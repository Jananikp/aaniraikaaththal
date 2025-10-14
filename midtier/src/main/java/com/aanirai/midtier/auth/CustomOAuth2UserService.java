package com.aanirai.midtier.auth;

import com.aanirai.midtier.user.OAuthUser;
import com.aanirai.midtier.user.OAuthUserRepository;
import java.time.Instant;
import java.util.Map;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final OAuthUserRepository oAuthUserRepository;

    public CustomOAuth2UserService(OAuthUserRepository oAuthUserRepository) {
        this.oAuthUserRepository = oAuthUserRepository;
    }

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        String provider = userRequest.getClientRegistration().getRegistrationId();
        Map<String, Object> attributes = oAuth2User.getAttributes();

        // For Google, subject identifier is in "sub"
        String providerUserId = String.valueOf(attributes.get("sub"));
        String email = attributes.get("email") != null ? String.valueOf(attributes.get("email")) : null;
        String name = attributes.get("name") != null ? String.valueOf(attributes.get("name")) : null;
        String picture = attributes.get("picture") != null ? String.valueOf(attributes.get("picture")) : null;

        OAuthUser entity = oAuthUserRepository.findByProviderUserId(providerUserId)
            .orElseGet(OAuthUser::new);

        boolean isNew = entity.getId() == null;
        if (isNew) {
            entity.setProvider(provider);
            entity.setProviderUserId(providerUserId);
            entity.setCreatedAt(Instant.now());
            entity.setLoginCount(0L);
        }

        entity.setEmail(email);
        entity.setDisplayName(name);
        entity.setPictureUrl(picture);
        entity.setLastLoginAt(Instant.now());
        entity.setLoginCount(entity.getLoginCount() == null ? 1L : entity.getLoginCount() + 1);

        oAuthUserRepository.save(entity);

        return oAuth2User;
    }
}



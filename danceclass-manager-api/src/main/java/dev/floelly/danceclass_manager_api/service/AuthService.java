package dev.floelly.danceclass_manager_api.service;

import dev.floelly.danceclass_manager_api.model.User;
import dev.floelly.danceclass_manager_api.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public Optional<User> authenticate(String email, String password) {
        log.debug("Attempting authentication for user: {}", email);

        Optional<User> user = userRepository.findByEmailAndIsActiveTrue(email);

        if (user.isPresent() && passwordEncoder.matches(password, user.get().getPasswordHash())) {
            log.info("User authenticated successfully: {}", email);
            return user;
        }

        log.warn("Authentication failed for user: {}", email);
        return Optional.empty();
    }

    public User getUserById(String userId) {
        return userRepository.findById(userId).orElseThrow(() ->
                new IllegalArgumentException("User not found: " + userId));
    }
}


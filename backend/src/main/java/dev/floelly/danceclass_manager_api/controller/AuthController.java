package dev.floelly.danceclass_manager_api.controller;

import dev.floelly.danceclass_manager_api.dto.LoginRequest;
import dev.floelly.danceclass_manager_api.dto.UserResponse;
import dev.floelly.danceclass_manager_api.model.User;
import dev.floelly.danceclass_manager_api.service.AuthService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request, HttpSession session) {
        log.info("Login attempt for email: {}", request.getEmail());

        if (request.getEmail() == null || request.getEmail().isBlank() ||
                request.getPassword() == null || request.getPassword().isBlank()) {
            return ResponseEntity.badRequest().body("Email and password required");
        }

        Optional<User> user = authService.authenticate(request.getEmail(), request.getPassword());

        if (user.isPresent()) {
            User authenticatedUser = user.get();

            // Create authentication token
            UsernamePasswordAuthenticationToken authToken =
                    new UsernamePasswordAuthenticationToken(
                            authenticatedUser.getId(),
                            authenticatedUser.getPasswordHash(),
                            new ArrayList<>()
                    );

            // Set in SecurityContext
            SecurityContextHolder.getContext().setAuthentication(authToken);

            // Store in session (for session persistence)
            session.setAttribute("userId", authenticatedUser.getId());
            session.setAttribute("userRole", authenticatedUser.getRole().name());
            session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());

            log.info("User logged in successfully: {}", request.getEmail());
            return ResponseEntity.ok(new UserResponse(authenticatedUser));
        }

        log.warn("Login failed for email: {}", request.getEmail());
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpSession session) {
        SecurityContextHolder.clearContext();
        session.invalidate();
        log.info("User logged out");
        return ResponseEntity.ok("Logged out successfully");
    }

    @GetMapping("/user")
    public ResponseEntity<?> getCurrentUser(Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Not authenticated");
        }

        return ResponseEntity.ok("User authenticated: " + principal.getName());
    }
}

-- Fix: Update user passwords to match NoOpPasswordEncoder

UPDATE users SET password_hash = 'password123' WHERE 1;
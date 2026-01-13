-- Test Data for MVP
INSERT INTO institutions (id, name, address, email) VALUES
    ('550e8400-e29b-41d4-a716-446655440001', 'Tanzschule München', 'Marienplatz 1, 80331 München', 'info@tanzschule-muenchen.de');

INSERT INTO users (id, email, password_hash, first_name, last_name, role, institution_id) VALUES
    ('550e8400-e29b-41d4-a716-446655440010', 'admin@dance.local', 'password123', 'Admin', 'User', 'ADMIN', NULL),
    ('550e8400-e29b-41d4-a716-446655440011', 'lehrer@tanzschule-muenchen.de', 'password123', 'Anna', 'Schmidt', 'TEACHER', '550e8400-e29b-41d4-a716-446655440001'),
    ('550e8400-e29b-41d4-a716-446655440012', 'schueler1@example.com', 'password123', 'Max', 'Mueller', 'STUDENT', '550e8400-e29b-41d4-a716-446655440001'),
    ('550e8400-e29b-41d4-a716-446655440013', 'schueler2@example.com', 'password123', 'Lisa', 'Bauer', 'STUDENT', '550e8400-e29b-41d4-a716-446655440001');

INSERT INTO courses (id, institution_id, name, teacher_id, day_of_week, start_time, end_time, max_students) VALUES
    ('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440001', 'Anfänger - Standard', '550e8400-e29b-41d4-a716-446655440011', 1, '19:00:00', '20:30:00', 15),
    ('550e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440001', 'Fortgeschrittene - Latin', '550e8400-e29b-41d4-a716-446655440011', 3, '20:00:00', '21:30:00', 12);

INSERT INTO course_enrollments (id, course_id, student_id, status) VALUES
    ('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440012', 'ACTIVE'),
    ('550e8400-e29b-41d4-a716-446655440031', '550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440013', 'ACTIVE');
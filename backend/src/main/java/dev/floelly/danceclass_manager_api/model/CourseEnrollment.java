package dev.floelly.danceclass_manager_api.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "course_enrollments", indexes = {
        @Index(name = "idx_course_id", columnList = "course_id"),
        @Index(name = "idx_student_id", columnList = "student_id")
}, uniqueConstraints = {
        @UniqueConstraint(name = "unique_enrollment", columnNames = {"course_id", "student_id"})
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CourseEnrollment {

    @Id
    private String id = UUID.randomUUID().toString();

    @ManyToOne
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EnrollmentStatus status = EnrollmentStatus.ACTIVE;

    @Column(nullable = false, updatable = false)
    private LocalDateTime enrolledDate = LocalDateTime.now();

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    public enum EnrollmentStatus {
        ACTIVE, INACTIVE, WAITLIST
    }
}

package dev.floelly.danceclass_manager_api.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "attendance", indexes = {
        @Index(name = "idx_course_id", columnList = "course_id"),
        @Index(name = "idx_student_id", columnList = "student_id"),
        @Index(name = "idx_session_date", columnList = "session_date")
}, uniqueConstraints = {
        @UniqueConstraint(name = "unique_attendance", columnNames = {"course_id", "student_id", "session_date"})
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Attendance {

    @Id
    private String id = UUID.randomUUID().toString();

    @ManyToOne
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    @Column(nullable = false)
    private LocalDate sessionDate;

    @Column(nullable = false)
    private Boolean present = false;

    private String notes;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();
}

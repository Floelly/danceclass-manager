package dev.floelly.danceclass_manager_api.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "courses", indexes = {
        @Index(name = "idx_institution_id", columnList = "institution_id"),
        @Index(name = "idx_teacher_id", columnList = "teacher_id")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Course {

    @Id
    private String id = UUID.randomUUID().toString();

    @ManyToOne
    @JoinColumn(name = "institution_id", nullable = false)
    private Institution institution;

    @Column(nullable = false)
    private String name;

    @ManyToOne
    @JoinColumn(name = "teacher_id", nullable = false)
    private User teacher;

    @Column(nullable = false)
    private Integer dayOfWeek; // 0=Monday, 6=Sunday

    @Column(nullable = false)
    private LocalTime startTime;

    @Column(nullable = false)
    private LocalTime endTime;

    @Column(nullable = false)
    private Integer maxStudents = 20;

    @Column(nullable = false)
    private Boolean isActive = true;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();
}

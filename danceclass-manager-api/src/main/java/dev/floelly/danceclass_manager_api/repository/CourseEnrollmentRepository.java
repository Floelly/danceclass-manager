package dev.floelly.danceclass_manager_api.repository;

import dev.floelly.danceclass_manager_api.model.CourseEnrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CourseEnrollmentRepository extends JpaRepository<CourseEnrollment, String> {
    List<CourseEnrollment> findByStudentIdAndStatusOrderByCreatedAtDesc(String studentId, CourseEnrollment.EnrollmentStatus status);
    List<CourseEnrollment> findByCourseIdAndStatus(String courseId, CourseEnrollment.EnrollmentStatus status);
    Optional<CourseEnrollment> findByCourseIdAndStudentId(String courseId, String studentId);
    Integer countByCourseIdAndStatus(String courseId, CourseEnrollment.EnrollmentStatus status);
}

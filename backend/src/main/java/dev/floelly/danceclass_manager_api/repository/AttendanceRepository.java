package dev.floelly.danceclass_manager_api.repository;

import dev.floelly.danceclass_manager_api.model.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, String> {
    List<Attendance> findByCourseIdAndSessionDate(String courseId, LocalDate sessionDate);
    List<Attendance> findByStudentIdAndCourseId(String studentId, String courseId);
    Optional<Attendance> findByCourseIdAndStudentIdAndSessionDate(String courseId, String studentId, LocalDate sessionDate);
}

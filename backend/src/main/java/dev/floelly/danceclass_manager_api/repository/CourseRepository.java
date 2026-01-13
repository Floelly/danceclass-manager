package dev.floelly.danceclass_manager_api.repository;

import dev.floelly.danceclass_manager_api.model.Course;
import dev.floelly.danceclass_manager_api.model.Institution;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, String> {
    List<Course> findByInstitutionAndIsActiveTrue(Institution institution);
    List<Course> findByTeacherIdAndIsActiveTrue(String teacherId);
}

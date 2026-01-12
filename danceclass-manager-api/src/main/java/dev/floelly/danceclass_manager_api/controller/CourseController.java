package dev.floelly.danceclass_manager_api.controller;

import dev.floelly.danceclass_manager_api.dto.CourseResponse;
import dev.floelly.danceclass_manager_api.model.Course;
import dev.floelly.danceclass_manager_api.model.CourseEnrollment;
import dev.floelly.danceclass_manager_api.model.User;
import dev.floelly.danceclass_manager_api.repository.CourseEnrollmentRepository;
import dev.floelly.danceclass_manager_api.repository.CourseRepository;
import dev.floelly.danceclass_manager_api.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/courses")
@RequiredArgsConstructor
@Slf4j
public class CourseController {

    private final CourseRepository courseRepository;
    private final CourseEnrollmentRepository enrollmentRepository;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<?> getCourses(Principal principal) {
        String userId = principal.getName();
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        List<CourseResponse> courses;

        if (user.getRole() == User.UserRole.TEACHER) {
            // Teachers see their courses
            courses = courseRepository.findByTeacherIdAndIsActiveTrue(userId).stream()
                    .map(course -> {
                        Integer enrolled = enrollmentRepository.countByCourseIdAndStatus(
                                course.getId(), CourseEnrollment.EnrollmentStatus.ACTIVE);
                        return new CourseResponse(course, enrolled);
                    })
                    .collect(Collectors.toList());
        } else if (user.getRole() == User.UserRole.STUDENT) {
            // Students see their enrolled courses
            List<String> enrolledCourseIds = enrollmentRepository
                    .findByStudentIdAndStatusOrderByCreatedAtDesc(userId, CourseEnrollment.EnrollmentStatus.ACTIVE)
                    .stream()
                    .map(e -> e.getCourse().getId())
                    .collect(Collectors.toList());

            courses = courseRepository.findAll().stream()
                    .filter(c -> enrolledCourseIds.contains(c.getId()))
                    .map(course -> {
                        Integer enrolled = enrollmentRepository.countByCourseIdAndStatus(
                                course.getId(), CourseEnrollment.EnrollmentStatus.ACTIVE);
                        return new CourseResponse(course, enrolled);
                    })
                    .collect(Collectors.toList());
        } else {
            courses = List.of();
        }

        return ResponseEntity.ok(courses);
    }

    @GetMapping("/{courseId}")
    public ResponseEntity<?> getCourse(@PathVariable String courseId, Principal principal) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new IllegalArgumentException("Course not found"));

        Integer enrolled = enrollmentRepository.countByCourseIdAndStatus(
                courseId, CourseEnrollment.EnrollmentStatus.ACTIVE);

        return ResponseEntity.ok(new CourseResponse(course, enrolled));
    }
}

package dev.floelly.danceclass_manager_api.controller;

import dev.floelly.danceclass_manager_api.dto.AttendanceRecord;
import dev.floelly.danceclass_manager_api.model.Attendance;
import dev.floelly.danceclass_manager_api.model.Course;
import dev.floelly.danceclass_manager_api.model.User;
import dev.floelly.danceclass_manager_api.repository.AttendanceRepository;
import dev.floelly.danceclass_manager_api.repository.CourseRepository;
import dev.floelly.danceclass_manager_api.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/attendance")
@RequiredArgsConstructor
@Slf4j
public class AttendanceController {

    private final AttendanceRepository attendanceRepository;
    private final CourseRepository courseRepository;
    private final UserRepository userRepository;

    @GetMapping("/{courseId}")
    public ResponseEntity<?> getAttendance(
            @PathVariable String courseId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate sessionDate,
            Principal principal) {

        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new IllegalArgumentException("Course not found"));

        User user = userRepository.findById(principal.getName()).orElseThrow();

        // Only teachers can view attendance for their courses
        if (user.getRole() != User.UserRole.TEACHER || !course.getTeacher().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access denied");
        }

        List<Attendance> records = attendanceRepository.findByCourseIdAndSessionDate(courseId, sessionDate);
        return ResponseEntity.ok(records);
    }

    @PostMapping
    public ResponseEntity<?> recordAttendance(
            @RequestBody AttendanceRecord request,
            Principal principal) {

        User user = userRepository.findById(principal.getName()).orElseThrow();
        Course course = courseRepository.findById(request.getCourseId()).orElseThrow();

        // Only teachers can record attendance
        if (user.getRole() != User.UserRole.TEACHER || !course.getTeacher().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access denied");
        }

        User student = userRepository.findById(request.getStudentId()).orElseThrow();

        Attendance attendance = new Attendance();
        attendance.setCourse(course);
        attendance.setStudent(student);
        attendance.setSessionDate(request.getSessionDate());
        attendance.setPresent(request.getPresent());
        attendance.setNotes(request.getNotes());

        Attendance saved = attendanceRepository.save(attendance);
        log.info("Attendance recorded for student {} in course {}", request.getStudentId(), request.getCourseId());

        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
}

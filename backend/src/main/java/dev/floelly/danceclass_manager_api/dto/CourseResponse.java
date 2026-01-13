package dev.floelly.danceclass_manager_api.dto;

import dev.floelly.danceclass_manager_api.model.Course;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CourseResponse {
    private String id;
    private String name;
    private String teacherName;
    private Integer dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;
    private Integer maxStudents;
    private Integer enrolledStudents;

    public CourseResponse(Course course, Integer enrolled) {
        this.id = course.getId();
        this.name = course.getName();
        this.teacherName = course.getTeacher().getFirstName() + " " + course.getTeacher().getLastName();
        this.dayOfWeek = course.getDayOfWeek();
        this.startTime = course.getStartTime();
        this.endTime = course.getEndTime();
        this.maxStudents = course.getMaxStudents();
        this.enrolledStudents = enrolled;
    }
}

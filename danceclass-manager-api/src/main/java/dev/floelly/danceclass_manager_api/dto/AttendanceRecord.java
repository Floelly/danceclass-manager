package dev.floelly.danceclass_manager_api.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AttendanceRecord {
    private String courseId;
    private String studentId;
    private LocalDate sessionDate;
    private Boolean present;
    private String notes;
}

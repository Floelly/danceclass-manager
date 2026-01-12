const teacher = {
    currentCourseId: null,
    attendanceModal: null,
    attendanceData: {}, // Stores attendance records: { studentId: { present, notes } }

    async init() {
        // Verify teacher role
        auth.requireRole('TEACHER');
        
        // Set user name
        document.getElementById('userFullName').textContent = auth.getUserFullName();
        
        // Setup event listeners
        this.setupEventListeners();
        
        // Load courses
        await this.loadCourses();
        
        // Initialize modal
        this.attendanceModal = new bootstrap.Modal(document.getElementById('attendanceModal'));
    },

    setupEventListeners() {
        document.getElementById('logoutBtn').addEventListener('click', () => auth.logout());
    },

    async loadCourses() {
        const container = document.getElementById('coursesContainer');
        
        try {
            const response = await apiClient.getCourses();
            const courses = await apiClient.handleResponse(response, 'Fehler beim Laden der Kurse');
            
            if (!courses || courses.length === 0) {
                container.innerHTML = '<div class="col-12"><div class="alert alert-info">Keine Kurse gefunden</div></div>';
                return;
            }

            container.innerHTML = courses.map(course => `
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card h-100 shadow-sm border-0 course-card">
                        <div class="card-body">
                            <h5 class="card-title fw-bold">${this.escapeHtml(course.name)}</h5>
                            <p class="card-text text-muted mb-3">
                                <small>
                                    🕐 ${course.startTime} - ${course.endTime}<br>
                                    👥 ${course.enrolledStudents}/${course.maxStudents} Schüler
                                </small>
                            </p>
                        </div>
                        <div class="card-footer bg-transparent border-top">
                            <button 
                                class="btn btn-primary btn-sm w-100"
                                onclick="teacher.openAttendanceModal('${course.id}', '${this.escapeHtml(course.name)}')"
                            >
                                ✅ Anwesenheit dokumentieren
                            </button>
                        </div>
                    </div>
                </div>
            `).join('');
        } catch (error) {
            console.error('Error loading courses:', error);
            container.innerHTML = `<div class="col-12"><div class="alert alert-danger">Fehler: ${error.message}</div></div>`;
        }
    },

    async openAttendanceModal(courseId, courseName) {
        this.currentCourseId = courseId;
        document.querySelector('#attendanceModal .modal-title').textContent = `Anwesenheit - ${courseName}`;
        
        // Set today's date by default
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('sessionDate').value = today;
        
        await this.loadStudentsForCourse(courseId);
        this.attendanceModal.show();
    },

    async loadStudentsForCourse(courseId) {
        const studentsList = document.getElementById('studentsList');
        
        try {
            const response = await apiClient.getCourse(courseId);
            const course = await apiClient.handleResponse(response);
            
            // In real scenario, we'd fetch enrolled students
            // For MVP, we'll use mock data from the course
            const mockStudents = [
                { id: '550e8400-e29b-41d4-a716-446655440012', name: 'Max Mueller' },
                { id: '550e8400-e29b-41d4-a716-446655440013', name: 'Lisa Bauer' },
            ];

            this.attendanceData = {};
            
            studentsList.innerHTML = mockStudents.map(student => `
                <div class="list-group-item d-flex align-items-center justify-content-between p-3">
                    <div>
                        <input 
                            type="checkbox" 
                            class="form-check-input me-3 attendance-checkbox"
                            data-student-id="${student.id}"
                            id="student_${student.id}"
                        >
                        <label class="form-check-label" for="student_${student.id}">
                            ${this.escapeHtml(student.name)}
                        </label>
                    </div>
                    <input 
                        type="text" 
                        class="form-control form-control-sm w-25 attendance-notes"
                        data-student-id="${student.id}"
                        placeholder="Notizen (optional)"
                    >
                </div>
            `).join('');

            // Add event listeners
            document.querySelectorAll('.attendance-checkbox').forEach(checkbox => {
                checkbox.addEventListener('change', (e) => {
                    const studentId = e.target.dataset.studentId;
                    this.attendanceData[studentId] = {
                        present: e.target.checked,
                        notes: document.querySelector(`.attendance-notes[data-student-id="${studentId}"]`).value,
                    };
                });
            });
        } catch (error) {
            console.error('Error loading students:', error);
            document.getElementById('studentsList').innerHTML = `<div class="alert alert-danger">Fehler: ${error.message}</div>`;
        }
    },

    async saveAttendance() {
        const sessionDate = new Date(document.getElementById('sessionDate').value);
        const saveBtn = document.getElementById('saveAttendanceBtn');
        saveBtn.disabled = true;

        try {
            const promises = Object.entries(this.attendanceData).map(([studentId, data]) => {
                return apiClient.recordAttendance(
                    this.currentCourseId,
                    studentId,
                    sessionDate,
                    data.present,
                    data.notes
                );
            });

            await Promise.all(promises);
            
            alert('✅ Anwesenheit erfolgreich gespeichert!');
            this.attendanceModal.hide();
            await this.loadCourses();
        } catch (error) {
            console.error('Error saving attendance:', error);
            alert('❌ Fehler beim Speichern: ' + error.message);
        } finally {
            saveBtn.disabled = false;
        }
    },

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    },
};

// Save attendance button
document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('saveAttendanceBtn').addEventListener('click', () => teacher.saveAttendance());
    teacher.init();
});

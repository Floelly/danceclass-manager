const student = {
    async init() {
        // Verify student role
        auth.requireRole('STUDENT');
        
        // Set user name
        document.getElementById('userFullName').textContent = auth.getUserFullName();
        
        // Setup event listeners
        this.setupEventListeners();
        
        // Load courses
        await this.loadEnrolledCourses();
    },

    setupEventListeners() {
        document.getElementById('logoutBtn').addEventListener('click', () => auth.logout());
    },

    async loadEnrolledCourses() {
        const container = document.getElementById('enrolledCoursesContainer');
        
        try {
            const response = await apiClient.getCourses();
            const courses = await apiClient.handleResponse(response, 'Fehler beim Laden der Kurse');
            
            if (!courses || courses.length === 0) {
                container.innerHTML = '<div class="col-12"><div class="alert alert-warning">Du bist noch in keinen Kursen angemeldet. Kontaktiere deine Tanzschule!</div></div>';
                return;
            }

            container.innerHTML = courses.map(course => `
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body">
                            <h5 class="card-title fw-bold text-info">${this.escapeHtml(course.name)}</h5>
                            <p class="card-text text-muted mb-2">
                                <strong>Lehrer:</strong> ${this.escapeHtml(course.teacherName)}<br>
                                <strong>Zeit:</strong> ${course.startTime} - ${course.endTime}
                            </p>
                            <div class="progress mb-3" style="height: 20px;">
                                <div 
                                    class="progress-bar" 
                                    role="progressbar" 
                                    style="width: ${(course.enrolledStudents / course.maxStudents) * 100}%"
                                >
                                    ${course.enrolledStudents}/${course.maxStudents}
                                </div>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent border-top">
                            <small class="text-muted d-block mb-2">Kurs-ID: ${course.id}</small>
                        </div>
                    </div>
                </div>
            `).join('');
        } catch (error) {
            console.error('Error loading courses:', error);
            container.innerHTML = `<div class="col-12"><div class="alert alert-danger">Fehler: ${error.message}</div></div>`;
        }
    },

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    },
};

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    student.init();
});

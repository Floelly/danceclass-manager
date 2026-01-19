const apiClient = {
    // Während Development: http://localhost:8080/api
    // Während Production: /api (proxy)
    BASE_URL: window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
        ? 'http://localhost:8080/api'
        : 'https://dance-class-manager-eu-backend-service-519149468224.europe-west3.run.app/api',

    // Helper: Fetch with credentials
    async fetchWithAuth(endpoint, options = {}) {
        const url = `${this.BASE_URL}${endpoint}`;
        
        const defaultOptions = {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
            credentials: 'include', // Include cookies for session
        };

        const mergedOptions = { ...defaultOptions, ...options };

        try {
            const response = await fetch(url, mergedOptions);
            return response;
        } catch (error) {
            console.error(`API Error on ${endpoint}:`, error);
            throw error;
        }
    },

    // Auth Endpoints
    async login(email, password) {
        return this.fetchWithAuth('/auth/login', {
            method: 'POST',
            body: JSON.stringify({ email, password }),
        });
    },

    async logout() {
        return this.fetchWithAuth('/auth/logout', {
            method: 'POST',
        });
    },

    async getCurrentUser() {
        return this.fetchWithAuth('/auth/user');
    },

    // Course Endpoints
    async getCourses() {
        return this.fetchWithAuth('/courses');
    },

    async getCourse(courseId) {
        return this.fetchWithAuth(`/courses/${courseId}`);
    },

    // Attendance Endpoints
    async getAttendance(courseId, sessionDate) {
        const dateStr = sessionDate.toISOString().split('T')[0];
        return this.fetchWithAuth(`/attendance/${courseId}?sessionDate=${dateStr}`);
    },

    async recordAttendance(courseId, studentId, sessionDate, present, notes = '') {
        return this.fetchWithAuth('/attendance', {
            method: 'POST',
            body: JSON.stringify({
                courseId,
                studentId,
                sessionDate: sessionDate.toISOString().split('T')[0],
                present,
                notes,
            }),
        });
    },

    // Error Handler
    async handleResponse(response, errorMessage = 'Ein Fehler ist aufgetreten') {
        if (!response.ok) {
            const error = await response.text();
            throw new Error(error || errorMessage);
        }
        
        try {
            return await response.json();
        } catch {
            return null;
        }
    },
};

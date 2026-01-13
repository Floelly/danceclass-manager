// js/auth.js
const auth = {
    // Get current user from sessionStorage
    getCurrentUser() {
        const userJson = sessionStorage.getItem('currentUser');
        return userJson ? JSON.parse(userJson) : null;
    },

    // Check if user is authenticated
    isAuthenticated() {
        return this.getCurrentUser() !== null;
    },

    // Check if user has specific role
    hasRole(role) {
        const user = this.getCurrentUser();
        return user && user.role === role;
    },

    // Get user full name
    getUserFullName() {
        const user = this.getCurrentUser();
        return user ? `${user.firstName} ${user.lastName}` : 'Unknown';
    },

    // Get user email
    getUserEmail() {
        const user = this.getCurrentUser();
        return user ? user.email : '';
    },

    // Logout
    async logout() {
        try {
            await apiClient.logout();
        } catch (error) {
            console.error('Logout error:', error);
        } finally {
            sessionStorage.removeItem('currentUser');
            window.location.href = 'index.html';
        }
    },

    // Verify authentication and redirect to login if needed
    requireAuthentication() {
        if (!this.isAuthenticated()) {
            window.location.href = 'index.html';
        }
    },

    // Verify role and redirect if needed
    requireRole(role) {
        if (!this.hasRole(role)) {
            alert('Du hast keine Berechtigung für diese Seite!');
            window.location.href = 'index.html';
        }
    },
};

// ONLY check on page load if we're on index.html
// Dashboard pages call requireAuthentication() explicitly
if (window.location.pathname.includes('dashboard')) {
    auth.requireAuthentication();
}
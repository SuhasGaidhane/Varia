import { Component } from '@angular/core';

@Component({
  selector: 'app-home',
  standalone: false,
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {
  selectedSection = 'dashboard';
  isSidebarCollapsed = false;
  showUserMenu = false;
  loggedInUser = 'Admin'; // Replace with actual user data

  selectSection(section: string) {
    this.selectedSection = section;
  }

  toggleSidebar() {
    this.isSidebarCollapsed = !this.isSidebarCollapsed;
  }

  // userManagement() {
  //   console.log('Open profile');
  // }

  showPasswordDialog = false;
  showLogoutDialog = false;

  // Password change form fields
  currentPassword = '';
  newPassword = '';
  confirmPassword = '';

  /**
   * Opens the password change dialog
   */
  openPasswordDialog(): void {
    this.showPasswordDialog = true;
    // Reset form fields when opening dialog
    this.currentPassword = '';
    this.newPassword = '';
    this.confirmPassword = '';
  }

  /**
   * Closes the password change dialog
   */
  closePasswordDialog(): void {
    this.showPasswordDialog = false;
  }

  /**
   * Opens the logout confirmation dialog
   */
  openLogoutDialog(): void {
    this.showLogoutDialog = true;
  }

  /**
   * Closes the logout confirmation dialog
   */
  closeLogoutDialog(): void {
    this.showLogoutDialog = false;
  }

  /**
   * Handles the password change functionality
   */
  changePassword(): void {
    console.log('Change password');

    // Add validation
    if (!this.currentPassword || !this.newPassword || !this.confirmPassword) {
      alert('Please fill in all password fields');
      return;
    }

    if (this.newPassword !== this.confirmPassword) {
      alert('New password and confirm password do not match');
      return;
    }

    // Here you would typically call a service to update the password

    // Close the dialog after successful password change
    this.closePasswordDialog();

    // Show success message
    alert('Password changed successfully');
  }

  /**
   * Handles the logout functionality
   */
  logout(): void {
    console.log('Logout');

    // Here you would typically call an authentication service to handle logout
    // For example: this.authService.logout();

    // Close the dialog
    this.closeLogoutDialog();

    // Redirect to login page or perform other logout actions
    // For example: this.router.navigate(['/login']);
  }
}



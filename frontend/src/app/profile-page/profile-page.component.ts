import {Component} from '@angular/core';
import {FireService} from "../fire.service";
import {MatSnackBar} from "@angular/material/snack-bar";

@Component({
  selector: 'app-profile-page',
  templateUrl: './profile-page.component.html',
  styleUrls: ['./profile-page.component.scss']
})
export class ProfilePageComponent {

  constructor(public fireService: FireService, private snackBar: MatSnackBar) {
  }

  async editProfile() {
    const id = this.fireService.user.uid;
    let dto = {
      email: this.fireService.user.email,
      firstname: this.fireService.user.firstname,
      lastname: this.fireService.user.lastname,
    };

    try {
      await this.fireService.editUser(id, dto);
      this.snackBar.open('User profile updated successfully', 'Close', {
        duration: 3000,
      });
    } catch (error) {
      this.snackBar.open('User profile update failed', 'Close', {
        duration: 3000,
      })
      console.error('Error editing user:', error);
    }
  }
}

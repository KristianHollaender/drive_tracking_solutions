import {Component} from '@angular/core';
import {FireService} from "../fire.service";
import {Router} from "@angular/router";
import {MatSnackBar} from "@angular/material/snack-bar";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})

export class LoginComponent {
  email!: string;
  password!: string;

  constructor(public fireService: FireService, private router: Router, private snackBar: MatSnackBar) {
  }

  async signIn(email: string, password: string) {
    await this.fireService
      .signIn(email, password).then(async () => {
        if (this.fireService.user.role == "Admin") {
          // @ts-ignore
          localStorage.setItem('token', await this.fireService.auth.currentUser?.getIdToken());
          // @ts-ignore
          localStorage.setItem('uid', await this.fireService.auth.currentUser?.uid)
          await this.router.navigate(['admin/users']);

          this.snackBar.open('SUCCESSFUL LOGIN', 'Close', {duration: 3000})
        } else {
          this.snackBar.open('You are not an admin!!', 'Close', {duration: 3000})
        }
      })
      .catch((error) => {
        console.log(error);
      });
  };

  async forgotPassword(email: string) {
    if (email != null) {
      await this.fireService.forgotPassword(email).then(async () => {
        this.snackBar.open('An email has been sent to: ' + email, 'Close', {duration: 3000})
      }).catch(() => {
        this.snackBar.open('The email you entered doesn\'t exist', 'Close', {duration: 3000})
      });
    } else {
      this.snackBar.open('Please enter an email', 'Close', {duration: 3000})
    }

  }
}

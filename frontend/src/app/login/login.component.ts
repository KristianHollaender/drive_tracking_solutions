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
  isLoading: boolean = false;

  constructor(public fireService: FireService, private router: Router, private snackBar: MatSnackBar) {
  }

  async signIn(email: string, password: string) {
    this.isLoading = true;
    await this.fireService
      .signIn(email, password).then(async () => {
        if (this.fireService.user.role == "Admin") {
          this.isLoading = true;
          // @ts-ignore
          localStorage.setItem('token', await this.fireService.auth.currentUser?.getIdToken());
          // @ts-ignore
          localStorage.setItem('uid', await this.fireService.auth.currentUser?.uid)
          await this.router.navigate(['admin/users']);
          this.snackBar.open('Successful login', '', {duration: 3000})
          this.isLoading = false;
        } else {
          this.isLoading = false;
          this.snackBar.open('You are not an admin!!', '', {duration: 3000})
        }
      })
      .catch((error) => {
        this.isLoading = false;
        this.snackBar.open('Error: Email or password may be incorrect','', {duration: 3000})
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

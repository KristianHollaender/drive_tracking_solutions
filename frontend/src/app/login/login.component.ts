import {Component} from '@angular/core';
import {FireService} from "../fire.service";
import {Router} from "@angular/router";
import firebase from "firebase/compat";
import {MatSnackBar} from "@angular/material/snack-bar";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  email: string = "";
  password: string = "";

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
        } else {
          this.snackBar.open('You are not an admin!!', 'Close', {duration: 3000})
        }
      })
      .catch((error) => {
        console.log(error);
      });
  };
}

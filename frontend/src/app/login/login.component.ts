import {Component} from '@angular/core';
import {FireService} from "../fire.service";
import {Router} from "@angular/router";
import firebase from "firebase/compat";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  email: string = "";
  password: string = "";

  constructor(public fireService: FireService, private router: Router) {
  }

  async signIn(email: string, password: string) {
    await this.fireService
      .signIn(email, password)
      .then(async () => {
        await this.router.navigate(['admin/users']);
      })
      .catch((error) => {
        console.log(error);
      });
  };
}

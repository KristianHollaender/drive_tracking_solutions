import { Component } from '@angular/core';
import {FireService} from "../fire.service";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  email: string = "";
  password: string = "";

  constructor(public fireService: FireService) { }

}

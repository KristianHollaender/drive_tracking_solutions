import {Component, OnInit} from '@angular/core';
import {FireService} from "../fire.service";

@Component({
  selector: 'app-profile-page',
  templateUrl: './profile-page.component.html',
  styleUrls: ['./profile-page.component.scss']
})
export class ProfilePageComponent implements OnInit{

  email: string = "";
  firstName: string = "";
  lastName: string = "";

  constructor(private fireService: FireService) {
  }

  async ngOnInit() {
    const user = this.fireService.auth.currentUser;
  }

}

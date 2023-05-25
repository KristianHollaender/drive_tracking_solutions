import {Component, OnInit, ViewChild} from '@angular/core';
import {Router} from "@angular/router";
import {MatSidenav} from "@angular/material/sidenav";
import {FireService} from "../fire.service";

@Component({
  selector: 'app-navigation',
  templateUrl: './admin-navigation.component.html',
  styleUrls: ['./admin-navigation.component.scss']
})
export class AdminNavigationComponent implements OnInit {
  @ViewChild(MatSidenav)
  sidenav!: MatSidenav;
  firstname: any;
  lastname: any;

  constructor(private router: Router, public fireService: FireService) {
  }

  async ngOnInit() {
    // Getting UID from localStorage, so we can keep refreshing without losing the user
    let t = localStorage.getItem('uid');
    // @ts-ignore
    let user = await this.fireService.getUserById(t);
    this.firstname = user.firstname;
    this.lastname = user.lastname;
  }

  /**
   * Async method for logging out
   */
  async logOut() {
    await this.fireService.signOut().then(() => {
      this.router.navigate(['']);
      // Clear localStorage so the token and UID doesn't stick
      localStorage.clear();
    })
      .catch((error) => {
        console.log(error);
      });
  }
}

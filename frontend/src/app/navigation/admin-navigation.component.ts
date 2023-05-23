import {Component, OnInit, ViewChild} from '@angular/core';
import {Router} from "@angular/router";
import {MatSidenav} from "@angular/material/sidenav";
import {BreakpointObserver} from "@angular/cdk/layout";
import {FireService} from "../fire.service";

@Component({
  selector: 'app-navigation',
  templateUrl: './admin-navigation.component.html',
  styleUrls: ['./admin-navigation.component.scss']
})
export class AdminNavigationComponent {
  @ViewChild(MatSidenav)
  sidenav!: MatSidenav;
  firstname: any;
  lastname: any;

  constructor(private router: Router, private observer: BreakpointObserver, public fireService: FireService) {
    this.firstname = this.fireService.user.firstname;
    this.lastname = this.fireService.user.lastname;
  }

  /**
   * Method for logging out, removing token from localstorage and reroutes to loginPage again.
   */
  async logOut() {
    await this.fireService.signOut().then(() => {
      this.router.navigate(['']);
    })
      .catch((error) => {
        console.log(error);
      });
  }

}

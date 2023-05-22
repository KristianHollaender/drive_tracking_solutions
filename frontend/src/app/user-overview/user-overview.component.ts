import {Component, OnInit} from '@angular/core';
import {FireService} from "../fire.service";
import {Router} from "@angular/router";
import {MatTableDataSource} from "@angular/material/table";
import {User} from "../models/User";

@Component({
  selector: 'app-user-overview',
  templateUrl: './user-overview.component.html',
  styleUrls: ['./user-overview.component.scss']
})

export class UserOverviewComponent implements OnInit{
  displayedColumns: string[] = ['id', 'email', 'firstname', 'lastname'];
  dataSource = new MatTableDataSource<User>;


  constructor(public fireService: FireService, private router: Router) {
  }

  async ngOnInit() {
    try {
      const users = await this.fireService.getUsers();
      this.dataSource.data = users;
    } catch (error) {
      console.error('Error retrieving users:', error);
    }
  }
  async signOut(){
    await this.fireService.signOut().then(() => {
      this.router.navigate(['']);
    })
      .catch((error) => {
        console.log(error);
      });
  }

}

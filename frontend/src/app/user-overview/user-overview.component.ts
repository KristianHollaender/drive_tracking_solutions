import {Component, OnInit} from '@angular/core';
import {FireService} from "../fire.service";
import {Router} from "@angular/router";
import {MatTableDataSource} from "@angular/material/table";
import {User} from "../models/User";
import {CreateUserComponent} from "../create-user/create-user.component";
import {MatDialog} from "@angular/material/dialog";
import {EditUserComponent} from "../edit-user/edit-user.component";


@Component({
  selector: 'app-user-overview',
  templateUrl: './user-overview.component.html',
  styleUrls: ['./user-overview.component.scss']
})

export class UserOverviewComponent implements OnInit{
  displayedColumns: string[] = ['id', 'email', 'firstname', 'lastname', 'edit'];
  dataSource = new MatTableDataSource<User>;


  constructor(public fireService: FireService, private router: Router, private popup: MatDialog) {
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

  createUser() {
    this.popup.open(CreateUserComponent);
  }

  editUser(row: any) {
   this.popup.open(EditUserComponent, {
      data: {
        user: row
      }
    });
  }
}

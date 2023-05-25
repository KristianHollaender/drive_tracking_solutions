import {Component, OnInit, ViewChild} from '@angular/core';
import {FireService} from "../fire.service";
import {Router} from "@angular/router";
import {MatTableDataSource} from "@angular/material/table";
import {User} from "../models/User";
import {CreateUserComponent} from "../create-user/create-user.component";
import {MatDialog} from "@angular/material/dialog";
import {EditUserComponent} from "../edit-user/edit-user.component";
import {MatSnackBar} from "@angular/material/snack-bar";
import {MatPaginator} from "@angular/material/paginator";


@Component({
  selector: 'app-user-overview',
  templateUrl: './user-overview.component.html',
  styleUrls: ['./user-overview.component.scss']
})

export class UserOverviewComponent implements OnInit {
  displayedColumns: string[] = ['id', 'email', 'firstname', 'lastname', 'edit'];
  dataSource = new MatTableDataSource<User>;
  isLoading: boolean = true;


  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(public fireService: FireService,
              private router: Router,
              private popup: MatDialog,
              private _snackBar: MatSnackBar) {
  }

  async ngOnInit() {
    try {
      localStorage.getItem('token')
      // Makes the spinner load while getting users
      this.isLoading = true;
      this.dataSource.data = await this.fireService.getUsers();
      this.dataSource.paginator = this.paginator;
      // Makes the spinner stop loading when getting users is done
      this.isLoading = false;
    } catch (error) {
      console.error('Error retrieving users:', error);
      this.isLoading = false;
    }
  }

  /**
   * Method for creating user
   */
  createUser() {
    const dialogRef = this.popup.open(CreateUserComponent);
    dialogRef.afterClosed().subscribe(async () => {
      this.isLoading = true; // Show the loading spinner
      this.dataSource.data = await this.fireService.getUsers();
      this.dataSource.paginator = this.paginator;
      this.isLoading = false; // Hide the loading spinner
    });
  }

  /**
   * Method for editing user
   */
  editUser(row: any) {
    const dialogRef = this.popup.open(EditUserComponent, {
      data: {
        user: row
      }
    });

    dialogRef.afterClosed().subscribe(async () => {
      this.isLoading = true; // Show the loading spinner
      const users = await this.fireService.getUsers();
      this.dataSource = new MatTableDataSource(users);
      this.dataSource.paginator = this.paginator;
      this.isLoading = false; // Hide the loading spinner
    });
  }

  /**
   * Method for deleting user
   */
  async deleteUser(row: any) {
    if (confirm(`Do you want to delete ${row.firstname} ${row.lastname}?`)) {
      this.isLoading = true; // Show the loading spinner
      await this.fireService.deleteUser(row.uid);
      this.dataSource.data = this.dataSource.data.filter(u => u.uid !== row.uid);
      this.dataSource.paginator = this.paginator;
      this.isLoading = false; // Hide the loading spinner

      const snackBarMessage = `${row.firstname} ${row.lastname} deleted`;
      this._snackBar.open(snackBarMessage, 'Close', {duration: 3000});
    }
  }
}

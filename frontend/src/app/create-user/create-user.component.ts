import {Component, Inject, OnInit} from '@angular/core';
import {UserOverviewComponent} from "../user-overview/user-overview.component";
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {FormControl, FormGroup} from "@angular/forms";
import {FireService} from "../fire.service";


@Component({
  selector: 'app-create-user',
  templateUrl: './create-user.component.html',
  styleUrls: ['./create-user.component.scss']
})

export class CreateUserComponent implements OnInit {
  email: string = '';
  password: string = '';
  firstname: string = '';
  lastname: string = '';

  /**
   * FormGroup for Creating user
   */
  userForm = new FormGroup({
    firstNameForm: new FormControl(''),
    lastNameForm: new FormControl(''),
    emailForm: new FormControl(''),
    passwordForm: new FormControl(''),
  });

  async ngOnInit() {
    this.dialogRef.updateSize("370px", "552px");
  }

  constructor(private fireService: FireService,
              private dialogRef: MatDialogRef<UserOverviewComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) {
  }

  /**
   * Async method for creating a user
   */
  async createUser() {
    const user = this.userForm.value;
    let dto = {
      email: user.emailForm,
      firstname: user.firstNameForm,
      lastname: user.lastNameForm,
      password: user.passwordForm,
    }
    await this.fireService.createUser(dto);
    this.dialogRef.close();
  }
}

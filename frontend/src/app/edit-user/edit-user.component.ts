import {Component, Inject, OnInit} from '@angular/core';
import {FireService} from "../fire.service";
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {UserOverviewComponent} from "../user-overview/user-overview.component";
import {FormControl, FormGroup} from "@angular/forms";

@Component({
  selector: 'app-edit-user',
  templateUrl: './edit-user.component.html',
  styleUrls: ['./edit-user.component.scss']
})

export class EditUserComponent implements OnInit {
  editUser = new FormGroup({
    id: new FormControl(this.data.user.uid),
    email: new FormControl(this.data.user.email),
    firstname: new FormControl(this.data.user.firstname),
    lastname: new FormControl(this.data.user.lastname),
  })

  async ngOnInit() {
    this.dialogRef.updateSize("350px", "522px");
  }

  constructor(private fireService: FireService,
              private dialogRef: MatDialogRef<UserOverviewComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,) {
  }

  async save() {
    const user = this.editUser.value;
    const id = this.data.user.uid;
    let dto = {
      email: user.email,
      firstname: user.firstname,
      lastname: user.lastname,
    }
    await this.fireService.editUser(id, dto);

    this.dialogRef.close();
  }
}

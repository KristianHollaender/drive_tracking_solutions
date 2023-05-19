import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { LoginComponent } from './login/login.component';
import { UserOverviewComponent } from './user-overview/user-overview.component';
import { TourOverviewComponent } from './tour-overview/tour-overview.component';
import {FormsModule} from "@angular/forms";
import {MatFormFieldModule} from "@angular/material/form-field";
import {MatTableModule} from "@angular/material/table";
import {MatPaginatorModule} from "@angular/material/paginator";

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    UserOverviewComponent,
    TourOverviewComponent
  ],
    imports: [
        BrowserModule,
        AppRoutingModule,
        BrowserAnimationsModule,
        FormsModule,
        MatFormFieldModule,
        MatTableModule,
        MatPaginatorModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }

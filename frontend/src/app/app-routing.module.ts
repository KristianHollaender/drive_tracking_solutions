import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {LoginComponent} from "./login/login.component";
import {UserOverviewComponent} from "./user-overview/user-overview.component";
import {TourOverviewComponent} from "./tour-overview/tour-overview.component";

const routes: Routes = [
  {path: '', component: LoginComponent},
  {path: 'users', component: UserOverviewComponent},
  {path: 'tours', component: TourOverviewComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {LoginComponent} from "./login/login.component";
import {UserOverviewComponent} from "./user-overview/user-overview.component";
import {TourOverviewComponent} from "./tour-overview/tour-overview.component";
import {AdminNavigationComponent} from "./navigation/admin-navigation.component";
import {ProfilePageComponent} from "./profile-page/profile-page.component";

const routes: Routes = [
  {path: '', component: LoginComponent},
  {path: 'admin', component: AdminNavigationComponent, children:[
      {path: 'users', component: UserOverviewComponent},
      {path: 'tours', component: TourOverviewComponent},
      {path: 'profile-page', component: ProfilePageComponent},
    ]},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

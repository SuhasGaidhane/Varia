import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {WebsiteComponent} from './website/website.component';
import {HomeComponent} from './home/home.component';
import {ManageDistrictComponent} from './manage-district/manage-district.component';
import {ManageFirmComponent} from './manage-firm/manage-firm.component';
import {OffersSubscriptionComponent} from './offers-subscription/offers-subscription.component';

const routes: Routes = [
  {path: "", component: WebsiteComponent},
  {path: "home", component: HomeComponent},
  {path: "firm", component: ManageFirmComponent},
  {path: "district", component: ManageDistrictComponent},
  {path: "app-offers-subscription", component: OffersSubscriptionComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

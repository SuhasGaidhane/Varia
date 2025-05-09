import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private baseUrl = 'https://variaindia.com/VariaAPI';

  constructor(private http: HttpClient) {}

  // Example: GET method
  getOffers(): Observable<any> {
    return this.http.get(this.baseUrl + "/Offers/get-all-offers.php");
  }

  addOffer(formData: FormData): Observable<any> {
    return this.http.post(this.baseUrl + '/Offers/add-offer.php', formData);
  }

  updateOffer(formData: FormData): Observable<any> {
    return this.http.post(this.baseUrl +"/Offers/update-offer.php", formData);
  }

  deleteOffer(formData: FormData): Observable<any> {
    return this.http.post(this.baseUrl +`/Offers/delete-offer.php`, formData);
  }


  getSubscriptionPlan(): Observable<any> {
    return this.http.get(this.baseUrl + "/getAllSubscriptionPlan.php");
  }

  updateSubscription(formData: FormData): Observable<any> {
    return this.http.post(this.baseUrl +"/UpdateSubscriptionPlan.php", formData);
  }

  getDistrictsWithTalukas(): Observable<any> {
    return this.http.get(this.baseUrl + "/GetDistrictsWithTalukas.php");
  }

  updateDistrict(district: any) {
    return this.http.put<any>(this.baseUrl + '/update_district.php', {
      district_id: district.id,
      district_name: district.name,
      is_active: district.isActive
    });
  }

  updateTaluka(taluka: any, districtId: number) {
    return this.http.put<any>(this.baseUrl + '/update_taluka.php', {
      taluka_id: taluka.id,
      taluka_name: taluka.name,
      is_active: taluka.isActive,
      district_id: districtId
    });
  }


  // apiService.ts
  addDistrict(district: { name: string; isActive: boolean }) {
    return this.http.post<any>(this.baseUrl + '/add_district.php', {
      district_name: district.name,
      is_active: district.isActive ? 1 : 0
    });
  }

  addTaluka(taluka: { name: string; isActive: boolean }, districtId: number) {
    return this.http.post<any>(this.baseUrl + '/add_taluka.php', {
      taluka_name: taluka.name,
      district_id: districtId,
      is_active: taluka.isActive ? 1 : 0
    });
  }


  // Delete District API
  deleteDistrict(districtId: number): Observable<any> {
    return this.http.delete(this.baseUrl +`/delete_district.php`, {
      body: { district_id: districtId }
    });
  }

  // Delete Taluka API
  deleteTaluka(talukaId: number): Observable<any> {
    return this.http.delete(this.baseUrl +`/delete_taluka.php`, {
      body: { taluka_id: talukaId }
    });
  }



  getAllFirmList(): Observable<any> {
    return this.http.get(this.baseUrl + "/getAllFirmList.php");
  }

  addFirm(formData: FormData): Observable<any> {
    return this.http.post(this.baseUrl + "/add_firm.php", formData);
  }
  updateFirm(firmData: FormData) {
    return this.http.post<any>(this.baseUrl + "/update_firm.php", firmData);
  }

  deleteFirm(masterFirmId: string): Observable<any> {
    const formData = new FormData();
    formData.append('masterFirmId', masterFirmId);

    return this.http.post<any>(this.baseUrl + "/delete_firm.php", formData);
  }


  // Example: POST method
  postData(endpoint: string, data: any): Observable<any> {
    return this.http.post(this.baseUrl + endpoint, data);
  }

  // Example: PUT method
  putData(endpoint: string, data: any): Observable<any> {
    return this.http.put(this.baseUrl + endpoint, data);
  }

  // Example: DELETE method
  deleteData(endpoint: string): Observable<any> {
    return this.http.delete(this.baseUrl + endpoint);
  }
}

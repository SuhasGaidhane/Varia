import {Component, OnInit} from '@angular/core';
import {ApiService} from '../services/api.service';
import {MatDialog} from '@angular/material/dialog';
import {FormBuilder, Validators} from '@angular/forms';

interface Taluka {
  id: number;
  name: string;
  isActive: boolean;
}

interface District {
  id: number;
  name: string;
  isActive: boolean;
  talukas: Taluka[];
}

@Component({
  selector: 'app-manage-district',
  standalone: false,
  templateUrl: './manage-district.component.html',
  styleUrl: './manage-district.component.scss'
})
export class ManageDistrictComponent implements OnInit{



  constructor(
    private apiService: ApiService,
    private dialog: MatDialog,
    private fb: FormBuilder
  ) {}


  ngOnInit(): void {
    // console.log("suhas")
    this.getDistrictsWithTalukas()
  }


  districts: District[] = [];

  async getDistrictsWithTalukas() {
    try {
      const data = await this.apiService.getDistrictsWithTalukas().toPromise();
      if (data && Array.isArray(data)) {
        // Map API response to match your District and Taluka interfaces
        this.districts = data.map((item: any) => ({
          id: item.id,
          name: item.name,
          isActive: item.isActive,
          talukas: item.talukas.map((taluka: any) => ({
            id: taluka.id,
            name: taluka.name,
            isActive: taluka.isActive
          }))
        }));
      } else {
        this.districts = [];
      }
    } catch (error) {
      console.error('Error fetching district and Taluka:', error);
      this.districts = [];
    }
  }



  // districts: District[] = [
  //   {
  //     id: 1,
  //     name: 'Nagpur',
  //     isActive: true,
  //     talukas: [
  //       { id: 1, name: 'Nagpur Urban', isActive: true },
  //       { id: 2, name: 'Nagpur Rural', isActive: true },
  //       { id: 3, name: 'Kamptee', isActive: true },
  //       { id: 4, name: 'Hingna', isActive: true }
  //     ]
  //   },
  //   {
  //     id: 2,
  //     name: 'Amravati',
  //     isActive: true,
  //     talukas: [
  //       { id: 5, name: 'Amravati', isActive: true },
  //       { id: 6, name: 'Achalpur', isActive: true },
  //       { id: 7, name: 'Chandur Railway', isActive: true }
  //     ]
  //   },
  //   {
  //     id: 3,
  //     name: 'Akola',
  //     isActive: true,
  //     talukas: [
  //       { id: 8, name: 'Akola', isActive: true },
  //       { id: 9, name: 'Balapur', isActive: true },
  //       { id: 10, name: 'Barshitakli', isActive: true }
  //     ]
  //   }
  // ];

  districtDialogVisible = false;
  talukaDialogVisible = false;
  isEditMode = false;
  isEditModeTaluka = false;
  currentDistrict: any = { name: '', isActive: true };
  currentTaluka: any = { name: '', isActive: true };
  nextDistrictId = 4; // Starting ID for new districts
  nextTalukaId = 11; // Starting ID for new talukas

  // District Dialog Methods
  openDistrictDialog(district?: District) {
    this.districtDialogVisible = true;
    this.isEditMode = !!district;

    if (district) {
      this.currentDistrict = { ...district };
    } else {
      this.currentDistrict = { name: '', isActive: true };
    }
  }

  closeDistrictDialog() {
    this.districtDialogVisible = false;
    this.currentDistrict = { name: '', isActive: true };
  }

  async saveDistrict() {
    if (!this.currentDistrict.name.trim()) {
      alert('District name cannot be empty');
      return;
    }

    if (this.isEditMode) {
      const index = this.districts.findIndex(d => d.id === this.currentDistrict.id);
      if (index !== -1) {
        try {
          await this.apiService.updateDistrict(this.currentDistrict).toPromise();
          const talukas = this.districts[index].talukas;
          this.districts[index] = {
            ...this.currentDistrict,
            talukas: talukas
          };
          alert('District updated successfully.');
        } catch (error) {
          console.error('Failed to update district:', error);
          alert('Failed to update district.');
        }
      }
    } else {

      // Add District Section
      try {
        const response: any = await this.apiService.addDistrict(this.currentDistrict).toPromise();

        if (response.success) {
          this.districts.push({
            id: response.id, // Use backend-generated ID
            name: this.currentDistrict.name,
            isActive: this.currentDistrict.isActive,
            talukas: []
          });
          alert(response.message || 'District added successfully.');
        } else {
          alert(response.message || 'Failed to add district.');
        }
      } catch (error) {
        console.error('Failed to add district:', error);
        alert('Server error occurred while adding district.');
      }



    }
    this.closeDistrictDialog();
  }

  deleteDistrict(id: number) {
    if (confirm('Are you sure you want to delete this district? All talukas in this district will also be deleted.')) {
      this.apiService.deleteDistrict(id).subscribe({
        next: (response) => {
          // Check if deletion was successful based on response
          alert(response.message);
          this.districts = this.districts.filter(d => d.id !== id);  // Remove district from array
        },
        error: (error) => {
          console.error('Failed to delete district:', error);
          alert('Failed to delete district.');
        }
      });
    }
  }

  toggleDistrictStatus(district: District) {
    district.isActive = !district.isActive;
  }

  // Taluka Dialog Methods
  openTalukaDialog(district: District, taluka?: Taluka) {
    this.talukaDialogVisible = true;
    this.isEditModeTaluka = !!taluka;
    this.currentDistrict = district;

    if (taluka) {
      this.currentTaluka = { ...taluka };
    } else {
      this.currentTaluka = { name: '', isActive: true };
    }
  }

  closeTalukaDialog() {
    this.talukaDialogVisible = false;
    this.currentTaluka = { name: '', isActive: true };
  }

  async saveTaluka() {
    if (!this.currentTaluka.name.trim()) {
      alert('Taluka name cannot be empty');
      return;
    }

    const districtIndex = this.districts.findIndex(d => d.id === this.currentDistrict.id);
    if (districtIndex === -1) return;

    if (this.isEditModeTaluka) {
      const talukaIndex = this.districts[districtIndex].talukas.findIndex(
        t => t.id === this.currentTaluka.id
      );
      if (talukaIndex !== -1) {
        try {
          await this.apiService.updateTaluka(this.currentTaluka, this.currentDistrict.id).toPromise();
          this.districts[districtIndex].talukas[talukaIndex] = {
            ...this.currentTaluka
          };
          alert('Taluka updated successfully.');
        } catch (error) {
          console.error('Failed to update taluka:', error);
          alert('Failed to update taluka.');
        }
      }
    } else {

      try {
        const response: any = await this.apiService.addTaluka(this.currentTaluka, this.currentDistrict.id).toPromise();

        if (response.success) {
          this.districts[districtIndex].talukas.push({
            id: response.id, // Use backend-generated ID
            name: this.currentTaluka.name,
            isActive: this.currentTaluka.isActive
          });
          alert(response.message || 'Taluka added successfully.');
        } else {
          alert(response.message || 'Failed to add taluka.');
        }
      } catch (error) {
        console.error('Failed to add taluka:', error);
        alert('Server error occurred while adding taluka.');
      }



    }
    this.closeTalukaDialog();
  }

  // Delete Taluka Section
  deleteTaluka(districtId: number, talukaId: number) {
    if (confirm('Are you sure you want to delete this taluka?')) {
      this.apiService.deleteTaluka(talukaId).subscribe({
        next: (response) => {
          // Check if deletion was successful based on response
          alert(response.message);
          const districtIndex = this.districts.findIndex(d => d.id === districtId);
          if (districtIndex !== -1) {
            this.districts[districtIndex].talukas = this.districts[districtIndex].talukas.filter(
              t => t.id !== talukaId
            );
          }
        },
        error: (error) => {
          console.error('Failed to delete taluka:', error);
          alert('Failed to delete taluka.');
        }
      });
    }
  }

  toggleTalukaStatus(districtId: number, taluka: Taluka) {
    const districtIndex = this.districts.findIndex(d => d.id === districtId);
    if (districtIndex !== -1) {
      const talukaIndex = this.districts[districtIndex].talukas.findIndex(t => t.id === taluka.id);
      if (talukaIndex !== -1) {
        this.districts[districtIndex].talukas[talukaIndex].isActive = !taluka.isActive;
      }
    }
  }
}

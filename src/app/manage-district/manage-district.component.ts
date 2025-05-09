import { Component } from '@angular/core';

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
export class ManageDistrictComponent {
  districts: District[] = [
    {
      id: 1,
      name: 'Nagpur',
      isActive: true,
      talukas: [
        { id: 1, name: 'Nagpur Urban', isActive: true },
        { id: 2, name: 'Nagpur Rural', isActive: true },
        { id: 3, name: 'Kamptee', isActive: true },
        { id: 4, name: 'Hingna', isActive: true }
      ]
    },
    {
      id: 2,
      name: 'Amravati',
      isActive: true,
      talukas: [
        { id: 5, name: 'Amravati', isActive: true },
        { id: 6, name: 'Achalpur', isActive: true },
        { id: 7, name: 'Chandur Railway', isActive: true }
      ]
    },
    {
      id: 3,
      name: 'Akola',
      isActive: true,
      talukas: [
        { id: 8, name: 'Akola', isActive: true },
        { id: 9, name: 'Balapur', isActive: true },
        { id: 10, name: 'Barshitakli', isActive: true }
      ]
    }
  ];

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

  saveDistrict() {
    if (!this.currentDistrict.name.trim()) {
      alert('District name cannot be empty');
      return;
    }

    if (this.isEditMode) {
      const index = this.districts.findIndex(d => d.id === this.currentDistrict.id);
      if (index !== -1) {
        // Preserve talukas when updating district
        const talukas = this.districts[index].talukas;
        this.districts[index] = {
          ...this.currentDistrict,
          talukas: talukas
        };
      }
    } else {
      this.districts.push({
        id: this.nextDistrictId++,
        name: this.currentDistrict.name,
        isActive: this.currentDistrict.isActive,
        talukas: []
      });
    }
    this.closeDistrictDialog();
  }

  deleteDistrict(id: number) {
    if (confirm('Are you sure you want to delete this district? All talukas in this district will also be deleted.')) {
      this.districts = this.districts.filter(d => d.id !== id);
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

  saveTaluka() {
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
        this.districts[districtIndex].talukas[talukaIndex] = {
          ...this.currentTaluka
        };
      }
    } else {
      this.districts[districtIndex].talukas.push({
        id: this.nextTalukaId++,
        name: this.currentTaluka.name,
        isActive: this.currentTaluka.isActive
      });
    }
    this.closeTalukaDialog();
  }

  deleteTaluka(districtId: number, talukaId: number) {
    if (confirm('Are you sure you want to delete this taluka?')) {
      const districtIndex = this.districts.findIndex(d => d.id === districtId);
      if (districtIndex !== -1) {
        this.districts[districtIndex].talukas = this.districts[districtIndex].talukas.filter(
          t => t.id !== talukaId
        );
      }
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

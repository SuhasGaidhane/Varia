import { Component } from '@angular/core';

@Component({
  selector: 'app-manage-district',
  standalone: false,
  templateUrl: './manage-district.component.html',
  styleUrl: './manage-district.component.scss'
})
export class ManageDistrictComponent {
  districts = [
    { id: 1, name: 'Nagpur', state: 'Maharashtra' },
    { id: 2, name: 'Pune', state: 'Maharashtra' },
    { id: 3, name: 'Bhopal', state: 'Madhya Pradesh' },
    { id: 4, name: 'Raipur', state: 'Chhattisgarh' },
    { id: 5, name: 'Lucknow', state: 'Uttar Pradesh' }
  ];

  dialogVisible = false;
  isEditMode = false;
  currentDistrict: any = { name: '', state: '' };

  openDialog(district?: any) {
    this.dialogVisible = true;
    this.isEditMode = !!district;
    this.currentDistrict = district ? { ...district } : { name: '', state: '' };
  }

  closeDialog() {
    this.dialogVisible = false;
    this.currentDistrict = { name: '', state: '' };
    this.isEditMode = false;
  }

  saveDistrict() {
    if (this.isEditMode) {
      const index = this.districts.findIndex(d => d.id === this.currentDistrict.id);
      if (index !== -1) {
        this.districts[index] = { ...this.currentDistrict };
      }
    } else {
      const newId = this.districts.length + 1;
      this.districts.push({ id: newId, ...this.currentDistrict });
    }
    this.closeDialog();
  }

  deleteDistrict(id: number) {
    this.districts = this.districts.filter(d => d.id !== id);
  }
}

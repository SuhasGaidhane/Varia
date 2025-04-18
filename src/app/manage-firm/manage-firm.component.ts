import { Component } from '@angular/core';

@Component({
  selector: 'app-manage-firm',
  standalone: false,
  templateUrl: './manage-firm.component.html',
  styleUrl: './manage-firm.component.scss'
})
export class ManageFirmComponent {
  searchQuery = '';
  selectedDistrict = '';
  popupVisible = false;
  editingFirm: any = null;

  formData: any = {
    name: '',
    owner: '',
    mobile: '',
    address: '',
    district: '',
    gst: '',
    image: ''
  };

  districts: string[] = ['Nagpur', 'Amravati', 'Akola', 'Wardha'];

  firms: any[] = [
    {
      name: 'Agro Mart',
      owner: 'Ravi Kumar',
      mobile: '7972726558',
      address: 'MG Road, Nagpur',
      district: 'Nagpur',
      gst: '27AABCU9603R1Z2',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs_d7KFhikyJ65amGDjDgxk1ktCMwx54EjDQ&s'
    },
    {
      name: 'Farmers First',
      owner: 'Pooja Deshmukh',
      mobile: '8530412675',
      address: 'Main Road, Akola',
      district: 'Akola',
      gst: '27AACCD1234B1Z5',
      image: 'https://content.jdmagicbox.com/comp/thrissur/h9/9999px487.x487.200622101826.s4h9/catalogue/cheringal-agri-shop-mannuthy-thrissur-flower-pot-dealers-rqunkbp6xz.jpg'
    }
  ];

  filteredFirms() {
    return this.firms.filter(firm => {
      const matchesSearch =
        !this.searchQuery ||
        firm.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
        firm.owner.toLowerCase().includes(this.searchQuery.toLowerCase())||
        firm.mobile.toLowerCase().includes(this.searchQuery.toLowerCase());
      const matchesDistrict =
        !this.selectedDistrict || firm.district === this.selectedDistrict;
      return matchesSearch && matchesDistrict;
    });
  }

  openPopup(firm: any = null) {
    this.editingFirm = firm;
    this.popupVisible = true;

    if (firm) {
      this.formData = { ...firm };
    } else {
      this.formData = {
        name: '',
        owner: '',
        mobile: '',
        address: '',
        district: '',
        gst: '',
        image: ''
      };
    }
  }

  closePopup() {
    this.popupVisible = false;
    this.editingFirm = null;
  }

  saveFirm() {
    if (this.editingFirm) {
      const index = this.firms.indexOf(this.editingFirm);
      this.firms[index] = { ...this.formData };
    } else {
      this.firms.push({ ...this.formData });
    }

    this.closePopup();
  }

  deleteFirm(firm: any) {
    this.firms = this.firms.filter(f => f !== firm);
  }

  handleImageUpload(event: any) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = e => {
        this.formData.image = (e.target as FileReader).result;
      };
      reader.readAsDataURL(file);
    }
  }
}

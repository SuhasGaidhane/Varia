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
  selectedTaluka = '';
  popupVisible = false;
  editingFirm: any = null;
  availableTalukas: string[] = [];
  filterTalukas: string[] = [];
  activeStatusFilter: 'all' | 'active' | 'inactive' = 'all';

  formData: any = {
    name: '',
    owner: '',
    mobile: '',
    otherMobile: '',
    email: '',
    mfmsNumber: '',
    address: '',
    district: '',
    taluka: '',
    gst: '',
    image: '',
    isActive: true
  };

  districts: string[] = ['Nagpur', 'Amravati', 'Akola', 'Wardha'];

  // Map districts to their talukas
  districtTalukaMap: { [key: string]: string[] } = {
    'Nagpur': ['Nagpur Urban', 'Nagpur Rural', 'Kamptee', 'Hingna', 'Ramtek', 'Umred'],
    'Amravati': ['Amravati', 'Achalpur', 'Chandur Railway', 'Dhamangaon', 'Morshi'],
    'Akola': ['Akola', 'Balapur', 'Barshitakli', 'Murtijapur', 'Patur', 'Telhara'],
    'Wardha': ['Wardha', 'Arvi', 'Ashti', 'Deoli', 'Hinganghat', 'Samudrapur']
  };

  firms: any[] = [
    {
      name: 'Agro Mart',
      owner: 'Ravi Kumar',
      mobile: '7972726558',
      otherMobile: '9876543210',
      email: 'ravi@agromart.com',
      mfmsNumber: 'MFMS123456',
      address: 'MG Road, Nagpur',
      district: 'Nagpur',
      taluka: 'Nagpur Urban',
      gst: '27AABCU9603R1Z2',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs_d7KFhikyJ65amGDjDgxk1ktCMwx54EjDQ&s',
      isActive: true
    },
    {
      name: 'Farmers First',
      owner: 'Pooja Deshmukh',
      mobile: '8530412675',
      otherMobile: '7894561230',
      email: 'pooja@farmersfirst.com',
      mfmsNumber: 'MFMS789012',
      address: 'Main Road, Akola',
      district: 'Akola',
      taluka: 'Akola',
      gst: '27AACCD1234B1Z5',
      image: 'https://content.jdmagicbox.com/comp/thrissur/h9/9999px487.x487.200622101826.s4h9/catalogue/cheringal-agri-shop-mannuthy-thrissur-flower-pot-dealers-rqunkbp6xz.jpg',
      isActive: true
    }
  ];

  filteredFirms() {
    return this.firms.filter(firm => {
      const matchesSearch =
        !this.searchQuery ||
        firm.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
        firm.owner.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
        firm.mobile.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
        (firm.email && firm.email.toLowerCase().includes(this.searchQuery.toLowerCase())) ||
        (firm.otherMobile && firm.otherMobile.toLowerCase().includes(this.searchQuery.toLowerCase())) ||
        (firm.mfmsNumber && firm.mfmsNumber.toLowerCase().includes(this.searchQuery.toLowerCase()));

      const matchesDistrict =
        !this.selectedDistrict || firm.district === this.selectedDistrict;

      const matchesTaluka =
        !this.selectedTaluka || firm.taluka === this.selectedTaluka;

      const matchesActiveStatus =
        this.activeStatusFilter === 'all' ||
        (this.activeStatusFilter === 'active' && firm.isActive) ||
        (this.activeStatusFilter === 'inactive' && !firm.isActive);

      return matchesSearch && matchesDistrict && matchesTaluka && matchesActiveStatus;
    });
  }

  openPopup(firm: any = null) {
    this.editingFirm = firm;
    this.popupVisible = true;

    if (firm) {
      this.formData = { ...firm };
      // Set available talukas based on selected district
      if (this.formData.district) {
        this.availableTalukas = this.districtTalukaMap[this.formData.district] || [];
      }
    } else {
      this.formData = {
        name: '',
        owner: '',
        mobile: '',
        otherMobile: '',
        email: '',
        mfmsNumber: '',
        address: '',
        district: '',
        taluka: '',
        gst: '',
        image: '',
        isActive: true
      };
      this.availableTalukas = [];
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

  toggleFirmStatus(firm: any) {
    firm.isActive = !firm.isActive;
  }

  setActiveStatusFilter(status: 'all' | 'active' | 'inactive') {
    this.activeStatusFilter = status;
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

  onDistrictChange() {
    // Update available talukas when district changes in form
    if (this.formData.district) {
      this.availableTalukas = this.districtTalukaMap[this.formData.district] || [];
      // Reset taluka when district changes
      this.formData.taluka = '';
    } else {
      this.availableTalukas = [];
    }
  }

  onFilterDistrictChange() {
    // Update available talukas for filter when district filter changes
    if (this.selectedDistrict) {
      this.filterTalukas = this.districtTalukaMap[this.selectedDistrict] || [];
      // Reset taluka filter when district changes
      this.selectedTaluka = '';
    } else {
      this.filterTalukas = [];
      this.selectedTaluka = '';
    }
  }
}

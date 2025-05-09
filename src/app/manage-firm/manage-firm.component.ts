import {Component, OnInit} from '@angular/core';
import {ApiService} from '../services/api.service';
import {MatDialog} from '@angular/material/dialog';
import {FormBuilder} from '@angular/forms';
import {MatSnackBar} from '@angular/material/snack-bar';

@Component({
  selector: 'app-manage-firm',
  standalone: false,
  templateUrl: './manage-firm.component.html',
  styleUrl: './manage-firm.component.scss'
})
export class ManageFirmComponent implements OnInit{

  constructor(
    private snackBar: MatSnackBar,
    private apiService: ApiService,
    private dialog: MatDialog,
    private fb: FormBuilder
  ) {}


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
    city: '', // ✅ Add this
    district: '',
    district_id : '',
    taluka: '',
    taluka_id: '',
    gst: '',
    firm_image: '',
    isActive: true
  };

  // // districts: string[] = ['Nagpur', 'Amravati', 'Akola', 'Wardha'];
  // //
  // // Map districts to their talukas
  // districtTalukaMap: { [key: string]: string[] } = {
  //   'Nagpur': ['Nagpur Urban', 'Nagpur Rural', 'Kamptee', 'Hingna', 'Ramtek', 'Umred'],
  //   'Amravati': ['Amravati', 'Achalpur', 'Chandur Railway', 'Dhamangaon', 'Morshi'],
  //   'Akola': ['Akola', 'Balapur', 'Barshitakli', 'Murtijapur', 'Patur', 'Telhara'],
  //   'Wardha': ['Wardha', 'Arvi', 'Ashti', 'Deoli', 'Hinganghat', 'Samudrapur']
  // };


  ngOnInit(): void {

    this.getAllFirmList()
    this.getDistrictsWithTalukas()
  }


  districts: string[] = [];
  districtTalukaMap: { [district: string]: string[] } = {};

  getDistrictsWithTalukasData: any[] = [];

  async getDistrictsWithTalukas() {
    try {
      const data = await this.apiService.getDistrictsWithTalukas().toPromise();
      if (data) {
        this.getDistrictsWithTalukasData = data;

        // Extract district names
        this.districts = this.getDistrictsWithTalukasData.map(d => d.name);

        // Build district–taluka map
        this.districtTalukaMap = {};
        this.getDistrictsWithTalukasData.forEach(district => {
          this.districtTalukaMap[district.name] = district.talukas.map((t: { name: string }) => t.name);
        });

      } else {
        this.getDistrictsWithTalukasData = [];
        this.districts = [];
        this.districtTalukaMap = {};
      }
    } catch (error) {
      console.error('Error fetching Districts and Talukas Data:', error);
      this.getDistrictsWithTalukasData = [];
      this.districts = [];
      this.districtTalukaMap = {};
    }
  }




  firms: any[] = [];

  async getAllFirmList() {
    try {
      const data = await this.apiService.getAllFirmList().toPromise();
      if (data.status) {
        this.firms = data.details
      } else {
        this.firms = [];
      }
    } catch (error) {
      console.error('Error fetching Firms:', error);
      this.firms = [];
    }
  }





  filteredFirms() {
    return this.firms.filter(firm => {
      const search = this.searchQuery?.toLowerCase() || '';

      const matchesSearch =
        !this.searchQuery ||
        (firm.name?.toLowerCase()?.includes(search)) ||
        (firm.owner?.toLowerCase()?.includes(search)) ||
        (firm.mobile?.toLowerCase()?.includes(search)) ||
        (firm.email?.toLowerCase()?.includes(search)) ||
        (firm.otherMobile?.toLowerCase()?.includes(search)) ||
        (firm.district?.toLowerCase()?.includes(search)) ||
        (firm.taluka?.toLowerCase()?.includes(search)) ||
        (firm.mfmsNumber?.toLowerCase()?.includes(search));

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
      this.formData = {
        ...firm,
        firm_image: firm.firm_image
          ? 'https://variaindia.com/VariaAPI/' + firm.firm_image
          : ''
      };
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
        city: '',
        district: '',
        district_id : '',
        taluka: '',
        taluka_id: '',
        gst: '',
        firm_image: '',
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
    const formDataToSend = new FormData();

    // Common form data for both add and update
    formDataToSend.append('shop_name', this.formData.name);
    formDataToSend.append('proprieter_name', this.formData.owner);
    formDataToSend.append('mobile', this.formData.mobile);
    formDataToSend.append('otherNumbers', this.formData.otherMobile);
    formDataToSend.append('email', this.formData.email);
    formDataToSend.append('address', this.formData.address);
    formDataToSend.append('city', this.formData.city);
    formDataToSend.append('gst', this.formData.gst);
    formDataToSend.append('mfms', this.formData.mfmsNumber);
    formDataToSend.append('district_id', this.formData.district_id);
    formDataToSend.append('taluka_id', this.formData.taluka_id);
    formDataToSend.append('isActive', this.formData.isActive ? '1' : '0');

    // Use the stored File object for the image, if available
    if (this.selectedFirmImage) {
      formDataToSend.append('firm_image', this.selectedFirmImage, this.selectedFirmImage.name);
    }

    if (this.editingFirm) {
      // Update existing firm
      formDataToSend.append('masterFirmId', this.editingFirm.masterFirmId);

      this.apiService.updateFirm(formDataToSend).subscribe({
        next: (response: any) => {
          if (response.status === 'success') {
            console.log('Firm updated successfully:', response);
            this.showNotification('Firm updated successfully');
            // Get updated data from server
            this.getAllFirmList();
            this.closePopup();
          } else {
            console.error('Server responded with error:', response.message);
            alert('Error: ' + (response.message || 'Something went wrong'));
          }
        },
        error: (error) => {
          console.error('Request failed:', error);
          alert('Failed to update firm due to a network or server error.');
        }
      });
    } else {
      // Add new firm
      this.apiService.addFirm(formDataToSend).subscribe({
        next: (response: any) => {
          if (response.status === 'success') {
            console.log('Firm added successfully:', response);
            this.showNotification('Firm added successfully');
            // Get updated data from server
            this.getAllFirmList();
            this.closePopup();
          } else {
            console.error('Server responded with error:', response.message);
            alert('Error: ' + (response.message || 'Something went wrong'));
          }
        },
        error: (error) => {
          console.error('Request failed:', error);
          alert('Failed to add firm due to a network or server error.');
        }
      });
    }
  }



  deleteFirm(firm: any) {
    if (!firm.masterFirmId) {
      alert('Invalid firm ID');
      return;
    }

    this.apiService.deleteFirm(firm.masterFirmId).subscribe({
      next: (response: any) => {
        if (response.status === 'success') {
          this.firms = this.firms.filter(f => f !== firm);
          this.showNotification('Firm deleted successfully');
        } else {
          alert('Error: ' + (response.message || 'Something went wrong'));
        }
      },
      error: () => {
        alert('Failed to delete firm due to a network or server error.');
      }
    });
  }


  toggleFirmStatus(firm: any) {
    firm.isActive = !firm.isActive;
  }

  setActiveStatusFilter(status: 'all' | 'active' | 'inactive') {
    this.activeStatusFilter = status;
  }

  selectedFirmImage: File | null = null;

  handleImageUpload(event: any) {
    const file = event.target.files[0];
    if (file) {
      // Store the actual file object for later use when submitting the form
      this.selectedFirmImage = file;

      // Create preview
      const reader = new FileReader();
      reader.onload = e => {
        // This is just for preview purposes
        this.formData.imagePreview = (e.target as FileReader).result;
      };
      reader.readAsDataURL(file);
    }
  }

  // Update this method to set district_id when a district is selected
  onDistrictChange() {
    // Find the selected district in the districts data
    if (this.formData.district) {
      const selectedDistrictObj = this.getDistrictsWithTalukasData.find(
        d => d.name === this.formData.district
      );

      if (selectedDistrictObj) {
        // Set the district_id
        this.formData.district_id = selectedDistrictObj.id;

        // Update available talukas
        this.availableTalukas = selectedDistrictObj.talukas.map((t: any) => t.name);

        // Reset taluka and taluka_id when district changes
        this.formData.taluka = '';
        this.formData.taluka_id = '';
      } else {
        this.availableTalukas = [];
      }
    } else {
      this.availableTalukas = [];
      this.formData.district_id = '';
    }
  }

// Add a new method to handle taluka selection
  onTalukaChange() {
    if (this.formData.district && this.formData.taluka) {
      const selectedDistrictObj = this.getDistrictsWithTalukasData.find(
        d => d.name === this.formData.district
      );

      if (selectedDistrictObj) {
        const selectedTalukaObj = selectedDistrictObj.talukas.find(
          (t: any) => t.name === this.formData.taluka
        );

        if (selectedTalukaObj) {
          // Set the taluka_id
          this.formData.taluka_id = selectedTalukaObj.id;
        }
      }
    } else {
      this.formData.taluka_id = '';
    }
  }

  onFilterDistrictChange() {
    if (this.selectedDistrict) {
      this.filterTalukas = this.districtTalukaMap[this.selectedDistrict] || [];
      this.selectedTaluka = '';
    } else {
      this.filterTalukas = [];
      this.selectedTaluka = '';
    }
  }

  showNotification(message: string) {
    this.snackBar.open(message, 'Close', {
      duration: 3000, // milliseconds
      horizontalPosition: 'right',
      verticalPosition: 'top',
    });
  }

}

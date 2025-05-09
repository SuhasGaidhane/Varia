import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import {ApiService} from '../services/api.service';

interface Offer {
  id: number;
  title: string;
  description: string;
  startDate: Date;
  endDate: Date;
  imageUrl: string;
  isActive: boolean;
}

interface SubscriptionPlan {
  id: number;
  name: string;
  price: number;
  credits: number;
  duration: number; // in months
  feature: string;
  popularTag?: string;
}

@Component({
  selector: 'app-offers-subscription',
  standalone: false,
  templateUrl: './offers-subscription.component.html',
  styleUrls: ['./offers-subscription.component.scss']
})
export class OffersSubscriptionComponent implements OnInit {
  activeTab = 'offers'; // Default tab

  // For editing offers
  showEditOfferDialog = false;
  currentOffer: Offer | null = null;
  offerForm: FormGroup;
  previewImage: string | ArrayBuffer | null = null;

  // For deleting offers
  showDeleteDialog = false;
  offerToDelete: Offer | null = null;

  // For editing subscription plans
  showEditSubscriptionDialog = false;
  currentSubscriptionPlan: SubscriptionPlan | null = null;
  subscriptionForm: FormGroup;


  // Subscription plans data
  // subscriptionPlans: SubscriptionPlan[] = [
  //   {
  //     id: 1,
  //     name: 'Basic',
  //     price: 2000,
  //     credits: 101,
  //     duration: 3,
  //     features: ['Essential features to get started', 'Email support', 'Basic analytics']
  //   },
  //   {
  //     id: 2,
  //     name: 'Standard',
  //     price: 3500,
  //     credits: 250,
  //     duration: 6,
  //     features: ['More features and better limits', 'Priority email support', 'Advanced analytics', 'Phone support'],
  //     popularTag: 'Most Popular'
  //   },
  //   {
  //     id: 3,
  //     name: 'Premium',
  //     price: 5000,
  //     credits: 750,
  //     duration: 12,
  //     features: ['Full access to all features', '24/7 support', 'Premium analytics', 'Dedicated account manager', 'Customization options']
  //   }
  // ];

  constructor(
    private apiService: ApiService,
    private dialog: MatDialog,
    private fb: FormBuilder
  ) {
    // Initialize offer form
    this.offerForm = this.fb.group({
      id: [null],
      title: ['', [Validators.required]],
      description: ['', [Validators.required]],
      startDate: [null, [Validators.required]],
      endDate: [null, [Validators.required]],
      imageUrl: ['', [Validators.required]],
      isActive: [true]
    });

    // Initialize subscription form
    this.subscriptionForm = this.fb.group({
      id: [null],
      name: ['', [Validators.required]],
      price: [0, [Validators.required, Validators.min(0)]],
      credits: [0, [Validators.required, Validators.min(0)]],
      duration: [1, [Validators.required, Validators.min(1)]],
      feature: ['', [Validators.required]],
      popularTag: ['']
    });
  }

  ngOnInit(): void {
    this.getOffers();
    this.getSubscriptionPlan();
  }

  offers: Offer[] = [];

  async getOffers() {
    try {
      const data = await this.apiService.getOffers().toPromise();
      if (data.status === "success" && data.data) {
        // Map API response to match your Offer interface
        this.offers = data.data.map((item: any) => ({
          id: item.offer_id,
          title: item.title,
          description: item.description,
          imageUrl: item.image_url,
          startDate: new Date(item.start_date),
          endDate: new Date(item.end_date),
          isActive: item.is_active === 1

        }));
      } else {
        this.offers = [];
      }
    } catch (error) {
      console.error('Error fetching offers:', error);
      this.offers = [];
    }
  }

  subscriptionPlans: SubscriptionPlan[] = [];
  async getSubscriptionPlan() {
    try {

      const data = await this.apiService.getSubscriptionPlan().toPromise();
      if (data.status === "success" && data.data) {
        this.subscriptionPlans = data.data.map((item: any) => ({
          id: item.MasterSubscriptionId,
          name: item.PlanName,
          price: item.BasePrice,
          credits: item.Credit,
          duration: item.Month,
          feature: item.Description,
        }));
      } else {
        this.offers = [];
      }
    } catch (error) {
      console.error('Error fetching offers:', error);
      this.offers = [];
    }
  }


  switchTab(tab: string): void {
    this.activeTab = tab;
  }

  // Offer management methods
  editOffer(offer: Offer | null = null): void {
    this.showEditOfferDialog = true;

    if (offer) {
      this.currentOffer = { ...offer };
      this.offerForm.patchValue(offer);
      this.previewImage = 'https://variaindia.com/VariaAPI/' + offer.imageUrl;
    } else {
      // Creating a new offer
      this.currentOffer = null;
      this.offerForm.reset({ isActive: true });
      this.previewImage = null;
    }
  }




// Class level variable to store the file
  selectedFile: File | null = null;

  onFileSelected(event: Event): void {
    const element = event.target as HTMLInputElement;
    const fileList: FileList | null = element.files;

    if (fileList && fileList.length > 0) {
      const file = fileList[0];
      this.selectedFile = file; // Store the file for later use

      // Create a preview
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.previewImage = e.target.result;
        // Don't set form value to the base64 string, as it's too large
        // Just store the file reference and set a placeholder for the form
        this.offerForm.patchValue({ imageUrl: 'file-selected' });
      };
      reader.readAsDataURL(file);
    }
  }

  saveOffer(): void {
    if (this.offerForm.invalid) {
      return;
    }

    const formData = new FormData();
    const offerData = this.offerForm.value;

    // Common fields
    formData.append('title', offerData.title);
    formData.append('description', offerData.description);
    formData.append('start_date', this.formatDate(offerData.startDate));
    formData.append('end_date', this.formatDate(offerData.endDate));
    formData.append('is_active', offerData.isActive ? '1' : '0');

    // Handle image upload
    if (this.selectedFile) {
      formData.append('image', this.selectedFile, this.selectedFile.name);
    } else if (this.currentOffer?.imageUrl) {
      // If editing and no new file selected, send the existing image URL
      formData.append('image', this.currentOffer.imageUrl);
    }

    // --- Detect whether it is Add or Edit ---
    if (this.currentOffer && this.currentOffer.id) {
      // Editing existing offer
      formData.append('offer_id', this.currentOffer.id.toString());

      this.apiService.updateOffer(formData).subscribe({
        next: (response) => {
          if (response.status === 'success') {
            this.getOffers();
            this.closeOfferDialog();
          } else {
            console.error('Error updating offer:', response.message);
          }
        },
        error: (error) => {
          console.error('API error:', error);
        }
      });

    } else {
      // Adding new offer
      this.apiService.addOffer(formData).subscribe({
        next: (response) => {
          if (response.status === 'success') {
            this.getOffers();
            this.closeOfferDialog();
          } else {
            console.error('Error adding offer:', response.message);
          }
        },
        error: (error) => {
          console.error('API error:', error);
        }
      });
    }
  }

// Helper method to format dates for API
  private formatDate(date: Date): string {
    if (!date) return '';

    const d = new Date(date);
    const year = d.getFullYear();
    const month = ('0' + (d.getMonth() + 1)).slice(-2);
    const day = ('0' + d.getDate()).slice(-2);

    return `${year}-${month}-${day}`;
  }

  getNextOfferId(): number {
    return Math.max(0, ...this.offers.map(o => o.id)) + 1;
  }

  closeOfferDialog(): void {
    this.showEditOfferDialog = false;
    this.currentOffer = null;
    this.offerForm.reset();
  }

  confirmDeleteOffer(offer: Offer): void {
    this.offerToDelete = offer;
    this.showDeleteDialog = true;
  }

  deleteOffer(): void {
    if (this.offerToDelete) {
      // Create formData to pass in the request body
      const formData = new FormData();
      formData.append('offer_id', this.offerToDelete.id.toString());

      // Call the delete API using POST method
      this.apiService.deleteOffer(formData).subscribe({
        next: (response) => {
          if (response.status === 'success') {
            // If deletion is successful, remove the offer from the list
            this.offers = this.offers.filter(o => o.id !== this.offerToDelete!.id);
            console.log('Offer deleted successfully');
            this.closeDeleteDialog(); // Close the delete confirmation dialog
          } else {
            console.error('Error deleting offer:', response.message);
            // Optionally show error message to user
          }
        },
        error: (error) => {
          console.error('API error:', error);
          // Optionally show error message to user
        }
      });
    }
  }



  closeDeleteDialog(): void {
    this.showDeleteDialog = false;
    this.offerToDelete = null;
  }

  toggleOfferStatus(offer: Offer): void {
    offer.isActive = !offer.isActive;
  }

  // Subscription plan management methods
  editSubscriptionPlan(plan: SubscriptionPlan): void {
    this.showEditSubscriptionDialog = true;
    this.currentSubscriptionPlan = { ...plan };
    this.subscriptionForm.patchValue({
      id: plan.id,
      name: plan.name,
      price: plan.price,
      credits: plan.credits,
      duration: plan.duration,
      feature: plan.feature
    });
    console.log(this.currentSubscriptionPlan)
  }

  // Save (Update Data)
  saveSubscriptionPlan(): void {
    if (this.subscriptionForm.valid) {
      const formValue = this.subscriptionForm.value;

      const formData = new FormData();

      formData.append('MasterSubscriptionId', formValue.id);
      console.log("data", formValue.id)
      formData.append('PlanName', formValue.name);
      formData.append('Description', formValue.feature);
      formData.append('Credit', formValue.credits.toString());
      formData.append('BasePrice', formValue.price.toString());
      console.log(formValue)
      this.apiService.updateSubscription(formData).subscribe(
        response => {
          const updatedPlan = {
            id: formValue.id,
            name: formValue.name,
            price: formValue.price,
            credits: formValue.credits,
            duration: formValue.duration,
            feature: formValue.feature,
          };

          const index = this.subscriptionPlans.findIndex(p => p.id === updatedPlan.id);
          if (index !== -1) {
            this.subscriptionPlans[index] = updatedPlan;
          }

          this.closeSubscriptionDialog();
        },
        error => {
          console.error('Update failed', error);
        }
      );
    }
  }


  closeSubscriptionDialog(): void {
    this.showEditSubscriptionDialog = false;
    this.currentSubscriptionPlan = null;
    this.subscriptionForm.reset();
  }
}

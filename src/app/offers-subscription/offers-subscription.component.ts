import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';

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
  features: string[];
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

  // Offers data
  offers: Offer[] = [
    {
      id: 1,
      title: 'Summer Special',
      description: 'Get 20% off on all subscription plans',
      startDate: new Date('2025-04-01'),
      endDate: new Date('2025-05-31'),
      imageUrl: 'https://agroorbit.s3.ap-south-1.amazonaws.com/uploads/all/5cMwZXT5cG7rUuLwgZBgjxdvZx1MvSRKu0AKOWm4.png',
      isActive: true
    },
    {
      id: 2,
      title: 'New User Discount',
      description: 'First-time users get 30% off',
      startDate: new Date('2025-03-15'),
      endDate: new Date('2025-06-15'),
      imageUrl: 'https://agroorbit.s3.ap-south-1.amazonaws.com/uploads/all/5cMwZXT5cG7rUuLwgZBgjxdvZx1MvSRKu0AKOWm4.png',
      isActive: true
    },
    {
      id: 3,
      title: 'Holiday Promotion',
      description: 'Special holiday packages with extra credits',
      startDate: new Date('2025-11-15'),
      endDate: new Date('2025-12-31'),
      imageUrl: 'https://agroorbit.s3.ap-south-1.amazonaws.com/uploads/all/5cMwZXT5cG7rUuLwgZBgjxdvZx1MvSRKu0AKOWm4.png',
      isActive: false
    }
  ];

  // Subscription plans data
  subscriptionPlans: SubscriptionPlan[] = [
    {
      id: 1,
      name: 'Basic',
      price: 2000,
      credits: 101,
      duration: 3,
      features: ['Essential features to get started', 'Email support', 'Basic analytics']
    },
    {
      id: 2,
      name: 'Standard',
      price: 3500,
      credits: 250,
      duration: 6,
      features: ['More features and better limits', 'Priority email support', 'Advanced analytics', 'Phone support'],
      popularTag: 'Most Popular'
    },
    {
      id: 3,
      name: 'Premium',
      price: 5000,
      credits: 750,
      duration: 12,
      features: ['Full access to all features', '24/7 support', 'Premium analytics', 'Dedicated account manager', 'Customization options']
    }
  ];

  constructor(
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
      features: [[]],
      popularTag: ['']
    });
  }

  ngOnInit(): void {}

  switchTab(tab: string): void {
    this.activeTab = tab;
  }

  // Offer management methods
  editOffer(offer: Offer | null = null): void {
    this.showEditOfferDialog = true;

    if (offer) {
      this.currentOffer = { ...offer };
      this.offerForm.patchValue(offer);
      this.previewImage = offer.imageUrl;
    } else {
      // Creating a new offer
      this.currentOffer = null;
      this.offerForm.reset({ isActive: true });
      this.previewImage = null;
    }
  }

  onFileSelected(event: any): void {
    const file = event.target.files[0];
    if (file) {
      // In a real app, you would upload this file to a server
      // For now, we'll just create a preview
      const reader = new FileReader();
      reader.onload = () => {
        this.previewImage = reader.result;
        this.offerForm.patchValue({ imageUrl: reader.result as string });
      };
      reader.readAsDataURL(file);
    }
  }

  saveOffer(): void {
    if (this.offerForm.valid) {
      const offerData = this.offerForm.value;

      if (offerData.id) {
        // Update existing offer
        const index = this.offers.findIndex(o => o.id === offerData.id);
        if (index !== -1) {
          this.offers[index] = offerData;
        }
      } else {
        // Add new offer
        offerData.id = this.getNextOfferId();
        this.offers.push(offerData);
      }

      this.closeOfferDialog();
    }
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
      this.offers = this.offers.filter(o => o.id !== this.offerToDelete!.id);
      this.closeDeleteDialog();
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

    // Convert features array to string for easier editing
    const featuresString = plan.features.join('\n');

    this.subscriptionForm.patchValue({
      ...plan,
      features: featuresString
    });
  }

  saveSubscriptionPlan(): void {
    if (this.subscriptionForm.valid) {
      const formValue = this.subscriptionForm.value;

      // Convert features string back to array
      const featuresString = formValue.features;
      const featuresArray = typeof featuresString === 'string'
        ? featuresString.split('\n').filter(f => f.trim() !== '')
        : formValue.features;

      const planData = {
        ...formValue,
        features: featuresArray
      };

      // Update the subscription plan with the edited data
      const index = this.subscriptionPlans.findIndex(p => p.id === planData.id);
      if (index !== -1) {
        this.subscriptionPlans[index] = planData;
      }

      this.closeSubscriptionDialog();
    }
  }

  closeSubscriptionDialog(): void {
    this.showEditSubscriptionDialog = false;
    this.currentSubscriptionPlan = null;
    this.subscriptionForm.reset();
  }
}

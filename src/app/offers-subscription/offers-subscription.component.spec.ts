import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OffersSubscriptionComponent } from './offers-subscription.component';

describe('OffersSubscriptionComponent', () => {
  let component: OffersSubscriptionComponent;
  let fixture: ComponentFixture<OffersSubscriptionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [OffersSubscriptionComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OffersSubscriptionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

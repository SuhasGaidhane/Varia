import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ManageFirmComponent } from './manage-firm.component';

describe('ManageFirmComponent', () => {
  let component: ManageFirmComponent;
  let fixture: ComponentFixture<ManageFirmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ManageFirmComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ManageFirmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

import { Component } from '@angular/core';

@Component({
  selector: 'app-dashboard',
  standalone: false,
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent {

  graphList = [
    {
      title: 'Total Users',
      config: {
        type: 'bar',
        license: 'none',
        series: [{ values: [50, 100, 150, 200] }],
        scaleX: { labels: ['Jan', 'Feb', 'Mar', 'Apr'] }
      }
    },
    {
      title: 'Active Subscriptions',
      config: {
        type: 'line',
        license: 'none',
        series: [{ values: [20, 60, 80, 120] }],
        scaleX: { labels: ['Jan', 'Feb', 'Mar', 'Apr'] }
      }
    },
    {
      title: 'Sales This Month',
      config: {
        type: 'pie',
        license: 'none',
        series: [
          { values: [25], text: 'Online' },
          { values: [50], text: 'Retail' },
          { values: [25], text: 'Wholesale' }
        ]
      }
    },
    {
      title: 'Subscription by District',
      config: {
        type: 'bar',
        license: 'none',
        series: [{ values: [70, 30, 50, 90] }],
        scaleX: { labels: ['Nagpur', 'Wardha', 'Amravati', 'Buldhana'] }
      }
    },
    {
      title: 'Firms by District',
      config: {
        type: 'bar',
        license: 'none',
        series: [{ values: [10, 20, 5, 15] }],
        scaleX: { labels: ['Nagpur', 'Wardha', 'Amravati', 'Buldhana'] }
      }
    }
  ];

  users = [
    {
      name: 'User 1',
      mobile: '98765432101',
      otherNumbers: '7972726558, 8530412675',
      address: 'Nagpur',
      subscriptions: [
        {
          district: 'Nagpur',
          plan: 'Premium',
          startDate: '2024-01-01',
          endDate: '2024-01-01'
        },
        {
          district: 'Gondia',
          plan: 'Basic',
          startDate: '2021-06-01',
          endDate: '2024-06-01'
        }
      ],
      firms: [
        {
          name: 'Firm 1A',
          owner: 'User 1',
          address: 'Address 1A',
          district: 'Nagpur',
          gst: 'GST1A',
          image: ''
        },
        {
          name: 'Firm 1B',
          owner: 'User 1',
          address: 'Address 1B',
          district: 'Gondia',
          gst: 'GST1B',
          image: ''
        }
      ],
      messages: [
        {
          district: 'Nagpur',
          date: '2025-04-10',
          text: 'Check our offers!',
          count: 50,
          receivers: ['Firm 1', 'Firm 2', 'Firm 3']
        },
        {
          district: 'Bhandara',
          date: '2025-04-11',
          text: 'Check our offers!',
          count: 50,
          receivers: ['Firm 1', 'Firm 2', 'Firm 3']
        }
      ],
      credits: 120
    },
    {
      name: 'User 2',
      mobile: '98765432102',
      otherNumbers: '7972726558, 8530412675',
      address: 'Nagpur',
      subscriptions: [
        {
          district: 'Nagpur',
          plan: 'Standard',
          startDate: '2025-03-01',
          endDate: '2026-03-01'
        }
      ],
      firms: [
        {
          name: 'Firm 2A',
          owner: 'User 2',
          address: 'Address 2A',
          district: 'Nagpur',
          gst: 'GST2A',
          image: ''
        },
        {
          name: 'Firm 2B',
          owner: 'User 2',
          address: 'Address 2B',
          district: 'Gondia',
          gst: 'GST2B',
          image: ''
        }
      ],
      messages: [
        {
          district: 'Nagpur',
          date: '2025-04-10',
          text: 'Check our offers!',
          count: 50,
          receivers: ['Firm 1', 'Firm 2', 'Firm 3']
        }
      ],
      credits: 100
    },
    {
      name: 'User 3',
      mobile: '98765432103',
      otherNumbers: '7972726558, 8530412675',
      address: 'Nagpur',
      subscriptions: [],
      firms: [
        {
          name: 'Firm 3A',
          owner: 'User 3',
          address: 'Address 3A',
          district: 'Nagpur',
          gst: 'GST3A',
          image: ''
        },
        {
          name: 'Firm 3B',
          owner: 'User 3',
          address: 'Address 3B',
          district: 'Gondia',
          gst: 'GST3B',
          image: ''
        }
      ],
      credits: 0,
      messages: []
    },
    {
      name: 'User 4',
      mobile: '98765432104',
      otherNumbers: '7972726558, 8530412675',
      address: 'Nagpur',
      subscriptions: [
        {
          district: 'Nagpur',
          plan: 'Premium',
          startDate: '2024-08-01',
          endDate: '2025-08-01'
        }
      ],
      firms: [
        {
          name: 'Firm 4A',
          owner: 'User 4',
          address: 'Address 4A',
          district: 'Nagpur',
          gst: 'GST4A',
          image: ''
        },
        {
          name: 'Firm 4B',
          owner: 'User 4',
          address: 'Address 4B',
          district: 'Gondia',
          gst: 'GST4B',
          image: ''
        }
      ],
      messages: [
        {
          district: 'Nagpur',
          date: '2025-04-10',
          text: 'Check our offers!',
          count: 50,
          receivers: ['Firm 1', 'Firm 2', 'Firm 3']
        }
      ],
      credits: 150
    },
    {
      name: 'User 5',
      mobile: '98765432105',
      otherNumbers: '7972726558, 8530412675',
      address: 'Nagpur',
      subscriptions: [],
      firms: [
        {
          name: 'Firm 5A',
          owner: 'User 5',
          address: 'Address 5A',
          district: 'Nagpur',
          gst: 'GST5A',
          image: ''
        },
        {
          name: 'Firm 5B',
          owner: 'User 5',
          address: 'Address 5B',
          district: 'Gondia',
          gst: 'GST5B',
          image: ''
        }
      ],
      credits: 0,
      messages: []
    },
    {
      name: 'User 6',
      mobile: '98765432106',
      otherNumbers: '7972726558, 8530412675',
      address: 'Nagpur',
      subscriptions: [
        {
          district: 'Nagpur',
          plan: 'Basic',
          startDate: '2024-07-01',
          endDate: '2025-07-01'
        }
      ],
      firms: [
        {
          name: 'Firm 6A',
          owner: 'User 6',
          address: 'Address 6A',
          district: 'Nagpur',
          gst: 'GST6A',
          image: ''
        },
        {
          name: 'Firm 6B',
          owner: 'User 6',
          address: 'Address 6B',
          district: 'Gondia',
          gst: 'GST6B',
          image: ''
        }
      ],
      messages: [
        {
          district: 'Nagpur',
          date: '2025-04-10',
          text: 'Check our offers!',
          count: 50,
          receivers: ['Firm 1', 'Firm 2', 'Firm 3']
        }
      ],
      credits: 75
    },
    {
      name: 'User 7',
      mobile: '98765432107',
      otherNumbers: '7972726558, 8530412675',
      address: 'Nagpur',
      subscriptions: [],
      firms: [
        {
          name: 'Firm 7A',
          owner: 'User 7',
          address: 'Address 7A',
          district: 'Nagpur',
          gst: 'GST7A',
          image: ''
        },
        {
          name: 'Firm 7B',
          owner: 'User 7',
          address: 'Address 7B',
          district: 'Gondia',
          gst: 'GST7B',
          image: ''
        }
      ],
      credits: 0,
      messages: []
    },
    {
      name: 'User 8',
      mobile: '98765432108',
      otherNumbers: '7972726558, 8530412675',
      address: 'Nagpur',
      subscriptions: [
        {
          district: 'Nagpur',
          plan: 'Standard',
          startDate: '2024-04-01',
          endDate: '2025-04-01'
        }
      ],
      firms: [
        {
          name: 'Firm 8A',
          owner: 'User 8',
          address: 'Address 8A',
          district: 'Nagpur',
          gst: 'GST8A',
          image: ''
        },
        {
          name: 'Firm 8B',
          owner: 'User 8',
          address: 'Address 8B',
          district: 'Gondia',
          gst: 'GST8B',
          image: ''
        }
      ],
      messages: [
        {
          district: 'Nagpur',
          date: '2025-04-10',
          text: 'Check our offers!',
          count: 50,
          receivers: ['Firm 1', 'Firm 2', 'Firm 3']
        }
      ],
      credits: 100
    }
  ];


  searchTerm = '';
  selectedUser: any = null;
  editingFirm: any = null;
  editingUser: any = null;
  selectedMessage: any = null;

  filteredUsers() {
    const term = this.searchTerm.toLowerCase();
    return this.users.filter(user =>
      user.name.toLowerCase().includes(term) ||
      user.mobile.toLowerCase().includes(term)
    );
  }


  isSubscriptionActiveUserList(subscriptions: any[]): boolean {
    if (!subscriptions || subscriptions.length === 0) return false;

    const now = new Date();
    return subscriptions.some(sub => new Date(sub.endDate) >= now);
  }


  viewUser(user: any) {
    this.selectedUser = user;
    this.editingFirm = null;
    this.editingUser = null;
  }

  editUser(user: any) {
    this.editingUser = { ...user };
    this.selectedUser = null;
    this.editingFirm = null;
  }

  saveUser() {
    const index = this.users.findIndex(u => u.mobile === this.editingUser.mobile);
    if (index !== -1) {
      this.users[index] = this.editingUser;
    }
    this.cancelEditUser();
  }

  cancelEditUser() {
    this.editingUser = null;
  }

  deleteUser(user: any) {
    this.users = this.users.filter(u => u !== user);
    if (this.selectedUser === user) this.selectedUser = null;
  }

  viewFirmDetails(firm: any) {
    alert(`Firm: ${firm.name}, Owner: ${firm.owner}, District: ${firm.district}`);
  }

  editFirm(firm: any) {
    this.editingFirm = { ...firm };
  }

  cancelEdit() {
    this.editingFirm = null;
  }

  saveFirm() {
    const index = this.selectedUser.firms.findIndex((f: any) => f.name === this.editingFirm.name);
    if (index !== -1) {
      this.selectedUser.firms[index] = this.editingFirm;
    }
    this.cancelEdit();
  }

  // Subscription Helpers
  // hasActiveSubscription(user: any) {
  //   return user.subscriptions?.some(sub => new Date(sub.endDate) > new Date());
  // }
  //
  // hasAnySubscription(user: any) {
  //   return user.subscriptions?.length > 0;
  // }
  //
  // hasExpiredSubscription(user: any) {
  //   return user.subscriptions?.some(sub => new Date(sub.endDate) < new Date());
  // }

  isSubscriptionActive(sub: any) {
    return new Date(sub.endDate) > new Date();
  }

  isSubscriptionExpired(sub: any) {
    return new Date(sub.endDate) < new Date();
  }

  // Message logic
  getMessageDistricts(user: any) {
    return [...new Set(user.messages?.map((msg: any) => msg.district))];
  }

  getMessagesByDistrict(user: any, district: any) {
    return user.messages?.filter((msg: any) => msg.district === district);
  }

  openMessageDialog(message: any) {
    this.selectedMessage = message;
  }

  showActiveUsers(user: any) {
    alert(`Showing active subscription users for ${user.name}`);
    // Your logic for writch button
  }

  onImageChange(event: any) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.editingFirm.image = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }
}

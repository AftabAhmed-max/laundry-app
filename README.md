# Laundry Order Management App

A Flutter application to manage laundry service orders built with Provider state management and SQLite local database.

## Features
- View all laundry orders in a list
- Add new orders with auto-calculated total price
- Update order status: Received → Washing → Ready → Delivered
- Search orders by Customer Name or Order ID
- Filter orders by status
- Dashboard showing total orders and total revenue
- Delete orders with long press
- Form validation on all inputs

## Tech Stack
- **Framework:** Flutter & Dart
- **State Management:** Provider
- **Database:** SQLite via sqflite + sqflite_common_ffi
- **Platform:** Windows Desktop / Android

## Project Structure
lib/
├── models/        # Data models (LaundryOrder)
├── data/          # Database helper (SQLite operations)
├── logic/         # Provider (state management + business logic)
└── ui/
└── screens/   # UI screens (Orders List, Add Order, Dashboard)

## How to Run

### Prerequisites
- Flutter SDK 3.x
- Windows: Visual Studio Build Tools 2022 with C++ workload
- Android: Android SDK + emulator or physical device

### Steps
```bash
git clone https://github.com/AftabAhmed-max/laundry-app.git
cd laundry-app
flutter pub get
flutter run -d windows   # for Windows
flutter run              # for Android
```

## Database Structure

**Table: orders**

| Column | Type | Description |
|---|---|---|
| id | INTEGER (PK) | Auto-incremented order ID |
| customerName | TEXT | Customer full name |
| phoneNumber | TEXT | Customer phone number |
| serviceType | TEXT | Type of laundry service |
| numberOfItems | INTEGER | Number of items |
| pricePerItem | REAL | Price per item |
| totalPrice | REAL | numberOfItems × pricePerItem |
| status | TEXT | Received / Washing / Ready / Delivered |
| createdAt | TEXT | Order creation timestamp |

## Screenshots
_(Add screenshots here)_
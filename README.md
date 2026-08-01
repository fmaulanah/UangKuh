# 💰 UangKuh

> An **Offline-First Personal Finance** application built with **Flutter**, **Riverpod**, **Drift**, and **Firebase**.

UangKuh is a modern personal finance application designed for individuals and families. It supports offline usage with automatic local persistence while using Firebase as the cloud source of truth.

---

## ✨ Features

### 🔐 Authentication
- Firebase Authentication
- Email & Password Sign In
- User Registration
- Auto Login
- Logout

### ☁️ Cloud
- Cloud Firestore
- User Provisioning
- Household Provisioning
- Household Member Provisioning
- Session Bootstrap
- Offline-First Architecture

### 📱 Local Storage
- Drift (SQLite)
- Local Session
- Local Bootstrap
- Automatic Upsert
- Default Category Seeding

### 🌎 Localization
- English
- Bahasa Indonesia

---

# 🏗️ Architecture

The application follows **Clean Architecture**.

```
Presentation
      │
      ▼
Controller
      │
      ▼
Repository
      │
 ┌────┴────┐
 ▼         ▼
Firebase   Drift
      │
      ▼
SQLite
```

---

# 🚀 Tech Stack

| Technology | Description |
|------------|-------------|
| Flutter | Cross-platform Framework |
| Riverpod | State Management |
| Drift | SQLite ORM |
| Firebase Auth | Authentication |
| Cloud Firestore | Cloud Database |
| Go Router | Navigation |
| Material 3 | UI Framework |

---

# 📂 Project Structure

```
lib/
│
├── core/
│   ├── database/
│   ├── firebase/
│   ├── router/
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── auth/
│   ├── household/
│   ├── account/
│   ├── category/
│   ├── transaction/
│   └── profile/
│
└── main.dart
```

---

# 🔄 Current Flow

## Register

```
Firebase Auth
      │
      ▼
Create User
      │
      ▼
Create Household
      │
      ▼
Create Household Member
      │
      ▼
Update Default Household
      │
      ▼
Dashboard
```

---

## Login

```
Firebase Auth
      │
      ▼
Session Bootstrap
      │
      ▼
Firestore
      │
      ▼
SQLite (Drift)
      │
      ▼
Dashboard
```

---

# 🎯 Roadmap

## ✅ Phase 1
- Flutter Setup
- Project Structure
- Theme

## ✅ Phase 2
- Drift Database
- Repository Pattern
- Riverpod

## ✅ Phase 3
- Firebase Authentication
- Register
- Login
- Logout

## ✅ Phase 4
- Firestore Foundation
- User Provisioning
- Household Provisioning
- Session Bootstrap

## 🚧 Phase 5
- Accounts
- Categories
- Transactions
- Dashboard Improvements
- Cloud Synchronization

---

# 📸 Screenshots

Coming Soon...

---

# 🤝 Contributing

Pull requests are welcome.

For major changes, please open an issue first to discuss what you would like to change.

---

Made with ❤️ using Flutter.
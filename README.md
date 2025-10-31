# 👨‍⚕️ Hospital Management App – User Side

> **A patient-friendly mobile app built with Flutter & Firebase for booking doctor appointments, managing profiles, and uploading health documents.**

![Flutter](https://img.shields.io/badge/Flutter-Mobile-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Backend-yellow?logo=firebase)
![Cloudinary](https://img.shields.io/badge/Cloudinary-Storage-orange?logo=cloudinary)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

---

## ✨ Overview

The **Hospital Management User App** is a cross-platform mobile application developed using **Flutter** and **Firebase**.  
It allows patients to browse doctors, book appointments, upload medical documents, and track their appointments in real-time.  

This app is the **user-side module** of the hospital management ecosystem and works seamlessly with the **Admin Panel** and **Doctor App**.

---

## 📋 Table of Contents

- [🚀 Features](#-features)
- [👤 User Authentication](#-user-authentication)
- [🛠️ Tech Stack](#-tech-stack)
- [⚙️ Installation](#️-installation)
- [📦 Configuration](#-configuration)
- [💻 Usage](#-usage)
- [📷 Screenshots](#-screenshots)
- [🧩 Troubleshooting](#-troubleshooting)
- [🙋 Contributors](#-contributors)
- [📝 License](#-license)

---

## 🚀 Features

✅ User registration and login via **Firebase Auth**  
✅ Browse verified doctors with detailed profiles  
✅ Search and filter doctors by specialization or name  
✅ Book, view, and cancel appointments  
✅ Upload health documents (PDF/images) via **Cloudinary**  
✅ Responsive and modern UI using **Material 3**  
✅ Real-time updates on appointment status  
✅ Notifications for appointment confirmations (if implemented)  

---

## 👤 User Authentication

> Easy, secure, and privacy-first.

- Authentication is handled using **Firebase Authentication** (Email / Google Sign-In).  
- Each user has a unique account linked to their **appointments and documents**.  
- Users can update their **profile information** and view **appointment history**.  

---

## 🛠️ Tech Stack

| Layer        | Technology                  |
|--------------|-----------------------------|
| Frontend     | Flutter (Dart)              |
| State Mgmt   |  Bloc                       |
| Backend/Auth | Firebase Authentication     |
| Database     | Firebase Firestore          |
| File Storage | Cloudinary                  |

---

## ⚙️ Installation

### 1. Clone the Repository

```bash
git clone https://github.com/AkashMaroli/hospitalManagementUser#1-clone-the-repository

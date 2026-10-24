<img width="1214" height="1295" alt="image" src="https://github.com/user-attachments/assets/89e2f7ef-cc8b-4763-b01f-19ccbf755c7b" /><img width="1214" height="1295" alt="image" src="https://github.com/user-attachments/assets/8dadd88a-dd64-43ea-b893-2de36150978b" /><img width="1214" height="1295" alt="image" src="https://github.com/user-attachments/assets/a5a67d88-76cc-44c9-a814-9b28a7818596" /># 💜 QR Studio

### Create. Customize. Save. Share.

**QR Studio** is a Flutter-based QR code generator application developed as part of my internship at **Auspify**. It is designed to make creating and managing QR codes simple, convenient, and visually appealing.

From generating QR codes from text and URLs to customizing their appearance, QR Studio brings essential QR code tools together in one application.

---

## ✨ Features

- **QR Code Generation** — Generate QR codes from text and URLs.
- **QR Customization** — Customize QR code colors and styles.
- **Logo Personalization** — Add a logo to the center of a QR code.
- **Save to Gallery** — Save QR code images to your device.
- **Share QR Codes** — Share QR codes with others.
- **QR History** — Access previously generated QR codes.
- **Saved QR Codes** — Keep frequently used QR codes organized.
- **Custom UI** — A clean interface featuring a lavender and purple visual theme.
- **Splash Screen** — A branded introduction to the app.
- **Success Screen** — Feedback after successfully saving a customized QR code.

*Note: Feature availability depends on the current implementation and platform support.*

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| `qr_flutter` | QR code rendering |
| `image_picker` | Selecting images for logo customization |
| `gal` | Saving images to the device gallery |
| `share_plus` | Sharing content |
| `shared_preferences` | Local data persistence |

---

## 🎨 Design

QR Studio uses a consistent lavender and purple color palette with rounded components, simple icons, and a user-friendly layout.

The design aims to make QR code generation and customization accessible while keeping the experience clean and intuitive.

---

## 📱 App Screens

Screens included in the project:

1. Splash Screen
2. Home Screen
3. QR Preview Screen
4. Customize QR Screen
5. History Screen
6. Saved QR Codes Screen
7. Success Screen

---

## 🚀 Getting Started

### Prerequisites

Before running the project, install:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Visual Studio Code](https://code.visualstudio.com/) or Android Studio

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/YOUR-USERNAME/QR-Studio.git
```

**2. Open the project directory**

```bash
cd QR-Studio
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Run the application**

```bash
flutter run
```

---

## 📂 Project Structure

```text
lib/
├── models/
│   └── qr_item.dart
├── screens/
│   ├── home_screen.dart
│   ├── qr_preview_screen.dart
│   ├── customize_qr_screen.dart
│   ├── history_screen.dart
│   ├── saved_screen.dart
│   ├── splash_screen.dart
│   ├── success_screen.dart
│   └── main_navigation_screen.dart
├── services/
│   ├── qr_service.dart
│   └── storage_service.dart
├── theme/
│   └── app_theme.dart
└── main.dart
```

---

## 💡 What I Learned

Working on QR Studio during my internship at Auspify has given me an opportunity to practice Flutter development, organize application code into separate components, work with packages, and focus on UI/UX design.

It has also helped me understand how individual screens and services come together to create a complete mobile application.

---

## 🔮 Future Improvements

- Additional QR design and styling options
- Improved QR code organization and management
- More customization options
- Further UI/UX refinements

---

## 👩‍💻 Developer

**Developed during my internship at Auspify**

This project represents my continued learning and growth in Flutter application development.

---


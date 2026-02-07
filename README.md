# 🛒 GroceryTracka
GroceryTracka is a simple and smart iOS app that helps users manage grocery lists and discover recipes based on the ingredients they already have. Built with Swift, SwiftUI, and Core Data, it keeps shopping organized and makes meal planning easier than ever.

---

## ✨ Features

### 📝 Grocery Lists
- Add items with **name**, **quantity/measurement**, and **category**
- Categories help automatically **sort** your list for easier shopping
- Quickly update or remove items as you shop

### 🍽️ Recipe Discovery
- Uses **TheMealDB API** to fetch recipes  
- Finds recipes based on **ingredients already in your list**
- View recipe details and **instantly add missing ingredients** to your grocery list

### 💾 Local Storage
- All data is stored using **Core Data**
- Your lists and items persist across app launches

---

## 🧰 Tech Stack
- **Swift**
- **SwiftUI**
- **Core Data**
- **URLSession** for API calls
- **TheMealDB API** for recipe search

---

## 📱 Platform
- **iOS app**
- Built for iPhone using SwiftUI

## 🚀 Getting Started

Follow these steps to build and run GroceryTracka on your local machine.

### **Prerequisites**
Before you begin, make sure you have:

- **Xcode 15+**
- **iOS 17+** simulator or physical device
- macOS capable of running Xcode
- Internet connection (required for TheMealDB API)

---

### **1. Clone the repository**
```bash
git clone https://github.com/yourusername/GroceryTracka.git
cd GroceryTracka
```

### **2. Open the project in Xcode**
Open the project by double‑clicking:
GroceryTracka.xcodeproj

Or from Xcode:
File → Open → GroceryTracka.xcodeproj

### **3. Build & Run the app**
- Select an iPhone simulator (e.g., *iPhone 15*)
- Press **Run** (⌘ + R)

### **4. API Usage**
GroceryTracka uses **TheMealDB** to fetch recipes based on ingredients:

No API key is required.

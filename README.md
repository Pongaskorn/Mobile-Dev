## การรันใช้ค่ำสั่ง 
flutter clean 
flutter pub get
## ก่อนรันต้อง 
flutter clean  ใช้สำหรับ ลบไฟล์ build เก่า ๆ และ cache ที่ Flutter เก็บไว้
flutter pub get ใช้สำหรับ ดึง dependencies (package / library) เวลาเราเพิ่ม package ใหม่ ที่ระบุไว้ในไฟล์ pubspec.yaml	 

## ถ้าอยากรันใน Chrome ใช้คำสั่ง 
flutter run -d chrome 

## ถ้าอยากรันใน  emulators ต้องเช็คว่าเรา มี emulatorตัวไหนบ้าง
- ใช้คำสั่ง flutter emulators เครื่องผมคือ nexus_api30
- ใช้คำสั่ง emulator -avd nexus_api30 หรือ emulator -avd nexus_api30 -scale 0.5 -no-snapshot-load  เพื่อเปิด emulators
## ต่อไป เปิด cmd ใหม่อีกตัวเพื่อเปิดงานของเรา
- ใช้คำสั่ง flutter run
## เช็ค Emulator ที่กำลังรันอยู่
- flutter devices
## ถ้าเปิด emulator แล้ว Error ลองใช้คำสั่ง 
- emulator -avd nexus_api30 -gpu swiftshader_indirect

** ข้อกำหนดคือ ** 
- อนุญาตให้ผู้ใช้แก้ไขชื่อทีมและบันทึกโดยใช้ GetStorage
- เพิ่มภาพหรือภาพเคลื่อนไหวเมื่อเลือก/ยกเลิกการเลือกโปเกมอน
- คงข้อมูลทีมทั้งหมด (ชื่อ + รูปภาพ) ไว้ เพื่อให้โหลดเมื่อแอปรีสตาร์ท
- เพิ่มปุ่ม "รีเซ็ตทีม" เพื่อล้างการเลือก
- เพิ่มแถบค้นหาเพื่อกรองโปเกมอนในรายการ


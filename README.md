# Akhada Gym — Gym Management System

**Akhada Gym** is a simple web-based Gym Management System built with **Java (Servlets/JSP)**, **MySQL**, and **BCrypt** for secure password hashing. The project includes member registration with email confirmation, login, profile/dashboard, and a secure password reset flow (security-question or OTP options).

---

## 🚀 Features

**Member**
- Member registration with auto-generated `member_id`
- Email confirmation on successful registration
- Secure password storage using **BCrypt**
- Login using email + password
- Member profile page (view details and admin messages)
- Edit profile (name, phone, optional password change)

**Security**
- BCrypt password hashing (no plaintext storage)
- Email validation and duplicate-email check
- XSS-safe output in JSP (`<c:out>` usage recommended)
- (Optional) Forgot password via security question or OTP

---

## 🧰 Tech Stack

- **Language:** Java
- **Web:** JSP, Servlets, Jakarta Mail (Jakarta / JavaMail)
- **Database:** MySQL
- **Server:** Glashfish server (any servlet container will work)
- **Password hashing:** BCrypt (`org.mindrot.jbcrypt.BCrypt`)
- **Build / IDE:** Can be used with IntelliJ IDEA, Eclipse, NetBeans or Maven/Gradle

---

## 📁 Repo Structure (recommended)

Gym-Management-System/
├─ src/
│ ├─ main/
│ │ ├─ java/
│ │ │ ├─ com/yourorg/servlets/ (Register.java, Login.java, EditServ.java, ForgotPasswordServ.java, ...)
│ │ └─ webapp/
│ │ ├─ WEB-INF/
│ │ │ └─ web.xml
│ │ ├─ Register.jsp
│ │ ├─ Login.jsp
│ │ ├─ Profile.jsp
│ │ ├─ EditProfile.jsp
│ │ └─ ForgotPassword.jsp
├─ sql/
│ └─ schema.sql
├─ README.md
└─ pom.xml (optional)


---

## ⚙️ Database (MySQL) — create schema

Create the database and `members` table (example):


CREATE DATABASE IF NOT EXISTS gym_management;
USE gym_management;

CREATE TABLE IF NOT EXISTS members (
  member_id VARCHAR(10) PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20),
  password VARCHAR(255),
  join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional messages table (admin -> member messaging)
CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  member_id VARCHAR(10),
  message_text TEXT,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

---

### 🔁 Typical Flows

#### 📝 Registration
- User fills **Register.jsp**
- Register servlet validates input & checks duplicate email
- Generates **member_id**
- Password is **hashed (BCrypt)** and inserted into DB
- Confirmation email (optional) is sent

#### 🔑 Login
- User enters email & password
- Login servlet retrieves **hashed password** from DB
- Uses **BCrypt.checkpw** to validate
- On success → create session:
  java
  session.setAttribute("email", email);
  session.setAttribute("member_id", memberId);

---

#### 🧑‍💻 Author

Ziyad Ahmad — Student/Developer

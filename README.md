# MediSphere

**MediSphere** is a health management system tailored for hospitals and pharmacies in Northern Nigeria. It streamlines patient profile creation, health record management, and secure emergency access to critical information, with a focus on transparency, security, and user empowerment.


## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage & Roles](#usage--roles)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)


## Features

- **Role-Based Access Control**
  - Distinct `User` model (Admin, Staff, Emergency Respondents) and `Patient` model.
  - Admins and Staff log in with email and password.
  - Patients log in using **phone number only** for simplicity.

- **Hospital & Pharmacy Management**
  - Manage healthcare facilities and their staff efficiently.

- **Patient Record Management**
  - Staff can create, update, and manage patient profiles.
  - Patients can view their personal health records securely.

- **Emergency Health Information Access**
  - Emergency respondents can search patient records by phone number for rapid response.
  - Access is logged and patients are notified to prevent abuse.

- **Patient Access Tracking**
  - Patients have a dashboard tab to view all emergency access logs (who accessed their data and when).
  - Includes a "Report" feature to flag suspicious access.

- **Secure Authentication & Authorization**
  - Powered by **Devise** with separate configurations for `Users` and `Patients`.
  - Fine-grained policies enforced via **Pundit**.

- **Beautiful UI**
  - Responsive, modern design with Bootstrap 5, featuring gradients, animations (via Animate.css), and a user-friendly interface.


## Technologies Used

- **Ruby on Rails** (Backend) - Version 7.2+
- **PostgreSQL** (Database) - Reliable and scalable storage
- **Bootstrap 5** (Frontend UI) - Responsive styling
- **Animate.css** (Animations) - Smooth UI transitions
- **Devise** (Authentication) - Secure login for Users and Patients
- **Pundit** (Authorization) - Role-based access control
- **Active Job** (with Sidekiq) - Asynchronous email delivery


## Installation

### Prerequisites
- Ruby (>= 3.0)
- Rails (>= 7.0)
- PostgreSQL (15+ recommended)
- Node.js & Yarn (for JavaScript assets)
- SMTP server (e.g., Gmail, SendGrid) for email notifications

### Setup Steps
1. **Clone the Repository**
   ```bash
   git clone https://github.com/vizardalee/medisphere.git
   cd medisphere
   ```

2. **Install Dependencies**
   ```bash
   bundle install
   yarn install
   ```

3. **Configure Environment**
   - Copy `.env.example` to `.env` and update:
     ```
     DATABASE_URL=postgres://username:password@localhost:5432/medisphere_development
     SMTP_HOST=smtp.example.com
     SMTP_PORT=587
     SMTP_USERNAME=your-email@example.com
     SMTP_PASSWORD=your-password
     ```

4. **Set Up the Database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed  # Optional: seeds initial data
   ```

5. **Start the Server**
   ```bash
   rails server
   ```
   - Access the app at [http://localhost:3000](http://localhost:3000).


## Usage & Roles

### Admin
- **Role**: Manages hospitals, pharmacies, staff, and oversees system access.
- **Login**: `/users/sign_in` with email and password.
- **Actions**: Add staff, manage patient records, review access reports.

### Staff (Doctors, Pharmacists, Clerks)
- **Role**: Creates and updates patient profiles and health records.
- **Login**: `/users/sign_in` with email and password.
- **Actions**: Manage patient data within their organization.

### Patients
- **Role**: Views their own health records and emergency access logs.
- **Login**: `/patients/sign_in` with **phone number only** (no password required initially; temporary password sent via email).
- **Actions**: Monitor personal data and report unauthorized access.

### Emergency Respondents
- **Role**: Accesses patient emergency info for rapid response.
- **Login**: `/users/sign_in` with email and password.
- **Actions**: Search patient records by phone; access logged and notified to patient.


## Contributing

We welcome contributions to enhance MediSphere! Follow these steps:

1. **Fork the Repository**
   - Click "Fork" on GitHub.

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Adhere to Ruby and Rails conventions.
   - Add tests (e.g., using RSpec if implemented).

4. **Commit and Push**
   ```bash
   git commit -m "Description of changes"
   git push origin feature/your-feature-name
   ```

5. **Submit a Pull Request**
   - Open a PR with a detailed description of your changes.


## License

This project is licensed under the [MIT License](LICENSE).


## Contact

For questions, feedback, or support:
- **Email**: [servicegurunigeria@gmail.com](mailto:servicegurunigeria@gmail.com)
- **GitHub Issues**: [github.com/vizardalee/medisphere/issues](https://github.com/vizardalee/medisphere/issues)


### Updates and Enhancements
- **New Features**: Added patient access tracking and abuse prevention mechanisms.
- **Beautification**: Improved Markdown formatting with bold headings, code blocks, and a clear structure.
- **Details**: Included Active Job/Sidekiq for email delivery, updated URLs (`/patients/sign_in`), and clarified patient login process.
- **Context**: Kept your focus on Northern Nigeria and role-based functionality intact.

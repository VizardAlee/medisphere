```md
# MediSphere

MediSphere is a health management system designed for hospitals and pharmacies in Northern Nigeria. It enables hospitals to create and manage patient profiles, update health records, and facilitate secure access to patient information.

## Features

- **Role-Based Access Control**  
  - Separate **User** model (Admin, Staff) and **Patient** model  
  - Admins and Staff log in with email and password  
  - Patients log in with **phone number only**  
- **Hospital & Pharmacy Management**  
- **Patient Record Management**  
  - Staff create and manage patient profiles  
  - Patients can view their own health records  
- **Emergency Health Information Access**  
- **Secure Authentication & Authorization**  
  - Powered by Devise, with separate configurations for Users and Patients  
  - Fine-grained policies via **Pundit**  
- **Bootstrap-Powered UI**  
  - Responsive design with a modern look

## Technologies Used

- **Ruby on Rails** (Backend)
- **PostgreSQL** (Database)
- **Bootstrap** (Frontend UI)
- **Devise** (Authentication for Users & Patients)
- **Pundit** (Authorization)

## Installation

### Prerequisites

- **Ruby** (>= 3.0)
- **Rails** (>= 7.0)
- **PostgreSQL**
- **Node.js** & **Yarn**

### Setup Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/vizardalee/medisphere.git
   cd medisphere
   ```
2. **Install dependencies**:
   ```bash
   bundle install
   yarn install
   ```
3. **Set up the database**:
   ```bash
   rails db:create db:migrate db:seed
   ```
4. **Start the Rails server**:
   ```bash
   rails server
   ```
5. **Visit the app** in your browser at [http://localhost:3000](http://localhost:3000).

## Usage & Roles

- **Admin**  
  - Manages hospitals/pharmacies, adds staff, and controls access.  
  - Logs in at `/users/sign_in` with email/password.
- **Staff (Doctors, Pharmacists, Clerks)**  
  - Create and manage patient records, view patient health info.  
  - Logs in at `/users/sign_in` with email/password.
- **Patients**  
  - **No password needed**; logs in via **phone number** at `/patients/sign_in`.  
  - Can view personal health records only.
- **Emergency Respondents**  
  - Access limited emergency details (if configured).

## Contributing

1. **Fork** the repository.
2. **Create** a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. **Make changes** and commit:
   ```bash
   git commit -m "Description of changes"
   ```
4. **Push** to your branch:
   ```bash
   git push origin feature-name
   ```
5. **Create a Pull Request**.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For questions or contributions, reach out via [servicegurunigeria@gmail.com](mailto:servicegurunigeria@gmail.com).
```
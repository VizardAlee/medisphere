# MediSphere

MediSphere is a health management system designed for hospitals and pharmacies in Northern Nigeria. It enables hospitals to create and manage client profiles, update health records, and facilitate access to patient health information.

## Features

- **Role-Based Access Control** using Pundit
- **Hospital & Pharmacy Management**
- **Patient Record Management**
- **Emergency Health Information Access**
- **Secure Authentication & Authorization**
- **Bootstrap-powered UI**

## Technologies Used

- **Ruby on Rails** (Backend)
- **PostgreSQL** (Database)
- **Bootstrap** (Frontend UI)
- **Pundit** (Authorization)

## Installation

### Prerequisites

Ensure you have the following installed:

- Ruby (>= 3.0)
- Rails (>= 7.0)
- PostgreSQL
- Node.js & Yarn

### Setup Steps

1. Clone the repository:
   ```sh
   git clone https://github.com/vizardalee/medisphere.git
   cd medisphere
   ```
2. Install dependencies:
   ```sh
   bundle install
   yarn install
   ```
3. Set up the database:
   ```sh
   rails db:create db:migrate db:seed
   ```
4. Start the server:
   ```sh
   rails server
   ```

## Usage

- **Admin**: Manages hospital or pharmacy details, adds staff, and controls access.
- **Staff**: Doctors, pharmacists, and clerks who manage patient records.
- **Patients**: View personal health records.
- **Emergency Respondents**: Access patient emergency details.

## Contributing

1. Fork the repository.
2. Create a feature branch:
   ```sh
   git checkout -b feature-name
   ```
3. Make changes and commit:
   ```sh
   git commit -m "Description of changes"
   ```
4. Push to your branch:
   ```sh
   git push origin feature-name
   ```
5. Create a Pull Request.

## License

This project is licensed under the MIT License.

## Contact

For questions or contributions, reach out via [servicegurunigeria@gmail.com](mailto\:servicegurunigeria@gmail.com).


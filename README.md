# Car Booking System

<div align="center">

[![Licence: MIT](https://img.shields.io/badge/Licence-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg)](https://www.postgresql.org/)
[![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)

**A modern car rental management system with web interface**

[Installation](#installation) • [Features](#features) • [Documentation](#api-documentation) • [Contributing](#contributing)

</div>

---

A comprehensive SQL solution for car hire companies to manage vehicle bookings, customer data, and rental operations. Features a modern web interface for easy management and real-time availability tracking.

### Quick Start

```bash
git clone https://github.com/AL-Kaisi/CarBookingSystem.git
cd CarBookingSystem
docker-compose up -d
```

Access the system at: http://localhost:3000

## Table of Contents

- [Overview](#overview)
- [Screenshots](#screenshots)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Database Schema](#database-schema)
- [Installation](#installation)
- [Usage](#usage)
- [API Documentation](#api-documentation)
- [Technology Stack](#technology-stack)
- [Contributing](#contributing)
- [Licence](#licence)

## Overview

The Car Booking System is a complete car rental management solution built with PostgreSQL and Node.js. It provides both a powerful database backend and an intuitive web interface for managing customers, vehicles, bookings, and generating reports.

## Screenshots

### Dashboard
![Dashboard Screenshot](docs/screenshots/dashboard.png)
*Main dashboard showing system statistics and recent bookings*

### Customer Management
![Customer Management Screenshot](docs/screenshots/customers.png)
*Customer list with search functionality*

### Vehicle Management
![Vehicle Management Screenshot](docs/screenshots/vehicles.png)
*Vehicle inventory and availability checking*

### Booking Process
![Booking Process Screenshot](docs/screenshots/booking.png)
*Step-by-step booking creation with real-time availability*

### Reports
![Reports Screenshot](docs/screenshots/reports.png)
*Revenue reports with visual charts*

## Features

### Core Functionality
- **Customer Management**: Register, search, and track customer information
- **Vehicle Management**: Maintain fleet inventory with categories and pricing
- **Booking System**: Create, modify, and cancel reservations
- **Availability Checking**: Real-time vehicle availability verification
- **Reporting**: Generate revenue reports with visual analytics
- **Web Interface**: Modern browser-based management dashboard

### Technical Features
- **Modular Architecture**: Organised function structure for maintainability
- **Data Integrity**: Business rules enforced through triggers
- **Performance**: Optimised queries with strategic indexing
- **Security**: Input validation and parameterised queries
- **Containerisation**: Docker support for easy deployment
- **RESTful Design**: Clean API structure for extensibility

### Feature Comparison

| Feature | Car Booking System | Traditional Systems |
|---------|-------------------|-------------------|
| **Database** | PostgreSQL (Free) | Oracle (Licensed) |
| **Deployment** | Docker (1 command) | Manual setup |
| **Web Interface** | Included | Separate purchase |
| **API** | RESTful | Legacy |
| **Real-time Updates** | Yes | Limited |
| **Cost** | Free | Expensive |
| **Open Source** | Yes | No |
| **Scalability** | Horizontal | Limited |

### Key Metrics

| Metric | Value |
|--------|-------|
| **Setup Time** | < 5 minutes |
| **Database Tables** | 7 |
| **Core Functions** | 12 |
| **API Endpoints** | 8 |
| **Lines of Code** | ~3,000 |
| **Container Size** | < 500MB |
| **Memory Usage** | < 256MB |
| **Response Time** | < 100ms |

## System Architecture

### Component Architecture

```mermaid
graph TB
    subgraph "Frontend Layer"
        UI[Web Browser]
        CSS[Stylesheets]
        JS[JavaScript]
    end

    subgraph "Presentation Layer"
        VIEWS[EJS Templates]
        STATIC[Static Assets]
    end

    subgraph "Application Layer"
        EXPRESS[Express Server]
        ROUTES[Route Handlers]
        CTRL[Controllers]
        MW[Middleware]
    end

    subgraph "Data Access Layer"
        POOL[Connection Pool]
        QUERY[Query Builder]
    end

    subgraph "Database Layer"
        PG[(PostgreSQL)]
        FUNC[Functions]
        TRIG[Triggers]
        VIEWS_DB[Database Views]
    end

    UI --> VIEWS
    UI --> CSS
    UI --> JS

    VIEWS --> EXPRESS
    STATIC --> EXPRESS

    EXPRESS --> ROUTES
    ROUTES --> CTRL
    EXPRESS --> MW

    CTRL --> POOL
    POOL --> QUERY
    QUERY --> PG

    PG --> FUNC
    PG --> TRIG
    PG --> VIEWS_DB

    style UI fill:#f9f,stroke:#333,stroke-width:2px
    style EXPRESS fill:#bbf,stroke:#333,stroke-width:2px
    style PG fill:#bfb,stroke:#333,stroke-width:2px
```

### Layered Architecture

```mermaid
graph TB
    subgraph "Client Layer"
        UI[Web Browser]
    end

    subgraph "Application Layer"
        WEB[Node.js/Express Server]
        API[RESTful API]
    end

    subgraph "Data Layer"
        DB[(PostgreSQL Database)]
        FUNC[Stored Functions]
        TRIG[Triggers]
    end

    UI --> WEB
    WEB --> API
    API --> DB
    DB --> FUNC
    DB --> TRIG

    style UI fill:#f9f,stroke:#333,stroke-width:2px
    style WEB fill:#bbf,stroke:#333,stroke-width:2px
    style DB fill:#bfb,stroke:#333,stroke-width:2px
```

## Database Schema

### Class Diagram

```mermaid
classDiagram
    class Customer {
        +INTEGER customer_id
        +VARCHAR cust_forename
        +VARCHAR cust_surname
        +CHAR gender
        +VARCHAR email_address
        +VARCHAR phone_number
        +VARCHAR address_line1
        +VARCHAR town
        +VARCHAR post_code
        +VARCHAR country
        +TIMESTAMP created_date
        +TIMESTAMP last_updated
        +checkCustomer()
        +createCustomer()
    }

    class Vehicle {
        +VARCHAR reg_number
        +VARCHAR manufacturer_code
        +VARCHAR model_code
        +VARCHAR vehicle_category_code
        +INTEGER current_mileage
        +DECIMAL daily_hire_rate
        +DATE date_mot_due
        +TIMESTAMP created_date
        +TIMESTAMP last_updated
        +checkAvailability()
        +updateMileage()
    }

    class Booking {
        +INTEGER booking_id
        +VARCHAR booking_status_code
        +INTEGER customer_id
        +VARCHAR reg_number
        +DATE date_from
        +DATE date_to
        +DECIMAL total_cost
        +TIMESTAMP created_date
        +TIMESTAMP last_updated
        +createBooking()
        +updateStatus()
        +calculateCost()
    }

    class VehicleCategory {
        +VARCHAR vehicle_category_code
        +VARCHAR vehicle_category_description
    }

    class BookingStatus {
        +VARCHAR booking_status_code
        +VARCHAR booking_status_description
    }

    class Model {
        +VARCHAR model_code
        +VARCHAR manufacturer_code
        +VARCHAR model_name
        +DECIMAL daily_hire_rate
    }

    class Manufacturer {
        +VARCHAR manufacturer_code
        +VARCHAR manufacturer_name
    }

    Customer "1" --> "*" Booking : places
    Vehicle "1" --> "*" Booking : reserved in
    Vehicle "*" --> "1" VehicleCategory : belongs to
    Vehicle "*" --> "1" Model : is a
    Model "*" --> "1" Manufacturer : made by
    Booking "*" --> "1" BookingStatus : has
```

### Entity Relationship Diagram

```mermaid
erDiagram
    CUSTOMER ||--o{ BOOKING : places
    VEHICLE ||--o{ BOOKING : reserved
    MANUFACTURER ||--o{ MODEL : produces
    MODEL ||--o{ VEHICLE : instance_of
    VEHICLE_CATEGORY ||--o{ VEHICLE : categorises
    BOOKING_STATUS ||--o{ BOOKING : has_status

    CUSTOMER {
        INTEGER customer_id PK
        VARCHAR cust_forename
        VARCHAR cust_surname
        CHAR gender
        VARCHAR email_address UK
        VARCHAR phone_number
        VARCHAR address_line1
        VARCHAR town
        VARCHAR post_code
        VARCHAR country
        TIMESTAMP created_date
        TIMESTAMP last_updated
    }

    VEHICLE {
        VARCHAR reg_number PK
        VARCHAR manufacturer_code FK
        VARCHAR model_code FK
        VARCHAR vehicle_category_code FK
        INTEGER current_mileage
        DECIMAL daily_hire_rate
        DATE date_mot_due
        TIMESTAMP created_date
        TIMESTAMP last_updated
    }

    BOOKING {
        INTEGER booking_id PK
        VARCHAR booking_status_code FK
        INTEGER customer_id FK
        VARCHAR reg_number FK
        DATE date_from
        DATE date_to
        DECIMAL total_cost
        TIMESTAMP created_date
        TIMESTAMP last_updated
    }

    MANUFACTURER {
        VARCHAR manufacturer_code PK
        VARCHAR manufacturer_name
    }

    MODEL {
        VARCHAR model_code PK
        VARCHAR manufacturer_code FK
        VARCHAR model_name
        DECIMAL daily_hire_rate
    }

    VEHICLE_CATEGORY {
        VARCHAR vehicle_category_code PK
        VARCHAR vehicle_category_description
    }

    BOOKING_STATUS {
        VARCHAR booking_status_code PK
        VARCHAR booking_status_description
    }
```

### Data Flow Diagram

```mermaid
flowchart LR
    subgraph "User Actions"
        A[Customer Registration]
        B[Vehicle Selection]
        C[Booking Creation]
        D[Status Updates]
    end

    subgraph "Business Logic"
        E[Validate Customer]
        F[Check Availability]
        G[Calculate Pricing]
        H[Update Records]
    end

    subgraph "Database Operations"
        I[Insert/Update Customer]
        J[Query Vehicles]
        K[Create Booking]
        L[Log Changes]
    end

    A --> E --> I
    B --> F --> J
    C --> G --> K
    D --> H --> L

    style A fill:#f96,stroke:#333,stroke-width:2px
    style B fill:#f96,stroke:#333,stroke-width:2px
    style C fill:#f96,stroke:#333,stroke-width:2px
    style D fill:#f96,stroke:#333,stroke-width:2px
```

### Deployment Architecture

```mermaid
graph TB
    subgraph "Docker Environment"
        subgraph "Container: carbooking_web"
            WEB[Node.js Application<br/>Port: 3000]
        end

        subgraph "Container: carbooking_db"
            DB[PostgreSQL Database<br/>Port: 5432]
            FUNC[Stored Functions]
            TRIG[Triggers]
        end

        subgraph "Docker Network"
            NET[carbooking_network]
        end
    end

    subgraph "Host System"
        VOL[docker volume:<br/>postgres_data]
        CONF[Configuration Files]
    end

    BROWSER[Web Browser<br/>http://localhost:3000]

    BROWSER --> WEB
    WEB --> NET
    NET --> DB
    DB --> VOL
    CONF --> WEB
    CONF --> DB

    style BROWSER fill:#f9f,stroke:#333,stroke-width:2px
    style WEB fill:#bbf,stroke:#333,stroke-width:2px
    style DB fill:#bfb,stroke:#333,stroke-width:2px
    style NET fill:#ffd,stroke:#333,stroke-width:2px
```

### Sequence Diagram: Booking Process

```mermaid
sequenceDiagram
    participant U as User
    participant W as Web Interface
    participant S as Express Server
    participant D as Database
    participant F as Functions

    U->>W: Navigate to New Booking
    W->>U: Display booking form

    U->>W: Enter customer details
    U->>W: Select vehicle type & dates
    U->>W: Click "Check Availability"

    W->>S: POST /bookings/check-availability
    S->>D: Query available_vehicles()
    D->>F: Execute function
    F-->>D: Return available vehicles
    D-->>S: Vehicle results
    S-->>W: JSON response
    W->>U: Display available vehicles

    U->>W: Submit booking
    W->>S: POST /bookings/create
    S->>D: Call make_booking()
    D->>F: Validate customer
    D->>F: Check availability
    D->>F: Create booking
    F-->>D: Booking created
    D-->>S: Success response
    S-->>W: Redirect to bookings
    W->>U: Show success message
```

## Installation

### Prerequisites
- Docker and Docker Compose (recommended)
- OR PostgreSQL 13+ and Node.js 16+

### Quick Start with Docker

1. Clone the repository:
```bash
git clone https://github.com/AL-Kaisi/CarBookingSystem.git
cd CarBookingSystem
```

2. Start the complete system:
```bash
docker-compose up -d
```

3. Access the web interface:
```
http://localhost:3000
```

That's it! The system is now running with both database and web interface.

### Manual Installation

#### Database Setup

1. Create database:
```bash
createdb carbooking
```

2. Install schema:
```bash
psql -d carbooking -f scripts/install-complete.sql
```

3. Load sample data (optional):
```bash
psql -d carbooking -f sql/data/sample_data.sql
```

#### Web Interface Setup

1. Install dependencies:
```bash
cd web
npm install
```

2. Configure environment:
```bash
cp .env.example .env
# Edit .env with your database credentials
```

3. Start the server:
```bash
npm start
```

## Usage

### Web Interface Features

#### Dashboard
- View system statistics
- Monitor recent bookings
- Quick access to common actions

#### Customer Management
- Add new customers
- Search existing customers
- View booking history
- Update customer details

#### Vehicle Management
- Add vehicles to fleet
- Update vehicle information
- Check MOT dates
- Monitor mileage

#### Booking System
- Create new bookings
- Check availability in real-time
- Modify existing bookings
- Update booking status

#### Reporting
- Monthly revenue reports
- Visual charts and graphs
- Export data to CSV

### Database Operations

Connect to the database:
```bash
docker exec -it carbooking_db psql -U carbooking -d carbooking
```

Example queries:
```sql
-- Check available vehicles
SELECT * FROM available_vehicles('SUV', '2025-07-01', '2025-07-05');

-- Create a booking
SELECT make_booking(
    NULL, 'John', 'Smith', 'M',
    'john.smith@example.co.uk', '020-7946-0123',
    '123 High Street', NULL, NULL,
    'London', 'SW1A 1AA', 'UK',
    'SUV', '2025-07-01'::DATE, '2025-07-05'::DATE,
    'confirmed'
);

-- Generate revenue report
SELECT * FROM revenue_report();
```

## API Documentation

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Dashboard |
| GET | `/customers` | List customers |
| POST | `/customers/create` | Create customer |
| GET | `/vehicles` | List vehicles |
| POST | `/vehicles/create` | Add vehicle |
| GET | `/bookings` | List bookings |
| POST | `/bookings/create` | Create booking |
| GET | `/reports` | View reports |

### Database Functions

| Function | Description |
|----------|-------------|
| `customer_check()` | Verify customer existence |
| `create_customer()` | Register new customer |
| `check_cars()` | Check vehicle availability |
| `make_booking()` | Create complete booking |
| `update_booking()` | Modify booking status |
| `available_vehicles()` | List available vehicles |
| `revenue_report()` | Generate revenue report |

## Technology Stack

### Backend
- **Database**: PostgreSQL 13+
- **Language**: PL/pgSQL for stored procedures
- **Server**: Node.js with Express
- **ORM**: Native PostgreSQL driver

### Frontend
- **Templating**: EJS
- **Styling**: Custom CSS
- **JavaScript**: Vanilla JS
- **Charts**: Chart.js

### Infrastructure
- **Containerisation**: Docker
- **Orchestration**: Docker Compose
- **Environment**: Cross-platform compatible

## Project Structure

```
CarBookingSystem/
├── docker-compose.yml    # Docker orchestration
├── web/                  # Node.js web application
│   ├── src/             # Server code
│   ├── controllers/     # Request handlers
│   ├── routes/          # URL routing
│   ├── views/           # EJS templates
│   └── public/          # Static assets
├── sql/                  # Database code
│   ├── functions/       # Stored procedures
│   ├── triggers/        # Database triggers
│   └── data/           # Sample data
├── scripts/             # Installation scripts
│   ├── install.sql     # Base schema
│   └── install-complete.sql  # Full installation
├── tests/               # Test suites
└── docs/               # Documentation
    ├── api/            # API docs
    ├── schemas/        # Database design
    └── guides/         # User guides
```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### Code Standards

- Use British English in documentation
- Follow SQL formatting conventions
- Maintain consistent code style
- Include appropriate comments

## Support

- **Documentation**: [Full Docs](docs/)
- **Issues**: [GitHub Issues](https://github.com/AL-Kaisi/CarBookingSystem/issues)
- **Discussions**: [GitHub Discussions](https://github.com/AL-Kaisi/CarBookingSystem/discussions)

## Licence

This project is licenced under the MIT Licence - see the [LICENCE](LICENCE) file for details.

## Authors

- **Mohamed Alkaisi** - *Initial work* - [GitHub](https://github.com/AL-Kaisi)

## Acknowledgements

- PostgreSQL community
- Node.js community
- All contributors and testers

---

Made with dedication by the Car Booking System team
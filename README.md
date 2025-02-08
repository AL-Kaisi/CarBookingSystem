# PL/SQL Oracle – Car Hire Company Solution

This repository contains a PL/SQL solution developed to address the requirements of a car hire company. It demonstrates key database functionalities including booking management, business rule enforcement via triggers, and information updates using PL/SQL scripts.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)
- [Scripts Explanation](#scripts-explanation)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project was created as a solution to a given set of requirements for a car hire company. The solution leverages Oracle’s PL/SQL to handle core operations such as:

- **Car Booking:** Managing the process of booking cars for customers.
- **Business Rules Enforcement:** Utilizing database triggers to enforce business logic and ensure data integrity.
- **Information Updates:** Managing changes to booking or customer information efficiently.

The goal is to provide a reliable, maintainable, and scalable PL/SQL implementation that can be integrated into a larger car hire management system.

## Project Structure

The repository is structured around three main PL/SQL script files:

- **Booking_cars.sql**  
  Contains the SQL and PL/SQL code to handle car booking operations. This script likely includes procedures or functions to insert new bookings and manage related validations.

- **Trigger(Business_rules).sql**  
  Implements a trigger that enforces business rules. The trigger ensures that any operation violating the defined business rules is caught and handled appropriately, maintaining the integrity of the data.

- **Update_Information.sql**  
  Provides functionality for updating existing booking or customer information. This script includes the necessary logic to safely update records in the database.

Each script is designed to be executed within an Oracle Database environment to simulate a real‑world operational workflow for a car hire company.

## Requirements

Before running the solution, ensure that you have:

- **Oracle Database:** An Oracle instance installed and running, with necessary privileges to create objects, run triggers, and execute PL/SQL scripts.
- **SQL*Plus or Oracle SQL Developer:** Tools to execute the provided SQL/PLSQL scripts.
- **Basic knowledge of PL/SQL:** Familiarity with PL/SQL programming, database triggers, and standard SQL operations is beneficial.

## Setup and Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/AL-Kaisi/PL-SQL-ORACLE.git
   cd PL-SQL-ORACLE
   ```

2. **Prepare the Oracle Environment**

   - Connect to your Oracle database using SQL*Plus, Oracle SQL Developer, or your preferred interface.
   - Ensure you have the appropriate privileges to run scripts that create or modify database objects.

3. **Review the Scripts**

   Open each SQL file to understand its purpose and adapt any hard-coded paths or values as needed to suit your environment.

## Usage

To deploy and test the solution:

1. **Execute the Booking Script**

   Run the `Booking_cars.sql` script to create the necessary procedures and insert booking data.

   ```sql
   @Booking_cars.sql
   ```

2. **Implement Business Rules**

   Execute the `Trigger(Business_rules).sql` to create the trigger that enforces business logic. This trigger will automatically validate operations based on the rules defined within it.

   ```sql
   @Trigger(Business_rules).sql
   ```

3. **Update Operations**

   Run the `Update_Information.sql` script to test updating records. This will ensure that changes in the database are handled correctly and that all business rules are respected.

   ```sql
   @Update_Information.sql
   ```

Monitor the output in your SQL interface for any errors or messages that indicate the successful execution of these scripts.

## Scripts Explanation

- **Booking_cars.sql:**  
  Sets up the booking process for cars. This may include inserting new booking records and handling related validations before the data is committed to the database.

- **Trigger(Business_rules).sql:**  
  Contains the trigger code designed to enforce the business rules of the car hire company. The trigger ensures data consistency by preventing operations that would violate company policies or operational constraints.

- **Update_Information.sql:**  
  Provides the mechanism for updating records in the system, ensuring that modifications are done in a controlled manner that adheres to the established business logic.

## Contributing

Contributions to improve this PL/SQL solution are welcome. If you wish to contribute:

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes with clear descriptions.
4. Submit a pull request for review.

Please ensure that any contributions are well-documented and maintain the clarity of the solution.

## License

*Specify the project’s license here. For example:*

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

This README aims to provide a clear and comprehensive guide for setting up, understanding, and utilizing the PL/SQL solution for a car hire company. If you have any questions or require further assistance, please open an issue in the repository.

References:  
cite50†[PL-SQL-ORACLE Repository](https://github.com/AL-Kaisi/PL-SQL-ORACLE)

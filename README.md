# ORACLE-PL-SQL
# Requirement

Detailed Specification
You are required to design and build a database background processing system for a
car rental company CarsHire. You will need to create at least one PL/SQL package
containing necessary procedures and functions, as well as database triggers to
support the following scenario and requirements. You do not need to create tables for
this assignment: the SQL scripts will be provided for you containing commands to
create necessary tables and populate them with data (see ERD below).
Case study:
Details: The CarsHire Company is renting cars and vans to the customers using the
database-based booking system. The company requires to have a standard back-end
process that can work with any type of the user interface. The back-end process
should be able to receive all necessary customer details as well as the information
about the preferred car category, dates of hire, etc. and proceed with the request
without any further interaction with the customer.
The request has to be processed by the background PL/SQL processing and the
confirmation should be sent to the customer’s email.
Vehicles in the company are categorized into small cars (suitable for carrying up to 4
people), family cars (suitable for carrying up to 7 adults), and vans.
Information for each booking is stored in appropriate tables in the database. 
Vehicle category code can be small, family or van.
Booking status code can be open, confirmed or cancelled.
Please study carefully the SQL scripts that are provided to reproduce a prototype
database before executing them. 


Requirements
You are required to create a database back-end processing solution for CarsHire
using PL/SQL. You are not required to build a user interface. You need to create at 
least one PL/SQL package with all procedures and functions that implement the
following business requirements.
Business requirements:
1. The system should be able to recognise if the customer is new or existing
based on the information provided by the customer.
a. If a new customer is submitting a car hire request, they must be
registered by the system as a part of the booking process.
b. If an existing customer is submitting a car hire request their details
should be taken from the customer table.
The process should use the existing sequence book_id_seq to generate a new
booking id automatically. After the booking has been made it should also print
on the screen an appropriate confirmation message including the customer id,
the booking id as well as car hiring details (simulation of sending booking
confirmation to the customer via email).
On receiving a car hire enquiry, the company’s process is required to check
the availability of requested cars and vans for dates specified:
c. If there are vehicles of a requested category available, the customer's
details are recorded (if not stored already) and a new booking is made
and one of the available cars (using registration number) is assigned to
the booking. An appropriate confirmation message is displayed on the
screen. Customers are not required to pay at this stage and will pay for
the vehicle at the time of pick up.
d. If there are no vehicles of a requested category available, the process
sends an appropriate message to the customer and does not create a
booking.

2. A customer should be able to cancel an existing booking.

3. The system should be able to record all necessary information about new cars
added to the company fleet.

4. The company has a business rule: ‘If the status of the booking is ‘open’, or
‘confirmed’ it can be changed, but the bookings with the ‘cancelled’ cannot be
changed’. You have to design and implement the best way to enforce this
business rule. 

5. A company’s clerk should be able to print a report showing all bookings for any
particular day.

6. All your PL/SQL subprograms should include appropriate error handling.

#solutions uploaded as SQL package 


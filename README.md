Cab Booking System (SQL Project)

The Cab Booking System is a database-driven project designed to manage cab bookings, drivers, customers, payments, and trip records. It focuses on efficient data storage, relational design, and SQL-based operations such as querying, filtering, and reporting.

📌 Features

Customer Management: Store and manage customer information.

Driver Management: Maintain driver profiles, license details, and cab assignments.

Cab Details: Track cab types, numbers, availability, and status.

Booking System: Create and manage bookings with pickup/drop locations and time.

Trip Management: Logs trip start/end time, distance traveled, and total fare.

Payment Handling: Manage payment status, mode, and transaction records.

Reports & Queries:

Total rides per customer

Earnings per driver

Daily/Monthly revenue

Cabin availability status

🛠️ Tech Stack

SQL Database: MySQL / PostgreSQL / SQL Server (choose based on your project)

Optional: Frontend or backend layer if you extend it later

📂 Database Structure
Tables Included

customers

drivers

cabs

bookings

trips

payments

Key Relationships

One customer → Many bookings

One driver → Many trips

One cab → Many trips

One booking → One trip & One payment

⚙️ SQL Operations Demonstrated

CREATE, INSERT, UPDATE, DELETE queries

INNER JOIN, LEFT JOIN, AGGREGATE functions

TRIGGERS & STORED PROCEDURES (optional)

VIEWS for generating reports

FOREIGN KEY constraints & indexing for optimization

🚀 How to Use

Import the .sql file into your SQL server.

Run table creation scripts.

Insert sample data.

Use provided queries to test the system.

Extend it with UI or API if needed.

📈 Possible Extensions

Admin dashboard

Real-time cab tracking

Rating & reviews system

Automated fare calculation procedures

Authentication system for customers & drivers

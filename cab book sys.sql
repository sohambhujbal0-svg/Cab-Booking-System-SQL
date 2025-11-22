Create Database Project;
use Project;

-- 1. Customers
Create table Customers (
CustomerID INT PRIMARY KEY,
Name VARCHAR(100),
Phone VARCHAR(15),
Email VARCHAR(100),
JoinDate DATE);

INSERT INTO Customers (CustomerID, Name, Phone, Email, JoinDate) VALUES
(1, 'Rajan Pandey', '9876543210', 'rajan@example.com', '2024-01-10'),
(2, 'Jay Tiwari', '8765432109', 'jay@example.com', '2024-02-15'),
(3, 'Rakesh Yadav', '7654321098', 'rakesh1@example.com', '2024-03-01'),
(4, 'Harsh Singh', '6543210987', 'harshu@example.com', '2024-04-05');

Select * from Customers;


-- 2. Drivers

Create table Drivers (
DriverID INT PRIMARY KEY,
Name VARCHAR(100),
Phone VARCHAR(15),
LicenseNumber VARCHAR(50),
JoinDate DATE,
Rating FLOAT);

INSERT INTO Drivers (DriverID, Name, Phone, LicenseNumber, JoinDate, Rating) VALUES
(1, 'Raj Singh', '9123456789', 'DL12345678', '2023-09-01', 4.5),
(2, 'Sunny Chaudhary', '9234567890', 'DL87654321', '2023-10-12', 3.2),
(3, 'Anshu P', '9345678901', 'DL23456789', '2024-01-20', 2.8),
(4, 'Alina Kapoor', '9456789012', 'DL34567890', '2024-03-15', 4.0);

Select * from Drivers;

-- 3. Cabs

Create table Cabs(
CabID INT PRIMARY KEY,
DriverID INT,
CabType VARCHAR(20), -- 'Sedan', 'SUV', etc.
PlateNumber VARCHAR(20),
FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID));

INSERT INTO Cabs (CabID, DriverID, CabType, PlateNumber) VALUES
(1, 1, 'Sedan', 'KA01AB1234'),
(2, 2, 'SUV', 'KA01CD5678'),
(3, 3, 'Sedan', 'KA01EF9012'),
(4, 4, 'SUV', 'KA01GH3456');

Select * from Cabs;

-- 4. Bookings
 
Create table Bookings(
BookingID INT PRIMARY KEY,
CustomerID INT,
CabID INT,
BookingTime DATETIME,
TripStartTime DATETIME,
TripEndTime DATETIME,
PickupLocation VARCHAR(100),
DropoffLocation VARCHAR(100),
Status VARCHAR(20), -- 'Completed', 'Cancelled', 'Ongoing'
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (CabID) REFERENCES Cabs(CabID));

INSERT INTO Bookings (BookingID, CustomerID, CabID, BookingTime, TripStartTime, TripEndTime, PickupLocation, DropoffLocation, Status) VALUES
(101, 1, 1, '2025-05-01 08:00:00', '2025-05-01 08:10:00', '2025-05-01 08:40:00', 'Downtown', 'Airport', 'Completed'),
(102, 2, 2, '2025-05-01 09:00:00', NULL, NULL, 'Station', 'Mall', 'Cancelled'),
(103, 1, 3, '2025-05-02 10:00:00', '2025-05-02 10:15:00', '2025-05-02 10:50:00', 'Downtown', 'Hospital', 'Completed'),
(104, 3, 4, '2025-05-03 11:30:00', '2025-05-03 11:45:00', '2025-05-03 12:30:00', 'Mall', 'University', 'Completed'),
(105, 4, 1, '2025-05-04 14:00:00', NULL, NULL, 'Airport', 'Downtown', 'Cancelled');

Select * from Bookings;

-- 5. TripDetails

Create table TripDetails(
TripID INT PRIMARY KEY,
BookingID INT,
Distance FLOAT, -- in kilometers
Fare DECIMAL(10,2),
DriverRating FLOAT,
FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID));

INSERT INTO TripDetails (TripID, BookingID, Distance, Fare, DriverRating) VALUES
(1001, 101, 12.5, 250.00, 5.0),
(1002, 103, 10.0, 200.00, 4.0),
(1003, 104, 15.0, 300.00, 3.5);

Select * from TripDetails;

-- Note: Bookings 102 and 105 are cancelled, so they don’t appear here.


-- 6. Feedback

Create table Feedback(
FeedbackID INT PRIMARY KEY,
BookingID INT,
CustomerFeedback TEXT,
ReasonForCancellation VARCHAR(100),
FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID));

INSERT INTO Feedback (FeedbackID, BookingID, CustomerFeedback, ReasonForCancellation) VALUES
(501, 102, 'Cab was late, had to cancel.', 'Driver Delay'),
(502, 105, 'Change of plans.', 'Customer Personal Reason');

Select * from Feedback;


# Problem Solving with SQL Queries
# 1. Customer and Booking Analysis

-- 1. Top Customers by Completed Bookings

SELECT c.Name, COUNT(b.BookingID) AS CompletedBookings
FROM Customers c
JOIN Bookings b ON c.CustomerID = b.CustomerID
WHERE b.Status = 'Completed'
GROUP BY c.CustomerID
ORDER BY CompletedBookings DESC
LIMIT 5;

-- 2. Customers with >30% Cancellations
SELECT c.Name, 
       COUNT(CASE WHEN b.Status = 'Cancelled' THEN 1 END) * 1.0 / COUNT(b.BookingID) AS CancellationRate
FROM Customers c
JOIN Bookings b ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID
HAVING CancellationRate > 0.3;

-- 3. Busiest Day for Bookings
SELECT DAYNAME(BookingTime) AS DayOfWeek, COUNT(*) AS TotalBookings
FROM Bookings
GROUP BY DayOfWeek
ORDER BY TotalBookings DESC
LIMIT 1;

# 2. Driver Performance & Efficiency

-- 1. Drivers Rated Below 3.0 in Last 3 Months
SELECT d.Name, AVG(t.DriverRating) AS AvgRating
FROM Drivers d
JOIN Cabs c ON d.DriverID = c.DriverID
JOIN Bookings b ON c.CabID = b.CabID
JOIN TripDetails t ON b.BookingID = t.BookingID
WHERE b.TripEndTime >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY d.DriverID
HAVING AvgRating < 3.0;

-- 2. Top 5 Longest Trips
SELECT d.Name, t.Distance
FROM Drivers d
JOIN Cabs c ON d.DriverID = c.DriverID
JOIN Bookings b ON c.CabID = b.CabID
JOIN TripDetails t ON b.BookingID = t.BookingID
ORDER BY t.Distance DESC
LIMIT 5;

-- 3. Drivers with High Cancellation Rates
SELECT d.Name,
       COUNT(CASE WHEN b.Status = 'Cancelled' THEN 1 END)*1.0 / COUNT(b.BookingID) AS CancellationRate
FROM Drivers d
JOIN Cabs c ON d.DriverID = c.DriverID
JOIN Bookings b ON c.CabID = b.CabID
GROUP BY d.DriverID
HAVING CancellationRate > 0.3;

# 3. Revenue & Business Metrics

-- 1. Revenue in Last 6 Months
SELECT MONTH(TripEndTime) AS Month, SUM(Fare) AS MonthlyRevenue
FROM Bookings b
JOIN TripDetails t ON b.BookingID = t.BookingID
WHERE b.Status = 'Completed'
AND TripEndTime >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY Month
ORDER BY Month;

-- 2. Top 3 Routes
SELECT PickupLocation, DropoffLocation, COUNT(*) AS TripCount
FROM Bookings
WHERE Status = 'Completed'
GROUP BY PickupLocation, DropoffLocation
ORDER BY TripCount DESC
LIMIT 3;

-- 3. Driver Ratings vs. Earnings
SELECT d.Name, AVG(t.DriverRating) AS AvgRating, COUNT(t.TripID) AS TripCount, SUM(t.Fare) AS TotalEarnings
FROM Drivers d
JOIN Cabs c ON d.DriverID = c.DriverID
JOIN Bookings b ON c.CabID = b.CabID
JOIN TripDetails t ON b.BookingID = t.BookingID
GROUP BY d.DriverID
ORDER BY AvgRating DESC;

# 4. Operational Efficiency & Optimization

-- 1. Average Waiting Time by Pickup Location
SELECT PickupLocation, AVG(TIMESTAMPDIFF(MINUTE, BookingTime, TripStartTime)) AS AvgWaitTime
FROM Bookings
WHERE Status = 'Completed'
GROUP BY PickupLocation
ORDER BY AvgWaitTime DESC;

-- 2. Common Cancellation Reasons
SELECT ReasonForCancellation, COUNT(*) AS Occurrences
FROM Feedback
JOIN Bookings ON Feedback.BookingID = Bookings.BookingID
WHERE Bookings.Status = 'Cancelled'
GROUP BY ReasonForCancellation
ORDER BY Occurrences DESC;

-- 3. Revenue from Short Trips (<5km)
SELECT 
    SUM(CASE WHEN Distance < 5 THEN Fare ELSE 0 END) AS ShortTripRevenue,
    SUM(Fare) AS TotalRevenue,
    SUM(CASE WHEN Distance < 5 THEN Fare ELSE 0 END) * 100.0 / SUM(Fare) AS PercentageShortTripRevenue
FROM TripDetails;

#5. Comparative & Predictive Analysis

-- 1. Sedan vs SUV Revenue
SELECT CabType, SUM(Fare) AS Revenue
FROM TripDetails t
JOIN Bookings b ON t.BookingID = b.BookingID
JOIN Cabs c ON b.CabID = c.CabID
GROUP BY CabType;

-- 2. Customers Likely to Churn
SELECT c.Name, MAX(b.BookingTime) AS LastBooking, COUNT(b.BookingID) AS TotalBookings
FROM Customers c
JOIN Bookings b ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID
HAVING LastBooking < DATE_SUB(CURDATE(), INTERVAL 60 DAY)
   OR TotalBookings < 5;
   
-- 3. Weekend vs Weekday Bookings
SELECT 
    CASE 
        WHEN DAYOFWEEK(BookingTime) IN (1, 7) THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS DayType,
    COUNT(*) AS BookingCount,
    SUM(t.Fare) AS TotalRevenue
FROM Bookings b
JOIN TripDetails t ON b.BookingID = t.BookingID
GROUP BY DayType;
 
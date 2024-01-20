CREATE DATABASE LIBRARY;
USE LIBRARY;

CREATE TABLE Branch
(
Branch_No INT PRIMARY KEY NOT NULL,
Manager_Id VARCHAR(5),
Branch_Address VARCHAR(150),
Contact_No VARCHAR(50)
);

INSERT INTO Branch VALUES 
(101,'M1','154 Brook Street',5005550126),
(102,'M2','3514 Berry Dr',5005550184),
(103,'M3','624 Peabody Road',5005550164);

SELECT * FROM branch;

CREATE TABLE Employee
(
Emp_Id INT PRIMARY KEY NOT NULL,
Emp_name VARCHAR(50),
Position VARCHAR(50),
Salary INT,
Branch_No INT,
FOREIGN KEY (Branch_No) REFERENCES Branch(Branch_No)
);

INSERT INTO Employee VALUES
(201,'Jennifer Russell','Librarian',55000,101),
(202,'Marc Martin','Cleaning Staff',25000,101),
(203,'Jesse Murphy','Manager',52500,101),
(204,'Diana Hernandez','Cleaning Staff',18000,101),
(205,'Marc Martin','Librarian',47500,101),
(206,'Denise Stone','Cleaning Staff',22000,102),
(207,'Jaime Nath','Librarian',47500,102),
(208,'Harold Sai','Cleaning Staff',15000,103),
(209,'Ebony Gonzalez','Librarian',50000,103),
(210,'Jimmy Moreno','Clerk',20000,101);

SELECT * FROM employee;

CREATE TABLE Customer
(
Customer_Id INT PRIMARY KEY NOT NULL,
Customer_Name VARCHAR (50),
Customer_Address VARCHAR (150),
Reg_Date DATE
);

INSERT INTO Customer VALUES
(301,'Amanda Carter', '1321 4th Street, New York','2021-11-20'),
(302,'Megan Sanchez', '981 Main Street, Ann Arbor','2022-01-15'),
(303,'Nathan Simmons', '491 3rd Street, New York','2020-05-13'),
(304,'Adam Flores', '5826 Escobar,Australia','2023-09-03'),
(305,'Leonard Nara', '101 South University, Ann Arbor','2022-01-30'),
(306,'Christine Yuan', '40 State Street, Saline','2019-12-12'),
(307,'Daniel Johnson', '32 Corner Road, New York','2020-02-10'),
(308,'Carl Andersen', '2212 Green Avenue, Ann Arbor','2023-08-25'),
(309,'Michele Nath', '121 Park Drive, Ann Arbor','2023-07-23'),
(310,'Heidi Lopez', '23 75th Street, New York','2022-12-12'),
(311,'Jessica Henderson', '231 52nd Avenue New York','2023-01-20');

SELECT * FROM Customer;

CREATE TABLE Books
(
ISBN BIGINT PRIMARY KEY NOT NULL,
Book_title VARCHAR (100),
Category VARCHAR(100),
Rental_Price INT,
Status ENUM('YES',"NO"),
Author VARCHAR(100),
Publisher VARCHAR(200)
);

INSERT INTO Books VALUES
(0060973129,'Decision in Normandy','Fiction',80,'YES','Carlo D Este','HarperPerennial'),
(0964161484100, 'Mike Tyson : Undisputed Truth', 'Sports', 50,'YES','Larry Sloman, Mike Tyson','Sunday Times'),
(6901142585540, 'V for Vendetta','Comics',90,'No', 'Alan Moore','Black Label'),
(9094996245442, 'When Breath Becomes Air','Medical',65,'YES', 'Paul Kalanithi','Bodeley Head'),
(9788172234980,'The Alchemist','Adventure Fiction',100,'Yes','Paulo Coehlo','Harper'),
(9789381626344,'The Secret of Nagas','History',80,'YES','Amish','WestLand'),
(9780349413686,'Deep Work','Non-Fiction',45,'NO','Cal Newport','Hachette Book Group'),
(8653491200700, 'The Great Gatsby', 'History',75,'NO', 'F. Scott Fitzgerald','FingerPrint');

SELECT * FROM BOOKS;

CREATE TABLE IssueStatus
(
Issue_Id INT PRIMARY KEY NOT NULL,
Issued_cust INT,
FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
Issued_book_name VARCHAR(100),
Issue_date DATE,
Isbn_book BIGINT ,
FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);

INSERT INTO IssueStatus VALUES
(401,304,'Decision in Normandy','2023-12-22',00060973129),
(402,301,'Mike Tyson : Undisputed Truth','2024-01-02',964161484100),
(403,303,'When Breath Becomes Air','2023-06-29',9094996245442),
(404,305,'The Alchemist','2024-01-11',9788172234980);

SELECT * FROM IssueStatus;

CREATE TABLE ReturnStatus
(
Return_Id INT PRIMARY KEY NOT NULL,
Return_cust INT,
FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),
Return_book_name VARCHAR(100),
Return_date DATE,
Isbn_book2 BIGINT ,
FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);

INSERT INTO ReturnStatus VALUES
(501,307,'V for Vendetta','2024-01-02',6901142585540),
(502,309,'The Great Gatsby','2024-01-10',8653491200700),
(503,302,'Deep Work','2023-12-30',9780349413686),
(504,308,'Decision in Normandy','2024-01-05',00060973129);


-- Write the queries for the following:
-- 1. Retrieve the book title, category, and rental price of all available books.
SELECT Book_title,Category,Rental_Price FROM Books WHERE Status='Yes';

-- 2.List the employee names and their respective salaries in descending order of salary. 
SELECT Emp_name,Salary FROM Employee ORDER BY Salary DESC;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books.
SELECT b.Book_title, c.Customer_Name FROM Books b 
JOIN IssueStatus i ON b.ISBN=i.isbn_book
JOIN Customer c ON i.Issued_cust=c.Customer_id;

-- 4. Display the total count of books in each category.
SELECT Category, COUNT(*) AS Total_Count FROM Books GROUP BY Category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000.
SELECT Emp_name,Position FROM Employee WHERE Salary > 50000;

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
SELECT Customer_Name FROM Customer WHERE Reg_Date < '2022-01-01' 
AND Customer_id NOT IN(SELECT Issued_cust FROM IssueStatus);

-- 7. Display the branch numbers and the total count of employees in each branch.
SELECT Branch_no, COUNT(*) AS Total_Employees FROM Employee GROUP BY Branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
SELECT DISTINCT c.Customer_name FROM Customer c
JOIN IssueStatus i ON c.Customer_Id = i.Issued_cust
WHERE MONTH(i.Issue_date) = 6 AND YEAR(i.Issue_date) = 2023;

-- 9. Retrieve book_title from book table containing history.
SELECT Book_title FROM Books WHERE Category='History';

-- 10. Retrieve the branch numbers along with the count of employees for branches having more than 5 employees. 
SELECT Branch_no, COUNT(*) AS Total_Employees FROM Employee GROUP BY Branch_no HAVING Total_Employees > 5;

-- create a database called 'Library'
CREATE DATABASE Library;
-- use the 'Library' database
USE Library;
-- create a table called 'Authors'
CREATE TABLE Authors
    (Author_ID INTEGER PRIMARY KEY, 
    Author_forename VARCHAR(20),
    Author_surname VARCHAR(20));
-- create a table called 'Books'
CREATE TABLE Books
    (Book_ID INTEGER PRIMARY KEY, 
    Book_name VARCHAR(50),
    Author_ID INTEGER,
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID));
-- create a table called 'BorrowingCategory'
CREATE TABLE BorrowingCategory
    (Borrowing_category_ID INTEGER PRIMARY KEY,
    Borrowing_category_name VARCHAR(10),
    Borrowing_length_weeks INTEGER);
-- create a table called 'Stock'
CREATE TABLE Stock
    (Stock_ID INTEGER PRIMARY KEY,
    Book_ID INTEGER,
    Borrowing_category_ID INTEGER,
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID),
    FOREIGN KEY (Borrowing_category_ID) REFERENCES BorrowingCategory(Borrowing_category_ID));
-- create a table called 'Members'
CREATE TABLE Members
    (Member_ID INTEGER PRIMARY KEY,
    Member_forename VARCHAR(20),
    Member_surname VARCHAR(20),
    Member_address VARCHAR(100),
    Member_phone VARCHAR(15),
    Member_email VARCHAR(50));
    
-- create a table called 'BorrowingRecord'
CREATE TABLE BorrowingRecord
    (Borrowing_record_ID INTEGER PRIMARY KEY,
    Member_ID INTEGER,
    Stock_ID INTEGER,
    Borrow_date DATE,
    Due_date DATE,
    Return_date DATE,
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Stock_ID) REFERENCES Stock(Stock_ID));
    
-- create a table called 'Fines'
CREATE TABLE Fines
    (Fine_category_ID INTEGER PRIMARY KEY,
    Fine_category_name VARCHAR(20),
    Fine_amount_pounds FLOAT(3, 2));
    
-- create a table called 'AppliedFines'
CREATE TABLE AppliedFines
    (Applied_fine_ID INTEGER PRIMARY KEY, 
    Borrowing_record_ID INTEGER,
    Fine_category_ID INTEGER,
    FOREIGN KEY (Borrowing_record_ID) REFERENCES BorrowingRecord(Borrowing_Record_ID),
    FOREIGN KEY (Fine_category_ID) REFERENCES Fines(Fine_category_ID));

-- enter data into the 'Authors' table
INSERT INTO Library.Authors (Author_ID, Author_forename, Author_surname)
VALUES
(1, 'Margaret', 'Atwood'),
(2, 'Alice', 'Walker'),
(3, 'Hilary', 'Mantel'),
(4, 'Yaa', 'Gyasi'),
(5, 'Naomi', 'Alderman'),
(6, 'Virginia', 'Woolf'),
(7, 'Charlotte', 'Bronte');
-- enter data into the 'Books' table
INSERT INTO Library.Books (Book_ID, Book_name, Author_ID)
VALUES
(1, 'The Handmaid s Tale', 1),
(2, 'Alias Grace', 1),
(3, 'The Color Purple', 2),
(4, 'Wolf Hall', 3),
(5, 'Bring Up the Bodies', 3),
(6, 'The Mirror and the Light', 3),
(7, 'Homegoing', 4),
(8, 'The Power', 5),
(9, 'To the Lighthouse', 6),
(10, 'Jane Eyre', 7);
-- enter data into the 'BorrowingCategory' table
INSERT INTO Library.BorrowingCategory (Borrowing_category_ID, Borrowing_category_name, Borrowing_length_weeks)
VALUES
(1, 'Short', 1),
(2, 'Long', 3);
-- enter data into the 'Stock' table
INSERT INTO Library.Stock (Stock_ID, Book_ID, Borrowing_category_ID)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 2),
(4, 2, 2),
(5, 3, 2),
(6, 4, 2),
(7, 5, 2),
(8, 6, 1),
(9, 7, 1),
(10, 7, 2),
(11, 8, 2),
(13, 9, 2),
(14, 10, 2),
(15, 10, 2);
-- enter data into the 'Members' table
INSERT INTO Library.Members (Member_ID, Member_forename, Member_surname, Member_email)
VALUES
(1, 'Melanie', 'Brown', 'MelB@email.com'),
(2, 'Melanie', 'Chisholm', 'MelC@email.com'),
(3, 'Emma', 'Bunton', 'EmmaB@email.com'),
(4, 'Geri', 'Halliwell', 'GeriH@email.com'),
(5, 'Victoria', 'Beckham', 'VictoriaB@email.com');
-- enter data into the 'BorrowingRecord' table
INSERT INTO Library.BorrowingRecord (Borrowing_record_ID, Member_ID, Stock_ID, Borrow_date, Due_date, Return_date)
VALUES
(1, 1, 3, 20220308, 20220329, 20220315),
(2, 2, 5, 20220308, 20220329, NULL),
(3, 3, 7, 20220308, 20220329, NULL),
(4, 4, 9, 20220308, 20220315, NULL),
(5, 5, 11, 20220308, 20220315, 20220310),
(6, 5, 13, 20220308, 20220329, 20220315),
(7, 5, 15, 20220310, 20220331, NULL);
-- enter data into the 'Fines' table
INSERT INTO Library.Fines (Fine_category_ID, Fine_category_name, Fine_amount_pounds)
VALUES
(1, 'Shortday1', 1.00),
(2, 'Longday1', 0.50),
(3, 'Shortongoing', 0.20),
(4, 'Longongoing', 0.10);
-- enter data into the 'AppliedFines' table
INSERT INTO Library.AppliedFines (Applied_fine_ID, Borrowing_record_ID, Fine_category_ID)
VALUES
(1, 4, 1);

-- Using any type of the joins create a view that combines multiple tables in a logical way
CREATE VIEW stockview AS SELECT 
Stock_ID, Book_name, Borrowing_Category_name 
FROM Stock s, Books b, BorrowingCategory c 
WHERE s.Book_ID=b.Book_ID 
AND s.Borrowing_category_ID=c.Borrowing_category_ID;

-- In your database, create a stored procedure and demonstrate how it runs
-- Change Delimiter
DELIMITER //
-- Create Stored Procedure
CREATE PROCEDURE InsertAuthor(
IN Author_ID INT, 
IN Author_forename VARCHAR(100),
IN Author_surname VARCHAR(100))
BEGIN

INSERT INTO Authors(Author_ID,Author_forename, Author_surname)
VALUES (Author_ID,Author_forename, Author_surname);

END//
-- Change Delimiter again
DELIMITER ;

-- Write a trigger that activates before the INSERT statement on inserted values
DELIMITER //
CREATE TRIGGER Author_Before_Insert
BEFORE INSERT ON authors
FOR EACH ROW
BEGIN
    SET NEW.author_forename = TRIM(NEW.author_forename);
    SET NEW.author_surname = TRIM(NEW.author_surname);
END//
DELIMITER ;

-- create stored function that can be applied to a query
-- create function
USE library;
DELIMITER //
CREATE FUNCTION OnLoan(Return_date DATE)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE OnLoan VARCHAR(10);
    IF Return_date IS NOT NULL THEN 
        SET OnLoan = 'On loan';
    ELSEIF Return_date IS NULL THEN
        SET OnLoan = 'Returned';
    END IF;
    RETURN(OnLoan);
END //
DELIMITER ;

-- Turn ON Event Scheduler 
SET GLOBAL event_scheduler = ON;
USE library;
-- recurrent loan status update
CREATE TABLE Current_loans
(Loan_record_ID INT NOT NULL AUTO_INCREMENT, Books_on_loan INT, Updated TIMESTAMP, PRIMARY KEY (Loan_record_ID));
DELIMITER //
CREATE EVENT Loan_monitoring
ON SCHEDULE EVERY 1 DAY
STARTS NOW()
DO BEGIN
    INSERT INTO Current_loans(Books_on_loan, Updated)
    VALUES (
        (SELECT COUNT(Stock_ID) FROM BorrowingRecord WHERE Return_date IS NULL), 
        NOW());
END //
DELIMITER ;

-- Create a view that uses at least 3-4 base tables; prepare and demonstrate a query that uses the view to produce a logically arranged result set for analysis.

CREATE VIEW contacts_for_fines
AS SELECT
m.member_email,
f.fine_amount_pounds
FROM appliedfines a, borrowingrecord br, members m, fines f
WHERE a.borrowing_record_ID = br.borrowing_record_ID
AND br.member_ID = m.member_ID
AND f.fine_category_ID = a.fine_category_ID;
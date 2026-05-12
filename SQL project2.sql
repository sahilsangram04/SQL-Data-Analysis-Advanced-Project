CREATE TABLE Books(
	Book_ID	SERIAL	PRIMARY KEY,
	Title	VARCHAR(100),	
	Author	VARCHAR(100),	
	Genre	VARCHAR(50)	,
	Published_Year	INT	,
	Price	NUMERIC(10,2),	
	Stock	INT	
);

CREATE TABLE Customers(
	Customer_ID	SERIAL	PRIMARY KEY,
	Name	VARCHAR(100),	
	Email	VARCHAR(100),	
	Phone	VARCHAR(15)	,
	City	VARCHAR(50)	,
	Country	VARCHAR(150)
);

CREATE TABLE Orders(
	Order_ID SERIAL	PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,	
	Quantity INT,	
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) RETRIVE ALL BOOKS IN "FICTION" GENRE

SELECT * FROM Books WHERE genre='Fiction';

-- 2) Find books published after the year 1950

SELECT * FROM Books WHERE published_year>1950;

-- 3) LIST ALL THE CUSTOMERS FROM CANADA

SELECT * FROM Customers WHERE country='Canada';

-- 4) SHOW ORDERS PLACED IN  NOVEMBER 2023

SELECT * FROM Orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) RETRIVE THE TOTAL STOCK OF BOOK AVAILABLE

SELECT SUM(stock) AS Total_stock FROM Books;

-- 6) FIND THE DETAILS OF THE MOST EXPENSIVE BOOK

SELECT * FROM Books ORDER BY price DESC LIMIT 1;

-- 7) SHOW ALL CUSTOMERS WHO ORDERED MORE THAN 1 QUANTITY OF BOOK

SELECT * FROM Orders WHERE quantity>1;

-- 8) RETRIVE ALL THE ORDERS WHERE THE TOTAL AMOUNT EXCEEDS $20

SELECT * FROM Orders WHERE total_amount>20;

-- 9) LIST ALL THE GENRES AVAILABLE IN THE BOOKS TABLE

SELECT DISTINCT genre FROM Books;

-- 10) FIND THE BOOK WITH  THE LOWEST STOCK

SELECT * FROM Books ORDER BY stock ASC LIMIT 1;

-- 11) CALCULATE THE TOTAL REVENUE FROM ALL ORDERS

SELECT SUM(total_amount) AS Total_revenue FROM Orders; 

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- ADVANCED QUESTIONS

-- 1) RETRIVE THE TOTAL NUMBER OF BOOKS SOLD FOR EACH GENRE

SELECT b.genre, SUM(o.quantity) AS total_number_of_books
FROM Books b JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.genre;

-- 2) FIND THE AVERAGE PRICE OF BOOKS IN THE 'FANTASY' GENRE

SELECT AVG(price) AS Average_price FROM Books WHERE genre = 'Fantasy';

-- 3) LIST CUSTOMERS WHO HAVE PLACED AT LEAST 2 ORDERS

SELECT c.name, o.customer_id, COUNT(o.order_id) 
FROM Customers c JOIN Orders o ON c.customer_id=o.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(o.order_id) >= 2;

-- 4) FIND THE MOST FREQUENTLY ORDERD BOOKS

SELECT b.title, o.book_id, COUNT(order_id) AS ORDER_COUNT
FROM Orders o JOIN Books b on o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC;

-- 5) SHOW THE TOP 3 MOST EXPENSIVE BOOKS OF 'FANTASY' GENRE

SELECT * FROM Books WHERE genre='Fantasy' ORDER BY price DESC LIMIT 3;

-- 6) RETRIVE THE TOTAL QUANTITY OF BOOKS SOLD BY EACH AUTHOR

SELECT b.author, o.book_id, COUNT(o.quantity) AS TOTAL_QUANTITY
FROM Books b JOIN Orders o ON o.book_id = b.book_id
GROUP BY b.author,o.book_id ;

-- 7) LIST THE CITIES WHERE CUSTOMERS WHO SPENT OVER 30 ARE LOCATED

SELECT DISTINCT c.city, o.total_amount
FROM Orders o JOIN Customers c ON o.customer_id=c.customer_id 
WHERE o.total_amount>30

-- 8) FIND THE CUSTOMER WHO SPENT THE MOST ON ORDERS

SELECT c.name, SUM(o.total_amount) AS AMOUNT_SPENT
FROM Customers c JOIN Orders o ON o.customer_id=c.customer_id
GROUP BY c.name
ORDER BY AMOUNT_SPENT DESC LIMIT 1;
-- 9) CALCULATE THE STOCK REMAINING AFTER FULFILLING ALL ORDER

SELECT b.book_id, b.stock, COALESCE(SUM(o.quantity),0) AS ORDER_QUANTITY, b.stock-COALESCE(SUM(o.quantity),0) AS REMAINING_STOCK
FROM Books b LEFT JOIN Orders o ON b.book_id=o.book_id
GROUP BY b.book_id;
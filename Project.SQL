CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Borrowed_Books (
    borrow_id INT PRIMARY KEY,
    book_id INT,
    student_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);



INSERT INTO Authors VALUES (1, 'J.K. Rowling'), (2, 'George Orwell'), (3, 'Chetan Bhagat');

INSERT INTO Books VALUES 
(101, 'Harry Potter', 1, 3),
(102, '1984', 2, 2),
(103, 'Half Girlfriend', 3, 4);

INSERT INTO Students VALUES 
(201, 'Anjali Sharma', 'anjali@example.com'),
(202, 'Ravi Kumar', 'ravi@example.com'),
(203, 'Priya Singh', 'priya@example.com');

INSERT INTO Borrowed_Books VALUES
(301, 101, 201, '2025-08-01', NULL),   -- Book issued, not yet returned
(302, 102, 202, '2025-07-20', '2025-08-01'), -- Returned
(303, 103, 203, '2025-07-10', NULL);   -- Overdue

-- 1️⃣ Issue a Book (insert into Borrowed_Books & decrease available_copies)
-- Example: Ravi borrows Harry Potter
INSERT INTO Borrowed_Books VALUES (304, 101, 202, CURDATE(), NULL);
UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = 101;

-- 2️⃣ Return a Book (update Borrowed_Books & increase available_copies)
-- Example: Anjali returns Harry Potter
UPDATE Borrowed_Books SET return_date = CURDATE() WHERE borrow_id = 301;
UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = 101;

-- 3️⃣ List Overdue Books (borrowed for more than 14 days & not returned)
SELECT b.title, s.name AS student, bb.borrow_date
FROM Borrowed_Books bb
JOIN Books b ON bb.book_id = b.book_id
JOIN Students s ON bb.student_id = s.student_id
WHERE bb.return_date IS NULL
  AND DATEDIFF(CURDATE(), bb.borrow_date) > 14;

-- 4️⃣ Most Borrowed Books
SELECT b.title, COUNT(*) AS times_borrowed
FROM Borrowed_Books bb
JOIN Books b ON bb.book_id = b.book_id
GROUP BY b.title
ORDER BY times_borrowed DESC;

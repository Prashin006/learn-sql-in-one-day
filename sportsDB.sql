CREATE DATABASE sports_booking;
USE sports_booking;

-- members table
CREATE TABLE members(
	id VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    member_since TIMESTAMP NOT NULL DEFAULT NOW(),
    payment_due FLOAT NOT NULL DEFAULT 0
);

-- pending_terminations table
CREATE TABLE pending_terminations(
	id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    request_date TIMESTAMP NOT NULL DEFAULT NOW(),
    payment_due FLOAT NOT NULL DEFAULT 0
);

-- rooms table
CREATE TABLE rooms(
	id VARCHAR(255) PRIMARY KEY,
    room_type VARCHAR(255) NOT NULL,
    price FLOAT NOT NULL
);

-- bookings table
CREATE TABLE bookings(
	id INT PRIMARY KEY AUTO_INCREMENT,
    room_id VARCHAR(255) NOT NULL,
    booked_date DATE NOT NULL,
    booked_time TIME NOT NULL,
    member_id VARCHAR(255) NOT NULL,
    datetime_of_booking TIMESTAMP NOT NULL DEFAULT NOW(),
    payment_status VARCHAR(255) NOT NULL DEFAULT 'Unpaid',
    CONSTRAINT uc1 UNIQUE(room_id, booked_date, booked_time)
);

ALTER TABLE bookings
ADD CONSTRAINT fk1 FOREIGN KEY(member_id) REFERENCES members(id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk2 FOREIGN KEY(room_id) REFERENCES rooms(id) ON DELETE CASCADE ON UPDATE CASCADE;

INSERT INTO members(id,password,email,member_since,payment_due) VALUES
('afeil', 'feil1988<3', 'Abdul.Feil@hotmail.com', '2017-04-15 12:10:13', 0),
('amely_18', 'loseweightin18', 'Amely.Bauch91@yahoo.com', '2018-02-06 16:48:43', 0),
('bbahringer', 'iambeau17', 'Beaulah_Bahringer@yahoo.com', '2017-12-28 05:36:50', 0),
('little31', 'whocares31', 'Anthony_Little31@gmail.com', '2017-06-01 21:12:11', 10),
('macejkovic73', 'jadajeda12', 'Jada.Macejkovic73@gmail.com','2017-05-30 17:30:22', 0),
('marvin1', 'if0909mar', 'Marvin_Schulist@gmail.com', '2017-09-09 02:30:49', 10),
('nitzsche77', 'bret77@#', 'Bret_Nitzsche77@gmail.com', '2018-01-09 17:36:49', 0),
('noah51', '18Oct1976#51', 'Noah51@gmail.com', '2017-12-16 22:59:46', 0),
('oreillys', 'reallycool#1', 'Martine_OReilly@yahoo.com', '2017-10-12 05:39:20', 0),
('wyattgreat', 'wyatt111', 'Wyatt_Wisozk2@gmail.com', '2017-07-18 16:28:35', 0);

SELECT * FROM members;

INSERT INTO rooms(id,room_type,price) VALUES
('AR','Archery Range',120.00),
('B1','Badminton Court',8),
('B2','Badminton Court',8),
('MPF1','Mutli Purpose Field',50),
('MPF2','Mutli Purpose Field',60),
('T1','Tennis Court',10),
('T2','Tennis Court',10);

INSERT INTO bookings(id,room_id,booked_date,booked_time,member_id,datetime_of_booking,payment_status) VALUES
(1, 'AR', '2017-12-26', '13:00:00', 'oreillys', '2017-12-20 20:31:27', 'Paid'),
(2, 'MPF1', '2017-12-30', '17:00:00', 'noah51', '2017-12-22 05:22:10', 'Paid'),
(3, 'T2', '2017-12-31', '16:00:00', 'macejkovic73', '2017-12-28 18:14:23', 'Paid'),
(4, 'T1', '2018-03-05', '08:00:00', 'little31', '2018-02-22 20:19:17', 'Unpaid'),
(5, 'MPF2', '2018-03-02', '11:00:00', 'marvin1', '2018-03-01 16:13:45', 'Paid'),
(6, 'B1', '2018-03-28', '16:00:00', 'marvin1', '2018-03-23 22:46:36', 'Paid'),
(7, 'B1', '2018-04-15', '14:00:00', 'macejkovic73', '2018-04-12 22:23:20', 'Cancelled'),
(8, 'T2', '2018-04-23', '13:00:00', 'macejkovic73', '2018-04-19 10:49:00', 'Cancelled'),
(9, 'T1', '2018-05-25', '10:00:00', 'marvin1', '2018-05-21 11:20:46', 'Unpaid'),
(10, 'B2', '2018-06-12', '15:00:00', 'bbahringer', '2018-05-30 14:40:23', 'Paid');

CREATE VIEW member_bookings AS 
SELECT bookings.id,room_id,rooms.room_type,booked_date,booked_time,member_id,datetime_of_booking,rooms.price,payment_status
FROM bookings
JOIN rooms
ON bookings.room_id = rooms.id
ORDER BY bookings.id;

SELECT * FROM member_bookings;

-- Creating stored procedures for our project 
DELIMITER $$

-- STORED PROCEDURES
-- insert_new_member
CREATE PROCEDURE insert_new_member(IN p_id VARCHAR(255), IN p_password VARCHAR(255), IN p_email VARCHAR(255))
BEGIN
	INSERT INTO members(id, password, email) VALUES (p_id,p_password,p_email);
END $$

-- delete_member
CREATE PROCEDURE delete_member(IN p_id VARCHAR(255))
BEGIN 
	DELETE FROM members WHERE id = p_id;
END $$

-- update_member_password
CREATE PROCEDURE update_member_password(IN p_id VARCHAR(255), IN p_password VARCHAR(255))
BEGIN 
	UPDATE members
    SET password = p_password
    WHERE id = p_id;
END $$

-- update_member_email
CREATE PROCEDURE update_member_email(IN p_id VARCHAR(255), IN p_email VARCHAR(255))
BEGIN 
	UPDATE members
    SET email = p_email
    WHERE id = p_id;
END $$

-- make_booking
CREATE PROCEDURE make_booking(IN p_room_id VARCHAR(255), IN p_booked_date DATE, IN p_booked_time TIME, IN p_member_id VARCHAR(255))
BEGIN
	DECLARE v_price FLOAT;
    DECLARE v_payment_due FLOAT;
    SELECT price INTO v_price FROM rooms WHERE id = p_room_id;
    INSERT INTO bookings(room_id, booked_date, booked_time, member_id) VALUES 
    (p_room_id, p_booked_date, p_booked_time, p_member_id);
    SELECT payment_due INTO v_payment_due FROM members WHERE id = p_member_id;
    UPDATE members SET payment_due = v_payment_due + v_price WHERE id = p_member_id;
END $$

-- page 143


DELIMITER ;

SHOW TABLES;
DESCRIBE members;
DESCRIBE rooms;
DESCRIBE bookings;
DESCRIBE member_bookings;
DESCRIBE pending_terminations;
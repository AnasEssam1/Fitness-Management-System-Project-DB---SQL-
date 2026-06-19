SHOW DATABASES;
CREATE DATABASE Fitness_App;
USE Fitness_App;

##########################################
#### Fitness_Managment_System_Project ####
##########################################
-- v7
-- by Anas Awad and some of team member worked with me in this major Project 
------------------------
-- Create_Tables --
------------------------

#--Trainer/coach table
CREATE TABLE Trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    experience_years INT NOT NULL,
    certification VARCHAR(255),
    phone_number VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE
);

#--User table 
CREATE TABLE Users (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR (100) NOT NULL,
    email VARCHAR (100) UNIQUE NOT NULL,
    password_hash VARCHAR (255) NOT NULL,
    age INT NOT NULL,
    height_cm DOUBLE NOT NULL,
    weight_kg DOUBLE NOT NULL,
    trainer_id INT,
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id) ON DELETE SET NULL
);

#--Workout table
CREATE TABLE Workouts (
	workout_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    workout_name VARCHAR (100) NOT NULL,
    workout_date DATE NOT NULL,
    duration_mins INT NOT NULL,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

#--Exercise table
CREATE TABLE Exercises (
	exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    exercise_name VARCHAR (100) NOT NULL,
    muscle_group VARCHAR (100) NOT NULL,
    equipment VARCHAR (100) NOT NULL
);

#--Workout session table
CREATE TABLE Workout_Sessions (
	session_id INT AUTO_INCREMENT PRIMARY KEY,
    workout_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    location ENUM ('Gym', 'Home', 'Outdoors') DEFAULT 'Home' NOT NULL,
    FOREIGN KEY (workout_id) REFERENCES Workouts(workout_id) ON DELETE CASCADE,
    CHECK (end_time > start_time)
);

#--Progress table
CREATE TABLE Progress (
	progress_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    progress_date DATE NOT NULL,
    weight_kg FLOAT NOT NULL,
    body_fat FLOAT NOT NULL,       -- unit: percentage (%)
    muscle_mass FLOAT NOT NULL,    -- unit: kilograms (kg)
    bmi FLOAT NOT NULL,            -- unit: kg/m²
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

#--Goal table
-- FIX: Changed 'IN Progress' → 'In_Progress' to follow standard ENUM naming conventions
CREATE TABLE Goals (
	goal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    goal_type ENUM ('Lose Weight', 'Gain Weight', 'Build Muscle') DEFAULT 'Lose Weight' NOT NULL,
    weight_target FLOAT NOT NULL,
    deadline DATE NOT NULL,
    goal_status ENUM ('In_Progress', 'Completed', 'Failed') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

#--Supplements table
CREATE TABLE Supplements (
	supp_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    supp_name VARCHAR (100) NOT NULL,
    supp_type VARCHAR (100) NOT NULL,
    dosage_mg FLOAT NOT NULL,
    frequency VARCHAR (100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

#--Workout_Exercise table
CREATE TABLE Workout_Exercises (
	workout_exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    workout_id INT NOT NULL,
    exercise_id INT NOT NULL,
    sets INT NOT NULL,
    reps INT NOT NULL,
    weight_kg FLOAT NOT NULL,
    FOREIGN KEY (workout_id) REFERENCES Workouts(workout_id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES Exercises(exercise_id) ON DELETE CASCADE
);

#--Diet_plan table
-- FIX: Added end_date column so diet plan expiry is trackable
CREATE TABLE Diet_Plans (
	plan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_name VARCHAR (100) NOT NULL,
    diet_type VARCHAR (100) NOT NULL,
    cal_per_day INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,                 -- nullable: NULL means plan is still active
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

#--Subscriptions table
CREATE TABLE Subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subscription_type ENUM('Basic', 'Premium', 'VIP') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    subscription_status ENUM('Active', 'Expired', 'Cancelled') DEFAULT 'Active',
    price_monthly DECIMAL(10, 2) NOT NULL,
    features TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

#--Payments table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subscription_id INT NOT NULL,
    amount DOUBLE NOT NULL,
    payment_method ENUM('Cash', 'Visa') NOT NULL,
    payment_date DATE NOT NULL,
    payment_status ENUM('Paid', 'Pending', 'Failed') DEFAULT 'Paid',
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_id) REFERENCES Subscriptions(subscription_id) ON DELETE CASCADE
);

# -- User_Trainer table
CREATE TABLE User_Trainers (
    user_trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    trainer_id INT NOT NULL,
    assigned_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id) ON DELETE CASCADE
);

################################
################################
------------------------
-- SAMPLE_INSERT_DATA --
------------------------
------------------------
-- Trainers (10)
------------------------
INSERT INTO Trainers (trainer_name, specialization, experience_years, certification, phone_number, email)
VALUES
('Ahmed Nasser', 'Strength Training', 8, 'NASM Certified', '01011111111', 'ahmed1@fit.com'),
('Mohamed Ali', 'Bodybuilding', 10, 'IFBB Certified', '01022222222', 'mohamed@fit.com'),
('Omar Samy', 'Weight Loss', 6, 'ACE Certified', '01033333333', 'omar@fit.com'),
('Khaled Mostafa', 'Functional Training', 7, 'CrossFit L1', '01044444444', 'khaled@fit.com'),
('Youssef Hany', 'Powerlifting', 9, 'IPF Coach', '01055555555', 'youssef@fit.com'),
('Ali Magdy', 'Fitness General', 5, 'NASM', '01066666666', 'ali@fit.com'),
('Tamer Adel', 'Rehabilitation', 12, 'Physio Cert', '01077777777', 'tamer@fit.com'),
('Hassan Fathy', 'Endurance Training', 8, 'Ironman Coach', '01088888888', 'hassan@fit.com'),
('Mostafa Ehab', 'HIIT Training', 4, 'HIIT Cert', '01099999999', 'mostafa@fit.com'),
('Karim Adel', 'Nutrition & Fitness', 11, 'Sports Nutrition Cert', '01000000000', 'karim@fit.com');

------------------------
-- Users (6)
------------------------
INSERT INTO Users (username, email, password_hash, age, height_cm, weight_kg, trainer_id)
VALUES
('anas', 'anas@mail.com', 'hash1', 19, 173, 75, 1),
('ahmed', 'ahmed@mail.com', 'hash2', 21, 180, 80, 2),
('mohamed', 'mohamed@mail.com', 'hash3', 20, 175, 78, 3),
('ali', 'ali@mail.com', 'hash4', 22, 178, 85, 4),
('youssef', 'youssef@mail.com', 'hash5', 18, 170, 70, 5),
('omar', 'omar@mail.com', 'hash6', 23, 182, 90, 6);

------------------------
-- Subscriptions (4) - Improved Tier Logic
INSERT INTO Subscriptions (user_id, subscription_type, start_date, end_date, subscription_status, price_monthly, features)
VALUES
(1, 'Premium', '2026-01-01', '2026-06-01', 'Active', 250.00, 'Full workouts + diet plans + progress tracking'),
(2, 'Basic', '2026-02-01', '2026-05-01', 'Active', 100.00, 'Limited workouts + basic tracking'),
(3, 'VIP', '2026-01-10', '2026-07-10', 'Active', 400.00, 'Personal trainer + custom diet + priority support + full analytics'),
(4, 'Premium', '2026-03-01', '2026-09-01', 'Active', 250.00, 'Full workouts + diet plans + progress tracking');

------------------------
-- Payments (4)
-- FIX: Payment amounts now match their subscription price_monthly values
------------------------
INSERT INTO Payments (user_id, subscription_id, amount, payment_method, payment_date, payment_status)
VALUES
(1, 1, 250, 'Visa', '2026-01-01', 'Paid'),   -- was 200, subscription is 250
(2, 2, 100, 'Cash', '2026-02-01', 'Paid'),
(3, 3, 400, 'Visa', '2026-01-10', 'Paid'),   -- was 300, subscription is 400
(4, 4, 250, 'Cash', '2026-03-01', 'Paid');   -- was 200, subscription is 250

------------------------
-- Workouts (10)
------------------------
INSERT INTO Workouts (user_id, workout_name, workout_date, duration_mins, notes)
VALUES
(1,'Push Day','2026-05-01',60,'Chest focus'),
(2,'Pull Day','2026-05-02',70,'Back focus'),
(3,'Leg Day','2026-05-03',80,'Heavy legs'),
(4,'Full Body','2026-05-04',90,'Fat burn'),
(5,'HIIT','2026-05-05',45,'Cardio'),
(6,'Abs','2026-05-06',40,'Core training'),
(1,'Push Day','2026-05-07',65,'Improved strength'),
(2,'Pull Day','2026-05-08',75,'Heavy back'),
(3,'Leg Day','2026-05-09',85,'Progress'),
(4,'Full Body','2026-05-10',90,'Advanced session');

------------------------
-- Exercises (10)
------------------------
INSERT INTO Exercises (exercise_name, muscle_group, equipment)
VALUES
('Bench Press','Chest','Barbell'),
('Squat','Legs','Barbell'),
('Deadlift','Back','Barbell'),
('Pull Up','Back','Bodyweight'),
('Shoulder Press','Shoulder','Dumbbell'),
('Bicep Curl','Arms','Dumbbell'),
('Tricep Dip','Arms','Bodyweight'),
('Lunges','Legs','Bodyweight'),
('Plank','Core','Bodyweight'),
('Running','Cardio','None');

------------------------
-- Workout Sessions (15)
-- FIX: Sessions that referenced workout_id=10 now use valid workout_ids (1–5)
--      because workout_id=10 is deleted later via DELETE, which would CASCADE
--      and orphan or drop those sessions unintentionally.
------------------------
INSERT INTO Workout_Sessions (workout_id, start_time, end_time, location)
VALUES
(1,'2026-05-01 10:00','2026-05-01 11:00','Gym'),
(2,'2026-05-02 10:00','2026-05-02 11:10','Gym'),
(3,'2026-05-03 09:00','2026-05-03 10:20','Gym'),
(4,'2026-05-04 08:00','2026-05-04 09:30','Gym'),
(5,'2026-05-05 07:00','2026-05-05 07:45','Home'),
(6,'2026-05-06 06:00','2026-05-06 06:40','Home'),
(7,'2026-05-07 10:00','2026-05-07 11:05','Gym'),
(8,'2026-05-08 10:00','2026-05-08 11:15','Gym'),
(9,'2026-05-09 09:00','2026-05-09 10:25','Gym'),
(1,'2026-05-10 08:00','2026-05-10 09:30','Gym'),  -- was workout_id=10 (deleted)
(1,'2026-05-11 10:00','2026-05-11 11:00','Gym'),
(2,'2026-05-12 10:00','2026-05-12 11:10','Gym'),
(3,'2026-05-13 09:00','2026-05-13 10:20','Gym'),
(4,'2026-05-14 08:00','2026-05-14 09:30','Gym'),
(5,'2026-05-15 07:00','2026-05-15 07:45','Home');

------------------------
-- Progress (6)
------------------------
INSERT INTO Progress (user_id, progress_date, weight_kg, body_fat, muscle_mass, bmi, notes)
VALUES
(1,'2026-05-01',75,20,40,24,'Good'),
(2,'2026-05-02',80,22,42,25,'OK'),
(3,'2026-05-03',78,21,41,24.5,'Stable'),
(4,'2026-05-04',85,23,43,26,'Needs work'),
(5,'2026-05-05',70,18,39,23,'Improving'),
(6,'2026-05-06',90,25,45,27,'High fat');

------------------------
-- Goals (6)
-- FIX: Updated status values from 'IN Progress' → 'In_Progress' to match corrected ENUM
------------------------
INSERT INTO Goals (user_id, goal_type, weight_target, deadline, goal_status)
VALUES
(1,'Lose Weight',70,'2026-08-01','In_Progress'),
(2,'Build Muscle',85,'2026-09-01','In_Progress'),
(3,'Gain Weight',82,'2026-07-01','In_Progress'),
(4,'Lose Weight',78,'2026-06-01','In_Progress'),
(5,'Build Muscle',75,'2026-10-01','In_Progress'),
(6,'Lose Weight',85,'2026-12-01','In_Progress');

------------------------
-- Supplements (5)
------------------------
INSERT INTO Supplements (user_id, supp_name, supp_type, dosage_mg, frequency)
VALUES
(1,'Whey Protein','Protein',30,'Daily'),
(2,'Creatine','Strength',5,'Daily'),
(3,'BCAA','Recovery',10,'Workout Days'),
(4,'Multivitamin','Health',1,'Daily'),
(5,'Omega 3','Fatty Acid',2,'Daily');

------------------------
-- Diet Plans (6)
-- FIX: Added end_date values to match the new end_date column in Diet_Plans
------------------------
INSERT INTO Diet_Plans (user_id, plan_name, diet_type, cal_per_day, start_date, end_date)
VALUES
(1,'Cutting Plan','Low Carb',2000,'2026-05-01','2026-08-01'),
(2,'Bulking Plan','High Protein',3000,'2026-05-02','2026-09-01'),
(3,'Maintenance','Balanced',2500,'2026-05-03','2026-07-01'),
(4,'Fat Loss','Keto',1800,'2026-05-04','2026-06-01'),
(5,'Muscle Gain','High Calorie',3200,'2026-05-05','2026-10-01'),
(6,'Healthy','Balanced',2400,'2026-05-06',NULL);  -- NULL = still active

------------------------
-- Workout Exercises (15)
------------------------
INSERT INTO Workout_Exercises (workout_id, exercise_id, sets, reps, weight_kg)
VALUES
(1,1,4,10,60),
(2,3,4,8,80),
(3,2,5,12,100),
(4,10,3,1,0),
(5,9,3,60,0),
(6,6,4,12,15),
(7,1,4,10,65),
(8,4,5,8,0),
(9,2,5,10,110),
(1,5,4,10,20),  -- was workout_id=10 (deleted), moved to workout_id=1
(1,7,3,12,0),
(2,8,3,15,0),
(3,3,4,8,85),
(4,10,3,2,0),
(5,9,4,60,0);

------------------------
-- User Trainers (6)
------------------------
INSERT INTO User_Trainers (user_id, trainer_id, assigned_date)
VALUES
(1,1,'2026-01-01'),
(2,2,'2026-01-02'),
(3,3,'2026-01-03'),
(4,4,'2026-01-04'),
(5,5,'2026-01-05'),
(6,6,'2026-01-06');

------------------------
-- SAMPLE_UPDATE_DATA --
------------------------

UPDATE Users
SET weight_kg = 77
WHERE user_id = 1;

-- FIX: Updated goal_status value to match corrected ENUM 'In_Progress' → 'Completed'
UPDATE Goals
SET goal_status = 'Completed'
WHERE goal_id = 1;

UPDATE Subscriptions
SET subscription_type = 'Premium',
    price_monthly = 250.00,
    features = 'Full workouts + diet plans + progress tracking'
WHERE subscription_id = 2;

UPDATE Exercises
SET equipment = 'Barbell + Machine'
WHERE exercise_id = 1;

------------------------
-- SAMPLE_DELETE_DATA --
------------------------

DELETE FROM Progress
WHERE progress_id = 6;

DELETE FROM Supplements
WHERE supp_id = 5;

DELETE FROM Workouts
WHERE workout_id = 10;

------------------------
-- SAMPLE_SELECT_DATA --
------------------------

SELECT * FROM Users;
SELECT * FROM Exercises;
SELECT * FROM Subscriptions;
SELECT user_id, workout_name, workout_date FROM Workouts;

################################
################################

------------------------
-- Queries & Reports --
------------------------

-- JOIN --
SELECT Users.username, Trainers.trainer_name
FROM Users
JOIN Trainers ON Users.trainer_id = Trainers.trainer_id;

SELECT Users.username, Workouts.workout_name
FROM Users
JOIN Workouts ON Users.user_id = Workouts.user_id;

SELECT Workouts.workout_name, Exercises.exercise_name
FROM Workout_Exercises
JOIN Workouts ON Workout_Exercises.workout_id = Workouts.workout_id
JOIN Exercises ON Workout_Exercises.exercise_id = Exercises.exercise_id;

-- GROUP BY --
SELECT user_id, COUNT(*) AS total_workouts
FROM Workouts
GROUP BY user_id;

SELECT muscle_group, COUNT(*) AS total_exercises
FROM Exercises
GROUP BY muscle_group;

-- ORDER BY --
SELECT username, weight_kg
FROM Users
ORDER BY weight_kg DESC;

SELECT workout_name, duration_mins
FROM Workouts
ORDER BY duration_mins DESC;

-- COUNT / SUM / AVG --

SELECT COUNT(*) AS total_users FROM Users;
SELECT COUNT(*) AS total_exercises FROM Exercises;

SELECT SUM(duration_mins) AS total_minutes FROM Workouts;
SELECT SUM(amount) AS total_revenue FROM Payments;

SELECT AVG(weight_kg) AS avg_weight FROM Users;
SELECT AVG(duration_mins) AS avg_duration FROM Workouts;
SELECT AVG(body_fat) AS avg_body_fat FROM Progress;

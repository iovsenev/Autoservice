
CREATE DATABASE AutoServiceDB;


USE AutoServiceDB;


IF OBJECT_ID('Repairs', 'U') IS NOT NULL DROP TABLE Repairs;
IF OBJECT_ID('Cars', 'U') IS NOT NULL DROP TABLE Cars;
IF OBJECT_ID('Masters', 'U') IS NOT NULL DROP TABLE Masters;
IF OBJECT_ID('Owners', 'U') IS NOT NULL DROP TABLE Owners;


CREATE TABLE Owners (
    OwnerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Address NVARCHAR(200),
    Passport NVARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE Cars (
    CarID INT PRIMARY KEY IDENTITY(1,1),
    Brand NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    PlateNumber NVARCHAR(20) NOT NULL UNIQUE,
    Mileage INT NOT NULL,
    EngineVolume DECIMAL(4,1),
    OwnerID INT NOT NULL,
    FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID)
);


CREATE TABLE Masters (
    MasterID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    ExperienceYears INT NOT NULL CHECK (ExperienceYears >= 0)
);


CREATE TABLE Repairs (
    RepairID INT PRIMARY KEY IDENTITY(1,1),
    CarID INT NOT NULL,
    MasterID INT NOT NULL,
    IssueDescription NVARCHAR(200) NOT NULL,
    Cost DECIMAL(10,2) NOT NULL CHECK (Cost >= 0),
    DateStart DATE NOT NULL,
    DateEnd DATE NULL,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (MasterID) REFERENCES Masters(MasterID)
);

INSERT INTO Owners (FullName, Phone, Address, Passport)
VALUES 
(N'Иванов Иван Иванович', '+79991234567', N'Москва, ул. Пушкина, д. 1', '1234 567890'),
(N'Петров Петр Петрович', '+79997654321', N'Санкт-Петербург, Невский пр., д. 10', '1234 567891'),
(N'Сидоров Алексей Михайлович', '+79995553322', N'Казань, ул. Баумана, д. 5', '31234 567892'),
(N'Иванов Петр Иванович', '+74991234567', N'Москва, ул. Пушкина, д. 1', '1234 567893'),
(N'Петров Иван Петрович', '+77997654321', N'Санкт-Петербург, Невский пр., д. 10', '1234 567894'),
(N'Сидоров Арсен Михайлович', '+78995553322', N'Казань, ул. Баумана, д. 5', '1234 567895'),
(N'Иванов Валерий Иванович', '+79891234567', N'Москва, ул. Пушкина, д. 1', '1234 567896'),
(N'Петров Георгий Петрович', '+79597654321', N'Санкт-Петербург, Невский пр., д. 10', '1234 567897'),
(N'Сидоров Владилен Михайлович', '+71995553322', N'Казань, ул. Баумана, д. 5', '1234 567898');


INSERT  INTO  Cars (Brand, Model, PlateNumber, Mileage, EngineVolume, OwnerID )
VALUES 
('Toyota', 'Camry', 'A123BC77', 150000, 2.5, 1),
('BMW', 'X5', 'B456CD78', 90000, 3.0, 1),
('Lada', 'Vesta', 'C789DE79', 40000, 1.6, 3),
('Toyota', 'Camry', 'A234BC77', 150000, 2.5, 2),
('BMW', 'X5', 'B567CD78', 90000, 3.0, 5),
('Lada', 'Vesta', 'C345DE79', 40000, 1.6, 4),
('Toyota', 'Camry', 'A765BC77', 150000, 2.5, 6),
('BMW', 'X5', 'B432CD78', 90000, 3.0, 7),
('Lada', 'Vesta', 'C111DE79', 40000, 1.6, 8)

INSERT  INTO Masters (FullName , Phone , ExperienceYears )
VALUES 
(N'Иванов Иван Иванович', '+71111234567', 2),
(N'Петров Петр Петрович', '+72227654321', 4),
(N'Сидоров Алексей Михайлович', '+73335553322', 6)

INSERT INTO  Repairs (CarID, MasterID, IssueDescription, Cost, DateStart , DateEnd )
VALUES 
(1, 1, N'РЕМОНТ КОЛЕС', 6000,        '2024-05-10', '2024-05-11'),
(2, 2, N'РЕМОНТ ДВИГАТЕЛЯ', 1200,    '2024-06-15', '2024-06-20'),
(3, 3, N'РЕМОНТ КУЗОВА', 123455,     '2024-07-01', '2024-07-10'),
(4, 2, N'РЕМОНТ АКПП', 567474,       '2024-08-05', '2024-08-12'),
(5, 1, N'РЕМОНТ КОЛЕС', 564,         '2024-09-09', '2024-09-10'),
(6, 2, N'РЕМОНТ КОЛЕС', 7674674,     '2024-10-14', '2024-10-15'),
(7, 3, N'РЕМОНТ КОЛЕС', 46574567,    '2024-11-11', '2024-11-20'),
(8, 3, N'РЕМОНТ САЛОНА', 34563,      '2024-12-02', '2024-12-05'),
(9, 3, N'РЕМОНТ КОЛЕС', 7654,        '2025-01-10', '2025-01-11'),
(1, 2, N'РЕМОНТ ФИЛЬТРА', 345612,    '2025-02-15', '2025-02-17'),
(2, 2, N'РЕМОНТ КОЛЕС', 765423,      '2025-05-05', '2025-05-07'),
(2, 1, N'РЕМОНТ ЛЮКА', 245245,       '2025-05-20', '2025-05-25'),
(1, 2, N'РЕМОНТ КОЛЕС', 234526,   '2025-05-01', '2025-06-02'),
(5, 3, N'РЕМОНТ ВСЕГО', 23452,    '2025-05-10', '2025-06-30'),
(1, 3, N'РЕМОНТ КОЛЕС', 23452,    '2025-05-01', '2025-06-03'),
(6, 2, N'РЕМОНТ МАШИНЫ', 245234,     '2024-06-01', '2024-06-05'),
(4, 1, N'РЕМОНТ КОЛЕС', 24352,   '2024-07-15', '2024-07-16'),
(1, 1, N'РЕМОНТ ХОЗЯИНА', 24352,  '2024-08-22', '2024-08-25');











create table Vendor
    (VendorID INT PRIMARY KEY,
    Vname CHAR(50) NOT NULL,
    PaymentInfo CHAR(50) NOT NULL,
    MonthlyFee DECIMAL(10,2) DEFAULT 100.00);

create table RestaurantLocation 
    (PostalCode CHAR(7),
    UnitNum CHAR(50),
    Street CHAR(50) NOT NULL,
    PRIMARY KEY (PostalCode, UnitNum));

create table AreaCode 
    (PostalCode CHAR(7) PRIMARY KEY,
    City CHAR(50),
    Province CHAR(50));

create table ManagesRestaurant 
    (RestaurantID INT PRIMARY KEY,
    VendorID INT NOT NULL,
    PostalCode CHAR(7) NOT NULL,
    Rname CHAR(50) NOT NULL,
    UnitNum CHAR(50) NOT NULL,
    CuisineType CHAR(50),
    JoinDate DATE,
    FOREIGN KEY (VendorID) REFERENCES Vendor (VendorID),
    FOREIGN KEY (PostalCode, UnitNum) REFERENCES RestaurantLocation (PostalCode, UnitNum),
    FOREIGN KEY (PostalCode) REFERENCES AreaCode (PostalCode));

create table Food
    (FoodID INT PRIMARY KEY,
    Fname CHAR(50) NOT NULL,
    Price DECIMAL(6,2) NOT NULL,
    Type CHAR(50));

create table Drivers 
    (DriverID INT PRIMARY KEY,
    DriversLicense CHAR(50) NOT NULL,
    DName CHAR(50) NOT NULL,
    DrivingRecordApproved INT,
    UNIQUE (DriversLicense));

create table AddressDestination 
    (HouseNum CHAR(50),
    PostalCode CHAR(7),
    Street CHAR(50),
    City CHAR(50),
    Province CHAR(50),
    PRIMARY KEY (HouseNum, PostalCode));

create table TrialRange
    (TrialStartDate DATE PRIMARY KEY,
    TrialEndDate DATE);

create table MembershipInfo
    (MembershipLevel INT,
    MonthlyFee DECIMAL(6,2),
    PRIMARY KEY (MembershipLevel));

create table Customer 
    (CustomerID INT,
    Cname CHAR(50),
    Email CHAR(50) UNIQUE,
    PaymentInfo CHAR(50),
    TrialStartDate DATE,
    MembershipLevel INT,
    Points INT,
    PRIMARY KEY (CustomerID),
    FOREIGN KEY (MembershipLevel) REFERENCES MembershipInfo (MembershipLevel),
    FOREIGN KEY (TrialStartDate) REFERENCES TrialRange (TrialStartDate));

create table Drivers_Vehicle
    (DriverID INT,
    VehicleNum INT NOT NULL,
    InsuranceNum INT NOT NULL,
    PRIMARY KEY (DriverID, VehicleNum),
    FOREIGN KEY (DriverID) REFERENCES Drivers (DriverID) ON DELETE CASCADE);

create table Serves 
    (RestaurantID INT,
    FoodID INT,
    PRIMARY KEY (RestaurantID, FoodID),
    FOREIGN KEY (RestaurantID) REFERENCES ManagesRestaurant (RestaurantID) ON DELETE CASCADE,
    FOREIGN KEY (FoodID) REFERENCES Food (FoodID) ON DELETE CASCADE);

create table Receipt
    (Subtotal DECIMAL (6,2),
    Tax DECIMAL (6,2),
    DeliveryFee DECIMAL (6,2),
    Total DECIMAL (6,2),
    PRIMARY KEY (Subtotal, Tax, DeliveryFee));

create table MakesOrder
    (OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    DeliveryFee DECIMAL(6,2) NOT NULL,
    Subtotal DECIMAL(6,2) NOT NULL,
    Tax DECIMAL(6,2) NOT NULL,
    OrderTime TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
    FOREIGN KEY (DeliveryFee, Subtotal, Tax) REFERENCES Receipt (DeliveryFee, Subtotal, Tax));

create table OrderDestination 
    (OrderID INT PRIMARY KEY,
    HouseNum CHAR(50) NOT NULL,
    PostalCode CHAR(7) NOT NULL,
    FOREIGN KEY (OrderID) References MakesOrder (OrderID),
    FOREIGN KEY (HouseNum, PostalCode) REFERENCES AddressDestination (HouseNum, PostalCode));

create table RequestsOrder 
    (RestaurantID INT,
    FoodID INT,
    OrderID INT,
    PRIMARY KEY (RestaurantID, FoodID, OrderID),
    FOREIGN KEY (RestaurantID) REFERENCES ManagesRestaurant (RestaurantID),
    FOREIGN KEY (FoodID) REFERENCES Food (FoodID),
    FOREIGN KEY (OrderID) REFERENCES MakesOrder (OrderID));

create table PicksUpOrder 
    (OrderID INT,
    DriverID INT NOT NULL,
    PickupTime TIMESTAMP,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (OrderID) REFERENCES MakesOrder (OrderID),
    FOREIGN KEY (DriverID) REFERENCES Drivers (DriverID) ON DELETE CASCADE);

create table Transactions 
    (CustomerID INT,
    RestaurantID INT,
    PRIMARY KEY (CustomerID, RestaurantID),
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES ManagesRestaurant (RestaurantID));

create table DeliversTo 
    (DriverID INT,
    HouseNum CHAR(50),
    PostalCode CHAR(7),
    PRIMARY KEY (DriverID, HouseNum, PostalCode),
    FOREIGN KEY (DriverID) REFERENCES Drivers (DriverID) ON DELETE CASCADE,
    FOREIGN KEY (HouseNum, PostalCode) REFERENCES AddressDestination (HouseNum, PostalCode));

create table RequestsAddress 
    (HouseNum CHAR(50),
    PostalCode CHAR(7),
    CustomerID INT,
    PRIMARY KEY (HouseNum, PostalCode, CustomerID),
    FOREIGN KEY (HouseNum, PostalCode) REFERENCES AddressDestination (HouseNum, PostalCode),
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID));


INSERT INTO Vendor VALUES ('1390', 'Food Master', '1234 5678 9876', '100.00');
INSERT INTO Vendor VALUES ('1391', 'Ronald McDonald ', '1342 6767 8787 ', '800.00');
INSERT INTO Vendor VALUES ('1392', 'Gordon Ramsay', '2787 7878 8283 ', '200.00');
INSERT INTO Vendor VALUES ('1393', 'ABC Food Corp ', '9078 3647 2834 ', '259.00');
INSERT INTO Vendor VALUES ('1394', 'Best Food Coop ', '9076 3241 2639 ', '100.00');

INSERT INTO RestaurantLocation VALUES ('V7S 3G5', '201-2013', 'Broadway');
INSERT INTO RestaurantLocation VALUES ('P5N 7F8', '1342', 'Fraser');
INSERT INTO RestaurantLocation VALUES ('J5K 6N8', '2039', 'Main');
INSERT INTO RestaurantLocation VALUES ('K6B 7C8', '1854', 'Keefer');
INSERT INTO RestaurantLocation VALUES ('Z6Y 8V9', '3049', 'McDonald');

INSERT INTO RestaurantLocation VALUES ('V3E 3R7', '2009', 'Ioco');


INSERT INTO AreaCode VALUES ('V7S 3G5', 'Vancouver', 'British Columbia');
INSERT INTO AreaCode VALUES ('P5N 7F8', 'Vancouver', 'British Columbia');
INSERT INTO AreaCode VALUES ('J5K 6N8', 'Vancouver', 'British Columbia');
INSERT INTO AreaCode VALUES ('K6B 7C8', 'Langley', 'British Columbia');
INSERT INTO AreaCode VALUES ('Z6Y 8V9', 'Burnaby', 'British Columbia');

INSERT INTO AreaCode VALUES ('V3E 3R7', 'Coquitlam', 'British Columbia');


INSERT INTO ManagesRestaurant VALUES ('3524', '1390', 'V7S 3G5', 'Broadway Chicken Shop', '201-2013', 'Western', TO_DATE('12-SEP-2019', 'DD-MON-YY'));
INSERT INTO ManagesRestaurant VALUES ('3525', '1391', 'P5N 7F8', 'Hee Rae Dong', '1342', 'Korean', TO_DATE('2-JAN-2020', 'DD-MON-YY'));
INSERT INTO ManagesRestaurant VALUES ('3526', '1392', 'J5K 6N8', 'Dumpling House', '2039', 'Chinese', TO_DATE('5-FEB-2019', 'DD-MON-YY'));
INSERT INTO ManagesRestaurant VALUES ('3527', '1393', 'K6B 7C8', 'Ajisai', '1854', 'Japanese', TO_DATE('2-APR-2019', 'DD-MON-YY'));
INSERT INTO ManagesRestaurant VALUES ('3528', '1394', 'Z6Y 8V9', 'Lemongrass', '3049', 'Vietnamese', TO_DATE('1-JAN-2020', 'DD-MON-YY'));

INSERT INTO ManagesRestaurant VALUES ('3529', '1390', 'V3E 3R7', 'Coffee Cantata', '2009', 'Western', TO_DATE('20-JAN-2019', 'DD-MON-YY'));


INSERT INTO Food VALUES ('2230', 'Potato Wedges', '7.00', 'Appetizer');
INSERT INTO Food VALUES ('2231', 'Chicken Noodle Soup ', '6.25 ', 'Soup');
INSERT INTO Food VALUES ('2232', 'Tomato Beef Noodle Soup', '14.95', 'Noodle');
INSERT INTO Food VALUES ('2234', 'Fries', '5.96', 'Appetizer');
INSERT INTO Food VALUES ('2235', 'Cherry Soda', '4.19', 'Drink');

INSERT INTO Food VALUES ('2236', 'Premium Steak Family Size', '100.00', 'Main Dish');
INSERT INTO Food VALUES ('2237', 'Sushi Big Party', '150.00', 'Main Dish');
INSERT INTO Food VALUES ('2238', 'Coffee Carafe', '50.00', 'Drink');
INSERT INTO Food VALUES ('2239', 'Kenya AA Hand Drip', '10.00', 'Drink');
INSERT INTO Food VALUES ('2240', 'Black Forest Cake', '60.00', 'Dessert');
INSERT INTO Food VALUES ('2241', 'Chicken Wrap Combo', '15.00', 'Main Dish');


INSERT INTO Drivers VALUES ('5380', '1827937', 'Lucy Shee', 1);
INSERT INTO Drivers VALUES ('5381', '1625374', 'Anthony Wong', 0);
INSERT INTO Drivers VALUES ('5382', '4859234', 'Jennifer Pan', 1);
INSERT INTO Drivers VALUES ('5383', '5849680', 'Ann Heinkel', 1);
INSERT INTO Drivers VALUES ('5384', '2637485', 'Harry Potter', 0);

INSERT INTO AddressDestination VALUES ('1288', 'V6E 4R3', 'W Georgia St', 'Vancouver', 'British Columbia');
INSERT INTO AddressDestination VALUES ('1104', 'V3J 2M8', 'Como Lake Ave', 'Coquitlam', 'British Columbia');
INSERT INTO AddressDestination VALUES ('2053', 'V6T 1Z2', 'Main Mall ', 'Vancouver', 'British Columbia');
INSERT INTO AddressDestination VALUES ('8800', 'V3J 7X5', 'Eastlake Dr', 'Burnaby', 'British Columbia');
INSERT INTO AddressDestination VALUES ('300', 'V3H 2M5', 'Albert St', 'Port Moody', 'British Columbia');

INSERT INTO TrialRange VALUES (TIMESTAMP'2019-01-01 00:00:01 US/Pacific', TIMESTAMP'2019-01-31 00:00:01 US/Pacific');
INSERT INTO TrialRange VALUES (TIMESTAMP'2020-03-01 09:00:01 US/Pacific', TIMESTAMP'2020-03-31 09:00:01 US/Pacific');
INSERT INTO TrialRange VALUES (TIMESTAMP'2012-05-01 04:00:01 US/Pacific', TIMESTAMP'2012-05-31 04:00:01 US/Pacific');
INSERT INTO TrialRange VALUES (TIMESTAMP'2013-07-01 02:05:01 US/Pacific', TIMESTAMP'2013-07-31 02:05:01 US/Pacific');
INSERT INTO TrialRange VALUES (TIMESTAMP'2014-08-01 06:00:01 US/Pacific', TIMESTAMP'2014-08-31 06:00:01 US/Pacific');

INSERT INTO MembershipInfo VALUES ('0', '0.00');
INSERT INTO MembershipInfo VALUES ('1', '2.00');
INSERT INTO MembershipInfo VALUES ('2', '5.00');
INSERT INTO MembershipInfo VALUES ('3', '7.00');
INSERT INTO MembershipInfo VALUES ('4', '10.00');

INSERT INTO Customer VALUES ('4456', 'Emily Wu', 'emilywu@gmail.com', '1789 9333 0000', TIMESTAMP'2019-01-01 00:00:01 US/Pacific', '1', '123');
INSERT INTO Customer VALUES ('4457', 'Taehyung Kim', 'kimtaehyung@gmail.com', '1111 2222 3333', TIMESTAMP'2020-03-01 09:00:01 US/Pacific', '2', '6789');
INSERT INTO Customer VALUES ('4458', 'Taylor Baker', 'taylorbaker@gmail.com', '5555 6666 7777', TIMESTAMP'2012-05-01 04:00:01 US/Pacific', '3', '12222');
INSERT INTO Customer VALUES ('4459', 'Maya Zabihi', 'mayazabihi@yahoo.ca', '8888 9999 1010', TIMESTAMP'2013-07-01 02:05:01 US/Pacific', '4', '98723');
INSERT INTO Customer VALUES ('4460', 'Kassidy Lu', 'kassidy.lu@yahoo.ca', '0987 7890 0987', TIMESTAMP'2014-08-01 06:00:01 US/Pacific', '0', '29');

INSERT INTO Drivers_Vehicle VALUES ('5380', '1', '000000000');
INSERT INTO Drivers_Vehicle VALUES ('5381', '2', '111111111');
INSERT INTO Drivers_Vehicle VALUES ('5382', '1', '222222222');
INSERT INTO Drivers_Vehicle VALUES ('5383', '3', '333333333');
INSERT INTO Drivers_Vehicle VALUES ('5384', '2', '444444444');

INSERT INTO Drivers_Vehicle VALUES ('5384', '1', '555555555');


INSERT INTO Serves VALUES ('3524', '2230');
INSERT INTO Serves VALUES ('3525', '2231');
INSERT INTO Serves VALUES ('3526', '2232');
INSERT INTO Serves VALUES ('3527', '2234');
INSERT INTO Serves VALUES ('3528', '2235');

INSERT INTO Serves VALUES ('3526', '2236');
INSERT INTO Serves VALUES ('3527', '2237');
INSERT INTO Serves VALUES ('3529', '2238');
INSERT INTO Serves VALUES ('3529', '2239');
INSERT INTO Serves VALUES ('3529', '2240');
INSERT INTO Serves VALUES ('3524', '2241');


INSERT INTO Receipt VALUES ('93.80', '4.98', '5.80', '104.58');
INSERT INTO Receipt VALUES ('125.75', '6.29', '0.00', '132.04');
INSERT INTO Receipt VALUES ('23.09', '1.27', '2.30', '26.66');
INSERT INTO Receipt VALUES ('15.70', '0.91', '2.57', '19.18');
INSERT INTO Receipt VALUES ('258.03', '13.31', '8.30', '279.65');

INSERT INTO Receipt VALUES ('100.00', '5.00', '5.00', '110.00');
INSERT INTO Receipt VALUES ('150.00', '7.50', '6.50', '164.00');
INSERT INTO Receipt VALUES ('50.00', '2.50', '3.50', '56.00');
INSERT INTO Receipt VALUES ('10.00', '0.50', '2.30', '12.80');
INSERT INTO Receipt VALUES ('60.00', '3.00', '3.80', '66.80');
INSERT INTO Receipt VALUES ('60.00', '3.00', '3.00', '66.00');
INSERT INTO Receipt VALUES ('15.00', '0.75', '2.45', '18.20');

INSERT INTO Receipt VALUES ('7.00', '0.35', '2.21', '9.56');
INSERT INTO Receipt VALUES ('14.95', '0.75', '2.45', '18.15');
INSERT INTO Receipt VALUES ('4.19', '0.21', '2.13', '6.53');

INSERT INTO Receipt VALUES ('6.25', '0.31', '2.19', '8.75');
INSERT INTO Receipt VALUES ('5.96', '0.30', '2.18', '8.44');
INSERT INTO Receipt VALUES ('4.19', '0.21', '2.17', '6.57');


INSERT INTO MakesOrder VALUES ('6021', '4456', '5.80', '93.80', '4.98', TIMESTAMP'2019-08-01 23:30:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6022', '4457', '0.00', '125.75', '6.29', TIMESTAMP'2019-09-09 01:00:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6023', '4458', '2.30', '23.09', '1.27', TIMESTAMP'2019-12-21 11:20:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6024', '4459', '2.57', '15.70', '0.91', TIMESTAMP'2020-06-11 09:48:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6025', '4460', '8.30', '258.03', '13.31', TIMESTAMP'2020-08-24 03:20:01 US/Pacific');

INSERT INTO MakesOrder VALUES ('6026', '4456', '5.00', '100.00', '5.00', TIMESTAMP'2019-08-11 20:30:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6027', '4457', '6.50', '150.00', '7.50', TIMESTAMP'2019-08-21 19:30:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6028', '4456', '3.50', '50.00', '2.50', TIMESTAMP'2019-09-29 14:30:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6029', '4456', '2.30', '10.00', '0.50', TIMESTAMP'2019-11-29 14:30:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6030', '4456', '3.80', '60.00', '3.00', TIMESTAMP'2019-12-29 14:30:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6031', '4457', '3.00', '60.00', '3.00', TIMESTAMP'2019-12-25 11:00:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6032', '4456', '2.45', '15.00', '0.75', TIMESTAMP'2020-1-20 12:00:01 US/Pacific');

INSERT INTO MakesOrder VALUES ('6033', '4457', '2.21', '7.00', '0.35', TIMESTAMP'2019-12-26 17:00:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6034', '4457', '2.45', '14.95', '0.75', TIMESTAMP'2019-12-27 18:30:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6035', '4457', '2.13', '4.19', '0.21', TIMESTAMP'2019-12-28 09:30:01 US/Pacific');

INSERT INTO MakesOrder VALUES ('6036', '4456', '2.19', '6.25', '0.31', TIMESTAMP'2020-2-08 11:20:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6037', '4456', '2.18', '5.96', '0.30', TIMESTAMP'2020-3-13 02:30:01 US/Pacific');
INSERT INTO MakesOrder VALUES ('6038', '4456', '2.17', '4.19', '0.21', TIMESTAMP'2020-4-24 15:00:01 US/Pacific');


INSERT INTO OrderDestination VALUES ('6021', '1288', 'V6E 4R3');
INSERT INTO OrderDestination VALUES ('6022', '1104', 'V3J 2M8');
INSERT INTO OrderDestination VALUES ('6023', '2053', 'V6T 1Z2');
INSERT INTO OrderDestination VALUES ('6024', '8800', 'V3J 7X5');
INSERT INTO OrderDestination VALUES ('6025', '300', 'V3H 2M5');

INSERT INTO OrderDestination VALUES ('6026', '1288', 'V6E 4R3');
INSERT INTO OrderDestination VALUES ('6027', '1104', 'V3J 2M8');
INSERT INTO OrderDestination VALUES ('6028', '1288', 'V6E 4R3');
INSERT INTO OrderDestination VALUES ('6029', '1288', 'V6E 4R3');
INSERT INTO OrderDestination VALUES ('6030', '1288', 'V6E 4R3');
INSERT INTO OrderDestination VALUES ('6031', '1104', 'V3J 2M8');
INSERT INTO OrderDestination VALUES ('6032', '1288', 'V6E 4R3');

INSERT INTO OrderDestination VALUES ('6033', '1104', 'V3J 2M8');
INSERT INTO OrderDestination VALUES ('6034', '1104', 'V3J 2M8');
INSERT INTO OrderDestination VALUES ('6035', '1104', 'V3J 2M8');

INSERT INTO OrderDestination VALUES ('6036', '1288', 'V6E 4R3');
INSERT INTO OrderDestination VALUES ('6037', '1288', 'V6E 4R3');
INSERT INTO OrderDestination VALUES ('6038', '1288', 'V6E 4R3');


INSERT INTO RequestsOrder VALUES ('3524', '2230', '6021');
INSERT INTO RequestsOrder VALUES ('3525', '2231', '6022');
INSERT INTO RequestsOrder VALUES ('3526', '2232', '6023');
INSERT INTO RequestsOrder VALUES ('3527', '2234', '6024');
INSERT INTO RequestsOrder VALUES ('3528', '2235', '6025');

INSERT INTO RequestsOrder VALUES ('3526', '2236', '6026');
INSERT INTO RequestsOrder VALUES ('3527', '2237', '6027');
INSERT INTO RequestsOrder VALUES ('3529', '2238', '6028');
INSERT INTO RequestsOrder VALUES ('3529', '2239', '6029');
INSERT INTO RequestsOrder VALUES ('3529', '2240', '6030');
INSERT INTO RequestsOrder VALUES ('3529', '2240', '6031');
INSERT INTO RequestsOrder VALUES ('3524', '2241', '6032');

INSERT INTO RequestsOrder VALUES ('3524', '2230', '6033');
INSERT INTO RequestsOrder VALUES ('3526', '2232', '6034');
INSERT INTO RequestsOrder VALUES ('3528', '2235', '6035');

INSERT INTO RequestsOrder VALUES ('3525', '2231', '6036');
INSERT INTO RequestsOrder VALUES ('3527', '2234', '6037');
INSERT INTO RequestsOrder VALUES ('3528', '2235', '6038');


INSERT INTO PicksUpOrder VALUES ('6021','5380', TIMESTAMP'2019-08-01 00:00:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6022','5381', TIMESTAMP'2019-09-09 01:30:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6023','5382', TIMESTAMP'2019-12-21 11:50:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6024','5383', TIMESTAMP'2020-06-11 10:08:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6025','5384', TIMESTAMP'2020-08-24 03:56:01 US/Pacific');

INSERT INTO PicksUpOrder VALUES ('6026','5383', TIMESTAMP'2019-08-11 21:00:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6027','5384', TIMESTAMP'2019-08-21 20:30:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6028','5383', TIMESTAMP'2019-09-29 15:00:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6029','5384', TIMESTAMP'2019-11-29 14:40:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6030','5384', TIMESTAMP'2019-12-29 14:50:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6031','5380', TIMESTAMP'2019-12-25 11:20:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6032','5380', TIMESTAMP'2020-01-20 12:30:01 US/Pacific');

INSERT INTO PicksUpOrder VALUES ('6033','5380', TIMESTAMP'2019-12-26 17:10:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6034','5380', TIMESTAMP'2019-12-27 18:50:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6035','5380', TIMESTAMP'2019-12-28 09:55:01 US/Pacific');

INSERT INTO PicksUpOrder VALUES ('6036','5384', TIMESTAMP'2020-2-08 11:30:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6037','5384', TIMESTAMP'2020-3-13 02:50:01 US/Pacific');
INSERT INTO PicksUpOrder VALUES ('6038','5384', TIMESTAMP'2020-4-24 15:20:01 US/Pacific');


INSERT INTO Transactions VALUES ('4456', '3524');
INSERT INTO Transactions VALUES ('4457', '3525');
INSERT INTO Transactions VALUES ('4458', '3526');
INSERT INTO Transactions VALUES ('4459', '3527');
INSERT INTO Transactions VALUES ('4460', '3528');

INSERT INTO Transactions VALUES ('4456', '3526');
INSERT INTO Transactions VALUES ('4457', '3527');
INSERT INTO Transactions VALUES ('4456', '3529');
INSERT INTO Transactions VALUES ('4457', '3529');

INSERT INTO Transactions VALUES ('4457', '3524');
INSERT INTO Transactions VALUES ('4457', '3526');
INSERT INTO Transactions VALUES ('4457', '3528');

INSERT INTO Transactions VALUES ('4456', '3525');
INSERT INTO Transactions VALUES ('4456', '3527');
INSERT INTO Transactions VALUES ('4456', '3528');


INSERT INTO DeliversTo VALUES ('5380', '1288', 'V6E 4R3');
INSERT INTO DeliversTo VALUES ('5381', '1104', 'V3J 2M8');
INSERT INTO DeliversTo VALUES ('5382', '2053', 'V6T 1Z2');
INSERT INTO DeliversTo VALUES ('5383', '8800', 'V3J 7X5');
INSERT INTO DeliversTo VALUES ('5384', '300', 'V3H 2M5');

INSERT INTO DeliversTo VALUES ('5383', '1288', 'V6E 4R3');
INSERT INTO DeliversTo VALUES ('5384', '1104', 'V3J 2M8');
INSERT INTO DeliversTo VALUES ('5384', '1288', 'V6E 4R3');
INSERT INTO DeliversTo VALUES ('5380', '1104', 'V3J 2M8');


INSERT INTO RequestsAddress VALUES ('1288', 'V6E 4R3', '4456');
INSERT INTO RequestsAddress VALUES ('1104', 'V3J 2M8', '4457');
INSERT INTO RequestsAddress VALUES ('2053', 'V6T 1Z2', '4458');
INSERT INTO RequestsAddress VALUES ('8800', 'V3J 7X5', '4459');
INSERT INTO RequestsAddress VALUES ('300', 'V3H 2M5', '4460');













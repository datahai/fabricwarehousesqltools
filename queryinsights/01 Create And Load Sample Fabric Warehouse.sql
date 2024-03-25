DROP TABLE IF EXISTS dbo.FactTrip;
DROP VIEW IF EXISTS dbo.vwDimPaymentAnalysis;
DROP TABLE IF EXISTS dbo.DimDate;
DROP TABLE IF EXISTS dbo.DimGeography;
DROP TABLE IF EXISTS dbo.DimHackneyLicense;
DROP TABLE IF EXISTS dbo.DimMedallion;
DROP TABLE IF EXISTS dbo.DimTime;
DROP TABLE IF EXISTS dbo.DimWeather;

CREATE TABLE [dbo].[DimDate] ( [DateID] int NOT NULL, [Date] datetime2(6) NULL, [DateBKey] char(10) NULL, [DayOfMonth] varchar(2) NULL, [DaySuffix] varchar(4) NULL, [DayName] varchar(9) NULL, [DayOfWeek] char(1) NULL, [DayOfWeekInMonth] varchar(2) NULL, [DayOfWeekInYear] varchar(2) NULL, [DayOfQuarter] varchar(3) NULL, [DayOfYear] varchar(3) NULL, [WeekOfMonth] varchar(1) NULL, [WeekOfQuarter] varchar(2) NULL, [WeekOfYear] varchar(2) NULL, [Month] varchar(2) NULL, [MonthName] varchar(9) NULL, [MonthOfQuarter] varchar(2) NULL, [Quarter] char(1) NULL, [QuarterName] varchar(9) NULL, [Year] char(4) NULL, [YearName] char(7) NULL, [MonthYear] char(10) NULL, [MMYYYY] char(6) NULL, [FirstDayOfMonth] date NULL, [LastDayOfMonth] date NULL, [FirstDayOfQuarter] date NULL, [LastDayOfQuarter] date NULL, [FirstDayOfYear] date NULL, [LastDayOfYear] date NULL, [IsHolidayUSA] bit NULL, [IsWeekday] bit NULL, [HolidayUSA] varchar(50) NULL );
CREATE TABLE [dbo].[DimGeography] ( [GeographyID] int NOT NULL, [ZipCodeBKey] varchar(10) NOT NULL, [County] varchar(50) NULL, [City] varchar(50) NULL, [State] varchar(50) NULL, [Country] varchar(50) NULL, [ZipCode] varchar(50) NULL );
CREATE TABLE [dbo].[DimHackneyLicense] ( [HackneyLicenseID] int NOT NULL, [HackneyLicenseBKey] varchar(50) NOT NULL, [HackneyLicenseCode] varchar(50) NULL );
CREATE TABLE [dbo].[DimMedallion] ( [MedallionID] int NOT NULL, [MedallionBKey] varchar(50) NOT NULL, [MedallionCode] varchar(50) NULL );
CREATE TABLE [dbo].[DimTime] ( [TimeID] int NOT NULL, [TimeBKey] varchar(8) NOT NULL, [HourNumber] int NOT NULL, [MinuteNumber] int NOT NULL, [SecondNumber] int NOT NULL, [TimeInSecond] int NOT NULL, [HourlyBucket] varchar(15) NOT NULL, [DayTimeBucketGroupKey] int NOT NULL, [DayTimeBucket] varchar(100) NOT NULL );
CREATE TABLE [dbo].[FactTrip] ( [DateID] int NOT NULL, [MedallionID] int NOT NULL, [HackneyLicenseID] int NOT NULL, [PickupTimeID] int NOT NULL, [DropoffTimeID] int NOT NULL, [PickupGeographyID] int NULL, [DropoffGeographyID] int NULL, [PickupLatitude] float NULL, [PickupLongitude] float NULL, [PickupLatLong] varchar(50) NULL, [DropoffLatitude] float NULL, [DropoffLongitude] float NULL, [DropoffLatLong] varchar(50) NULL, [PassengerCount] int NULL, [TripDurationSeconds] int NULL, [TripDistanceMiles] float NULL, [PaymentType] varchar(50) NULL, [FareAmount] decimal NULL, [SurchargeAmount] decimal NULL, [TaxAmount] decimal NULL, [TipAmount] decimal NULL, [TollsAmount] decimal NULL, [TotalAmount] decimal NULL );
CREATE TABLE [dbo].[DimWeather] ( [DateID] int NOT NULL, [GeographyID] int NOT NULL, [PrecipitationInches] float NOT NULL, [AvgTemperatureFahrenheit] float NOT NULL );

--Load Dims
COPY INTO [dbo].[DimDate] FROM 'https://nytaxiblob.blob.core.windows.net/parquet/Date/*.parquet' WITH ( FILE_TYPE = 'PARQUET' );
COPY INTO [dbo].[DimGeography] FROM 'https://nytaxiblob.blob.core.windows.net/parquet/Geography/*.parquet' WITH ( FILE_TYPE = 'PARQUET' );
COPY INTO [dbo].[DimHackneyLicense] FROM 'https://nytaxiblob.blob.core.windows.net/parquet/HackneyLicense/*.parquet' WITH ( FILE_TYPE = 'PARQUET' );
COPY INTO [dbo].[DimMedallion] FROM 'https://nytaxiblob.blob.core.windows.net/parquet/Medallion/*.parquet' WITH ( FILE_TYPE = 'PARQUET' );
COPY INTO [dbo].[DimTime] FROM 'https://nytaxiblob.blob.core.windows.net/parquet/Time/*.parquet' WITH ( FILE_TYPE = 'PARQUET' );
COPY INTO [dbo].[DimWeather] FROM 'https://nytaxiblob.blob.core.windows.net/parquet/Weather/*.parquet' WITH ( FILE_TYPE = 'PARQUET' );

--Load Facts
COPY INTO [dbo].[FactTrip] FROM 'https://nytaxiblob.blob.core.windows.net/parquet/Trip/*.parquet' WITH ( FILE_TYPE = 'PARQUET' );

--check rowcounts
SELECT COUNT(*) FROM [dbo].[DimDate];
SELECT COUNT(*) FROM [dbo].[DimGeography];
SELECT COUNT(*) FROM [dbo].[DimHackneyLicense];
SELECT COUNT(*) FROM [dbo].[DimMedallion];
SELECT COUNT(*) FROM [dbo].[DimTime] ;
SELECT COUNT(*) FROM [dbo].[DimWeather];
SELECT COUNT(*) FROM [dbo].[FactTrip];

select * from [dbo].[vwDimPaymentAnalysis] 

--create derived Dimension
CREATE VIEW [dbo].[vwDimPaymentAnalysis] 
AS 
SELECT 
PaymentType 
,COUNT(T.PaymentType) AS PaymentsCount 
,SUM(TotalAmount) AS TotalAmountProcessed 
FROM dbo.FactTrip AS T 
JOIN dbo.[DimDate] AS D ON T.[DateID]=D.[DateID] 
WHERE YEAR(D.[Date])=2013 
GROUP BY PaymentType;

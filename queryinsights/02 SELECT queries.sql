--simple count
SELECT
    COUNT(T.DateID) AS TripCount,
    SUM(T.PassengerCount) AS TotalPassengerCount
FROM
    dbo.FactTrip T;

--joins
SELECT
    D.Date AS TripDate,
    D.MonthName,
    COUNT(T.DateID) AS TotalTripCount,
    SUM(T.PassengerCount) AS TotalPassengerCount
FROM
    dbo.FactTrip T
INNER JOIN
    dbo.DimDate D ON D.DateID = T.DateID
GROUP BY
    D.Date,
    D.MonthName
ORDER BY
    D.Date;

--joins with WHERE - January
SELECT
    D.Date AS TripDate,
    D.MonthName,
    COUNT(T.DateID) AS TotalTripCount,
    SUM(T.PassengerCount) AS TotalPassengerCount
FROM
    dbo.FactTrip T
INNER JOIN
    dbo.DimDate D ON D.DateID = T.DateID
WHERE D.MonthName = 'January'
GROUP BY
    D.Date,
    D.MonthName
ORDER BY
    D.Date;

--joins with WHERE - February
SELECT
    D.Date AS TripDate,
    D.MonthName,
    COUNT(T.DateID) AS TotalTripCount,
    SUM(T.PassengerCount) AS TotalPassengerCount
FROM
    dbo.FactTrip T
INNER JOIN
    dbo.DimDate D ON D.DateID = T.DateID
WHERE D.MonthName = 'February'
GROUP BY
    D.Date,
    D.MonthName
ORDER BY
    D.Date;



--joins but missed 1 out (geographyid)
SELECT
    D.Date AS TripDate,
    D.MonthName,
    D.DayName,
    G.City AS PickupCity,
    G.County AS PickUpCounty,
    G.State AS PickUpState,
    COUNT(T.DateID) AS TotalTripCount,
    SUM(T.PassengerCount) AS TotalPassengerCount,
    SUM(T.FareAmount) AS TotalFareAmount,
    SUM(T.SurchargeAmount) AS TotalSurchargeAmount,
    SUM(T.TaxAmount) AS TotalTaxAmount,
    SUM(T.TotalAmount) AS TotalAmount,
    SUM(W.PrecipitationInches) AS TotalRainFallInches
FROM
    dbo.FactTrip T
INNER JOIN
    dbo.DimDate D ON D.DateID = T.DateID
INNER JOIN
    dbo.DimGeography G ON G.GeographyID = T.PickupGeographyID
INNER JOIN 
    dbo.DimWeather W ON W.DateID = T.DateID
GROUP BY
    D.Date,
    D.MonthName,
    D.DayName,
    G.City,
    G.County,
    G.State
ORDER BY
    D.Date,
    G.State,
    G.County,
    G.City;


--joins but now corrected
SELECT
    D.Date AS TripDate,
    D.MonthName,
    D.DayName,
    G.City AS PickupCity,
    G.County AS PickUpCounty,
    G.State AS PickUpState,
    COUNT(T.DateID) AS TotalTripCount,
    SUM(T.PassengerCount) AS TotalPassengerCount,
    SUM(T.FareAmount) AS TotalFareAmount,
    SUM(T.SurchargeAmount) AS TotalSurchargeAmount,
    SUM(T.TaxAmount) AS TotalTaxAmount,
    SUM(T.TotalAmount) AS TotalAmount,
    SUM(W.PrecipitationInches) AS TotalRainFallInches
FROM
    dbo.FactTrip T
INNER JOIN
    dbo.DimDate D ON D.DateID = T.DateID
INNER JOIN
    dbo.DimGeography G ON G.GeographyID = T.PickupGeographyID
INNER JOIN 
    dbo.DimWeather W ON W.DateID = T.DateID AND W.GeographyID = T.PickupGeographyID
GROUP BY
    D.Date,
    D.MonthName,
    D.DayName,
    G.City,
    G.County,
    G.State
ORDER BY
    D.Date,
    G.State,
    G.County,
    G.City;

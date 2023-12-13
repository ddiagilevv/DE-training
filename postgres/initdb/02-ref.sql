CREATE SCHEMA IF NOT EXISTS RefData;

CREATE TABLE IF NOT EXISTS RefData.Currencies (
    CurrencyID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    CurrencyCode VARCHAR(10),
    CurrencyName VARCHAR(50),
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS RefData.Regions (
    RegionID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    RegionName VARCHAR(255),
    TimeZone VARCHAR(50),
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS RefData.Countries (
    CountryID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    CountryName VARCHAR(100),
    RegionID UUID,
    CurrencyID UUID,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (RegionID) REFERENCES RefData.Regions(RegionID),
    FOREIGN KEY (CurrencyID) REFERENCES RefData.Currencies(CurrencyID)
);

CREATE TABLE IF NOT EXISTS RefData.Cities (
    CityID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    CityName VARCHAR(255),
    CountryID UUID,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (CountryID) REFERENCES RefData.Countries(CountryID)
);

CREATE TABLE IF NOT EXISTS RefData.Holidays (
    HolidayID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    HolidayName VARCHAR(100),
    Date DATE,
    CountryID UUID,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (CountryID) REFERENCES RefData.Countries(CountryID)
);

CREATE TABLE IF NOT EXISTS RefData.ProductCategories (
    CategoryID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    CategoryName VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS RefData.SupplierTypes (
    SupplierTypeID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    TypeName VARCHAR(100)
);
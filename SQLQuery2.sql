/*SELECT
	*
  FROM 
	[Portfolioproject].[dbo].[Nashvilehousing]
-- cleaning the DATA using SQL 
--Standardize the Date Format8*/

select 
	* 
from 
	Nashvilehousing
UPDATE 
	Nashvilehousing
SET 
	SaleDate = CONVERT(Date,SaleDate)

--ALTER Tablenashvilehousing
--add saledateconverted date;
UPDATE 
	nashvilehousing 
set 
	saledateconverted = convert(date,saledate)

-- Populate the property address data 
select 
	* 
from 
	Nashvilehousing
where 
	PropertyAddress is null
order by 
	ParcelID

select 
	a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(A.PropertyAddress,b.PropertyAddress)
FROM 
	Nashvilehousing a
join 
	Nashvilehousing b 
on 
	a.ParcelID = b.ParcelID and a.[UniqueID ]<> b.[UniqueID ]
where 
	a.PropertyAddress is null

UPDATE
	a
SET 
	PropertyAddress = ISNULL(A.PropertyAddress,b.PropertyAddress)
FROM 
	Nashvilehousing a
join 
	Nashvilehousing b 
on 
	a.ParcelID = b.ParcelID and a.[UniqueID ]<> b.[UniqueID ]
where
	a.PropertyAddress is null

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS,CITY,STATE)

SELECT 
	[PropertyAddress]
fROM 
	Nashvilehousing

ALTER TABLE 
	Nashvilehousing
add 
	propertysplit_address nvarchar(250);

alter table 
	nashvilehousing
add 
	propertysplit_state nvarchar(250);

select 
	substring(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1),
	substring(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress))
from 
	Nashvilehousing
select
	* 
from 
	Nashvilehousing
update 
	Nashvilehousing
set 
	propertysplit_address = substring(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)

update 
	Nashvilehousing
set 
	propertysplit_state =  substring(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress))
--
select 
	OwnerAddress 
from 
	Nashvilehousing 

select 
	PARSENAME(replace(owneraddress,',','.'),3),
	PARSENAME(replace(owneraddress,',','.'),2),
	PARSENAME(replace(owneraddress,',','.'),1)
FROM
	Nashvilehousing

ALTER TABLE
	Nashvilehousing
ADD
	Ownersplit_address Nvarchar(250)

ALTER TABLE
	Nashvilehousing
ADD
	Ownersplit_city Nvarchar(250)
ALTER TABLE
	Nashvilehousing
ADD
	Ownersplit_state Nvarchar(250)

UPDATE
	Nashvilehousing
SET 
	Ownersplit_address = PARSENAME(replace(owneraddress,',','.'),3) 
UPDATE
	Nashvilehousing
SET 
	Ownersplit_city = PARSENAME(replace(owneraddress,',','.'),2) 
UPDATE
	Nashvilehousing
SET
	Ownersplit_state = PARSENAME(replace(owneraddress,',','.'),1) 

select 
	* 
from 
	Nashvilehousing 
	--CHANGE Y & N TO YES & NO IN 'SOLDASVACANT'COLUMN
SELECT
	DISTINCT(SOLDASVACANT)
FROM
	Nashvilehousing
UPDATE 
	Nashvilehousing
set 
	SoldAsVacant = 'Yes'
where 
	SoldAsVacant = 'Y'
UPDATE 
	Nashvilehousing
set 
	SoldAsVacant = 'No'
where 
	SoldAsVacant = 'N'
SELECT
	DISTINCT(SoldAsVacant),count(SoldAsVacant)
FROM
	Nashvilehousing
GROUP BY
	SoldAsVacant;

--REMOVE DUPLICATES 
WITH RowNumCTE AS 
(
SELECT *,ROW_NUMBER()OVER(PARTITION BY PARCELID,
									PROPERTYADDRESS,
									SALEPRICE,
									SALEDATE,
									LEGALREFERENCE
									ORDER BY uniqueId)rr
FROM 
	Nashvilehousing
)

DELETE  
FROM RowNumCTE
where rr>1

--DELETE unused Columns

select 
		*
from
	Nashvilehousing

ALTER TABLE
	nashvilehousing 
DROP COLUMN
	OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE
	nashvilehousing 
DROP COLUMN
	SaleDate
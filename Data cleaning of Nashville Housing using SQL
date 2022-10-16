--Cleaning and exploring Data
Select *
FROM PortfolioProjects.dbo.NashvilleHousing

-- Standardizing the date format
Select SaleDate, CONVERT(Date,Saledate)
FROM PortfolioProjects.dbo.NashvilleHousing -- Since the datatype is datetime, conver doesn't work so we use the syntax below

ALTER TABLE NashvilleHousing ALTER COLUMN SaleDate date NOT NULL

-- Popultae property address data
 SELECT PropertyAddress
 FROM PortfolioProjects.dbo.NashvilleHousing
 WHERE PropertyAddress IS NULL

 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM PortfolioProjects.dbo.NashvilleHousing a JOIN PortfolioProjects.dbo.NashvilleHousing b 
 ON a.ParcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL 

 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM PortfolioProjects.dbo.NashvilleHousing a JOIN PortfolioProjects.dbo.NashvilleHousing b 
 ON a.ParcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL 

 -- Breaking out Address into individual columns (Address,city,state)
 SELECT PropertyAddress
 FROM PortfolioProjects.dbo.NashvilleHousing

 SELECT SUBSTRING(PropertyAddress,1,CHARINDEX (',', PropertyAddress)-1) AS Address, SUBSTRING(PropertyAddress,CHARINDEX (',', PropertyAddress)+1,LEN(PropertyAddress)) AS Address
 FROM PortfolioProjects.dbo.NashvilleHousing
 ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress Nvarchar(255)
 Update NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX (',', PropertyAddress)-1)
 ALTER TABLE NashvilleHousing
 ADD PropertySplitCity Nvarchar(255)
 Update NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX (',', PropertyAddress)+1,LEN(PropertyAddress))

 -- for owner address 

 SELECT 
 PARSENAME(REPLACE(OwnerAddress, ',','.'),3), PARSENAME(REPLACE(OwnerAddress, ',','.'),2) , PARSENAME(REPLACE(OwnerAddress, ',','.'),1) 
 FROM PortfolioProjects.dbo.NashvilleHousing

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress Nvarchar(255)
 Update NashvilleHousing
 SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
 ALTER TABLE NashvilleHousing
 ADD OwnerSplitCity Nvarchar(255)
 Update NashvilleHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
 
 ALTER TABLE NashvilleHousing
 ADD OwnerSplitState Nvarchar(255)
 Update NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

 SELECT *
 FROM PortfolioProjects.dbo.NashvilleHousing

 -- Change Y and N to Yes and No in "Sold as Vacant" field
 SELECT DISTINCT (SoldAsVacant), COUNt(SoldAsVacant)
 FROM PortfolioProjects.dbo.NashvilleHousing
 GROUP BY SoldAsVacant
 ORDER BY SoldAsVacant

 SELECT CASE WHEN SoldAsVacant='Y' THEN 'Yes'   
 WHEN SoldAsVacant='N' THEN 'No'
 ELSE SoldAsVacant END
 FROM PortfolioProjects.dbo.NashvilleHousing
  UPDATE NashvilleHousing
  SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes'   
 WHEN SoldAsVacant='N' THEN 'No'
 ELSE SoldAsVacant END

 -- Remove duplicates
 
 WITH ROWNUMCTE AS (
 SELECT *, ROW_NUMBER() OVER ( 
		PARTITION by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
		ORDER BY UniqueID) row_num
 FROM PortfolioProjects.dbo.NashvilleHousing
 )
 DELETE
 FROM ROWNUMCTE
 WHERE row_num>1
 --Order by PropertyAddress

 --DELETE Unused Columns-- Never delete raw data

-- (SELECT * FROM PortfolioProjects.dbo.NashvilleHousing ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
 --DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
  
  SELECT * FROM PortfolioProjects.dbo.NashvilleHousing

/*
Data Cleaning 

*/

Select *
From NashvilleHousing

--- Standardize Date Format
Select SaleDate, CONVERT(Date, SaleDate)
From NashvilleHousing

Update NashvilleHousing
SET SaleDate =CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted =CONVERT(Date, SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
From NashvilleHousing

----Property Adess
Select*
From NashvilleHousing
Where PropertyAddress is Null
Order by ParcelID

-- Do a self Join
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

--Breaking Out Address
Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is Null
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) As Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))  As Address
From NashvilleHousing

ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From NashvilleHousing

--Split Owner Adress 
Select OwnerAddress
From NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
From NashvilleHousing
Where OwnerAddress is not Null


---------
ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)


ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)


ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

Select *
From NashvilleHousing

--Chnage Y and N to Yes and No
Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE WHEN SoldAsVacant ='Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
From NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant ='Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END



	 -- Remove Duplicates
Select *
From NashvilleHousing

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				   UniqueID
				   )row_Num

From NashvilleHousing
--Order by ParcelID
)
Delete
From RowNumCTE
Where row_num >1
--Order by PropertyAddress

--Check for More Duplicate 
WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				   UniqueID
				   )row_Num

From NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress


---Delete Unused Columna * Dont do this to your raw data*
Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

Select *
From NashvilleHousing

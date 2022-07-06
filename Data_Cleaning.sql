use  PortfolioProject


--Change date format
select * from NashvilleHousing
select OwnerAddress from NashvilleHousing


select SaleDateconvert
from NashvilleHousing

alter table dbo.NashvilleHousing
add saledateconvert date

update dbo.NashvilleHousing
set saledateconvert=convert(date, saledate)


--populate property adrr data

select *
 from NashvilleHousing
 where PropertyAddress is null

 select nh.uniqueid, nh1.uniqueid, nh.propertyaddress, nh.parcelid, nh1.parcelid, nh1.propertyaddress, 
 isnull(nh1.propertyaddress, nh.propertyaddress)
 from NashvilleHousing nh
 join NashvilleHousing nh1 on nh.Parcelid= nh1.ParcelID
 and nh.SalePrice <> nh1.SalePrice
 where nh1.propertyaddress is not null

 update nh
 set PropertyAddress= isnull(nh1.propertyaddress, nh.propertyaddress)
 from NashvilleHousing nh
 join NashvilleHousing nh1 on nh.Parcelid= nh1.ParcelID
 and nh.SalePrice <> nh1.SalePrice

 --breaking out address into individual col

 select PropertyAddress
 from NashvilleHousing
 --where PropertyAddress is null

 select 
 substring(PropertyAddress ,1, CHARINDEX(',', PropertyAddress)-1) as Address
,  substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as address
 from NashvilleHousing;

 alter table NashvilleHousing
 add AddressLane nvarchar(255)

 update NashvilleHousing
 set AddressLane =  substring(PropertyAddress ,1, CHARINDEX(',', PropertyAddress)-1)

  alter table NashvilleHousing
 add AddressStreet nvarchar(255)

 update NashvilleHousing
 set AddressStreet =  substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 
 
select
PARSENAME(replace(owneraddress, ',', '.'), 3)
,PARSENAME(replace(owneraddress, ',', '.'), 2)
,PARSENAME(replace(owneraddress, ',', '.'), 1)
 from NashvilleHousing

 alter table NashvilleHousing
 add OwnerAddressLane nvarchar(255)

 update NashvilleHousing
 set OwnerAddressLane =  PARSENAME(replace(owneraddress, ',', '.'), 3)

  alter table NashvilleHousing
 add OwnerAddressStreet nvarchar(255)

 update NashvilleHousing
 set OwnerAddressStreet =  PARSENAME(replace(owneraddress, ',', '.'), 2)

   alter table NashvilleHousing
 add OwnerAddressState nvarchar(255)

 update NashvilleHousing
 set OwnerAddressState =  PARSENAME(replace(owneraddress, ',', '.'), 1)


 ---change yes/No to Y/N

 select distinct(SOldasvacant), count(soldasvacant)
  from NashvilleHousing
  group by soldasvacant;

  select soldasvacant
,  case when soldasvacant = 'N' then 'No'
  when SoldAsVacant='Y' then 'Yes'
  else SoldAsVacant
  end
   from NashvilleHousing


 update NashvilleHousing
 set SoldAsVacant= case when soldasvacant = 'N' then 'No'
  when SoldAsVacant='Y' then 'Yes'
  else SoldAsVacant
  end


  --remove duplicates
  
  
  with cte as(
  select *
,  ROW_NUMBER() over (partition by ParcelID, SaleDate, LegalReference 
  order by UniqueID) row_num 
  from NashvilleHousing
  )

  select *  from cte
  where row_num> 1







  --remove unused col
  select * from NashvilleHousing

  alter table NashvilleHousing
  drop column Owneraddress, Propertyaddress, TaxDistrict



GO
-- drop function CreateNewIndividual
Create FUNCTION CreateNewIndividual(@SoftwareUniqueId nvarchar(50), @EntityId nvarchar(50), @IndName nvarchar(200), @eTin nvarchar(50), @EntityOriginator nvarchar(50), @FatherName nvarchar(200), @MotherName nvarchar(200), @DateOfBirth nvarchar(50), @BirthCertificateNumber nvarchar(50), @Nid nvarchar(50), @PassportNumber nvarchar(50), @DrivingLicenseNumber nvarchar(50))
RETURNS [nvarchar](20)
AS 
EXTERNAL NAME [CODConsumer].[UserDefinedFunctions].[CreateNewIndividual]

GO
-- drop function fnInsertEntityAddress
Create function fnInsertEntityAddress(@RequestId nvarchar(50),@AddressTypeId int,@DivisionId int,
@DistrictId int,@ThanaId int,@PostOfficeId nvarchar(50),@AddressDetails nvarchar(250))
returns nvarchar(20)
as 
external name CODConsumer.UserDefinedFunctions.InsertEntityAddress
GO

-- drop proc spIntegrateCODWithHRM
Create proc spIntegrateCODWithHRM
@EmployeeID nvarchar(50)
as
begin

	Declare @SoftwareUniqueId as nvarchar(50) Set @SoftwareUniqueId = ''
	Declare @EntityId nvarchar(50) Set @EntityId = ''
	Declare @IndName nvarchar(200) Set @IndName = ''
	Declare @eTin nvarchar(50) Set @eTin = ''
	Declare @EntityOriginator nvarchar(50) Set @EntityOriginator = 'Career'
	Declare @FatherName nvarchar(200) Set @FatherName = ''
	Declare @MotherName nvarchar(200) Set @MotherName = ''
	Declare @DateOfBirth Date Set @DateOfBirth = '1/1/1900'
	Declare @BirthCertificateNumber nvarchar(50) Set @BirthCertificateNumber = ''
	Declare @Nid nvarchar(50) Set @Nid = ''
	Declare @PassportNumber nvarchar(50) Set @PassportNumber = ''
	Declare @DrivingLicenseNumber nvarchar(50) Set @DrivingLicenseNumber = ''
	Declare @RequestID as nvarchar(20) Set @RequestID = ''

	Declare @CountryId as int Set @CountryId = 1
	Declare @AddressTypeIdPresent as int Set @AddressTypeIdPresent = 1
	Declare @AddressTypeIdPermanent as int Set @AddressTypeIdPermanent = 2
	Declare @DivisionIdPresent as int Set @DivisionIdPresent = 0
	Declare @DivisionIdPermanent as int Set @DivisionIdPermanent = 0
	Declare @DistrictIdPresent as Int Set @DistrictIdPresent = 0
	Declare @DistrictIdPermanent as Int Set @DistrictIdPermanent = 0
	Declare @UpazilaIDPresent as int set @UpazilaIDPresent = 0
	Declare @UpazilaIDPermanent as int set @UpazilaIDPermanent = 0
	Declare @PostOfficeId as int Set @PostOfficeId = 0
	Declare @AddressDetailsPresent as nvarchar(250) Set @AddressDetailsPresent = ''
	Declare @AddressDetailsPermanent as nvarchar(250) Set @AddressDetailsPermanent = ''
	Declare @Status as nvarchar(50) Set @Status = ''


begin tran

	Select @SoftwareUniqueId=EI.EmployeeID,@IndName=EI.EmployeeName,@FatherName=EB.FathersName,@MotherName = EB.MothersName,@eTin=EB.TinNo,
	@DateOfBirth = ISNULL(EI.DateOfBirth,'1/1/1900'),@BirthCertificateNumber='',@Nid=NIDNo,@PassportNumber=PassportNo,@DrivingLicenseNumber=EB.DrivingLicenseNo,
	@DivisionIdPresent = dbo.fnGetCleanDivisionIDByDistrictID(EB.PreDistrict),
	@DistrictIdPresent = dbo.fnGetCleanDistrictKey(EB.PreDistrict),
	@UpazilaIDPresent = dbo.fnGetCleanUpazilaKey(EB.PreThana),
	@AddressDetailsPresent = EB.PresentAddress,
	@DivisionIdPermanent = dbo.fnGetCleanDivisionIDByDistrictID(EB.PerDistrict),
	@DistrictIdPermanent = dbo.fnGetCleanDistrictKey(EB.PerDistrict),
	@UpazilaIDPermanent = dbo.fnGetCleanUpazilaKey(EB.PreThana),
	@AddressDetailsPermanent = EB.PermanentAddress
	from tblEmployeeInfo EI Left Join tblEmployeeBasicInfo EB ON EI.EmployeeID = EB.EmployeeID
	Where EI.EmployeeID=@EmployeeID

	select @RequestID=dbo.CreateNewIndividual(@SoftwareUniqueId,@EntityId,@IndName,@eTin,@EntityOriginator,@FatherName,@MotherName,@DateOfBirth,@BirthCertificateNumber,@Nid,@PassportNumber,@DrivingLicenseNumber)

	Select @Status = dbo.fnInsertEntityAddress(@RequestID,@AddressTypeIdPresent,@DivisionIdPresent,@DistrictIdPresent,@UpazilaIDPresent,@PostOfficeId,@AddressDetailsPresent)

	Select @Status = dbo.fnInsertEntityAddress(@RequestID,@AddressTypeIdPermanent,@DivisionIdPermanent,@DistrictIdPermanent,@UpazilaIDPermanent,@PostOfficeId,@AddressDetailsPermanent)

	Update tblEmployeeInfo Set RequestId=@RequestID Where EmployeeID=@EmployeeID
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

-- drop proc spIntegrateCODWithHRMUpdate
Create proc spIntegrateCODWithHRMUpdate
@EmployeeID nvarchar(50)
as
begin

	Declare @SoftwareUniqueId as nvarchar(50) Set @SoftwareUniqueId = ''
	Declare @EntityId nvarchar(50) Set @EntityId = ''
	Declare @IndName nvarchar(200) Set @IndName = ''
	Declare @eTin nvarchar(50) Set @eTin = ''
	Declare @EntityOriginator nvarchar(50) Set @EntityOriginator = 'Career'
	Declare @FatherName nvarchar(200) Set @FatherName = ''
	Declare @MotherName nvarchar(200) Set @MotherName = ''
	Declare @DateOfBirth Date Set @DateOfBirth = '1/1/1900'
	Declare @BirthCertificateNumber nvarchar(50) Set @BirthCertificateNumber = ''
	Declare @Nid nvarchar(50) Set @Nid = ''
	Declare @PassportNumber nvarchar(50) Set @PassportNumber = ''
	Declare @DrivingLicenseNumber nvarchar(50) Set @DrivingLicenseNumber = ''
	Declare @RequestID as nvarchar(20) Set @RequestID = ''

	Declare @CountryId as int Set @CountryId = 1
	Declare @AddressTypeIdPresent as int Set @AddressTypeIdPresent = 1
	Declare @AddressTypeIdPermanent as int Set @AddressTypeIdPermanent = 2
	Declare @DivisionIdPresent as int Set @DivisionIdPresent = 0
	Declare @DivisionIdPermanent as int Set @DivisionIdPermanent = 0
	Declare @DistrictIdPresent as Int Set @DistrictIdPresent = 0
	Declare @DistrictIdPermanent as Int Set @DistrictIdPermanent = 0
	Declare @UpazilaIDPresent as int set @UpazilaIDPresent = 0
	Declare @UpazilaIDPermanent as int set @UpazilaIDPermanent = 0
	Declare @PostOfficeId as int Set @PostOfficeId = 0
	Declare @AddressDetailsPresent as nvarchar(250) Set @AddressDetailsPresent = ''
	Declare @AddressDetailsPermanent as nvarchar(250) Set @AddressDetailsPermanent = ''
	Declare @Status as nvarchar(50) Set @Status = ''

begin tran

	Select @SoftwareUniqueId=EI.EmployeeID,@IndName=EI.EmployeeName,@FatherName=EB.FathersName,@MotherName = EB.MothersName,@eTin=EB.TinNo,
	@DateOfBirth = ISNULL(EI.DateOfBirth,'1/1/1900'),@BirthCertificateNumber='',@Nid=NIDNo,@PassportNumber=PassportNo,@DrivingLicenseNumber=EB.DrivingLicenseNo,@EntityId=EntityId,
	@DivisionIdPresent = dbo.fnGetCleanDivisionIDByDistrictID(EB.PreDistrict),
	@DistrictIdPresent = dbo.fnGetCleanDistrictKey(EB.PreDistrict),
	@UpazilaIDPresent = dbo.fnGetCleanUpazilaKey(EB.PreThana),
	@AddressDetailsPresent = EB.PresentAddress,
	@DivisionIdPermanent = dbo.fnGetCleanDivisionIDByDistrictID(EB.PerDistrict),
	@DistrictIdPermanent = dbo.fnGetCleanDistrictKey(EB.PerDistrict),
	@UpazilaIDPermanent = dbo.fnGetCleanUpazilaKey(EB.PreThana),
	@AddressDetailsPermanent = EB.PermanentAddress
	from tblEmployeeInfo EI Left Join tblEmployeeBasicInfo EB ON EI.EmployeeID = EB.EmployeeID
	Where EI.EmployeeID=@EmployeeID

	select @RequestID=dbo.CreateNewIndividual(@SoftwareUniqueId,@EntityId,@IndName,@eTin,@EntityOriginator,@FatherName,@MotherName,@DateOfBirth,@BirthCertificateNumber,@Nid,@PassportNumber,@DrivingLicenseNumber)

	Select @Status = dbo.fnInsertEntityAddress(@RequestID,@AddressTypeIdPresent,@DivisionIdPresent,@DistrictIdPresent,@UpazilaIDPresent,@PostOfficeId,@AddressDetailsPresent)

	Select @Status = dbo.fnInsertEntityAddress(@RequestID,@AddressTypeIdPermanent,@DivisionIdPermanent,@DistrictIdPermanent,@UpazilaIDPermanent,@PostOfficeId,@AddressDetailsPermanent)


	Update tblEmployeeInfo Set RequestId=@RequestID,IsCodSync=0 Where EmployeeID=@EmployeeID
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO


/* Sending All Data To COD */
Declare @EmployeeID as nvarchar(50) Set @EmployeeID = ''

Declare @EmpTbl table(
EmployeeID nvarchar(50),
Taken bit default 0
);

Insert into @EmpTbl(EmployeeID)
Select EmployeeID from tblEmployeeInfo Where RequestId Is NULL

Declare @Count as int Set @Count = 1
Declare @NCount as int Set @NCount = 0

Select @NCount = Count(*) from @EmpTbl

While @Count <= @NCount
begin
	Select top 1 @EmployeeID=EmployeeID from @EmpTbl Where Taken=0

	exec spIntegrateCODWithHRM @EmployeeID

	Update @EmpTbl Set Taken=1 Where EmployeeID=@EmployeeID
	Set @Count = @Count + 1
end
/* Sending All Data To COD */

GO

-- drop function dbo.SendExistingEntityID
Create function SendExistingEntityID(@RequestID nvarchar(50))
returns nvarchar(8)
as 
external name CODConsumer.UserDefinedFunctions.SendExistingEntityID

GO

Select dbo.SendExistingEntityID('RL000000000000000001')

GO

-- drop proc spResolveEntityID
Create proc spResolveEntityID
as
begin
	Declare @RequestID as nvarchar(20) Set @RequestID = ''
	Declare @EntityId as nvarchar(8) Set @EntityId = ''
	Declare @Count as int Set @Count = 1
	Declare @NCount as int Set @NCount = 0

	Declare @ReqTbl table(
	RequestID nvarchar(50),
	Taken bit default 0
	);

begin tran

	Insert into @ReqTbl(RequestID)
	Select RequestId from tblEmployeeInfo Where IsCodSync=0 And RequestId <> ''

	Select @NCount = Count(*) from @ReqTbl

	While @Count <= @NCount
	begin
		Select top 1 @RequestID=RequestID from @ReqTbl Where Taken=0

		select @EntityId=dbo.SendExistingEntityID(@RequestID)
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		If @EntityId <> ''
		begin
			Update tblEmployeeInfo Set EntityId=@EntityId,IsCodSync=1 Where RequestId=@RequestID
			IF (@@ERROR <> 0) GOTO ERR_HANDLER
		end

		Update @ReqTbl Set Taken=1 Where RequestID=@RequestID
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
		Set @Count = @Count + 1
		Set @EntityId = ''
	end

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

-- exec spResolveEntityID
-- Select EmployeeID,RequestId,EntityId,IsCodSync from tblEmployeeInfo 
-- Select dbo.SendExistingEntityID('RL000000000000000001')

GO

-- drop function fnGetCountryList
Create function dbo.fnGetCountryList(@key nvarchar(20))
returns table(CountryId int,CountryName nvarchar(100)
)
as 
external name CODConsumer.UserDefinedFunctions.GetCountryList

GO

-- drop function fnGetDivisionList
Create function dbo.fnGetDivisionList(@key nvarchar(20),@CountryId nvarchar(20))
returns table(DivisionId int,DivisionName nvarchar(100)
)
as 
external name CODConsumer.UserDefinedFunctions.GetDivisionList;

GO

-- drop function fnGetDistrictList
Create function dbo.fnGetDistrictList(@key nvarchar(20),@DivisionId nvarchar(20))
returns table(DistrictId int,DistrictName nvarchar(100)
)
as 
external name CODConsumer.UserDefinedFunctions.GetDistrictList;

GO

-- drop function fnGetThanaList
Create function dbo.fnGetThanaList(@key nvarchar(20),@DistrictId nvarchar(20))
returns table(ThanaId int,ThanaName nvarchar(100)
)
as 
external name CODConsumer.UserDefinedFunctions.GetThanaList;
GO

-- drop function fnGetPostOfficeList
Create function dbo.fnGetPostOfficeList(@key nvarchar(20),@ThanaId nvarchar(20))
returns table(PostOfficeId int,PostOfficeName nvarchar(100)
)
as 
external name CODConsumer.UserDefinedFunctions.GetPostOfficeList;

GO

-- drop function ReadEventLog
CREATE FUNCTION ReadEventLog(@logname nvarchar(100))
RETURNS TABLE 
(logTime datetime,Message nvarchar(4000),Category nvarchar(4000),InstanceId bigint)
AS 
EXTERNAL NAME CODConsumer.UserDefinedFunctions.InitMethod;

GO

-- drop function fnGetAddressTypeList
Create function dbo.fnGetAddressTypeList(@key nvarchar(20))
returns table(ValueId int,ValueName nvarchar(100)
)
as 
external name CODConsumer.UserDefinedFunctions.GetAddressTypeList;

GO
Select * from dbo.fnGetCountryList('@Web$erv1ceKey#')
GO
Select * from dbo.fnGetDivisionList('@Web$erv1ceKey#','1')
GO
Select * from dbo.fnGetDistrictList('@Web$erv1ceKey#','')
GO
Select * from dbo.fnGetThanaList('@Web$erv1ceKey#','')
GO
Select * from dbo.fnGetPostOfficeList('@Web$erv1ceKey#','1')
GO
Select * from dbo.fnGetAddressTypeList('@Web$erv1ceKey#')
GO
SELECT TOP 100 * FROM dbo.ReadEventLog(N'Security') as T;
GO

GO

Create function fnGetCleanDivisionIDByDistrictID(@DistrictId int)
returns int
as
begin
	Declare @CleanDivisionKey as int Set @CleanDivisionKey = 0
	Select @CleanDivisionKey=DivisionID from tblDistrict Where DistrictID = @DistrictId
	return ISNULL(@CleanDivisionKey,0)
end
GO

-- drop function fnGetCleanDistrictKey
Create function fnGetCleanDistrictKey(@DistrictId int)
returns int
as
begin
	Declare @CleanDistrictKey as int Set @CleanDistrictKey = 0
	Select @CleanDistrictKey=CleanDistrictKey from tblDistrict Where DistrictID = @DistrictId
	return ISNULL(@CleanDistrictKey,0)
end

-- Select dbo.fnGetCleanDistrictKey(1000)

GO

Create function fnGetCleanUpazilaKey(@UpazilaId int)
returns int
as
begin
	Declare @CleanUpazilaKey as int Set @CleanUpazilaKey = 0
	Select @CleanUpazilaKey=CleanUpazilaKey from tblUpazila Where UpazilaID = @UpazilaId
	return ISNULL(@CleanUpazilaKey,0)
end

-- Select dbo.fnGetCleanUpazilaKey(2000)
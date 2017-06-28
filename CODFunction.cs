using System;
using System.IO;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Collections.Generic;
using CODConsumer.GeographicalReference;
using CODConsumer.ExistingEntityReference;
using CODConsumer.InsertEntityReference;
using CODConsumer.OtherReference;
using System.Diagnostics;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString SendExistingEntityID(string ReferenceID)
    {
        CODConsumer.ExistingEntityReference.SendExistingEntity cs = new CODConsumer.ExistingEntityReference.SendExistingEntity();
        return cs.EntityId(ReferenceID);
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString CreateNewIndividual(string SoftwareUniqueId,string EntityId, string IndName, string eTin, string EntityOriginator, string FatherName, string MotherName, string DateOfBirth, string BirthCertificateNumber, string Nid, string PassportNumber, string DrivingLicenseNumber)
    {
        CODConsumer.InsertEntityReference.InsertService cs = new CODConsumer.InsertEntityReference.InsertService();
        return cs.CreateNewIndividual("", "HRM", SoftwareUniqueId, "HRMDBA", EntityId, IndName, eTin, EntityOriginator, FatherName, MotherName, DateOfBirth, BirthCertificateNumber, Nid, PassportNumber, DrivingLicenseNumber);
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString InsertEntityAddress(string RequestId, int AddressTypeId, int DivisionId, int DistrictId, int ThanaId, string PostOfficeId, string AddressDetails)
    {
        CODConsumer.InsertEntityReference.InsertService cs = new CODConsumer.InsertEntityReference.InsertService();
        return cs.InsertEntityAddress(RequestId, AddressTypeId, DivisionId, DistrictId, ThanaId, PostOfficeId, AddressDetails);
    }

    #region Log Entries

    [SqlFunction(FillRowMethodName = "FillRow")]
    public static IEnumerable InitMethod(String logname)
    {
        return new EventLog(logname).Entries;
    }

    public static void FillRow(Object obj, out SqlDateTime timeWritten, out SqlChars message, out SqlChars category, out long instanceId)
    {
        EventLogEntry eventLogEntry = (EventLogEntry)obj;
        timeWritten = new SqlDateTime(eventLogEntry.TimeWritten);
        message = new SqlChars(eventLogEntry.Message);
        category = new SqlChars(eventLogEntry.Category);
        instanceId = eventLogEntry.InstanceId;
    }

    #endregion

    #region Country List

    public class Country
    {
        public SqlInt32 CountryId { get; set; }
        public SqlString CountryName { get; set; }

        public Country()
        { }

        public Country(SqlInt32 countryId, SqlString countryName)
        {
            this.CountryId = countryId;
            this.CountryName = countryName;
        }
    }

    public static void FillCountry(Object row, out SqlInt32 countryId, out SqlString countryName)
    {
        Country cList = (Country)row;
        countryId = cList.CountryId;
        countryName = cList.CountryName;
    }

    [SqlFunction(DataAccess = DataAccessKind.Read, FillRowMethodName = "FillCountry", TableDefinition = "CountryId int,CountryName nvarchar(100)")]
    public static IEnumerable GetCountryList(String Key)
    {
        CODConsumer.GeographicalReference.GeographicalInfoWebService gs = new CODConsumer.GeographicalReference.GeographicalInfoWebService();
        DataTable dt = new DataTable("Country");
        dt.Columns.Add("CountryId", typeof(Int32));
        dt.Columns.Add("CountryName", typeof(string));
        dt = gs.GetCountry(Key);

        List<Country> CountryList = new List<Country>();
        foreach (DataRow dr in dt.Rows)
        {
            Country C = new Country();
            C.CountryId = Convert.ToInt32(dr["CountryId"]);
            C.CountryName = dr["CountryName"].ToString();
            CountryList.Add(C);
        }
        return CountryList;
    }

    #endregion

    #region Division List

    public class Division
    {
        public SqlInt32 DivisionId { get; set; }
        public SqlString DivisionName { get; set; }

        public Division(SqlInt32 divisionId, SqlString divisionName)
        {
            this.DivisionId = divisionId;
            this.DivisionName = divisionName;
        }
    }

    public static void FillDivision(Object row, out SqlInt32 divisionId, out SqlString divisionName)
    {
        Division dList = (Division)row;
        divisionId = dList.DivisionId;
        divisionName = dList.DivisionName;
    }

    [SqlFunction(DataAccess = DataAccessKind.Read, FillRowMethodName = "FillDivision", TableDefinition = "DivisionId int,DivisionName nvarchar(100)")]
    public static IEnumerable GetDivisionList(String Key, String CountryId)
    {
        CODConsumer.GeographicalReference.GeographicalInfoWebService gs = new CODConsumer.GeographicalReference.GeographicalInfoWebService();
        DataTable dt = new DataTable("Division");
        dt.Columns.Add("DivisionId", typeof(Int32));
        dt.Columns.Add("DivisionName", typeof(string));
        dt = gs.GetDivision(Key, CountryId);

        List<Division> DivisionList = new List<Division>();
        foreach (DataRow dr in dt.Rows)
        {
            Division D = new Division(Convert.ToInt32(dr["DivisionId"]), dr["DivisionName"].ToString());
            DivisionList.Add(D);
        }
        return DivisionList;
    }


    #endregion

    #region District List

    public class District
    {
        public SqlInt32 DistrictId { get; set; }
        public SqlString DistrictName { get; set; }

        public District(SqlInt32 districtId, SqlString districtName)
        {
            this.DistrictId = districtId;
            this.DistrictName = districtName;
        }
    }

    public static void FillDistrict(Object row, out SqlInt32 districtId, out SqlString districtName)
    {
        District dList = (District)row;
        districtId = dList.DistrictId;
        districtName = dList.DistrictName;
    }

    [SqlFunction(DataAccess = DataAccessKind.Read, FillRowMethodName = "FillDistrict", TableDefinition = "DistrictId int,DistrictName nvarchar(100)")]
    public static IEnumerable GetDistrictList(String Key, String DivisionId)
    {
        CODConsumer.GeographicalReference.GeographicalInfoWebService gs = new CODConsumer.GeographicalReference.GeographicalInfoWebService();
        DataTable dt = new DataTable("District");
        dt.Columns.Add("DistrictId", typeof(Int32));
        dt.Columns.Add("DistrictName", typeof(string));
        dt = gs.GetDistrict(Key, DivisionId);

        List<District> DistrictList = new List<District>();
        foreach (DataRow dr in dt.Rows)
        {
            District D = new District(Convert.ToInt32(dr["DistrictId"]), dr["DistrictName"].ToString());
            DistrictList.Add(D);
        }
        return DistrictList;
    }


    #endregion

    #region Thana List

    public class Thana
    {
        public SqlInt32 ThanaId { get; set; }
        public SqlString ThanaName { get; set; }

        public Thana(SqlInt32 thanaId, SqlString thanaName)
        {
            this.ThanaId = thanaId;
            this.ThanaName = thanaName;
        }
    }

    public static void FillThana(Object row, out SqlInt32 thanaId, out SqlString thanaName)
    {
        Thana tList = (Thana)row;
        thanaId = tList.ThanaId;
        thanaName = tList.ThanaName;
    }

    [SqlFunction(DataAccess = DataAccessKind.Read, FillRowMethodName = "FillThana", TableDefinition = "ThanaId int,ThanaName nvarchar(100)")]
    public static IEnumerable GetThanaList(String Key, String DistrictId)
    {
        CODConsumer.GeographicalReference.GeographicalInfoWebService gs = new CODConsumer.GeographicalReference.GeographicalInfoWebService();
        DataTable dt = new DataTable("Thana");
        dt.Columns.Add("ThanaId", typeof(Int32));
        dt.Columns.Add("ThanaName", typeof(string));
        dt = gs.GetThana(Key, DistrictId);

        List<Thana> ThanaList = new List<Thana>();
        foreach (DataRow dr in dt.Rows)
        {
            Thana T = new Thana(Convert.ToInt32(dr["ThanaId"]), dr["ThanaName"].ToString());
            ThanaList.Add(T);
        }
        return ThanaList;
    }

    #endregion

    #region Post Office List

    public class PostOffices
    {
        public SqlInt32 PostOfficeId { get; set; }
        public SqlString PostOfficeName { get; set; }
        public SqlString PostCode { get; set; }

        public PostOffices(SqlInt32 postOfficeId, SqlString postOfficeName)
        {
            this.PostOfficeId = postOfficeId;
            this.PostOfficeName = postOfficeName;
        }
    }

    public static void FillPostOffice(Object row, out SqlInt32 postOfficeId, out SqlString postOfficeName)
    {
        PostOffices pList = (PostOffices)row;
        postOfficeId = pList.PostOfficeId;
        postOfficeName = pList.PostOfficeName;
    }

    [SqlFunction(DataAccess = DataAccessKind.Read, FillRowMethodName = "FillPostOffice", TableDefinition = "PostOfficeId int,PostOfficeName nvarchar(100)")]
    public static IEnumerable GetPostOfficeList(String Key, String ThanaId)
    {
        CODConsumer.GeographicalReference.GeographicalInfoWebService gs = new CODConsumer.GeographicalReference.GeographicalInfoWebService();
        DataTable dt = new DataTable("PostOffices");
        dt.Columns.Add("PostOfficeId", typeof(Int32));
        dt.Columns.Add("PostOfficeName", typeof(string));
        dt = gs.GetPostOffice(Key, ThanaId);

        List<PostOffices> POList = new List<PostOffices>();
        foreach (DataRow dr in dt.Rows)
        {
            PostOffices PO = new PostOffices(Convert.ToInt32(dr["PostOfficeId"]), dr["PostOfficeName"].ToString());
            POList.Add(PO);
        }
        return POList;
    }

    #endregion

    #region Address Type List

    public class AddressType
    {
        public SqlInt32 ValueId { get; set; }
        public SqlString ValueName { get; set; }

        public AddressType(SqlInt32 valueId, SqlString valueName)
        {
            this.ValueId = valueId;
            this.ValueName = valueName;
        }
    }

    public static void FillAddressType(Object row, out SqlInt32 valueId, out SqlString valueName)
    {
        AddressType atList = (AddressType)row;
        valueId = atList.ValueId;
        valueName = atList.ValueName;
    }

    [SqlFunction(DataAccess = DataAccessKind.Read, FillRowMethodName = "FillAddressType", TableDefinition = "ValueId int,ValueName nvarchar(100)")]
    public static IEnumerable GetAddressTypeList(String Key)
    {
        CODConsumer.OtherReference.OtherInfoWebService os = new CODConsumer.OtherReference.OtherInfoWebService();
        DataTable dt = new DataTable("AddressType");
        dt.Columns.Add("ValueId", typeof(Int32));
        dt.Columns.Add("ValueName", typeof(string));
        dt = os.GetAddressType(Key);

        List<AddressType> ATList = new List<AddressType>();
        foreach (DataRow dr in dt.Rows)
        {
            AddressType AT = new AddressType(Convert.ToInt32(dr["ValueId"]), dr["ValueName"].ToString());
            ATList.Add(AT);
        }
        return ATList;
    }

    #endregion
};


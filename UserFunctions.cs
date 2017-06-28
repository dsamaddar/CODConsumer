using System;
using System.IO;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
   private class FileProperties
    {
        public SqlString FileName;
        public SqlInt64 FileSize;
        public SqlDateTime CreationTime;
        public FileProperties(SqlString fileName, SqlInt64 fileSize,SqlDateTime creationTime)
        {
            FileName = fileName;
            FileSize = fileSize;
            CreationTime = creationTime;
        }
    }
    //The SqlFunction attribute tells Visual Studio to register this 
    //code as a user defined function
    [Microsoft.SqlServer.Server.SqlFunction(FillRowMethodName = "FindFiles",TableDefinition = "FileName nvarchar(500), FileSize bigint,CreationTime datetime")]
    public static IEnumerable BuildFileNamesArray(string targetDirectory,string searchPattern)
    {
        try
        {
            ArrayList FilePropertiesCollection = new ArrayList();
            DirectoryInfo dirInfo = new DirectoryInfo(targetDirectory);
            FileInfo[] files = dirInfo.GetFiles(searchPattern);
            foreach (FileInfo fileInfo in files)
            {
                //I'm adding to the colection the properties (FileProperties) 
                //of each file I've found  
                FilePropertiesCollection.Add(new FileProperties(fileInfo.Name, 
                fileInfo.Length, fileInfo.CreationTime));
            }
            return FilePropertiesCollection;
        }
        catch (Exception ex)
        {
            return null;
        }
    }
    //FillRow method. The method name has been specified above as 
    //a SqlFunction attribute property
    public static void FindFiles(object objFileProperties, out SqlString fileName,out SqlInt64 fileSize, out SqlDateTime creationTime)
    {
        //I'm using here the FileProperties class defined above
        FileProperties fileProperties = (FileProperties)objFileProperties;
        fileName = fileProperties.FileName;
        fileSize = fileProperties.FileSize;
        creationTime = fileProperties.CreationTime;
    }
};


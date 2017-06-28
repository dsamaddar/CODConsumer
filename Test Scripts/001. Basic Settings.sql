use master

ALTER DATABASE HRM SET trustworthy ON

USE HRM

exec sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

exec sp_configure 'clr enabled', 1;
GO
RECONFIGURE;
GO

exec sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO

-- Create the assemblies from the ones we have built.
USE HRM
create assembly CODConsumer from 'C:\CODCLR\CODConsumer.dll' with permission_set = external_access
create assembly [CODConsumer.XmlSerializers] from 'C:\CODCLR\CODConsumer.XmlSerializers.dll' with permission_set = external_access

go


/* Getting All database Owner
SELECT
    a.name
    , a.owner_sid
    , b.sid
    , b.name
    , b.type_desc
FROM   
    master.sys.databases a
    LEFT OUTER JOIN master.sys.server_principals b
        ON a.owner_sid = b.sid
WHERE
    a.name not in ('master','tempdb','model','msdb');
*/
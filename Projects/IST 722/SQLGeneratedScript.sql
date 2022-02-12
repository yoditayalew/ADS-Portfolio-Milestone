/****** Object:  Database ist722_hhkhan_ob3_dw    Script Date: 1/13/2022 6:56:04 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_hhkhan_ob3_dw
GO
CREATE DATABASE ist722_hhkhan_ob3_dw
GO
ALTER DATABASE ist722_hhkhan_ob3_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_ob3_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
--CREATE SCHEMA Group3ob3
--GO

/* Drop table Group3ob3.FactProductReview */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Group3ob3.FactProductReview') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Group3ob3.FactProductReview 



/* Create table Group3ob3.FactProductReview */CREATE TABLE Group3ob3.FactProductReview (   [ItemKey]  int   NOT NULL,  [DateKey]  int   NOT NULL,  [UserKey]  int   NOT NULL,  [rating]  int   NULL,  [source] nvarchar(20)  NOT NULL, CONSTRAINT [PK_Group3ob3.FactProductReview] PRIMARY KEY NONCLUSTERED( [ItemKey], [UserKey] )) ON [PRIMARY];




/* Drop table Group3ob3.DimItems */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Group3ob3.DimItems') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Group3ob3.DimItems 
;

/* Create table Group3ob3.DimItems */
CREATE TABLE Group3ob3.DimItems (
   [ItemKey]  int IDENTITY  NOT NULL
,  [item_id]  varchar(50)   NOT NULL
,  [item_department]  nvarchar(20)   NOT NULL
,  [item_name]  nvarchar(200) NULL
,  [item_is_active]  bit   NOT NULL
,  [RowIsCurrent]  bit DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200) NULL
,  [item_source] nvarchar(20) NOT NULL

, CONSTRAINT [PK_Group3ob3.DimItems] PRIMARY KEY CLUSTERED 
( [ItemKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT Group3ob3.DimItems ON
;
INSERT INTO Group3ob3.DimItems (ItemKey, item_id, item_department, item_name, item_is_active, item_source, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'Unk', 'Unk Department', 'Unk Name', 0, 'Unk Source',  1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT Group3ob3.DimItems OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Group3ob3].[Items]'))
DROP VIEW [Group3ob3].[Items]
GO
CREATE VIEW [Group3ob3].[Items] AS 
SELECT [ItemKey] AS [ItemKey]
, [item_id] AS [item_id]
, [item_department] AS [item_department]
, [item_name] AS [item_name]
, [item_is_active] AS [item_is_active]
, [item_source] as [item_source]
FROM Group3ob3.DimItems
GO







/* Drop table Group3ob3.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Group3ob3.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Group3ob3.DimDate 
;

/* Create table Group3ob3.DimDate */
CREATE TABLE Group3ob3.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  int   NOT NULL
,  [IsWeekday]  varchar(1)  DEFAULT '0' NOT NULL
, CONSTRAINT [PK_Group3ob3.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;


INSERT INTO Group3ob3.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, '?')
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Group3ob3].[Date]'))
DROP VIEW [Group3ob3].[Date]
GO
CREATE VIEW [Group3ob3].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsWeekday] AS [IsWeekday]
FROM Group3ob3.DimDate
GO







/* Drop table Group3ob3.DimUsers */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Group3ob3.DimUsers') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Group3ob3.DimUsers 
;

/* Create table Group3ob3.DimUsers */
CREATE TABLE Group3ob3.DimUsers (
   [UserKey]  int IDENTITY  NOT NULL
,  [user_ID]  int   NOT NULL
,  [user_FullName]  nvarchar(152)   NOT NULL
,  [user_city]  varchar(50)   NOT NULL
,  [user_state]  char(2)   NOT NULL
,  [user_zip]  varchar(20)   NOT NULL
,  [RowIsCurrent]  bit DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200) NULL
,  [user_source] nvarchar(20) NOT NULL
, CONSTRAINT [PK_Group3ob3.DimUsers] PRIMARY KEY CLUSTERED 
( [UserKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT Group3ob3.DimUsers ON
;
INSERT INTO Group3ob3.DimUsers (UserKey, user_ID, user_FullName, user_city, user_state, user_zip, user_source, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'Unk Name', 'Unk City', 'NA', 'Unk Zip', 'Unk Source', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT Group3ob3.DimUsers OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Group3ob3].[Users]'))
DROP VIEW [Group3ob3].[Users]
GO
CREATE VIEW [Group3ob3].[Users] AS 
SELECT [UserKey] AS [UserKey]
, [user_ID] AS [userID]
, [user_FirstName] AS [first_name]
, [user_LastName] AS [last_name]
, [user_zip] AS [user_zip]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM Group3ob3.DimUsers
GO


ALTER TABLE [Group3ob3].FactProductReview ADD CONSTRAINT
   FK_Group3ob3_FactProductReview_ItemKey FOREIGN KEY
   (
   ItemKey
   ) REFERENCES [Group3ob3].DimItems
   ( ItemKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE [Group3ob3].FactProductReview ADD CONSTRAINT
   FK_Group3ob3_FactProductReview_UserKey FOREIGN KEY
   (
   UserKey
   ) REFERENCES [Group3ob3].DimUsers
   ( UserKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE [Group3ob3].FactProductReview ADD CONSTRAINT
   FK_Group3ob3_FactProductReview_DateKey FOREIGN KEY
   (
   DateKey
   ) REFERENCES [Group3ob3].DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;



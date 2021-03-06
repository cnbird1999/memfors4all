USE [master]
GO
/****** Object:  Database [VolatilityStore]    Script Date: 11/28/2014 7:06:15 PM ******/
CREATE DATABASE [VolatilityStore]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'VolatilityDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\VolatilityDB.mdf' , SIZE = 209920KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'VolatilityDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\VolatilityDB_log.ldf' , SIZE = 102400KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [VolatilityStore] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [VolatilityStore].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [VolatilityStore] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [VolatilityStore] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [VolatilityStore] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [VolatilityStore] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [VolatilityStore] SET ARITHABORT OFF 
GO
ALTER DATABASE [VolatilityStore] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [VolatilityStore] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [VolatilityStore] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [VolatilityStore] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [VolatilityStore] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [VolatilityStore] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [VolatilityStore] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [VolatilityStore] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [VolatilityStore] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [VolatilityStore] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [VolatilityStore] SET  DISABLE_BROKER 
GO
ALTER DATABASE [VolatilityStore] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [VolatilityStore] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [VolatilityStore] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [VolatilityStore] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [VolatilityStore] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [VolatilityStore] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [VolatilityStore] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [VolatilityStore] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [VolatilityStore] SET  MULTI_USER 
GO
ALTER DATABASE [VolatilityStore] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [VolatilityStore] SET DB_CHAINING OFF 
GO
ALTER DATABASE [VolatilityStore] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [VolatilityStore] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'VolatilityStore', N'ON'
GO
USE [VolatilityStore]
GO
/****** Object:  UserDefinedFunction [dbo].[IntegerToIPAddress]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[IntegerToIPAddress] (@IP AS bigint)

RETURNS varchar(15)

AS

BEGIN

DECLARE @Octet1 bigint

DECLARE @Octet2 bigint

DECLARE @Octet3 bigint

DECLARE @Octet4 bigint

DECLARE @RestOfIP bigint

SET @Octet1 = @IP / 16777216

SET @RestOfIP = @IP - (@Octet1 * 16777216)

SET @Octet2 = @RestOfIP / 65536

SET @RestOfIP = @RestOfIP - (@Octet2 * 65536)

SET @Octet3 = @RestOfIP / 256

SET @Octet4 = @RestOfIP - (@Octet3 * 256)

RETURN(CONVERT(varchar, @Octet1) + '.' +

CONVERT(varchar, @Octet2) + '.' +

CONVERT(varchar, @Octet3) + '.' +

CONVERT(varchar, @Octet4))

END



GO
/****** Object:  UserDefinedFunction [dbo].[IPAddressToInteger]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IPAddressToInteger] (@IP AS varchar(15))

RETURNS bigint

AS

BEGIN

RETURN (CONVERT(bigint, PARSENAME(@IP,1)) +

CONVERT(bigint, PARSENAME(@IP,2)) * 256 +

CONVERT(bigint, PARSENAME(@IP,3)) * 65536 +

CONVERT(bigint, PARSENAME(@IP,4)) * 16777216)

END


GO
/****** Object:  Table [dbo].[CommandList]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CommandList](
	[ID] [int] NULL,
	[Command] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[Complexity] [varchar](50) NULL,
	[Category] [varchar](200) NULL,
	[Priority] [int] NULL,
	[Output Type] [varchar](255) NULL,
	[Format] [text] NULL,
	[Usage] [varchar](500) NULL,
	[Enabled] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Commands]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Commands](
	[Command] [varchar](50) NULL,
	[Location] [int] NULL,
	[Complexity] [varchar](50) NULL,
	[Category] [varchar](50) NULL,
	[Priority] [int] NULL,
	[Output Type] [varchar](50) NULL,
	[Format] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GeoIP_Blocks]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeoIP_Blocks](
	[startIpNum] [bigint] NULL,
	[endIpNum] [bigint] NULL,
	[locId] [bigint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeoIP_City]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GeoIP_City](
	[locId] [bigint] NULL,
	[country] [varchar](200) NULL,
	[region] [varchar](200) NULL,
	[city] [varchar](300) NULL,
	[postalCode] [varchar](50) NULL,
	[latitude] [varchar](50) NULL,
	[longitude] [varchar](50) NULL,
	[metroCode] [varchar](50) NULL,
	[areaCode] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GEOIP_NUM]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GEOIP_NUM](
	[StartIPNum] [bigint] NULL,
	[EndIPNum] [bigint] NULL,
	[Entity Name] [varchar](1000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GeoIP_WhoIs]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GeoIP_WhoIs](
	[StartIP] [varchar](50) NULL,
	[EndIP] [varchar](50) NULL,
	[StartIPNum] [bigint] NULL,
	[EndIPNum] [bigint] NULL,
	[Code] [varchar](50) NULL,
	[Country ] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ScriptTemplate]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ScriptTemplate](
	[Platform] [varchar](50) NULL,
	[Template] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Callbacks]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Callbacks](
	[HostID] [varchar](10) NULL,
	[Type] [varchar](50) NULL,
	[Callback] [varchar](50) NULL,
	[Module] [varchar](50) NULL,
	[Details] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Connections]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Connections](
	[HostID] [varchar](10) NULL,
	[Offset(V)] [varchar](50) NULL,
	[Local Address] [varchar](50) NULL,
	[Remote Address] [varchar](50) NULL,
	[Pid] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Connscan]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Connscan](
	[HostID] [varchar](10) NULL,
	[Local Address] [varchar](50) NULL,
	[Remote Address] [varchar](50) NULL,
	[Pid] [varchar](50) NULL,
	[Offset(P)] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Driverscan]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Driverscan](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[#Ptr] [varchar](50) NULL,
	[#Hnd] [varchar](50) NULL,
	[Start] [varchar](50) NULL,
	[Size] [varchar](50) NULL,
	[Service Key] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[Driver Name] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Envars]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Envars](
	[HostID] [varchar](10) NULL,
	[Pid] [varchar](50) NULL,
	[Process] [varchar](50) NULL,
	[Block] [varchar](50) NULL,
	[Variable] [varchar](50) NULL,
	[Value] [varchar](1000) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Filescan]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Filescan](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[#Ptr] [varchar](50) NULL,
	[#Hnd] [varchar](50) NULL,
	[Access] [varchar](50) NULL,
	[Name] [varchar](1000) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Gdt]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Gdt](
	[HostID] [varchar](10) NULL,
	[CPU] [varchar](50) NULL,
	[Sel] [varchar](50) NULL,
	[Base] [varchar](50) NULL,
	[Limit] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[DPL] [varchar](50) NULL,
	[Gr] [varchar](50) NULL,
	[Pr] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Handles]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Handles](
	[HostID] [varchar](10) NULL,
	[Type] [varchar](50) NULL,
	[Offset(V)] [varchar](50) NULL,
	[Pid] [varchar](50) NULL,
	[Handle] [varchar](50) NULL,
	[Access] [varchar](50) NULL,
	[Details] [varchar](500) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_HiveList]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_HiveList](
	[HostID] [varchar](10) NULL,
	[Virtual] [varchar](50) NULL,
	[Physical] [varchar](50) NULL,
	[Name] [varchar](500) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Host_ImageInfo]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Host_ImageInfo](
	[HostID] [varchar](10) NOT NULL,
	[Hostname] [varchar](50) NULL,
	[AnalysisDateTime] [datetime] NULL,
	[ImageSize_KB] [bigint] NULL,
	[ImageDate] [datetime] NULL,
	[ImageMD5Hash] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL,
 CONSTRAINT [PK_Windows_Host_Basic] PRIMARY KEY CLUSTERED 
(
	[HostID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_idt]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_idt](
	[HostID] [varchar](10) NULL,
	[CPU] [varchar](50) NULL,
	[Index] [varchar](50) NULL,
	[Selector] [varchar](50) NULL,
	[Value] [varchar](50) NULL,
	[Module] [varchar](50) NULL,
	[Section] [varchar](50) NULL,
	[LoadDatetime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_IOC]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_IOC](
	[IOCID] [int] NULL,
	[Name] [varchar](50) NULL,
	[Type] [varchar](200) NULL,
	[Location] [varchar](300) NULL,
	[Value] [varchar](500) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_LdrModules]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_LdrModules](
	[HostID] [varchar](10) NULL,
	[Pid] [varchar](50) NULL,
	[Process] [varchar](50) NULL,
	[Base] [varchar](50) NULL,
	[InLoad] [varchar](50) NULL,
	[InInit] [varchar](50) NULL,
	[InMem] [varchar](50) NULL,
	[MappedPath] [varchar](200) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_md5]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_md5](
	[HostID] [varchar](10) NULL,
	[md5_Hash] [varchar](50) NULL,
	[Image_Location] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_MutantScan]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_MutantScan](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[#Ptr] [varchar](50) NULL,
	[#Hnd] [varchar](50) NULL,
	[Signal] [varchar](50) NULL,
	[Thread] [varchar](50) NULL,
	[CID] [varchar](50) NULL,
	[Name] [varchar](300) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_PrintKey]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_PrintKey](
	[HostID] [varchar](10) NULL,
	[RegistryDetails] [varchar](8000) NULL,
	[LoodDateTime] [datetime] NULL,
	[ID] [bigint] IDENTITY(10000,1) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_ProcessingQueue]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_ProcessingQueue](
	[QueueID] [bigint] NOT NULL,
	[QueuedTime] [datetime] NULL,
	[HostID] [bigint] IDENTITY(1000000,1) NOT NULL,
	[ZipFolderName] [varchar](100) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[NodeName] [varchar](100) NULL,
	[ImageTakenTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_PsList]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_PsList](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[PID] [varchar](50) NULL,
	[PPID] [varchar](50) NULL,
	[Thds] [varchar](50) NULL,
	[Hnds] [varchar](50) NULL,
	[Sess] [varchar](50) NULL,
	[Wow64] [varchar](50) NULL,
	[Start] [varchar](50) NULL,
	[End] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_PSScan]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_PSScan](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[PID] [varchar](50) NULL,
	[PPID] [varchar](50) NULL,
	[PDB] [varchar](50) NULL,
	[Time Created] [varchar](50) NULL,
	[Time Exited] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Pstree]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Pstree](
	[HostID] [varchar](10) NULL,
	[ID] [bigint] IDENTITY(1000,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[PID] [varchar](50) NULL,
	[Thds] [varchar](50) NULL,
	[Hnds] [varchar](50) NULL,
	[PPid] [varchar](50) NULL,
	[Time] [varchar](50) NULL,
	[LoadDatetime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Psxview]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Psxview](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[PID] [varchar](50) NULL,
	[pslist] [varchar](50) NULL,
	[psscan] [varchar](50) NULL,
	[thrdproc] [varchar](50) NULL,
	[pspcid] [varchar](50) NULL,
	[csrss] [varchar](50) NULL,
	[session] [varchar](50) NULL,
	[deskthrd] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Sockets]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Sockets](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[PID] [varchar](50) NULL,
	[Port] [varchar](50) NULL,
	[Proto] [varchar](50) NULL,
	[Protocol] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[Create Time] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_SockScan]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_SockScan](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[PID] [varchar](50) NULL,
	[Port] [varchar](50) NULL,
	[Proto] [varchar](50) NULL,
	[Protocol] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[Create Time] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Symlinkscan]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Symlinkscan](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[#Ptr] [varchar](50) NULL,
	[#Hnd] [varchar](50) NULL,
	[Creation time] [varchar](50) NULL,
	[From] [varchar](500) NULL,
	[To] [varchar](500) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Windows_Timers]    Script Date: 11/28/2014 7:06:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Windows_Timers](
	[HostID] [varchar](10) NULL,
	[Offset(P)] [varchar](50) NULL,
	[DueTime] [varchar](50) NULL,
	[Period(ms)] [varchar](50) NULL,
	[Signaled] [varchar](50) NULL,
	[Routine] [varchar](50) NULL,
	[Module] [varchar](50) NULL,
	[LoadDateTime] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Windows_Callbacks] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Connections] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Connscan] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Driverscan] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Envars] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Filescan] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Gdt] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Handles] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_HiveList] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Host_ImageInfo] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_idt] ADD  DEFAULT (getdate()) FOR [LoadDatetime]
GO
ALTER TABLE [dbo].[Windows_LdrModules] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_md5] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_MutantScan] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_PrintKey] ADD  DEFAULT (getdate()) FOR [LoodDateTime]
GO
ALTER TABLE [dbo].[Windows_ProcessingQueue] ADD  CONSTRAINT [DF_Windows_ProcessingQueue_QueuedTime]  DEFAULT (getdate()) FOR [QueuedTime]
GO
ALTER TABLE [dbo].[Windows_PsList] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_PSScan] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Pstree] ADD  DEFAULT (getdate()) FOR [LoadDatetime]
GO
ALTER TABLE [dbo].[Windows_Psxview] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Sockets] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_SockScan] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Symlinkscan] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
ALTER TABLE [dbo].[Windows_Timers] ADD  DEFAULT (getdate()) FOR [LoadDateTime]
GO
USE [master]
GO
ALTER DATABASE [VolatilityStore] SET  READ_WRITE 
GO

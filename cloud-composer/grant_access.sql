-- Grant owner role to a user
USE MyDB
EXEC sp_adduser 'user';
EXEC sp_addrolemember 'db_owner', 'user';
GO

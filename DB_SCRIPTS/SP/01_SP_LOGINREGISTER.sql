CREATE PROCEDURE [dbo].[SP_LOGINREGISTER]
@Title VARCHAR(10) = NULL,
@Name VARCHAR(100) = NULL,
@Gender VARCHAR(10) = NULL,
@Address VARCHAR(MAX) = NULL,
@Email VARCHAR(100) = NULL,
@Mobno VARCHAR(10) = NULL,
@Passno VARCHAR(30) = NULL,
@Aadharno VARCHAR(20) = NULL,
@Panno VARCHAR(20) = NULL,
@UserName VARCHAR(20),
@Password VARCHAR(20),
@Mode VARCHAR(10)
as
BEGIN
IF @Mode = 'Login'
BEGIN
IF EXISTS (SELECT * FROM AR_LOGIN WHERE USERNAME = @UserName AND PASSWORD = @Password)
BEGIN 
UPDATE AR_LOGIN SET LASTLOGINDATE = GETDATE()
SELECT 'SUCCESS' AS MESSAGE, * FROM AR_LOGIN L 
JOIN AR_REGISTRATION R ON L.PK_ID = R.HDR_FK WHERE L.USERNAME = @UserName
END
ELSE
BEGIN
SELECT 'FAILED' AS MESSAGE
END
END
IF @Mode = 'Register'
BEGIN
IF EXISTS (SELECT * FROM AR_LOGIN WHERE USERNAME = @UserName)
BEGIN
SELECT 'USERNAME ALREADY EXISTS' AS MESSAGE
END
ELSE IF EXISTS (SELECT * FROM AR_REGISTRATION WHERE MOBILENO = @Mobno )
BEGIN
SELECT 'MOBILE NUMBER ALREADY EXISTS'  AS MESSAGE
END
ELSE IF EXISTS (SELECT * FROM AR_REGISTRATION WHERE PASSPORTNO = @Passno )
BEGIN
SELECT 'PASSPORT NUMBER ALREADY EXISTS'  AS MESSAGE
END
ELSE IF EXISTS (SELECT * FROM AR_REGISTRATION WHERE AADHARNO = @Aadharno )
BEGIN
SELECT 'AADHAR NUMBER ALREADY EXISTS'  AS MESSAGE
END
ELSE IF EXISTS (SELECT * FROM AR_REGISTRATION WHERE PANNO = @Panno )
BEGIN
SELECT 'PAN NUMBER ALREADY EXISTS'  AS MESSAGE
END
ELSE
BEGIN

BEGIN TRY
BEGIN TRANSACTION

INSERT INTO AR_LOGIN(USERNAME,PASSWORD,USERTYPE,ISACTIVE) VALUES (@UserName,@Password,'1','1')

INSERT INTO AR_REGISTRATION (HDR_FK,TITLE,NAME,GENDER,EMAILID,MOBILENO,PASSPORTNO,AADHARNO,PANNO,ADDRESS)
SELECT A.PK_ID,@Title,@Name,@Gender,@Email,@Mobno,@Passno,@Aadharno,@Panno,@Address 
FROM AR_LOGIN A WHERE USERNAME = @UserName
SELECT 'SUCCESS' AS MESSAGE
COMMIT TRANSACTION
END TRY

BEGIN CATCH
SELECT ERROR_MESSAGE() AS MESSAGE
ROLLBACK TRANSACTION

END CATCH
END

END

END


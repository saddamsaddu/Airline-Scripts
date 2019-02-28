CREATE PROCEDURE [dbo].[SP_ADDANDVIEWFLIGHT]
@FlightName VARCHAR(50) = NULL,
@FromPlace varchar(100) = null,
@ToPlace Varchar(100) = null,
@ArrivalTime VARCHAR(100) = NULL,
@DepatureTime VARCHAR(100) = NULL,
@Seats int = NULL,
@TicketPrice varchar(20) = NULL,
@Mode VARCHAR(10)
as
BEGIN
IF @Mode = 'View'
BEGIN
select FLIGHT_ID,From_place,TO_PLACE,FLIGHT_NAME,ARRIVAL_TIME,DEPATURE_TIME,SEATS,TICKET_PRICE from FLIGHTDET
END
IF @Mode = 'Add'
BEGIN
begin transaction
begin try
DECLARE @FLIGHT_ID VARCHAR(10)
SELECT @FLIGHT_ID = ID FROM MAXFLIGHTIDGEN
SELECT @FLIGHT_ID = @FLIGHT_ID + 1
insert INTO FLIGHTDET VALUES(@FLIGHT_ID,@FlightName,@FromPlace,@ToPlace,@ArrivalTime,@DepatureTime,@Seats,@TicketPrice,'admin',GETDATE(),1)
select 'SUCCESS' as Message,@FLIGHT_ID as flightid
update MAXFLIGHTIDGEN set id = @FLIGHT_ID

commit transaction
end try
begin catch
rollback transaction
Select ERROR_MESSAGE() as Message
end catch

END

END



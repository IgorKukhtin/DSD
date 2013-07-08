-- Function: gpGet_Movement_Income()

--DROP FUNCTION gpGet_Movement_Income(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Income(
IN inId          Integer,       /* Единица измерения */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer,
               StatusName TVarChar, FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, 
               PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar,
               CarId Integer, CarName TVarChar, PersonalDriverId Integer, PersonalDriverName TVarChar,
               PersonalPackerId Integer, PersonalPackerName TVarChar, OperDatePartner TDateTime,
               InvNumberPartner TVarChar, PriceWithVAT Boolean, ChangePercent TFloat) 
AS
$BODY$
BEGIN

--   PERFORM lpCheckRight (inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT 
       Movement.Id,
       Movement.InvNumber,
       Movement.OperDate,
       Status.ObjectCode          AS StatusCode,
       Status.ValueData           AS StatusName,
       ObjectFrom.Id              AS FromId,
       ObjectFrom.ValueData       AS FromName,
       ObjectTo.Id                AS ToId,
       ObjectTo.ValueData         AS ToName,
       PaidKind.Id                AS PaidKindId,
       PaidKind.ValueData         AS PaidKindName,
       Contract.Id                AS ContractId,
       Contract.ValueData         AS ContractName,
       Car.Id                     AS CarId,
       Car.ValueData              AS CarName,
       PersonalDriver.Id          AS PersonalDriverId,
       PersonalDriver.ValueData   AS PersonalDriverName,
       PersonalPacker.Id          AS PersonalPackerId,
       PersonalPacker.ValueData   AS PersonalPackerName,
       OperDatePartner.ValueData  AS OperDatePartner,
       InvNumberPartner.ValueData AS InvNumberPartner,
       PriceWithVAT.ValueData     AS PriceWithVAT,
            MovementFloat_ChangePercent.ValueData       AS ChangePercent
     FROM Movement
LEFT JOIN Object AS Status 
       ON Status.id = Movement.StatusId    
LEFT JOIN MovementLinkObject AS MovementLinkObject_From 
       ON MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
      AND MovementLinkObject_From.MovementId = Movement.Id
LEFT JOIN Object AS ObjectFrom 
       ON ObjectFrom.Id =  MovementLinkObject_From.ObjectId
LEFT JOIN MovementLinkObject AS MovementLinkObject_To
       ON MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
      AND MovementLinkObject_To.MovementId = Movement.Id
LEFT JOIN Object AS ObjectTo 
       ON ObjectTo.Id =  MovementLinkObject_To.ObjectId
LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
       ON MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
      AND MovementLinkObject_PaidKind.MovementId = Movement.Id
LEFT JOIN Object AS PaidKind
       ON PaidKind.Id =  MovementLinkObject_PaidKind.ObjectId
LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
       ON MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
      AND MovementLinkObject_Contract.MovementId = Movement.Id
LEFT JOIN Object AS Contract 
       ON Contract.Id =  MovementLinkObject_Contract.ObjectId
LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
       ON MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
      AND MovementLinkObject_Car.MovementId = Movement.Id
LEFT JOIN Object AS Car 
       ON Car.Id =  MovementLinkObject_Car.ObjectId
LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
       ON MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
      AND MovementLinkObject_PersonalDriver.MovementId = Movement.Id
LEFT JOIN Object AS PersonalDriver 
       ON PersonalDriver.Id =  MovementLinkObject_PersonalDriver.ObjectId
LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
       ON MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
      AND MovementLinkObject_PersonalPacker.MovementId = Movement.Id
LEFT JOIN Object AS PersonalPacker 
       ON PersonalPacker.Id =  MovementLinkObject_PersonalPacker.ObjectId
LEFT JOIN MovementDate AS OperDatePartner 
       ON OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
      AND OperDatePartner.MovementId =  Movement.Id
LEFT JOIN MovementString AS InvNumberPartner 
       ON InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
      AND InvNumberPartner.MovementId =  Movement.Id
LEFT JOIN MovementBoolean AS PriceWithVAT
       ON PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
      AND PriceWithVAT.MovementId =  Movement.Id

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
    WHERE Movement.Id = inId;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 08.07.13                                        * zc_MovementFloat_ChangePercent
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Movement_Income (inId:= 1, inSession:= '2')

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
               InvNumberPartner TVarChar, PriceWithVAT Boolean, VATPercent TFloat, DiscountPercent TFloat) 
AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

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
       VATPercent.ValueData       AS VATPercent,
       DiscountPercent.ValueData  AS DiscountPercent
     FROM Movement
LEFT JOIN Object AS Status 
       ON Status.id = Movement.StatusId    
LEFT JOIN MovementLinkObject AS MovementLink_From 
       ON MovementLink_From.DescId = zc_MovementLink_From()
      AND MovementLink_From.MovementId = Movement.Id
LEFT JOIN Object AS ObjectFrom 
       ON ObjectFrom.Id =  MovementLink_From.ObjectId
LEFT JOIN MovementLinkObject AS MovementLink_To
       ON MovementLink_To.DescId = zc_MovementLink_To()
      AND MovementLink_To.MovementId = Movement.Id
LEFT JOIN Object AS ObjectTo 
       ON ObjectTo.Id =  MovementLink_To.ObjectId
LEFT JOIN MovementLinkObject AS MovementLink_PaidKind
       ON MovementLink_PaidKind.DescId = zc_MovementLink_PaidKind()
      AND MovementLink_PaidKind.MovementId = Movement.Id
LEFT JOIN Object AS PaidKind
       ON PaidKind.Id =  MovementLink_PaidKind.ObjectId
LEFT JOIN MovementLinkObject AS MovementLink_Contract
       ON MovementLink_Contract.DescId = zc_MovementLink_Contract()
      AND MovementLink_Contract.MovementId = Movement.Id
LEFT JOIN Object AS Contract 
       ON Contract.Id =  MovementLink_Contract.ObjectId
LEFT JOIN MovementLinkObject AS MovementLink_Car
       ON MovementLink_Car.DescId = zc_MovementLink_Car()
      AND MovementLink_Car.MovementId = Movement.Id
LEFT JOIN Object AS Car 
       ON Car.Id =  MovementLink_Car.ObjectId
LEFT JOIN MovementLinkObject AS MovementLink_PersonalDriver
       ON MovementLink_PersonalDriver.DescId = zc_MovementLink_PersonalDriver()
      AND MovementLink_PersonalDriver.MovementId = Movement.Id
LEFT JOIN Object AS PersonalDriver 
       ON PersonalDriver.Id =  MovementLink_PersonalDriver.ObjectId
LEFT JOIN MovementLinkObject AS MovementLink_PersonalPacker
       ON MovementLink_PersonalPacker.DescId = zc_MovementLink_PersonalPacker()
      AND MovementLink_PersonalPacker.MovementId = Movement.Id
LEFT JOIN Object AS PersonalPacker 
       ON PersonalPacker.Id =  MovementLink_PersonalPacker.ObjectId
LEFT JOIN MovementDate AS OperDatePartner 
       ON OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
      AND OperDatePartner.MovementId =  Movement.Id
LEFT JOIN MovementString AS InvNumberPartner 
       ON InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
      AND InvNumberPartner.MovementId =  Movement.Id
LEFT JOIN MovementBoolean AS PriceWithVAT
       ON PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
      AND PriceWithVAT.MovementId =  Movement.Id
LEFT JOIN MovementFloat AS VATPercent
       ON VATPercent.DescId = zc_MovementFloat_VATPercent()
      AND VATPercent.MovementId =  Movement.Id
LEFT JOIN MovementFloat AS DiscountPercent
       ON DiscountPercent.DescId = zc_MovementFloat_DiscountPercent()
      AND DiscountPercent.MovementId =  Movement.Id
    WHERE Movement.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

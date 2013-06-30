-- Function: gpSelect_Movement_Income()

--DROP FUNCTION gpSelect_Movement_Income(TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income(
IN inStartDate   TDateTime,
IN inEndDate     TDateTime,
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar, 
               FromName TVarChar, ToName TVarChar, PaidKindName TVarChar, ContractName TVarChar, OperDatePartner TDateTime,
               InvNumberPartner TVarChar) AS
$BODY$BEGIN

   --PERFORM lpCheckRight (inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT
       Movement.Id,
       Movement.InvNumber,
       Movement.OperDate,
       Status.ObjectCode          AS StatusCode,
       Status.ValueData           AS StatusName,
       ObjectFrom.ValueData       AS FromName,
       ObjectTo.ValueData         AS ToName,
       PaidKind.ValueData         AS PaidKindName,
       Contract.ValueData         AS ContractName,
       OperDatePartner.ValueData  AS OperDatePartner,
       InvNumberPartner.ValueData AS InvNumberPartner 
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
LEFT JOIN MovementDate AS OperDatePartner 
       ON OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
      AND OperDatePartner.MovementId =  Movement.Id
LEFT JOIN MovementString AS InvNumberPartner 
       ON InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
      AND InvNumberPartner.MovementId =  Movement.Id
   WHERE Movement.DescId = zc_Movement_Income();
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')

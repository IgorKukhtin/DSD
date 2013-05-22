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

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

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
LEFT JOIN MovementDate AS OperDatePartner 
       ON OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
      AND OperDatePartner.MovementId =  Movement.Id
LEFT JOIN MovementString AS InvNumberPartner 
       ON InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
      AND InvNumberPartner.MovementId =  Movement.Id
   WHERE Movement.DescId = zc_Movement_Income();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Movement_Income(TDateTime, TDateTime, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Movement_Income('2')
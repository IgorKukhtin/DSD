-- Function: gpSelect_Movement_ProductionUnion()

--DROP FUNCTION gpSelect_Movement_ProductionUnion();

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnion(
IN inStartDate   TDateTime,
IN inEndDate     TDateTime,
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusId Integer, StatusName TVarChar,
               FromName TVarChar, ToName TVarChar) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
       Movement.Id,
       Movement.InvNumber,
       Movement.OperDate,
       Movement.StatusId,
       Status.ValueData           AS StatusName,
       ObjectFrom.ValueData       AS ObjectFromName,
       ObjectTo.ValueData         AS ObjectToName
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
   WHERE Movement.DescId = zc_Movement_ProductionUnion();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Movement_ProductionUnion(TDateTime, TDateTime, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Movement_ProductionUnion('2')
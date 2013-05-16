-- Function: gpGet_Movement_ProductionUnion()

--DROP FUNCTION gpGet_Movement_ProductionUnion();

CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionUnion(
IN inId          Integer,       /* Единица измерения */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusId Integer, StatusName TVarChar,
               FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar) 
AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT 
       Movement.Id,
       Movement.InvNumber,
       Movement.OperDate,
       Movement.StatusId,
       Status.ValueData           AS StatusName,
       ObjectFrom.Id              AS FromId,
       ObjectFrom.ValueData       AS ObjectFromName,
       ObjectTo.Id                AS ToId,
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
    WHERE Movement.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

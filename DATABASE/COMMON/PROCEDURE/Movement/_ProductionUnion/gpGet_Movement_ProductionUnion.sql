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
    WHERE Movement.Id = inId;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Movement_ProductionUnion (inId:= 1, inSession:= '2')

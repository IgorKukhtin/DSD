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
   WHERE Movement.DescId = zc_Movement_ProductionUnion();
 

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProductionUnion (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')

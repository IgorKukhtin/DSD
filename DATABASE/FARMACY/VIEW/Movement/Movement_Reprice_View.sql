DROP VIEW IF EXISTS Movement_Reprice_View;

CREATE OR REPLACE VIEW Movement_Reprice_View AS 
    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , MovementLinkObject_Unit.ObjectId                      AS UnitId
      , Object_Unit.ValueData                                 AS UnitName
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat AS TotalSumm
      , MovementString_GUID.ValueData                         AS GUID
    FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN Object AS Object_Unit 
                         ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
        LEFT OUTER JOIN MovementString AS MovementString_GUID
                                       ON MovementString_GUID.MovementId = Movement.Id
                                      AND MovementString_GUID.DescId = zc_MovementString_Comment()
    WHERE Movement.DescId = zc_Movement_Reprice();

ALTER TABLE Movement_Reprice_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 27.11.15                                                         * 
*/

-- тест
-- SELECT * FROM Movement_Reprice_View  where id = 805

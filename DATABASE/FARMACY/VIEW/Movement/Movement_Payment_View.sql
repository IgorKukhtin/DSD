DROP VIEW IF EXISTS Movement_Payment_View;

CREATE OR REPLACE VIEW Movement_Payment_View AS 
    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , Movement.StatusId
      , MovementLinkObject_Juridical.ObjectId                          AS JuridicalId
      , Object_Juridical.ValueData                                     AS JuridicalName
      , Object_Status.ObjectCode                                       AS StatusCode
      , Object_Status.ValueData                                        AS StatusName
      , COALESCE(MovementFloat_TotalCount.ValueData,0)::TFloat         AS TotalCount
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat          AS TotalSumm
      
    FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId =  Movement.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId =  Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT OUTER JOIN Object AS Object_Juridical
                               ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
    WHERE Movement.DescId = zc_Movement_Payment();

ALTER TABLE Movement_Payment_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 29.10.15                                                         * 
*/

-- тест
-- SELECT * FROM Movement_Payment_View  where id = 805

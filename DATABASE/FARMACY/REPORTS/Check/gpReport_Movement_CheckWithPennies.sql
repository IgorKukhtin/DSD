-- Function: gpReport_Movement_CheckWithPennies()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckWithPennies (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_CheckWithPennies(
    IN inDateStart       TDateTime , --
    IN inDateFinal       TDateTime , --
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId             Integer
             , UnitCode           Integer
             , UnitName           TVarChar
             , CountCheck         Integer
             , CountPennies       Integer
             , ProcPennies        TFloat 
             , ProcPenniesAll     TFloat 
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
          tmpMovement_Check AS (
                SELECT
                     Movement_Check.Id
                   , Movement_Check.UnitId                                      AS UnitId
                   , MovementFloat_TotalSumm.ValueData                          AS TotalSumm
                FROM (SELECT Movement.*
                           , MovementLinkObject_Unit.ObjectId                    AS UnitId
                      FROM Movement

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                           
                      WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inDateStart)
                        AND Movement.OperDate < DATE_TRUNC ('DAY', inDateFinal) + INTERVAL '1 DAY'
                        AND Movement.DescId = zc_Movement_Check()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                   ) AS Movement_Check

                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                             ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm())
        , tmpTotal AS (SELECT (SUM(CASE WHEN MOD(round(tmpMovement_Check.TotalSumm * 100), 50) = 0 THEN 1 ELSE 0 END)::TFloat / Count(*) * 100)::TFloat  AS ProcPennies                       
                       FROM tmpMovement_Check)  
                
      SELECT 
             Object_Unit.Id                              AS UnitId
           , Object_Unit.ObjectCode                      AS UnitCode
           , Object_Unit.ValueData                       AS UnitName
           , Count(*)::Integer                           AS CountCheck
           , SUM(CASE WHEN MOD(round(tmpMovement_Check.TotalSumm * 100), 50) = 0 THEN 1 ELSE 0 END)::Integer                    AS CountPennies
           , round(SUM(CASE WHEN MOD(round(tmpMovement_Check.TotalSumm * 100), 50) = 0 THEN 1 ELSE 0 END)::TFloat / Count(*) * 100, 2)::TFloat  AS ProcPennies                       
           , round(tmpTotal.ProcPennies, 2)::TFloat                        AS ProcPenniesAll 
      FROM tmpMovement_Check
                
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement_Check.UnitId
           
           LEFT JOIN tmpTotal ON 1 = 1
                     
      GROUP BY Object_Unit.Id
             , Object_Unit.ObjectCode
             , Object_Unit.ValueData 
             , tmpTotal.ProcPennies
      ORDER BY Object_Unit.ValueData 

              ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_Movement_CheckWithPennies (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.07.21                                                       * 
*/

-- тест
--
select * from gpReport_Movement_CheckWithPennies(inDateStart := ('21.07.2021')::TDateTime , inDateFinal := ('21.07.2021')::TDateTime , inSession := '3');
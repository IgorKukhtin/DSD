-- Function: gpReport_InfoMobileAppChech()

DROP FUNCTION IF EXISTS gpReport_InfoMobileAppChech (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_InfoMobileAppChech(
    IN inOperDate     TDateTime , --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , TotalCount TFloat, TotalSumm TFloat, CountCheck Integer, CountFirstOrder Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
          
     raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMov ON COMMIT DROP AS 
     SELECT Movement.*
          , MovementLinkObject_Unit.ObjectId                   AS UnitId
          , MovementFloat_TotalCount.ValueData                 AS TotalCount
          , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
          , COALESCE (MovementBoolean_MobileFirstOrder.ValueData, False)::Boolean    AS isMobileFirstOrder
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          INNER JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                     ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                    AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
                                    AND MovementBoolean_MobileApplication.ValueData = TRUE

          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId = Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
          LEFT JOIN MovementBoolean AS MovementBoolean_MobileFirstOrder
                                    ON MovementBoolean_MobileFirstOrder.MovementId = Movement.Id
                                   AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()

     WHERE Movement.DescId = zc_Movement_Check()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.OperDate >= date_trunc('MONTH', inOperDate)
       AND Movement.OperDate < date_trunc('MONTH', inOperDate) + INTERVAL '1 MONTH';
        
     ANALYSE tmpMov;
     
     raise notice 'Value 2: %', CLOCK_TIMESTAMP();
          

     -- Результат
     RETURN QUERY
       WITH tmpMovement AS (SELECT Movement.UnitId
                                 , SUM(Movement.TotalCount)::TFloat                      AS TotalCount
                                 , SUM(Movement.TotalSumm)::TFloat                       AS TotalSumm
                                 , COUNT(*)::Integer                                     AS CountCheck
                                 , SUM(CASE WHEN Movement.isMobileFirstOrder THEN 1 ELSE 0 END)::Integer  AS CountFirstOrder
                            FROM tmpMov AS Movement
                            GROUP BY Movement.UnitId
                            )
            
         SELECT       
             Object_Unit.Id                                        AS UnitId
           , Object_Unit.ObjectCode                                AS UnitCode
           , Object_Unit.ValueData                                 AS UserName
           
           , Movement.TotalCount                                   AS TotalCount
           , Movement.TotalSumm                                    AS TotalSumm
           , Movement.CountCheck                                   AS CountCheck
           , Movement.CountFirstOrder                              AS CountFirstOrder
           
        FROM tmpMovement AS Movement 
        
             LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = Movement.UnitId
                          
        ORDER BY Object_Unit.ValueData
        ;

         
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_InfoMobileAppChech (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 14.02.23                                                        * 
*/            

-- 
select * from gpReport_InfoMobileAppChech (('01.02.2023')::TDateTime, '3');
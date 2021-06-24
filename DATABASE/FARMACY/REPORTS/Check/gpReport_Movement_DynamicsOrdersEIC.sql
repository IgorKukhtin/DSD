-- Function: gpReport_Movement_DynamicsOrdersEIC()

DROP FUNCTION IF EXISTS gpReport_Movement_DynamicsOrdersEIC (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_DynamicsOrdersEIC(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , CountNeBoley Integer
             , CountTabletki Integer
             , CountLiki24 Integer
             , CountAll Integer
             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Результат
     RETURN QUERY
       WITH tmpMovement AS (SELECT Movement_Check.Id                                         AS Id
                                 , COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0)  AS CheckSourceKindId
                                 , MovementFloat_TotalCount.ValueData                        AS TotalCount
                                 , MovementFloat_TotalSumm.ValueData                         AS TotalSumm
                            FROM (SELECT Movement.*
                                       , MovementLinkObject_Unit.ObjectId                    AS UnitId
                                       , COALESCE(MovementBoolean_Deferred.ValueData, False) AS IsDeferred
                                  FROM Movement

                                       INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                     ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                    AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                                    AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_Complete()

                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()


                                       LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                 ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                       
                                  WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate) - INTERVAL '5 DAY' 
                                    AND Movement.DescId = zc_Movement_Check()
                                    AND COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                               ) AS Movement_Check

                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                         ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                                        AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

                                 LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                         ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                                        AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                 LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                          ON MovementString_InvNumberOrder.MovementId = Movement_Check.Id
                                                         AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()


                                LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                             ON MovementLinkObject_CheckSourceKind.MovementId =  Movement_Check.Id
                                                            AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                                                            
                                LEFT JOIN MovementDate AS MovementDate_Insert
                                                       ON MovementDate_Insert.MovementId = Movement_Check.Id
                                                      AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                                                            
                                LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId
                            WHERE COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0
                               OR COALESCE (MovementString_InvNumberOrder.ValueData, '') <> ''
                            )
        , tmpMovementProtocol AS (SELECT Movement.Id
                                       , date_trunc('day', MIN(MovementProtocol.OperDate))  AS OperDate
                        FROM tmpMovement AS Movement
                             INNER JOIN MovementProtocol ON Movement.Id = MovementProtocol.MovementId
                        GROUP BY Movement.Id)        
        , tmpMovementDay AS (SELECT tmpMovementProtocol.OperDate
                                  , Movement.CheckSourceKindId
                                  , Count(*)                    AS CountCheck
                                  , Sum(Movement.TotalCount)    AS TotalCount
                                  , Sum(Movement.TotalSumm)     AS TotalSumm
                             FROM tmpMovement AS Movement
                              
                                  INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.Id = Movement.Id
                                  
                             WHERE tmpMovementProtocol.OperDate >= inStartDate
                             GROUP BY tmpMovementProtocol.OperDate, Movement.CheckSourceKindId) 
        , tmpMovementSum AS (SELECT Movement.OperDate
                                  , Sum(Movement.CountCheck)    AS CountCheck
                                  , Sum(Movement.TotalCount)    AS TotalCount
                                  , Sum(Movement.TotalSumm)     AS TotalSumm
                             FROM tmpMovementDay AS Movement
                             GROUP BY Movement.OperDate) 

        SELECT Movement.OperDate::TDateTime
             , MovementNeBoley.CountCheck::Integer       AS CountNeBoley
             , MovementTabletki.CountCheck::Integer      AS CountTabletki
             , MovementLiki24.CountCheck::Integer        AS CountLiki24
             , Movement.CountCheck::Integer              AS CountAll
        FROM tmpMovementSum AS Movement
        
             LEFT JOIN tmpMovementDay AS MovementNeBoley
                                      ON MovementNeBoley.OperDate = Movement.OperDate
                                     AND MovementNeBoley.CheckSourceKindId = 0  
             
             LEFT JOIN tmpMovementDay AS MovementTabletki
                                      ON MovementTabletki.OperDate = Movement.OperDate
                                     AND MovementTabletki.CheckSourceKindId = zc_Enum_CheckSourceKind_Tabletki()  

             LEFT JOIN tmpMovementDay AS MovementLiki24
                                      ON MovementLiki24.OperDate = Movement.OperDate
                                     AND MovementLiki24.CheckSourceKindId = zc_Enum_CheckSourceKind_Liki24() 

        ORDER BY Movement.OperDate
        
        
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.06.21                                                       * 
*/

-- тест

select * FROM gpReport_Movement_DynamicsOrdersEIC(inStartDate := '11.06.2021', inEndDate := CURRENT_DATE - INTERVAL '1 DAY', inSession := '3');
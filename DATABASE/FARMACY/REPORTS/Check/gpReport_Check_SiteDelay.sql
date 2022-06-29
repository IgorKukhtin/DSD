-- Function: gpReport_Check_SiteDelay()

DROP FUNCTION IF EXISTS gpReport_Check_SiteDelay (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_SiteDelay(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , SourceName TVarChar  
             , CountChech TFloat
             , TotalCount TFloat
             , TotalSumm TFloat
             , CountChechDel TFloat
             , TotalCountDel TFloat
             , TotalSummDel TFloat
             , CountChechDelay TFloat
             , TotalCountDelay TFloat
             , TotalSummDelay TFloat
             , CountChechDelayDel TFloat
             , TotalCountDelayDel TFloat
             , TotalSummDelayDel TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;

    RETURN QUERY
        WITH
           tmpMovAll AS (SELECT Movement.*
                         FROM Movement
                              INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                         ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                        AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()
                                                        AND MovementBoolean_Deferred.ValueData  = TRUE
                         WHERE Movement.DescId = zc_Movement_Check()
                           AND Movement.OperDate >= inStartDate
                           AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                      )
         , tmpMov AS (SELECT Movement.*
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                           , COALESCE (MovementBoolean_Delay.ValueData, False) AS isDelay
                           , CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki() THEN 'Таблетки'
                                  WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Liki24() THEN 'Лики 24'
                                  WHEN COALESCE(MovementString_InvNumberOrder.ValueData, '') <> '' THEN 'Не болей'
                                  ELSE 'ВИП чек' END::TVarChar                  AS SourceName
                           , MovementFloat_TotalCount.ValueData                 AS TotalCount
                           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
                      FROM tmpMovAll AS Movement

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                        ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                                       AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                           LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                    ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                   AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                           LEFT JOIN MovementBoolean AS MovementBoolean_Delay
                                                     ON MovementBoolean_Delay.MovementId = Movement.Id
                                                    AND MovementBoolean_Delay.DescId     = zc_MovementBoolean_Delay()

                           LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                   ON MovementFloat_TotalCount.MovementId = Movement.Id
                                                  AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
               
                           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                      WHERE Movement.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
                     )

       -- Результат
       SELECT Object_Unit.Id                       AS UnitId  
            , Object_Unit.ObjectCode               AS UnitCode
            , Object_Unit.ValueData                AS UnitName
            , Movement.SourceName
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() AND Movement.isDelay = False THEN 1 END)::TFloat                      AS CountChech
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() AND Movement.isDelay = False THEN Movement.TotalCount END)::TFloat    AS TotalCount
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() AND Movement.isDelay = False THEN Movement.TotalSumm END)::TFloat     AS TotalSumm
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() AND Movement.isDelay = False THEN 1 END)::TFloat                        AS CountChechDel
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() AND Movement.isDelay = False THEN Movement.TotalCount END)::TFloat      AS TotalCountDel
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() AND Movement.isDelay = False THEN Movement.TotalSumm END)::TFloat       AS TotalSummDel
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() AND Movement.isDelay = True THEN 1 END)::TFloat                       AS CountChechDelay
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() AND Movement.isDelay = True THEN Movement.TotalCount END)::TFloat     AS TotalCountDelay
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() AND Movement.isDelay = True THEN Movement.TotalSumm END)::TFloat      AS TotalSummDelay
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() AND Movement.isDelay = True THEN 1 END)::TFloat                         AS CountChechDelayDel
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() AND Movement.isDelay = True THEN Movement.TotalCount END)::TFloat       AS TotalCountDelayDel
            , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() AND Movement.isDelay = True THEN Movement.TotalSumm END)::TFloat        AS TotalSummDelayDel

       FROM tmpMov AS Movement
       
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
            
       GROUP BY Object_Unit.Id
              , Object_Unit.ObjectCode
              , Object_Unit.ValueData
              , Movement.SourceName
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Check_SiteDelay (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 05.04.19                                                                                   *
*/

-- тест
-- 
SELECT * FROM gpReport_Check_SiteDelay ('01.06.2022', '21.06.2022', 0, '3')
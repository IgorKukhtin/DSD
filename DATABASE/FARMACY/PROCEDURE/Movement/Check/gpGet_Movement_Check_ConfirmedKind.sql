-- Function: gpGet_Movement_Check_ConfirmedKind()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_ConfirmedKind (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_ConfirmedKind(
   OUT outMovementId_list  TVarChar,  -- 
   OUT outIsVIP            Boolean,  -- 
   OUT outIsSite           Boolean,  -- 
   OUT outIsTabletki       Boolean,  -- 
   OUT outIsLiki24         Boolean,  -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);


    vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    vbUnitId  := CASE WHEN vbUnitKey = '' THEN '0' ELSE vbUnitKey END :: Integer;

        -- Результат - ВСЕ документы - с типом "Не подтвержден"
          WITH tmpMov_UnC AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                              FROM Movement
                              WHERE Movement.DescId   =  zc_Movement_Check()
                                AND Movement.StatusId =  zc_Enum_Status_UnComplete()
                                AND Movement.OperDate >= CURRENT_DATE - INTERVAL '100 DAY'
                             )
             , tmpMov_all AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , MovementLinkObject_Unit.ObjectId AS UnitId
                              FROM tmpMov_UnC AS Movement
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                                AND MovementLinkObject_Unit.ObjectId   = vbUnitId

                                   LEFT JOIN MovementBoolean AS MovementBoolean_AutoVIPforSales
                                                             ON MovementBoolean_AutoVIPforSales.MovementId = Movement.Id
                                                            AND MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales()
                                                            
                              WHERE COALESCE(MovementBoolean_AutoVIPforSales.ValueData, False) = False
                             )
             , tmpMLO_ConfirmedKind AS (SELECT MLO_ConfirmedKind.*
                                        FROM MovementLinkObject AS MLO_ConfirmedKind
                                        WHERE MLO_ConfirmedKind.MovementId IN (SELECT DISTINCT tmpMov_all.Id FROM tmpMov_all)
                                          AND MLO_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()
                                       )
             , tmpMov AS (SELECT Movement.Id
                               , Movement.InvNumber
                               , Movement.OperDate
                               , Movement.UnitId
                          FROM tmpMov_all AS Movement
                               INNER JOIN tmpMLO_ConfirmedKind AS MovementLinkObject_ConfirmedKind
                                                               ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                              AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_UnComplete()
                          -- ORDER BY Movement.Id DESC
                         )
             , tmpMI_all AS (SELECT tmpMov.Id AS MovementId, tmpMov.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                             FROM tmpMov
                                  INNER JOIN MovementItem
                                          ON MovementItem.MovementId = tmpMov.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                             GROUP BY tmpMov.Id, tmpMov.UnitId, MovementItem.ObjectId
                             )
             , tmpMI AS (SELECT tmpMI_all.MovementId, tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                         FROM tmpMI_all
                         GROUP BY tmpMI_all.MovementId, tmpMI_all.UnitId, tmpMI_all.GoodsId
                        )
             , tmpMov_Complete AS (SELECT Movement.Id
                                        , Movement.InvNumber
                                        , Movement.OperDate
                                        , Movement.UnitId
                                   FROM tmpMov_all AS Movement
                                        INNER JOIN tmpMLO_ConfirmedKind AS MovementLinkObject_ConfirmedKind
                                                                        ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                       AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_Complete()
                                  )
             , tmpComplete AS (SELECT tmpMov_Complete.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                               FROM tmpMov_Complete
                                    INNER JOIN MovementItem
                                            ON MovementItem.MovementId = tmpMov_Complete.Id
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = FALSE
                               GROUP BY tmpMov_Complete.UnitId, MovementItem.ObjectId
                              )
             , tmpRemains AS (SELECT tmpMI.MovementId
                                   , tmpMI.GoodsId
                                   , tmpMI.UnitId
                                   , tmpMI.Amount           AS Amount_mi
                                   , (COALESCE (SUM (Container.Amount), 0) - COALESCE (MAX (tmpComplete.Amount), 0)) AS Amount_remains
                              FROM tmpMI
                                   LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                      AND Container.ObjectId = tmpMI.GoodsId
                                                      AND Container.WhereObjectId = tmpMI.UnitId
                                                      AND Container.Amount <> 0
                                   LEFT JOIN tmpComplete ON tmpComplete.GoodsId = tmpMI.GoodsId
                                                        AND tmpComplete.UnitId = tmpMI.UnitId
                              GROUP BY tmpMI.MovementId
                                     , tmpMI.GoodsId
                                     , tmpMI.UnitId
                                     , tmpMI.Amount
                              HAVING (COALESCE (SUM (Container.Amount), 0) - COALESCE (MAX (tmpComplete.Amount), 0)) < tmpMI.Amount
                             )
             , tmpErr AS (SELECT DISTINCT tmpMov.Id AS MovementId
                          FROM tmpMov
                               INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMov.Id
                               INNER JOIN tmpRemains ON tmpRemains.MovementId = tmpMI_all.MovementId
                                                    AND tmpRemains.GoodsId    = tmpMI_all.GoodsId
                                                    AND tmpRemains.UnitId     = tmpMI_all.UnitId
                         )
             , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject
                                          WHERE MovementLinkObject.MovementId in (select tmpMov.ID from tmpMov))
                                            
    SELECT STRING_AGG (COALESCE (Movement.Id :: TVarChar, ''), ';') AS RetV
         , SUM(CASE WHEN COALESCE (ObjectBoolean_CheckSourceKind_Site.ValueData, FALSE) = FALSE
                         OR COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) 
                            NOT IN (zc_Enum_CheckSourceKind_Liki24(), zc_Enum_CheckSourceKind_Tabletki()) THEN 1 ELSE 0 END) > 0 
         , SUM(CASE WHEN COALESCE (ObjectBoolean_CheckSourceKind_Site.ValueData, FALSE) = TRUE THEN 1 ELSE 0 END) > 0 
         , SUM(CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki() THEN 1 ELSE 0 END) > 0 
         , SUM(CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Liki24() THEN 1 ELSE 0 END) > 0 
    INTO outMovementId_list, outIsVIP, outIsSite, outIsTabletki, outIsLiki24
    FROM tmpMov AS Movement
         LEFT JOIN tmpErr ON tmpErr.MovementId = Movement.Id

         LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckSourceKind
                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_CheckSourceKind_Site
                                 ON ObjectBoolean_CheckSourceKind_Site.ObjectId = MovementLinkObject_CheckSourceKind.ObjectId
                                AND ObjectBoolean_CheckSourceKind_Site.DescId = zc_ObjectBoolean_CheckSourceKind_Site()
    WHERE tmpErr.MovementId IS NULL;
    
    outMovementId_list := COALESCE (outMovementId_list, '');
    outIsVIP := COALESCE (outIsVIP, False); 
    outIsSite := COALESCE (outIsSite, False);
    outIsTabletki := COALESCE (outIsTabletki, False);
    outIsLiki24 := COALESCE (outIsLiki24, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 20.10.18                                                                     *
 31.08.18                                                                     *
 18.08.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Check_ConfirmedKind (inSession:= zfCalc_UserAdmin())
select * from gpGet_Movement_Check_ConfirmedKind( inSession := '3');
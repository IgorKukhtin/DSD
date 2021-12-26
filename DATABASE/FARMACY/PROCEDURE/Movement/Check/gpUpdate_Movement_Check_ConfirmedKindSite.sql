-- Function: gpUpdate_Movement_Check_ConfirmedKindSite()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ConfirmedKindSite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ConfirmedKindSite(
    IN inMovementId        Integer  ,  --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbConfirmedKindId Integer;
   DECLARE vbSourceKindId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    SELECT Movement.StatusId
         , COALESCE (MovementLinkObject_ConfirmedKind.ObjectId, zc_Enum_ConfirmedKind_UnComplete())
         , COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0)
    INTO vbStatusId, vbConfirmedKindId, vbSourceKindId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                      ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                     AND MovementLinkObject_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                      ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                     AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

    WHERE Movement.ID = inMovementId;


    IF vbConfirmedKindId <> zc_Enum_ConfirmedKind_UnComplete()
       OR vbStatusId <> zc_Enum_Status_UnComplete()
       OR vbSourceKindId NOT IN (zc_Enum_CheckSourceKind_Liki24(), zc_Enum_CheckSourceKind_Tabletki())
    THEN
      raise notice 'Пропустили %', timeofday();
      RETURN;
    END IF;

    IF EXISTS (SELECT 1 FROM MovementBoolean AS MovementBoolean_AutoVIPforSales
               WHERE MovementBoolean_AutoVIPforSales.MovementId = inMovementId
                 AND MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales()
                 AND MovementBoolean_AutoVIPforSales.ValueData = TRUE)
    THEN
      raise notice 'Пропустили %', 'Изменять статус ВИП чек для резерва под продажи запрещено.';    
      RETURN;
    END IF;

      -- подправили количество в пределах 0.05 длч таблеток
    IF vbSourceKindId = zc_Enum_CheckSourceKind_Tabletki()
    THEN

      PERFORM gpUpdate_MovementItem_Check_AmountAdmin(inId           := T1.MovementItemId
                                                    , inMovementId   := T1.MovementId
                                                    , inAmount       := (T1.Amount - T1.Delta) :: TFloat
                                                    , inSession      := inSession)
      FROM (WITH tmpMov_UnC AS (SELECT Movement.Id
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
                                     , COALESCE (MovementLinkObject_ConfirmedKind.ObjectID, zc_Enum_ConfirmedKind_UnComplete()) AS ConfirmedKindID
                                     , COALESCE(MovementBoolean_Deferred.ValueData, FALSE)   AS isDeferred
                                FROM tmpMov_UnC AS Movement

                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()

                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                  ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

                                     LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                               ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                              AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()

                                     LEFT JOIN MovementString AS MovementString_CommentError
                                                              ON MovementString_CommentError.MovementId = Movement.Id
                                                             AND MovementString_CommentError.DescId     = zc_MovementString_CommentError()

                                WHERE COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                                   OR MovementString_CommentError.ValueData <> ''
                               )
               , tmpMov AS (SELECT Movement.Id
                                 , Movement.InvNumber
                                 , Movement.OperDate
                                 , Movement.UnitId
                            FROM tmpMov_all AS Movement
                            WHERE Movement.Id = inMovementId
                           )
               , tmpMI_all AS (SELECT tmpMov.UnitId
                                    , tmpMov.Id              AS MovementId
                                    , MovementItem.ID        AS MovementItemId
                                    , MovementItem.ObjectId  AS GoodsId
                                    , MovementItem.Amount    AS Amount
                               FROM tmpMov
                                    INNER JOIN MovementItem
                                            ON MovementItem.MovementId = tmpMov.Id
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = FALSE
                                           AND MovementItem.Amount     > 0.1
                               )
               , tmpMI AS (SELECT tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                           FROM tmpMI_all
                           GROUP BY tmpMI_all.UnitId, tmpMI_all.GoodsId
                          )
               , tmpMov_Res AS (SELECT Movement.Id
                                     , Movement.InvNumber
                                     , Movement.OperDate
                                     , Movement.UnitId
                                FROM tmpMov_all AS Movement

                                WHERE Movement.ConfirmedKindID = zc_Enum_ConfirmedKind_Complete()
                                   OR Movement.isDeferred = False
                               )
               , tmpMI_Res AS (SELECT Movement.UnitId
                                    , MovementItem.ObjectId       AS GoodsId
                                    , Sum(MovementItem.Amount)    AS Amount
                               FROM tmpMov_Res AS Movement
                                    INNER JOIN MovementItem
                                            ON MovementItem.MovementId = Movement.Id
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = FALSE
                               GROUP BY Movement.UnitId, MovementItem.ObjectId
                               )
               , tmpRemains AS (SELECT tmpMI.GoodsId
                                     , tmpMI.UnitId
                                     , COALESCE (SUM (Container.Amount), 0) AS Amount
                                FROM tmpMI
                                     LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                        AND Container.ObjectId = tmpMI.GoodsId
                                                        AND Container.WhereObjectId = tmpMI.UnitId
                                                        AND Container.Amount <> 0
                                GROUP BY tmpMI.GoodsId
                                       , tmpMI.UnitId
                                       , tmpMI.Amount
                              )

       SELECT tmpMI_all.MovementId
            , tmpMI_all.MovementItemId
            , tmpMI_all.GoodsId
            , tmpMI_all.Amount
            , (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0)) AS Remains
            , (tmpMI_all.Amount - (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0))) AS Delta
       FROM tmpMI_all

            LEFT JOIN tmpRemains ON tmpRemains.UnitId = tmpMI_all.UnitId
                                AND tmpRemains.GoodsId = tmpMI_all.GoodsId

            LEFT JOIN tmpMI_Res ON tmpMI_Res.UnitId = tmpMI_all.UnitId
                               AND tmpMI_Res.GoodsId = tmpMI_all.GoodsId

       WHERE tmpMI_all.MovementId = inMovementId
         AND (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0)) > 0
         AND tmpMI_all.Amount > (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0))
         AND (tmpMI_all.Amount - (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0))) <= 0.05) AS T1;
    END IF;


    -- проверим что есть остатки
    IF EXISTS(WITH tmpMov_UnC AS (SELECT Movement.Id
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
                                       , COALESCE (MovementLinkObject_ConfirmedKind.ObjectID, zc_Enum_ConfirmedKind_UnComplete()) AS ConfirmedKindID
                                       , COALESCE(MovementBoolean_Deferred.ValueData, FALSE)   AS isDeferred
                                  FROM tmpMov_UnC AS Movement

                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()

                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                    ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                   AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

                                       LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                 ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()

                                       LEFT JOIN MovementString AS MovementString_CommentError
                                                                ON MovementString_CommentError.MovementId = Movement.Id
                                                               AND MovementString_CommentError.DescId     = zc_MovementString_CommentError()

                                  WHERE COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                                     OR MovementString_CommentError.ValueData <> ''
                                 )
                 , tmpMov AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , Movement.UnitId
                              FROM tmpMov_all AS Movement
                              WHERE Movement.Id = inMovementId
                             )
                 , tmpMI_all AS (SELECT tmpMov.UnitId
                                      , tmpMov.Id              AS MovementId
                                      , MovementItem.ID        AS MovementItemId
                                      , MovementItem.ObjectId  AS GoodsId
                                      , MovementItem.Amount    AS Amount
                                 FROM tmpMov
                                      INNER JOIN MovementItem
                                              ON MovementItem.MovementId = tmpMov.Id
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = FALSE
                                 )
                 , tmpMI AS (SELECT tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                             FROM tmpMI_all
                             GROUP BY tmpMI_all.UnitId, tmpMI_all.GoodsId
                            )
                 , tmpMov_Res AS (SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.OperDate
                                       , Movement.UnitId
                                  FROM tmpMov_all AS Movement

                                  WHERE Movement.ConfirmedKindID = zc_Enum_ConfirmedKind_Complete()
                                     OR Movement.isDeferred = False
                                 )
                 , tmpMI_Res AS (SELECT Movement.UnitId
                                      , MovementItem.ObjectId       AS GoodsId
                                      , Sum(MovementItem.Amount)    AS Amount
                                 FROM tmpMov_Res AS Movement
                                      INNER JOIN MovementItem
                                              ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = FALSE
                                 GROUP BY Movement.UnitId, MovementItem.ObjectId
                                 )
                 , tmpRemains AS (SELECT tmpMI.GoodsId
                                       , tmpMI.UnitId
                                       , COALESCE (SUM (Container.Amount), 0) AS Amount
                                  FROM tmpMI
                                       LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                          AND Container.ObjectId = tmpMI.GoodsId
                                                          AND Container.WhereObjectId = tmpMI.UnitId
                                                          AND Container.Amount <> 0
                                  GROUP BY tmpMI.GoodsId
                                         , tmpMI.UnitId
                                         , tmpMI.Amount
                                )

         SELECT 1
         FROM tmpMI_all

              LEFT JOIN tmpRemains ON tmpRemains.UnitId = tmpMI_all.UnitId
                                  AND tmpRemains.GoodsId = tmpMI_all.GoodsId

              LEFT JOIN tmpMI_Res ON tmpMI_Res.UnitId = tmpMI_all.UnitId
                                 AND tmpMI_Res.GoodsId = tmpMI_all.GoodsId

         WHERE tmpMI_all.MovementId = inMovementId
           AND tmpMI_all.Amount > (COALESCE(tmpRemains.Amount, 0) - COALESCE(tmpMI_Res.Amount, 0)))
    THEN

      -- Удалили чек
      IF vbSourceKindId = zc_Enum_CheckSourceKind_Tabletki()
      THEN
        PERFORM gpSetErased_Movement_CheckVIP (inMovementId, 15016705, inSession);
      ELSE
        PERFORM gpSetErased_Movement_Check (inMovementId, inSession);
      END IF;
      
/*    ELSE
      -- сохранили связь
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), inMovementId, zc_Enum_ConfirmedKind_Complete());

      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inMovementId, CURRENT_TIMESTAMP);

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE); */
    END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_Movement_Check_ConfirmedKindSite (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.12.20                                                       *

*/

-- SELECT * FROM gpUpdate_Movement_Check_ConfirmedKindSite (inMovementId := 21388345  , inSession := zfCalc_UserAdmin());
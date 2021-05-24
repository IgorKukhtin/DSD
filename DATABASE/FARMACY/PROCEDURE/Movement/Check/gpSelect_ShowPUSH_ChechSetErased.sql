-- Function: gpSelect_ShowPUSH_ChechSetErased(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_ChechSetErased(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_ChechSetErased(
    IN inMovementID   integer,          -- ID инвентаризации
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbText  Text;
   DECLARE vbAmount_mi TFloat;
   DECLARE vbAmount_remains TFloat;
BEGIN

  outShowMessage := False;
  vbText := '';

  IF COALESCE (inMovementID, 0) = 0 /*OR inSession <> '3'*/
  THEN
    RETURN;
  END IF;

  IF NOT EXISTS(SELECT * FROM MovementString AS MovementString_InvNumberOrder
                WHERE MovementString_InvNumberOrder.MovementId = inMovementID
                  AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                  AND MovementString_InvNumberOrder.ValueData <> '')
  THEN
    RETURN;
  END IF;
  
  
  IF EXISTS(SELECT * FROM MovementLinkObject AS MovementLinkObject_ConfirmedKind
            WHERE MovementLinkObject_ConfirmedKind.MovementId = inMovementID
              AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
              AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_Complete())
  THEN
    outShowMessage := True;
    outPUSHType := 2;

    IF EXISTS(SELECT * FROM MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
              WHERE MovementLinkObject_ConfirmedKindClient.MovementId = inMovementID
                AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
                AND MovementLinkObject_ConfirmedKindClient.ObjectId = zc_Enum_ConfirmedKind_SmsYes())
    THEN
      outText := 'Товар подтвержден и клиент получил СМС уведомление.'||CHR(13)||CHR(13)||' Удаление чека запрещено.';    
    ELSE
      outText := 'Товар подтвержден.'||CHR(13)||CHR(13)||' Удаление чека запрещено.';    
    END IF;

    RETURN;

/*    outPUSHType := 4;

    IF EXISTS(SELECT * FROM MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
              WHERE MovementLinkObject_ConfirmedKindClient.MovementId = inMovementID
                AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
                AND MovementLinkObject_ConfirmedKindClient.ObjectId = zc_Enum_ConfirmedKind_SmsYes())
    THEN
      outText := 'Товар подтвержден и клиент получил СМС уведомление.'||CHR(13)||CHR(13)||' Удалить чек?';    
    ELSE
      outText := 'Товар подтвержден.'||CHR(13)||CHR(13)||' Удалить чек?';    
    END IF;

    RETURN;*/
  END IF;
  
  
  CREATE TEMP TABLE tmpMov ON COMMIT DROP AS (
       WITH
            tmpMovementCheck AS (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_Check()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete())
          , tmpMovReserveId AS (
                             SELECT Movement.Id
                                  , COALESCE(MovementBoolean_Deferred.ValueData, FALSE) AS  isDeferred
                                  ,  MovementString_CommentError.ValueData              AS  CommentError
                             FROM tmpMovementCheck AS Movement
                                  LEFT JOIN MovementBoolean AS MovementBoolean_Deferred ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                            AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                  LEFT JOIN MovementString AS MovementString_CommentError ON Movement.Id     = MovementString_CommentError.MovementId
                                                          AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                                          AND MovementString_CommentError.ValueData <> ''                             )

          , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject
                                      WHERE MovementLinkObject.MovementId in (select tmpMovReserveId.ID from tmpMovReserveId))

          , tmpMov AS (
                             SELECT Movement.Id
                                  , Movement.isDeferred
                                  , MovementLinkObject_Unit.ObjectId            AS UnitId
                                  , MovementLinkObject_ConfirmedKind.ObjectId   AS ConfirmedKindId
                                  , Movement.CommentError
                             FROM tmpMovReserveId AS Movement
                                  INNER JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                  AND MovementLinkObject_Unit.ObjectId = (SELECT MovementLinkObject_Unit.ObjectId 
                                                                                                          FROM MovementLinkObject AS MovementLinkObject_Unit
                                                                                                          WHERE MovementLinkObject_Unit.MovementId = inMovementID
                                                                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit())
                                  LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                  ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                             WHERE isDeferred = TRUE OR COALESCE(CommentError, '') <> '')

        SELECT Movement.Id
             , Movement.isDeferred
             , Movement.UnitId
             , Movement.ConfirmedKindId
             , Movement.CommentError
             , MovementLinkObject_CheckSourceKind.ObjectId AS CheckSourceKindID
             , COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) 
               NOT IN (zc_Enum_CheckSourceKind_Liki24(), zc_Enum_CheckSourceKind_Tabletki())                  AS isShowVIP
             , COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Liki24()   AS isShowLiki24
             , COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki() AS isShowTabletki
        FROM tmpMov AS Movement
            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckSourceKind
                                            ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                           AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
        );

  WITH
      tmpMI_all AS (SELECT tmpMov.Id AS MovementId, tmpMov.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
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
    , tmpMIConfirmedKind AS (SELECT tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                             FROM tmpMI_all
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                ON MovementLinkObject_ConfirmedKind.MovementId = tmpMI_all.MovementId
                                                               AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                               AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_Complete() 
                             GROUP BY tmpMI_all.UnitId, tmpMI_all.GoodsId
                            )
    , tmpRemains AS (SELECT tmpMI.MovementId
                          , tmpMI.GoodsId
                          , tmpMI.UnitId
                          , tmpMI.Amount           AS Amount_mi
                          , CASE WHEN COALESCE (SUM (Container.Amount), 0) - COALESCE (Max (tmpMIConfirmedKind.Amount), 0) > 0
                                 THEN COALESCE (SUM (Container.Amount), 0) - COALESCE (Max (tmpMIConfirmedKind.Amount), 0)
                                 ELSE 0 END                                                                                      AS Amount_remains
                     FROM tmpMI
                          LEFT JOIN tmpMIConfirmedKind ON tmpMIConfirmedKind.GoodsId = tmpMI.GoodsId
                                                      AND tmpMIConfirmedKind.UnitId = tmpMI.UnitId
                          LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                             AND Container.ObjectId = tmpMI.GoodsId
                                             AND Container.WhereObjectId = tmpMI.UnitId
                                             AND Container.Amount <> 0
                     WHERE tmpMI.MovementId = inMovementID
                     GROUP BY tmpMI.MovementId
                            , tmpMI.GoodsId
                            , tmpMI.UnitId
                            , tmpMI.Amount
                    )
                    
  SELECT COALESCE(sum(tmpRemains.Amount_mi), 0)
       , COALESCE(sum(CASE WHEN tmpRemains.Amount_remains > tmpRemains.Amount_mi THEN tmpRemains.Amount_mi ELSE tmpRemains.Amount_remains END), 0)
  INTO vbAmount_mi, vbAmount_remains
  FROM tmpRemains;
  

  --RAISE EXCEPTION 'Ошибка. <%> <%> <%>', (SELECT Count(*) FROM tmpMov), vbAmount_mi, vbAmount_remains;
  
  IF vbAmount_mi > 0 AND vbAmount_mi = vbAmount_remains
  THEN
--    vbText := 'По заказу есть наличие по всему товару'||CHR(13)||CHR(13)||' Удалить полностью чек?';
    vbText := 'По заказу есть наличие по всему товару'||CHR(13)||CHR(13)||' Удаление чека запрещено.';
  ELSEIF vbAmount_remains > 0
  THEN
--    vbText := 'По заказу есть наличие на часть товара. Можно удалить только некоторые позиции, а не весь заказ. '||CHR(13)||CHR(13)||' Удалить полностью чек?';  
    vbText := 'По заказу есть наличие на часть товара. Можно удалить только некоторые позиции, а не весь заказ. '||CHR(13)||CHR(13)||' Удаление чека запрещено.';  
  END IF;

  IF COALESCE(vbText, '') <> ''
  THEN
    outShowMessage := True;
    outPUSHType := 2;
--    outPUSHType := 4;
    outText := vbText;
  END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.05.21                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_ChechSetErased(23344851   , '3')
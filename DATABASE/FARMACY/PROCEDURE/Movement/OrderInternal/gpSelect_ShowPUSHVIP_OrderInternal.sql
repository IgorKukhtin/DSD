-- Function: gpSelect_ShowPUSHVIP_OrderInternal(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSHVIP_OrderInternal(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSHVIP_OrderInternal(
    IN inMovementID   integer,          -- Документ
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStatusId  Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbCount     Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := False;

     -- ПАРАМЕТРЫ
    SELECT Movement.StatusId, MovementLinkObject_Unit.ObjectId
    INTO vbStatusId, vbUnitId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;


    IF vbStatusId <> zc_Enum_Status_Complete() AND
       inSession in (zfCalc_UserAdmin(), '3004360', '4183126', '3171185', 
                                         '8688630', '7670317', '11262719',
                                         '10642587', '10362758', '10642315',
                                         '8539679', '7670307', '9909730')
    THEN

      WITH
           tmpMovementChek AS (SELECT Movement.Id
                               FROM MovementBoolean AS MovementBoolean_Deferred
                                    INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                       AND Movement.DescId = zc_Movement_Check()
                                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                 AND MovementLinkObject_Unit.ObjectId = vbUnitId
                               WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                 AND MovementBoolean_Deferred.ValueData = TRUE
                              UNION
                               SELECT Movement.Id
                               FROM MovementString AS MovementString_CommentError
                                    INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                       AND Movement.DescId = zc_Movement_Check()
                                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                 AND MovementLinkObject_Unit.ObjectId = vbUnitId
                              WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                AND MovementString_CommentError.ValueData <> ''
                              )
         , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                               , SUM (MovementItem.Amount)::TFloat AS Amount
                          FROM tmpMovementChek
                               INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId
                          )
         , MovementItemOrder AS (SELECT MovementItem.ObjectId AS GoodsId
                                 FROM MovementItem
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                )
      SELECT count(*)
      INTO vbCount
      FROM MovementItemOrder
           INNER JOIN tmpReserve ON tmpReserve.GoodsId = MovementItemOrder.GoodsId;

      IF vbCount > 0 
      THEN
        outShowMessage := True;
        outPUSHType := 3;
        outText := 'Коллеги, обратите внимание, в данном заказе есть значения по отложенным чекам!';
      END IF;
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.02.20                                                       *

*/

--
SELECT * FROM gpSelect_ShowPUSHVIP_OrderInternal(17572772  , '3')

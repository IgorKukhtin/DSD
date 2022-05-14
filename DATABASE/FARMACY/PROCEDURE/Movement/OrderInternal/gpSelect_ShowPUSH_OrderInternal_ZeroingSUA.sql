-- Function: gpSelect_ShowPUSH_OrderInternal_ZeroingSUA(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_OrderInternal_ZeroingSUA(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_OrderInternal_ZeroingSUA(
    IN inMovementId   integer,          -- Подразделение
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbName  TVarChar;
   DECLARE vbStatusId  Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbJuridical Integer;
BEGIN

    outShowMessage := False;

     -- ПАРАМЕТРЫ
    SELECT Movement.StatusId, MovementLinkObject_Unit.ObjectId
    INTO vbStatusId, vbUnitId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;
    
    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
      RETURN;
    END IF;
    
    IF inSession in (zfCalc_UserAdmin(), '3004360', '4183126', '3171185', 
                                         '8688630', '7670317', '11262719',
                                         '10642587', '10362758', '10642315',
                                         '8539679', '7670307', '9909730')
        AND EXISTS(SELECT Movement.ID
                        , Movement.InvNumber
                        , Movement.StatusId
                        , Movement.OperDate
                   FROM Movement
                        INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                ON MovementBoolean_SUN.MovementId = Movement.Id
                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                               AND MovementBoolean_SUN.ValueData = TRUE
                        INNER JOIN MovementDate AS MovementDate_Insert
                                                ON MovementDate_Insert.MovementId = Movement.Id
                                               AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                        INNER JOIN MovementString AS MovementString_Comment
                                                  ON MovementString_Comment.MovementId = Movement.Id
                                                 AND MovementString_Comment.DescId = zc_MovementString_Comment()                                                   
                   WHERE MovementDate_Insert.ValueData BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE
                     AND Movement.DescId = zc_Movement_Send()
                     AND MovementString_Comment.ValueData = 'Товар по СУА')
    THEN

      IF EXISTS(WITH tmpMovement AS (SELECT Movement.ID
                                          , Movement.InvNumber
                                          , Movement.StatusId
                                          , Movement.OperDate
                                     FROM Movement
                                          INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                 AND MovementBoolean_SUN.ValueData = TRUE
                                          INNER JOIN MovementDate AS MovementDate_Insert
                                                                  ON MovementDate_Insert.MovementId = Movement.Id
                                                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                                          INNER JOIN MovementString AS MovementString_Comment
                                                                    ON MovementString_Comment.MovementId = Movement.Id
                                                                   AND MovementString_Comment.DescId = zc_MovementString_Comment()                                                   
                                     WHERE MovementDate_Insert.ValueData BETWEEN CURRENT_DATE - ((date_part('isodow', CURRENT_DATE) - 1)||' day')::INTERVAL AND CURRENT_DATE
                                       AND Movement.DescId = zc_Movement_Send()
                                       AND MovementString_Comment.ValueData = 'Товар по СУА')
                   , tmpMI AS (SELECT Movement.ID                                                                    AS ID
                                    , Movement.InvNumber
                                    , Movement.OperDate
                                    , MovementLinkObject_To.ObjectId                                                 AS UnitId
                                    , MILinkObject_CommentSend.ObjectId                                              AS CommentSendID
                                    , MovementItem.ObjectId                                                          AS GoodsID
                                    , MovementItem.Id                                                                AS MovementItemId
                                    , MovementItem.Amount                                                            AS Amount
                                    , COALESCE(MIFloat_PriceFrom.ValueData,0)                                        AS Price
                               FROM tmpMovement AS Movement
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                    LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE

                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                                     ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

                                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                                      ON MIFloat_PriceFrom.MovementItemId = MovementItem.ID
                                                                     AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                               WHERE COALESCE (MovementLinkObject_To.ObjectId , 0) = vbUnitId
                                 AND COALESCE (MILinkObject_CommentSend.ObjectId , 0) <> 0
                               )
                   , tmpProtocolAll AS (SELECT MovementItem.MovementItemId
                                             , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                             , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                                        FROM tmpMI AS MovementItem

                                             INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                                            AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                        )
                   , tmpProtocol AS (SELECT tmpProtocolAll.MovementItemId
                                          , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                                     FROM tmpProtocolAll
                                     WHERE tmpProtocolAll.Ord = 1)
                   , tmpZeroingSUA AS (SELECT tmpMI.UnitID
                                            , tmpMI.GoodsID
                                            , SUM(COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) - tmpMI.Amount)::TFloat           AS Amount
                                            , ROUND(SUM(ROUND(tmpMI.Price * (COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) -
                                                                       tmpMI.Amount), 2))/ 
                                                    SUM(COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) - tmpMI.Amount), 2)::TFloat AS Price
                                            , SUM(ROUND(tmpMI.Price * (COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) -
                                                                       tmpMI.Amount), 2))::TFloat                                   AS Summa
                                       FROM tmpMI
                                            LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.MovementItemId
                                       WHERE (COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) - tmpMI.Amount) > 0
                                       GROUP BY tmpMI.UnitID, tmpMI.GoodsID) 
                   SELECT 1
                   FROM tmpZeroingSUA)
      THEN
        outShowMessage := True;
        outPUSHType := 3;
        outText := 'По подразделению есть зануленные в перемещениях позиции по СУА загрузите их в заказ.';
       END IF;
     END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.08.21                                                       *

*/

-- select * from gpSelect_ShowPUSH_OrderInternal_ZeroingSUA(inMovementId := 24652564 ,  inSession := '3');

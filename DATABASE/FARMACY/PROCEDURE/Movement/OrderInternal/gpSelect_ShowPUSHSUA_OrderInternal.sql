-- Function: gpSelect_ShowPUSHSUA_OrderInternal(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSHSUA_OrderInternal(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSHSUA_OrderInternal(
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
   DECLARE vbOperDate  TDateTime;
   DECLARE vbCount     Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := False;

     -- ПАРАМЕТРЫ
    SELECT Movement.StatusId, MovementLinkObject_Unit.ObjectId, Movement.OperDate
    INTO vbStatusId, vbUnitId, vbOperDate
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;


/*    IF vbStatusId <> zc_Enum_Status_Complete() AND
       inSession in (zfCalc_UserAdmin(), '3004360', '4183126', '3171185', 
                                         '8688630', '7670317', '11262719',
                                         '10642587', '10362758', '10642315',
                                         '8539679', '7670307', '9909730')
    THEN
*/

    IF vbStatusId <> zc_Enum_Status_Complete() AND
       EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
    THEN
      WITH    
          -- документ финальный СУН
          tmpFinalSUA AS (SELECT Movement.id
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_Calculation
                                                      ON MovementDate_Calculation.MovementId = Movement.Id
                                                     AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()
                          LEFT JOIN MovementDate AS MovementDate_DateOrder
                                                 ON MovementDate_DateOrder.MovementId = Movement.Id
                                                AND MovementDate_DateOrder.DescId = zc_MovementDate_Order()

                          LEFT JOIN MovementBoolean AS MovementBoolean_OnlyOrder
                                                    ON MovementBoolean_OnlyOrder.MovementId = Movement.Id
                                                   AND MovementBoolean_OnlyOrder.DescId = zc_MovementBoolean_OnlyOrder()

                     WHERE Movement.OperDate = vbOperDate - ((date_part('DOW', vbOperDate)::Integer - 1)::TVarChar||' DAY')::INTERVAL
                       AND Movement.DescId = zc_Movement_FinalSUA()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND (COALESCE (MovementBoolean_OnlyOrder.ValueData, FALSE) = TRUE OR MovementDate_Calculation.ValueData IS NOT NULL) 
                       AND COALESCE(MovementDate_DateOrder.ValueData, MovementDate_Calculation.ValueData) = vbOperDate
                         )
         , MI_Master AS (SELECT MovementItem.ObjectId                   AS GoodsId
                              , SUM(MovementItem.Amount)                AS Amount
                              , SUM(MIFloat_SendSUN.ValueData)          AS SendSUN
                         FROM MovementItem

                             INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                               ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                              AND MILinkObject_Unit.ObjectId = vbUnitId

                             LEFT JOIN MovementItemFloat AS MIFloat_SendSUN
                                                         ON MIFloat_SendSUN.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SendSUN.DescId = zc_MIFloat_SendSUN()

                         WHERE MovementItem.MovementId in (SELECT tmpFinalSUA.Id FROM tmpFinalSUA)
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = False
                           AND MovementItem.Amount > 0
                          GROUP BY MovementItem.ObjectId 
                         )
         , tmpContainer AS (SELECT MI_Master.GoodsId                  AS GoodsId
                                 , Sum(Container.Amount)::TFloat      AS Amount
                            FROM MI_Master
                                      
                                 INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                     AND Container.ObjectId = MI_Master.GoodsId
                                                     AND Container.WhereObjectId = vbUnitId
                                                     AND Container.Amount <> 0
                                                             
                            GROUP BY MI_Master.GoodsId
                            )
         , tmpObject_Price AS (
                SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                             AND ObjectFloat_Goods_Price.ValueData > 0
                            THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                            ELSE ROUND (Price_Value.ValueData, 2)
                       END :: TFloat                           AS Price
                     , MCS_Value.ValueData                     AS MCSValue
                     , COALESCE (ObjectBoolean_Price_MCSIsClose.ValueData, False) AS MCSIsClose
                     , Price_Goods.ChildObjectId               AS GoodsId
                     , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Price_Unit
                   LEFT JOIN ObjectLink AS Price_Goods
                                        ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                       AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                   LEFT JOIN ObjectFloat AS Price_Value
                                         ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                   LEFT JOIN ObjectFloat AS MCS_Value
                                         ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Price_MCSIsClose
                                           ON ObjectBoolean_Price_MCSIsClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                          AND ObjectBoolean_Price_MCSIsClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                   -- Фикс цена для всей Сети
                   LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                          ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                         AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                           ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                          AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                  AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                )
                                 
          -- строки финальный СУН
        SELECT SUM(CEIL(MI_Master.Amount - COALESCE (MI_Master.SendSUN, 0) - COALESCE (Container.Amount, 0)))  AS Amount
        INTO vbCount
        FROM MI_Master
                
             LEFT JOIN tmpContainer AS Container
                                    ON Container.GoodsId = MI_Master.GoodsId
                                           
             LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = MI_Master.GoodsId
                     
        WHERE CEIL(MI_Master.Amount - COALESCE (MI_Master.SendSUN, 0) - COALESCE (Container.Amount, 0)) > 0
          AND COALESCE(tmpObject_Price.MCSIsClose, FALSE) = False
        ;

      IF vbCount > 0 
      THEN
        outShowMessage := True;
        outPUSHType := 3;
        outText := 'Коллеги, обратите внимание, по точке были сформированы перемещения СУА. При формировании заказа не забудьте "Заполнить данные по Итоговому СУА"!';
      END IF;
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.03.21                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSHSUA_OrderInternal(22634874  , '3')
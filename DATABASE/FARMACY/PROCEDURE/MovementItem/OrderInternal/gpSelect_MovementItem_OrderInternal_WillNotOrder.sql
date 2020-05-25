-- Function: gpSelect_MovementItem_OrderInternal_WillNotOrder()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal_WillNotOrder (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal_WillNotOrder(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                    Integer
             , GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName             TVarChar

             , RemainsInUnit         TFloat
             , RemainsSUN            TFloat
             , MCS                   TFloat

             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    IF inSession <> '3' AND COALESCE(vbUnitId, 0) <> 377605 
    THEN
      Return;
    END IF;

     RETURN QUERY
     WITH
        tmpMovement AS (SELECT Movement.id
                        FROM Movement
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        WHERE Movement.OperDate = CURRENT_DATE
                          AND MovementLinkObject_Unit.ObjectId = vbUnitId
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                        )

      , tmpMI AS (SELECT MovementItem.Id                                AS Id
                       , MovementItem.ObjectId                          AS GoodsId
                  FROM MovementItem
                  WHERE MovementItem.MovementId IN (SELECT tmpMovement.ID FROM tmpMovement)
                    AND MovementItem.DescId     = zc_MI_Master()
                   -- AND MovementItem.Amount     > 0
                    AND MovementItem.isErased  = False
                  )

      , tmpGoods AS (SELECT DISTINCT tmpMI.GoodsId
                     FROM tmpMI
                     )
      , tmpPriceView AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                              , MCS_Value.ValueData                     AS MCSValue
                              , Price_Goods.ChildObjectId               AS GoodsId
                              , COALESCE(MCS_isClose.ValueData,FALSE)   AS MCSIsClose
                              , COALESCE(MCS_NotRecalc.ValueData,FALSE) AS MCSNotRecalc
                              , COALESCE(Price_Top.ValueData,FALSE)     AS isTop
                         FROM ObjectLink AS ObjectLink_Price_Unit
                              LEFT JOIN ObjectLink AS Price_Goods
                                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                              LEFT JOIN tmpGoods ON tmpGoods.GoodsId = Price_Goods.ChildObjectId  -- goodsId
                              LEFT JOIN ObjectFloat AS MCS_Value
                                                    ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                              LEFT JOIN ObjectBoolean AS MCS_isClose
                                                      ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                              LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                      ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                              LEFT JOIN ObjectBoolean AS Price_Top
                                                      ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                         WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                           AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                           AND tmpGoods.GoodsId is not NULL
                      )

      -- считаем остатки
      , tmpRemains AS (SELECT Container.ObjectId
                            , SUM (Container.Amount) AS Amount
                       FROM Container
                            INNER JOIN tmpGoods AS tmp
                                                ON tmp.GoodsId = Container.ObjectId
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount<>0
                         AND Container.WhereObjectId = vbUnitId
                       GROUP BY Container.ObjectId
                      )

       -- Результат 1
       SELECT
             tmpMI.Id                                       AS Id
           , tmpMI.GoodsId                                  AS GoodsId
           , Object_Guuds.ObjectCode                        AS GoodsCode
           , Object_Guuds.ValueData                         AS GoodsName
           , MIFloat_RemainsSUN.ValueData                   AS RemainsSUN
           , Remains.Amount  ::TFloat                       AS RemainsInUnit
           , Object_Price_View.MCSValue                     AS MCS

       FROM tmpMI
            LEFT JOIN Object AS Object_Guuds            ON Object_Guuds.Id                  = tmpMI.GoodsId
            LEFT JOIN tmpPriceView AS Object_Price_View ON Object_Price_View.GoodsId        = tmpMI.GoodsId
            LEFT JOIN tmpRemains   AS Remains           ON Remains.ObjectId                 = tmpMI.GoodsId
            LEFT JOIN MovementItemFloat AS MIFloat_RemainsSUN
                                        ON MIFloat_RemainsSUN.MovementItemId     = tmpMI.Id
                                       AND MIFloat_RemainsSUN.DescId = zc_MIFloat_RemainsSUN()
       WHERE COALESCE (MIFloat_RemainsSUN.ValueData, 0) > 0
           ;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_OrderInternal_WillNotOrder (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 15.05.20                                                                     *
*/

-- select * from gpSelect_MovementItem_OrderInternal_WillNotOrder(inSession := '3');
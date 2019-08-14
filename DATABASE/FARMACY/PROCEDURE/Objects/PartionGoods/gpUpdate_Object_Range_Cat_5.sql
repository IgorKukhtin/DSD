-- Function: gpUpdate_Object_Range_Cat_5

DROP FUNCTION IF EXISTS gpUpdate_Object_Range_Cat_5 (TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Range_Cat_5(
    IN inPriceMin         TFloat,   -- Партия товара
    IN inPriceMax         TFloat,   -- Признак категории
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

    PERFORM gpUpdate_Object_PartionGoods_Cat_5 (PartionGoodsID, False, inSession)
    FROM
    (WITH
       tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                         AND ObjectFloat_Goods_Price.ValueData > 0
                                        THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                        ELSE ROUND (Price_Value.ValueData, 2)
                                   END :: TFloat                           AS Price
                                 , MCS_Value.ValueData                     AS MCSValue
                                 , Price_Goods.ChildObjectId               AS GoodsId
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
                               -- Фикс цена для всей Сети
                               LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                      ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                     AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                       ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                      AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                            WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                              AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                            ),
       tmpNotSale AS (SELECT ContainerLinkObject.ContainerId 
                      FROM ObjectDate
                           INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = ObjectDate.ObjectId
                                                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                           INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                               AND Container.WhereObjectId = vbUnitId
/*                           LEFT JOIN MovementItemContainer ON MovementItemContainer.MovementDescId =  zc_Movement_Check() 
                                                          AND MovementItemContainer.ContainerId = ContainerLinkObject.ContainerId
                           LEFT JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemID
                                                                 
                           LEFT JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.ParentId
                                                           AND MovementItemLinkObject.DescId = zc_MILinkObject_PartionDateKind()
                                                           AND MovementItemLinkObject.ObjectId = zc_Enum_PartionDateKind_Cat_5() 
*/                      WHERE ObjectDate.DescId = zc_ObjectDate_PartionGoods_Cat_5()
--                        AND COALESCE (MovementItemLinkObject.MovementItemId, 0) = 0
                        AND ObjectDate.ValueData < CURRENT_DATE - interval '30 day')
                            

    SELECT ContainerLinkObject.ObjectId AS PartionGoodsID
    FROM Container
         LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId
         LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = Container.whereobjectid
         LEFT JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                 ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                              ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                 ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  ContainerLinkObject.ObjectId
                                AND ObjectBoolean_PartionGoods_Cat_5.DescId = zc_ObjectBoolean_PartionGoods_Cat_5()

         LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Container.ObjectId

    WHERE Container.DescId = zc_container_countpartiondate()
      AND Container.Amount > 0
      AND COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()) <= CURRENT_DATE
      AND COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE) = TRUE
      AND Container.whereobjectid = vbUnitId
      AND COALESCE(tmpObject_Price.Price,0) >= inPriceMin
      AND COALESCE(tmpObject_Price.Price,0) <= inPriceMax
      AND COALESCE(tmpNotSale.ContainerId, 0) = 0
      AND COALESCE(ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE) AS T1;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Range_Cat_5 (inMovementId:= 1, inOperDate:= NULL);

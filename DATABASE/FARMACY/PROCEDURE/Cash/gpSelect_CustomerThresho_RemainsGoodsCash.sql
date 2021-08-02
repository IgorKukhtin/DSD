 -- Function: gpSelect_CustomerThresho_RemainsGoodsCash()

DROP FUNCTION IF EXISTS gpSelect_CustomerThresho_RemainsGoodsCash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CustomerThresho_RemainsGoodsCash(
    IN inGoodsId     Integer,       -- Товар
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId       Integer
             , UnitCode     Integer
             , UnitName     TVarChar
             , Price        TFloat
             , Amount       TFloat
             , MCSValue     TFloat
             , Layout       TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
      WITH tmpUnit AS (SELECT Object_Unit.Id
                       FROM Object AS Object_Unit
                            INNER JOIN ObjectBoolean AS ObjectBoolean_ParticipDistribListDiff
                                                     ON ObjectBoolean_ParticipDistribListDiff.ObjectId = Object_Unit.Id
                                                    AND ObjectBoolean_ParticipDistribListDiff.DescId = zc_ObjectBoolean_Unit_ParticipDistribListDiff()
                                                    AND ObjectBoolean_ParticipDistribListDiff.ValueData = True
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                         AND Object_Unit.isErased = False
                         AND Object_Unit.Id <> vbUnitId
                       ),
           tmpContainer AS (SELECT Container.ObjectId
                                 , Container.WhereObjectId
                                 , SUM(Container.Amount)                       AS Amount
                            FROM Container

                            WHERE Container.DescId = zc_Container_Count()
                              AND Container.Amount <> 0
                              AND Container.ObjectId = inGoodsId
                              AND Container.WhereObjectId IN (SELECT tmpUnit.Id FROM tmpUnit)
                            GROUP BY Container.ObjectId, Container.WhereObjectId
                            HAVING SUM(Container.Amount) > 0
                           ),
           tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                            THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                            ELSE ROUND (Price_Value.ValueData, 2)
                                       END :: TFloat                           AS Price
                                     , MCS_Value.ValueData                     AS MCSValue
                                     , Price_Goods.ChildObjectId               AS GoodsId
                                     , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                                FROM ObjectLink AS Price_Goods
                                   LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                                        ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                                                       AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
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
                                WHERE Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                  AND Price_Goods.ChildObjectId = inGoodsId
                                ),
           tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                      , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                                 FROM Movement
                                      LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                                ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                               AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                 WHERE Movement.DescId = zc_Movement_Layout()
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                ),
           tmpLayout AS (SELECT Movement.ID                        AS Id
                              , MovementItem.ObjectId              AS GoodsId
                              , MovementItem.Amount                AS Amount
                              , Movement.isPharmacyItem            AS isPharmacyItem
                         FROM tmpLayoutMovement AS Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                                                     AND MovementItem.Amount > 0
                         WHERE MovementItem.ObjectId = inGoodsId
                        ),
           tmpLayoutUnit AS (SELECT MovementItem.ObjectId              AS UnitId
                                  , Max(MovementItem.Amount)           AS Amount
                             FROM tmpLayoutMovement AS Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Child()
                                                         AND MovementItem.isErased = FALSE
                                                         AND MovementItem.Amount > 0
                             GROUP BY MovementItem.ObjectId 
                            )
                           
        SELECT Container.ObjectId                                    AS UnitId
             , Object_Unit.ObjectCode                                AS UnitCode
             , Object_Unit.ValueData                                 AS UnitName

             , COALESCE(tmpObject_Price.Price,0)::TFloat             AS Price
             , FLOOR(Container.Amount - 
                COALESCE (tmpObject_Price.MCSValue, 0) - 
                COALESCE (tmpLayoutUnit.Amount, 0))::TFloat          AS Amount
                
             , tmpObject_Price.MCSValue                              AS MCSValue 
             , tmpLayoutUnit.Amount::TFloat                          AS Layout 

        FROM tmpContainer AS Container

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Container.WhereObjectId

            LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = Container.WhereObjectId
            
            LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.UnitId = Container.WhereObjectId
            
        WHERE FLOOR(Container.Amount - 
                    COALESCE (tmpObject_Price.MCSValue, 0) - 
                    COALESCE (tmpLayoutUnit.Amount, 0)) > 0

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 28.07.21                                                      *
*/

--ТЕСТ
-- 

SELECT * FROM gpSelect_CustomerThresho_RemainsGoodsCash (inGoodsId := 13303, inSession:= '3')

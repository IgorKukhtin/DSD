-- Function: gpSelect_CashGoodsNew()

DROP FUNCTION IF EXISTS gpSelect_CashGoodsNew (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoodsNew(
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               GoodsCode Integer,
               GoodsName TVarChar,
               JuridicalName TVarChar,
               ExpirationDate TDateTime,
               Price TFloat)

AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbObjectId   Integer;
  DECLARE vbUnitId     Integer;
  DECLARE vbUnitIdStr  TVarChar;
  DECLARE vbAreaId     Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');
     vbUnitIdStr := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '0');
     IF vbUnitIdStr <> '' THEN
        vbUnitId := vbUnitIdStr;
     ELSE
     	vbUnitId := 0;
     END IF;

    -- старая выборка только товары из прайса подразделения
     RETURN QUERY
     WITH tmpObject_Price AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat  AS Price
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
                        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )

    SELECT tmpObject_Price.GoodsId                     AS GoodsId
         , Object_Goods.ObjectCode                     AS GoodsCode
         , Object_Goods.ValueData                      AS GoodsName
         , COALESCE(tmpObject_Price.Price,0)::TFloat   AS Price
    FROM
        tmpObject_Price

        LEFT OUTER JOIN Object AS Object_Goods 
                               ON Object_Goods.Id = tmpObject_Price.GoodsId
    ORDER BY Object_Goods.ObjectCode;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 20.11.18                                                                                     *
*/

-- тест
-- SELECT * FROM gpSelect_CashGoodsNew (inSession := '3354092');
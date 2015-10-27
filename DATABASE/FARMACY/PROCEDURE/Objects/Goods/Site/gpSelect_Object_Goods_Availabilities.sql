DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Availabilities(TBlob,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Availabilities(
    IN inGoodsId       TBlob,       -- № товаров через запятую
    IN inUnitId        Integer,     -- подразделение
    IN inSession       TVarChar     -- сессия пользователя
)
RETURNS TABLE (--id Integer, 
               product_id Integer, pharmacy_id Integer, supplier_id Integer, quantity TVarChar, price TFloat) AS
$BODY$
BEGIN
    inGoodsId := ','||inGoodsId||',';
    RETURN QUERY
        SELECT
            --id	int(10) unsigned Автоматическое приращение	ИД записи
            Container.ObjectId              as product_id   --ИД товара
           ,Container.WhereObjectId         as pharmacy_id  --ИД аптеки
           ,0::Integer                      as supplier_id  --ИД поставщика 
           ,SUM(Container.Amount)::TVarChar as quantity     --кол-во (*полагаю у поставщика)
           ,Object_Price.Price              as price        --цена, (*полагаю у поставщика)
        FROM Container
            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON Object_Price.GoodsId = Container.ObjectId
                                             AND Object_Price.UnitId = Container.WhereObjectId
        WHERE
            Container.DescId = zc_Container_Count()
            AND
            Container.WhereObjectId = inUnitId
            AND
            Container.Amount > 0
            AND
            Object_Price.Price > 0
            AND
            position((','||Container.ObjectId||',')::TVarChar IN inGoodsId)>0
        GROUP BY
            Container.ObjectId
           ,Container.WhereObjectId
           ,Object_Price.Price
        ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Availabilities(TBlob,Integer,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 27.10.15                                                         *
 
*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods_Count(TRUE,FALSE);



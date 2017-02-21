-- Function: gpSelectMobile_Object_Goods (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Goods (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Goods (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id           Integer
             , ObjectCode   Integer  -- Код
             , ValueData    TVarChar -- Название
             , Weight       TFloat   -- Вес товара
             , Remains      TFloat   -- Остаток товара|для склада Object_Const.UnitId - по данным "последней"  синхронизации
             , Forecast     TFloat   -- Прогноз по поступлению - сколько прийдет на склад Object_Const.UnitId на основнии заказа или факта отгрузки на филиал - по данным "последней"  синхронизации
             , GoodsGroupId Integer  -- Группа товара
             , MeasureId    Integer  -- Единица измерения
             , isErased     Boolean  -- Удаленный ли элемент
             , isSync       Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY
        WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS GoodsId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                             FROM ObjectProtocol
                                  JOIN Object AS Object_Goods
                                              ON Object_Goods.Id = ObjectProtocol.ObjectId
                                             AND Object_Goods.DescId = zc_Object_Goods() 
                             WHERE ObjectProtocol.OperDate > inSyncDateIn
                             GROUP BY ObjectProtocol.ObjectId
                            )
        SELECT Object_Goods.Id
             , Object_Goods.ObjectCode
             , Object_Goods.ValueData
             , CAST(0.0 AS TFloat) AS Weight
             , CAST(0.0 AS TFloat) AS Remains
             , CAST(0.0 AS TFloat) AS Forecast
             , CAST(0 AS Integer)  AS GoodsGroupId
             , CAST(0 AS Integer)  AS MeasureId
             , Object_Goods.isErased
             , (NOT Object_Goods.isErased) AS isSync
        FROM Object AS Object_Goods
             JOIN tmpProtocol ON tmpProtocol.GoodsId = Object_Goods.Id
        WHERE Object_Goods.DescId = zc_Object_Goods();

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Goods(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())

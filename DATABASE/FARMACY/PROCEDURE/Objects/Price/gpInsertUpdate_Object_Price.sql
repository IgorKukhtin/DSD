-- Function: gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ключ объекта < Цена >
    IN inPrice                    TFloat    ,    -- цена
    IN inMCSValue                 TFloat    ,    -- Неснижаемый товарный запас
    IN inGoodsId                  Integer   ,    -- Товар
    IN inUnitId                   Integer   ,    -- подразделение
   OUT outDateChange              TDateTime ,    -- Дата изменения цены
   OUT outMCSDateChange           TDateTime ,    -- Дата изменения неснижаемого товарного запаса
    IN inSession                  TVarChar       -- сессия пользователя
)
AS
$BODY$
   DECLARE
     vbUserId Integer;
     vbPrice TFloat;
     vbMCSValue TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Price());
   vbUserId := inSession;

   -- проверили корректность цены
   IF inPrice = 0
   THEN
     inPrice := null;
   END IF;
   IF inPrice is not null AND (inPrice<0)
   THEN
     RAISE EXCEPTION 'Ошибка.Цена <%> должна быть больше 0.', inPrice;
   END IF;
   -- проверили корректность цены

   IF inMCSValue is not null AND (inMCSValue<0)
   THEN
     RAISE EXCEPTION 'Ошибка.Неснижаемый товарный запас <%> Не может быть меньше 0.', inMCSValue;
   END IF;
   -- Если такая запись есть - достаем её ключу подр.-товар
   SELECT Id, Price, MCSValue, DateChange, MCSDateChange
     INTO ioId, vbPrice, vbMCSValue, outDateChange, outMCSDateChange
   from Object_Price_View
   Where
     GoodsId = inGoodsId
     AND
     UnitId = inUnitID;
   IF COALESCE(ioId,0)=0
   THEN
     -- сохранили/получили <Объект> по ИД
     ioId := lpInsertUpdate_Object (ioId, zc_Object_Price(), 0, '');

     -- сохранили связь с <товар>
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), ioId, inGoodsId);

     -- сохранили связь с <подразделение>
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), ioId, inUnitId);
   END IF;
   -- сохранили св-во < Цена >
   IF (inPrice is not null) AND (inPrice <> COALESCE(vbPrice,0))
   THEN
     PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_Value(), ioId, inPrice);
     -- сохранили св-во < Дата изменения >
     outDateChange := CURRENT_DATE;
     PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_DateChange(), ioId, outDateChange);
   END IF;
   -- сохранили св-во < Неснижаемый товарный запас >
   IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
   THEN
     PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, inMCSValue);
     -- сохранили св-во < Дата изменения Неснижаемого товарного запаса>
     outMCSDateChange := CURRENT_DATE;
     PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), ioId, outMCSDateChange);
   END IF;
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.15                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Price()

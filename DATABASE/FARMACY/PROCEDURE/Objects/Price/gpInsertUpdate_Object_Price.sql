-- Function: gpInsertUpdate_Object_Price (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ключ объекта < Цена > 
    IN inPrice                    TFloat    ,    -- 
    IN inGoodsId                  Integer   ,    --          
    IN inUnitId                   Integer   ,    --
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Price());
   vbUserId := inSession;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Price(), 0, '');

   -- сохранили св-во < Цена >
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Price_Value(), ioId, inPrice);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), ioId, inGoodsId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.15                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Price()

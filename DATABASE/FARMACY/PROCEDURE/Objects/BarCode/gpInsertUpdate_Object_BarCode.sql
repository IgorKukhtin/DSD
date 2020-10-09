-- Function: gpInsertUpdate_Object_BarCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BarCode (Integer, Integer, TVarChar, Integer, Integer, TFloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BarCode(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Договор>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inBarCodeName             TVarChar  ,    -- штрихкод
    IN inGoodsId                 Integer   ,    -- товар
    IN inObjectId                Integer   ,    -- Подключение к программе дисконтных карт
    IN inMaxPrice                TFloat   ,     -- Максимальная цена
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BarCode());
   vbUserId := inSession;

 -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_BarCode());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_BarCode(), inBarCodeName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_BarCode(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BarCode(), vbCode_calc, inBarCodeName, inAccessKeyId:= NULL);


   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BarCode_Goods(), ioId, inGoodsId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BarCode_Object(), ioId, inObjectId);

   -- Максимальная цена
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_BarCode_MaxPrice(), ioId, inMaxPrice);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.16         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BarCode ()                            

-- Function: gpInsertUpdate_Object_JuridicalGoodsCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalGoodsCode (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalGoodsCode(
 INOUT ioId                 Integer   ,    -- ключ объекта <Коды товаров контрагентов>
    IN inCode               Integer   ,    -- Код объекта <>
    IN inName               TVarChar  ,    -- Название объекта <>
    IN inGoodsMainId        Integer   ,    -- ссылка на главное юр.лицо
    IN inObjectId           Integer   ,    -- ссылка на  юр.лицо
    IN inSession            TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalGoodsCode());

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_JuridicalGoodsCode());
     
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_JuridicalGoodsCode(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalGoodsCode(), vbCode_calc);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalGoodsCode_GoodsMain(), ioId, inGoodsMainId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalGoodsCode_Object(), ioId, inObjectId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_JuridicalGoodsCode (Integer, Integer, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_JuridicalGoodsCode ()                            

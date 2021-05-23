-- Function: gpInsertUpdate_Object_GoodsTag()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsTag(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsTag(Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsTag(Integer, Integer, TVarChar, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsTag(
 INOUT ioId                  Integer   ,     -- ключ объекта <Признак товара> 
    IN inCode                Integer   ,     -- Код объекта  
    IN inName                TVarChar  ,     -- Название объекта 
    IN inGoodsGroupAnalystId Integer   ,     -- ссылка на группу Товаров (аналитика) 
    IN inColorReport         TFloat    ,     -- Цвет текста в "отчет по отгрузке"
    IN inColorBgReport       TFloat    ,     -- Цвет фона в "отчет по отгрузке"
    IN inSession             TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag());
   vbUserId:= lpGetUserBySession (inSession);


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_GoodsTag());
   
   -- проверка прав уникальности для свойства <Наименование>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsTag(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsTag(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsTag(), vbCode_calc, inName);
   
      -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsTag_GoodsGroupAnalyst(), ioId, inGoodsGroupAnalystId); 

   -- сохранили свойство <Цвет текста в "отчет по отгрузке">
   IF (COALESCE (inColorReport,0) <> 0 AND COALESCE (inColorBgReport,0) <> zc_Color_White())
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsTag_ColorReport(), ioId, inColorReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsTag_ColorReport(), ioId, Null);
   END IF;

   -- сохранили свойство <Цвет фона в "отчет по отгрузке">
   IF (COALESCE (inColorBgReport,0) <> 0 AND COALESCE (inColorBgReport,0) <> zc_Color_White())
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsTag_ColorBgReport(), ioId, inColorBgReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsTag_ColorBgReport(), ioId, Null);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_GoodsTag (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.12.16         * 
 12.01.15         * add GoodsGroupAnalyst
 15.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsTag(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')

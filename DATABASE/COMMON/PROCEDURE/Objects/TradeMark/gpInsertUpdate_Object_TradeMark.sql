-- Function: gpInsertUpdate_Object_TradeMark(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TradeMark(
 INOUT ioId                  Integer,       -- Ключ объекта <маршрут>
    IN inCode                Integer,       -- свойство <Код маршрута>
    IN inName                TVarChar,      -- свойство <Наименование маршрута>
    IN inColorReport         TFloat  ,      -- Цвет текста в "отчет по отгрузке"
    IN inColorBgReport       TFloat  ,      -- Цвет фона в "отчет по отгрузке" 
    IN inRetailId            Integer ,      --
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TradeMark());
   vbUserId:= lpGetUserBySession (inSession);


   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_TradeMark();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка уникальности для свойства <Наименование Маршрута>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_TradeMark(), inName);
   -- проверка уникальности для свойства <Код маршрута>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TradeMark(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TradeMark(), Code_max, inName);
   
   -- сохранили свойство <Цвет текста в "отчет по отгрузке">
   IF (COALESCE (inColorReport,0) <> 0 AND COALESCE (inColorBgReport,0) <> zc_Color_White())
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorReport(), ioId, inColorReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorReport(), ioId, Null);
   END IF;

   -- сохранили свойство <Цвет фона в "отчет по отгрузке">
   IF (COALESCE (inColorBgReport,0) <> 0 AND COALESCE (inColorBgReport,0) <> zc_Color_White())
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorBgReport(), ioId, inColorBgReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorBgReport(), ioId, Null);
   END IF;

   -- сохранили связь с <торг сеть>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_TradeMark_Retail(), ioId, inRetailId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.22         * zc_ObjectLink_TradeMark_Retail
 05.12.16         * 
 06.09.13                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_TradeMark()

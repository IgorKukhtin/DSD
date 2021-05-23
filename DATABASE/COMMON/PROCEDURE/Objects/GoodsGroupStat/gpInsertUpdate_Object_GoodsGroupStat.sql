-- Function: gpInsertUpdate_Object_GoodsGroupStat()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroupStat (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroupStat(
 INOUT ioId             Integer   ,     -- ключ объекта <Учредители>
    IN inCode           Integer   ,     -- Код объекта
    IN inName           TVarChar  ,     -- Название объекта
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroupStat());


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_GoodsGroupStat());

   -- проверка уникальности для свойства <Наименование> + <Область>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsGroupStat(), inName);

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroupStat(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsGroupStat(), vbCode_calc, inName);
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsGroupStat (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 03.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroupStat(ioId:=null, inCode:=null, inName:='Учредитель 1', inSession:='2')

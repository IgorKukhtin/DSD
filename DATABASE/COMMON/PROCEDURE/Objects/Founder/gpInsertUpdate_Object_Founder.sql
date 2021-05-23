-- Function: gpInsertUpdate_Object_Founder()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Founder (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Founder (Integer, Integer, TVarChar, Integer, Tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Founder(
 INOUT ioId             Integer   ,     -- ключ объекта <Учредители>
    IN inCode           Integer   ,     -- Код объекта
    IN inName           TVarChar  ,     -- Название объекта
    IN inInfoMoneyId    Integer   ,     -- Статьи назначения
    IN inLimitMoney     Tfloat    ,     -- лимит грн
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Founder());


   -- проверка
   IF COALESCE (inInfoMoneyId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<УП статья назначения> не выбрана.';
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Founder());

   -- проверка уникальности для свойства <Наименование> + <Область>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Founder(), inName);

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Founder(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Founder(), vbCode_calc, inName);
  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Founder_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Founder_Limit(), ioId, inLimitMoney);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Founder (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 01.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Founder (ioId:= NULL, inCode:= NULL, inName:= 'Учредитель 1', inInfoMoneyId:= NULL, inSession:='2')

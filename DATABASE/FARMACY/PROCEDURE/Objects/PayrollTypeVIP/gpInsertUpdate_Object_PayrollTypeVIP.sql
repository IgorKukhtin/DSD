-- Function: gpInsertUpdate_Object_PayrollTypeVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PayrollTypeVIP(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PayrollTypeVIP (
  INOUT ioId integer,
     IN inCode integer,
     IN inName TVarChar,
     IN inShortName TVarChar,
     IN inPercentPhone TFloat,
     IN inPercentOther TFloat,
     IN inSession TVarChar
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PayrollTypeVIP());
   vbUserId := inSession;
  
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PayrollTypeVIP());

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PayrollTypeVIP(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PayrollTypeVIP(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PayrollTypeVIP(), vbCode_calc, inName);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_PayrollTypeVIP_ShortName(), ioId, inShortName);

   -- Процент от базы
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PayrollTypeVIP_PercentPhone(), ioId, inPercentPhone);
   -- % ночной
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PayrollTypeVIP_PercentOther(), ioId, inPercentOther);

   -- Мин сумма начисления
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.09.21                                                        *

*/

-- тест
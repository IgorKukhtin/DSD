-- Function: gpInsertUpdate_Object_InternetRepair()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InternetRepair (Integer ,Integer ,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InternetRepair(
 INOUT ioId	                 Integer   ,    -- ключ объекта
    IN inCode                Integer   ,    -- код объекта
    IN inName                TVarChar  ,    -- Название объекта <
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE ObjectName TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
       RAISE EXCEPTION 'Не определено подразделение';
   END IF;
   vbUnitId := vbUnitKey::Integer;


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_InternetRepair());

   -- проверка уникальности <Наименование>
   IF EXISTS (SELECT Object.ValueData FROM Object

                 INNER JOIN ObjectLink AS ObjectLink_InternetRepair
                                       ON ObjectLink_InternetRepair.ChildObjectId = vbUnitId
                                      AND ObjectLink_InternetRepair.ObjectId = Object.Id
                                      AND ObjectLink_InternetRepair.DescId = zc_Object_InternetRepair()

              WHERE Object.DescId = zc_Object_InternetRepair()
                AND Object.ValueData = inName
                AND Object.Id <> ioId)
   THEN
      SELECT ItemName INTO ObjectName FROM ObjectDesc WHERE Id = zc_Object_InternetRepair();
      RAISE EXCEPTION 'Значение "%" не уникально для справочника "%" по подразделению "%"', inName, ObjectName,
        (SELECT ValueData FROM Object WHERE Id = vbUnitId);
   END IF;
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InternetRepair(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InternetRepair(), vbCode_calc, inName);

   -- сохранили связь с <Подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_Object_InternetRepair(), ioId, vbUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InternetRepair(Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.09.22                                                       *              
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_InternetRepair()
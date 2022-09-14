-- Function: gpInsertUpdate_Object_InternetRepair()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InternetRepair (Integer , Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InternetRepair(
 INOUT ioId	                 Integer   ,    -- ключ объекта
    IN inCode                Integer   ,    -- код объекта
    IN inName                TVarChar  ,    -- Название объекта <

    IN inUnitId              Integer   ,    -- Подразделение
    IN inProvider            TVarChar  ,    -- Провайдер
    IN inContractNumber      TVarChar  ,    -- Номер договора
    IN inPhone               TVarChar  ,    -- Телефон
    IN inWhoSignedContract   TVarChar  ,    -- Кто оформил договор
    IN inNotes               TBlob     ,    -- Пометки

    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE (inUnitId, 0) = 0 OR  COALESCE (inProvider, '') = ''
   THEN
     RAISE EXCEPTION 'Ошибка. Подразделение и провайдер должны быть заполнены.'; 
   END IF;
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_InternetRepair());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InternetRepair(), vbCode_calc, COALESCE(inName, ''));

   -- сохранили связь с <Подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InternetRepair_Unit(), ioId, inUnitId);

   -- сохранили <Провайдер>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InternetRepair_Provider(), ioId, inProvider);
   -- сохранили <Номер договора>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InternetRepair_ContractNumber(), ioId, inContractNumber);
   -- сохранили <Телефон>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InternetRepair_Phone(), ioId, inPhone);
   -- сохранили <Кто оформил договор>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InternetRepair_WhoSignedContract(), ioId, inWhoSignedContract);

   -- сохранили <Пометки>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_InternetRepair_Notes(), ioId, inNotes);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InternetRepair(Integer , Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.09.22                                                       *              
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_InternetRepair()
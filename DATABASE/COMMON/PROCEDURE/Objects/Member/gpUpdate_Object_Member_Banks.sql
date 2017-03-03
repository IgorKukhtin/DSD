-- Function: gpUpdate_Object_Member_Banks ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Member_Banks (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_Banks(
    IN inId                Integer   , -- Ключ объекта
    IN inBankId            Integer  , -- 
    IN inDescName          TVarChar  , -- 
   OUT outBankName         TVarChar  , -- 
    IN inSession           TVarChar    -- сессия пользователя
)
  RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(ObjectLinkDesc.Id, inId, inBankId)
   FROM ObjectLinkDesc
   WHERE LOWER (ObjectLinkDesc.Code) = LOWER (inDescName);

   outBankName:= (SELECT Object.ValueData  FROM Object WHERE Object.Id = inBankId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 03.03.17         *
*/


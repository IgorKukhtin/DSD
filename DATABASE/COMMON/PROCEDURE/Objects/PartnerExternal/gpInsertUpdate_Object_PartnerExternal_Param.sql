-- Function: gpInsertUpdate_Object_PartnerExternal_Param  ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal_Param (Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartnerExternal_Param(
    IN inId            Integer   ,    --
    IN inPartnerId     Integer   ,    --
    IN inContractId    Integer   ,    --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PartnerExternal());

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Partner(), inId, inPartnerId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Contract(), inId, inContractId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.20         *
*/

-- тест
--
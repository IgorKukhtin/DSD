-- Function: gpInsertUpdate_Object_PartnerExternal_PartnerReal  ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal_PartnerReal (Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartnerExternal_PartnerReal(
    IN inId            Integer   ,    --
    IN inPartnerRealId Integer   ,    --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartnerId  Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PartnerExternal());

     -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_PartnerReal(), inId, inPartnerRealId);
                   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.12.20         *
*/

-- тест
--


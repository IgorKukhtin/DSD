-- Function: gpUpdate_Object_isErased_ContractConditionPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_ContractConditionPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_ContractConditionPartner(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_ContractConditionPartner());

   -- изменили
   PERFORM lpDelete_Object (inObjectId, inSession) ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.20         *
*/

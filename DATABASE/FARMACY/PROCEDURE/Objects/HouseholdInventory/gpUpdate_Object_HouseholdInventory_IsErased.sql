-- Function: gpUpdate_Object_HouseholdInventory_IsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdate_Object_HouseholdInventory_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_HouseholdInventory_IsErased(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_HouseholdInventory());
    
   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_HouseholdInventory_IsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.07.20                                                       *
*/
	
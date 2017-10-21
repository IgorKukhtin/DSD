-- Function: gpUpdate_Object_isErased_PartnerMedical (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_PartnerMedical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_PartnerMedical(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
  21.10.15        *
*/

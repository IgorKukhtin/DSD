-- Function: gpUpdate_Object_JuridicalPriorities_IsErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_JuridicalPriorities_IsErased (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_JuridicalPriorities_IsErased(
    IN inObjectId      Integer, 
    IN inIsSetErased   Boolean, 
    IN inIsErased      Boolean, 
    IN Session         TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- НЕТ проверки прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (Session);

   -- изменили
   IF inIsSetErased <> inIsErased
   THEN
     PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_JuridicalPriorities_IsErased (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Шаблий О.В.
 12.06.22                                                                   *
*/
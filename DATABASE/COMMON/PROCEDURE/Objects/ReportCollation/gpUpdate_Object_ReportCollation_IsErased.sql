-- Function: gpUpdate_Object_ReportCollation_IsErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollation_IsErased(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());
 
   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.18        *
*/
	
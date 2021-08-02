 -- Function: gpUpdate_Unit_SetcCash()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SetRequestDistribListDiffCash (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SetRequestDistribListDiffCash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
        
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_RequestDistribListDiff(), vbUnitId, True);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 28.07.21                                                      *
*/

--ТЕСТ
-- SELECT * FROM gpUpdate_Unit_SetRequestDistribListDiffCash (inSession:= '3')


-- Function: gpSelect_Cash_InventoryEveryMonth()

DROP FUNCTION IF EXISTS gpSelect_Cash_InventoryEveryMonth (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_InventoryEveryMonth (
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Repl TVarChar,
              Texts TVarChar
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');

   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
   
   RETURN QUERY
     SELECT 'Unit'::TVarChar, 'Аптека'::TVarChar;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.08.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Cash_InventoryEveryMonth('3')
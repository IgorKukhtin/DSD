-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_OrderExternal_ExportParam(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderExternal_ExportParam(
    IN inMovementId  Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS TABLE (DefaultFileName TVarChar, ExportType Integer) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbUnitName TVarChar;
  DECLARE vbMainJuridicalName TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);

   SELECT FromId, ToName, Object_Unit_View.JuridicalName INTO vbJuridicalId, vbUnitName, vbMainJuridicalName
       FROM Movement_OrderExternal_View 
            LEFT JOIN Object_Unit_View ON Object_Unit_View.Id = ToId
       WHERE Movement_OrderExternal_View.Id = inMovementId;

   IF vbJuridicalId = 59611 THEN --Оптима

       RETURN QUERY
       SELECT
         ('Заказ - '||COALESCE(vbMainJuridicalName, '')||' от '||COALESCE(vbUnitName, ''))::TVarChar
        , 5;
       RETURN;
   END IF;

   IF vbJuridicalId = 59610 THEN --БАДМ

       RETURN QUERY
       SELECT
         ('Заказ - '||COALESCE(vbMainJuridicalName, '')||' от '||COALESCE(vbUnitName, ''))::TVarChar
        , 5;
       RETURN;
   END IF;

   RETURN QUERY
   SELECT
      ('Заказ - '||COALESCE(vbMainJuridicalName, '')||' от '||COALESCE(vbUnitName, ''))::TVarChar
    , 3;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OrderExternal_ExportParam(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.12.14                         *  

*/

-- тест
-- SELECT * FROM gpGet_Object_City (0, '2')
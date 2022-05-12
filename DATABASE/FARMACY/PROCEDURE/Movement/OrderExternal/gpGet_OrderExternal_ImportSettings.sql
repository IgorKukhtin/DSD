-- Function: gpGet_OrderExternal_ImportSettings()

DROP FUNCTION IF EXISTS gpGet_OrderExternal_ImportSettings(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderExternal_ImportSettings(
    IN inJuridicalId Integer,       -- Плставщик
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TVarChar AS
$BODY$
  DECLARE vbResult TVarChar;
  DECLARE vbName TVarChar;
BEGIN

   SELECT Object.ValueData
   INTO vbName
   FROM Object
   WHERE Object.Id = inJuridicalId;

   IF EXISTS(SELECT Id FROM gpSelect_Object_ImportSettings( inSession := '3') AS ImportSettings
             WHERE ImportSettings.ImportTypeId = zc_Enum_ImportType_SupplierFailures()
               AND ImportSettings.isErased = false
               AND Name ILIKE ('%'||vbName||'%'))
      AND COALESCE (vbName, '') <> ''
   THEN
     RETURN (SELECT Id FROM gpSelect_Object_ImportSettings( inSession := '3') AS ImportSettings
             WHERE ImportSettings.ImportTypeId = zc_Enum_ImportType_SupplierFailures()
               AND ImportSettings.isErased = false
               AND Name ILIKE ('%'||vbName||'%')
             LIMIT 1);
   ELSE   
     RETURN zc_Enum_ImportSetting_SupplierFailures();
   END IF;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OrderExternal_ImportSettings(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *

*/

-- тест

select * from gpGet_OrderExternal_ImportSettings(inJuridicalId :=  18926945  , inSession := '3');
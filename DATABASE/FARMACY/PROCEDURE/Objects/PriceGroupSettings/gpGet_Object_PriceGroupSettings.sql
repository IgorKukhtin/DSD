-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_PriceGroupSettings(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PriceGroupSettings(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Name TVarChar, MinPrice TFloat, Percent TFloat, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceGroupSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY 
       SELECT 
             Object_PriceGroupSettings.Id
           , Object_PriceGroupSettings.ValueData
           , ObjectFloat_MinPrice.ValueData
           , ObjectFloat_Percent.ValueData
           , Object_PriceGroupSettings.isErased
       FROM  Object AS Object_PriceGroupSettings

                     LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                      ON ObjectFloat_MinPrice.ObjectId = Object_PriceGroupSettings.Id
                                     AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_PriceGroupSettings_MinPrice()

                     LEFT JOIN ObjectFloat AS ObjectFloat_Percent 
                                      ON ObjectFloat_Percent.ObjectId = Object_PriceGroupSettings.Id
                                     AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PriceGroupSettings_Percent()

       WHERE Object_PriceGroupSettings.Id = inId;
  
END;
$BODY$
  
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PriceGroupSettings (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')
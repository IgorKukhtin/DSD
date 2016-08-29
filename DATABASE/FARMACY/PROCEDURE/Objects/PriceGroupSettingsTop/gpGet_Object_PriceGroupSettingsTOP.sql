-- Function: gpGet_Object_Unit()
 
DROP FUNCTION IF EXISTS gpGet_Object_PriceGroupSettingsTOP(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PriceGroupSettingsTOP(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Name TVarChar, MinPrice TFloat, Percent TFloat, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceGroupSettingsTOP());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY 
       SELECT 
             Object_PriceGroupSettingsTOP.Id
           , Object_PriceGroupSettingsTOP.ValueData
           , ObjectFloat_MinPrice.ValueData
           , ObjectFloat_Percent.ValueData
           , Object_PriceGroupSettingsTOP.isErased
       FROM  Object AS Object_PriceGroupSettingsTOP

                     LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                      ON ObjectFloat_MinPrice.ObjectId = Object_PriceGroupSettingsTOP.Id
                                     AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice()

                     LEFT JOIN ObjectFloat AS ObjectFloat_Percent 
                                      ON ObjectFloat_Percent.ObjectId = Object_PriceGroupSettingsTOP.Id
                                     AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PriceGroupSettingsTOP_Percent()

       WHERE Object_PriceGroupSettingsTOP.Id = inId;
  
END;
$BODY$
  
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PriceGroupSettingsTOP (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.16         *

*/

-- тест
-- SELECT * FROM gpGet_Object_PriceGroupSettingsTOP(0,'2')
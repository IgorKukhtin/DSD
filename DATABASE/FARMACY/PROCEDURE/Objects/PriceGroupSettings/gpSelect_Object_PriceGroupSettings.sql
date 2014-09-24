-- Function: gpSelect_Object_PriceGroupSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_PriceGroupSettings(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_PriceGroupSettings(
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
       FROM ObjectLink AS ObjectLink_PriceGroupSettings_Retail 
                     JOIN Object AS Object_PriceGroupSettings
                                 ON Object_PriceGroupSettings.Id = ObjectLink_PriceGroupSettings_Retail.ObjectId 

                     LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                      ON ObjectFloat_MinPrice.ObjectId = ObjectLink_PriceGroupSettings_Retail.ObjectId
                                     AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_PriceGroupSettings_MinPrice()

                     LEFT JOIN ObjectFloat AS ObjectFloat_Percent 
                                      ON ObjectFloat_Percent.ObjectId = ObjectLink_PriceGroupSettings_Retail.ObjectId
                                     AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PriceGroupSettings_Percent()

       WHERE ObjectLink_PriceGroupSettings_Retail.DescId = zc_ObjectLink_PriceGroupSettings_Retail()
         AND ObjectLink_PriceGroupSettings_Retail.ChildObjectId = vbObjectId;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PriceGroupSettings(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceGroupSettings ('2')
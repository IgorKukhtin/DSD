-- Function: gpSelect_Object_PriceGroupSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_PriceGroupSettingsInterval(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_PriceGroupSettingsInterval(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MinPrice TFloat, MaxPrice TFloat, Percent TFloat) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceGroupSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY 
WITH DDD AS 
       (SELECT 
            ObjectFloat_MinPrice.ValueData AS MinPrice
           , ObjectFloat_Percent.ValueData AS Percent
       FROM ObjectLink AS ObjectLink_PriceGroupSettings_Retail 

                     JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                      ON ObjectFloat_MinPrice.ObjectId = ObjectLink_PriceGroupSettings_Retail.ObjectId
                                     AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_PriceGroupSettings_MinPrice()

                     JOIN ObjectFloat AS ObjectFloat_Percent 
                                      ON ObjectFloat_Percent.ObjectId = ObjectLink_PriceGroupSettings_Retail.ObjectId
                                     AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PriceGroupSettings_Percent()

       WHERE ObjectLink_PriceGroupSettings_Retail.DescId = zc_ObjectLink_PriceGroupSettings_Retail()
         AND ObjectLink_PriceGroupSettings_Retail.ChildObjectId = vbObjectId)
       
       SELECT ddd.MinPrice 
            , COALESCE((SELECT min(d2.MInPrice) FROM ddd AS d2 WHERE D2.MinPrice > ddd.MinPrice ), 100000000000)::TFloat AS MaxPrice 
            , ddd.Percent
       FROM ddd;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PriceGroupSettingsInterval(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval ('240')
-- Function: gpSelect_Object_PriceGroupSettingsTOP()

DROP FUNCTION IF EXISTS gpSelect_Object_PriceGroupSettingsTOP(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_PriceGroupSettingsTOP(
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
       FROM ObjectLink AS ObjectLink_PriceGroupSettingsTOP_Retail 
                     JOIN Object AS Object_PriceGroupSettingsTOP
                                 ON Object_PriceGroupSettingsTOP.Id = ObjectLink_PriceGroupSettingsTOP_Retail.ObjectId 

                     LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                      ON ObjectFloat_MinPrice.ObjectId = ObjectLink_PriceGroupSettingsTOP_Retail.ObjectId
                                     AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice()

                     LEFT JOIN ObjectFloat AS ObjectFloat_Percent 
                                      ON ObjectFloat_Percent.ObjectId = ObjectLink_PriceGroupSettingsTOP_Retail.ObjectId
                                     AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PriceGroupSettingsTOP_Percent()

       WHERE ObjectLink_PriceGroupSettingsTOP_Retail.DescId = zc_ObjectLink_PriceGroupSettingsTOP_Retail()
         AND ObjectLink_PriceGroupSettingsTOP_Retail.ChildObjectId = vbObjectId;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PriceGroupSettingsTOP(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceGroupSettingsTOP ('2')
-- Function: gpSelect_Object_PriceGroupSettingsTOP()

DROP FUNCTION IF EXISTS gpSelect_Object_PriceGroupSettingsTOPInterval(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_PriceGroupSettingsTOPInterval(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MinPrice TFloat, MaxPrice TFloat, Percent TFloat) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceGroupSettingsTOP());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY 
   WITH 
   tmp AS (SELECT ObjectFloat_MinPrice.ValueData AS MinPrice
                , ObjectFloat_Percent.ValueData  AS Percent
           FROM ObjectLink AS ObjectLink_PriceGroupSettingsTOP_Retail 
                JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                 ON ObjectFloat_MinPrice.ObjectId = ObjectLink_PriceGroupSettingsTOP_Retail.ObjectId
                                AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice()
                JOIN ObjectFloat AS ObjectFloat_Percent 
                                 ON ObjectFloat_Percent.ObjectId = ObjectLink_PriceGroupSettingsTOP_Retail.ObjectId
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PriceGroupSettingsTOP_Percent()
 
          WHERE ObjectLink_PriceGroupSettingsTOP_Retail.DescId = zc_ObjectLink_PriceGroupSettingsTOP_Retail()
            AND ObjectLink_PriceGroupSettingsTOP_Retail.ChildObjectId = vbObjectId
          )
       
       SELECT tmp.MinPrice 
            , COALESCE((SELECT min(d2.MInPrice) FROM tmp AS d2 WHERE D2.MinPrice > tmp.MinPrice ), 100000000000)::TFloat AS MaxPrice 
            , tmp.Percent
       FROM tmp;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PriceGroupSettingsTOPInterval(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.16         * parce
 26.08.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval ('240')
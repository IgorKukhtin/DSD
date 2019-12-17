-- Function: gpSelect_Object_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Retail( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Retail(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MarginPercent TFloat
             , SummSUN TFloat
             , LimitSUN TFloat
             , ShareFromPrice TFloat
             , isGoodsReprice Boolean
             , isErased Boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY 
       SELECT 
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS NAME

           , COALESCE (ObjectFloat_MarginPercent.ValueData, 0) :: TFloat AS MarginPercent
           , COALESCE (ObjectFloat_SummSUN.ValueData, 0)       :: TFloat AS SummSUN
           , COALESCE (ObjectFloat_LimitSUN.ValueData, 0)      :: TFloat AS LimitSUN
           , COALESCE (ObjectFloat_ShareFromPrice.ValueData, 0):: TFloat AS ShareFromPrice
           
           , COALESCE (ObjectBoolean_GoodsReprice.ValueData, FALSE):: Boolean AS isGoodsReprice

           , Object_Retail.isErased   AS isErased
       FROM Object AS Object_Retail
            LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                  ON ObjectFloat_MarginPercent.ObjectId = Object_Retail.Id 
                                 AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_Retail_MarginPercent() 

            LEFT JOIN ObjectFloat AS ObjectFloat_SummSUN
                                  ON ObjectFloat_SummSUN.ObjectId = Object_Retail.Id 
                                 AND ObjectFloat_SummSUN.DescId = zc_ObjectFloat_Retail_SummSUN()

            LEFT JOIN ObjectFloat AS ObjectFloat_LimitSUN
                                  ON ObjectFloat_LimitSUN.ObjectId = Object_Retail.Id 
                                 AND ObjectFloat_LimitSUN.DescId = zc_ObjectFloat_Retail_LimitSUN()

            LEFT JOIN ObjectFloat AS ObjectFloat_ShareFromPrice
                                  ON ObjectFloat_ShareFromPrice.ObjectId = Object_Retail.Id 
                                 AND ObjectFloat_ShareFromPrice.DescId = zc_ObjectFloat_Retail_ShareFromPrice()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsReprice
                                    ON ObjectBoolean_GoodsReprice.ObjectId = Object_Retail.Id 
                                   AND ObjectBoolean_GoodsReprice.DescId = zc_ObjectBoolean_Retail_GoodsReprice()
       WHERE Object_Retail.DescId = zc_Object_Retail();
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.12.19         * add isGoodsReprice
 11.12.19                                                       * LimitSUN
 23.07.19         * SummSUN
 25.03.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Retail ( zfCalc_UserAdmin())

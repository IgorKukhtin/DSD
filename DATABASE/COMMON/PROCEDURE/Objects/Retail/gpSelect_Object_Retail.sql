-- Function: gpSelect_Object_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Retail(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Retail(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GLNCode TVarChar 
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar             
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Retail()());

   RETURN QUERY 
   SELECT 
     Object_Retail.Id         AS Id 
   , Object_Retail.ObjectCode AS Code
   , Object_Retail.ValueData  AS NAME
   , GLNCode.ValueData AS GLNCode
   , Object_GoodsProperty.Id         AS GoodsPropertyId
   , Object_GoodsProperty.ValueData  AS GoodsPropertyName           
   , Object_Retail.isErased   AS isErased
   FROM Object AS Object_Retail
        LEFT JOIN ObjectString AS GLNCode
                               ON GLNCode.ObjectId = Object_Retail.Id 
                              AND GLNCode.DescId = zc_ObjectString_Retail_GLNCode()

        LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                             ON ObjectLink_Retail_GoodsProperty.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Retail_GoodsProperty.ChildObjectId
                              
   WHERE Object_Retail.DescId = zc_Object_Retail();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Retail(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.15         * add GoodsProperty 
 10.11.14         * add GLNCode
 23.05.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Retail('2')
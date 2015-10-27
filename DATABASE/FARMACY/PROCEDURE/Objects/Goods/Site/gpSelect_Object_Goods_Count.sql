DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Count(Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Count(
    IN inPublished     Boolean,       -- опубликован
    IN inErased        Boolean,       -- удален
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (records_found Integer) AS
$BODY$
    DECLARE vbObjectId Integer;
    DECLARE vbUserId Integer;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    RETURN QUERY 
        SELECT 
            COUNT(*)::Integer as records_found
        FROM Object_Goods_View AS Object_Goods
            LEFT OUTER JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                          ON ObjectBoolean_Goods_Published.ObjectId = Object_Goods.Id
                                         AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()
        WHERE
            Object_Goods.ObjectId = vbObjectId
            AND
            Object_Goods.isErased = inErased
            AND
            COALESCE(ObjectBoolean_Goods_Published.ValueData,FALSE) = inPublished
        ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Count(Boolean,Boolean,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 27.10.15                                                         *
 
*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods_Count(TRUE,FALSE,'3');



-- Function: gpGet_Object_GoodsProperty()


DROP FUNCTION IF EXISTS gpGet_Object_GoodsProperty( Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsProperty(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , StartPosInt TFloat, EndPosInt TFloat, StartPosFrac TFloat, EndPosFrac TFloat             
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsProperty());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (COALESCE (Object_GoodsProperty.ObjectCode, 0)) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as TFloat)   AS StartPosInt
           , CAST (0 as TFloat)   AS EndPosInt
           , CAST (0 as TFloat)   AS StartPosFrac
           , CAST (0 as TFloat)   AS EndPosFrac

           , CAST (NULL AS Boolean) AS isErased;
       FROM Object AS Object_GoodsProperty
       WHERE Object_GoodsProperty.DescId = zc_Object_GoodsProperty();

   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsProperty.Id         AS Id
           , Object_GoodsProperty.ObjectCode AS Code
           , Object_GoodsProperty.ValueData  AS Name

           , ObjectFloat_StartPosInt.ValueData   AS StartPosInt
           , ObjectFloat_EndPosInt.ValueData     AS EndPosInt
           , ObjectFloat_StartPosFrac.ValueData  AS StartPosFrac
           , ObjectFloat_EndPosFrac.ValueData    AS EndPosFrac

           , Object_GoodsProperty.isErased   AS isErased
       FROM Object AS Object_GoodsProperty
        LEFT JOIN ObjectFloat AS ObjectFloat_StartPosInt 
                              ON ObjectFloat_StartPosInt.ObjectId = Object_GoodsProperty.Id 
                             AND ObjectFloat_StartPosInt.DescId = zc_ObjectFloat_GoodsProperty_StartPosInt()

        LEFT JOIN ObjectFloat AS ObjectFloat_EndPosInt 
                              ON ObjectFloat_EndPosInt.ObjectId = Object_GoodsProperty.Id 
                             AND ObjectFloat_EndPosInt.DescId = zc_ObjectFloat_GoodsProperty_EndPosInt()

        LEFT JOIN ObjectFloat AS ObjectFloat_StartPosFrac 
                              ON ObjectFloat_StartPosFrac.ObjectId = Object_GoodsProperty.Id 
                             AND ObjectFloat_StartPosFrac.DescId = zc_ObjectFloat_GoodsProperty_StartPosFrac()

        LEFT JOIN ObjectFloat AS ObjectFloat_EndPosFrac 
                              ON ObjectFloat_EndPosFrac.ObjectId = Object_GoodsProperty.Id 
                             AND ObjectFloat_EndPosFrac.DescId = zc_ObjectFloat_GoodsProperty_EndPosFrac()

       WHERE Object_GoodsProperty.Id = inId;
   END IF;
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsProperty(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.15          * ADD StartPosInt, EndPosInt, StartPosFrac, EndPosFrac
 12.06.13          *
 00.06.13

*/

-- ТЕСТ
-- SELECT * FROM gpSelect_GoodsProperty('2')
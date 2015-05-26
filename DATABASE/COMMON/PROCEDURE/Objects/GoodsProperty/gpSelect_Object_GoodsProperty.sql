-- Function: gpSelect_Object_GoodsProperty()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsProperty(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsProperty(
    IN inSession     TVarChar       -- 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , StartPosInt TFloat, EndPosInt TFloat, StartPosFrac TFloat, EndPosFrac TFloat
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   --PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsProperty());

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

   WHERE Object_GoodsProperty.DescId = zc_Object_GoodsProperty();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsProperty(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.15          * ADD StartPosInt, EndPosInt, StartPosFrac, EndPosFrac
 12.06.13          *
 00.06.13
 
*/

-- С‚РµСЃС‚
-- SELECT * FROM gpSelect_Object_GoodsProperty('2')
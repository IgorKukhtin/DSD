-- Function: gpGet_Object_GoodsProperty()


DROP FUNCTION IF EXISTS gpGet_Object_GoodsProperty( Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsProperty(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , StartPosInt TFloat, EndPosInt TFloat, StartPosFrac TFloat, EndPosFrac TFloat  
             , StartPosIdent TFloat, EndPosIdent TFloat 
             , TaxDoc TFloat
             , isErased Boolean)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsProperty());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode (0, zc_Object_GoodsProperty()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as TFloat)   AS StartPosInt
           , CAST (0 as TFloat)   AS EndPosInt
           , CAST (0 as TFloat)   AS StartPosFrac
           , CAST (0 as TFloat)   AS EndPosFrac

           , CAST (0 as TFloat)   AS StartPosIdent
           , CAST (0 as TFloat)   AS EndPosIdent

           , CAST (0 as TFloat)   AS TaxDoc

           , CAST (NULL AS Boolean) AS isErased;

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

           , ObjectFloat_StartPosIdent.ValueData AS StartPosIdent
           , ObjectFloat_EndPosIdent.ValueData   AS EndPosIdent

           , ObjectFloat_TaxDoc.ValueData        AS TaxDoc

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

        LEFT JOIN ObjectFloat AS ObjectFloat_StartPosIdent 
                              ON ObjectFloat_StartPosIdent.ObjectId = Object_GoodsProperty.Id 
                             AND ObjectFloat_StartPosIdent.DescId = zc_ObjectFloat_GoodsProperty_StartPosIdent()

        LEFT JOIN ObjectFloat AS ObjectFloat_EndPosIdent 
                              ON ObjectFloat_EndPosIdent.ObjectId = Object_GoodsProperty.Id 
                             AND ObjectFloat_EndPosIdent.DescId = zc_ObjectFloat_GoodsProperty_EndPosIdent()

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxDoc
                              ON ObjectFloat_TaxDoc.ObjectId = Object_GoodsProperty.Id 
                             AND ObjectFloat_TaxDoc.DescId = zc_ObjectFloat_GoodsProperty_TaxDoc()

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
 22.06.17         * add TaxDoc
 24.09.15         *
 26.05.15         * ADD StartPosInt, EndPosInt, StartPosFrac, EndPosFrac
 12.06.13         *
 00.06.13

*/

-- ТЕСТ
-- SELECT * FROM gpGet_Object_GoodsProperty (1, '2')

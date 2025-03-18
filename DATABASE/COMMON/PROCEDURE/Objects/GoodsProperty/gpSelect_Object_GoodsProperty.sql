-- Function: gpSelect_Object_GoodsProperty()

--DROP FUNCTION IF EXISTS gpSelect_Object_GoodsProperty(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsProperty(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsProperty(
    IN inIsErased    Boolean , 
    IN inSession     TVarChar       -- 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , StartPosInt TFloat, EndPosInt TFloat, StartPosFrac TFloat, EndPosFrac TFloat
             , StartPosIdent TFloat, EndPosIdent TFloat
             , TaxDoc TFloat
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   --PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsProperty());

   RETURN QUERY 
   SELECT 
         Object_GoodsProperty.Id             AS Id 
       , Object_GoodsProperty.ObjectCode     AS Code
       , Object_GoodsProperty.ValueData      AS Name
      
       , ObjectFloat_StartPosInt.ValueData   AS StartPosInt
       , ObjectFloat_EndPosInt.ValueData     AS EndPosInt
       , ObjectFloat_StartPosFrac.ValueData  AS StartPosFrac
       , ObjectFloat_EndPosFrac.ValueData    AS EndPosFrac

       , ObjectFloat_StartPosIdent.ValueData AS StartPosIdent
       , ObjectFloat_EndPosIdent.ValueData   AS EndPosIdent

       , ObjectFloat_TaxDoc.ValueData        AS TaxDoc

       , Object_GoodsProperty.isErased       AS isErased

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

   WHERE Object_GoodsProperty.DescId = zc_Object_GoodsProperty() 
     AND (Object_GoodsProperty.isErased = inIsErased OR inIsErased = TRUE)

    UNION ALL
      SELECT 0               AS Id
           , NULL :: Integer AS Code
           , 'УДАЛИТЬ Значение' :: TVarChar AS Name
           , NULL :: TFloat AS StartPosInt
           , NULL :: TFloat AS EndPosInt
           , NULL :: TFloat AS StartPosFrac
           , NULL :: TFloat EndPosFrac

           , NULL :: TFloat AS StartPosIdent
           , NULL :: TFloat AS EndPosIdent
           , NULL :: TFloat AS TaxDoc

           , FALSE AS isErased
          ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsProperty(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.17          * add TaxDoc
 24.09.15          *
 26.05.15          * ADD StartPosInt, EndPosInt, StartPosFrac, EndPosFrac
 12.06.13          *
 00.06.13
 
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsProperty(false, '2')

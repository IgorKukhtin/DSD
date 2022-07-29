-- Function: gpSelect_Object_GoodsMethodAppl(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsMethodAppl(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsMethodAppl(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameUkr TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsMethodAppl());

   RETURN QUERY 
     SELECT Object_GoodsMethodAppl.Id                       AS Id
          , Object_GoodsMethodAppl.ObjectCode               AS Code
          , Object_GoodsMethodAppl.ValueData                AS Name
          , ObjectString_GoodsMethodAppl_NameUkr.ValueData  AS NameUkr
          , Object_GoodsMethodAppl.isErased                 AS isErased
     FROM OBJECT AS Object_GoodsMethodAppl

          LEFT JOIN ObjectString AS ObjectString_GoodsMethodAppl_NameUkr
                                 ON ObjectString_GoodsMethodAppl_NameUkr.ObjectId = Object_GoodsMethodAppl.Id
                                AND ObjectString_GoodsMethodAppl_NameUkr.DescId = zc_ObjectString_GoodsMethodAppl_NameUkr()   

     WHERE Object_GoodsMethodAppl.DescId = zc_Object_GoodsMethodAppl();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsMethodAppl(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.07.22                                                       *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsMethodAppl('2')
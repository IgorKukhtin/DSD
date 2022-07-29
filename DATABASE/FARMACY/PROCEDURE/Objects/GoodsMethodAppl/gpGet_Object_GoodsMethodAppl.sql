-- Function: gpGet_Object_GoodsMethodAppl (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsMethodAppl (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsMethodAppl(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameUkr TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsMethodAppl());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsMethodAppl()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS NameUkr
           , False                  AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_GoodsMethodAppl.Id                       AS Id
            , Object_GoodsMethodAppl.ObjectCode               AS Code
            , Object_GoodsMethodAppl.ValueData                AS Name
            , ObjectString_GoodsMethodAppl_NameUkr.ValueData  AS NameUkr
            , Object_GoodsMethodAppl.isErased                 AS isErased
       FROM Object AS Object_GoodsMethodAppl

           LEFT JOIN ObjectString AS ObjectString_GoodsMethodAppl_NameUkr
                                  ON ObjectString_GoodsMethodAppl_NameUkr.ObjectId = Object_GoodsMethodAppl.Id
                                 AND ObjectString_GoodsMethodAppl_NameUkr.DescId = zc_ObjectString_GoodsMethodAppl_NameUkr()   

       WHERE Object_GoodsMethodAppl.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.07.22                                                       *              

*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsMethodAppl(0,'2')
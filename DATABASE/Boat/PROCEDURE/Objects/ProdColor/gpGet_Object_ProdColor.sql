-- Торговая марка

DROP FUNCTION IF EXISTS gpGet_Object_ProdColor (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdColor(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , Value TVarChar, Color_Value Integer
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProdColor());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_ProdColor())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
           , '' :: TVarChar           AS Value
           , zc_Color_White()::Integer  AS Color_Value
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_ProdColor.Id                 AS Id
           , Object_ProdColor.ObjectCode         AS Code
           , Object_ProdColor.ValueData          AS Name
           , ObjectString_Comment.ValueData      AS Comment
           , ObjectString_Value.ValueData        AS Value
           , COALESCE(ObjectFloat_Value.ValueData, zc_Color_White())::Integer  AS Color_Value
       FROM Object AS Object_ProdColor
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColor.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColor_Comment() 
          LEFT JOIN ObjectString AS ObjectString_Value
                                 ON ObjectString_Value.ObjectId = Object_ProdColor.Id
                                AND ObjectString_Value.DescId = zc_ObjectString_ProdColor_Value()
          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ProdColor.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ProdColor_Value()
       WHERE Object_ProdColor.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.   Шаблий О.В.
 29.09.22                                                                        *
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ProdColor (1 ::integer,'2'::TVarChar)

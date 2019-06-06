-- Function: gpSelect_Object_DiffKindCash(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DiffKindCash(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiffKindCash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, MaxOrderAmount TFloat) 
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
     SELECT Object_DiffKind.Id                     AS Id
          , Object_DiffKind.ObjectCode             AS Code
          , Object_DiffKind.ValueData              AS Name
          , ObjectFloat_DiffKind_MaxOrderAmount.ValueData  AS MaxOrderAmount
     FROM Object AS Object_DiffKind
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmount
                                ON ObjectFloat_DiffKind_MaxOrderAmount.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_MaxOrderAmount.DescId = zc_ObjectFloat_MaxOrderAmount() 
     WHERE Object_DiffKind.DescId = zc_Object_DiffKind()
       AND Object_DiffKind.isErased = FALSE;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.12.18                                                       *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_DiffKindCash('3')
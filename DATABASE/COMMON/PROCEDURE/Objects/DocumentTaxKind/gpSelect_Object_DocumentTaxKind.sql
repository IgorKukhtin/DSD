-- Function: gpSelect_Object_DocumentTaxKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DocumentTaxKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DocumentTaxKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, KindCode TVarChar, isErased Boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DocumentTaxKind());

   RETURN QUERY
   SELECT
         Object.Id         AS Id
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , ObjectString_Code.ValueData  :: TVarChar AS KindCode
       , Object.isErased   AS isErased
   FROM Object
        LEFT JOIN ObjectString AS ObjectString_Code
                               ON ObjectString_Code.ObjectId = Object.Id
                              AND ObjectString_Code.DescId = zc_objectString_DocumentTaxKind_Code()
   WHERE Object.DescId = zc_Object_DocumentTaxKind();

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.11.18         *
 11.02.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DocumentTaxKind('2')
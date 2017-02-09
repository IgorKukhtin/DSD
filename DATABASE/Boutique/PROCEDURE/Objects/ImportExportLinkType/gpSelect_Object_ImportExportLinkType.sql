-- Function: gpSelect_Object_ImportExportLinkType (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportExportLinkType (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportExportLinkType(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ImportExportLinkType());

   RETURN QUERY 
   SELECT
        Object_ImportExportLinkType.Id           AS Id 
      , Object_ImportExportLinkType.ObjectCode   AS Code
      , Object_ImportExportLinkType.ValueData    AS NAME
            
      , Object_ImportExportLinkType.isErased     AS isErased
      
   FROM OBJECT AS Object_ImportExportLinkType
                              
   WHERE Object_ImportExportLinkType.DescId = zc_Object_ImportExportLinkType();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ImportExportLinkType (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.14                        *             

*/

-- тест
-- SELECT * FROM gpSelect_Object_ImportExportLinkType('2')




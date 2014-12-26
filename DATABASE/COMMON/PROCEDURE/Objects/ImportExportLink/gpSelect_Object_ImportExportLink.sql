-- Function: gpSelect_Object_GoodsKind()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportExportLink(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportExportLink(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, IntegerKey Integer, StringKey TVarChar
            , MainId Integer, ValueId Integer, ObjectMainName TVarChar, ObjectChildName TVarChar
            , LinkTypeId Integer, LinkTypeName TVarChar, SomeText TBlob) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKind());

   RETURN QUERY 
   SELECT 
       Object_ImportExportLink_View.Id 
     , Object_ImportExportLink_View.IntegerKey
     , Object_ImportExportLink_View.StringKey
     , Object_ImportExportLink_View.MainId
     , Object_ImportExportLink_View.ValueId
     , Object_ImportExportLink_View.ObjectMainName
     , Object_ImportExportLink_View.ObjectChildName
     , Object_ImportExportLink_View.LinkTypeId
     , Object_ImportExportLink_View.LinkTypeName
     , Object_ImportExportLink_View.SomeText

   FROM Object_ImportExportLink_View;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpSelect_Object_ImportExportLink(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.14                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsKind('2')
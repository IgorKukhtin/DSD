-- Function: gpSelect_Object_GoodsKind()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportExportLink(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ImportExportLink(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportExportLink(
    IN inIsErased       Boolean,       -- показать удаденные Да/Нет
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, IntegerKey Integer, StringKey TVarChar
            , MainId Integer, ValueId Integer, ObjectMainName TVarChar, DescMainName TVarChar
            , ObjectChildName TVarChar, DescChildName TVarChar
            , LinkTypeId Integer, LinkTypeName TVarChar, SomeText TBlob
            , isErased Boolean
            ) AS
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
     , Object_ImportExportLink_View.DescMainName
     , Object_ImportExportLink_View.ObjectChildName
     , Object_ImportExportLink_View.DescChildName
     , Object_ImportExportLink_View.LinkTypeId
     , Object_ImportExportLink_View.LinkTypeName
     , Object_ImportExportLink_View.SomeText
     , Object_ImportExportLink_View.isErased
   FROM Object_ImportExportLink_View
   WHERE (COALESCE (Object_ImportExportLink_View.isErased, False) = False OR inIsErased = TRUE);
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_ImportExportLink(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.14                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsKind('2')

-- Function: gpSelect_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               FileTypeId Integer, FileTypeName TVarChar,
               ImportTypeId Integer, ImportTypeName TVarChar,
               StartRow Integer,
               Directory TVarChar,
               isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportSettings());

   RETURN QUERY 
       SELECT 
             Object_ImportSettings_View.Id
           , Object_ImportSettings_View.Code
           , Object_ImportSettings_View.Name
         
           , Object_ImportSettings_View.JuridicalId
           , Object_ImportSettings_View.JuridicalName 
                     
         
           , Object_ImportSettings_View.FileTypeId
           , Object_ImportSettings_View.FileTypeName 
           
           , Object_ImportSettings_View.ImportTypeId
           , Object_ImportSettings_View.ImportTypeName 
           , Object_ImportSettings_View.StartRow
           , Object_ImportSettings_View.Directory
           , Object_ImportSettings_View.isErased
           
       FROM Object_ImportSettings_View

         ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.03.16         *
 03.03.16         *
 02.07.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ImportSettings ('2')

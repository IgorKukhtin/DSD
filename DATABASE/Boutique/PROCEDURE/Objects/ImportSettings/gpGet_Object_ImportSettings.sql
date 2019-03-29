-- Function: gpSelect_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpGet_Object_ImportSettings(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ImportSettings(
    IN inId          Integer , 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               FileTypeId Integer, FileTypeName TVarChar,
               ImportTypeId Integer, ImportTypeName TVarChar,
               StartRow Integer,
               Directory TVarChar, 
               isErased boolean, 
               ProcedureName TVarChar
               ) AS
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
           , Object_ImportSettings_View.ProcedureName
           
       FROM Object_ImportSettings_View
       WHERE Object_ImportSettings_View.Id = inId;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Подмогильный В.В.
 29.03.19         *
 09.02.18                                                           * 
 04.09.14                        *
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_ImportSettings (0,'2'::TVarChar)
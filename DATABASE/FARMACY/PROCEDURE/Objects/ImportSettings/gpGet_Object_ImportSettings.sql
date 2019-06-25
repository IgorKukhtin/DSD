-- Function: gpSelect_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpGet_Object_ImportSettings(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ImportSettings(
    IN inId          Integer , 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               ContractId Integer, ContractName TVarChar,
               FileTypeId Integer, FileTypeName TVarChar,
               ImportTypeId Integer, ImportTypeName TVarChar,
               StartRow Integer, HDR Boolean, 
               Directory TVarChar, Query TBlob, 
               isErased boolean, 
               ProcedureName TVarChar,
               JSONParamName TVarChar) AS
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
                     
           , Object_ImportSettings_View.ContractId
           , Object_ImportSettings_View.ContractName 
           
           , Object_ImportSettings_View.FileTypeId
           , Object_ImportSettings_View.FileTypeName 
           
           , Object_ImportSettings_View.ImportTypeId
           , Object_ImportSettings_View.ImportTypeName 
           
           , Object_ImportSettings_View.StartRow
           , Object_ImportSettings_View.HDR
           , Object_ImportSettings_View.Directory
           , Object_ImportSettings_View.Query 
           
           , Object_ImportSettings_View.isErased
           , Object_ImportSettings_View.ProcedureName
           , Object_ImportSettings_View.JSONParamName
           
       FROM Object_ImportSettings_View WHERE Object_ImportSettings_View.Id = inId;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ImportSettings(Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Подмогильный В.В.
 09.02.18                                                           * 
 04.09.14                        *
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_ImportSettings ('2')
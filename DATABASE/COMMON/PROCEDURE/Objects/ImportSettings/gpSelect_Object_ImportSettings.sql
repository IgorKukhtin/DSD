-- Function: gpSelect_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               ContractId Integer, ContractName TVarChar,
               FileTypeId Integer, FileTypeName TVarChar,
               ImportTypeId Integer, ImportTypeName TVarChar,
               StartRow TFloat,
               Directory TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportSettings());

   RETURN QUERY 
       SELECT 
             Object_ImportSettings.Id           AS Id
           , Object_ImportSettings.ObjectCode   AS Code
           , Object_ImportSettings.ValueData    AS Name
         
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName 
                     
           , Object_Contract.Id         AS ContractId
           , Object_Contract.ValueData  AS ContractName 
           
           , Object_FileType.Id         AS FileTypeId
           , Object_FileType.ValueData  AS FileTypeName 
           
           , Object_ImportType.Id         AS ImportTypeId
           , Object_ImportType.ValueData  AS ImportTypeName 
           
           , ObjectFloat_StartRow.ValueData   AS StartRow
           , ObjectString_Directory.ValueData AS Directory
           
           , Object_ImportSettings.isErased   AS isErased
           
       FROM Object AS Object_ImportSettings
           LEFT JOIN ObjectLink AS ObjectLink_ImportSettings_Juridical
                                ON ObjectLink_ImportSettings_Juridical.ObjectId = Object_ImportSettings.Id
                               AND ObjectLink_ImportSettings_Juridical.DescId = zc_ObjectLink_ImportSettings_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_ImportSettings_Juridical.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_ImportSettings_Contract
                                ON ObjectLink_ImportSettings_Contract.ObjectId = Object_ImportSettings.Id
                               AND ObjectLink_ImportSettings_Contract.DescId = zc_ObjectLink_ImportSettings_Contract()
           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ImportSettings_Contract.ChildObjectId           
           
           LEFT JOIN ObjectLink AS ObjectLink_ImportSettings_FileType
                                ON ObjectLink_ImportSettings_FileType.ObjectId = Object_ImportSettings.Id
                               AND ObjectLink_ImportSettings_FileType.DescId = zc_ObjectLink_ImportSettings_FileType()
           LEFT JOIN Object AS Object_FileType ON Object_FileType.Id = ObjectLink_ImportSettings_FileType.ChildObjectId 
   
           LEFT JOIN ObjectLink AS ObjectLink_ImportSettings_ImportType
                                ON ObjectLink_ImportSettings_ImportType.ObjectId = Object_ImportSettings.Id
                               AND ObjectLink_ImportSettings_ImportType.DescId = zc_ObjectLink_ImportSettings_ImportType()
           LEFT JOIN Object AS Object_ImportType ON Object_ImportType.Id = ObjectLink_ImportSettings_ImportType.ChildObjectId            

           LEFT JOIN ObjectFloat AS ObjectFloat_StartRow 
                                  ON ObjectFloat_StartRow.ObjectId = Object_ImportSettings.Id
                                 AND ObjectFloat_StartRow.DescId = zc_ObjectFloat_ImportSettings_StartRow()
                                         
           LEFT JOIN ObjectString AS ObjectString_Directory 
                                  ON ObjectString_Directory.ObjectId = Object_ImportSettings.Id
                                 AND ObjectString_Directory.DescId = zc_ObjectString_ImportSettings_Directory()
       WHERE Object_ImportSettings.DescId = zc_Object_ImportSettings();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ImportSettings(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ImportSettings ('2')
-- Function: gpGet_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpGet_Object_ImportSettings(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ImportSettings(
    IN inId          Integer,       -- Подразделение 
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Contract());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Contract()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName 
                     
           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName 
           
           , CAST (0 as Integer)    AS FileTypeId
           , CAST ('' as TVarChar)  AS FileTypeName 
           
           , CAST (0 as Integer)    AS ImportTypeId
           , CAST ('' as TVarChar)  AS ImportTypeName 
           
           , CAST (Null as TFloat)  AS StartRow
           , CAST ('' as TVarChar)  AS Directory
       
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Contract.Id           AS Id
           , Object_Contract.ObjectCode   AS Code
           , Object_Contract.ValueData    AS Name
         
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
           
           , Object_Contract.isErased       AS isErased
           
       FROM Object AS Object_Contract
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
                                  
      WHERE Object_Contract.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ImportSettings (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_ImportSettings(0,'2')
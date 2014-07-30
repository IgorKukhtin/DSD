-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_ImportSettings_View;

CREATE OR REPLACE VIEW Object_ImportSettings_View AS
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

ALTER TABLE Object_ImportSettings_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 24.07.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Goods_View

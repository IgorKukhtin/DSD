-- Function: gpSelect_Object_JuridicalLegalAddress()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalLegalAddress(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalLegalAddress(
    IN inJuridicalId Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , AddressId Integer, AddressCode Integer, AddressName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_JuridicalLegalAddress());

     RETURN QUERY  
       SELECT 
             Object_JuridicalLegalAddress.Id          AS Id
           , Object_JuridicalLegalAddress.ObjectCode  AS Code
           , Object_JuridicalLegalAddress.ValueData   AS Comment
           
           , Object_Juridical.Id                      AS JuridicalId
           , Object_Juridical.ObjectCode              AS JuridicalCode
           , Object_Juridical.ValueData               AS JuridicalName

           , Object_Address.Id                        AS AddressId
           , Object_Address.ObjectCode                AS AddressCode
           , Object_Address.ValueData                 AS AddressName

           , Object_JuridicalLegalAddress.isErased AS isErased
           
       FROM Object AS Object_JuridicalLegalAddress
            INNER JOIN ObjectLink AS ObjectLink_JuridicalLegalAddress_Juridical
                                  ON ObjectLink_JuridicalLegalAddress_Juridical.ObjectId = Object_JuridicalLegalAddress.Id 
                                 AND ObjectLink_JuridicalLegalAddress_Juridical.DescId = zc_ObjectLink_JuridicalLegalAddress_Juridical()
                                 AND (ObjectLink_JuridicalLegalAddress_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_JuridicalLegalAddress_Juridical.ChildObjectId       
            
            LEFT JOIN ObjectLink AS ObjectLink_JuridicalLegalAddress_LegalAddress
                                 ON ObjectLink_JuridicalLegalAddress_LegalAddress.ObjectId = Object_JuridicalLegalAddress.Id 
                                AND ObjectLink_JuridicalLegalAddress_LegalAddress.DescId = zc_ObjectLink_JuridicalLegalAddress_Address()
            LEFT JOIN Object AS Object_Address ON Object_Address.Id = ObjectLink_JuridicalLegalAddress_LegalAddress.ChildObjectId                     
   
     WHERE Object_JuridicalLegalAddress.DescId = zc_Object_JuridicalLegalAddress();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 28.05.18        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalLegalAddress(0, '3')
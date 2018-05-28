-- Function: gpSelect_Object_JuridicalActualAddress()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalActualAddress(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalActualAddress(
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_JuridicalActualAddress());

     RETURN QUERY  
       SELECT 
             Object_JuridicalActualAddress.Id          AS Id
           , Object_JuridicalActualAddress.ObjectCode  AS Code
           , Object_JuridicalActualAddress.ValueData   AS Comment
           
           , Object_Juridical.Id                      AS JuridicalId
           , Object_Juridical.ObjectCode              AS JuridicalCode
           , Object_Juridical.ValueData               AS JuridicalName

           , Object_Address.Id                        AS AddressId
           , Object_Address.ObjectCode                AS AddressCode
           , Object_Address.ValueData                 AS AddressName

           , Object_JuridicalActualAddress.isErased AS isErased
           
       FROM Object AS Object_JuridicalActualAddress
            INNER JOIN ObjectLink AS ObjectLink_JuridicalActualAddress_Juridical
                                  ON ObjectLink_JuridicalActualAddress_Juridical.ObjectId = Object_JuridicalActualAddress.Id 
                                 AND ObjectLink_JuridicalActualAddress_Juridical.DescId = zc_ObjectLink_JuridicalActualAddress_Juridical()
                                 AND (ObjectLink_JuridicalActualAddress_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_JuridicalActualAddress_Juridical.ChildObjectId       
            
            LEFT JOIN ObjectLink AS ObjectLink_JuridicalActualAddress_ActualAddress
                                 ON ObjectLink_JuridicalActualAddress_ActualAddress.ObjectId = Object_JuridicalActualAddress.Id 
                                AND ObjectLink_JuridicalActualAddress_ActualAddress.DescId = zc_ObjectLink_JuridicalActualAddress_Address()
            LEFT JOIN Object AS Object_Address ON Object_Address.Id = ObjectLink_JuridicalActualAddress_ActualAddress.ChildObjectId                     
   
     WHERE Object_JuridicalActualAddress.DescId = zc_Object_JuridicalActualAddress();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 28.05.18        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalActualAddress(0, '3')
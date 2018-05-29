-- Function: gpGet_Object_JuridicalLegalAddress()

DROP FUNCTION IF EXISTS gpGet_Object_JuridicalLegalAddress(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_JuridicalLegalAddress(
    IN inId          Integer,       -- ключ объекта <>
    IN inJuridicalId Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , AddressId Integer, AddressCode Integer, AddressName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_JuridicalLegalAddress());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT 
             CAST (0 as Integer)                AS Id                
           , Object_JuridicalLegalAddress.Code  AS Code
           , CAST ('' as TVarChar)              AS Comment
           
           , Object_Juridical.JuridicalId       AS JuridicalId
           , Object_Juridical.JuridicalCode     AS JuridicalCode
           , Object_Juridical.JuridicalName     AS JuridicalName
                                    
           , CAST (0 as Integer)                AS AddressId
           , CAST (0 as Integer)                AS AddressCode
           , CAST ('' as TVarChar)              AS AddressName

           , CAST (NULL AS Boolean)             AS isErased
       FROM (SELECT
             COALESCE (MAX (Object_JuridicalLegalAddress.ObjectCode), 0) + 1 AS Code
       FROM Object AS Object_JuridicalLegalAddress
       WHERE Object_JuridicalLegalAddress.DescId = zc_Object_JuridicalLegalAddress()) AS Object_JuridicalLegalAddress
         LEFT JOIN (SELECT
             Object_Juridical.Id           AS JuridicalId
           , Object_Juridical.ObjectCode   AS JuridicalCode
           , Object_Juridical.ValueData    AS JuridicalName
       FROM Object AS Object_Juridical       
       WHERE Object_Juridical.Id = inJuridicalId) AS Object_Juridical ON 1 = 1;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_JuridicalLegalAddress.Id          AS Id
           , Object_JuridicalLegalAddress.ObjectCode  AS Code
           , Object_JuridicalLegalAddress.ValueData   AS Comment
           
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName

           , Object_Address.Id                   AS AddressId
           , Object_Address.ObjectCode           AS AddressCode
           , Object_Address.ValueData            AS AddressName
           
           , Object_JuridicalLegalAddress.isErased    AS isErased
           
       FROM Object AS Object_JuridicalLegalAddress
       
           LEFT JOIN ObjectLink AS ObjectLink_JuridicalLegalAddress_Juridical
                                ON ObjectLink_JuridicalLegalAddress_Juridical.ObjectId = Object_JuridicalLegalAddress.Id 
                               AND ObjectLink_JuridicalLegalAddress_Juridical.DescId = zc_ObjectLink_JuridicalLegalAddress_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_JuridicalLegalAddress_Juridical.ChildObjectId       
           
           LEFT JOIN ObjectLink AS ObjectLink_JuridicalLegalAddress_Address
                                ON ObjectLink_JuridicalLegalAddress_Address.ObjectId = Object_JuridicalLegalAddress.Id 
                               AND ObjectLink_JuridicalLegalAddress_Address.DescId = zc_ObjectLink_JuridicalLegalAddress_Address()
           LEFT JOIN Object AS Object_Address ON Object_Address.Id = ObjectLink_JuridicalLegalAddress_Address.ChildObjectId        
   
       WHERE Object_JuridicalLegalAddress.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 28.05.18        *
*/

-- тест
-- select * from gpGet_Object_JuridicalLegalAddress(inId := 0 , inJuridicalId := 59610 ,  inSession := '3');

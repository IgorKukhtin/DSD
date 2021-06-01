-- Function: gpGet_Object_Partner_Category()

DROP FUNCTION IF EXISTS gpGet_Object_Partner_Category (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner_Category(
    IN inId          Integer,        -- Контрагенты 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               Address TVarChar,
               Category TFloat,
               JuridicalId Integer, JuridicalName TVarChar
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Category());

       RETURN QUERY 
       SELECT 
             Object_Partner.Id          :: Integer AS Id
           , Object_Partner.ObjectCode  :: Integer AS Code
           , Object_Partner.ValueData   :: TVarChar AS Name

           , ObjectString_Address.ValueData     AS Address

           , COALESCE (ObjectFloat_Category.ValueData,0) ::TFloat  AS Category

           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName
           
       FROM Object AS Object_Partner
           LEFT JOIN ObjectString AS ObjectString_Address
                                  ON ObjectString_Address.ObjectId = Object_Partner.Id
                                 AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
  
           LEFT JOIN ObjectFloat AS ObjectFloat_Category
                                 ON ObjectFloat_Category.ObjectId = Object_Partner.Id
                                AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()

           LEFT JOIN ObjectLink AS Partner_Juridical
                                ON Partner_Juridical.ObjectId = Object_Partner.Id 
                               AND Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Partner_Juridical.ChildObjectId
       WHERE Object_Partner.Id = inId
;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.21         *
*/

-- тест
-- 
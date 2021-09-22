-- Function: gpGet_Object_MemberIC (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberIC (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberIC(
    IN inId          Integer,        -- ФИО покупателя (Страховой компании)
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InsuranceCompaniesId Integer, InsuranceCompaniesName TVarChar
             , InsuranceCardNumber	 TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MemberIC());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MemberIC()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (0 as Integer)    AS InsuranceCompaniesId
           , CAST ('' as TVarChar)  AS InsuranceCompaniesName
           , Null     :: TVarChar   AS InsuranceCardNumber	
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_MemberIC.Id                     AS Id
            , Object_MemberIC.ObjectCode             AS Code
            , Object_MemberIC.ValueData              AS Name
            , Object_InsuranceCompanies.Id           AS InsuranceCompaniesId
            , Object_InsuranceCompanies.ValueData    AS InsuranceCompaniesName
            , COALESCE (ObjectString_InsuranceCardNumber	.ValueData, '')       :: TVarChar  AS InsuranceCardNumber	
            , Object_MemberIC.isErased               AS isErased
       FROM Object AS Object_MemberIC

         LEFT JOIN ObjectString AS ObjectString_InsuranceCardNumber	
                                ON ObjectString_InsuranceCardNumber	.ObjectId = Object_MemberIC.Id
                               AND ObjectString_InsuranceCardNumber	.DescId = zc_ObjectString_MemberIC_InsuranceCardNumber	()

         LEFT JOIN ObjectLink AS ObjectLink_MemberIC_InsuranceCompanies
                              ON ObjectLink_MemberIC_InsuranceCompanies.ObjectId = Object_MemberIC.Id
                             AND ObjectLink_MemberIC_InsuranceCompanies.DescId = zc_ObjectLink_MemberIC_InsuranceCompanies()
         LEFT JOIN Object AS Object_InsuranceCompanies ON Object_InsuranceCompanies.Id = ObjectLink_MemberIC_InsuranceCompanies.ChildObjectId
 
       WHERE Object_MemberIC.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.09.21                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberIC(0,'3')
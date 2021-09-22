-- Function: gpSelect_Object_MemberIC(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberIC(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberIC(
    IN inInsuranceCompaniesId   Integer  ,     -- Страховые компании 
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InsuranceCompaniesId Integer, InsuranceCompaniesName TVarChar
             , InsuranceCardNumber TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberIC());

   RETURN QUERY 
     SELECT Object_MemberIC.Id                 AS Id
          , Object_MemberIC.ObjectCode         AS Code
          , Object_MemberIC.ValueData          AS Name
          , Object_InsuranceCompanies.Id           AS InsuranceCompaniesId
          , Object_InsuranceCompanies.ValueData    AS InsuranceCompaniesName
          , COALESCE (ObjectString_InsuranceCardNumber.ValueData, '')       :: TVarChar  AS InsuranceCardNumber
          , Object_MemberIC.isErased           AS isErased
     FROM OBJECT AS Object_MemberIC

         LEFT JOIN ObjectString AS ObjectString_InsuranceCardNumber
                                ON ObjectString_InsuranceCardNumber.ObjectId = Object_MemberIC.Id
                               AND ObjectString_InsuranceCardNumber.DescId = zc_ObjectString_MemberIC_InsuranceCardNumber()

         LEFT JOIN ObjectLink AS ObjectLink_MemberIC_InsuranceCompanies
                              ON ObjectLink_MemberIC_InsuranceCompanies.ObjectId = Object_MemberIC.Id
                             AND ObjectLink_MemberIC_InsuranceCompanies.DescId = zc_ObjectLink_MemberIC_InsuranceCompanies()
         LEFT JOIN Object AS Object_InsuranceCompanies ON Object_InsuranceCompanies.Id = ObjectLink_MemberIC_InsuranceCompanies.ChildObjectId


     WHERE Object_MemberIC.DescId = zc_Object_MemberIC()
       AND (ObjectLink_MemberIC_InsuranceCompanies.ChildObjectId = inInsuranceCompaniesId OR inInsuranceCompaniesId = 0);
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.09.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_MemberIC(0, '3')
-- Function: gpSelect_Object_ExportJuridical (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ExportJuridical (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ExportJuridical(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EmailKindCode Integer, EmailKindName TVarChar
             , RetailCode Integer, RetailName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , ContractCode Integer, ContractName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ExportKindCode Integer, ExportKindName TVarChar
             , ContactPersonCode Integer, ContactPersonName TVarChar
             , ContactPersonMail TVarChar
             , isAuto Boolean
             , isErased Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ExportJuridical());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_ExportJuridical.Id          AS Id
           , Object_ExportJuridical.ObjectCode  AS Code
           , Object_ExportJuridical.ValueData   AS Name
           
           , Object_EmailKind.ObjectCode               AS EmailKindCode
           , Object_EmailKind.ValueData                AS EmailKindName

           , Object_Retail.ObjectCode                  AS RetailCode
           , Object_Retail.ValueData                   AS RetailName
         
           , Object_Juridical.ObjectCode               AS JuridicalCode
           , Object_Juridical.ValueData                AS JuridicalName

           , Object_Contract.ObjectCode                AS ContractCode
           , Object_Contract.ValueData                 AS ContractName

           , Object_InfoMoney.ObjectCode               AS InfoMoneyCode
           , Object_InfoMoney.ValueData                AS InfoMoneyName        

           , Object_ExportKind.ObjectCode              AS ExportKindCode
           , Object_ExportKind.ValueData               AS ExportKindName
           
           , Object_ContactPerson.ObjectCode           AS ContactPersonCode
           , Object_ContactPerson.ValueData            AS ContactPersonName           
           , ObjectString_ContactPersonMail.ValueData  AS ContactPersonMail
              
           , COALESCE (ObjectBoolean_Auto.ValueData, FALSE) ::Boolean AS isAuto
           , Object_ExportJuridical.isErased    AS isErased
           
       FROM Object AS Object_ExportJuridical
            LEFT JOIN ObjectLink AS ObjectLink_EmailKind 
                                 ON ObjectLink_EmailKind.ObjectId = Object_ExportJuridical.Id
                                AND ObjectLink_EmailKind.DescId = zc_ObjectLink_ExportJuridical_EmailKind()
            LEFT JOIN Object AS Object_EmailKind ON Object_EmailKind.Id = ObjectLink_EmailKind.ChildObjectId

            LEFT JOIN ObjectLink AS ExportJuridical_Retail 
                                 ON ExportJuridical_Retail.ObjectId = Object_ExportJuridical.Id
                                AND ExportJuridical_Retail.DescId = zc_ObjectLink_ExportJuridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ExportJuridical_Retail.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ExportJuridical_Juridical 
                                 ON ObjectLink_ExportJuridical_Juridical.ObjectId = Object_ExportJuridical.Id
                                AND ObjectLink_ExportJuridical_Juridical.DescId = zc_ObjectLink_ExportJuridical_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_ExportJuridical_Juridical.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ExportJuridical_Contract
                                 ON ObjectLink_ExportJuridical_Contract.ObjectId = Object_ExportJuridical.Id
                                AND ObjectLink_ExportJuridical_Contract.DescId = zc_ObjectLink_ExportJuridical_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ExportJuridical_Contract.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ExportJuridical_InfoMoney 
                                 ON ObjectLink_ExportJuridical_InfoMoney.ObjectId = Object_ExportJuridical.Id
                                AND ObjectLink_ExportJuridical_InfoMoney.DescId = zc_ObjectLink_ExportJuridical_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_ExportJuridical_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ExportJuridical_ExportKind 
                                 ON ObjectLink_ExportJuridical_ExportKind.ObjectId = Object_ExportJuridical.Id
                                AND ObjectLink_ExportJuridical_ExportKind.DescId = zc_ObjectLink_ExportJuridical_ExportKind()
            LEFT JOIN Object AS Object_ExportKind ON Object_ExportKind.Id = ObjectLink_ExportJuridical_ExportKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ExportJuridical_ContactPerson 
                                 ON ObjectLink_ExportJuridical_ContactPerson.ObjectId = Object_ExportJuridical.Id
                                AND ObjectLink_ExportJuridical_ContactPerson.DescId = zc_ObjectLink_ExportJuridical_ContactPerson()
            LEFT JOIN Object AS Object_ContactPerson ON Object_ContactPerson.Id = ObjectLink_ExportJuridical_ContactPerson.ChildObjectId            
           
            LEFT JOIN ObjectString AS ObjectString_ContactPersonMail
                                   ON ObjectString_ContactPersonMail.ObjectId = Object_ContactPerson.Id
                                  AND ObjectString_ContactPersonMail.DescId = zc_ObjectString_ContactPerson_Mail()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Auto
                                    ON ObjectBoolean_Auto.ObjectId = Object_ExportJuridical.Id
                                   AND ObjectBoolean_Auto.DescId = zc_ObjectBoolean_ExportJuridical_Auto()
     WHERE Object_ExportJuridical.DescId = zc_Object_ExportJuridical()
     
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ExportJuridical (zfCalc_UserAdmin())


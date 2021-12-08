-- Function: gpGet_Object_ExportJuridical (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ExportJuridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ExportJuridical(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , EmailKindId Integer, EmailKindCode Integer, EmailKindName TVarChar
             , RetailId Integer, RetailCode Integer, RetailName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ExportKindId Integer, ExportKindCode Integer, ExportKindName TVarChar
             , ContactPersonId Integer, ContactPersonCode Integer, ContactPersonName TVarChar
             , ContactPersonMail TVarChar
             , isAuto Boolean
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ExportJuridical());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_ExportJuridical.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)    AS EmailKindId
           , CAST (0 as Integer)    AS EmailKindCode
           , CAST ('' as TVarChar)  AS EmailKindName

           , CAST (0 as Integer)    AS RetailId
           , CAST (0 as Integer)    AS RetailCode
           , CAST ('' as TVarChar)  AS RetailName
          
           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (0 as Integer)    AS ContractId
           , CAST (0 as Integer)    AS ContractCode
           , CAST ('' as TVarChar)  AS ContractName

           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST (0 as Integer)    AS InfoMoneyCode
           , CAST ('' as TVarChar)  AS InfoMoneyName
          
           , CAST (0 as Integer)    AS ExportKindId
           , CAST (0 as Integer)    AS ExportKindCode
           , CAST ('' as TVarChar)  AS ExportKindName
           
           , CAST (0 as Integer)    AS ContactPersonId
           , CAST (0 as Integer)    AS ContactPersonCode
           , CAST ('' as TVarChar)  AS ContactPersonName
           , CAST ('' as TVarChar)  AS ContactPersonMail

           , CAST (FALSE AS Boolean) AS isAuto
           , CAST (FALSE AS Boolean) AS isErased

       FROM Object AS Object_ExportJuridical
       WHERE Object_ExportJuridical.DescId = zc_Object_ExportJuridical();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ExportJuridical.Id          AS Id
           , Object_ExportJuridical.ObjectCode  AS Code
           , Object_ExportJuridical.ValueData   AS Name

           , Object_EmailKind.Id          AS EmailKindId
           , Object_EmailKind.ObjectCode  AS EmailKindCode
           , Object_EmailKind.ValueData   AS EmailKindName
           
           , Object_Retail.Id         AS RetailId
           , Object_Retail.ObjectCode AS RetailCode
           , Object_Retail.ValueData  AS RetailName
         
           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName

           , Object_Contract.Id           AS ContractId
           , Object_Contract.ObjectCode   AS ContractCode
           , Object_Contract.ValueData    AS ContractName

           , Object_InfoMoney.Id          AS InfoMoneyId
           , Object_InfoMoney.ObjectCode  AS InfoMoneyCode
           , Object_InfoMoney.ValueData   AS InfoMoneyName        

           , Object_ExportKind.Id          AS ExportKindId
           , Object_ExportKind.ObjectCode  AS ExportKindCode
           , Object_ExportKind.ValueData   AS ExportKindName
           
           , Object_ContactPerson.Id          AS ContactPersonId
           , Object_ContactPerson.ObjectCode  AS ContactPersonCode
           , Object_ContactPerson.ValueData   AS ContactPersonName
           , ObjectString_ContactPersonMail.ValueData  AS ContactPersonMail           
           
           , COALESCE (ObjectBoolean_Auto.ValueData, FALSE) ::Boolean AS isAuto
           , Object_ExportJuridical.isErased AS isErased
           
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

       WHERE Object_ExportJuridical.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ExportJuridical (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.21         * isAuto
 23.03.16         * 
        
*/

-- тест
-- SELECT * FROM gpGet_Object_ExportJuridical (2, '')

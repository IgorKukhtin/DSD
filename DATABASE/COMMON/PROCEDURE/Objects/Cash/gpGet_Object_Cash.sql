-- Function: gpGet_Object_Cash (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Cash(
    IN inId          Integer,       -- Касса 
    IN inSession     TVarChar       -- текущий пользователь 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CurrencyId Integer, CurrencyName TVarChar,
               BranchId Integer, BranchName TVarChar, 
               JuridicalBasisId Integer, JuridicalBasisName TVarChar,
               BusinessId Integer, BusinessName TVarChar,
               PaidKindId Integer, PaidKindName TVarChar,
               isNotCurrencyDiff Boolean
               ) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Cash()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)    AS CurrencyId
           , CAST ('' as TVarChar)  AS CurrencyName
           , CAST (0 as Integer)    AS BranchId
           , CAST ('' as TVarChar)  AS BranchName
           , CAST (0 as Integer)    AS JuridicalBasisId
           , CAST ('' as TVarChar)  AS JuridicalBasisName
           , CAST (0 as Integer)    AS BusinessId
           , CAST ('' as TVarChar)  AS BusinessName
           , CAST (0 as Integer)    AS PaidKindId
           , CAST ('' as TVarChar)  AS PaidKindName
           , CAST (FALSE AS Boolean) AS isNotCurrencyDiff
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id          AS Id
           , Object.ObjectCode  AS Code
           , Object.ValueData   AS Name
           , Object.isErased    AS isErased
           , Currency.Id        AS CurrencyId
           , Currency.ValueData AS CurrencyName
           , Branch.Id          AS BranchId
           , Branch.ValueData   AS BranchName
           , JuridicalBasis.Id   AS JuridicalBasisId
           , JuridicalBasis.ValueData  AS JuridicalBasisName
           , Business.Id        AS BusinessId
           , Business.ValueData AS BusinessName
           , PaidKind.Id        AS PaidKindId
           , PaidKind.ValueData AS PaidKindName 
           , COALESCE (ObjectBoolean_notCurrencyDiff.ValueData, FALSE) ::Boolean AS isNotCurrencyDiff          
       FROM Object
           LEFT JOIN ObjectLink AS Cash_Currency
                           ON Cash_Currency.ObjectId = Object.Id
                          AND Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
           LEFT JOIN Object AS Currency ON Currency.Id = Cash_Currency.ChildObjectId
           
           LEFT JOIN ObjectLink AS Cash_Branch
                                ON Cash_Branch.ObjectId = Object.Id
                               AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
           LEFT JOIN Object AS Branch ON Branch.Id = Cash_Branch.ChildObjectId
           
           LEFT JOIN ObjectLink AS Cash_JuridicalBasis
                                ON Cash_JuridicalBasis.ObjectId = Object.Id
                               AND Cash_JuridicalBasis.DescId = zc_ObjectLink_Cash_JuridicalBasis()
           LEFT JOIN Object AS JuridicalBasis ON JuridicalBasis.Id = Cash_JuridicalBasis.ChildObjectId
           
           LEFT JOIN ObjectLink AS Cash_Business
                                ON Cash_Business.ObjectId = Object.Id
                               AND Cash_Business.DescId = zc_ObjectLink_Cash_Business()
           LEFT JOIN Object AS Business ON Business.Id = Cash_Business.ChildObjectId
           
           LEFT JOIN ObjectLink AS Cash_PaidKind
                                ON Cash_PaidKind.ObjectId = Object.Id
                               AND Cash_PaidKind.DescId = zc_ObjectLink_Cash_PaidKind()
           LEFT JOIN Object AS PaidKind ON PaidKind.Id = Cash_PaidKind.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_notCurrencyDiff
                                   ON ObjectBoolean_notCurrencyDiff.ObjectId = Object.Id
                                  AND ObjectBoolean_notCurrencyDiff.DescId = zc_ObjectBoolean_Cash_notCurrencyDiff()                      
       WHERE Object.Id = inId;
   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Cash (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.11.14         * add PaidKind
 28.12.13                                        * rename to zc_ObjectLink_Cash_JuridicalBasis
 11.06.13         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Cash (1, zfCalc_UserAdmin())

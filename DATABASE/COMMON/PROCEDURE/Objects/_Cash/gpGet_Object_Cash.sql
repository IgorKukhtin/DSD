-- Function: gpGet_Object_Cash()

--DROP FUNCTION gpGet_Object_Cash();

CREATE OR REPLACE FUNCTION gpGet_Object_Cash(
    IN inId          Integer,       -- Касса 
    IN inSession     TVarChar       -- текущий пользователь 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CurrencyId Integer, CurrencyName TVarChar, BranchId Integer, BranchName TVarChar, 
               MainJuridicalId Integer, MainJuridicalName TVarChar, BusinessId Integer, BusinessName TVarChar) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(zc_Object_Cash(), inCode) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)    AS CurrencyId
           , CAST ('' as TVarChar)  AS CurrencyName
           , CAST (0 as Integer)    AS BranchId
           , CAST ('' as TVarChar)  AS BranchName
           , CAST (0 as Integer)    AS MainJuridicalId
           , CAST ('' as TVarChar)  AS MainJuridicalName
           , CAST (0 as Integer)    AS BusinessId
           , CAST ('' as TVarChar)  AS BusinessName;
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
           , MainJuridical.Id   AS MainJuridicalId
           , MainJuridical.ValueData  AS MainJuridicalName
           , Business.Id        AS BusinessId
           , Business.ValueData AS BusinessName
       FROM Object
           JOIN ObjectLink AS Cash_Currency
                           ON Cash_Currency.ObjectId = Object.Id
                          AND Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
           JOIN Object AS Currency ON Currency.Id = Cash_Currency.ChildObjectId
           LEFT JOIN ObjectLink AS Cash_Branch
                                ON Cash_Branch.ObjectId = Object.Id
                               AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
           LEFT JOIN Object AS Branch ON Branch.Id = Cash_Branch.ChildObjectId
           LEFT JOIN ObjectLink AS Cash_MainJuridical
                                ON Cash_MainJuridical.ObjectId = Object.Id
                               AND Cash_MainJuridical.DescId = zc_ObjectLink_Cash_MainJuridical()
           LEFT JOIN Object AS MainJuridical ON MainJuridical.Id = Cash_MainJuridical.ChildObjectId
           LEFT JOIN ObjectLink AS Cash_Business
                                ON Cash_Business.ObjectId = Object.Id
                               AND Cash_Business.DescId = zc_ObjectLink_Cash_Business()
           LEFT JOIN Object AS Business ON Business.Id = Cash_Business.ChildObjectId
       WHERE Object.Id = inId;
   END IF;  
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Cash(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 03.06.13

*/

-- тест
-- SELECT * FROM gpSelect_Cash(1,'2')
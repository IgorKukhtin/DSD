-- Function: gpGet_Object_Cash()

--DROP FUNCTION gpGet_Object_Cash();

CREATE OR REPLACE FUNCTION gpGet_Object_Cash(
    IN inId          Integer,       -- Касса 
    IN inSession     TVarChar       -- текущий пользователь 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CurrencyId Integer, CurrencyName TVarChar, BranchId Integer, BranchName TVarChar, PaidKindId Integer, PaidKindName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());


   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)    AS CurrencyId
           , CAST ('' as TVarChar)  AS CurrencyName
           , CAST (0 as Integer)    AS BranchId
           , CAST ('' as TVarChar)  AS BranchName
           , CAST (0 as Integer)    AS PaidKindId
           , CAST ('' as TVarChar)  AS PaidKindName          
       FROM Object 
       WHERE Object.DescId = zc_Object_Cash();
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
           , PaidKind.Id        AS PaidKindId
           , PaidKind.ValueData AS PaidKindName
       FROM Object
       JOIN ObjectLink AS Cash_Currency
         ON Cash_Currency.ObjectId = Object.Id
        AND Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
       JOIN Object AS Currency
         ON Currency.Id = Cash_Currency.ChildObjectId
  LEFT JOIN ObjectLink AS Cash_Branch
         ON Cash_Branch.ObjectId = Object.Id
        AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
  LEFT JOIN Object AS Branch
         ON Branch.Id = Cash_Branch.ChildObjectId
  LEFT JOIN ObjectLink AS Cash_PaidKind
         ON Cash_PaidKind.ObjectId = Object.Id
        AND Cash_PaidKind.DescId = zc_ObjectLink_Cash_PaidKind()
  LEFT JOIN Object AS PaidKind
         ON Branch.Id = Cash_PaidKind.ChildObjectId
       WHERE Object.Id = inId;
   END IF;  
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Cash(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 03.06.13

*/

-- тест
-- SELECT * FROM gpSelect_Cash(1,'2')
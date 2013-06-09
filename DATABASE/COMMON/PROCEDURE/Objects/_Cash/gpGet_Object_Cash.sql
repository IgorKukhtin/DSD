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

     RETURN QUERY 
     SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData
     , Object.isErased
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
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Cash(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')
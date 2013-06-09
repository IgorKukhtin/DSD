-- Function: gpSelect_Object_Cash()

--DROP FUNCTION gpSelect_Object_Cash();

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash(
    IN inSession     TVarChar       -- текущий пользователь
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CurrencyName TVarChar) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode
   , Object.ValueData
   , Object.isErased
   , Currency.ValueData AS CurrencyName
   FROM Object
   JOIN ObjectLink 
     ON ObjectLink.ObjectId = Object.Id
    AND ObjectLink.DescId = zc_ObjectLink_Cash_Currency()
   JOIN Object AS Currency
     ON Currency.Id = ObjectLink.ChildObjectId
   WHERE Object.DescId = zc_Object_Cash();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Cash(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_Cash('2')
-- Function: gpGet_Object_Cash (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Cash(
    IN inId          Integer,       -- Касса 
    IN inSession     TVarChar       -- текущий пользователь 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , CurrencyId Integer, CurrencyName TVarChar
             , ParentId Integer, ParentName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ShortName TVarChar
             , NPP TFloat
             , isUserAll Boolean
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
           , CAST (0 as Integer)    AS ParentId
           , CAST ('' as TVarChar)  AS ParentName
           , CAST (0 as Integer)    AS PaidKindId
           , CAST ('' as TVarChar)  AS PaidKindName
           , CAST ('' as TVarChar)  AS ShortName
           , CAST (0 as TFloat)     AS NPP
           , CAST (FALSE as Boolean)  AS isUserAll
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Cash.Id                 AS Id
           , Object_Cash.ObjectCode         AS Code
           , Object_Cash.ValueData          AS Name
           , Object_Cash.isErased           AS isErased
           , Object_Currency.Id        AS CurrencyId
           , Object_Currency.ValueData AS CurrencyName
           , Object_Parent.Id          AS ParentId
           , Object_Parent.ValueData   AS ParentName
           , Object_PaidKind.Id        AS PaidKindId
           , Object_PaidKind.ValueData AS PaidKindName
           , ObjectString_ShortName.ValueData     AS ShortName
           , ObjectFloat_NPP.ValueData   ::TFloat AS NPP
           , COALESCE (ObjectBoolean_UserAll.ValueData, FALSE) ::Boolean AS isUserAll           
       FROM Object AS Object_Cash
        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_Cash.Id
                              AND ObjectString_ShortName.DescId = zc_ObjectString_Cash_ShortName()

        LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                              ON ObjectFloat_NPP.ObjectId = Object_Cash.Id
                             AND ObjectFloat_NPP.DescId = zc_ObjectFloat_Cash_NPP()

        LEFT JOIN ObjectLink AS ObjectLink_Currency
                             ON ObjectLink_Currency.ObjectId = Object_Cash.Id
                            AND ObjectLink_Currency.DescId = zc_ObjectLink_Cash_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Currency.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Parent
                             ON ObjectLink_Parent.ObjectId = Object_Cash.Id
                            AND ObjectLink_Parent.DescId = zc_ObjectLink_Cash_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Parent.ChildObjectId
          
        LEFT JOIN ObjectLink AS ObjectLink_PaidKind
                             ON ObjectLink_PaidKind.ObjectId = Object_Cash.Id
                            AND ObjectLink_PaidKind.DescId = zc_ObjectLink_Cash_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_PaidKind.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                ON ObjectBoolean_UserAll.ObjectId = Object_Cash.Id
                               AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_Cash_UserAll()

       WHERE Object_Cash.Id = inId;
   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Cash (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.22         *
 25.11.14         * add PaidKind
 28.12.13                                        * rename to zc_ObjectLink_Cash_JuridicalBasis
 11.06.13         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Cash (1, zfCalc_UserAdmin())

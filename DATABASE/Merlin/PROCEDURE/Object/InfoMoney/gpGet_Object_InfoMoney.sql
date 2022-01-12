-- Function: gpGet_Object_InfoMoney (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_InfoMoney (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InfoMoney(
    IN inId          Integer,       --  
    IN inSession     TVarChar       -- текущий пользователь 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
             , ParentId Integer, ParentName TVarChar
             , isUserAll Boolean, isService Boolean
               ) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_InfoMoney()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)    AS InfoMoneyKindId
           , CAST ('' as TVarChar)  AS InfoMoneyKindName
           , CAST (0 as Integer)    AS ParentId
           , CAST ('' as TVarChar)  AS ParentName
           , CAST (FALSE as Boolean)  AS isUserAll
           , CAST (FALSE as Boolean)  AS isService
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_InfoMoney.Id                 AS Id
           , Object_InfoMoney.ObjectCode         AS Code
           , Object_InfoMoney.ValueData          AS Name
           , Object_InfoMoneyKind.Id             AS InfoMoneyKindId
           , Object_InfoMoneyKind.ValueData      AS InfoMoneyKindName
           , COALESCE(Object_Parent.Id,0)        AS ParentId
           , Object_Parent.ValueData             AS ParentName
           , COALESCE (ObjectBoolean_UserAll.ValueData, FALSE) ::Boolean AS isUserAll
           , COALESCE (ObjectBoolean_Service.ValueData, FALSE) ::Boolean AS isService         
       FROM Object AS Object_InfoMoney

        LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                ON ObjectBoolean_UserAll.ObjectId = Object_InfoMoney.Id
                               AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoney_UserAll()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Service
                                ON ObjectBoolean_Service.ObjectId = Object_InfoMoney.Id
                               AND ObjectBoolean_Service.DescId = zc_ObjectBoolean_InfoMoney_Service()

        LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyKind
                             ON ObjectLink_InfoMoneyKind.ObjectId = Object_InfoMoney.Id
                            AND ObjectLink_InfoMoneyKind.DescId = zc_ObjectLink_InfoMoney_InfoMoneyKind()
        LEFT JOIN Object AS Object_InfoMoneyKind ON Object_InfoMoneyKind.Id = ObjectLink_InfoMoneyKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Parent
                             ON ObjectLink_Parent.ObjectId = Object_InfoMoney.Id
                            AND ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Parent.ChildObjectId
                      
       WHERE Object_InfoMoney.Id = inId;
   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_InfoMoney (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.11.14         * add PaidKind
 28.12.13                                        * rename to zc_ObjectLink_InfoMoney_JuridicalBasis
 11.06.13         *
*/

-- тест
-- SELECT * FROM gpGet_Object_InfoMoney (1, zfCalc_UserAdmin())

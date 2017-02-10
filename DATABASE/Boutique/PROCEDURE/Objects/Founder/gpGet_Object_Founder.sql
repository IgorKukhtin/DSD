-- Function: gpGet_Object_Founder()

DROP FUNCTION IF EXISTS gpGet_Object_Founder (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Founder(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , LimitMoney TFloat)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Founder());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Founder()) AS Code
           , CAST ('' AS TVarChar)  AS Name
          
           , CAST (0 AS Integer)    AS InfoMoneyId
           , CAST ('' AS TVarChar)  AS InfoMoneyName

           , CAST (0 AS TFloat)     AS LimitMoney;
   ELSE
       RETURN QUERY
       SELECT
             Object_Founder.Id         AS Id
           , Object_Founder.ObjectCode AS Code
           , Object_Founder.ValueData  AS Name

           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName_all AS InfoMoneyName

           , COALESCE(ObjectFloat_Limit.ValueData, 0) ::TFloat AS LimitMoney

       FROM Object AS Object_Founder
           LEFT JOIN ObjectLink AS ObjectLink_Founder_InfoMoney
                                ON ObjectLink_Founder_InfoMoney.ObjectId = Object_Founder.Id
                               AND ObjectLink_Founder_InfoMoney.DescId = zc_ObjectLink_Founder_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Founder_InfoMoney.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_Limit
                                 ON ObjectFloat_Limit.ObjectId = Object_Founder.Id
                                AND ObjectFloat_Limit.DescId = zc_ObjectFloat_Founder_Limit()

       WHERE Object_Founder.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Founder (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.01.16         * 
 21.09.14                                        *
 01.09.14         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Founder (0, '2')

-- Function: gpSelect_Object_Founder()

DROP FUNCTION IF EXISTS gpSelect_Object_Founder(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Founder(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , LimitMoney TFloat
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Founder());
     vbUserId:= lpGetUserBySession (inSession);

     -- Блокируем ему просмотр
     IF 1=0 AND vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     -- Результат
   RETURN QUERY
   SELECT
          Object_Founder.Id         AS Id
        , Object_Founder.ObjectCode AS Code
        , Object_Founder.ValueData  AS Name

       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all
      
       , COALESCE(ObjectFloat_Limit.ValueData, 0) ::TFloat       AS LimitMoney
       
       , Object_Founder.isErased    AS isErased
   FROM Object AS Object_Founder
           LEFT JOIN ObjectLink AS ObjectLink_Founder_InfoMoney
                                ON ObjectLink_Founder_InfoMoney.ObjectId = Object_Founder.Id
                               AND ObjectLink_Founder_InfoMoney.DescId = zc_ObjectLink_Founder_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Founder_InfoMoney.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_Limit
                                 ON ObjectFloat_Limit.ObjectId = Object_Founder.Id
                                AND ObjectFloat_Limit.DescId = zc_ObjectFloat_Founder_Limit()

   WHERE Object_Founder.DescId = zc_Object_Founder();

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Founder(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 28.01.16         * 
 20.09.14                                        *
 01.09.14         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_Founder ('2')

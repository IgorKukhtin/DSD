-- Function: gpGet_Object_Member (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,        -- Физические лица 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
            , INN TVarChar, DriverCertificate TVarChar
            , Card TVarChar, CardSecond TVarChar, CardChild TVarChar
            , Comment TVarChar
            , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
            , BankId Integer, BankName TVarChar
            , BankSecondId Integer, BankSecondName TVarChar
            , BankChildId Integer, BankChildName TVarChar
            , isOfficial Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Member());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Member()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS INN
           , CAST ('' as TVarChar)  AS DriverCertificate
           , CAST ('' as TVarChar)  AS Card
           , CAST ('' as TVarChar)  AS CardSecond
           , CAST ('' as TVarChar)  AS CardChild
           , CAST ('' as TVarChar)  AS Comment
           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST (0 as Integer)    AS InfoMoneyCode
           , CAST ('' as TVarChar)  AS InfoMoneyName   
           , CAST ('' as TVarChar)  AS InfoMoneyName_all  

           , CAST (0 as Integer)    AS BankId
           , CAST ('' as TVarChar)  AS BankName 
           , CAST (0 as Integer)    AS BankSecondId
           , CAST ('' as TVarChar)  AS BankSecondName 
           , CAST (0 as Integer)    AS BankChildId
           , CAST ('' as TVarChar)  AS BankChildName 
     
           , FALSE AS isOfficial;
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Member.Id         AS Id
         , Object_Member.ObjectCode AS Code
         , Object_Member.ValueData  AS Name
         
         , ObjectString_INN.ValueData               AS INN
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Card.ValueData              AS Card
         , ObjectString_CardSecond.ValueData        AS CardSecond3
         , ObjectString_CardChild.ValueData         AS CardChild
         , ObjectString_Comment.ValueData           AS Comment
         
         , Object_InfoMoney_View.InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyName_all

         , Object_Bank.Id               AS BankId
         , Object_Bank.ValueData        AS BankName
         , Object_BankSecond.Id         AS BankSecondId
         , Object_BankSecond.ValueData  AS BankSecondName
         , Object_BankChild.Id          AS BankChildId
         , Object_BankChild.ValueData   AS BankChildName

         , ObjectBoolean_Official.ValueData         AS isOfficial

     FROM Object AS Object_Member
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                  ON ObjectBoolean_Official.ObjectId = Object_Member.Id
                                 AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
          LEFT JOIN ObjectString AS ObjectString_INN 
                                 ON ObjectString_INN.ObjectId = Object_Member.Id 
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
 
          LEFT JOIN ObjectString AS ObjectString_Card
                                 ON ObjectString_Card.ObjectId = Object_Member.Id 
                                AND ObjectString_Card.DescId = zc_ObjectString_Member_Card()
          LEFT JOIN ObjectString AS ObjectString_CardSecond
                                 ON ObjectString_CardSecond.ObjectId = Object_Member.Id 
                                AND ObjectString_CardSecond.DescId = zc_ObjectString_Member_CardSecond()
          LEFT JOIN ObjectString AS ObjectString_CardChild
                                 ON ObjectString_CardChild.ObjectId = Object_Member.Id 
                                AND ObjectString_CardChild.DescId = zc_ObjectString_Member_CardChild()

          LEFT JOIN ObjectString AS ObjectString_DriverCertificate 
                                 ON ObjectString_DriverCertificate.ObjectId = Object_Member.Id 
                                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()

          LEFT JOIN ObjectString AS ObjectString_Comment 
                                 ON ObjectString_Comment.ObjectId = Object_Member.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Member_InfoMoney
                               ON ObjectLink_Member_InfoMoney.ObjectId = Object_Member.Id
                              AND ObjectLink_Member_InfoMoney.DescId = zc_ObjectLink_Member_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Member_InfoMoney.ChildObjectId
    
          LEFT JOIN ObjectLink AS ObjectLink_Member_Bank
                               ON ObjectLink_Member_Bank.ObjectId = Object_Member.Id
                              AND ObjectLink_Member_Bank.DescId = zc_ObjectLink_Member_Bank()
          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Member_Bank.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                               ON ObjectLink_Member_BankSecond.ObjectId = Object_Member.Id
                              AND ObjectLink_Member_BankSecond.DescId = zc_ObjectLink_Member_BankSecond()
          LEFT JOIN Object AS Object_BankSecond ON Object_BankSecond.Id = ObjectLink_Member_BankSecond.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Member_BankChild
                               ON ObjectLink_Member_BankChild.ObjectId = Object_Member.Id
                              AND ObjectLink_Member_BankChild.DescId = zc_ObjectLink_Member_BankChild()
          LEFT JOIN Object AS Object_BankChild ON Object_BankChild.Id = ObjectLink_Member_BankChild.ChildObjectId

     WHERE Object_Member.Id = inId;
     
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.03.17         * add Bank, BankSecond, BankChild
 20.02.17         * add CardSecond
 19.02.15         * add InfoMoney
 12.09.14                                        * add isOfficial
 01.10.13         * add DriverCertificate, Comment             
 01.07.13         *
 19.07.13                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_Member (1, '2')
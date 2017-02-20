-- Function: gpGet_Object_Member (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,        -- ���������� ���� 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
            , INN TVarChar, DriverCertificate TVarChar
            , Card TVarChar, CardSecond TVarChar
            , Comment TVarChar
            , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
            , isOfficial Boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
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
           , CAST ('' as TVarChar)  AS Comment
           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST (0 as Integer)    AS InfoMoneyCode
           , CAST ('' as TVarChar)  AS InfoMoneyName   
           , CAST ('' as TVarChar)  AS InfoMoneyName_all       
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
         , ObjectString_CardSecond.ValueData        AS CardSecond
         , ObjectString_Comment.ValueData           AS Comment
         
         , Object_InfoMoney_View.InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyName_all 

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
    
     WHERE Object_Member.Id = inId;
     
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.02.17         * add CardSecond
 19.02.15         * add InfoMoney
 12.09.14                                        * add isOfficial
 01.10.13         * add DriverCertificate, Comment             
 01.07.13         *
 19.07.13                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Member (1, '2')
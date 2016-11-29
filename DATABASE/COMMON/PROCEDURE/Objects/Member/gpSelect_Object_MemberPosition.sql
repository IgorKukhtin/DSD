-- Function: gpSelect_Object_MemberPosition (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberPosition (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberPosition(
    IN inPositionId       Integer , --
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, PositionId Integer, PositionName TVarChar
             , INN TVarChar, DriverCertificate TVarChar, Card TVarChar, Comment TVarChar
             , isOfficial Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY 
   with tmpPersonal AS (SELECT DISTINCT
                               Object_Personal.PersonalId
                             , Object_Personal.MemberId
                             , Object_Personal.PositionId
                             , Object_Personal.PositionName
                        FROM Object_Personal_View AS Object_Personal
                        WHERE Object_Personal.PositionId = inPositionId
                          --AND (Object_Personal.isErased = FALSE OR (Object_Personal.isErased = TRUE AND inIsShowAll = TRUE))
                          AND Object_Personal.isErased = FALSE
                        )
                   
     SELECT 
           Object_Member.Id         AS Id
         , Object_Member.ObjectCode AS Code
         , Object_Member.ValueData  AS Name
         , tmpPersonal.PositionId
         , tmpPersonal.PositionName
         , ObjectString_INN.ValueData               AS INN
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Card.ValueData              AS Card
         , ObjectString_Comment.ValueData           AS Comment

         , ObjectBoolean_Official.ValueData         AS isOfficial
 
         , Object_InfoMoney_View.InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyName_all

         , Object_Member.isErased                   AS isErased

     FROM Object AS Object_Member
          INNER JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id
         
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                  ON ObjectBoolean_Official.ObjectId = Object_Member.Id
                                 AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_Member.Id 
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
          LEFT JOIN ObjectString AS ObjectString_Card
                                 ON ObjectString_Card.ObjectId = Object_Member.Id 
                                AND ObjectString_Card.DescId = zc_ObjectString_Member_Card()
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

     WHERE Object_Member.DescId = zc_Object_Member()
       AND (Object_Member.isErased = FALSE OR (Object_Member.isErased = TRUE AND inIsShowAll = TRUE))
  UNION ALL
          SELECT
             CAST (0 as Integer)    AS Id
           , 0    AS Code
           , CAST ('УДАЛИТЬ' as TVarChar)  AS NAME
           , 0                      AS PositionId
           , CAST ('' as TVarChar)  AS PositionName
           , CAST ('' as TVarChar)  AS INN
           , CAST ('' as TVarChar)  AS DriverCertificate
           , CAST ('' as TVarChar)  AS Card
           , CAST ('' as TVarChar)  AS Comment
           , FALSE                  AS isOfficial
           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST (0 as Integer)    AS InfoMoneyCode
           , CAST ('' as TVarChar)  AS InfoMoneyName   
           , CAST ('' as TVarChar)  AS InfoMoneyName_all

           , FALSE AS isErased
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.11.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberPosition (8466, FALSE, zfCalc_UserAdmin()) order by 3
--SELECT * FROM gpSelect_Object_MemberPosition (8466, TRUE, zfCalc_UserAdmin())  order by 3

--select * from gpSelect_Object_MemberPosition(inPositionId := 81178 , inIsShowAll := 'False' ,  inSession := '5');
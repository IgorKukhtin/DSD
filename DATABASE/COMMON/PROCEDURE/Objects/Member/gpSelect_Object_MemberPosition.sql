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
             , BranchId Integer, BranchName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar 
             , GLN TVarChar
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE vbAll    Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- доступ
   vbMemberId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbUserId AND OL.DescId = zc_ObjectLink_User_Member());

   -- User by RoleId
   vbAll:= NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View
                       WHERE UserId = vbUserId
                         AND RoleId IN (SELECT Object.Id FROM Object
                                        WHERE Object.DescId = zc_Object_Role()
                                          -- Так криво - через zc_Object_Role
                                          AND Object.ObjectCode IN (3004, 4004, 5004, 6004, 7004, 8004, 8014, 9004
                                                                  , 1201, 2001, 2002, 2003, 2004, 2005, 2006
                                                                   )
                                       ));

   -- Результат
   RETURN QUERY 
   WITH tmpPersonal AS (SELECT Object_Personal.PersonalId
                             , Object_Personal.MemberId
                             , Object_Personal.PositionId
                             , Object_Personal.PositionName
                               --  № п/п
                             , ROW_NUMBER() OVER (PARTITION BY Object_Personal.MemberId ORDER BY Object_Personal.PersonalId DESC) AS Ord
                        FROM Object_Personal_View AS Object_Personal
                        WHERE vbAll = FALSE
                          AND (Object_Personal.PositionId IN (SELECT inPositionId
                                                       --  экспедитор <-> водитель
                                                       UNION SELECT 81178 WHERE inPositionId = 8466
                                                       UNION SELECT 8466  WHERE inPositionId = 81178
                                                       -- Представник торговельний  <-> мерчендайзер
                                                       --UNION SELECT 149828 WHERE inPositionId = 149831
                                                       --UNION SELECT 149831 WHERE inPositionId = 149828
                                                            )
                            OR Object_Personal.MemberId = vbMemberId
                              )
                          AND Object_Personal.isErased = FALSE

                       UNION ALL
                        SELECT lfSelect.PersonalId
                             , lfSelect.MemberId
                             , lfSelect.PositionId
                             , Object_Position.ValueData AS PositionName
                             , lfSelect.Ord
                        FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                             LEFT JOIN Object AS Object_Position ON Object_Position.Id = lfSelect.PositionId
                        WHERE vbAll = TRUE


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

         , Object_Branch.Id                         AS BranchId
         , Object_Branch.ValueData                  AS BranchName

         , COALESCE (ObjectLink_Personal_Unit.ChildObjectId, 0) AS UnitId
         , Object_Unit.ObjectCode                   AS UnitCode
         , Object_Unit.ValueData                    AS UnitName
         , ObjectString_GLN.ValueData   :: TVarChar AS GLN

         , Object_Member.isErased                   AS isErased

     FROM Object AS Object_Member
          INNER JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id
                                AND tmpPersonal.Ord      = 1 -- !!!только первый!!!
         
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

         LEFT JOIN ObjectString AS ObjectString_GLN
                                ON ObjectString_GLN.ObjectId = Object_Member.Id
                               AND ObjectString_GLN.DescId = zc_ObjectString_Member_GLN()

         LEFT JOIN ObjectLink AS ObjectLink_Member_InfoMoney
                              ON ObjectLink_Member_InfoMoney.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_InfoMoney.DescId = zc_ObjectLink_Member_InfoMoney()
         LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Member_InfoMoney.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                              ON ObjectLink_Personal_Unit.ObjectId = tmpPersonal.PersonalId
                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
 
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                             AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

     WHERE Object_Member.DescId = zc_Object_Member()
       AND (Object_Member.isErased = FALSE OR (Object_Member.isErased = TRUE AND inIsShowAll = TRUE))
  /*UNION ALL
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

           , FALSE AS isErased*/
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.23         *
 29.11.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberPosition (8466, FALSE, zfCalc_UserAdmin()) order by 3
-- SELECT * FROM gpSelect_Object_MemberPosition (8466, TRUE, zfCalc_UserAdmin())  order by 3
-- SELECT * FROM gpSelect_Object_MemberPosition (81178, TRUE, zfCalc_UserAdmin())  order by 3

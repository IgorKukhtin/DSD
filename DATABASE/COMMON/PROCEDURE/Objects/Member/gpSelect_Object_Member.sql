-- Function: gpSelect_Object_Member (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member(
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , INN TVarChar, DriverCertificate TVarChar, Comment TVarChar
             , isOfficial Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAllUnit Boolean;
   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   vbIsAllUnit:= NOT EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId);

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;

   -- Результат
   RETURN QUERY 
     SELECT 
           Object_Member.Id         AS Id
         , Object_Member.ObjectCode AS Code
         , Object_Member.ValueData  AS Name
         
         , ObjectString_INN.ValueData               AS INN
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Comment.ValueData           AS Comment

         , ObjectBoolean_Official.ValueData         AS isOfficial
 
         , Object_InfoMoney_View.InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyName_all
         
         , Object_Member.isErased                   AS isErased

     FROM Object AS Object_Member
          LEFT JOIN (SELECT View_Personal.MemberId
                     FROM Object_Personal_View AS View_Personal
                          INNER JOIN Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide
                                                                    ON View_RoleAccessKeyGuide.UserId = vbUserId
                                                                   AND View_RoleAccessKeyGuide.UnitId_PersonalService = View_Personal.UnitId
                                                                   AND vbIsAllUnit = FALSE
                     GROUP BY View_Personal.MemberId
                    ) AS View_Personal ON View_Personal.MemberId = Object_Member.Id
          LEFT JOIN (SELECT View_Personal.MemberId
                     FROM ObjectLink AS ObjectLink_Unit_Branch
                          INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = ObjectLink_Unit_Branch.ObjectId
                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint
                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                     GROUP BY View_Personal.MemberId
                    UNION
                     SELECT View_Personal.MemberId
                     FROM Object_Personal_View AS View_Personal
                     WHERE View_Personal.PositionId = 81178 -- экспедитор
                        OR View_Personal.PositionId = 8466  -- водитель
                        OR View_Personal.UnitId = 8409 -- Отдел экспедиторов
                     GROUP BY View_Personal.MemberId
                    ) AS View_Personal_Branch ON View_Personal_Branch.MemberId = Object_Member.Id

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                  ON ObjectBoolean_Official.ObjectId = Object_Member.Id
                                 AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_Member.Id 
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
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
       AND (Object_Member.isErased = FALSE
            OR (Object_Member.isErased = TRUE AND inIsShowAll = TRUE)
           )
       AND (View_Personal.MemberId > 0
            OR vbIsAllUnit = TRUE
           )
       AND (View_Personal_Branch.MemberId > 0
            OR vbIsConstraint = FALSE
           )

    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Member (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.15         * add InfoMoney
 24.09.13                                        * add vbIsAllUnit
 12.09.14                                        * add isOfficial
 12.09.13                                        * add inIsShowAll
 13.12.13                                        * del Object_RoleAccessKey_View
 08.12.13                                        * add Object_RoleAccessKey_View
 01.10.13         *  add DriverCertificate, Comment             
 01.07.13         *              
*/

-- тест
-- SELECT * FROM gpSelect_Object_Member (FALSE, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Member (TRUE, zfCalc_UserAdmin())

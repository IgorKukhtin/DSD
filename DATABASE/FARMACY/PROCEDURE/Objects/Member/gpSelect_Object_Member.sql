-- Function: gpSelect_Object_Member (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member(
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameUkr TVarChar
             , INN TVarChar, DriverCertificate TVarChar, Comment TVarChar
             , EMail TVarChar, Phone TVarChar, Address TVarChar
             , EMailSign Tblob, Photo Tblob
             , isOfficial Boolean
             , EducationId Integer, EducationCode Integer, EducationName TVarChar
             , isManagerPharmacy Boolean
             , PositionID Integer, PositionName TVarChar
             , UnitID Integer, UnitName TVarChar, isNotSchedule Boolean, isReleasedMarketingPlan Boolean
             , UserList TVarChar
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
     WITH tmpUser AS (SELECT ObjectLink_User_Member.ChildObjectId               AS MemberID
                           , string_agg(Object_User.ObjectCode::TVarChar, ', ') AS CodeList
                      FROM Object AS Object_User

                           INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                      WHERE Object_User.DescId = zc_Object_User()
                        AND Object_User.isErased = False
                        AND COALESCE (ObjectLink_User_Member.ChildObjectId, 0) <> 0
                      GROUP BY ObjectLink_User_Member.ChildObjectId)

     SELECT
           Object_Member.Id                AS Id
         , Object_Member.ObjectCode        AS Code
         , Object_Member.ValueData         AS Name
         , ObjectString_NameUkr.ValueData  AS NameUkr

         , ObjectString_INN.ValueData               AS INN
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Comment.ValueData           AS Comment


         , ObjectString_EMail.ValueData             AS EMail
         , ObjectString_Phone.ValueData             AS Phone
         , ObjectString_Address.ValueData           AS Address

         , ObjectBlob_EMailSign.ValueData           AS EMailSign
         , ObjectBlob_Photo.ValueData               AS Photo

         , ObjectBoolean_Official.ValueData         AS isOfficial

         , Object_Education.Id                      AS EducationId
         , Object_Education.ObjectCode              AS EducationCode
         , Object_Education.ValueData               AS EducationName

         , COALESCE (ObjectBoolean_ManagerPharmacy.ValueData, False)  AS isManagerPharmacy
         , Object_Position.Id                       AS PositionID
         , Object_Position.ValueData                AS PositionName
         , Object_Unit.Id                           AS UnitID
         , Object_Unit.ValueData                    AS UnitName
         , COALESCE (ObjectBoolean_NotSchedule.ValueData, False)  AS isNotSchedule
         , COALESCE (ObjectBoolean_ReleasedMarketingPlan.ValueData, False)  AS isReleasedMarketingPlan

         , tmpUser.CodeList::TVarChar               AS UserList

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

          LEFT JOIN ObjectString AS ObjectString_NameUkr
                                 ON ObjectString_NameUkr.ObjectId = Object_Member.Id
                                AND ObjectString_NameUkr.DescId = zc_ObjectString_Member_NameUkr()
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

          LEFT JOIN ObjectString AS ObjectString_EMail
                                 ON ObjectString_EMail.ObjectId = Object_Member.Id
                                AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()
          LEFT JOIN ObjectString AS ObjectString_Phone
                                 ON ObjectString_Phone.ObjectId = Object_Member.Id
                                AND ObjectString_Phone.DescId = zc_ObjectString_Member_Phone()
          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = Object_Member.Id
                                AND ObjectString_Address.DescId = zc_ObjectString_Member_Address()

         LEFT JOIN ObjectLink AS ObjectLink_Member_Education
                              ON ObjectLink_Member_Education.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Education.DescId = zc_ObjectLink_Member_Education()
         LEFT JOIN Object AS Object_Education ON Object_Education.Id = ObjectLink_Member_Education.ChildObjectId


         LEFT JOIN ObjectBlob AS ObjectBlob_EMailSign
                              ON ObjectBlob_EMailSign.ObjectId = Object_Member.Id
                             AND ObjectBlob_EMailSign.DescId = zc_ObjectBlob_Member_EMailSign()

         LEFT JOIN ObjectBlob AS ObjectBlob_Photo
                              ON ObjectBlob_Photo.ObjectId = Object_Member.Id
                             AND ObjectBlob_Photo.DescId = zc_ObjectBlob_Member_Photo()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_ManagerPharmacy
                                 ON ObjectBoolean_ManagerPharmacy.ObjectId = Object_Member.Id
                                AND ObjectBoolean_ManagerPharmacy.DescId = zc_ObjectBoolean_Member_ManagerPharmacy()

         LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                              ON ObjectLink_Member_Position.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                              ON ObjectLink_Member_Unit.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId
         
         LEFT JOIN ObjectBoolean AS ObjectBoolean_NotSchedule
                                 ON ObjectBoolean_NotSchedule.ObjectId = Object_Member.Id
                                AND ObjectBoolean_NotSchedule.DescId = zc_ObjectBoolean_Member_NotSchedule()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_ReleasedMarketingPlan
                                 ON ObjectBoolean_ReleasedMarketingPlan.ObjectId = Object_Member.Id
                                AND ObjectBoolean_ReleasedMarketingPlan.DescId = zc_ObjectBoolean_Member_ReleasedMarketingPlan()

         LEFT JOIN tmpUser ON tmpUser.MemberID =  Object_Member.Id

     WHERE Object_Member.DescId = zc_Object_Member()
       AND (Object_Member.isErased = FALSE
            OR (Object_Member.isErased = TRUE AND inIsShowAll = TRUE)
           )
       AND (View_Personal.MemberId > 0
            OR vbIsAllUnit = TRUE
           )

  UNION ALL
          SELECT
             CAST (0 as Integer)    AS Id
           , 0    AS Code
           , CAST ('УДАЛИТЬ' as TVarChar)  AS NAME
           , CAST ('ВИЛУЧИТИ' as TVarChar) AS NameUkr
           , CAST ('' as TVarChar)  AS INN
           , CAST ('' as TVarChar)  AS DriverCertificate
           , CAST ('' as TVarChar)  AS Comment

           , CAST ('' as TVarChar)  AS EMail
           , CAST ('' as TVarChar)  AS Phone
           , CAST ('' as TVarChar)  AS Address

           , CAST ('' as TBlob)     AS EMailSign
           , CAST ('' as TBlob)     AS Photo

           , FALSE                  AS isOfficial
           , CAST (0 as Integer)    AS EducationId
           , CAST (0 as Integer)    AS EducationCode
           , CAST ('' as TVarChar)  AS EducationName

           , FALSE                  AS isManagerPharmacy
           , CAST (0 as Integer)    AS PositionId
           , CAST ('' as TVarChar)  AS PositionName

           , CAST (0 as Integer)    AS UnitID
           , CAST ('' as TVarChar)  AS UnitName
           , FALSE                  AS isNotSchedule
           , FALSE                  AS isReleasedMarketingPlan

           , CAST ('' as TVarChar)  AS UserList

           , FALSE AS isErased

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Member (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                       *
 25.08.19                                                       *
 25.01.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Member (FALSE, zfCalc_UserAdmin()) order by 3
-- SELECT * FROM gpSelect_Object_Member (TRUE, zfCalc_UserAdmin())  order by 3
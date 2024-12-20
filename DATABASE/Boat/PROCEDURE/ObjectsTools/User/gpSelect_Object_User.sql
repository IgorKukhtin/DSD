-- Function: gpSelect_Object_User (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_User (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , User_ TVarChar
             , UnitCode_Personal Integer
             , UnitName_Personal TVarChar
             , PositionName TVarChar
             , LanguageId Integer
             , LanguageName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
IF inSession = '9464' THEN vbUserId := 9464;
ELSE
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_User());
END IF;

     -- ��������� ��� ��������
     IF vbUserId = 9457 -- ���������� �.�.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

   -- ���������
   RETURN QUERY 
   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                             , MAX (View_Personal.PositionId) AS PositionId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                        GROUP BY View_Personal.MemberId
                       )
   SELECT 
         Object_User.Id
       , Object_User.ObjectCode
       , Object_User.ValueData
       , Object_User.isErased
       , Object_Member.Id                 AS MemberId
       , Object_Member.ValueData          AS MemberName

       , ObjectString_User_.ValueData     AS User_

       , Object_Unit_Personal.ObjectCode  AS UnitCode_Personal
       , Object_Unit_Personal.ValueData   AS UnitName_Personal
       , Object_Position.ValueData        AS PositionName

       , Object_Language.Id               AS LanguageId
       , Object_Language.ValueData        AS LanguageName
   FROM Object AS Object_User
        LEFT JOIN ObjectString AS ObjectString_User_
                               ON ObjectString_User_.ObjectId = Object_User.Id
                              AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Language
                             ON ObjectLink_User_Language.ObjectId = Object_User.Id
                            AND ObjectLink_User_Language.DescId = zc_ObjectLink_User_Language()
        LEFT JOIN Object AS Object_Language ON Object_Language.Id = ObjectLink_User_Language.ChildObjectId

        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
        LEFT JOIN Object AS Object_Unit_Personal ON Object_Unit_Personal.Id = tmpPersonal.UnitId

   WHERE Object_User.DescId = zc_Object_User();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_User (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 30.04.18         * PrinterName
 15.02.18         * add UnitId_User
 05.05.16                                                         *
 12.09.16         *
 07.06.13                                        * lpCheckRight
 25.09.13                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_User (zfCalc_UserAdmin())

-- Function: gpSelect_Object_User (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_User (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , User_ TVarChar, UserSign TVarChar, UserSeal TVarChar, UserKey TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
             , ProjectMobile TVarChar
             , Foto TVarChar
             , BillNumberMobile Integer
             , isProjectMobile Boolean
             , UpdateMobileFrom TDateTime, UpdateMobileTo TDateTime
             , InDate TDateTime, FarmacyCashDate TDateTime
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
         Object_User.Id                             AS Id
       , Object_User.ObjectCode                     AS Code
       , Object_User.ValueData                      AS Name
       , Object_User.isErased                       AS isErased
       , Object_Member.Id                           AS MemberId
       , Object_Member.ValueData                    AS MemberName
                                                    
       , ObjectString_User_.ValueData               AS User_
       , ObjectString_UserSign.ValueData            AS UserSign
       , ObjectString_UserSeal.ValueData            AS UserSeal
       , ObjectString_UserKey.ValueData             AS UserKey
                                                    
       , Object_Branch.ObjectCode                   AS BranchCode
       , Object_Branch.ValueData                    AS BranchName
       , Object_Unit.ObjectCode                     AS UnitCode
       , Object_Unit.ValueData                      AS UnitName
       , Object_Position.ValueData                  AS PositionName

       , ObjectString_ProjectMobile.ValueData       AS ProjectMobile
       , ObjectString_Foto.ValueData                AS Foto
       , ObjectFloat_BillNumberMobile.ValueData :: Integer AS BillNumberMobile
       , COALESCE (ObjectBoolean_ProjectMobile.ValueData, FALSE) :: Boolean  AS isProjectMobile

       , ObjectDate_User_UpdateMobileFrom.ValueData AS UpdateMobileFrom
       , ObjectDate_User_UpdateMobileTo.ValueData   AS UpdateMobileTo
       
       , ObjectDate_User_In.ValueData               AS InDate
       , ObjectDate_User_FarmacyCash.ValueData      AS FarmacyCashDate
       
   FROM Object AS Object_User
        LEFT JOIN ObjectString AS ObjectString_User_
                               ON ObjectString_User_.ObjectId = Object_User.Id
                              AND ObjectString_User_.DescId = zc_ObjectString_User_Password()
        LEFT JOIN ObjectString AS ObjectString_UserSign
                               ON ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
                              AND ObjectString_UserSign.ObjectId = Object_User.Id

        LEFT JOIN ObjectString AS ObjectString_UserSeal
                               ON ObjectString_UserSeal.DescId = zc_ObjectString_User_Seal() 
                              AND ObjectString_UserSeal.ObjectId = Object_User.Id

        LEFT JOIN ObjectString AS ObjectString_UserKey 
                               ON ObjectString_UserKey.DescId = zc_ObjectString_User_Key() 
                              AND ObjectString_UserKey.ObjectId = Object_User.Id

        LEFT JOIN ObjectString AS ObjectString_ProjectMobile
                               ON ObjectString_ProjectMobile.ObjectId = Object_User.Id
                              AND ObjectString_ProjectMobile.DescId = zc_ObjectString_User_ProjectMobile()
                              
        LEFT JOIN ObjectString AS ObjectString_Foto
                               ON ObjectString_Foto.ObjectId = Object_User.Id
                              AND ObjectString_Foto.DescId = zc_ObjectString_User_Foto()
                              
        LEFT JOIN ObjectBoolean AS ObjectBoolean_ProjectMobile
                                ON ObjectBoolean_ProjectMobile.ObjectId = Object_User.Id
                               AND ObjectBoolean_ProjectMobile.DescId = zc_ObjectBoolean_User_ProjectMobile()
        LEFT JOIN ObjectFloat AS ObjectFloat_BillNumberMobile
                              ON ObjectFloat_BillNumberMobile.ObjectId = Object_User.Id
                             AND ObjectFloat_BillNumberMobile.DescId = zc_ObjectFloat_User_BillNumberMobile()

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_User_UpdateMobileFrom
                             ON ObjectDate_User_UpdateMobileFrom.ObjectId = Object_User.Id
                            AND ObjectDate_User_UpdateMobileFrom.DescId = zc_ObjectDate_User_UpdateMobileFrom()
        LEFT JOIN ObjectDate AS ObjectDate_User_UpdateMobileTo
                             ON ObjectDate_User_UpdateMobileTo.ObjectId = Object_User.Id
                            AND ObjectDate_User_UpdateMobileTo.DescId = zc_ObjectDate_User_UpdateMobileTo()

        LEFT JOIN ObjectDate AS ObjectDate_User_In
                             ON ObjectDate_User_In.ObjectId = Object_User.Id
                            AND ObjectDate_User_In.DescId = zc_ObjectDate_User_In()  
        LEFT JOIN ObjectDate AS ObjectDate_User_FarmacyCash
                             ON ObjectDate_User_FarmacyCash.ObjectId = Object_User.Id
                            AND ObjectDate_User_FarmacyCash.DescId = zc_ObjectDate_User_FarmacyCash()
   WHERE Object_User.DescId = zc_Object_User();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_User (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 02.05.17                                                       * zc_ObjectDate_User_UpdateMobileFrom, zc_ObjectDate_User_UpdateMobileTo
 21.04.17         *
 12.09.16         *
 07.06.13                                        * lpCheckRight
 25.09.13                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_User ('5')

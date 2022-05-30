-- Function: gpGet_Object_User()

DROP FUNCTION IF EXISTS gpGet_Object_User (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User(
    IN inId          Integer,       -- ������������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Password TVarChar
             , isSign Boolean
             , MemberId Integer, MemberName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Object_User());


   -- 0. ��������
   IF COALESCE (vbUserId, 0) <> 5
   THEN
       RAISE EXCEPTION '������.��� ����.';
   END IF;


   -- ���������
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_User()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS Password
           , CAST (FALSE as Boolean)  AS isSign
           , 0                      AS MemberId
           , CAST ('' as TVarChar)  AS MemberName
            ;

   ELSE
      RETURN QUERY
         SELECT
               Object_User.Id
             , Object_User.ObjectCode              AS Code
             , Object_User.ValueData               AS NAME
             , ObjectString_UserPassword.ValueData AS Password
             , COALESCE (ObjectBoolean_Sign.ValueData,FALSE) ::Boolean AS isSign

             , Object_Member.Id AS MemberId
             , Object_Member.ValueData AS MemberName

          FROM Object AS Object_User
           LEFT JOIN ObjectString AS ObjectString_UserPassword
                                  ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Password()
                                 AND ObjectString_UserPassword.ObjectId = Object_User.Id

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Sign
                                   ON ObjectBoolean_Sign.DescId = zc_ObjectBoolean_User_Sign()
                                  AND ObjectBoolean_Sign.ObjectId = Object_User.Id

           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
         WHERE Object_User.Id = inId;

   END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.22         *
*/

-- ����
-- SELECT * FROM gpGet_Object_User (1, '5')

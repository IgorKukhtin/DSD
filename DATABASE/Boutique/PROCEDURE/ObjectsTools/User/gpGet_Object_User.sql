-- Function: gpGet_Object_User()

DROP FUNCTION IF EXISTS gpGet_Object_User (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User(
    IN inId          Integer,       -- ������������ 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name TVarChar
             , Password TVarChar
             , MemberId Integer
             , MemberName TVarChar
             , UnitId Integer
             , UnitName TVarChar
             , PrinterName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Object_User());


   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
              0 :: Integer    AS Id
           ,  NEXTVAL ('Object_User_seq') :: Integer AS Code
           , '' :: TVarChar  AS NAME
           , '' :: TVarChar  AS Password
           ,  0 :: Integer   AS MemberId 
           , '' :: TVarChar  AS MemberName
           ,  0 :: Integer   AS UnitId
           , '' :: TVarChar  AS UnitName
           , '' :: TVarChar  AS PrinterName;
   ELSE
      RETURN QUERY 
      SELECT 
            Object_User.Id                       AS Id
          , Object_User.ObjectCode               AS Code
          , Object_User.ValueData                AS NAME
          , ObjectString_UserPassword.ValueData  AS Password
          , Object_Member.Id                     AS MemberId
          , Object_Member.ValueData              AS MemberName
          , Object_Unit.Id                       AS UnitId
          , Object_Unit.ValueData                AS UnitName
          , ObjectString_Printer.ValueData       AS PrinterName
      FROM Object AS Object_User
           LEFT JOIN ObjectString AS ObjectString_UserPassword 
                                  ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Password() 
                                 AND ObjectString_UserPassword.ObjectId = Object_User.Id

           LEFT JOIN ObjectString AS ObjectString_Printer
                                  ON ObjectString_Printer.ObjectId = Object_User.Id
                                 AND ObjectString_Printer.DescId = zc_ObjectString_User_Printer()

           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                                ON ObjectLink_User_Unit.ObjectId = Object_User.Id
                               AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId
      WHERE Object_User.Id = inId;
   END IF;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 15.02.18         *
 05.05.17                                                          *
 12.09.16         *
 07.06.13                                        * lpCheckRight
 03.06.13         *
*/

-- ����
-- SELECT * FROM gpGet_Object_User(0,'2')
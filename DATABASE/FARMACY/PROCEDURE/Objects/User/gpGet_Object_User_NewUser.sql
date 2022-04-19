-- Function: gpGet_Object_User_NewUser()

DROP FUNCTION IF EXISTS gpGet_Object_User_NewUser (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User_NewUser(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Name TVarChar
             , Phone TVarChar
             , PositionId Integer
             , PositionName TVarChar
             , UnitId Integer
             , UnitName TVarChar
             , Login TVarChar
             , Password TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 1633980))
   THEN
     RAISE EXCEPTION '�������� ������ ������������ ��� ���������.';
   END IF;

   RETURN QUERY 
   SELECT 0
        , ''::TVarChar                   AS Name
        , ''::TVarChar                   AS Phone
        , Object_Position.Id             AS PositionId
        , Object_Position.ValueData      AS PositionName
        , 0::Integer                     AS UnitId
        , ''::TVarChar                   AS UnitName
        , ''::TVarChar                   AS Login
        , '123456'::TVarChar             AS Password
   FROM Object AS Object_Position
   WHERE Object_Position.DescId = zc_Object_Position()
     AND Object_Position.ObjectCode = 1;

  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_User_NewUser (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.04.22                                                       *
*/

-- ����
-- 
SELECT * FROM gpGet_Object_User_NewUser ('3')
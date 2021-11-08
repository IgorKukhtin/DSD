-- Function: gpSelect_Object_Role()

--DROP FUNCTION gpSelect_Object_Role();

CREATE OR REPLACE FUNCTION gpSelect_Object_Role(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ��� ��������
     IF 1=0 AND vbUserId = 9457 -- ���������� �.�.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


   -- ���������
   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS Name
   , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_Role();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Role(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.09.13                         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_Role('2')
/*SELECT  
  Role.ItemName AS RoleName,
  Process.ItemName AS ProcessName
FROM 
  Object 
  JOIN ObjectEnum RoleRight_Role 
    ON RoleRight_Role.ObjectId = Object.Id AND RoleRight_Role.DescId = zc_Object_RoleRight_Role()
  JOIN Enum Role 
    ON Role.Id = RoleRight_Role.EnumId
  JOIN ObjectEnum RoleRight_Process
    ON RoleRight_Process.ObjectId = Object.Id AND RoleRight_Process.DescId = zc_Object_RoleRight_Process()
  JOIN Enum Process 
    ON Process.Id = RoleRight_Process.EnumId


WHERE Object.DescId = zc_Object_RoleRight()*/

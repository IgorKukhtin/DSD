-- Function: gpSelect_Object_Unit_IsErased (Integer, TVarChar)

-- DROP FUNCTION gpSelect_Object_Unit_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_IsErased(
    IN inObjectId Integer, 
    IN Session    TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- ��� �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (Session);

   -- �������� - �����������/��������� ��������� �������� ������
   IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������.��������� �������� �������� ��������� ������ ��������������.';
   END IF;

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit_IsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ������ �.�.
 05.05.19                                                                   *
*/

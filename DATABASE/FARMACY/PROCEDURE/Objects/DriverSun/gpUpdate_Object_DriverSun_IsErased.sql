-- Function: gpUpdate_Object_DriverSun_IsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdate_Object_DriverSun_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DriverSun_IsErased(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   vbUserId:= inSession;
  
    -- ��������� ������ ����������� � ������� ������    
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '�������� � ������������� ��� ���������, ���������� � ���������� ��������������';
   END IF;
    
   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_DriverSun_IsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.20                                                       *
*/
	
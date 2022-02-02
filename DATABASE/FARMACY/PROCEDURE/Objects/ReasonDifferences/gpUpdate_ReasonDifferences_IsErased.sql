-- Function: gpUpdate_ReasonDifferences_IsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdate_ReasonDifferences_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ReasonDifferences_IsErased(
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
   IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
   THEN
      RAISE EXCEPTION '������.������� <������� �����������> ��� ���������.';
   END IF;

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_ReasonDifferences_IsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.08.20                                                       *
*/

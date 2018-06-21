-- Function: gpUpdate_Object_Member_IsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdate_Object_Member_IsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_IsErased(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
 
   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Member_IsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������ �.�.
 21.06.15        *
*/
	
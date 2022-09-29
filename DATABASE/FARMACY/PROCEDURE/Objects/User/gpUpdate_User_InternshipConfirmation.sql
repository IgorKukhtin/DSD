-- Function: gpUpdate_User_InternshipCompleted()

DROP FUNCTION IF EXISTS gpUpdate_User_InternshipConfirmation (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_InternshipConfirmation(
    IN inUserId                    Integer   ,    -- 	���������
    IN inInternshipConfirmation    Integer   ,    -- 	������������� ����������
    IN inSession                   TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� <������������� ����������>. ��������� ������ ���������� ��������������';
   END IF;     

     -- �������� <������������� ����������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_User_InternshipConfirmation(), inUserId, inInternshipConfirmation);

     -- �������� <���� ������������� ����������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_InternshipConfirmation(), inUserId, CURRENT_TIMESTAMP);

   -- ������� ���������
   PERFORM lpInsert_ObjectProtocol (inUserId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.01.22                                                       *
*/
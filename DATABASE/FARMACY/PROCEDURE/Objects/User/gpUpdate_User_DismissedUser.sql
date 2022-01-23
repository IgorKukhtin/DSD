-- Function: gpUpdate_User_DismissedUser()

DROP FUNCTION IF EXISTS gpUpdate_User_DismissedUser (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_DismissedUser(
    IN inUserId              Integer   ,    -- ����
    IN inisDismissedUser     Boolean   ,    -- ��������� ���������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- ���� �����
    IF inUserId <> 0
    THEN

        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_DismissedUser(), inUserId, not inisDismissedUser);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.01.22                                                       *
*/

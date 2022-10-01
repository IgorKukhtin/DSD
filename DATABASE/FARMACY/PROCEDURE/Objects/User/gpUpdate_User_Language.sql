-- Function: gpUpdate_User_Language()

DROP FUNCTION IF EXISTS gpUpdate_User_Language (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_Language(
    IN inLanguage        TVarChar   ,   -- ���� ������������ �����
    IN inSession         TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- ��������� <������>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Language(), vbUserId, inLanguage);

    -- ������� ���������
    PERFORM lpInsert_ObjectProtocol (vbUserId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.09.22                                                       *
*/
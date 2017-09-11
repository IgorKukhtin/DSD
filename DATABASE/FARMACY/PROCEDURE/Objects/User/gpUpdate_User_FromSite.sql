-- Function: gpUpdate_User_FromSite()

DROP FUNCTION IF EXISTS gpUpdate_User_FromSite (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_FromSite(
    IN inId                  Integer   ,    -- ����
    IN inPhoto               TVarChar  ,    -- ����
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
    IF inId <> 0
    THEN
        -- ��������� �������� <����>
        PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Foto(), inId, inPhoto);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 11.09.17                                        *
*/

-- Function: gpUpdate_User_KeyExpireDate()

DROP FUNCTION IF EXISTS gpUpdate_User_KeyExpireDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_KeyExpireDate(
    IN inId                  Integer   ,    -- ����
    IN inKeyExpireDate       TDateTime ,    -- ���� ��������� ����� �������� ��������� �����
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
    IF inId <> 0 AND inKeyExpireDate IS NOT NULL AND date_part('YEAR', inKeyExpireDate) >= 2000
    THEN
        -- ��������� �������� <���� ��������� ����� �������� ��������� �����>
        PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_KeyExpireDate(), inId, inKeyExpireDate);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.03.22                                                       *
*/

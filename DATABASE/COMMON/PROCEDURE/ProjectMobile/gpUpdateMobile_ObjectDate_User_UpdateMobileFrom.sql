-- Function: gpUpdateMobile_ObjectDate_User_UpdateMobileFrom

DROP FUNCTION IF EXISTS gpUpdateMobile_ObjectDate_User_UpdateMobileFrom (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_ObjectDate_User_UpdateMobileFrom (
    IN inUpdateMobileFrom TDateTime , -- �������� - ����/����� �������� �������� ������������� � ���������� ����������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- ����� ����������� ��������� ������� ������������
      IF EXISTS (SELECT 1 FROM Object AS Object_User WHERE Object_User.Id = vbUserId AND Object_User.DescId = zc_Object_User())
      THEN
           -- ��������� �������� <����/����� �������� �������� ������������� � ���������� ����������>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_UpdateMobileFrom(), vbUserId, CURRENT_TIMESTAMP /*inUpdateMobileFrom*/);
           -- ��������� ��������
           PERFORM lpInsert_ObjectProtocol (vbUserId, vbUserId);
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 02.05.17                                                         *
*/

-- ����
-- SELECT * FROM gpUpdateMobile_ObjectDate_User_UpdateMobileFrom (inUpdateMobileFrom:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())

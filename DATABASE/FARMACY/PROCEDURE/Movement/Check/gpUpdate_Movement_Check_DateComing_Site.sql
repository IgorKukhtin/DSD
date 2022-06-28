-- Function: gpUpdate_Movement_Check_DateComing_Site()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_DateComing_Site (Integer, TDateTime, TVarChar);
      
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_DateComing_Site(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inDateComing        TDateTime , -- ���� ������� � ������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    -- ���� ������� � ������
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Coming(), inId, inDateComing);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', inSession, inDateComing;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 27.06.22                                                                    *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Check_DateComing_Site (28372118 , CURRENT_DATE::tdatetime, '3'); 

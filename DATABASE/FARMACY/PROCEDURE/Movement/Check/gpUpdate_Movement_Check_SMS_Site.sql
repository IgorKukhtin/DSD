-- Function: gpUpdate_Movement_Check_SMS_Site() - ���� ������� � ������ ������ ������� "���������� ���"

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SMS_Site (Integer, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SMS_Site(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inSMS               Boolean   , -- 
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF inSMS = TRUE
    THEN
        -- ��������� ����� � <������ ������ (��������� VIP-����)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), inId, zc_Enum_ConfirmedKind_SmsYes());
    ELSE
        -- ��������� ����� � <������ ������ (��������� VIP-����)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), inId, zc_Enum_ConfirmedKind_SmsNo());
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 25.08.16                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Check_SMS_Site (inId:= 0, inSMS:= TRUE, inSession:= zfCalc_UserAdmin());

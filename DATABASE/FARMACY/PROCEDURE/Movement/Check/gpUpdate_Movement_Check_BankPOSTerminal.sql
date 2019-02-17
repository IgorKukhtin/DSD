-- Function: gpUpdate_Movement_Check_BankPOSTerminal()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_BankPOSTerminal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_BankPOSTerminal(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inBankPOSTerminalId Integer   , -- ������������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbPaidTypeId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpGetUserBySession (inSession);
--    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� <����� POS ���������> ��� ���������.';
    END IF;

    SELECT
      StatusId,
      MovementLinkObject_PaidType.ObjectId
    INTO
      vbStatusId,
      vbPaidTypeId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                      ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                     AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
    WHERE Id = inId;

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� POS ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (vbPaidTypeId, 0) not in (496645, 9200130)
    THEN
        RAISE EXCEPTION '������.��� ����� ������ <%> ��������� ����� POS ��������� �� ��������.',
           (select ValueData from Object where Id = vbPaidTypeId);
    END IF;

    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankPOSTerminal(), inId, inBankPOSTerminalId);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 17.11.18                                                                                    *
*/
-- ����
-- select * from gpUpdate_Movement_Check_BankPOSTerminal(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');
-- Function: gpInsertUpdate_Movement_Check_SendVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_SendVIP (Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_SendVIP(
 INOUT ioId                Integer   , -- ���� ������� <�������� ���>
    IN inUnitId            Integer   , -- ���� ������� <�������������>
    IN inManagerId         Integer   , -- ��������
    IN inBayer             TVarChar  , -- ���������� ���
    IN inBayerPhone        TVarChar  , -- ���������� ������� (����������)
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbDate TDateTime;

   DECLARE vbInvNumber Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbPaidTypeId Integer;
   DECLARE vbManagerId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    -- ���������� ������� ��������/�������������
    ioId := 0;
    vbDate := CURRENT_TIMESTAMP::TDateTime;
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    SELECT
        COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1
    INTO
        vbInvNumber
    FROM
        Movement_Check_View
    WHERE
        Movement_Check_View.UnitId = inUnitId
        AND
        Movement_Check_View.OperDate > CURRENT_DATE;

    IF COALESCE(inManagerId, 0) = 0 OR
       COALESCE(inBayer,'') = '' OR
       COALESCE(inBayerPhone,'') = ''
    THEN
        RAISE EXCEPTION '������. �� ���������: ������������� <%> ��� �������� <%> ��� ���������� <%> ��� ���������� ������� <%>', inUnitId, inManagerId, inBayer, inBayerPhone;
    END IF;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Check(), vbInvNumber::TVarChar, vbDate, NULL);

    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- ��������� ����� � <������ ������ (��������� VIP-����)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), ioId, zc_Enum_ConfirmedKind_UnComplete());
    -- ��������� ���������
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, inManagerId);
    -- ��������� ��� ����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Bayer(), ioId, inBayer);
    -- ��������� ���������� ������� (����������)
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BayerPhone(), ioId, inBayerPhone);
    -- �������� �������� ��� ����������
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), ioId, TRUE);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 29.05.20                                                                                      *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Check_SendVIP (ioId := 0, inUnitId := 183292, inBayer := 'Test Bayer'::TVarChar, inBayerPhone:= '11-22-33', inSession := '3'::TVarChar);
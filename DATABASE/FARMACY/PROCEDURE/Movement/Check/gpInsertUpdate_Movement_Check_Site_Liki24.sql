-- Function: gpInsertUpdate_Movement_Check_Site_Liki24()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site_Liki24 (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_Site_Liki24(
 INOUT ioId                Integer   , -- ���� ������� <�������� ���>
    IN inUnitId            Integer   , -- ���� ������� <�������������>
    IN inDate              TDateTime , -- ����/����� ���������
    IN inBookingId         TVarChar  , -- ID ������ �� �����
    IN inOrderId           TVarChar  , -- ID ������ � ������� ���������
    IN inBookingStatus     TVarChar  , -- ������ ������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    IF inSession = zfCalc_UserAdmin()
    THEN
      inSession = zfCalc_UserSite();
    END IF;

    vbUserId := lpGetUserBySession (inSession);

    IF inDate is null
    THEN
        inDate := CURRENT_TIMESTAMP::TDateTime;
    END IF;

    IF COALESCE(inBookingId, '') = ''
    THEN
        RAISE EXCEPTION '������. �� ��������� ID ������';
    END IF;


    IF COALESCE(ioId,0) = 0 AND
       EXISTS(SELECT MovementString.MovementId FROM MovementString
              WHERE MovementString.DescId = zc_MovementString_BookingId()
                AND MovementString.ValueData = inBookingId)
    THEN
      SELECT MovementString.MovementId
      INTO ioId
      FROM MovementString
      WHERE MovementString.DescId = zc_MovementString_BookingId()
        AND MovementString.ValueData = inBookingId;
    END IF;

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    IF COALESCE(ioId,0) = 0
    THEN
        SELECT COALESCE(MAX(zfConvert_StringToNumber(Movement.InvNumber)), 0) + 1
        INTO vbInvNumber
        FROM Movement
             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        WHERE Movement.DescId = zc_Movement_Check()
          AND Movement.OperDate > CURRENT_DATE
          AND MovementLinkObject_Unit.ObjectId = inUnitId;
    ELSE
        SELECT Movement.InvNumber
        INTO vbInvNumber
        FROM Movement
        WHERE Movement.Id = ioId;
    END IF;


    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Check(), vbInvNumber::TVarChar, inDate, NULL);



    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- ��������� ����� � <�������� ����>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CheckSourceKind(), ioId, zc_Enum_CheckSourceKind_Liki24());
    -- ��������� ����� � <������ ������ (��������� VIP-����)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), ioId, zc_Enum_ConfirmedKind_UnComplete());

    -- ��������� ID ������ �� �����
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BookingId(), ioId, inBookingId);
    -- ��������� ID ������ � ������� ���������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_OrderId(), ioId, inOrderId);
    -- ��������� ������ ������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BookingStatus(), ioId, inBookingStatus);
    -- �������� �������� ��� ����������
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), ioId, TRUE);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

    -- !!!�������� ��� �����!!!
/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', vbInvNumber, inSession;
    END IF;
*/
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.20                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Check_Site_Liki24 (ioId := 0, inUnitId := 183292, inDate := NULL::TDateTime, inBookingId := 'ea611433-bfc6-435b-80cf-16b457607dc3'::TVarChar, inOrderId:= 'bfb4b3dd-affe-11ea-a9f3-00163e3c1eb4', inSession := '3'::TVarChar); -
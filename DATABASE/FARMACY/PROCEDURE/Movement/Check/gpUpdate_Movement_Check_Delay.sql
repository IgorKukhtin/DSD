 -- Function: gpUpdate_Movement_Check_Delay()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Delay (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Delay(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� �������� <���������.> ��� ���������.';
    END IF;

    SELECT StatusId
    INTO vbStatusId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                      ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                     AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
    WHERE Id = inMovementId;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� �������� <���������.> � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ������� ���
    PERFORM gpSetErased_Movement_Check (inMovementId, inSession);

    -- ��������� ������� <���������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Delay(), inMovementId, True);

    -- ��������� �������� <���� �������� ���������>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Delay(), inMovementId, CURRENT_TIMESTAMP);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 18.04.19                                                                    *
 04.04.19                                                                    *
*/
-- ����
-- select * from gpUpdate_Movement_Check_Delay(inMovementId := 7784533 ,  inSession := '3');
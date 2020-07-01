 -- Function: gpUpdate_Movement_Check_SummCard()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SummCard (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SummCard(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inSummCard          TFloat    , -- ���������s �� �����
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
        RAISE EXCEPTION '������.��������� �������� <���������s �� �����.> � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ��������� ������� <���������s �� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCard(), inMovementId, inSummCard);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 01.07.20                                                                    *
*/
-- ����
-- select * from gpUpdate_Movement_Check_SummCard(inMovementId := 7784533 ,  inSession := '3');
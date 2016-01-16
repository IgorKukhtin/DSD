-- Function: gpUpdate_Movement_Income_PartnerData()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_PartnerData(Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_PartnerData(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- � ���������
    IN inPaymentDate         TDateTime , -- ���� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.InvNumber <> inInvNumber)
    THEN
        UPDATE Movement SET
            InvNumber = inInvNumber
        WHERE
            Id = inMovementId;
    END IF;
    
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Payment(), inMovementId, inPaymentDate);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.05.15                         *

*/

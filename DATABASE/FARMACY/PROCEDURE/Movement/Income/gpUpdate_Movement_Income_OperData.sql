-- Function: gpUpdate_Movement_Income_OperData()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_OperData(Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_OperData(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- � ���������
    IN inOperDate            TDateTime , -- ���� �
   OUT outInvNumber          TVarChar  , -- � ���������
   OUT outOperDate           TDateTime , -- ���� �
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
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

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND (Movement.InvNumber <> inInvNumber OR Movement.OperDate <> inOperDate))
    THEN
        UPDATE Movement SET
            InvNumber = inInvNumber, OperDate = inOperDate
        WHERE
            Id = inMovementId;
    END IF;
    
    outInvNumber := inInvNumber;
    outOperDate := inOperDate;
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.04.20                                                       *

*/

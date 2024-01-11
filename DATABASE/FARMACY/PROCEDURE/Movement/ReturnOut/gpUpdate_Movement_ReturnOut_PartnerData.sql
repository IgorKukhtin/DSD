-- Function: gpUpdate_Movement_ReturnOut_PartnerData()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnOut_PartnerData (Integer, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnOut_PartnerData (Integer, TVarChar, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnOut_PartnerData(
    IN inMovementId          Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumberPartner    TVarChar  , -- ����� ���������
    IN inOperDatePartner     TDateTime , -- ���� ���������
    IN inAdjustingOurDate    TDateTime , -- ������������� ����� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbNeedComplete Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := inSession;
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ReturnOut_PartnerData());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());
    
    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;

    -- ���� �������� �������� - ����������� ��� � �������� ��� � ����� ������ ��� ��������
    IF EXISTS(SELECT 1 FROM Movement Where Id = inMovementId AND StatusId = zc_Enum_Status_Complete())
    THEN
        PERFORM gpUnComplete_Movement_ReturnOut (inMovementId := inMovementId, inSession := inSession);
        vbNeedComplete := TRUE;
    ELSE
        vbNeedComplete := FALSE;
    END IF;
    
    --��������� ������������� ����� ����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_AdjustingOurDate(), inMovementId, CASE WHEN inAdjustingOurDate > '01.01.2000' THEN inAdjustingOurDate ELSE NULL END);
    
    --��������� ���� ��������
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inMovementId, CASE WHEN TRIM (inInvNumberPartner) <> '' AND inOperDatePartner > '01.01.2000' THEN inOperDatePartner ELSE NULL END);

    -- ��������� � ��������� ��������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), inMovementId, inInvNumberPartner);

    -- ���� �������� ��� ����������� - �� �������� ���
    IF vbNeedComplete = TRUE
    THEN
        PERFORM gpComplete_Movement_ReturnOut (inMovementId := inMovementId, inSession := inSession);
    END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 29.05.18                                                                                     * 
 12.01.16                                                                        *

*/

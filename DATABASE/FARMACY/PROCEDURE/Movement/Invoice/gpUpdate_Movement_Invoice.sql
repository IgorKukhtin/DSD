-- Function: gpUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice (Integer, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice (Integer, TDateTime, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice (Integer, TDateTime, TVarChar, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice(
    IN inId                    Integer,    -- 
    IN inDateRegistered        TDateTime,  -- ���� ��������
    IN inInvNumberRegistered   TVarChar ,  -- ����� ��������
    IN inisDocument            Boolean  ,  -- ���� ��� ���.
    IN inTotalDiffSumm         TFloat   ,  -- ���������������� �����
   OUT outSumm_Diff            TFloat   ,  -- ������� ����� � ��� � ���������������� �����
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Invoice());
    vbUserId := inSession;

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), inId, inDateRegistered);    

    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberRegistered(), inId, inInvNumberRegistered);
  
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), inId, inisDocument);

    -- ��������� �������� <> 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiffSumm(), inId, inTotalDiffSumm);

    -- 
    outSumm_Diff := (COALESCE ( (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0) - COALESCE (inTotalDiffSumm,0) ) :: TFloat;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 17.04.19         * inTotalDiffSumm, outSumm_Diff
 21.04.17         * add inisDocument
 22.03.17         *
*/
-- Function: gpInsertUpdate_Movement_TaxCorrective_DocChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_DocChild (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_DocChild(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovement_ChildId    Integer   , -- ��������� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

     -- �������� - �����������/��������� ��������� �������� ������
     IF inMovement_ChildId <> 0
        AND COALESCE ((SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_TotalSummPVAT()), 0)
          > COALESCE ((SELECT ValueData FROM MovementFloat WHERE MovementId = inMovement_ChildId AND DescId = zc_MovementFloat_TotalSummPVAT()), 0)
     THEN
         RAISE EXCEPTION '������.����� <%> � ��������� % � <%> �� <%> ������ ��� ����� <%> � ��������� <%> � <%> �� <%>.%����� ����������.', COALESCE ((SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_TotalSummPVAT()), 0)
                                                                                                                                , (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective())
                                                                                                                                , (SELECT ValueData FROM MovementString WHERE MovementId = ioId AND DescId = zc_MovementString_InvNumberPartner())
                                                                                                                                , DATE (inOperDate)
                                                                                                                                , COALESCE ((SELECT ValueData FROM MovementFloat WHERE MovementId = inMovement_ChildId AND DescId = zc_MovementFloat_TotalSummPVAT()), 0)
                                                                                                                                , (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())
                                                                                                                                , (SELECT ValueData FROM MovementString WHERE MovementId = inMovement_ChildId AND DescId = zc_MovementString_InvNumberPartner())
                                                                                                                                , DATE ((SELECT OperDate FROM Movement WHERE Id = inMovement_ChildId))
                                                                                                                                , CHR (13)
                                                                                                                                ;
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_TaxCorrective_DocChild(ioId, inInvNumber, inOperDate, inMovement_ChildId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 09.04.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_DocChild (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKindId:= 0, inSession:= '2')

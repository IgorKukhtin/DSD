-- Function: gpInsertUpdate_Movement_TaxCorrective_DocChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_DocChild (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_DocChild(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovement_ChildId    Integer   , -- ��������� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbTotalSumm_corrective TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());


     -- �������� - �����������/��������� ��������� �������� ������
     vbTotalSumm_corrective:= COALESCE ((SELECT SUM (COALESCE (MovementFloat.ValueData, 0))
                                         FROM (SELECT ioId AS MovementId
                                              UNION
                                               SELECT MovementId FROM MovementLinkMovement WHERE MovementChildId = inMovement_ChildId AND DescId = zc_MovementLinkMovement_Child()
                                              ) AS tmp
                                              INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                 AND Movement.DescId = zc_Movement_TaxCorrective()
                                              LEFT JOIN MovementFloat ON MovementFloat.MovementId = tmp.MovementId
                                                                     AND MovementFloat.DescId = zc_MovementFloat_TotalSummPVAT()
                                        ), 0);


     -- �������� - �����������/��������� ��������� �������� ������
     IF inMovement_ChildId <> 0
        AND vbTotalSumm_corrective
          > COALESCE ((SELECT ValueData FROM MovementFloat WHERE MovementId = inMovement_ChildId AND DescId = zc_MovementFloat_TotalSummPVAT()), 0)
     THEN
         -- RAISE EXCEPTION '������.����� <%> � ��������� % � <%> �� <%> ������ ��� ����� <%> � ��������� <%> � <%> �� <%>.%����� ����������.', COALESCE ((SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_TotalSummPVAT()), 0)
         RAISE EXCEPTION '������.����� <%> �� ���� ���������� % ������ ��� ����� <%> � ��������� <%> � <%> �� <%>.%����� ����������.', vbTotalSumm_corrective
                                                                                                                                , (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective())
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

-- Function: lpInsertUpdate_Movement_TaxCorrective_DocChild()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TaxCorrective_DocChild (Integer, TVarChar, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TaxCorrective_DocChild(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ���������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovement_ChildId    Integer   , -- ��������� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������� ����� � <��������� ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), ioId, inMovement_ChildId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 10.05.14                                        * add lpInsert_MovementProtocol
 10.05.14                                        * ����� ���� ��������� ������ 1 ��������
 09.04.14                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_TaxCorrective_DocChild (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)

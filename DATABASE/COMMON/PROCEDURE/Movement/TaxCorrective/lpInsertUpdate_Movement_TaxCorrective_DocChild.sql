-- Function: lpInsertUpdate_Movement_TaxCorrective_DocChild()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TaxCorrective_DocChild (Integer, TVarChar, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TaxCorrective_DocChild(
 INOUT ioId                  Integer   , -- ���� �������
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovement_ChildId    Integer   , -- ��������� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
  DECLARE vbStatusId  Integer;
  DECLARE vbInvNumber TVarChar;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� <������>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = ioId;
     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- �������� - ����� �������� ������ ���� ����������
     IF COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Contract()), 0)
        <> COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovement_ChildId AND DescId = zc_MovementLinkObject_Contract()), 0)
        AND inMovement_ChildId <> 0
     THEN
         RAISE EXCEPTION '������.� �������� � ������������� �� ������������ � �������� � ���������.';
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
 06.06.14                                        * add �������� - �����������/��������� ��������� �������� ������
 10.05.14                                        * add lpInsert_MovementProtocol
 10.05.14                                        * ����� ���� ��������� ������ 1 ��������
 09.04.14                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_TaxCorrective_DocChild (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)

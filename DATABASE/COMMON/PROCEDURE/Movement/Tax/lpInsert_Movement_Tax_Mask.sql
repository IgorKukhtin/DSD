-- Function: lpInsert_Movement_Tax_Mask()

DROP FUNCTION IF EXISTS lpInsert_Movement_Tax_Mask (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Tax_Mask (
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ���������� ���������
    IN inInvNumberBranch     TVarChar  , -- ����� �������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inChecked             Boolean   , -- ��������
    IN inDocument            Boolean   , -- ���� �� ����������� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartnerId           Integer   , -- ����������
    IN inContractId          Integer   , -- ��������
    IN inDocumentTaxKindId   Integer   , -- ��� ������������ ���������� ���������
    IN inUserId              Integer   -- ������ ������������
)
RETURNS Integer AS
$BODY$
  
BEGIN
    
     -- ��������� <��������>
     SELECT tmp.ioId
        INTO ioId
     FROM lpInsertUpdate_Movement_Tax (ioId, inInvNumber, inInvNumberPartner, inInvNumberBranch, inOperDate
                                     , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                     , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, inUserId
                                      ) AS tmp;

    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.01.15         * 

*/

-- ����
-- SELECT * FROM lpInsert_Movement_TaxMask (ioId:= 0, ioInvNumber:= '-1',ioInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inSession:= '2')

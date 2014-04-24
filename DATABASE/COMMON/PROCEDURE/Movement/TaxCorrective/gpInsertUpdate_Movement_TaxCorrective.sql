-- Function: gpInsertUpdate_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective(
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
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_TaxCorrective(ioId, inInvNumber, inInvNumberPartner, inInvNumberBranch, inOperDate
                                                 , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                                 , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.04.14                                                       * add inInvNumberBranch
 19.03.14                                        * add inPartnerId
 11.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKindId:= 0, inSession:= '2')
-- Function: gpInsertUpdate_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
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
    IN inComment             TVarChar  , -- ����������
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

     -- ������� "����������� �������"
     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
       AND NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.isErased = FALSE) -- AND ObjectId = inDocumentTaxKindId
     THEN
         PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                          , inMovementId         := ioId
                                                          , inGoodsId            := 2117  -- inDocumentTaxKindId
                                                          , inAmount             := 0
                                                          , inPrice              := 0
                                                          , inPriceTax_calc      := 0
                                                          , ioCountForPrice      := 1
                                                          , inGoodsKindId        := zc_GoodsKind_Basis() -- NULL
                                                          , inUserId             := vbUserId
                                                           );

     END IF;

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.07.14                                        * add zc_Enum_DocumentTaxKind_Prepay
 24.04.14                                                       * add inInvNumberBranch
 19.03.14                                        * add inPartnerId
 11.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKindId:= 0, inSession:= '2')

-- Function: gpInsert_Movement_TaxCorrectiveMask()

DROP FUNCTION IF EXISTS gpInsert_Movement_TaxCorrective_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_TaxCorrective_Mask(
 INOUT ioId                  Integer   , -- ���� ������� <�������� >
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

     -- ��������� <��������>
     select lpInsert_Movement_TaxCorrective_Mask(
                                          0
                                        , CAST (NEXTVAL ('movement_taxcorrective_seq') AS TVarChar)
                                        , '' ::TVarChar
                                        , tmp.InvNumberBranch, tmp.OperDate
                                        , tmp.Checked, tmp.Document
                                        , tmp.PriceWithVAT, tmp.VATPercent
                                        , tmp.FromId, tmp.ToId
                                        , tmp.PartnerId, tmp.ContractId
                                        , tmp.TaxKindId, vbUserId
                                         )
     INTO vbMovementId
     FROM gpGet_Movement_TaxCorrective (ioId, 'False', inOperDate, inSession) AS tmp;


   -- ���������� ������ ���������
   PERFORM lpInsertUpdate_MovementItem_TaxCorrective (
                                           ioId                := 0
                                         , inMovementId         := vbMovementId
                                         , inGoodsId            := tmp.GoodsId
                                         , inAmount             := COALESCE (tmp.Amount, 0)
                                         , inPrice              := COALESCE (tmp.Price, 0)
                                         , inPriceTax_calc      := 0
                                         , ioCountForPrice      := COALESCE (tmp.CountForPrice, 1)
                                         , inGoodsKindId        := tmp.GoodsKindId
                                         , inUserId             := vbUserId
                                          ) 
   FROM gpSelect_MovementItem_TaxCorrective (ioId, 'False', 'False', inSession)  AS tmp;
   
   -- ���������� ������ ���������
   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
  16.03.15        *
*/

-- ����
-- SELECT * FROM gpInsert_Movement_TaxCorrective_Mask (ioId:= 0, ioInvNumber:= '-1',ioInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inSession:= '2')

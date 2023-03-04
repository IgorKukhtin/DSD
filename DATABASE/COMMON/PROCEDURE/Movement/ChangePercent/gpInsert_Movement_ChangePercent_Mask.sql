-- Function: gpInsert_Movement_ChangePercentMask()

DROP FUNCTION IF EXISTS gpInsert_Movement_ChangePercent_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_ChangePercent_Mask(
 INOUT ioId                  Integer   , -- ���� ������� <�������� >
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChangePercent());

     -- ��������� �����-���� ���������
     vbPriceListId := (SELECT tmp.PriceListId FROM gpGet_Movement_ChangePercent (ioId, 'False', inOperDate, inSession) AS tmp );
      
     -- ��������� <��������>
     SELECT lpInsertUpdate_Movement_ChangePercent (ioId               := 0
                                                 , inInvNumber        := CAST (NEXTVAL ('movement_ChangePercent_seq') AS TVarChar)
                                                 , inInvNumberPartner := '' ::TVarChar
                                                 , inOperDate         := inOperDate
                                                 , inChecked          := False
                                                 , inPriceWithVAT     := tmp.PriceWithVAT
                                                 , inVATPercent       := tmp.VATPercent
                                                 , inChangePercent    := COALESCE(tmp.ChangePercent, 0) ::TFloat
                                                 , inFromId           := tmp.FromId
                                                 , inToId             := tmp.ToId
                                                 , inPaidKindId       := tmp.PaidKindId
                                                 , inContractId       := tmp.ContractId
                                                 , inPartnerId        := tmp.PartnerId
                                                 , inDocumentTaxKindId:= tmp.DocumentTaxKindId
                                                 , inComment          := ''::TVarChar
                                                 , inUserId           := vbUserId
                                                   )
     INTO vbMovementId
     FROM gpGet_Movement_ChangePercent (ioId, False, inOperDate, inSession) AS tmp;

     -- ���������� ������ ���������
     PERFORM lpInsertUpdate_MovementItem_ChangePercent  (ioId            := 0
                                                       , inMovementId    := vbMovementId
                                                       , inGoodsId       := tmp.GoodsId
                                                       , inAmount        := COALESCE (tmp.Amount, 0) ::TFloat
                                                       , inPrice         := COALESCE (tmp.Price, 0)  ::TFloat
                                                       , ioCountForPrice := COALESCE (tmp.CountForPrice, 0) ::TFloat
                                                       , inGoodsKindId   := tmp.GoodsKindId
                                                       , inUserId        := vbUserId
                                                        )
    FROM gpSelect_MovementItem_ChangePercent (ioId, vbPriceListId, inOperDate, False, False, inSession)  AS tmp;
   
   -- ���������� ������ ���������
   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  02.03.23        *
*/

-- ����
-- 

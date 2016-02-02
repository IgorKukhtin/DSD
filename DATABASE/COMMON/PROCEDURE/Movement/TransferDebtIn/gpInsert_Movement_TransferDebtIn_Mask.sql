-- Function: gpInsert_Movement_TransferDebtInMask()

DROP FUNCTION IF EXISTS gpInsert_Movement_TransferDebtIn_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_TransferDebtIn_Mask(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn());

     -- ��������� �����-���� ���������
     vbPriceListId := (SELECT tmp.PriceListId FROM gpGet_Movement_TransferDebtIn (ioId, 'False', inOperDate, inSession) AS tmp );
      
      -- ��������� <��������>
      select lpInsertUpdate_Movement_TransferDebtIn (ioId               := 0
                                                   , inInvNumber        := CAST (NEXTVAL ('movement_TransferDebtIn_seq') AS TVarChar)
                                                   , inInvNumberPartner := '' ::TVarChar
                                                   , inInvNumberMark    := '' ::TVarChar
                                                   , inOperDate         := inOperDate
                                                   , inChecked          := False
                                                   , inPriceWithVAT     := tmp.PriceWithVAT
                                                   , inVATPercent       := tmp.VATPercent
                                                   , inChangePercent    := COALESCE(tmp.ChangePercent, 0) ::TFloat
                                                   , inFromId           := tmp.FromId
                                                   , inToId             := tmp.ToId
                                                   , inPaidKindFromId   := tmp.PaidKindFromId
                                                   , inPaidKindToId     := tmp.PaidKindToId
                                                   , inContractFromId   := tmp.ContractFromId
                                                   , inContractToId     := tmp.ContractToId
                                                   , inPartnerId        := tmp.PartnerId
                                                   , inPartnerFromId    := tmp.PartnerFromId
                                                   , inUserId           := vbUserId
                                                    )
     INTO vbMovementId
     FROM gpGet_Movement_TransferDebtIn (ioId, 'False', inOperDate, inSession) AS tmp;

    -- ���������� ������ ���������
    PERFORM lpInsertUpdate_MovementItem_TransferDebtIn  (ioId    := 0
                                          , inMovementId         := vbMovementId
                                          , inGoodsId            := tmp.GoodsId
                                          , inAmount             := COALESCE (tmp.Amount, 0) ::TFloat
                                          , inPrice              := COALESCE (tmp.Price, 0)  ::TFloat
                                          , ioCountForPrice      := COALESCE (tmp.CountForPrice, 0) ::TFloat
                                          , inGoodsKindId        := tmp.GoodsKindId
                                          , inUserId             := vbUserId
                                           )
   FROM gpSelect_MovementItem_TransferDebtIn (ioId, vbPriceListId, inOperDate, 'False', 'False', inSession)  AS tmp;
   
   -- ���������� ������ ���������
   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
  02.02.16        * PartnerFromId
  19.01.16        *
*/

-- ����
-- 

-- Function: gpInsert_Movement_OrderExternal_Mask()

DROP FUNCTION IF EXISTS gpInsert_Movement_OrderExternal_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_OrderExternal_Mask(
 INOUT ioId                  Integer   , -- ���� ������� <�������� >
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbPriceListId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

           -- ��������� <��������>
     vbInvNumber := CAST (NEXTVAL ('movement_OrderExternal_seq') AS TVarChar);
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_OrderExternal(), vbInvNumber, inOperDate, NULL, 0);

     PERFORM lpInsertUpdate_Movement_OrderExternal (ioId                  := vbMovementId
                                                  , inInvNumber           := vbInvNumber 
                                                  , inInvNumberPartner    := '' ::TVarChar
                                                  , inOperDate            := inOperDate
                                                  , inOperDatePartner     := inOperDate
                                                  , inOperDateMark        := inOperDate
                                                  , inPriceWithVAT        := tmp.PriceWithVAT
                                                  , inVATPercent          := tmp.VATPercent
                                                  , ioChangePercent       := tmp.ChangePercent
                                                  , inFromId              := tmp.FromId
                                                  , inToId                := tmp.ToId
                                                  , inPaidKindId          := tmp.PaidKindId
                                                  , inContractId          := tmp.ContractId
                                                  , inRouteId             := tmp.RouteId
                                                  , inRouteSortingId      := tmp.RouteSortingId
                                                  , inPersonalId          := tmp.PersonalId
                                                  , inPriceListId         := tmp.PriceListId
                                                  , inPartnerId           := tmp.PartnerId
                                                  , inisPrintComment      := tmp.isPrintComment
                                                  , inUserId              := vbUserId
                                                   )
     FROM gpGet_Movement_OrderExternal (ioId, inOperDate, FALSE, inSession) AS tmp;

     --
     SELECT tmp.PriceListId, tmp.OperDate
            INTO vbPriceListId, inOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_From())
                                               , inMovementDescId := zc_Movement_Sale() -- !!!�� ������!!!
                                               , inOperDate_order := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioId)
                                               , inOperDatePartner:= NULL
                                               , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                               , inIsPrior        := FALSE -- !!!�������� ����� �� �����!!!
                                               , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = ioId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                ) AS tmp;

   -- ���������� ������ OrderExternalGoods ���������
   PERFORM gpInsertUpdate_MovementItem_OrderExternal (ioId                 := 0
                                                    , inMovementId         := vbMovementId
                                                    , inGoodsId            := tmp.GoodsId
                                                    , inAmount             := tmp.Amount
                                                    , inAmountSecond       := tmp.AmountSecond
                                                    , inGoodsKindId        := tmp.GoodsKindId
                                                    , ioPrice              := tmp.Price
                                                    , ioCountForPrice      := tmp.CountForPrice
                                                    , inSession            := inSession
                                                     ) 
   FROM gpSelect_MovementItem_OrderExternal (ioId, vbPriceListId, inOperDate, False, False, inSession)  AS tmp;

   -- ���������� ������ ���������
   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  25.06.21        *
*/

-- ����
--
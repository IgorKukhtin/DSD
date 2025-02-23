-- Function: gpInsert_Movement_PromoMask()

DROP FUNCTION IF EXISTS gpInsert_Movement_Promo_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Promo_Mask(
 INOUT ioId                  Integer   , -- ���� ������� <�������� >
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

           -- ��������� <��������>
     vbInvNumber := CAST (NEXTVAL ('movement_Promo_seq') AS TVarChar);
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_Promo(), vbInvNumber, inOperDate, NULL, 0);

     PERFORM lpInsertUpdate_Movement_Promo( ioId             := vbMovementId
                                          , inInvNumber      := vbInvNumber
                                          , inOperDate       := tmp.OperDate
                                          , inPromoKindId    := tmp.PromoKindId
                                          , inPriceListId    := tmp.PriceListId
                                          , inStartPromo     := tmp.StartPromo
                                          , inEndPromo       := tmp.EndPromo
                                          , inStartSale      := tmp.StartSale
                                          , inEndSale        := tmp.EndSale
                                          , inEndReturn      := tmp.EndReturn
                                          , inOperDateStart  := tmp.OperDateStart
                                          , inOperDateEnd    := tmp.OperDateEnd
                                          , ioMonthPromo     := tmp.MonthPromo
                                          , inCheckDate      := Null          ::TDateTime
                                          , inChecked        := False         ::Boolean
                                          , inIsPromo        := tmp.IsPromo 
                                          , inisCost         := tmp.isCost
                                          , inCostPromo      := tmp.CostPromo
                                          , inComment        := '' ::TVarChar
                                          , inCommentMain    := tmp.CommentMain
                                          , inUnitId         := tmp.UnitId
                                          , inPersonalTradeId:= tmp.PersonalTradeId
                                          , inPersonalId     := tmp.PersonalId 
                                          , inPaidKindId     := tmp.PaidKindId
                                          , inUserId         := vbUserId
                                           )
     FROM gpGet_Movement_Promo (ioId, inOperDate, 'False', inSession) AS tmp;

   -- ���������� ������ PromoGoods ���������
   PERFORM lpInsertUpdate_MovementItem_PromoGoods (ioId                 := 0
                                                 , inMovementId         := vbMovementId
                                                 , inGoodsId            := tmp.GoodsId
                                                 , inAmount             := COALESCE (tmp.Amount, 0)        ::  TFloat
                                                 , inPrice              := COALESCE (tmp.Price, 0)         ::  TFloat
                                                 , inOperPriceList      := COALESCE (tmp.OperPriceList, 0) ::  TFloat
                                                 , inPriceSale          := COALESCE (tmp.PriceSale,0)      ::  TFloat
                                                 , inPriceWithOutVAT    := COALESCE (tmp.PriceWithOutVAT,0)::  TFloat     -- ���� �������� ��� ����� ���, � ������ ������, ���
                                                 , inPriceWithVAT       := COALESCE (tmp.PriceWithVAT,0)   ::  TFloat     -- ���� �������� � ������ ���, � ������ ������, ���
                                                 , inPriceTender        := COALESCE (tmp.PriceTender,0)    ::  TFloat     -- ���� ������ ��� ����� ���, � ������ ������, ���
                                                 , inCountForPrice      := COALESCE (tmp.CountForPrice,1)  ::  TFloat     -- ��������� �� ���� �����
                                                 , inAmountReal         := COALESCE (tmp.AmountReal,0)     ::  TFloat     -- ����� ������ � ����������� ������, ��
                                                 , inAmountPlanMin      := COALESCE (tmp.AmountPlanMin,0)  ::  TFloat     -- ������� ������������ ������ ������ �� ��������� ������ (� ��)
                                                 , inAmountPlanMax      := COALESCE (tmp.AmountPlanMax,0)  ::  TFloat     -- �������� ������������ ������ ������ �� ��������� ������ (� ��)
                                                 , inTaxRetIn           := COALESCE (tmp.TaxRetIn,0)       ::  TFloat     -- % ��������
                                                 , inGoodsKindId        := COALESCE (tmp.GoodsKindId,0)    ::  Integer    --�� ������� <��� ������>
                                                 , inGoodsKindCompleteId:= COALESCE (tmp.GoodsKindCompleteId,0)::  Integer--�� ������� <��� ������ (����������)>
                                                 , inComment            := ''                              ::  TVarChar   --�����������
                                                 , inUserId             := vbUserId
                                                  ) 
   FROM gpSelect_MovementItem_PromoGoods (ioId, 'False', inSession)  AS tmp;

   PERFORM gpInsertUpdate_Movement_PromoPartner(ioId              := 0                  ::Integer     -- ���� ������� <������� ��� ��������� �����>
                                              , inParentId        := vbMovementId       ::Integer     -- ���� ������������� ������� <�������� �����>
                                              , inPartnerId       := tmp.PartnerId      ::Integer     -- ���� ������� <���������� / �� ���� / �������� ����>
                                              , inContractId      := tmp.ContractId     ::Integer     -- ���� ������� <��������>
                                              , inComment         := ''                 ::TVarChar    -- ����������
                                              , inRetailName_inf  := tmp.RetailName_inf ::TVarChar    -- ����.���� ���.
                                              , inSession         := inSession          ::TVarChar    -- ������ ������������
                                              )
   FROM gpSelect_Movement_PromoPartner (ioId, FALSE ,inSession)  AS tmp;

   -- ���������� ������ PromoPartner ���������
   PERFORM lpInsertUpdate_MovementItem_PromoPartner (ioId         := 0
                                                   , inMovementId := tmpPP.Id
                                                   , inPartnerId  := tmp.PartnerId
                                                   , inContractId := tmp.ContractId
                                                   , inUserId     := vbUserId
                                                    ) 
   FROM gpSelect_MovementItem_PromoPartner (ioId, inSession)  AS tmp
        -- ��������� � ��� ����������� �������� Movement_PromoPartner
        INNER JOIN (SELECT tmp.Id
                    FROM gpSelect_Movement_PromoPartner (vbMovementId, FALSE ,inSession) AS tmp limit 1 ) AS tmpPP ON 1=1
        ;

   -- ���������� ������ ���������
   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  07.05.21        *
*/

-- ����
--
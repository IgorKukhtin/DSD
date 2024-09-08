-- Function: gpInsert_Movement_PromoTradeMask()

DROP FUNCTION IF EXISTS gpInsert_Movement_PromoTrade_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_PromoTrade_Mask(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());

           -- ��������� <��������>
     vbInvNumber := CAST (NEXTVAL ('movement_PromoTrade_seq') AS TVarChar);
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_PromoTrade(), vbInvNumber, inOperDate, NULL, 0);

     PERFORM lpInsertUpdate_Movement_PromoTrade( ioId             := vbMovementId
                                               , inInvNumber      := vbInvNumber
                                               , inOperDate       := tmp.OperDate
                                               , inContractId     := tmp.ContractId  
                                               , inPromoItemId    := tmp.PromoItemId
                                               , inPromoKindId    := tmp.PromoKindId
                                               , inStartPromo     := tmp.StartPromo
                                               , inEndPromo       := tmp.EndPromo
                                               , inCostPromo      := tmp.CostPromo
                                               , inComment        := '' ::TVarChar
                                               , inUserId         := vbUserId
                                                )         
     FROM gpGet_Movement_PromoTrade (ioId, inOperDate, 'False', inSession) AS tmp;

   -- ���������� ������ PromoTradeGoods ���������
   PERFORM lpInsertUpdate_MovementItem_PromoTradeGoods (ioId                 := 0
                                                      , inMovementId         := vbMovementId
                                                      , inGoodsId            := tmp.GoodsId
                                                      , inAmount             := COALESCE (tmp.Amount, 0)        ::  TFloat
                                                      , inSumm               := COALESCE (tmp.Summ, 0)        ::  TFloat
                                                      , inPartnerCount       := COALESCE (tmp.PartnerCount, 0)  ::  TFloat
                                                      , inGoodsKindId        := COALESCE (tmp.GoodsKindId,0)    ::  Integer
                                                      , inTradeMarkId        := COALESCE (tmp.TradeMarkId,0)    ::  Integer
                                                      , inGoodsGroupPropertyId := COALESCE (tmp.GoodsGroupPropertyId,0)  ::  Integer
                                                      , inGoodsGroupDirectionId:= COALESCE (tmp.GoodsGroupDirectionId,0) ::  Integer
                                                      , inComment            := ''                              ::  TVarChar
                                                      , inUserId             := vbUserId
                                                       ) 
   FROM gpSelect_MovementItem_PromoTradeGoods (ioId, 'False', inSession)  AS tmp;

 /*  PERFORM gpInsertUpdate_Movement_PromoPartner(ioId              := 0                  ::Integer     -- ���� ������� <������� ��� ��������� �����>
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
   */
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
-- Function: gpInsert_Movement_ContractGoods_Mask()

DROP FUNCTION IF EXISTS gpInsert_Movement_ContractGoods_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_ContractGoods_Mask(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ContractGoods());

           -- ��������� <��������>
     vbInvNumber := CAST (NEXTVAL ('movement_ContractGoods_seq') AS TVarChar);
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_ContractGoods(), vbInvNumber, inOperDate, NULL, 0);

     PERFORM lpInsertUpdate_Movement_ContractGoods (ioId           := vbMovementId
                                                  , ioInvNumber    := vbInvNumber
                                                  , inOperDate     := inOperDate
                                                  , inContractId   := tmp.ContractId
                                                  , inCurrencyId   := tmp.CurrencyId
                                                  , inSiteTagId    := tmp.SiteTagId
                                                  , inDiffPrice    := tmp.DiffPrice ::TFloat
                                                  , inRoundPrice   := tmp.RoundPrice::TFloat 
                                                  , inPriceWithVAT := tmp.PriceWithVAT  ::Boolean 
                                                  , inisMultWithVAT:= tmp.isMultWithVAT ::Boolean
                                                  , inComment      := '' ::TVarChar
                                                  , inUserId       := vbUserId
                                                   )
     FROM gpGet_Movement_ContractGoods (ioId, inOperDate, FALSE, inSession) AS tmp;

     -- ���������� ������ ContractGoodsGoods ���������
     PERFORM gpInsertUpdate_MovementItem_ContractGoods (ioId                 := 0
                                                      , inMovementId         := vbMovementId
                                                      , inGoodsId            := tmp.GoodsId
                                                      , inGoodsKindId        := tmp.GoodsKindId 
                                                      , inisBonusNo          := tmp.isBonusNo  
                                                      , inisSave             := tmp.isSave
                                                      , inPrice              := tmp.Price
                                                      , inChangePrice        := tmp.ChangePrice
                                                      , inChangePercent      := tmp.ChangePercent
                                                      , inCountForAmount     := tmp.CountForAmount
                                                      , inCountForPrice      := tmp.CountForPrice
                                                      , inComment            := '' :: TVarChar
                                                      , inSession            := inSession
                                                       ) 
   FROM gpSelect_MovementItem_ContractGoods (ioId, False, False, inSession)  AS tmp;

   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  29.11.23        *
  02.08.22        *
*/

-- ����
--
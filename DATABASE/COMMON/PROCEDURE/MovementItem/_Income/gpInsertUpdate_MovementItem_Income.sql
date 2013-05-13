-- Function: gpInsertUpdate_MovementItem_Income()

-- DROP FUNCTION gpInsertUpdate_MovementItem_Income();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
INOUT ioId	         Integer,   	/* ключ объекта <Приходная накладная> */
  IN inMovementId        Integer,
  IN inGoodsId           Integer,
  IN inAmount            TFloat, 
  IN inAmountPartner     TFloat, 
  IN inPrice             TFloat, 
  IN inCountForPrice     TFloat, 
  IN inLiveWeight        TFloat, 
  IN inHeadCount         TFloat, 
  IN inGoodsKindId       Integer,
  IN inSession           TVarChar       /* текущий пользователь */
)                              
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

   ioId := lpInsertUpdate_MovementItem(ioId, zc_MovementItem_Goods(), inGoodsId, inMovementId, inAmount, NULL);
   
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_GoodsKind(), ioId, inGoodsKindId);
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_Partion(), ioId, null);

   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_AmountPartner(), ioId, inAmountPartner);
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_Price(), ioId, inPrice);
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_CountForPrice(), ioId, inCountForPrice);
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_LiveWeight(), ioId, inLiveWeight);
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_HeadCount(), ioId, inHeadCount);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            
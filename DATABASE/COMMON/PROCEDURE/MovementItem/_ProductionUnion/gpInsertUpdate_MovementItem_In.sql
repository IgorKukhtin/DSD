-- Function: gpInsertUpdate_MovementItem_In()

-- DROP FUNCTION gpInsertUpdate_MovementItem_In();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_In(
INOUT ioId	         Integer,   	/* ключ объекта <Элемент прихода документа производства> */
  IN inMovementId        Integer,
  IN inGoodsId           Integer,
  IN inAmount            TFloat, 
  IN inPartionClose	 Boolean,       /* партия закрыта (да/нет)         */	
  IN inComment	         TVarChar,      /* Комментарий	                   */
  IN inCount	         TFloat,        /* Количество батонов или упаковок */
  IN inRealWeight	 TFloat,        /* Фактический вес(информативно)   */	
  IN inCuterCount        TFloat,        /* Количество кутеров	           */
  IN inReceiptId         Integer,       /* Рецептуры	                   */
  IN inSession           TVarChar       /* текущий пользователь            */
)                              
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

   ioId := lpInsertUpdate_MovementItem(ioId, zc_MovementItem_In(), inGoodsId, inMovementId, inAmount, NULL);
   
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MovementItemLink_Receipt(), ioId, inReceiptId);

   PERFORM lpInsertUpdate_MovementItemBoolean(zc_MovementItemBoolean_PartionClose(), ioId, inPartionClose);

   PERFORM lpInsertUpdate_MovementItemString(zc_MovementItemString_Comment(), ioId, inComment);

   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_Count(), ioId, inCount);
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_RealWeight(), ioId, inRealWeight);
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_CuterCount(), ioId, inCuterCount);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            
-- Function: gpInsertUpdate_MovementItem_Out()

-- DROP FUNCTION gpInsertUpdate_MovementItem_Out();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Out(
INOUT ioId	         Integer,   	/* ключ объекта <Элемент расхода документа производства> */
  IN inMovementId        Integer,
  IN inGoodsId           Integer,
  IN inAmount            TFloat, 
  IN inParentId          Integer,
  IN inAmountReceipt     TFloat,        /* Количество по рецептуре на 1 кутер */
  IN inComment	         TVarChar,      /* Комментарий	                   */
  IN inSession           TVarChar       /* текущий пользователь            */
)                              
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

   ioId := lpInsertUpdate_MovementItem(ioId, zc_MovementItem_Out(), inGoodsId, inMovementId, inAmount, inParentId);
   
   PERFORM lpInsertUpdate_MovementItemString(zc_MovementItemString_Comment(), ioId, inComment);

   PERFORM lpInsertUpdate_MovementItemFloat(zc_MovementItemFloat_AmountReceipt(), ioId, inAmountReceipt);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            
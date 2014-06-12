-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EDIComDoc(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_EDIComDoc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsPropertyId     Integer   , 
    IN inGoodsName           TVarChar  , -- Товар
    IN inGLNCode             TVarChar  , -- Товар
    IN inAmountPartner       TFloat    , -- Количество Принятое
    IN inPricePartner        TFloat    , -- Цена принятая
    IN inSummPartner         TFloat    , -- Сумма партнера
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbOrderAmount TFloat;
   DECLARE vbMovementItemId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_EDI());
     vbUserId := inSession;
     vbOrderAmount := 0;

     SELECT MovementItem.Id, MovementItem.Amount INTO vbMovementItemId, vbOrderAmount
       FROM MovementItemString 
            JOIN MovementItem ON MovementItem.Id = MovementItemString.MovementItemId 
                             AND MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Master() 
      WHERE MovementItemString.ValueData = inGLNCode
        AND MovementItemString.DescId = zc_MIString_GLNCode();

     IF COALESCE(inGoodsPropertyId, 0) <> 0 THEN
        -- Находим vbGoodsId и vbGoodsKindId
        SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId,
               ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId INTO vbGoodsId, vbGoodsKindId
     FROM ObjectString AS ObjectString_ArticleGLN
          JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                          ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectString_ArticleGLN.objectid
                         AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                         AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId
     LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                          ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectString_ArticleGLN.objectid
                         AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
     LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                          ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectString_ArticleGLN.objectid
                         AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()

         WHERE ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()           
           AND ObjectString_ArticleGLN.ValueData = inGLNCode;        
     END IF;

     vbOrderAmount := COALESCE(vbOrderAmount, 0);

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbGoodsId, inMovementId, vbOrderAmount, NULL);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GLNCode(), vbMovementItemId, inGLNCode);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), vbMovementItemId, inGoodsName);

     -- Количество Принятое
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), vbMovementItemId, inAmountPartner);
     -- Цена принятая
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPricePartner);
     -- Сумма партнера
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), vbMovementItemId, inSummPartner);


     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbMovementItemId, vbGoodsKindId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.14                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')

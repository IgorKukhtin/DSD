-- Function: gpInsertUpdate_MI_ContractGoods_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ContractGoods_Load (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ContractGoods_Load(
    IN inMovementId          Integer   , -- Ключ объекта
    IN inGoodsCode           Integer   , -- Товары
    IN inGoodsName           TVarChar  ,
    IN inGoodsKindName       TVarChar  , -- Виды товаров
    IN inPrice               TFloat    , -- 
    IN inChangePrice         TFloat    , -- Скидка в цене
    IN inChangePercent       TFloat    , -- % Скидки 
    IN inCountForAmount      TFloat    , -- Коэфф перевода из кол-ва поставщика
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbMIId        Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ContractGoods());

     IF inGoodsCode = 0 AND TRIM (inGoodsName) = ''
     THEN
         RETURN;
     END IF;

     -- Найти Id товара
    vbGoodsId:= (SELECT Object.Id
                 FROM Object
                 WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGoodsName))
                   AND Object.ObjectCode = inGoodsCode
                   AND Object.DescId = zc_Object_Goods()
                 LIMIT 1 --
                );
 
     -- находим товар по коду
     vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode AND inGoodsCode > 0);

     IF COALESCE (vbGoodsId,0) = 0 AND inGoodsCode > 0
     THEN
        RAISE EXCEPTION 'Ошибка. Товар <%> по коду <%> не найден.', inGoodsName, inGoodsCode;
     END IF;


     -- находим вид товара
     vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind() AND TRIM (inGoodsKindName) <> '');

     IF COALESCE (vbGoodsKindId,0) = 0 AND TRIM (inGoodsKindName) <> ''
     THEN
        RAISE EXCEPTION 'Ошибка. Вид товара по названию <%> не найден.', inGoodsKindName;
     END IF;



     --пробуем найти строку если уже создана
     vbMIId := (SELECT MovementItem.Id
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                   AND MovementItem.ObjectId = vbGoodsId
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE(vbGoodsKindId,0)
                );

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_ContractGoods (ioId            := COALESCE (vbMIId,0) ::Integer
                                                      , inMovementId    := inMovementId
                                                      , inGoodsId       := vbGoodsId
                                                      , inGoodsKindId   := vbGoodsKindId
                                                      , inisBonusNo     := FALSE
                                                      , inPrice         := inPrice
                                                      , inChangePrice   := inChangePrice
                                                      , inChangePercent := inChangePercent
                                                      , inCountForAmount:= inCountForAmount
                                                      , inCountForPrice := 1 ::TFloat
                                                      , inComment       := inComment
                                                      , inUserId        := vbUserId
                                                       ) ;
                                                       
                                                       
  
     IF vbUserId = 9457
     THEN
         RAISE EXCEPTION 'Ошибка.ok.';
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.24        *
*/

-- тест
--
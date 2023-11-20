-- Function: gpInsertUpdate_MI_OrderInternal_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderInternal_Child(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inObjectId               Integer   , -- Комплектующие 
    IN inReceiptLevelId         Integer   , -- Этап сборки
    IN inColorPatternId         Integer   , -- Шаблон Boat Structure 
    IN inProdColorPatternId     Integer   , -- Boat Structure  
    IN inProdOptionsId          Integer   , -- Опция
    IN inUnitId                 Integer   , -- Место учета
    IN inAmount                 TVarChar    , -- Количество (шаблон сборки)
    IN inAmountReserv           TFloat    , -- Количество резерв
    IN inAmountSend             TFloat    , -- Кол-во приход от поставщ./перемещение
 INOUT ioForCount               TFloat    , -- Для кол-во 
    IN inisChangeReceipt        Boolean   ,  -- "заменить значение в шаблоне сборки да/нет"
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$ 
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;              
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsId_parent Integer;
   DECLARE vbReceiptGoodsChildId Integer; 
   DECLARE vbAmount TFloat;  
   DECLARE vbValue   NUMERIC (16, 8);
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := lpGetUserBySession (inSession);

     -- переводим
     vbValue := (zfConvert_StringToFloat (REPLACE (inAmount, ',' , '.')) ) ;
 
     -- замена ioValue если больше 4-х знаков, тогда ForCount = 1000 а в ioValue записсываем ioValue * 1000
     IF (vbValue <> vbValue :: TFloat) 
     THEN
         ioForCount:= 1000; 
         vbValue   := (vbValue * 1000) :: TFloat; 
     ELSEIF COALESCE (ioForCount, 0) = 0 OR (vbValue = vbValue :: TFloat)
     THEN
         ioForCount:= 1; 
     END IF;

    --если  inisChangeReceipt = true   заменить значение в шаблоне сборки 
     IF COALESCE (inisChangeReceipt,False) = TRUE AND COALESCE (ioId,0) <> 0
     THEN
         --
         vbGoodsId := (SELECT MI.ObjectId FROM MovementItem AS MI WHERE MI.Id = ioId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE);
         vbAmount  := (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE);
         --по товару из мастера найдем потом ReceiptGoodsChild  (zc_ObjectLink_ReceiptGoodsChild_GoodsChild )
         vbGoodsId_parent := (SELECT MI.ObjectId FROM MovementItem AS MI WHERE MI.Id = inParentId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE);  

         --находим  шаблон
         vbReceiptGoodsChildId:= (SELECT Object_ReceiptGoodsChild.Id AS ReceiptGoodsChildId 
                                  FROM 
                                      (SELECT Object_ReceiptGoods.Id
                                            , ObjectLink_Goods.ChildObjectId AS GoodsId
                                       FROM Object AS Object_ReceiptGoods
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                                 ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                                AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
                                       WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                                        AND (Object_ReceiptGoods.isErased = FALSE )
                                        AND ObjectLink_Goods.ChildObjectId = vbGoodsId_parent
                                      UNION ALL
                                       SELECT DISTINCT
                                              Object_ReceiptGoods.Id
                                            , ObjectLink_GoodsChild.ChildObjectId AS GoodsId
                                       FROM Object AS Object_ReceiptGoods
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                                 ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                                AND ObjectLink_Goods.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                                 ON ObjectLink_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                                AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                            INNER JOIN Object AS Object_ReceiptGoodsChild
                                                              ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoods.ObjectId
                                                             AND Object_ReceiptGoodsChild.isErased = FALSE
                                            INNER JOIN ObjectLink AS ObjectLink_GoodsChild
                                                                  ON ObjectLink_GoodsChild.ObjectId      = Object_ReceiptGoodsChild.Id
                                                                 AND ObjectLink_GoodsChild.DescId        = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                                                 AND ObjectLink_GoodsChild.ChildObjectId > 0

                                       WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                                        AND (Object_ReceiptGoods.isErased = FALSE )
                                         AND ObjectLink_GoodsChild.ChildObjectId = vbGoodsId_parent
                                       ) AS tmpReceiptGoods

                                      INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                            ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                           AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = tmpReceiptGoods.Id
                                  
                                      INNER JOIN Object AS Object_ReceiptGoodsChild
                                                        ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                        -- не удален
                                                       AND Object_ReceiptGoodsChild.isErased = FALSE

                                      LEFT JOIN ObjectLink AS ObjectLink_Object
                                                           ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                          AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                      INNER JOIN Object AS Object_Object
                                                        ON Object_Object.Id     = ObjectLink_Object.ChildObjectId
                                                       -- это НЕ услуги и НЕ пустой Boat Structure
                                                       AND Object_Object.DescId = zc_Object_Goods()
                                                       AND ObjectLink_Object.ChildObjectId = vbGoodsId

                                      LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                           ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                          AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()

                                      LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                            ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                               
                                  WHERE COALESCE (ObjectLink_ReceiptLevel.ChildObjectId ,0)= COALESCE (inReceiptLevelId,0)
                                  --  AND COALESCE (ObjectFloat_Value.ValueData,0) = COALESCE (vbAmount,0)
                                  LIMIT 1   
                                 );
 
         IF COALESCE (vbReceiptGoodsChildId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден <Шаблон> для записи значения.';
         END IF;
         
         --перезаписываем Значения
         IF EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inProdColorPatternId AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_ProdColorPattern_Goods())
         THEN
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_Object(), vbReceiptGoodsChildId, inObjectId);
         ELSE
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_Object(), vbReceiptGoodsChildId, inObjectId);
         END IF;
         
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_Value(), vbReceiptGoodsChildId, vbValue);                                           
                                            
     END IF;



     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MI_OrderInternal_Child (ioId                := ioId
                                               , inParentId          := inParentId
                                               , inMovementId        := inMovementId
                                               , inObjectId          := inObjectId
                                               , inReceiptLevelId    := inReceiptLevelId
                                               , inColorPatternId    := inColorPatternId
                                               , inProdColorPatternId:= inProdColorPatternId
                                               , inProdOptionsId     := inProdOptionsId
                                               , inUnitId            := inUnitId
                                               , inAmount            := vbValue
                                               , inAmountReserv      := inAmountReserv
                                               , inAmountSend        := inAmountSend
                                               , inForCount          := ioForCount
                                               , inUserId            := vbUserId
                                                ) AS tmp;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.11.23         *
 13.02.23         *
*/

-- тест
-- SELECT * FROM 
-- Function: gpInsertUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inObjectId               Integer   , -- Комплектующие
    IN inReceiptLevelId         Integer   , -- Этап сборки
    IN inColorPatternId         Integer   , -- Шаблон Boat Structure 
    IN inProdColorPatternId     Integer   , -- Boat Structure  
    IN inProdOptionsId          Integer   , -- Опция
    IN inAmount                 TVarChar    , -- Количество резерв 
 INOUT ioForCount               TFloat    , -- Для кол-во
    IN inisChangeReceipt        Boolean   ,  -- "заменить значение в шаблоне сборки да/нет"
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbReceiptProdModelId Integer;   
   DECLARE vbReceiptGoodsChildId    Integer;
   DECLARE vbGoodsId    Integer;
   DECLARE vbAmount TFloat;  
   DECLARE vbValue   NUMERIC (16, 8);
   
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
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

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     --если  inisChangeReceipt = true   заменить значение в шаблоне сборки 
     IF COALESCE (inisChangeReceipt,False) = TRUE AND COALESCE (ioId,0) <> 0
     THEN
         --по inParentId находим inReceiptProdModelId
         vbReceiptProdModelId:= (SELECT MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId 
                                 FROM MovementItemLinkObject AS MILO_ReceiptProdModel
                                 WHERE MILO_ReceiptProdModel.MovementItemId = inParentId
                                   AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()
                                ); 
         --находим предыдущие сохраненные значения 
         vbGoodsId := (SELECT MI.ObjectId FROM MovementItem AS MI WHERE MI.Id = ioId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE);
         vbAmount  := (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE);  
    
         --пероверка
         IF COALESCE (vbReceiptProdModelId,0) = 0
         THEN
              RAISE EXCEPTION 'Ошибка.Не установлено значение <Шаблон сборки Модели или Узла>.';
         END IF;
         
         --находим  шаблон
         vbReceiptGoodsChildId:= (SELECT Object_ReceiptGoodsChild.Id AS ReceiptGoodsChildId 
                                  FROM ObjectLink AS ObjectLink_ReceiptGoods
                                      INNER JOIN Object AS Object_ReceiptGoodsChild
                                                         ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoods.ObjectId
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

                                  WHERE ObjectLink_ReceiptGoods.ChildObjectId = vbReceiptProdModelId
                                    AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() 
                                    AND COALESCE (ObjectLink_ReceiptLevel.ChildObjectId ,0)= COALESCE (inReceiptLevelId,0)
                                    AND COALESCE (ObjectFloat_Value.ValueData,0) = COALESCE (vbAmount,0) 
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


     -- сохранили <Элемент документа>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MI_ProductionUnion_Child (ioId                := ioId
                                                 , inParentId          := inParentId
                                                 , inMovementId        := inMovementId
                                                 , inObjectId          := inObjectId
                                                 , inReceiptLevelId    := inReceiptLevelId
                                                 , inColorPatternId    := inColorPatternId
                                                 , inProdColorPatternId:= inProdColorPatternId
                                                 , inProdOptionsId     := inProdOptionsId
                                                 , inAmount            := vbValue
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
 12.07.21         *
*/

-- тест
-- SELECT * FROM 
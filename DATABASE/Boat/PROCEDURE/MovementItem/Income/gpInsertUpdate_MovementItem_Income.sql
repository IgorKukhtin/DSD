-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>  
    IN inFromId              Integer   , -- 
    IN inToId                Integer   , -- 
    IN inOperDate            TDateTime , --
    IN inPartionId           Integer   , -- Партия
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inEmpfPrice           TFloat    , -- Цена рекомендованная без НДС прихода
    IN inOperPrice           TFloat    , -- Цена прихода
    IN inOperPriceList       TFloat    , -- Цена продажи
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inTaxKindValue        TFloat    , -- Значение НДС (!информативно!)
    IN inGoodsGroupId        Integer   , -- Группа товара
    IN inGoodsTagId          Integer   , -- Категория
    IN inGoodsTypeId         Integer   , -- Тип детали 
    IN inGoodsSizeId         Integer   , -- Размер
    IN inProdColorId         Integer   , -- Цвет
    IN inMeasureId           Integer   , -- Единица измерения
    IN inTaxKindId           Integer   , -- Тип НДС (!информативно!)                                            
    IN inPartNumber          TVarChar  , --№ по тех паспорту
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperPriceList_old TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF COALESCE (ioId, 0) <> 0
     THEN
         vbOperPriceList_old:= (SELECT Object_PartionGoods.OperPriceList FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId)::TFloat;
     ELSE
         vbOperPriceList_old := inOperPriceList;
     END IF;
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_Income (ioId         ::Integer
                                               , inMovementId ::Integer
                                               , inPartionId  ::Integer
                                               , inGoodsId    ::Integer
                                               , inAmount     ::TFloat
                                               , inOperPrice  ::TFloat
                                               , inCountForPrice ::TFloat
                                               , inPartNumber ::TVarChar
                                               , inComment    ::TVarChar
                                               , vbUserId     ::Integer
                                               );

     --сохраняем партию
     inPartionId := lpInsertUpdate_Object_PartionGoods(inMovementItemId    := ioId                 ::Integer       -- Ключ партии
                                                     , inMovementId        := inMovementId         ::Integer       -- Ключ Документа
                                                     , inFromId            := inFromId             ::Integer       -- Поставщик или Подразделение (место сборки)
                                                     , inUnitId            := inToId               ::Integer       -- Подразделение(прихода)
                                                     , inOperDate          := inOperDate           ::TDateTime     -- Дата прихода
                                                     , inObjectId          := inGoodsId            ::Integer       -- Комплектующие или Лодка
                                                     , inAmount            := inAmount             ::TFloat        -- Кол-во приход
                                                     , inEKPrice           := inOperPrice          ::TFloat        -- Цена вх. без НДС
                                                     , inCountForPrice     := COALESCE (inCountForPrice, 1)  ::TFloat  -- Цена за количество
                                                     , inEmpfPrice         := inEmpfPrice          ::TFloat        -- Цена рекоменд. без НДС
                                                     , inOperPriceList     := inOperPriceList      ::TFloat        -- Цена продажи, !!!грн!!!
                                                     , inOperPriceList_old := vbOperPriceList_old  ::TFloat        -- Цена продажи, ДО изменения строки
                                                     , inGoodsGroupId      := inGoodsGroupId       ::Integer       -- Группа товара
                                                     , inGoodsTagId        := inGoodsTagId         ::Integer       -- Категория
                                                     , inGoodsTypeId       := inGoodsTypeId        ::Integer       -- Тип детали 
                                                     , inGoodsSizeId       := inGoodsSizeId        ::Integer       -- Размер
                                                     , inProdColorId       := inProdColorId        ::Integer       -- Цвет
                                                     , inMeasureId         := inMeasureId          ::Integer       -- Единица измерения
                                                     , inTaxKindId         := inTaxKindId          ::Integer       -- Тип НДС (!информативно!)
                                                     , inTaxKindValue      := inTaxKindValue       ::TFloat        -- Значение НДС (!информативно!)
                                                     , inUserId            := vbUserId             ::Integer       --
                                                 );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.21         *
*/

-- тест
-- 
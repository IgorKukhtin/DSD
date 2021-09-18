-- Function: gpInsertUpdate_MovementItem_Income()


DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TDateTime, Integer, Integer
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer
                                                          , TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>  
    --IN inFromId              Integer   , -- 
    --IN inToId                Integer   , -- 
    --IN inOperDate            TDateTime , --
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inEmpfPrice           TFloat    , -- Цена рекомендованная без НДС прихода
    IN inOperPrice           TFloat    , -- Цена прихода
    IN inOperPriceList       TFloat    , -- Цена продажи
    IN inCountForPrice       TFloat    , -- Цена за кол.
    --IN inTaxKindValue        TFloat    , -- Значение НДС (!информативно!)
    IN inGoodsGroupId        Integer   , -- Группа товара
    IN inGoodsTagId          Integer   , -- Категория
    IN inGoodsTypeId         Integer   , -- Тип детали 
    IN inGoodsSizeId         Integer   , -- Размер
    IN inProdColorId         Integer   , -- Цвет
    IN inMeasureId           Integer   , -- Единица измерения
    --IN inTaxKindId           Integer   , -- Тип НДС (!информативно!)                                            
    IN inPartNumber          TVarChar  , --№ по тех паспорту
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperPriceList_old TFloat;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbTaxKindId Integer;
   DECLARE vbTaxKindValue TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

     -- из шапки
     SELECT Movement.OperDate
          , MovementLinkObject_To.ObjectId     AS ToId
          , MovementLinkObject_From.ObjectId   AS FromId
          , OF_TaxKind_Value.ObjectId          AS TaxKindId
          , MovementFloat_VATPercent.ValueData AS TaxKindValue
            INTO vbOperDate, vbToId, vbFromId, vbTaxKindId, vbTaxKindValue
     FROM Movement
      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
      LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                              ON MovementFloat_VATPercent.MovementId = Movement.Id
                             AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
      LEFT JOIN ObjectFloat AS OF_TaxKind_Value
                            ON OF_TaxKind_Value.ValueData = MovementFloat_VATPercent.ValueData
                           AND OF_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
     WHERE Movement.Id = inMovementId
    ;

     --проверка если не нашли TaxKindId - выдается ошибка
     IF COALESCE (vbTaxKindId,0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка.Не определен Тип НДС.';
     END IF;
     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF COALESCE (ioId, 0) <> 0
     THEN
         vbOperPriceList_old:= (SELECT Object_PartionGoods.OperPriceList FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId);
     ELSE
         vbOperPriceList_old := inOperPriceList;
     END IF;
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_Income (ioId         ::Integer
                                               , inMovementId ::Integer
                                               , inGoodsId    ::Integer
                                               , inAmount     ::TFloat
                                               , inOperPrice  ::TFloat
                                               , inCountForPrice ::TFloat
                                               , inPartNumber ::TVarChar
                                               , inComment    ::TVarChar
                                               , vbUserId     ::Integer
                                               );

     -- сохранили партию
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := ioId                 ::Integer       -- Ключ партии
                                               , inMovementId        := inMovementId         ::Integer       -- Ключ Документа
                                               , inFromId            := vbFromId             ::Integer       -- Поставщик или Подразделение (место сборки)
                                               , inUnitId            := vbToId               ::Integer       -- Подразделение(прихода)
                                               , inOperDate          := vbOperDate           ::TDateTime     -- Дата прихода
                                               , inObjectId          := inGoodsId            ::Integer       -- Комплектующие или Лодка
                                               , inAmount            := inAmount             ::TFloat        -- Кол-во приход
                                               , inEKPrice           := inOperPrice          ::TFloat        -- Цена вх. без НДС, ???с учетом скидки???
                                               , inCountForPrice     := inCountForPrice      ::TFloat        -- Цена за количество
                                               , inEmpfPrice         := inEmpfPrice          ::TFloat        -- Цена рекоменд. без НДС
                                               , inOperPriceList     := inOperPriceList      ::TFloat        -- Цена продажи, !!!грн!!!
                                               , inOperPriceList_old := vbOperPriceList_old  ::TFloat        -- Цена продажи, ДО изменения строки
                                               , inGoodsGroupId      := inGoodsGroupId       ::Integer       -- Группа товара
                                               , inGoodsTagId        := inGoodsTagId         ::Integer       -- Категория
                                               , inGoodsTypeId       := inGoodsTypeId        ::Integer       -- Тип детали 
                                               , inGoodsSizeId       := inGoodsSizeId        ::Integer       -- Размер
                                               , inProdColorId       := inProdColorId        ::Integer       -- Цвет
                                               , inMeasureId         := inMeasureId          ::Integer       -- Единица измерения
                                               , inTaxKindId         := vbTaxKindId          ::Integer       -- Тип НДС (!информативно!)
                                               , inTaxKindValue      := vbTaxKindValue       ::TFloat        -- Значение НДС (!информативно!)
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
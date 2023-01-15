--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeSN_Load (TDateTime, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IncomeSN_Load(
    IN inOperDate                   TDateTime,     -- дата документа
    IN inArticle                    TVarChar,      -- Article
    IN inPartNumber                 TVarChar,      -- № по техпаспорту  -- S/N
    IN inPrice                      TFloat  ,      -- цена без ндс
    IN inSession                    TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbToId             Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbPartnerId        Integer;
  DECLARE vbVATPercent       TFloat;
  DECLARE vbDiscountTax      TFloat;
  DECLARE vbOperPriceList    TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Временно - Склад
     vbToId:= 35139;

     -- RAISE EXCEPTION 'Ошибка. inArticle = <%>  Не найден.', inArticle;

     -- Проверка
     /*IF TRIM (COALESCE (inPartNumber, '')) = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден inPartNumber = <%>.', inPartNumber;
     END IF;*/


     IF COALESCE (inArticle,'') <> ''
     THEN
          -- поиск в спр. товара
          vbGoodsId := (SELECT ObjectString_Article.ObjectId
                        FROM ObjectString AS ObjectString_Article
                             INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                              AND Object.DescId   = zc_Object_Goods()
                                              AND Object.isErased = FALSE
                        WHERE ObjectString_Article.ValueData = inArticle
                          AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                        LIMIT 1
                       );

          -- Eсли не нашли пропускаем
          IF COALESCE (vbGoodsId,0) = 0
          THEN
               --RAISE EXCEPTION 'Ошибка. inArticle = <%>  Не найден.', inArticle;
               RETURN;
          END IF;

          -- Находим поставщика
          SELECT Object_Partner.Id
               , ObjectFloat_TaxKind_Value.ValueData::TFloat
               , ObjectFloat_DiscountTax.ValueData ::TFloat
                 INTO vbPartnerId, vbVATPercent, vbDiscountTax
          FROM ObjectLink AS ObjectLink_Goods_Partner
               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Goods_Partner.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                    ON ObjectLink_TaxKind.ObjectId = Object_Partner.Id
                                   AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Partner_TaxKind()

               LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                     ON ObjectFloat_TaxKind_Value.ObjectId = COALESCE (ObjectLink_TaxKind.ChildObjectId, zc_Enum_TaxKind_Basis())
                                    AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

               LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                     ON ObjectFloat_DiscountTax.ObjectId = Object_Partner.Id
                                    AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Partner_DiscountTax()

          WHERE ObjectLink_Goods_Partner.ObjectId = vbGoodsId
            AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
          --LIMIT 1
         ;

          -- Eсли не нашли пропускаем
          IF COALESCE (vbPartnerId,0) = 0
          THEN
               RETURN;
          END IF;

          -- пробуем найти документ
          vbMovementId := (SELECT Movement.Id
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                             AND MovementLinkObject_From.ObjectId   = vbPartnerId
                                INNER JOIN MovementString AS MovementString_Comment
                                                          ON MovementString_Comment.MovementId = Movement.Id
                                                         AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                                                         AND MovementString_Comment.ValueData  ILIKE 'auto S/N'
                           WHERE Movement.OperDate = inOperDate
                             AND Movement.DescId   = zc_Movement_Income()
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                          );
          -- Eсли не нашли создаем
          IF COALESCE (vbMovementId,0) = 0
          THEN
               --
               vbMovementId := lpInsertUpdate_Movement_Income(ioId                 := 0
                                                            , inInvNumber          := CAST (NEXTVAL ('movement_Income_seq') AS TVarChar)
                                                            , inInvNumberPartner   := ''
                                                            , inOperDate           := inOperDate
                                                            , inOperDatePartner    := inOperDate
                                                            , inPriceWithVAT       := FALSE
                                                            , inVATPercent         := vbVATPercent
                                                            , inDiscountTax        := vbDiscountTax
                                                            , inFromId             := vbPartnerId
                                                            , inToId               := vbToId
                                                            , inPaidKindId         := zc_Enum_PaidKind_FirstForm()
                                                            , inComment            := 'auto S/N'
                                                            , inUserId             := vbUserId
                                                            );
          END IF;

          -- поиск элемента с таким товаром + Партия, вдруг уже загрузили, тогда обновляем
          vbMovementItemId := (SELECT MovementItem.Id
                               FROM MovementItem
                                    LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                 ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                                AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                               WHERE MovementItem.MovementId = vbMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.ObjectId   = vbGoodsId
                                 AND COALESCE (MIString_PartNumber.ValueData, '') = inPartNumber

                              );

         -- цена продажи из базового прайса
         vbOperPriceList :=(SELECT tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := inOperDate) AS tmp
                            WHERE tmp.GoodsId = vbGoodsId
                           );

          -- сохранили <Элемент документа>
          vbMovementItemId:= lpInsertUpdate_MovementItem_Income (ioId            := vbMovementItemId
                                                               , inMovementId    := vbMovementId
                                                               , inGoodsId       := vbGoodsId
                                                               , inAmount        := 1
                                                               , inOperPrice     := inPrice
                                                               , inCountForPrice := 1
                                                               , inOperPriceList := COALESCE (vbOperPriceList, 0)
                                                               , inPartNumber    := inPartNumber
                                                               , inComment       := ''
                                                               , inUserId        := vbUserId
                                                                );

          -- сохраняем партию
          PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := vbMovementItemId
                                                    , inMovementId        := vbMovementId
                                                    , inFromId            := vbPartnerId
                                                    , inUnitId            := vbToId
                                                    , inOperDate          := inOperDate
                                                    , inObjectId          := vbGoodsId
                                                    , inAmount            := 1
                                                      --
                                                    , inEKPrice           := inPrice             -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка = inEKPrice_discount + inCostPrice
                                                    , inEKPrice_orig      := inPrice             -- Цена вх. без НДС, с учетом ТОЛЬКО скидки по элементу
                                                    , inEKPrice_discount  := inPrice             -- Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
                                                    , inCostPrice         := 0                   -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
                                                    , inCountForPrice     := 1
                                                      --
                                                    , inEmpfPrice         := ObjectFloat_EmpfPrice.ValueData
                                                    , inOperPriceList     := COALESCE (vbOperPriceList, 0)
                                                    , inOperPriceList_old := 0
                                                      --
                                                    , inTaxKindId         := COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, 0)
                                                    , inTaxKindValue      := COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0)
                                                    , inUserId            := vbUserId
                                                     )
          FROM Object
               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                    ON ObjectLink_Goods_GoodsGroup.ObjectId = Object.Id
                                   AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                    ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
               LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                    ON ObjectLink_Goods_TaxKind.ObjectId = Object.Id
                                   AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
               LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                     ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                    AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                    ON ObjectLink_Goods_GoodsTag.ObjectId = Object.Id
                                   AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                    ON ObjectLink_Goods_GoodsType.ObjectId = Object.Id
                                   AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                    ON ObjectLink_Goods_GoodsSize.ObjectId = Object.Id
                                   AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
               LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                    ON ObjectLink_Goods_ProdColor.ObjectId = Object.Id
                                   AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
               LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                     ON ObjectFloat_EmpfPrice.ObjectId = Object.Id
                                    AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()
          WHERE Object.Id = vbGoodsId;

         -- дописали партию
         UPDATE MovementItem SET PartionId = vbMovementItemId WHERE MovementItem.Id = vbMovementItemId;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.08.21         *
*/

-- тест
--
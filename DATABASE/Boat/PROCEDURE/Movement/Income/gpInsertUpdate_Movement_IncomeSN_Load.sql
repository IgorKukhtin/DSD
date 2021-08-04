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

   IF COALESCE (inArticle,0) <> 0
   THEN
          -- поиск в спр. товара
          vbGoodsId := (SELECT ObjectString_Article.ObjectId
                        FROM ObjectString AS ObjectString_Article
                             INNER JOIN Object ON Object.Id = ObjectString_Article.ObjectId
                                              AND Object.DescId = zc_Object_Goods()
                                              AND Object.isErased = FALSE
                        WHERE ObjectString_Article.DescId = zc_ObjectString_Article()
                          AND ObjectString_Article.ValueData = inArticle
                        limit 1
                        );
   
          -- Eсли не нашли пропускаем
          IF COALESCE (vbGoodsId,0) = 0
          THEN
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
           limit 1;

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
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                             AND MovementLinkObject_From.ObjectId = vbPartnerId
                           WHERE Movement.DescId = zc_Movement_Income()
                             AND Movement.OperDate = inOperDate
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                           );
          -- Eсли не нашли создаем
          IF COALESCE (vbMovementId,0) = 0
          THEN
               --
               vbMovementId := lpInsertUpdate_Movement_Income(ioId                 := 0
                                                            , inInvNumber          := CAST (NEXTVAL ('movement_Income_seq') AS TVarChar) 
                                                            , inInvNumberPartner   := ''            ::TVarChar
                                                            , inOperDate           := inOperDate    ::TDateTime
                                                            , inOperDatePartner    := NULL          ::TDateTime
                                                            , inPriceWithVAT       := False         ::Boolean
                                                            , inVATPercent         := vbVATPercent  ::TFloat
                                                            , inDiscountTax        := vbDiscountTax ::TFloat
                                                            , inFromId             := vbPartnerId   ::Integer
                                                            , inToId               := 35139         ::Integer -- Склад
                                                            , inPaidKindId         := zc_Enum_PaidKind_FirstForm() ::Integer
                                                            , inComment            := 'auto'        ::TVarChar
                                                            , inUserId             := vbUserId      ::Integer
                                                            );
          END IF;
          
          --ищем такой товар, вдруг уже загрузили, тогда обновляем 
          vbMovementItemId := (SELECT MovementItem.Id
                               FROM MovementItem
                               WHERE MovementItem.MovementId = vbMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = False
                                 AND MovementItem.ObjectId = vbGoodsId
                               );
                               
          -- сохранили <Элемент документа>
          vbMovementItemId:= lpInsertUpdate_MovementItem_Income (ioId            := COALESCE (vbMovementItemId,0) ::Integer
                                                               , inMovementId    := vbMovementId ::Integer
                                                               , inPartionId     := Null         ::Integer
                                                               , inGoodsId       := vbGoodsId    ::Integer
                                                               , inAmount        := 1            ::TFloat
                                                               , inOperPrice     := inPrice      ::TFloat
                                                               , inCountForPrice := 1            ::TFloat
                                                               , inPartNumber    := inPartNumber ::TVarChar
                                                               , inComment       := ''           ::TVarChar
                                                               , inUserId        := vbUserId     ::Integer
                                                               );



         --цена продажи из базового прайса
         vbOperPriceList :=(SELECT tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := inOperDate) AS tmp
                            WHERE tmp.GoodsId = vbGoodsId
                            );
                       
          --сохраняем партию
          PERFORM lpInsertUpdate_Object_PartionGoods(inMovementItemId    := vbMovementItemId     ::Integer       -- Ключ партии
                                                   , inMovementId        := vbMovementId         ::Integer       -- Ключ Документа
                                                   , inFromId            := vbPartnerId          ::Integer       -- Поставщик или Подразделение (место сборки)
                                                   , inUnitId            := 0                    ::Integer       -- Подразделение(прихода)
                                                   , inOperDate          := inOperDate           ::TDateTime     -- Дата прихода
                                                   , inObjectId          := vbGoodsId            ::Integer       -- Комплектующие или Лодка
                                                   , inAmount            := 1                    ::TFloat        -- Кол-во приход
                                                   , inEKPrice           := inPrice              ::TFloat        -- Цена вх. без НДС
                                                   , inCountForPrice     := 1                    ::TFloat  -- Цена за количество
                                                   , inEmpfPrice         := ObjectFloat_EmpfPrice.ValueData ::TFloat        -- Цена рекоменд. без НДС
                                                   , inOperPriceList     := vbOperPriceList      ::TFloat        -- Цена продажи, !!!грн!!!
                                                   , inOperPriceList_old := 0                    ::TFloat        -- Цена продажи, ДО изменения строки
                                                   , inGoodsGroupId      := ObjectLink_Goods_GoodsGroup.ChildObjectId       ::Integer       -- Группа товара
                                                   , inGoodsTagId        := ObjectLink_Goods_GoodsTag.ChildObjectId         ::Integer       -- Категория
                                                   , inGoodsTypeId       := ObjectLink_Goods_GoodsType.ChildObjectId        ::Integer       -- Тип детали 
                                                   , inGoodsSizeId       := ObjectLink_Goods_GoodsSize.ChildObjectId        ::Integer       -- Размер
                                                   , inProdColorId       := ObjectLink_Goods_ProdColor.ChildObjectId        ::Integer       -- Цвет
                                                   , inMeasureId         := ObjectLink_Goods_Measure.ChildObjectId          ::Integer       -- Единица измерения
                                                   , inTaxKindId         := COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, 0) ::Integer       -- Тип НДС (!информативно!)
                                                   , inTaxKindValue      := COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) ::TFloat        -- Значение НДС (!информативно!)
                                                   , inUserId            := vbUserId             ::Integer       --
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
                                     ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                                    AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()
          WHERE Object.Id = vbGoodsId;

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
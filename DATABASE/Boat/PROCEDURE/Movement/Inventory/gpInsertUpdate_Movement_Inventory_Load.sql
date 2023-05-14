
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory_Load (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory_Load(
    IN inMovementId                 Integer,     -- 
    IN inPartnerName                TVarChar,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      --
    IN inRemains                    TFloat  ,
    IN inAmount                     TFloat  ,
    IN inSession                    TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId          Integer;
  DECLARE vbGoodsId         Integer;
  DECLARE vbPartnerId       Integer;
  DECLARE vbMovementItemId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    -- Eсли не нашли пропускаем
   /* IF COALESCE (inPartnerName,'') = ''
    THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Поставщик';
    END IF;
   */
   IF COALESCE (inArticle,'') <> '' OR COALESCE (inGoodsName,'') <> ''
   THEN
       
     -- проверка <inPLZ>
     IF 1=0 AND TRIM (COALESCE (inPartnerName, '')) = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Partner> должно быть установлено.';
     END IF;

     -- поиск поставщика
     vbPartnerId := (SELECT Object.Id
                     FROM Object 
                     WHERE Object.DescId = zc_Object_Partner()
                       AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM (inPartnerName))
                     );
     IF COALESCE (vbPartnerId,0) = 0 
     THEN
         --RAISE EXCEPTION 'Ошибка.Не найден Поставщик <%>', inPartnerName;
       -- создаем
       SELECT tmp.ioId
              INTO vbPartnerId
       FROM gpInsertUpdate_Object_Partner(ioId           := 0          :: Integer
                                        , ioCode         := 0          :: Integer
                                        , inName         := TRIM (inPartnerName) :: TVarChar
                                        , inComment      := ''         :: TVarChar
                                        , inFax          := '' :: TVarChar
                                        , inPhone        := '' :: TVarChar
                                        , inMobile       := '' :: TVarChar
                                        , inIBAN         := '' :: TVarChar
                                        , inStreet       := '' :: TVarChar
                                        , inMember       := '' :: TVarChar
                                        , inWWW          := '' :: TVarChar
                                        , inEmail        := '' :: TVarChar
                                        , inCodeDB       := '' :: TVarChar
                                        , inTaxNumber    := ''
                                        , inDiscountTax  := 0
                                        , inDayCalendar  := 0
                                        , inDayBank      := 0
                                        , inBankId       := 0  :: Integer  
                                        , inPLZId        := 0  :: Integer 
                                        , inInfoMoneyId  := zc_Enum_InfoMoney_10101()
                                        , inTaxKindId    := zc_Enum_TaxKind_Basis() -- 19.0%
                                        , inPaidKindId   := zc_Enum_PaidKind_FirstForm() ::Integer
                                        , inSession      := inSession       :: TVarChar
                                         ) AS tmp;         
     END  IF;
     
     IF COALESCE (inArticle,'') <> ''
     THEN
         -- поиск в спр. товара
         vbGoodsId := (SELECT ObjectString_Article.ObjectId
                       FROM ObjectString AS ObjectString_Article
                            INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                             AND Object.DescId   = zc_Object_Goods()
                                             AND Object.isErased = FALSE
                       WHERE ObjectString_Article.ValueData ILIKE inArticle
                         AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                       LIMIT 1
                      ); 
     END IF;

     -- пробуем найти по наименованию
     IF COALESCE (vbGoodsId,0) = 0
     THEN
         vbGoodsId := (SELECT Object.Id
                       FROM Object
                       WHERE Object.DescId   = zc_Object_Goods()
                         AND Object.isErased = FALSE
                         AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGoodsName))
                       LIMIT 1
                      ); 
     END IF;
     
          -- Всегда создаем товар
          IF COALESCE (vbGoodsId,0) = 0 --OR 1=1
          THEN
             -- создаем
             vbGoodsId := gpInsertUpdate_Object_Goods (ioId               := vbGoodsId
                                                     , inCode             := lfGet_ObjectCode ((SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbGoodsId), zc_Object_Goods())
                                                     , inName             := TRIM (inGoodsName)
                                                     , inArticle          := TRIM (inArticle)
                                                     , inArticleVergl     := Null     :: TVarChar
                                                     , inEAN              := Null     :: TVarChar
                                                     , inASIN             := Null     :: TVarChar
                                                     , inMatchCode        := Null     :: TVarChar
                                                     , inFeeNumber        := Null     :: TVarChar
                                                     , inComment          := Null     :: TVarChar
                                                     , inIsArc            := FALSE    :: Boolean
                                                     , inFeet             := 0             :: TFloat
                                                     , inMetres           := 0             ::TFloat
                                                     , inAmountMin        := 0             :: TFloat
                                                     , inAmountRefer      := 0             :: TFloat
                                                     , inEKPrice          := inAmount      :: TFloat
                                                     , inEmpfPrice        := 0             :: TFloat
                                                     , inGoodsGroupId     := 40422         :: Integer  --NEW
                                                     , inMeasureId        := 0             :: Integer
                                                     , inGoodsTagId       := 0             :: Integer
                                                     , inGoodsTypeId      := 0             :: Integer
                                                     , inGoodsSizeId      := 0             :: Integer
                                                     , inProdColorId      := 0             :: Integer
                                                     , inPartnerId        := vbPartnerId   :: Integer
                                                     , inUnitId           := 0             :: Integer
                                                     , inDiscountPartnerId := 0            :: Integer
                                                     , inTaxKindId        := 0             :: Integer
                                                     , inEngineId         := NULL
                                                     , inSession          := inSession     :: TVarChar
                                                      ); 
          ELSE
              --если у товара пустое значение поставщик - устанавливаем текущего
              IF COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL 
                            WHERE OL.DescId = zc_ObjectLink_Goods_Partner()
                            AND Ol.ObjectId = vbGoodsId),0) = 0
              THEN
                  -- перезаписали поставщика
                  PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Partner(), vbGoodsId, vbPartnerId);
              END IF;
          END IF; 
          --
    

          -- поиск элемента с таким товаром, вдруг уже загрузили, тогда обновляем
          vbMovementItemId := (SELECT MovementItem.Id
                               FROM MovementItem
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.ObjectId   = vbGoodsId
                              );

          -- сохранили <Элемент документа>
          PERFORM lpInsertUpdate_MovementItem_Inventory (ioId              := COALESCE (vbMovementItemId,0)
                                                       , inMovementId      := inMovementId
                                                       , inMovementId_OrderClient := Null::Integer
                                                       , inGoodsId         := vbGoodsId  
                                                       , InPartnerId       := vbPartnerId
                                                       , ioAmount          := inRemains ::TFloat
                                                       , inTotalCount      := 0         ::TFloat
                                                       , inTotalCount_old  := 0         ::TFloat
                                                       , ioPrice           := 0         ::TFloat
                                                       , inPartNumber      := ''        ::TVarChar
                                                       , inComment         := ''        ::TVarChar
                                                       , inUserId          := vbUserId
                                                        );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.22         *
*/

-- тест
--
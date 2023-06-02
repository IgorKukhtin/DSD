--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListRapidMarine_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListRapidMarine_Load(
    IN inOperDate                   TDateTime,     -- дата документа
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- 
    IN inMeasureName                TVarChar,      -- 
    IN inFarbe                      TVarChar,      -- 
    IN inGroup                      TVarChar,      -- 
    IN inPartnerName                TVarChar,      -- 
    IN inMatchCode                  TVarChar  ,      -- 
    IN inEmpfPrice                  TFloat  ,
    IN inEKPrice                    TFloat  ,
    IN inSession                    TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbMeasureId        Integer;
  DECLARE vbProdColorId  Integer;
  DECLARE vbGoodsGroupId     Integer;
  DECLARE vbPartnerId        Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- RAISE EXCEPTION 'Ошибка. inArticle = <%>  Не найден.', inArticle;

    -- Eсли нет цены - выход
    IF COALESCE (inEKPrice, 0) = 0
    THEN
        RETURN;
    END IF;

    -- Проверка - Eсли не нашли
    IF COALESCE (inPartnerId,0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Поставщик';
    END IF;


   IF COALESCE (inMeasureName,'')<> ''
   THEN
       vbMeasureId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Measure() AND Object.ValueData Like TRIM (inMeasureName));    
       --если не находим создаем
       IF COALESCE (vbMeasureId,0) = 0
       THEN
   
        vbMeasureId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_Measure (ioId           := 0         :: Integer
                                                          , ioCode         := 0         :: Integer
                                                          , inName         := TRIM (inMeasureName) :: TVarChar
                                                          , inInternalCode := ''        :: TVarChar
                                                          , inInternalName := ''        :: TVarChar
                                                          , inSession      := inSession :: TVarChar
                                                           ) AS tmp);
       END IF;
   END IF;

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

          -- Eсли не нашли создаем товар
          IF COALESCE (vbGoodsId,0) = 0
          THEN

             vbGoodsGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGroup)));
             --если нет такой группы создаем
              IF COALESCE (vbGoodsGroupId,0) = 0
              THEN
                   vbGoodsGroupId := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                           , ioCode            := 0         :: Integer
                                                                           , inName            := CAST (TRIM (inGoods) AS TVarChar) ::TVarChar
                                                                           , inParentId        := 0         :: Integer
                                                                           , inInfoMoneyId     := 0         :: Integer
                                                                           , inModelEtiketenId := 0         :: Integer
                                                                           , inSession         := inSession :: TVarChar
                                                                            ) AS tmp);
              END IF;
        
          IF COALESCE (inPartnerName, '') <> ''
          THEN
              -- пробуем найти 
              vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Partner() AND UPPER ( TRIM (Object.ValueData)) = UPPER ( TRIM (inPartnerName)) );
              --если не нашли ощибка
              IF COALESCE (vbPartnerId,0) = 0
              THEN
                 -- создаем
                 PERFORM gpInsertUpdate_Object_Partner(ioId       := 0               :: Integer
                                                     , ioCode     := 0          :: Integer
                                                     , inName     := TRIM (inPartnerName) :: TVarChar
                                                     , inComment  := ''              :: TVarChar
                                                     , inFax      := ''    :: TVarChar
                                                     , inPhone    := '' :: TVarChar
                                                     , inMobile   := '' :: TVarChar
                                                     , inIBAN     :=  '':: TVarChar
                                                     , inStreet   := '' :: TVarChar
                                                     , inMember   := '' :: TVarChar
                                                     , inWWW      :=  '':: TVarChar
                                                     , inEmail    := '' :: TVarChar
                                                     , inCodeDB   := '' :: TVarChar
                                                     , inTaxNumber    := ''
                                                     , inDiscountTax  := 0
                                                     , inDayCalendar  := 0
                                                     , inDayBank      := 0
                                                     , inBankId   := 0 :: Integer  
                                                     , inPLZId    := 0 :: Integer 
                                                     , inInfoMoneyId:= zc_Enum_InfoMoney_10101()
                                                     , inTaxKindId  := zc_Enum_TaxKind_Basis() -- 19.0%
                                                     , inPaidKindId := zc_Enum_PaidKind_FirstForm() ::Integer
                                                     , inSession  := inSession       :: TVarChar
                                                      );

              END IF;
 
              IF COALESCE (inFarbe, '') <> ''
              THEN
                  -- пробуем найти 
                  vbProdColorId := (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inFarbe)));
                  --если не находим создаем
                  IF COALESCE (vbProdColorId,0) = 0
                  THEN
                       vbProdColorId := (SELECT tmp.ioId
                                         FROM gpInsertUpdate_Object_ProdColor_Load (ioId        := 0         :: Integer
                                                                                  , ioCode      := 0         :: Integer
                                                                                  , inName      := TRIM (inFarbe) ::TVarChar
                                                                                  , inComment   := ''        :: TVarChar
                                                                                  , inSession   := inSession :: TVarChar
                                                                                   ) AS tmp);
                  END IF;
              END IF;

              
             -- создаем
             vbGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId,0)::  Integer
                                                    , inCode             := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                    , inName             := TRIM (inGoodsName)       :: TVarChar
                                                    , inArticle          := TRIM (inArticle)      :: TVarChar
                                                    , inArticleVergl     := Null     :: TVarChar
                                                    , inEAN              := Null     :: TVarChar
                                                    , inASIN             := Null     :: TVarChar
                                                    , inMatchCode        := inMatchCode     :: TVarChar 
                                                    , inFeeNumber        := Null     :: TVarChar
                                                    , inComment          := Null     :: TVarChar
                                                    , inIsArc            := FALSE    :: Boolean
                                                    , inFeet             := 0             :: TFloat
                                                    , inMetres           := 0             :: TFloat
                                                    , inAmountMin        := 0             :: TFloat
                                                    , inAmountRefer      := 0             :: TFloat
                                                    , inEKPrice          := CAST (inEKPrice AS NUMERIC (16,2)) :: TFloat
                                                    , inEmpfPrice        := inEmpfPrice             :: TFloat
                                                    , inGoodsGroupId     := vbGoodsGroupId         :: Integer  --NEW
                                                    , inMeasureId        := vbMeasureId   :: Integer
                                                    , inGoodsTagId       := 0 -- vbGoodsTagId     :: Integer
                                                    , inGoodsTypeId      := 0        :: Integer
                                                    , inGoodsSizeId      := 0        :: Integer
                                                    , inProdColorId      := vbProdColorId       :: Integer
                                                    , inPartnerId        := vbPartnerId      :: Integer
                                                    , inUnitId           := 0                :: Integer
                                                    , inDiscountPartnerId := 0    :: Integer
                                                    , inTaxKindId        := 0                :: Integer
                                                    , inEngineId         := NULL
                                                    , inSession          := inSession        :: TVarChar
                                                    );
               
          END IF;


          -- пробуем найти документ
          vbMovementId := (SELECT Movement.Id
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                              ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                             AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_Partner()
                                                             AND MovementLinkObject_Partner.ObjectId   = inPartnerId
                           WHERE Movement.OperDate = inOperDate
                             AND Movement.DescId   = zc_Movement_PriceList()
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                          );
          -- Eсли не нашли создаем
          IF COALESCE (vbMovementId,0) = 0
          THEN
               --
               vbMovementId := lpInsertUpdate_Movement_PriceList(ioId         := 0
                                                               , inInvNumber  := CAST (NEXTVAL ('movement_PriceList_seq') AS TVarChar)
                                                               , inOperDate   := inOperDate
                                                               , inPartnerId  := inPartnerId
                                                               , inComment    := 'auto'
                                                               , inUserId     := vbUserId
                                                               );
          END IF;

          -- поиск элемента с таким товаром, вдруг уже загрузили, тогда обновляем
          vbMovementItemId := (SELECT MovementItem.Id
                               FROM MovementItem
                                 INNER JOIN MovementItemLinkObject AS MILO_Measure
                                                                   ON MILO_Measure.MovementItemId = MovementItem.Id
                                                                  AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                                                                  AND MILO_Measure.ObjectId = vbMeasureId
                               WHERE MovementItem.MovementId = vbMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.ObjectId   = vbGoodsId
                              );


          -- сохранили <Элемент документа>
          vbMovementItemId:=  lpInsertUpdate_MovementItem_PriceList (ioId                := COALESCE (vbMovementItemId,0) ::Integer
                                                                   , inMovementId        := vbMovementId                  ::Integer
                                                                   , inGoodsId           := vbGoodsId                     ::Integer
                                                                   , inDiscountPartnerId := 0            ::Integer
                                                                   , inMeasureId         := vbMeasureId                   ::Integer
                                                                   , inMeasureParentId   := 0
                                                                   , inAmount            := CAST (inEKPrice AS NUMERIC (16,2)) ::TFloat
                                                                   , inMeasureMult       := 0 ::TFloat
                                                                   , inPriceParent       := 0 ::TFloat
                                                                   , inEmpfPriceParent   := inEmpfPrice ::TFloat
                                                                   , inMinCount          := 0             ::TFloat
                                                                   , inMinCountMult      := 0             ::TFloat
                                                                   , inWeightParent      := 0             ::TFloat
                                                                   , inCatalogPage       := ''            ::TVarChar
                                                                   , inisOutlet          := FALSE         ::Boolean
                                                                   , inUserId            := vbUserId      :: Integer
                                                                    );
     END IF;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 И02.06.23         *
*/

-- тест
--
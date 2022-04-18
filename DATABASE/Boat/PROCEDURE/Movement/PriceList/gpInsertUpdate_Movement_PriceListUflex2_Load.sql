
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListUflex2_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListUflex2_Load(
    IN inOperDate                   TDateTime,     -- дата документа
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- 
    IN inModelName                  TVarChar,      -- 
    IN inAmount                     TFloat  ,
    IN inSession                    TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
        
    -- Eсли не нашли пропускаем
    IF COALESCE (inPartnerId,0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Поставщик';
    END IF;
            
   
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

          -- Eсли не нашли создаем товар
          IF COALESCE (vbGoodsId,0) = 0
          THEN

             -- создаем
             vbGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId,0)::  Integer
                                                    , inCode             := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                    , inName             := CASE WHEN COALESCE (TRIM (inModelName),'') <> '' THEN (TRIM (inGoodsName)  ||' / '||TRIM (inModelName) ) 
                                                                                 ELSE TRIM (inGoodsName)
                                                                            END :: TVarChar
                                                    , inArticle          := TRIM (inArticle)
                                                    , inArticleVergl     := Null     :: TVarChar
                                                    , inEAN              := Null     :: TVarChar
                                                    , inASIN             := Null     :: TVarChar
                                                    , inMatchCode        := Null     :: TVarChar 
                                                    , inFeeNumber        := Null     :: TVarChar
                                                    , inComment          := Null     :: TVarChar
                                                    , inIsArc            := FALSE    :: Boolean
                                                    , inAmountMin        := 0             :: TFloat
                                                    , inAmountRefer      := 0             :: TFloat
                                                    , inEKPrice          := inAmount      :: TFloat
                                                    , inEmpfPrice        := 0             :: TFloat
                                                    , inGoodsGroupId     := 40422         :: Integer  --NEW
                                                    , inMeasureId        := 0             :: Integer
                                                    , inGoodsTagId       := 0        :: Integer
                                                    , inGoodsTypeId      := 0        :: Integer
                                                    , inGoodsSizeId      := 0        :: Integer
                                                    , inProdColorId      := 0        :: Integer
                                                    , inPartnerId        := inPartnerId      :: Integer
                                                    , inUnitId           := 0                :: Integer
                                                    , inDiscountPartnerId := 0               :: Integer
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
                                                                   , inMeasureId         := 0            ::Integer
                                                                   , inMeasureParentId   := 0            ::Integer
                                                                   , inAmount            := inAmount     ::TFloat
                                                                   , inMeasureMult       := 0            ::TFloat
                                                                   , inPriceParent       := 0            ::TFloat
                                                                   , inEmpfPriceParent   := 0            ::TFloat
                                                                   , inMinCount          := 0            ::TFloat
                                                                   , inMinCountMult      := 0            ::TFloat
                                                                   , inWeightParent      := 0            ::TFloat
                                                                   , inCatalogPage       := ''           ::TVarChar
                                                                   , inisOutlet          := FALSE        ::Boolean
                                                                   , inUserId            := vbUserId     :: Integer
                                                                    );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.04.22         *
*/

-- тест
--
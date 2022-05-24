--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListSkiDoo_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListSkiDoo_Load(
    IN inOperDate                   TDateTime,     -- дата документа
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- 
    IN inMeasureName                TVarChar,      -- 
    IN inMeasureParentName          TVarChar,      -- 
    IN inDiscountPartnerName         TVarChar,      -- 
    IN inMeasureMult                TFloat  ,      -- 
    IN inEmpfPriceParent            TFloat  ,
    IN inPriceParent                TFloat  ,
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
  DECLARE vbMeasureId        Integer;
  DECLARE vbMeasureParentId  Integer;
  DECLARE vbDiscountPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- RAISE EXCEPTION 'Ошибка. inArticle = <%>  Не найден.', inArticle;

    -- Eсли нет цены - выход
    IF COALESCE (inAmount, 0) = 0
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

   IF COALESCE (inMeasureParentName,'')<> ''
   THEN
       vbMeasureParentId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Measure() AND Object.ValueData Like TRIM (inMeasureParentName));    
       --если не находим создаем
       IF COALESCE (vbMeasureParentId,0) = 0
       THEN
   
        vbMeasureParentId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_Measure (ioId           := 0         :: Integer
                                                                , ioCode         := 0         :: Integer
                                                                , inName         := TRIM (inMeasureParentName) :: TVarChar
                                                                , inInternalCode := ''        :: TVarChar
                                                                , inInternalName := ''        :: TVarChar
                                                                , inSession      := inSession :: TVarChar
                                                                 ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inDiscountPartnerName,'')<> ''
   THEN
       vbDiscountPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_DiscountPartner() AND Object.ValueData Like TRIM (inDiscountPartnerName));    
       --если не находим создаем
       IF COALESCE (vbDiscountPartnerId,0) = 0
       THEN

       vbDiscountPartnerId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_DiscountPartner (ioId           := 0         :: Integer
                                                                       , ioCode         := 0         :: Integer
                                                                       , inName         := TRIM (inDiscountPartnerName) :: TVarChar
                                                                       , inComment      := ''        :: TVarChar
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

             -- создаем
             vbGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId,0)::  Integer
                                                    , inCode             := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                    , inName             := TRIM (inGoodsName)       :: TVarChar
                                                    , inArticle          := TRIM (inArticle)      :: TVarChar
                                                    , inArticleVergl     := Null     :: TVarChar
                                                    , inEAN              := Null     :: TVarChar
                                                    , inASIN             := Null     :: TVarChar
                                                    , inMatchCode        := Null     :: TVarChar 
                                                    , inFeeNumber        := Null     :: TVarChar
                                                    , inComment          := Null     :: TVarChar
                                                    , inIsArc            := FALSE    :: Boolean
                                                    , inAmountMin        := 0             :: TFloat
                                                    , inAmountRefer      := 0             :: TFloat
                                                    , inEKPrice          := CAST (CASE WHEN COALESCE (inMeasureMult,0) <> 0 THEN inAmount / inMeasureMult ELSE inAmount END AS NUMERIC (16,2)) :: TFloat
                                                    , inEmpfPrice        := 0             :: TFloat
                                                    , inGoodsGroupId     := 40422         :: Integer  --NEW
                                                    , inMeasureId        := vbMeasureId   :: Integer
                                                    , inGoodsTagId       := 0 -- vbGoodsTagId     :: Integer
                                                    , inGoodsTypeId      := 0        :: Integer
                                                    , inGoodsSizeId      := 0        :: Integer
                                                    , inProdColorId      := 0        :: Integer
                                                    , inPartnerId        := inPartnerId      :: Integer
                                                    , inUnitId           := 0                :: Integer
                                                    , inDiscountPartnerId := vbDiscountPartnerId    :: Integer
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
                                 INNER JOIN MovementItemLinkObject AS MILO_DiscountPartner
                                                                  ON MILO_DiscountPartner.MovementItemId = MovementItem.Id
                                                                 AND MILO_DiscountPartner.DescId = zc_MILinkObject_DiscountPartner()
                                                                 AND MILO_DiscountPartner.ObjectId = vbDiscountPartnerId
                                 INNER JOIN MovementItemLinkObject AS MILO_Measure
                                                                  ON MILO_Measure.MovementItemId = MovementItem.Id
                                                                 AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                                                                 AND MILO_Measure.ObjectId = vbMeasureId
                                 INNER JOIN MovementItemLinkObject AS MILO_MeasureParent
                                                                  ON MILO_MeasureParent.MovementItemId = MovementItem.Id
                                                                 AND MILO_MeasureParent.DescId = zc_MILinkObject_MeasureParent()
                                                                 AND MILO_MeasureParent.ObjectId = vbMeasureParentId
                               WHERE MovementItem.MovementId = vbMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.ObjectId   = vbGoodsId
                              );


          -- сохранили <Элемент документа>
          vbMovementItemId:=  lpInsertUpdate_MovementItem_PriceList (ioId                := COALESCE (vbMovementItemId,0) ::Integer
                                                                   , inMovementId        := vbMovementId                  ::Integer
                                                                   , inGoodsId           := vbGoodsId                     ::Integer
                                                                   , inDiscountPartnerId := vbDiscountPartnerId            ::Integer
                                                                   , inMeasureId         := vbMeasureId                   ::Integer
                                                                   , inMeasureParentId   := vbMeasureParentId
                                                                   , inAmount            := CAST (CASE WHEN COALESCE (inMeasureMult,0) <> 0 THEN inAmount / inMeasureMult ELSE inAmount END AS NUMERIC (16,2)) ::TFloat
                                                                   , inMeasureMult       := inMeasureMult ::TFloat
                                                                   , inPriceParent       := inPriceParent ::TFloat
                                                                   , inEmpfPriceParent   := inEmpfPriceParent ::TFloat
                                                                   , inMinCount          := 0             ::TFloat
                                                                   , inMinCountMult      := 0             ::TFloat
                                                                   , inWeightParent      := 0             ::TFloat
                                                                   , inCatalogPage       := ''            ::TVarChar
                                                                   , inisOutlet          := FALSE         ::Boolean
                                                                   , inUserId            := vbUserId      :: Integer
                                                                    );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.02.22         *
*/

-- тест
--
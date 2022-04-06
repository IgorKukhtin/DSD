
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListUflex1_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListUflex1_Load(
    IN inOperDate                   TDateTime,     -- дата документа
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- 
    IN inGoodsName_fra              TVarChar,     --inDescription
    IN inBrandName                  TVarChar,      --   
    IN inModelName                  TVarChar,      -- 
    IN inCategory1                  TVarChar,
    IN inCategory2                  TVarChar,
    IN inAccess                     TVarChar,
    IN inCatalogueSection           TVarChar,      -- группа
    IN inCatalogPage                TVarChar,      -- pag1
    IN inAmount                     TFloat  ,
    IN inAmount2                    TFloat  ,
    IN inSession                    TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbGoodsGroupId     Integer;
  DECLARE vbObjectId_fra        Integer;
  
  DECLARE vbMeasureParentId        Integer;
  DECLARE vbObjectIdMeasure_ita    Integer;
  DECLARE vbObjectId_eng        Integer;
  DECLARE vbObjectId_ita        Integer;
  DECLARE vbdiscountpartnerid Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    -- Eсли не нашли пропускаем
    IF COALESCE (inPartnerId,0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Поставщик';
    END IF;

  /*IF inArticle = '66.045.02'
    THEN
         RAISE EXCEPTION 'Ошибка. %   %   %', inAmount, inPriceParent, inMeasureMult;
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

          -- Eсли не нашли создаем товар
          IF COALESCE (vbGoodsId,0) = 0
          THEN

             --группа товара пробуем найти
             vbGoodsGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inCatalogueSection));
             --если нет такой группы создаем
             IF COALESCE (vbGoodsGroupId,0) = 0
             THEN
                  vbGoodsGroupId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                          , ioCode            := 0         :: Integer
                                                                          , inName            := CAST (inCatalogueSection AS TVarChar) ::TVarChar
                                                                          , inParentId        := 0         :: Integer
                                                                          , inInfoMoneyId     := 0         :: Integer
                                                                          , inModelEtiketenId := 0         :: Integer
                                                                          , inSession         := inSession :: TVarChar
                                                                           ) AS tmp);
             END IF;

             -- создаем
             vbGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId,0)::  Integer
                                                    , inCode             := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                    , inName             := (CASE WHEN TRIM (inGoodsName) <> ''     THEN TRIM (inGoodsName)
                                                                                  WHEN TRIM (inGoodsName_fra) <> '' THEN TRIM (inGoodsName_fra)
                                                                             END ||' /'||TRIM (inModelName) ) :: TVarChar
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
                                                    , inGoodsGroupId     := vbGoodsGroupId  :: Integer  
                                                    , inMeasureId        := 0             :: Integer
                                                    , inGoodsTagId       := 0 -- vbGoodsTagId     :: Integer
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


          ---сохраняем перевод
              --франция          
          IF COALESCE (inGoodsName_fra,'') <> ''
          THEN
              --пробуем найти
              vbObjectId_fra := (SELECT Object_TranslateObject.Id
                                FROM Object AS Object_TranslateObject
                                     INNER JOIN ObjectLink AS ObjectLink_Language
                                                           ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                          AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                          AND ObjectLink_Language.ChildObjectId = 40529  --fra
                                     INNER JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                         AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                                         AND ObjectLink_Object.ChildObjectId = vbGoodsId
                                     INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                      AND Object.DescId = zc_Object_Goods()
                                WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                  AND Object_TranslateObject.isErased = FALSE
                                );
              
              IF COALESCE(vbObjectId_fra,0)=0
              THEN 
                   vbObjectId_fra := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_TranslateObject(ioId          := COALESCE (vbObjectId_fra,0)   ::Integer,       -- ключ объекта <>
                                                                                 ioCode        := lfGet_ObjectCode(0, zc_Object_TranslateObject())   ::Integer,       -- свойство <Код 
                                                                                 inName        := inGoodsName_fra   ::TVarChar,      -- Название 
                                                                                 inLanguageId  := 40529       ::Integer,
                                                                                 inObjectId    := vbGoodsId   ::Integer,
                                                                                 inSession     := inSession   ::TVarChar
                                                                                 )AS tmp);
              END IF;
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
                                                                   , inCatalogPage       := TRIM (inCatalogPage) ::TVarChar
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
 04.04.22         *
*/

-- тест
--
/*
select * from gpInsertUpdate_Movement_PriceListUflex1_Load
(inOperDate := ('02.03.2022')::TDateTime , 
inPartnerId := 2842 , 
inArticle := '64415T' , 
inGoodsName := 'Total length 365 mm, stroke 142 mm, output force 10 kg' , 
inGoodsName_fra := 'Lunghezza totale 365 mm, corsa 142 mm, spinta 10 kg' , 
inBrandName := 'UFLEX®' , 
inModelName := 'U140-10-b' , 
inCategory1 := 'U SERIES' , 
inCategory2 := '.' , 
inAccess := '.' , 
inCatalogueSection := 'Gas springs' , 
inCatalogPage := '13' , 
inAmount := 21.1 , 
inAmount2 := 21.1 ,  
inSession := '5');
*/
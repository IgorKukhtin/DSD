
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListOsculati_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListOsculati_Load(
    IN inOperDate                   TDateTime,     -- дата документа
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- 
    IN inMeasureName                TVarChar,      -- 
    IN inFeeNumber                  TVarChar,      -- 
    IN inMeasureMult                TFloat  ,      -- 
    IN inEmpfPriceParent            TFloat  ,
    IN inPriceParent                TFloat  ,
    IN inAmount                     TFloat  ,
    IN inMinCount                   TFloat  ,      -- 
    IN inMinCountMult               TFloat  ,
    IN inWeightParent               TFloat  ,      -- 
    IN inisOutlet                   TVarChar,
    IN inGoodsName_ita              TVarChar,
    IN inGoodsName_eng              TVarChar,
    IN inGoodsName_fra              TVarChar,
    IN inMeasure_ita                TVarChar,
    IN inMeasureParentName          TVarChar,
    IN inDiscountPartnerName        TVarChar,
    IN inEAN                        TVarChar,
    IN inCatalogPage                TVarChar,
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
  DECLARE vbMeasureParentId        Integer;
  DECLARE vbObjectIdMeasure_ita        Integer;
  DECLARE vbObjectId_eng        Integer;
  DECLARE vbObjectId_fra        Integer;
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
                                                    , inName             := TRIM (inGoodsName)       :: TVarChar
                                                    , inArticle          := TRIM (inArticle)      :: TVarChar
                                                    , inArticleVergl     := Null     :: TVarChar
                                                    , inEAN              := inEAN    :: TVarChar
                                                    , inASIN             := Null     :: TVarChar
                                                    , inMatchCode        := Null     :: TVarChar 
                                                    , inFeeNumber        := inFeeNumber :: TVarChar
                                                    , inComment          := Null     :: TVarChar
                                                    , inIsArc            := FALSE    :: Boolean
                                                    , inAmountMin        := 0             :: TFloat
                                                    , inAmountRefer      := 0             :: TFloat
                                                    , inEKPrice          := inAmount      :: TFloat
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


          ---сохраняем перевод
              --Италия          
          IF COALESCE (inGoodsName_ita,'') <> ''
          THEN
              -- проверка
              IF 1 < (SELECT COUNT(*)
                      FROM Object AS Object_TranslateObject
                           INNER JOIN ObjectLink AS ObjectLink_Language
                                                 ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                AND ObjectLink_Language.ChildObjectId = 40528 --италия
                           INNER JOIN ObjectLink AS ObjectLink_Object
                                                ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                               AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                               AND ObjectLink_Object.ChildObjectId = vbGoodsId
                           INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                            AND Object.DescId = zc_Object_Goods()
                      WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                        AND Object_TranslateObject.isErased = FALSE
                     )
              THEN
                  RAISE EXCEPTION 'Ошибка.Перевод <%>  <%>', vbGoodsId, lfGet_Object_ValueData_sh (40528);
              END IF;

              -- пробуем найти
              vbObjectId_ita := (SELECT Object_TranslateObject.Id
                                FROM Object AS Object_TranslateObject
                                     INNER JOIN ObjectLink AS ObjectLink_Language
                                                           ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                          AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                          AND ObjectLink_Language.ChildObjectId = 40528 --италия
                                     INNER JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                         AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                                         AND ObjectLink_Object.ChildObjectId = vbGoodsId
                                     INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                      AND Object.DescId = zc_Object_Goods()
                                WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                  AND Object_TranslateObject.isErased = FALSE
                                );
              
              IF COALESCE(vbObjectId_ita,0)=0
              THEN 
                   vbObjectId_ita := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_TranslateObject(ioId          := COALESCE (vbObjectId_ita,0)   ::Integer,       -- ключ объекта <>
                                                                            ioCode        := lfGet_ObjectCode(0, zc_Object_TranslateObject())   ::Integer,       -- свойство <Код 
                                                                            inName        := inGoodsName_ita   ::TVarChar,      -- Название 
                                                                            inLanguageId  := 40528       ::Integer,
                                                                            inObjectId    := vbGoodsId   ::Integer,
                                                                            inSession     := inSession   ::TVarChar
                                                                            )AS tmp);
              END IF;
          END IF;

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

              --Англия          
          IF COALESCE (inGoodsName_eng,'') <> ''
          THEN
              --пробуем найти
              vbObjectId_eng := (SELECT Object_TranslateObject.Id
                                FROM Object AS Object_TranslateObject
                                     INNER JOIN ObjectLink AS ObjectLink_Language
                                                           ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                          AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                          AND ObjectLink_Language.ChildObjectId = 179 -- английский
                                     INNER JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                         AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                                         AND ObjectLink_Object.ChildObjectId = vbGoodsId
                                     INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                      AND Object.DescId = zc_Object_Goods()
                                WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                  AND Object_TranslateObject.isErased = FALSE
                                );
              
              IF COALESCE(vbObjectId_eng,0)=0
              THEN 
                   vbObjectId_eng := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_TranslateObject(ioId          := COALESCE (vbObjectId_eng,0)   ::Integer,       -- ключ объекта <>
                                                                            ioCode        := lfGet_ObjectCode(0, zc_Object_TranslateObject())   ::Integer,       -- свойство <Код 
                                                                            inName        := inGoodsName_eng   ::TVarChar,      -- Название 
                                                                            inLanguageId  := 179       ::Integer,
                                                                            inObjectId    := vbGoodsId   ::Integer,
                                                                            inSession     := inSession   ::TVarChar
                                                                            )AS tmp);
              END IF;
          END IF;

              --Италия          
          IF COALESCE (inMeasure_ita,'') <> ''
          THEN
              --пробуем найти
              vbObjectIdMeasure_ita := (SELECT Object_TranslateObject.Id
                                        FROM Object AS Object_TranslateObject
                                             INNER JOIN ObjectLink AS ObjectLink_Language
                                                                   ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                                  AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                                  AND ObjectLink_Language.ChildObjectId = 40528 --италия
                                             INNER JOIN ObjectLink AS ObjectLink_Object
                                                                  ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                                 AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                                                 AND ObjectLink_Object.ChildObjectId = vbMeasureParentId
                                             INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                              AND Object.DescId = zc_Object_Measure()
                                        WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                          AND Object_TranslateObject.isErased = FALSE
                                        );
              
              IF COALESCE(vbObjectIdMeasure_ita,0)=0
              THEN 
                   vbObjectIdMeasure_ita := (SELECT tmp.ioId
                                             FROM gpInsertUpdate_Object_TranslateObject(ioId          := COALESCE (vbObjectIdMeasure_ita,0)   ::Integer,       -- ключ объекта <>
                                                                                         ioCode        := lfGet_ObjectCode(0, zc_Object_TranslateObject())   ::Integer,       -- свойство <Код 
                                                                                         inName        := inMeasure_ita   ::TVarChar,      -- Название 
                                                                                         inLanguageId  := 40528       ::Integer,
                                                                                         inObjectId    := vbMeasureParentId   ::Integer,
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
                                                                   , inAmount            := inAmount      ::TFloat
                                                                   , inMeasureMult       := inMeasureMult ::TFloat
                                                                   , inPriceParent       := inPriceParent ::TFloat
                                                                   , inEmpfPriceParent   := inEmpfPriceParent ::TFloat
                                                                   , inMinCount          := inMinCount     ::TFloat
                                                                   , inMinCountMult      := inMinCountMult ::TFloat
                                                                   , inWeightParent      := inWeightParent ::TFloat
                                                                   , inCatalogPage       := TRIM (inCatalogPage) ::TVarChar
                                                                   , inisOutlet          := CASE WHEN COALESCE (inisOutlet,'') = 'YES' THEN TRUE ELSE FALSE END  ::Boolean
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
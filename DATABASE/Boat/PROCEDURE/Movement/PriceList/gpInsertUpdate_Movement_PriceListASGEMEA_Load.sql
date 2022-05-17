
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListASGEMEA_Load (TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListASGEMEA_Load(
    IN inOperDate                   TDateTime,     -- дата документа
    IN inMovementId                 Integer,
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      --
    IN inGroupName1                 TVarChar,      --
    IN inGroupName2                 TVarChar,      --
    IN inGroupName3                 TVarChar,      --
    IN inGroupName4                 TVarChar,      -- 
    IN inDiscountPartnerName        TVarChar,      -- 
    IN inMinCount                   TFloat  ,      -- 
    IN inMinCountMult               TFloat  ,
    IN inAmount                     TFloat  ,
    IN inSession                    TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbGroupId_1        Integer;
  DECLARE vbGroupId_2        Integer;
  DECLARE vbGroupId_3        Integer;
  DECLARE vbGroupId_4        Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbDiscountPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    -- Проверка - Eсли не нашли
    IF COALESCE (inPartnerId,0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Поставщик.';
    END IF;


   /*IF COALESCE (inMeasureName,'')<> ''
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
   */

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
             --проверяем группу для товара 
           /*IF COALESCE (inGroupName1,'') <> ''
             THEN
                 -- пробуем найти группу Комплектующих
                 vbGroupId_1 := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName1));

                 --если нет такой группы создаем
                 IF COALESCE (vbGroupId_1,0) = 0
                 THEN
                      vbGroupId_1 := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                           , ioCode            := 0         :: Integer
                                                                           , inName            := TRIM (inGroupName1) ::TVarChar
                                                                           , inParentId        := 0         :: Integer
                                                                           , inInfoMoneyId     := 0         :: Integer
                                                                           , inModelEtiketenId := 0         :: Integer
                                                                           , inSession         := inSession :: TVarChar
                                                                            ) AS tmp);
                 END IF;

                 IF COALESCE (inGroupName2,'') <> ''
                 THEN
                      -- пробуем найти  след. группу Комплектующих
                      vbGroupId_2 := (SELECT Object.Id 
                                      FROM Object
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
                                                                AND ObjectLink_GoodsGroup_Parent.ChildObjectId = vbGroupId_1
                                      WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName2));

                      --если нет такой группы создаем
                      IF COALESCE (vbGroupId_2,0) = 0
                      THEN
                           vbGroupId_2 := (SELECT tmp.ioId
                                           FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                                , ioCode            := 0         :: Integer
                                                                                , inName            := TRIM (inGroupName2) ::TVarChar
                                                                                , inParentId        := vbGroupId_1        :: Integer
                                                                                , inInfoMoneyId     := 0         :: Integer
                                                                                , inModelEtiketenId := 0         :: Integer
                                                                                , inSession         := inSession :: TVarChar
                                                                                 ) AS tmp);
                      END IF;
                 END IF;


                 IF COALESCE (inGroupName3,'') <> ''
                 THEN
                      -- пробуем найти  след. группу Комплектующих
                      vbGroupId_3 := (SELECT Object.Id 
                                      FROM Object
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
                                                                AND ObjectLink_GoodsGroup_Parent.ChildObjectId = vbGroupId_2
                                      WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName3));

                      --если нет такой группы создаем
                      IF COALESCE (vbGroupId_3,0) = 0
                      THEN
                           vbGroupId_3 := (SELECT tmp.ioId
                                           FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                                , ioCode            := 0         :: Integer
                                                                                , inName            := TRIM (inGroupName3) ::TVarChar
                                                                                , inParentId        := vbGroupId_2        :: Integer
                                                                                , inInfoMoneyId     := 0         :: Integer
                                                                                , inModelEtiketenId := 0         :: Integer
                                                                                , inSession         := inSession :: TVarChar
                                                                                 ) AS tmp);
                      END IF;
                 END IF;

                 IF COALESCE (inGroupName4,'') <> ''
                 THEN
                      -- пробуем найти  след. группу Комплектующих
                      vbGroupId_4 := (SELECT Object.Id 
                                      FROM Object
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
                                                                AND ObjectLink_GoodsGroup_Parent.ChildObjectId = vbGroupId_3
                                      WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName4));

                      --если нет такой группы создаем
                      IF COALESCE (vbGroupId_4,0) = 0
                      THEN
                           vbGroupId_4 := (SELECT tmp.ioId
                                           FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                                , ioCode            := 0         :: Integer
                                                                                , inName            := TRIM (inGroupName4) ::TVarChar
                                                                                , inParentId        := vbGroupId_3        :: Integer
                                                                                , inInfoMoneyId     := 0         :: Integer
                                                                                , inModelEtiketenId := 0         :: Integer
                                                                                , inSession         := inSession :: TVarChar
                                                                                 ) AS tmp);
                      END IF;
                 END IF;
                 
                 
             END IF;*/
   

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
          
             -- создаем
             vbGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId,0)::  Integer
                                                    , inCode             := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                    , inName             := TRIM (inGoodsName)       :: TVarChar
                                                    , inArticle          := TRIM (inArticle)      :: TVarChar
                                                    , inArticleVergl     := Null     :: TVarChar
                                                    , inEAN              := NULL     :: TVarChar
                                                    , inASIN             := Null     :: TVarChar
                                                    , inMatchCode        := Null     :: TVarChar 
                                                    , inFeeNumber        := Null     :: TVarChar
                                                    , inComment          := Null     :: TVarChar
                                                    , inIsArc            := FALSE    :: Boolean
                                                    , inAmountMin        := 0        :: TFloat
                                                    , inAmountRefer      := 0        :: TFloat
                                                    , inEKPrice          := inAmount :: TFloat
                                                    , inEmpfPrice        := 0        :: TFloat
                                                    , inGoodsGroupId     := COALESCE (vbGroupId_4, vbGroupId_3, vbGroupId_2, vbGroupId_1, 40422)    :: Integer  --NEW
                                                    , inMeasureId        := 0        :: Integer
                                                    , inGoodsTagId       := 0        :: Integer
                                                    , inGoodsTypeId      := 0        :: Integer
                                                    , inGoodsSizeId      := 0        :: Integer
                                                    , inProdColorId      := 0        :: Integer
                                                    , inPartnerId        := inPartnerId :: Integer
                                                    , inUnitId           := 0           :: Integer
                                                    , inDiscountPartnerId := vbDiscountPartnerId :: Integer
                                                    , inTaxKindId        := 0           :: Integer
                                                    , inEngineId         := NULL
                                                    , inSession          := inSession   :: TVarChar
                                                    );
               
          END IF;

          IF COALESCE (inMovementId, 0) = 0
          THEN
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
          ELSE  vbMovementId := inMovementId;
          END IF;

          -- поиск элемента с таким товаром, вдруг уже загрузили, тогда обновляем
          vbMovementItemId := (SELECT MovementItem.Id
                               FROM MovementItem
                                 /*INNER JOIN MovementItemLinkObject AS MILO_Measure
                                                                  ON MILO_Measure.MovementItemId = MovementItem.Id
                                                                 AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                                                                 AND MILO_Measure.ObjectId = vbMeasureId*/
                               WHERE MovementItem.MovementId = vbMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.ObjectId   = vbGoodsId  
                               limit 1
                              );


          -- сохранили <Элемент документа>
          vbMovementItemId:=  lpInsertUpdate_MovementItem_PriceList (ioId                := COALESCE (vbMovementItemId,0) ::Integer
                                                                   , inMovementId        := vbMovementId                  ::Integer
                                                                   , inGoodsId           := vbGoodsId                     ::Integer
                                                                   , inDiscountPartnerId := 0                             ::Integer
                                                                   , inMeasureId         := 0                             ::Integer
                                                                   , inMeasureParentId   := 0                             ::Integer
                                                                   , inAmount            := inAmount       ::TFloat
                                                                   , inMeasureMult       := 0              ::TFloat
                                                                   , inPriceParent       := 0              ::TFloat
                                                                   , inEmpfPriceParent   := 0              ::TFloat
                                                                   , inMinCount          := inMinCount     ::TFloat
                                                                   , inMinCountMult      := inMinCountMult ::TFloat
                                                                   , inWeightParent      := 0              ::TFloat
                                                                   , inCatalogPage       := ''             ::TVarChar
                                                                   , inisOutlet          := FALSE          ::Boolean
                                                                   , inUserId            := vbUserId       :: Integer
                                                                    );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.05.22         *
*/

-- тест
--
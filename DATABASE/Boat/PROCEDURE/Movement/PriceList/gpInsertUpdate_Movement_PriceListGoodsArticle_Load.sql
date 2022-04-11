
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListGoodsArticle_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListGoodsArticle_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListGoodsArticle_Load(
    IN inOperDate                   TDateTime,     -- дата документа
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- 
    IN inGoodsArticle1              TVarChar,
    IN inGoodsArticle2              TVarChar,      --   
    IN inGoodsArticle3              TVarChar,      -- 
    IN inGoodsArticle4              TVarChar,
    IN inFeet                       TVarChar,
    IN inMetres                     TFloat  ,
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
                                                    , inName             := TRIM (inGoodsName)
                                                    , inArticle          := TRIM (inArticle)
                                                    , inArticleVergl     := Null     :: TVarChar
                                                    , inEAN              := Null     :: TVarChar
                                                    , inASIN             := Null     :: TVarChar
                                                    , inMatchCode        := Null     :: TVarChar 
                                                    , inFeeNumber        := Null     :: TVarChar
                                                    , inComment          := Null     :: TVarChar
                                                    , inIsArc            := FALSE    :: Boolean
                                                    , inFeet             := CAST (replace (inFeet,'`' , ' ') AS TFloat) 
                                                    , inMetres           := inMetres ::TFloat
                                                    , inAmountMin        := 0             :: TFloat
                                                    , inAmountRefer      := 0             :: TFloat
                                                    , inEKPrice          := inAmount      :: TFloat
                                                    , inEmpfPrice        := 0             :: TFloat
                                                    , inGoodsGroupId     := 40422         :: Integer  --NEW
                                                    , inMeasureId        := 0        :: Integer
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
          
          --заполняем справочник GoodsArticle
          IF COALESCE (TRIM (inGoodsArticle1),'') <> ''
            AND NOT EXISTS (SELECT 1
                            FROM Object
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsArticle_Goods
                                                       ON ObjectLink_GoodsArticle_Goods.ObjectId = Object.Id
                                                      AND ObjectLink_GoodsArticle_Goods.DescId = zc_ObjectLink_GoodsArticle_Goods()
                                                      AND ObjectLink_GoodsArticle_Goods.ChildObjectId = vbGoodsId
                            WHERE Object.DescId = zc_Object_GoodsArticle()
                              AND Object.isErased = FALSE
                              AND Object.ValueData = TRIM (inGoodsArticle1)
                            )
          THEN
              PERFORM gpInsertUpdate_Object_GoodsArticle (0,TRIM (inGoodsArticle1), vbGoodsId, inSession);
          END IF;

          IF COALESCE (TRIM (inGoodsArticle2),'') <> '`'
            AND NOT EXISTS (SELECT 1
                            FROM Object
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsArticle_Goods
                                                       ON ObjectLink_GoodsArticle_Goods.ObjectId = Object.Id
                                                      AND ObjectLink_GoodsArticle_Goods.DescId = zc_ObjectLink_GoodsArticle_Goods()
                                                      AND ObjectLink_GoodsArticle_Goods.ChildObjectId = vbGoodsId
                            WHERE Object.DescId = zc_Object_GoodsArticle()
                              AND Object.isErased = FALSE
                              AND Object.ValueData = TRIM (inGoodsArticle2)
                            )
          THEN
              PERFORM gpInsertUpdate_Object_GoodsArticle (0,TRIM (inGoodsArticle2), vbGoodsId, inSession);
          END IF;

          IF COALESCE (TRIM (inGoodsArticle3),'') <> ''
            AND NOT EXISTS (SELECT 1
                            FROM Object
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsArticle_Goods
                                                       ON ObjectLink_GoodsArticle_Goods.ObjectId = Object.Id
                                                      AND ObjectLink_GoodsArticle_Goods.DescId = zc_ObjectLink_GoodsArticle_Goods()
                                                      AND ObjectLink_GoodsArticle_Goods.ChildObjectId = vbGoodsId
                            WHERE Object.DescId = zc_Object_GoodsArticle()
                              AND Object.isErased = FALSE
                              AND Object.ValueData = TRIM (inGoodsArticle3)
                            )
          THEN
              PERFORM gpInsertUpdate_Object_GoodsArticle (0,TRIM (inGoodsArticle3), vbGoodsId, inSession);
          END IF;

          IF COALESCE (TRIM (inGoodsArticle4),'') <> ''
            AND NOT EXISTS (SELECT 1
                            FROM Object
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsArticle_Goods
                                                       ON ObjectLink_GoodsArticle_Goods.ObjectId = Object.Id
                                                      AND ObjectLink_GoodsArticle_Goods.DescId = zc_ObjectLink_GoodsArticle_Goods()
                                                      AND ObjectLink_GoodsArticle_Goods.ChildObjectId = vbGoodsId
                            WHERE Object.DescId = zc_Object_GoodsArticle()
                              AND Object.isErased = FALSE
                              AND Object.ValueData = TRIM (inGoodsArticle4)
                            )
          THEN
              PERFORM gpInsertUpdate_Object_GoodsArticle (0,TRIM (inGoodsArticle4), vbGoodsId, inSession);
          END IF;
          ------------

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
10.04.22         *
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
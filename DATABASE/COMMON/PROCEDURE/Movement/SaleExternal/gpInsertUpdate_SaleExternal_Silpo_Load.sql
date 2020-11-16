-- Function: gpInsertUpdate_SaleExternal_Silpo_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_SaleExternal_Silpo_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_SaleExternal_Silpo_Load(
    IN inOperDate              TDateTime , --
    IN inRetailId              Integer   , --
    IN inPartnerExternalName   TVarChar  , -- 
    IN inArticle               TVarChar  , -- 
    IN inGoodsName             TVarChar  , -- 
    IN inAmount                TFloat    , -- количество
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbPartnerExternalId Integer;
   DECLARE vbGoodsPropertyId   Integer;
   DECLARE vbGoodsPropertyValueId Integer;
   DECLARE vbGoodsId           Integer;
   DECLARE vbGoodsKindId       Integer;
   DECLARE vbMovementId        Integer;
   DECLARE vbId                Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SaleExternal());

     -- итоговые строки пропускаем
     IF COALESCE (inPartnerExternalName,'') = ''
     THEN
         RETURN;
     END IF;
     
     -- проверка
     IF COALESCE (inRetailId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Торговая сеть не выбрана';
     END IF;

     --ищем PartnerExternal
     vbPartnerExternalId := (SELECT Object_PartnerExternal.Id 
                             FROM Object AS Object_PartnerExternal
                                  LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                       ON ObjectLink_Retail.ObjectId = Object_PartnerExternal.Id 
                                                      AND ObjectLink_Retail.DescId = zc_ObjectLink_PartnerExternal_Retail()
                             WHERE Object_PartnerExternal.DescId = zc_Object_PartnerExternal()
                               AND Object_PartnerExternal.ValueData = TRIM (inPartnerExternalName)
                               AND (ObjectLink_Retail.ChildObjectId = inRetailId OR COALESCE(ObjectLink_Retail.ChildObjectId,0) = 0)
                             );
     
     --если не найден
     IF COALESCE (vbPartnerExternalId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Контрагент внешний - <%> не найден.', inPartnerExternalName;
         /*vbPartnerExternalId :=  lpInsertUpdate_Object_PartnerExternal (ioId         := 0
                                                                      , inCode       := lfGet_ObjectCode(0, zc_Object_PartnerExternal())
                                                                      , inName       := inPartnerExternalName
                                                                      , inObjectCode := 0
                                                                      , inPartnerId  := 0 -- inPartnerId
                                                                      , inContractId := 0 -- inContractId
                                                                      , inRetailId   := inRetailId
                                                                      , inUserId     := vbUserId
                                                                      );
                                                                      */
     ELSE
         --если элемент найден пересохраним только параметр торг. сеть
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Retail(), vbPartnerExternalId, inRetailId);
     END IF;

     --находим Классификатор свойств товаров, по связи с partner , далее juridical, далее GoodsProperty
     vbGoodsPropertyId := (SELECT ObjectLink_Juridical_GoodsProperty.ChildObjectId
                           FROM ObjectLink AS ObjectLink_Partner
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner.ChildObjectId
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                           WHERE ObjectLink_Partner.ObjectId = vbPartnerExternalId 
                             AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
                           );

     -- пробуем найти документ 
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND MovementLinkObject_From.ObjectId = vbPartnerExternalId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                                         ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                                        AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
                                                        AND MovementLinkObject_GoodsProperty.ObjectId = vbGoodsPropertyId
                      WHERE Movement.DescId = zc_Movement_SaleExternal()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                        AND Movement.OperDate =  DATE_TRUNC ('MONTH', inOperDate)
                      );

     -- если не нашли создаем
     IF COALESCE (vbMovementId,0) = 0
     THEN
         -- сохранили <Документ>
         vbMovementId:= lpInsertUpdate_Movement_SaleExternal (ioId               := 0
                                                            , inInvNumber        := CAST (NEXTVAL ('movement_SaleExternal_seq') AS TVarChar)
                                                            , inOperDate         := inOperDate
                                                            , inFromId           := vbPartnerExternalId
                                                            , inGoodsPropertyId  := vbGoodsPropertyId
                                                            , inComment          := 'Загрузка' :: TVarChar
                                                            , inUserId           := vbUserId
                                                             )AS tmp;
     END IF;

     --создаем строки
     --находим GoodsId по Артикулу
     SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId     AS GoodsId
          , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
          , ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId  AS GoodsPropertyValueId
   INTO vbGoodsId, vbGoodsKindId, vbGoodsPropertyValueId
     FROM ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
          INNER JOIN ObjectString AS ObjectString_Article
                                  ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                 AND ObjectString_Article.ValueData = inArticle
          INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                               AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
          INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                               ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                              AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
     WHERE ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = vbGoodsPropertyId
       AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
     ;

     IF COALESCE (vbGoodsId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар <%> с артикулом <%> не найден.', inGoodsName, inArticle;
     END IF;
     
     -- сохраняем св-во  zc_ObjectString_GoodsPropertyValue_NameExternal
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_NameExternal(), vbGoodsPropertyValueId, inGoodsName);

     -- найти если такой товар уже записан
     vbId := (SELECT MovementItem.Id
              FROM MovementItem
                   INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                    AND MILinkObject_GoodsKind.ObjectId = vbGoodsKindId
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MovementItem.ObjectId = vbGoodsId
              LIMIT 1
             );

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_SaleExternal (ioId           := COALESCE (vbId,0) ::Integer
                                                     , inMovementId   := vbMovementId      ::Integer
                                                     , inGoodsId      := vbGoodsId         ::Integer
                                                     , inAmount       := CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() 
                                                                              THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 THEN inAmount / ObjectFloat_Weight.ValueData ELSE inAmount END
                                                                              ELSE inAmount
                                                                         END ::TFloat
                                                     , inGoodsKindId  := vbGoodsKindId     ::Integer
                                                     , inUserId       := vbUserId          ::Integer
                                                      ) 
     FROM ObjectLink AS ObjectLink_Measure
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = ObjectLink_Measure.ObjectId
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
     WHERE ObjectLink_Measure.ObjectId = vbGoodsId
       AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
16.11.20          *
*/

-- тест
--
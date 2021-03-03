-- Function: gpInsertUpdate_SaleExternal_Varus_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_SaleExternal_Varus_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_SaleExternal_Varus_Load(
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

     IF COALESCE (inAmount,0) = 0
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
         --RAISE EXCEPTION 'Ошибка.Контрагент внешний - <%> не найден.', inPartnerExternalName;
         vbPartnerExternalId :=  lpInsertUpdate_Object_PartnerExternal (ioId         := 0                                                 :: Integer 
                                                                      , inCode       := lfGet_ObjectCode(0, zc_Object_PartnerExternal())  :: Integer 
                                                                      , inName       := inPartnerExternalName                             :: TVarChar
                                                                      , inObjectCode := ''                                                :: TVarChar
                                                                      , inPartnerId  := 0                                                 :: Integer 
                                                                      , inContractId := 0                                                 :: Integer 
                                                                      , inRetailId   := inRetailId                                        :: Integer 
                                                                      , inUserId     := vbUserId                                          :: Integer 
                                                                      );
     ELSE
         --если элемент найден пересохраним только параметр торг. сеть
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Retail(), vbPartnerExternalId, inRetailId);
     END IF;

     IF COALESCE ((SELECT ObjectLink_Partner.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Partner
                   WHERE ObjectLink_Partner.ObjectId = vbPartnerExternalId 
                     AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner())
                , 0) <> 0
     THEN 
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
     END IF;

     --проверка
     /*IF COALESCE (vbGoodsPropertyId,0) = 0
     THEN
         --RAISE EXCEPTION 'Ошибка.Классификатор свойств товаров для Внешнего контрагента - <%> не найден.', inPartnerExternalName;
         --ищем все юр.лица, а к юр.лицам уже все договора и контрагентов,.. а по ним уже определять классификатор
         
     END IF;
     **/
     vbGoodsId := 0;
     vbGoodsKindId := 0;
     vbGoodsPropertyValueId := 0;
     
     --создаем строки
     --находим GoodsId по Артикулу
     SELECT tmp.GoodsId
               , tmp.GoodsKindId
               , tmp.GoodsPropertyValueId
               , tmp.GoodsPropertyId
   INTO vbGoodsId, vbGoodsKindId, vbGoodsPropertyValueId, vbGoodsPropertyId
     FROM 
          (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId     AS GoodsId
                , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
                , ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId  AS GoodsPropertyValueId
                , ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId  AS GoodsPropertyId
                  -- если вдруг не 1 классификатор , берем максимальный
                , MAX (ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId) OVER (PARTITION BY ObjectLink_GoodsPropertyValue_Goods.ChildObjectId ,ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId) AS GoodsPropertyId_max
             FROM 
                  (SELECT vbGoodsPropertyId AS GoodsPropertyId
                   WHERE COALESCE (vbGoodsPropertyId,0) <> 0
                  UNION
                   SELECT DISTINCT COALESCE (ObjectLink_Partner_GoodsProperty.ChildObjectId
                        , COALESCE (ObjectLink_Contract_GoodsProperty.ChildObjectId
                        , COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId
                        , COALESCE (ObjectLink_Retail_GoodsProperty.ChildObjectId)))) AS GoodsPropertyId
                   FROM 
                       (SELECT ObjectLink_Juridical_Retail.ObjectId   AS JuridicalId
                             , ObjectLink_Partner_Juridical.ObjectId  AS PartnerId
                             , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                 AND ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                  ON ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                 AND ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                        WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                        AND ObjectLink_Juridical_Retail.ChildObjectId = inRetailId --310854
                        ) AS tmp
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_GoodsProperty
                                               ON ObjectLink_Partner_GoodsProperty.ObjectId = tmp.PartnerId
                                              AND ObjectLink_Partner_GoodsProperty.DescId = zc_ObjectLink_Partner_GoodsProperty()
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = tmp.JuridicalId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                                               ON ObjectLink_Contract_GoodsProperty.ObjectId = tmp.ContractId
                                              AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = tmp.JuridicalId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                                               ON ObjectLink_Retail_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                              AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
                   WHERE COALESCE (vbGoodsPropertyId,0) = 0
                   ) AS tmp
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                           ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmp.GoodsPropertyId
                                          AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                     INNER JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                            AND TRIM(ObjectString_Article.ValueData) = TRIM (inArticle)  --'26841'
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                          ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                         AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
           ) AS tmp
     WHERE tmp.GoodsPropertyId = tmp.GoodsPropertyId_max;


     IF COALESCE (vbGoodsId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар <%> с артикулом <%> не найден.', inGoodsName, inArticle;
     END IF;
     
     -- сохраняем св-во  zc_ObjectString_GoodsPropertyValue_NameExternal
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_NameExternal(), vbGoodsPropertyValueId, inGoodsName);

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
                                                     , inAmount       := inAmount          ::TFloat
                                                     , inGoodsKindId  := vbGoodsKindId     ::Integer
                                                     , inUserId       := vbUserId          ::Integer
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
03.03.21          *
*/

-- тест
--
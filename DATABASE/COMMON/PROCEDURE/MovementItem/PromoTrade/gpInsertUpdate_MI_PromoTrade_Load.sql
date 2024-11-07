-- Function: gpInsertUpdate_MI_PromoTrade_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoTrade_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoTrade_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoTrade_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PromoTrade_Load(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inArticle                TVarChar  , -- Артикул клиента
    IN inGoodsCode              Integer   , --
    IN inGoodsName              TVarChar  ,
    IN inGoodsKindName          TVarChar  ,
    IN inAmount                 TFloat    , -- Количество
    IN inSumm                   TFloat    , -- Сумма, грн
    IN inAmountPlan             TFloat    , -- Количество План
    IN inPricePlan              TFloat    , -- Цена план, с НДС
    IN inPartnerCount           TFloat    ,
    IN inPartnerName            TVarChar  ,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbRetailId    Integer;
   DECLARE vbPartnerId   Integer;
   DECLARE vbMIId        Integer;
   DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTrade());


     IF TRIM (inArticle) = '' AND inGoodsCode = 0 AND TRIM (inGoodsName) = '' AND TRIM (inPartnerName) = ''
     THEN
         RETURN;
     END IF;


     IF TRIM (inArticle) <> ''
     THEN
         -- Находим
         vbGoodsPropertyId:= (SELECT zfCalc_GoodsPropertyId (MLO_Contract.ObjectId, OL_Contract_Juridical.ChildObjectId, 0)
                              FROM MovementLinkObject AS MLO_Contract
                                   LEFT JOIN ObjectLink AS OL_Contract_Juridical
                                                        ON OL_Contract_Juridical.ObjectId = MLO_Contract.ObjectId
                                                       AND OL_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                              WHERE MLO_Contract.MovementId = inMovementId
                                AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                             );
         IF COALESCE (vbGoodsPropertyId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Классификатор не найден для Юр.лицо = <%>.'
                            , (SELECT lfGet_Object_ValueData_sh (OL_Contract_Juridical.ChildObjectId)
                               FROM MovementLinkObject AS MLO_Contract
                                    LEFT JOIN ObjectLink AS OL_Contract_Juridical
                                                         ON OL_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                                                        AND OL_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                               WHERE MLO_Contract.MovementId = inMovementId
                                 AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                              )
                             ;
         END IF;

         -- Находим товары
         SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
              , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                INTO vbGoodsId, vbGoodsKindId
         FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
              ) AS tmpGoodsProperty
              INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                    ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                   AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId       = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
              INNER JOIN ObjectString AS ObjectString_Article
                                      ON ObjectString_Article.ObjectId  = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                     AND ObjectString_Article.DescId    = zc_ObjectString_GoodsPropertyValue_Article()
                                     -- По Артикулу
                                     AND ObjectString_Article.ValueData = TRIM (inArticle)

              LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                   ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
        ;

     ELSE
         -- 
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods())
         THEN
             RAISE EXCEPTION 'Ошибка.Код товара <%> не уникальный.', inGoodsCode;
         END IF;
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind())
         THEN
             RAISE EXCEPTION 'Ошибка.Вид товара <%> не уникальный.', inGoodsKindName;
         END IF;
         -- Находим товары
         vbGoodsId        := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
         -- находим вид товара
         vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind());

     END IF;


     -- находим Контрагента (если есть)
     IF COALESCE (inPartnerName,'') <> ''
     THEN

         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ValueData = TRIM (inPartnerName) AND Object.DescId = zc_Object_Partner() AND Object.isErased = FALSE)
         THEN
             RAISE EXCEPTION 'Ошибка.Контрагент <%> не уникальный.', inPartnerName;
         END IF;

         -- поиск
         vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inPartnerName) AND Object.DescId = zc_Object_Partner() AND Object.isErased = FALSE);

         -- если не нашли
         IF COALESCE (vbPartnerId,0) = 0
         THEN
             IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ValueData = TRIM (inPartnerName) AND Object.DescId = zc_Object_Partner())
             THEN
                 RAISE EXCEPTION 'Ошибка.Контрагент <%> не уникальный.', inPartnerName;
             END IF;
    
             -- поиск
             vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inPartnerName) AND Object.DescId = zc_Object_Partner());
         END IF;


         -- если не нашли
         IF COALESCE (vbPartnerId,0) = 0
         THEN
             -- поиск
             vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                            FROM MovementLinkObject AS MovementLinkObject_Contract
                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                      ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                                                     AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                            WHERE MovementLinkObject_Contract.MovementId = inMovementId
                              AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                           );

             -- поиск
             vbPartnerId := (SELECT ObjectLink_Partner.ChildObjectId
                             FROM Object AS Object_PartnerExternal
                                  --INNER JOIN ObjectString AS ObjectString_ObjectCode
                                  --                        ON ObjectString_ObjectCode.ObjectId  = Object_PartnerExternal.Id 
                                   --                      AND ObjectString_ObjectCode.DescId    = zc_ObjectString_PartnerExternal_ObjectCode()
                                    --                     AND ObjectString_ObjectCode.ValueData = inPartnerExternalCode
                                  INNER JOIN ObjectLink AS ObjectLink_Retail
                                                        ON ObjectLink_Retail.ObjectId      = Object_PartnerExternal.Id 
                                                       AND ObjectLink_Retail.DescId        = zc_ObjectLink_PartnerExternal_Retail()
                                                       AND ObjectLink_Retail.ChildObjectId = vbRetailId

                                  INNER JOIN ObjectLink AS ObjectLink_Partner
                                                        ON ObjectLink_Partner.ObjectId = Object_PartnerExternal.Id 
                                                       AND ObjectLink_Partner.DescId   = zc_ObjectLink_PartnerExternal_Partner()

                             WHERE Object_PartnerExternal.DescId   = zc_Object_PartnerExternal()
                               AND Object_PartnerExternal.ValueData ILIKE TRIM (inPartnerName)
                            );
         END IF;

         IF COALESCE (vbPartnerId,0) = 0 AND vbUserId <> 5
         THEN
             RAISE EXCEPTION 'Ошибка.Контрагент <%> не найден.',inPartnerName;
         END IF;

     END IF;

     IF COALESCE (vbGoodsId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар (<%>) <%> не найден.%Артикул = <%> %Классификатор = <%>.'
                       , inGoodsCode
                       , inGoodsName
                       , CHR (13)
                       , inArticle
                       , CHR (13)
                       , CASE WHEN vbGoodsPropertyId > 0 THEN lfGet_Object_ValueData_sh(vbGoodsPropertyId) ELSE '' END
                        ;
     END IF;

     IF (COALESCE (vbGoodsKindId,0) = 0 AND COALESCE (inGoodsKindName,'') <> '' )
     THEN
         RAISE EXCEPTION 'Ошибка.Вид товара <%> не найден.', inGoodsKindName;
     END IF;

     --пробуем найти строку для обновления
     vbMIId := 0 /*(SELECT MovementItem.Id
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                      ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                   AND MovementItem.ObjectId = vbGoodsId
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE(vbGoodsKindId,0)
                   AND (COALESCE (MILinkObject_Partner.ObjectId,0) = COALESCE (vbPartnerId,0))
                )*/;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_PromoTradeGoods (ioId                   := COALESCE (vbMIId,0) ::Integer
                                                        , inMovementId           := inMovementId ::Integer
                                                        , inPartnerId            := vbPartnerId  ::Integer
                                                        , inGoodsId              := vbGoodsId    ::Integer
                                                        , inAmount               := inAmount     ::TFloat
                                                        , inSumm                 := inSumm       ::TFloat
                                                        , inPartnerCount         := inPartnerCount ::TFloat
                                                        , inAmountPlan           := inAmountPlan
                                                        , inPriceWithVAT         := inPricePlan
                                                        , inGoodsKindId          := vbGoodsKindId  ::Integer
                                                        , inTradeMarkId          := 0  ::Integer
                                                        , inGoodsGroupPropertyId := 0  ::Integer
                                                        , inGoodsGroupDirectionId:= 0  ::Integer
                                                        , inComment              := '' ::TVarChar
                                                        , inUserId               := vbUserId
                                                         ) ;

     -- сохранили <Элемент> - Состояние
     IF NOT EXISTS (SELECT 1 FROM MovementItem AS MI JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message() AND MI.isErased = FALSE)
     THEN
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, zc_Enum_PromoTradeStateKind_Start());
         --
         PERFORM gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := 0
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := zc_Enum_PromoTradeStateKind_Start()
                                                              , inIsQuickly             := FALSE
                                                              , inComment               := ''
                                                              , inSession               := inSession
                                                               );
     END IF;


     IF vbUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.ok.';
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.09.24        *
*/

-- тест
-- select * from gpInsertUpdate_MI_PromoTrade_Load(inMovementId := 18002434 ,  inSession := '5');
-- Function: lpInsertUpdate_MovementItem_PromoTradeGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoTradeGoods(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>   
    IN inPartnerId             Integer   ,
    IN inGoodsId               Integer   , -- Товары
    IN inAmount                TFloat    , -- 
    IN inSumm                  TFloat    , --
    IN inPartnerCount          TFloat    , -- Цена на полке
    IN inAmountPlan            TFloat    , --
    IN inPriceWithVAT          TFloat    , --   
   OUT outPriceWithOutVAT      TFloat    ,
    IN inGoodsKindId           Integer   , --ИД обьекта <Вид товара>
    IN inTradeMarkId           Integer   , --Торговая марка 
    IN inGoodsGroupPropertyId  Integer,
    IN inGoodsGroupDirectionId Integer,
    IN inComment               TVarChar  , --Комментарий
    IN inUserId                Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;  
   DECLARE vbIsUpdate_general Boolean;
   DECLARE vbVat TFloat;
BEGIN
 
    -- признак - изменение "важных" параметров
    vbIsUpdate_general:= inGoodsId <> COALESCE ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId), 0)
                      OR inSumm    <> COALESCE ((SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = ioId AND MF.DescId = zc_MIFloat_Summ()), 0)
                        ;

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL, inUserId);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartnerCount(), ioId, inPartnerCount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan(), ioId, inAmountPlan);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, inPriceWithVAT);
    
   --НДС из прайса договора 
    vbVat := COALESCE( (SELECT ObjectFloat_VATPercent.ValueData
                        FROM MovementLinkObject AS MLO
                             LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                                   ON ObjectFloat_VATPercent.ObjectId = MLO.ObjectId
                                                  AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
                        WHERE MLO.DescId = zc_MovementLinkObject_PriceList()
                          AND MLO.MovementId = inMovementId)
                      , 20)::TFloat;
    outPriceWithOutVAT:= ROUND ((inPriceWithVAT - inPriceWithVAT * (vbVAT / (vbVAT + 100))) , 2)::TFloat ; 
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), ioId, outPriceWithOutVAT);     
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TradeMark(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inTradeMarkId ELSE NULL END ::Integer);
    -- сохранили связь с <Вид товара>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
  
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TradeMark(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inTradeMarkId ELSE NULL END ::Integer);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupProperty(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupPropertyId ELSE NULL END ::Integer);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupDirection(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupDirectionId ELSE NULL END ::Integer);
    
    -- сохранили <Комментарий>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

    -- сохранили протокол
    IF inUserId > 0 THEN 
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    ELSE
      PERFORM lpInsert_MovementItemProtocol (ioId, zc_Enum_Process_Auto_ReComplete(), vbIsInsert);
    END IF;


     -- если была корректировка + последний не zc_Enum_PromoTradeStateKind_Start
     IF vbIsUpdate_general = TRUE
            AND zc_Enum_PromoTradeStateKind_Start() <> (SELECT MI.ObjectId
                                                        FROM MovementItem AS MI
                                                             JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
                                                        WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message() AND MI.isErased = FALSE
                                                        ORDER BY MI.Id DESC
                                                        LIMIT 1
                                                       )
     THEN
         -- сняли ВСЕ подписи
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Sign()
           AND MovementItem.isErased   = FALSE
          ;

         -- сохранили <В работе Автор документа>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, zc_Enum_PromoTradeStateKind_Start());
         -- сохранили <В работе Автор документа>
         PERFORM gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := 0
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := zc_Enum_PromoTradeStateKind_Start()
                                                              , inIsQuickly             := FALSE
                                                              , inComment               := ''
                                                              , inSession               := inUserId :: TVarChar
                                                               );

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.09.24         *
 03.09.24         *
 */
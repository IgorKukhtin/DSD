-- Function: gpInsertUpdate_MovementItem_PromoTradeGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoTradeGoods(
 INOUT ioId                             Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                     Integer   , -- Ключ объекта <Документ>
    IN inPartnerId                      Integer   , --
    IN inGoodsId                        Integer   , -- Товары
    IN inAmount                         TFloat    , --
    IN inSumm                           TFloat    , -- Cумм грн
    IN inPartnerCount                   TFloat    , --
    IN inAmountPlan                     TFloat    , --
    IN inPriceWithVAT                   TFloat    , --
   OUT outPriceWithOutVAT               TFloat    ,
   OUT outSummWithOutVATPlan            TFloat    ,
   OUT outSummWithVATPlan               TFloat    ,
    IN inGoodsKindId                    Integer   , -- ИД обьекта <Вид товара>
    IN inTradeMarkId                    Integer   ,  --Торговая марка
    IN inGoodsGroupPropertyId           Integer,
    IN inGoodsGroupPropertyId_Parent    Integer,
    IN inGoodsGroupDirectionId          Integer,
   OUT outTradeMarkName                 TVarChar,
   OUT outGoodsGroupPropertyName        TVarChar,
   OUT outGoodsGroupPropertyName_Parent TVarChar,
   OUT outGoodsGroupDirectionName       TVarChar,
    IN inComment                        TVarChar  , -- Комментарий
    IN inSession                        TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceList Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTrade());


    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- Проверили уникальность товар/вид товара
    IF EXISTS (SELECT 1
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId = inGoodsId
                   AND MovementItem.IsErased = FALSE
                   AND MovementItem.DescId = zc_MI_Master()
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                   AND MovementItem.Id <> ioId
               )
    THEN
        RAISE EXCEPTION 'Ошибка. В документе уже указана есть товар = <%> и вид = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
    END IF;

    -- переопределяем  если inGoodsGroupPropertyId заполнено берем его , если нет то группу
    inGoodsGroupPropertyId := CASE WHEN COALESCE (inGoodsGroupPropertyId,0) <> 0 THEN inGoodsGroupPropertyId ELSE inGoodsGroupPropertyId_Parent END;

    -- сохранили
    SELECT tmp.ioId, tmp.outPriceWithOutVAT
           INTO ioId, outPriceWithOutVAT
    FROM lpInsertUpdate_MovementItem_PromoTradeGoods (ioId                   := ioId
                                                    , inMovementId           := inMovementId
                                                    , inPartnerId            := inPartnerId
                                                    , inGoodsId              := inGoodsId
                                                    , inAmount               := inAmount
                                                    , inSumm                 := inSumm
                                                    , inPartnerCount         := inPartnerCount
                                                    , inAmountPlan           := inAmountPlan
                                                    , inPriceWithVAT         := inPriceWithVAT
                                                    , inGoodsKindId          := inGoodsKindId
                                                    , inTradeMarkId          := inTradeMarkId
                                                    , inGoodsGroupPropertyId := inGoodsGroupPropertyId
                                                    , inGoodsGroupDirectionId:= inGoodsGroupDirectionId
                                                    , inComment              := inComment
                                                    , inUserId               := vbUserId
                                                     ) AS tmp;

    SELECT Object_TradeMark.ValueData                AS TradeMark
         , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
         , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent
         , Object_GoodsGroupDirection.ValueData      AS GoodsGroupDirectionName
   INTO outTradeMarkName, outGoodsGroupPropertyName, outGoodsGroupPropertyName_Parent, outGoodsGroupDirectionName
    FROM MovementItem
             LEFT JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                              ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                             AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (MILinkObject_TradeMark.ObjectId, ObjectLink_Goods_TradeMark.ChildObjectId)
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupProperty
                                              ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()
                                             AND COALESCE (MovementItem.ObjectId,0) = 0

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
             LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
             LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupDirection
                                              ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupDirection.DescId = zc_MILinkObject_GoodsGroupDirection()
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                  ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
             LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = COALESCE (MILinkObject_GoodsGroupDirection.ObjectId, ObjectLink_Goods_GoodsGroupDirection.ChildObjectId)

    WHERE MovementItem.Id = ioId;

     -- Если не заполнено, надо поставить стартовый
     IF NOT EXISTS (SELECT 1 FROM MovementItem AS MI JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message() AND MI.isErased = FALSE)
     THEN
         -- сохранили <В работе Автор документа>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, zc_Enum_PromoTradeStateKind_Start());
         -- сохранили <В работе Автор документа>
         PERFORM gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := 0
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := zc_Enum_PromoTradeStateKind_Start()
                                                              , inIsQuickly             := FALSE
                                                              , inComment               := ''
                                                              , inSession               := inSession
                                                               );
     END IF;


    -- вернули данные
    outSummWithOutVATPlan:= (inAmountPlan * outPriceWithOutVAT) ::TFloat;
    outSummWithVATPlan   := (inAmountPlan * inPriceWithVAT)     ::TFloat;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.09.24         *
*/
-- Function: gpInsertUpdate_MovementItem_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_UnnamedEnterprises (Integer, Integer, Integer, TVarChar, TFloat, TFloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_UnnamedEnterprises (Integer, Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_UnnamedEnterprises(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsNameUkr        TVarChar  , -- Название украинское
    IN inAmount              TFloat    , -- Количество
    IN inAmountOrder         TFloat    , -- Количество в заказ
    IN inPrice               TFloat    , -- Цена
   OUT outSumm               TFloat    , -- Сумма
   OUT outSummOrder          TFloat    , -- Сумма в заказ
    IN inCodeUKTZED          TVarChar  , -- Код УКТЗЭД
    IN inExchangeId          Integer   , -- Од
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_UnnamedEnterprises());
    vbUserId := inSession;

    IF EXISTS(SELECT 1 FROM MovementLinkMovement
              WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
                AND MovementLinkMovement.MovementId = inMovementId)
    THEN
      RAISE EXCEPTION 'Ошибка. По безналу предприятия создана продежа <%> от <%>...',
        (SELECT Movement.InvNumber
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
           AND MovementLinkMovement.MovementId = inMovementId),
        (SELECT to_char(Movement.OperDate, 'DD-MM-YYYY')
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
           AND MovementLinkMovement.MovementId = inMovementId);
    END IF;

    IF EXISTS(SELECT 1 FROM MovementLinkMovement
              WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                AND MovementLinkMovement.MovementId = inMovementId) AND
       NOT EXISTS(SELECT 1 FROM MovementItemFloat
             WHERE MovementItemFloat.DescId = zc_MIFloat_AmountOrder() AND MovementItemFloat.MovementItemId = ioId
               AND COALESCE (MovementItemFloat.ValueData, 0) = COALESCE (inAmountOrder, 0))
    THEN
      RAISE EXCEPTION 'Ошибка. Данные добавлены во внутренний заказ номер <%> от <%>. Изменение количества в заказ запрещено...',
        (SELECT Movement.InvNumber
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
           AND MovementLinkMovement.MovementId = inMovementId),
        (SELECT to_char(Movement.OperDate, 'DD-MM-YYYY')
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
           AND MovementLinkMovement.MovementId = inMovementId);
    END IF;

    --Посчитали сумму
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(inPrice,0),2);
    outSummOrder := ROUND(COALESCE(inAmountOrder,0)*COALESCE(inPrice,0),2);

     -- сохранили
    ioId := lpInsertUpdate_MovementItem_UnnamedEnterprises (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inAmountOrder        := inAmountOrder
                                            , inPrice              := inPrice
                                            , inSumm               := outSumm
                                            , inSummOrder          := outSummOrder
                                            , inUserId             := vbUserId
                                             );

   IF (COALESCE (inGoodsNameUkr, '') <> '' OR COALESCE (inCodeUKTZED, '') <> '' OR COALESCE (inExchangeId, 0) <> 0)
     AND EXISTS(SELECT Object_Goods_View.Id
                FROM Object_Goods_View
                  LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                         ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods_View.Id
                                        AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

                  LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                         ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods_View.Id
                                        AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                       ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods_View.Id
                                      AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()

             WHERE Object_Goods_View.Id = inGoodsId AND (
                 ((COALESCE (inGoodsNameUkr, '') <> '') AND COALESCE (ObjectString_Goods_NameUkr.ValueData, '') <> COALESCE (inGoodsNameUkr, '')) OR
                 ((COALESCE (inCodeUKTZED, '') <> '') AND COALESCE (ObjectString_Goods_CodeUKTZED.ValueData, '') <> COALESCE (inCodeUKTZED, '')) OR
                 ((COALESCE (inExchangeId, 0) <> 0) AND COALESCE (ObjectLink_Goods_Exchange.ChildObjectId, 0) <> COALESCE (inExchangeId, 0))))
   THEN
      PERFORM lpUpdate_MovementItem_UnnamedEnterprises_Goods(
                                              inId           := inGoodsId
                                            , inNameUkr      := inGoodsNameUkr
                                            , inCodeUKTZED   := inCodeUKTZED
                                            , inExchangeId   := inExchangeId
                                            , inSession      := inSession) ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 02.10.18         *
 30.09.18         *
*/
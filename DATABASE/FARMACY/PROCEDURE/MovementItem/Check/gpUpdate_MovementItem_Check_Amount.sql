 -- Function: gpUpdate_MovementItem_Check_Amount()

--DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Check_Amount (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Check_Amount (Integer, Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Check_Amount(
    IN inId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inCommentCheckId      Integer   , -- Комментарий строк в заказах
   OUT outTotalSumm          TFloat    , -- Сумма чека
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountOrder TFloat;
   DECLARE vbCheckSourceKind Integer;
   DECLARE vbTotalCount TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);


    -- Провкряем элемент по документу
    IF COALESCE (inId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION 'Не найден элемент по документа';
    END IF;

    IF inAmount < 0
    THEN
        RAISE EXCEPTION 'Количество должно быть положительным или равно нолю.';
    END IF;      
    
    vbCheckSourceKind := COALESCE((SELECT MovementLinkObject.ObjectId
                                   FROM MovementLinkObject 
                                   WHERE MovementLinkObject.MovementID = inMovementId
                                     AND MovementLinkObject.DescId = zc_MovementLinkObject_CheckSourceKind()), 0);

    SELECT MovementItem.Amount, COALESCE (MIFloat_AmountOrder.ValueData, 0)
    INTO vbAmount, vbAmountOrder
    FROM MovementItem
         LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                     ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                    AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()      
    WHERE MovementItem.ID = inId;
    
    IF COALESCE (inCommentCheckId, 0) <> 0
    THEN
      IF vbCheckSourceKind <> zc_Enum_CheckSourceKind_Tabletki()
      THEN
        RAISE EXCEPTION 'Причина уменьшения количества можно устанавливать только на заказы таблеток.';
      END IF;

      IF inAmount >= vbAmountOrder
      THEN
          RAISE EXCEPTION 'Заполнять поле <Причина уменьшения количества> необходимо только при уменьшении количества товара от заказа.';
      END IF;          

    ELSEIF COALESCE (inCommentCheckId, 0) = 0 AND vbCheckSourceKind = zc_Enum_CheckSourceKind_Tabletki()
    THEN
      IF inAmount < vbAmountOrder
      THEN
          RAISE EXCEPTION 'Заполните поле <Причина уменьшения количества>.';
      END IF;          
    END IF;

    -- Находим элемент по документу и товару
    IF COALESCE (inMovementId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION 'Не задан документ или неправельная связь';
    END IF;
    
    IF vbCheckSourceKind = zc_Enum_CheckSourceKind_Tabletki()
    THEN
      IF inAmount > ceil(vbAmountOrder)
      THEN
          RAISE EXCEPTION 'Увеличивать количество на целые значения запрещено, можно до ближайшего целого. Отпустите клиента отдельтным чеком.';
      END IF;      
    END IF;

    -- сохранили <Элемент документа>
    UPDATE MovementItem SET Amount = inAmount 
    WHERE DescId = zc_MI_Master() AND ID = inId;

    -- сохранили связь с <Комментарий строк в заказах>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentCheck(), inId, inCommentCheckId);

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);
    
    -- Получили сумму документа
    SELECT MovementFloat_TotalSumm.ValueData
    INTO outTotalSumm
    FROM MovementFloat AS MovementFloat_TotalSumm
    WHERE MovementFloat_TotalSumm.MovementId =  inMovementId
      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm();


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
    

    -- Удаляем если все занулили
    IF  vbCheckSourceKind = zc_Enum_CheckSourceKind_Tabletki()
    THEN

      --определяем
      SELECT COALESCE (MovementFloat_TotalCount.ValueData, 0)
      INTO vbTotalCount
      FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

      WHERE Movement.Id = inMovementId;

      IF COALESCE (vbTotalCount, 0) = 0
      THEN
        PERFORM  gpSetErased_Movement_CheckVIP(inMovementId, 15016705, inSession);
      END IF;
    END IF;    
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_Check_Amount (Integer, Integer, Integer, TFloat, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Шаблий О.В.
 06.10.18       *
*/

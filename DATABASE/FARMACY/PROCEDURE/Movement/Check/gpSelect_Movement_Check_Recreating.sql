-- Function: gpSelect_Movement_Check_Recreating()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_Recreating (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_Recreating(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
   OUT outMovementId       Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbInvNumber Integer;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbComment TVarChar;   
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    SELECT Movement.StatusId
         , 'Сформирован по чеку '||Movement.InvNumber ||' от '||zfConvert_DateToString(Movement.OperDate)
         , MovementLinkObject_Unit.ObjectId
         , MovementFloat_TotalSumm.ValueData 
    INTO vbStatusId
       , vbComment
       , vbUnitId
       , vbTotalSumm
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

    WHERE Movement.Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_Complete()
    THEN
        RAISE EXCEPTION 'Ошибка. Пересоздать чек в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- Получили номер документа
    SELECT COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1
    INTO vbInvNumber
    FROM Movement_Check_View
    WHERE Movement_Check_View.UnitId = vbUnitId
      AND Movement_Check_View.OperDate > CURRENT_DATE;
            
    -- сохранили <Документ>
    outMovementId := lpInsertUpdate_Movement (0, zc_Movement_Check(), vbInvNumber::TVarChar, CURRENT_TIMESTAMP, NULL);

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), outMovementId, vbUnitId);

    -- сохранили связь с <С чеком источником>
    PERFORM lpInsertUpdate_MovementLinkMovement(zc_MovementLinkMovement_Master(), outMovementId, inMovementId);    

    -- Скопировали параметры чека
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RoundingTo10(), outMovementId, COALESCE (MB_RoundingTo10.ValueData, FALSE))
          , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RoundingDown(), outMovementId, COALESCE (MB_RoundingDown.ValueData, FALSE))
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(), outMovementId, zc_Enum_PaidType_Cash())
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DiscountCard(), outMovementId, COALESCE (MovementLinkObject_DiscountCard.ObjectId, 0))
          -- сохранили свойство <Дата создания>
          , lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), outMovementId, CURRENT_TIMESTAMP)
          -- сохранили свойство <Пользователь (создание)>
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), outMovementId, vbUserId)
         -- , vbComment)
    FROM Movement
         LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                   ON MB_RoundingTo10.MovementId =  Movement.Id
                                  AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
         LEFT JOIN MovementBoolean AS MB_RoundingDown
                                   ON MB_RoundingDown.MovementId = Movement.Id
                                  AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                      ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                     AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
    WHERE Movement.ID = inMovementId;
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (outMovementId, vbUserId, True);
    
    PERFORM gpInsertUpdate_MovementItem_Check_ver2 (ioId                  := 0               -- Ключ объекта <строка документа>
                                                  , inMovementId          := outMovementId   -- Ключ объекта <Документ>
                                                  , inGoodsId             := MovementItem_Check_View.GoodsId       -- Товары
                                                  , inAmount              := MovementItem_Check_View.Amount        -- Количество
                                                  , inPrice               := COALESCE(MovementItem_Check_View.Price, 0)              -- Цена
                                                  , inPriceSale           := COALESCE(MovementItem_Check_View.PriceSale, 0)          -- Цена без скидки
                                                  , inChangePercent       := COALESCE(MovementItem_Check_View.ChangePercent, 0)      -- % Скидки
                                                  , inSummChangePercent   := COALESCE(MovementItem_Check_View.SummChangePercent, 0)  -- Сумма Скидки
                                                  , inPartionDateKindID   := MILO_PartionDateKind.ObjectId         -- Тип срок/не срок
                                                  , inPricePartionDate    := MIFloat_PricePartionDate.ValueData    -- Цена отпускная согласно срока
                                                  , inNDSKindId           := MovementItem_Check_View.NDSKindId     -- Ставка НДС
                                                  , inDiscountExternalId  := MILO_DiscountExternal.ObjectId        -- Проект дисконтных карт
                                                  , inDivisionPartiesID   := MILO_DivisionParties.ObjectId         -- Разделение партий в кассе для продажи
                                                  , inPresent             := COALESCE(MIBoolean_Present.ValueData, False)   -- Подарок
                                                  , inList_UID            := ''     -- UID строки
                                                  , inUserSession	      := inSession
                                                  , inSession             := inSession)
    FROM MovementItem_Check_View

         LEFT JOIN MovementItemLinkObject AS MILO_PartionDateKind
                                          ON MILO_PartionDateKind.MovementItemId = MovementItem_Check_View.Id
                                         AND MILO_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
                                         
         LEFT JOIN MovementItemLinkObject AS MILO_DiscountExternal
                                          ON MILO_DiscountExternal.MovementItemId = MovementItem_Check_View.Id
                                         AND MILO_DiscountExternal.DescId = zc_MILinkObject_DiscountExternal()

         LEFT JOIN MovementItemLinkObject AS MILO_DivisionParties
                                          ON MILO_DivisionParties.MovementItemId = MovementItem_Check_View.Id
                                         AND MILO_DivisionParties.DescId = zc_MILinkObject_DivisionParties()

         LEFT JOIN MovementItemFloat AS MIFloat_PricePartionDate
                                     ON MIFloat_PricePartionDate.MovementItemId = MovementItem_Check_View.Id
                                    AND MIFloat_PricePartionDate.DescId = zc_MIFloat_PricePartionDate()
    
         LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                       ON MIBoolean_Present.MovementItemId = MovementItem_Check_View.Id
                                      AND MIBoolean_Present.DescId = zc_MIBoolean_Present()

    WHERE MovementItem_Check_View.MovementId = inMovementId
      AND MovementItem_Check_View.isErased = False
      AND MovementItem_Check_View.Amount > 0;
      
    IF COALESCE(vbTotalSumm, 0) <> COALESCE((SELECT MovementFloat_TotalSumm.ValueData 
                                             FROM MovementFloat AS MovementFloat_TotalSumm
                                             WHERE MovementFloat_TotalSumm.MovementId =  outMovementId
                                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()), 0)
    THEN
        RAISE EXCEPTION 'Ошибка. Сумма созданного чека отличаеться от суммы исходного, обратитесь к системному администратору.';
    END IF;
      
    PERFORM gpUnComplete_Movement_Check (inMovementId, inSession, inSession);
    PERFORM gpSetErased_Movement_Check (inMovementId, zfCalc_UserAdmin());

    PERFORM gpComplete_Movement_Check (outMovementId, inSession);
    
  -- RAISE EXCEPTION 'Прошло.';
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.08.21                                                       *    
*/
-- тест
-- select * from gpSelect_Movement_Check_Recreating(inMovementId := 24479161 ,  inSession := '3');
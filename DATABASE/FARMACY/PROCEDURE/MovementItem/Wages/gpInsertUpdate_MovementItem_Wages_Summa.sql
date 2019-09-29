-- Function: gpInsertUpdate_MovementItem_Wages_Summa()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Summa(INTEGER, INTEGER, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_Summa(
    IN ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inHolidaysHospital    TFloat    , -- Отпуск / Больничный
    IN inMarketing           TFloat    , -- Маркетинг
    IN inDirector            TFloat    , -- Директор. премии / штрафы
    IN inAmountCard          TFloat    , -- На карту
    IN inisIssuedBy          Boolean   , -- 
   OUT outAmountHand         TFloat    , -- На руки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (ioId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
    END IF;
    
    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF EXISTS(SELECT 1 FROM MovementItem WHERE ID = ioId AND MovementItem.DescId = zc_MI_Sign())
    THEN
      IF COALESCE(inHolidaysHospital, 0) <> 0 OR
         COALESCE(inMarketing, 0) <> 0 OR
         COALESCE(inDirector, 0) <> 0 OR
         COALESCE(inAmountCard, 0) <> 0
      THEN
        RAISE EXCEPTION 'Ошибка. Для дополнительных расходов можно изменять только признак "Выдано".';      
      END IF;
    
       -- сохранили свойство <Дата выдачи>
      IF inisIssuedBy <> COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId) , inisIssuedBy)
      THEN
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
      
         -- сохранили свойство <Выдано>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
      

        -- сохранили протокол
        PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);    
      END IF;

      SELECT MovementItem.Amount 
      INTO outAmountHand
      FROM  MovementItem
      WHERE MovementItem.Id = ioId;
    ELSE
    
    
      IF EXISTS( SELECT 1
        FROM  MovementItem

              LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                          ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                         AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

              LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                          ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                         AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

              LEFT JOIN MovementItemFloat AS MIFloat_Director
                                          ON MIFloat_Director.MovementItemId = MovementItem.Id
                                         AND MIFloat_Director.DescId = zc_MIFloat_Director()

              LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                          ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                         AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()
                                         
              LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                            ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                           AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

        WHERE MovementItem.Id = ioId 
          AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = True
          AND (COALESCE (MIFloat_HolidaysHospital.ValueData, 0) <> COALESCE (inHolidaysHospital, 0)
            OR COALESCE (MIFloat_Marketing.ValueData, 0) <>  COALESCE (inMarketing, 0)
            OR COALESCE (MIFloat_Director.ValueData, 0) <>  COALESCE (inDirector, 0)
            OR COALESCE (MIF_AmountCard.ValueData, 0) <>  COALESCE (inAmountCard, 0)))
      THEN
        RAISE EXCEPTION 'Ошибка. Зарплата выдана. Изменение сумм запрещено.';            
      END IF;
        
       -- сохранили свойство <Отпуск / Больничный>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HolidaysHospital(), ioId, inHolidaysHospital);
       -- сохранили свойство <Маркетинг>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Marketing(), ioId, inMarketing);
       -- сохранили свойство <Директор. премии / штрафы>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Director(), ioId, inDirector);

       -- сохранили свойство <На карту>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountCard(), ioId, inAmountCard);

       -- сохранили свойство <Дата выдачи>
      IF inisIssuedBy <> COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId) , inisIssuedBy)
      THEN
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
      
         -- сохранили свойство <Выдано>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
      END IF;

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);

      SELECT (MovementItem.Amount + 
              COALESCE (MIFloat_HolidaysHospital.ValueData, 0) + 
              COALESCE (MIFloat_Marketing.ValueData, 0) +
              COALESCE (MIFloat_Director.ValueData, 0) - 
              COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand
      INTO outAmountHand
      FROM  MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                        ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                       AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

            LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                        ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                       AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

            LEFT JOIN MovementItemFloat AS MIFloat_Director
                                        ON MIFloat_Director.MovementItemId = MovementItem.Id
                                       AND MIFloat_Director.DescId = zc_MIFloat_Director()

            LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                        ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                       AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

      WHERE MovementItem.Id = ioId;
  END IF;

    --
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.08.19                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages_Summa (, inSession:= '2')
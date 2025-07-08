-- Function: gpInsertUpdate_Movement_PromoTradeCondition()
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTradeCondition (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTradeCondition (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoTradeCondition(
    IN inMovementId            Integer    , -- Ключ объекта <Документ Трейд маркетинг>
    IN inOrd                   Integer    , -- Номер строки, по ней определим какое значение
    IN inValue                 TVarChar   , -- значение 
    IN inValue_new             TVarChar   , -- значение новое
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementId_PromoTradeCondition Integer;
           vbChangePercent TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());

    --проверка данные из шапки не корректируются
    IF inOrd = 1 OR inOrd = 3
    THEN 
      RAISE EXCEPTION 'Ошибка. Выбранный параметр не вводится, а берется из Договора.';
    END IF;
    -- проверка, можно вводить только новую 
    IF inOrd = 2
    THEN
         vbChangePercent := (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_ChangePercent())::TVarChar;  
         
         IF COALESCE (vbChangePercent,'') <> COALESCE (inValue,'')
         THEN
              RAISE EXCEPTION 'Ошибка. Выбранный параметр не вводится, а берется из Договора.';
         END IF;
    END IF;

    vbMovementId_PromoTradeCondition := (SELECT Movement.Id
                                         FROM Movement
                                         WHERE Movement.DescId = zc_Movement_PromoTradeCondition()
                                           AND Movement.ParentId = inMovementId
                                         );
        
    IF COALESCE (vbMovementId_PromoTradeCondition,0) = 0 
    THEN
        --создаем документ
        SELECT lpInsertUpdate_Movement (0, zc_Movement_PromoTradeCondition(), Movement.InvNumber, Movement.OperDate, Movement.Id, 0) 
      INTO vbMovementId_PromoTradeCondition
        FROM Movement
        WHERE Movement.Id = inMovementId;
    END IF;
    
    --замена
    inValue:= REPLACE (TRIM (inValue), ',', '.');
    inValue_new:= REPLACE (TRIM (inValue_new), ',', '.');

    IF COALESCE (inValue_new,'') = ''
    THEN
        inValue_new := inValue;
    END IF;

    IF inOrd = 2
    THEN 
        --ChangePercent_new
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent_new(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue_new)::TFloat);
    END IF;

    IF inOrd = 4
    THEN 
        --RetroBonus
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_RetroBonus(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_RetroBonus_new(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue_new)::TFloat);
    END IF;

    IF inOrd = 5
    THEN 
        --Market
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Market(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Market_new(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue_new)::TFloat);
    END IF;
    
    IF inOrd = 6
    THEN 
        --ReturnIn
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ReturnIn(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ReturnIn_new(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue_new)::TFloat);
    END IF;
    
    IF inOrd = 7
    THEN 
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Logist(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Logist_new(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue_new)::TFloat);
    END IF;

    IF inOrd = 8
    THEN 
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Report(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Report_(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue_new)::TFloat);
    END IF;   

    IF inOrd = 9
    THEN 
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MarketSumm(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MarketSumm_new(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue_new)::TFloat);
    END IF;
    
   /* IF vbUserId = 9457
    THEN
        RAISE EXCEPTION 'Test.Ok';
    END IF;
    */
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.06.25         *
 29.08.24         *
*/
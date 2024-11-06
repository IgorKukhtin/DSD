-- Function: gpInsertUpdate_Movement_PromoTradeCondition()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTradeCondition (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoTradeCondition(
    IN inMovementId            Integer    , -- Ключ объекта <Документ Трейд маркетинг>
    IN inOrd                   Integer    , -- Номер строки, по ней определим какое значение
    IN inValue                 TVarChar   , -- значение 
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementId_PromoTradeCondition Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());

    --проверка данные из шапки не корректируются
    IF inOrd <= 3
    THEN 
      RAISE EXCEPTION 'Ошибка. Выбранный параметр не вводится, а берется из Договора.';
    END IF;


    vbMovementId_PromoTradeCondition := (SELECT Movement.Id
                                         FROM Movement
                                         WHERE Movement.DescId = zc_Movement_PromoTradeCondition()
                                           AND Movement.ParentId =  inMovementId
                                         );

    IF COALESCE (vbMovementId_PromoTradeCondition,0) = 0 
    THEN
        --создаем документ
        SELECT lpInsertUpdate_Movement (0, zc_Movement_PromoTradeCondition(), Movement.InvNumber, Movement.OperDate, Movement.Id, 0) 
      INTO vbMovementId_PromoTradeCondition
        FROM Movement
        WHERE Movement.Id = inMovementId;
    END IF;
    

    IF inOrd = 4
    THEN 
        --замена
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --RetroBonus
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_RetroBonus(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;

    IF inOrd = 5
    THEN 
        --замена
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --Market
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Market(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;
    
    IF inOrd = 6
    THEN 
        --замена
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --ReturnIn
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ReturnIn(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;
    
    IF inOrd = 7
    THEN 
        --замена
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Logist(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;

    IF inOrd = 8
    THEN 
        --замена
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Report(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;   

    IF inOrd = 9
    THEN 
        --замена
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MarketSumm(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.24         *
*/
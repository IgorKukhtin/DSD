-- Function: gpInsertUpdate_Movement_PromoTradeSign()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTradeSign (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoTradeSign(
    IN inMovementId            Integer    , -- Ключ объекта <Документ Трейд маркетинг>
    IN inOrd                   Integer    , -- Номер строки, по ней определим какое значение 
    IN inValueId               Integer    , --
    IN inValue                 TVarChar   , -- значение 
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementId_PromoTradeSign Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());


    vbMovementId_PromoTradeSign := (SELECT Movement.Id
                                    FROM Movement
                                    WHERE Movement.DescId = zc_Movement_PromoTradeSign()
                                      AND Movement.ParentId =  inMovementId
                                    );
    -- проверка на существование док. согласования
    IF COALESCE (vbMovementId_PromoTradeSign,0) = 0
    THEN
        --создаем документ
        SELECT lpInsertUpdate_Movement (0, zc_Movement_PromoTradeSign(), Movement.InvNumber, Movement.OperDate, Movement.Id, 0) 
      INTO vbMovementId_PromoTradeSign
        FROM Movement
        WHERE Movement.Id = inMovementId;
    END IF;
    

    IF inOrd = 1
    THEN 
        RAISE EXCEPTION 'Ошибка.Нет прав менять Автора документа';
    END IF;


    IF inOrd = 2
    THEN 
        --
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member_1(), vbMovementId_PromoTradeSign, inValueId);
    END IF;
    IF inOrd = 3
    THEN 
        --
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member_2(), vbMovementId_PromoTradeSign, inValueId);
    END IF;
    IF inOrd = 4
    THEN 
        --
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member_3(), vbMovementId_PromoTradeSign, inValueId);
    END IF;
    IF inOrd = 5
    THEN 
        --
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member_4(), vbMovementId_PromoTradeSign, inValueId);
    END IF;
    IF inOrd = 6
    THEN 
        --
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member_5(), vbMovementId_PromoTradeSign, inValueId);
    END IF;
    IF inOrd = 7
    THEN 
        --
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member_6(), vbMovementId_PromoTradeSign, inValueId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.09.24         *
*/
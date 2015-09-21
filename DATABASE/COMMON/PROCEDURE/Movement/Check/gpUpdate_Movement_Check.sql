-- Function: gpUpdate_Movement_Check()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check(
    IN inId                  Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inPaidTypeId          Integer   , -- Тип оплаты (нал / карта)
    IN inCashRegisterId      Integer   , -- Кассовый аппарат
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
    vbUserId := inSession;
    IF NOT EXISTS(SELECT 1 
                  FROM 
                      Movement
                  WHERE
                      ID = inId
                      AND
                      DescId = zc_Movement_Check()
                      AND
                      StatusId = zc_Enum_Status_Uncomplete()
                 )
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен, либо не находится в состоянии "не проведен"!';
    END IF;
    -- сохранили связь с <Кассовый аппарат>
    IF inCashRegisterId <> 0 
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),inId,inCashRegisterId);
    END IF;
	-- сохранили связь с <Тип полаты>
    IF inPaidTypeId <> 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inId,inPaidTypeId);
    END IF;
	 
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_Movement_Check (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 14.09.15                                                                         * 
*/

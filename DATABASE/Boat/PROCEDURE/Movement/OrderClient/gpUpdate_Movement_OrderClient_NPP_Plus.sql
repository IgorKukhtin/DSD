-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_NPP_Plus (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_NPP_Plus(
    IN inId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioNPP                 TFloat    , -- Очередность сборки
    IN inisPlus              Boolean   , -- Увеличиваем или уменьшаем значение NPP
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
    vbUserId := lpGetUserBySession (inSession);

    IF inisPlus = TRUE
    THEN ioNPP:= ioNPP + 1;
    ELSE 
        IF ioNPP > 1 THEN ioNPP:= ioNPP - 1; END IF; --если № = 1 меньше уже некуда
    END IF;
    
     -- сохранили значение <NPP>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), inId, ioNPP);

    --проверка / замена
    /*если при вводе такой номер встречается тогда в остальных документах он сдвигается на +1, т.е. были документы 1,2,3;4,5 .... добавили новый док и поставили там №-3, тогда 3,4,5 превращаются в 4,5,6*/
     
     IF EXISTS (SELECT 1
                FROM MovementFloat
                WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                  AND COALESCE (MovementFloat.ValueData,0) = ioNPP
                  AND MovementFloat.MovementId <> inId)
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), MovementFloat.MovementId, COALESCE (MovementFloat.ValueData,0) + 1 )
         FROM MovementFloat
             INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                AND Movement.DescId = zc_Movement_OrderClient()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
           AND COALESCE (MovementFloat.ValueData,0) >= ioNPP
           AND MovementFloat.MovementId <> inId;
     END IF; 
 
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.23         *
*/

-- тест
--
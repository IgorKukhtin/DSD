-- Function: gpUpdateMovement_OrderFinance_SignSB()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_SignSB (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_SignSB(
    IN inMovementId      Integer   , -- Ключ объекта <Документ>
    IN inisSignSB        Boolean   ,
   OUT outisSignSB       Boolean   ,
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession);
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_OrderFinance_SignSB());

     IF NOT EXISTS (SELECT 1
                    FROM Movement
                        -- временно - Відділ забезбечення - 1
                        INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                      ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                     AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                        INNER JOIN ObjectBoolean  AS ObjectBoolean_SB 
                                                  ON ObjectBoolean_SB.ObjectId = MovementLinkObject_OrderFinance.ObjectId 
                                                 AND ObjectBoolean_SB.DescId = zc_ObjectBoolean_OrderFinance_SB()
                                                 AND COALESCE (ObjectBoolean_SB.ValueData, FALSE) = TRUE     --только те виды планировани, что нужно согласовывать СБ
    
                    WHERE Movement.DescId = zc_Movement_OrderFinance()
                      AND Movement.Id = inMovementId
                    )
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не требует <Виза СБ>.';
     END IF;
                

     -- сохранили свойство  <Виза СБ>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SignSB(), inMovementId, inisSignSB);

     IF COALESCE (inisSignSB, FALSE) = TRUE
     THEN
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), inMovementId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), inMovementId, NULL ::TDateTime);
     END IF; 
     
     outisSignSB := inisSignSB;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.26         *
*/

-- тест
--
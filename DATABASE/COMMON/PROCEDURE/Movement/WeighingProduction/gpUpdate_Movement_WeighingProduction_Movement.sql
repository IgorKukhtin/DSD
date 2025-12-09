-- Function: gpUpdate_Movement_WeighingProduction_Movement()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingProduction_Movement (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingProduction_Movement(
    IN inId             Integer   , -- Ключ объекта <Документ>
    IN inNumSecurity    Integer   , -- 
    IN inIsSecurity     Boolean   , -- 
    IN inSession        TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
           vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingProduction_Param()); 
     vbUserId:= lpGetUserBySession (inSession);

     --проверка на правильное внесение знака, если нужно подмена
     IF inIsSecurity = TRUE
     THEN 
         --для охраны должно быть значение меньше 0
         inNumSecurity := CASE WHEN inNumSecurity < 0 THEN inNumSecurity ELSE -1 * inNumSecurity END;
     ELSE
         --для склада должно быть значение больше 0
         inNumSecurity := CASE WHEN inNumSecurity >= 0 THEN inNumSecurity ELSE -1 * inNumSecurity END;
     END IF;
     
     --находим документ за этот же день по № охранника, если не нашли - выдали ошибку, 
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementFloat AS MovementFloat_NumSecurity
                                                    ON MovementFloat_NumSecurity.MovementId = Movement.Id
                                                   AND MovementFloat_NumSecurity.DescId = zc_MovementFloat_NumSecurity()
                                                   AND MovementFloat_NumSecurity.ValueData = inNumSecurity
                      WHERE Movement.OperDate = (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inId)
                        AND Movement.DescId = zc_Movement_WeighingProduction()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                        AND Movement.Id <> inId
                      LIMIT 1
                      );             
     -- если не нашли - выдали ошибку
     IF COALESCE (vbMovementId,0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.Не найден документ для Охранника № <%>.', inNumSecurity;
     END IF;
     
     -- все строки текущего документа  заменяем на другой 
     UPDATE MovementItem 
     SET MovementId = vbMovementId
     WHERE MovementItem.MovementId = inId;


     -- сохранили протокол
     --PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, False);


     if vbUserId = 9457 
     then
         RAISE EXCEPTION 'Test. Ok <%>, Id <%>', inNumSecurity, vbMovementId;
     end if;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.25         *
*/

-- тест
-- 
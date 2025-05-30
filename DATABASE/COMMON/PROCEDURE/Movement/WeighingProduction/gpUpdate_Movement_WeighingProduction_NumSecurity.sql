-- Function: gpUpdate_Movement_WeighingProduction_NumSecurity()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingProduction_NumSecurity (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingProduction_NumSecurity(
    IN inId             Integer   , -- Ключ объекта <Документ>
    IN inNumSecurity    Integer   , -- 
    IN inIsSecurity     Boolean   , -- 
    IN inSession        TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
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
     
     
     -- сохранили связь с <№ охранника>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NumSecurity(), inId, inNumSecurity);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);


     if vbUserId = 9457 
     then
         RAISE EXCEPTION 'Test. Ok <%>', inNumSecurity;
     end if;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.25         *
*/

-- тест
-- 
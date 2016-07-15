-- Function: gpUpdate_Movement_IncomeFuel_ChangePrice()

DROP FUNCTION IF EXISTS gpUpdate_Movement_IncomeFuel_ChangePrice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_IncomeFuel_ChangePrice(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inContractId          Integer   , -- Договора
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbChangePrice TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());

     vbStatusId := (SELECT  Movement.StatusId FROM Movement Where Movement.Id = inId);
     vbChangePrice := (SELECT Object_Contract_View.ChangePrice FROM Object_Contract_View WHERE Object_Contract_View.ContractId = inContractId);



     -- сохранили свойство <скидка в цене>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePrice(), inId, vbChangePrice);
   
     IF vbStatusId = zc_Enum_Status_Complete() THEN
        --перепроводим док.
        PERFORM gpReComplete_Movement_Income (inMovementId := inId, inislastcomplete := 'True',  inSession := inSession);
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.07.16         *
 */

-- тест
-- select * from gpUpdate_Movement_IncomeFuel_ChangePrice(inId := 3946512 , inContractId := 416053 ,  inSession := '5');
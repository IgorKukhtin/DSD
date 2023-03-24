-- Function: gpUpdate_Movement_BankStatementItem_LinkJuridical()

-- DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem_LinkJuridical(Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem_LinkJuridical(Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankStatementItem_LinkJuridical(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId         Integer   , -- СПД 
    IN inServiceDate         TDateTime , --
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbLinkJuridicalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankStatementItem());
  
     IF inJuridicalId = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не выбрано значение для <От Кого, Кому (найдено)>.';
     END IF; 

     -- находим сохраненное значение
     vbLinkJuridicalId := (SELECT MovementLinkObject.ObjectId 
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId = inId
                             AND MovementLinkObject.DescId = zc_MovementLinkObject_Juridical()
                          );
     
     -- если значение уже заполнено выдаем ошибку
     IF vbLinkJuridicalId <> 0
        AND (SELECT Object.DescId FROM Object WHERE Object.Id = vbLinkJuridicalId) <> (SELECT Object.DescId FROM Object WHERE Object.Id = inJuridicalId)
     THEN
         RAISE EXCEPTION 'Ошибка.Значение для <От Кого, Кому (найдено)> уже заполнено - <%>.', lfGet_Object_ValueData_sh (vbLinkJuridicalId);
     END IF;
     

     -- сохранили связь с <Юр. лицо>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inId, inJuridicalId);
     
     --
     IF (SELECT Object.DescId FROM Object WHERE Object.Id = inJuridicalId) = zc_Object_PersonalServiceList()
     THEN
         -- сохранили связь с <Заработная плата>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), inId, zc_Enum_InfoMoney_60101());

         -- формируются свойство <Месяц начислений>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), inId, DATE_TRUNC ('MONTH', inServiceDate));

     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.03.23         *
*/

-- тест
--
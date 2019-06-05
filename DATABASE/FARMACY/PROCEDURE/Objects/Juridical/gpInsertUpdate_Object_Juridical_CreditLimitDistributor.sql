-- Function: gpInsertUpdate_Object_Juridical_CreditLimitDistributor()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical_CreditLimitDistributor (Integer, TFloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical_CreditLimitDistributor(
    IN inId                      Integer   ,   	-- ключ объекта <Подразделение>
    IN inCreditLimit             TFloat    ,    
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId:= inSession;

/*   IF 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND 8001630 <> inSession::Integer
   THEN
      RAISE EXCEPTION 'Изменение <Кредитных лимитов> вам запрещено.';
   END IF;
*/
   IF COALESCE (inId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка. Не выбрано юр.лицо';
   ELSE

       -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_CreditLimit(), inId, inCreditLimit);

     -- сохранили протокол
     --PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   END IF;
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.06.19                                                        *
 10.04.19                                                        *
*/

-- тест
--
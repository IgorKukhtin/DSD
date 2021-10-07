-- Function: gpUpdate_Object_Contract_StateKind_Closed()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract_StateKind_Closed (Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract_StateKind_Closed(
    IN inId                  Integer,       -- Ключ объекта <Договор>
    IN inContractStateKindId Integer  ,     -- Состояние договора
    IN inEndDate             TDateTime,     -- Дата до которой действует договор 
    IN inEndDate_Term        TDateTime,     -- Дата пролонгации
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDebts TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract_StateKind_Closed());

   -- если договор закрыт ничего не делаем
   IF inContractStateKindId = zc_Enum_ContractStateKind_Close()
   THEN 
       RETURN;
   END IF;
   
   -- проверка даты завершения
   IF COALESCE (inEndDate, zc_DateEnd()) > CURRENT_DATE
   THEN
       RAISE EXCEPTION 'Ошибка.В договоре <%> дата завершения <%> позже текущей даты.', lfGet_Object_ValueData (inId), inEndDate;
   END IF;

   -- проверка даты пролонгации
   IF COALESCE (inEndDate_Term, zc_DateStart()) > CURRENT_DATE
   THEN
       RAISE EXCEPTION 'Ошибка.В договоре <%> установлена дата пролонгации <%>.', lfGet_Object_ValueData (inId), inEndDate_Term;
   END IF; 

   --когда удаляют договор или ставят статус - закрыт, не должно быть  долгов (погрешнось в 1 грн, т.е. когда долг >1 или <-1)
   vbDebts := (SELECT * FROM gpGet_Object_Contract_debts (inId, inSession) AS tmp);
   IF COALESCE (vbDebts, 0) <> 0 
   THEN
       RAISE EXCEPTION 'Ошибка.По договору <%> есть долг в сумме <%>.', lfGet_Object_ValueData (inId), vbDebts;
   END IF;


   -- если даты меньше текущей можем закрывать
   -- сохранили связь с <Состояние договора>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractStateKind(), inId, zc_Enum_ContractStateKind_Close());   
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);
   
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.20         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Contract_StateKind_Closed ()

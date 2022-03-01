-- Function: gpInsertUpdate_Object_ExchangeRates()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ExchangeRates(Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ExchangeRates(
 INOUT ioId                 Integer   ,     -- ключ объекта <Покупатель> 
    IN inOperDate           TDateTime ,     -- Дата начала действия
    IN inExchange           TFloat    ,     -- Курс
    IN inSession            TVarChar        -- Формировать заявку на изменения срока
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ExchangeRates());

   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
   THEN
     RAISE EXCEPTION 'Разрешено только системному администратору';
   END IF;
   
   IF EXISTS(SELECT Object_ExchangeRates.Id                             AS Id 
             FROM Object AS Object_ExchangeRates

                  LEFT JOIN ObjectDate AS ObjectDate_ExchangeRates_OperDate
                                       ON ObjectDate_ExchangeRates_OperDate.ObjectId = Object_ExchangeRates.Id
                                      AND ObjectDate_ExchangeRates_OperDate.DescId = zc_ObjectDate_ExchangeRates_OperDate()


             WHERE Object_ExchangeRates.DescId = zc_Object_ExchangeRates()
               AND Object_ExchangeRates.Id <> COALESCE(ioId, 0)
               AND ObjectDate_ExchangeRates_OperDate.ValueData = inOperDate)
   THEN
     RAISE EXCEPTION 'На дату <%> курс уже установлен.', zfConvert_DateShortToString(inOperDate);
   END IF;
   
   -- пытаемся найти код
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_ExchangeRates());
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ExchangeRates(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ExchangeRates(), vbCode_calc, '');

   -- сохранили Дата начала действия
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ExchangeRates_OperDate(), ioId, inOperDate);
   -- сохранили Курс
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ExchangeRates_Exchange(), ioId, inExchange);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.02.22                                                       *
*/

-- тест
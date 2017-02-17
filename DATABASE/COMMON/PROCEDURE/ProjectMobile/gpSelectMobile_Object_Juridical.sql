-- Function: gpSelectMobile_Object_Juridical (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Juridical (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Juridical (
  IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
  IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- Код
             , ValueData  TVarChar -- Название
             , DebtSum    TFloat   -- Сумма долга (нам) - БН - т.к. БН долг формируется только в разрезе Юр Лиц + договоров
             , OverSum    TFloat   -- Сумма просроченного долга (нам) - БН - Просрочка наступает спустя определенное кол-во дней
             , OverDays   Integer  -- Кол-во дней просрочки (нам)
             , ContractId Integer  -- Структура_Таблиц_Мобильное_приложение_Справочники#Object_Contract|Договор]] - все возможные договора...
             , isErased   Boolean  -- Удаленный ли элемент
             , isSync     Boolean  -- Синхронизируется (да/нет)
)
AS $BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
  vbUserId:= lpGetUserBySession (inSession);

  -- Результат
  RETURN;
  -- RETURN QUERY

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Juridical(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())

-- Function: gpSelect_Movement_OrderInternal() - проц которая вернет все заказы, по которым есть подтверждение, но нет признака "отправлено смс"

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_SMS_Site (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_SMS_Site(
    IN inUnitId_list      TVarChar ,  -- Список Подразделений, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer -- ключ документа
             , InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat  -- Итого кол-во
             , TotalSumm TFloat   -- Итого Сумма
             , TotalSummChangePercent TFloat
             , UnitId Integer    -- ключ аптеки
             , UnitName TVarChar -- название аптеки
             , IsDeferred Boolean
             , CashMember TVarChar -- ФИО менеджера
             , Bayer TVarChar      -- ФИО Покупателя
             , BayerPhone TVarChar -- Тел Покупателя
             , InvNumberOrder TVarChar  -- № заказа на сайте
             , ConfirmedKindName TVarChar
             , ConfirmedKindClientName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIndex Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- таблица
     CREATE TEMP TABLE _tmpUnitSMS_List (UnitId Integer) ON COMMIT DROP;

     -- парсим подразделения
     vbIndex := 1;
     WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
         -- добавляем то что нашли
         INSERT INTO _tmpUnitSMS_List (UnitId) SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer;
         -- теперь следуюющий
         vbIndex := vbIndex + 1;
     END LOOP;

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         )

         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.StatusName
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.TotalSummChangePercent
           , Movement_Check.UnitId
           , Movement_Check.UnitName
           , Movement_Check.IsDeferred
           , CASE WHEN Movement_Check.InvNumberOrder <> '' AND COALESCE (Movement_Check.CashMember, '') = '' THEN zc_Member_Site() ELSE Movement_Check.CashMember END :: TVarChar AS CashMember
           , Movement_Check.Bayer
           , Movement_Check.BayerPhone
           , Movement_Check.InvNumberOrder
           , Movement_Check.ConfirmedKindName
           , Movement_Check.ConfirmedKindClientName
        FROM Movement_Check_View AS Movement_Check
             JOIN tmpStatus ON tmpStatus.StatusId = Movement_Check.StatusId
             LEFT JOIN _tmpUnitSMS_List ON _tmpUnitSMS_List.UnitId = Movement_Check.UnitId
                           
       WHERE Movement_Check.ConfirmedKindId        = zc_Enum_ConfirmedKind_Complete()
         AND Movement_Check.ConfirmedKindId_Client = zc_Enum_ConfirmedKind_SmsNo()
         AND (_tmpUnitSMS_List.UnitId > 0 OR vbIndex = 1)
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 25.08.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Check_SMS_Site (inUnitId_list:= '', inSession:= '2')

-- Function: gpComplete_Movement_byReport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_byReport (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_byReport (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_byReport(
    IN inMovementId   Integer    , -- ключ объекта <Документ>
    IN inReportKind   Integer    , -- 1 - Отчет <по продажам / возвратам> ИЛИ 2 - Отчет <по расчетам>
   OUT outStatusCode  Integer    , --
    IN inSession      TVarChar     -- текущий пользователь
)
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbDescId   Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- определяем параметры Документа
     SELECT Movement.DescId, Movement.OperDate INTO vbDescId, vbOperDate FROM Movement WHERE Movement.Id = inMovementId;


     -- Вот они Роли + Пользователи: с проверкой прав = НЕЛЬЗЯ
     IF EXISTS (SELECT 1
                FROM Object_RoleAccessKey_View
                WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                  AND Object_RoleAccessKey_View.UserId      = vbUserId
               )
     THEN
         IF vbDescId = zc_Movement_Sale()
         THEN
             -- проверка прав пользователя на вызов процедуры - Ругнемся, т.к. права "забрали"
             vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());

         ELSEIF vbDescId = zc_Movement_ReturnIn()
         THEN
             -- проверка прав пользователя на вызов процедуры - Ругнемся, т.к. права "забрали"
             vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());

         ELSEIF vbDescId = zc_Movement_GoodsAccount()
         THEN
             -- проверка прав пользователя на вызов процедуры - Ругнемся, т.к. права "забрали"
             vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_GoodsAccount());

         ELSE
             RAISE EXCEPTION 'Ошибка.Проведение.';

         END IF;

     END IF;


     -- Проверка - Вид Документа
     IF inReportKind = 1 AND vbDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
     THEN
         RAISE EXCEPTION 'Ошибка. Проведение возможно только в Отчете <по расчетам>';

     ELSEIF inReportKind = 2 AND vbDescId NOT IN (zc_Movement_GoodsAccount())
     THEN
         RAISE EXCEPTION 'Ошибка. Проведение возможно только в Отчете <по продажам / возвратам>';

     END IF;


     -- Проверка - Дата Документа
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= vbOperDate, inUserId:= vbUserId);


     -- сохранили свойство <Дата Корректировки> - по Дате Проведения
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
     -- сохранили свойство <Пользователь (Корректировка)> - по Пользователю Проведения
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, vbUserId);


     -- 1.Провели
     IF vbDescId = zc_Movement_Sale()
     THEN
         -- создаются временные таблицы - для формирование данных по проводкам
         PERFORM lpComplete_Movement_Sale_CreateTemp();
         -- собственно проводки
         PERFORM lpComplete_Movement_Sale (inMovementId  -- Документ
                                         , vbUserId);    -- Пользователь
     END IF;

     -- 2.Провели
     IF vbDescId = zc_Movement_ReturnIn()
     THEN
         -- создаются временные таблицы - для формирование данных по проводкам
         PERFORM lpComplete_Movement_ReturnIn_CreateTemp();
         -- собственно проводки
         PERFORM lpComplete_Movement_ReturnIn (inMovementId  -- Документ
                                             , vbUserId);    -- Пользователь
     END IF;

     -- 3.Провели
     IF vbDescId = zc_Movement_GoodsAccount()
     THEN
         -- создаются временные таблицы - для формирование данных по проводкам
         PERFORM lpComplete_Movement_GoodsAccount_CreateTemp();
         -- собственно проводки
         PERFORM lpComplete_Movement_GoodsAccount (inMovementId  -- Документ
                                                 , vbUserId);    -- Пользователь
     END IF;


     -- вернули
     outStatusCode := (SELECT Object_Status.ObjectCode  AS StatusCode
                       FROM Movement
                            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                       WHERE Movement.Id = inMovementId
                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.02.18         * _User
 19.01.18         *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_byReport (inMovementId:= 0, inSession:= '2')

-- Function: gpSelectMobile_Movement_Task()

DROP FUNCTION IF EXISTS gpSelectMobile_Movement_Task (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Movement_Task(
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer   -- Уникальный идентификатор, формируется в Главной БД, и используется при синхронизации
             , InvNumber  TVarChar  -- Номер документа
             , OperDate   TDateTime -- Дата документа
             , StatusId   Integer   -- Виды статусов
             , PersonalId Integer   -- Сотрудники (торговый агент)
             , isSync     Boolean   
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT tmpConst.PersonalId FROM gpGetMobile_Object_Const (inSession) AS tmpConst);

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             SELECT Movement_Task.Id
                  , Movement_Task.InvNumber
                  , Movement_Task.Operdate
                  , Movement_Task.StatusId
                  , MovementLinkObject_PersonalTrade.ObjectId AS PersonalId
                  , true::Boolean                             AS isSync  
             FROM Movement AS Movement_Task
                  JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement_Task.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
                                         AND MovementLinkObject_PersonalTrade.ObjectId = vbPersonalId
             WHERE Movement_Task.DescId = zc_Movement_Task()
               AND Movement_Task.StatusId = zc_Enum_Status_UnComplete();
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Ярошенко Р.Ф.
 30.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_Movement_Task (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())

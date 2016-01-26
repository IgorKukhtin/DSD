-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeGroup(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeGroup(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTimeGroup(
    IN inMemberId            Integer   , -- Ключ физ. лицо
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inOldMemberId         Integer   , -- Ключ физ. лицо
    IN inOldPositionId       Integer   , -- Должность
    IN inOldPositionLevelId  Integer   , -- Разряд
    IN inOldPersonalGroupId  Integer   , -- Группировка Сотрудника
    IN inOperDate            TDateTime , -- дата установки часов
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemCount Integer;
   DECLARE vbTypeId Integer;
   DECLARE vbValue TVarChar;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    
    vbUserId := inSession;

    vbTypeId := zc_Enum_WorkTimeKind_Work();

    -- Первая задача. Это просто добавление нового документа

    -- Вторая - Изменение внесенных документов. 
    IF inOldMemberId = 0 THEN
       PERFORM gpInsertUpdate_MovementItem_SheetWorkTime(inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inOperDate, '0', vbTypeId, inSession);
    ELSE
       vbStartDate := date_trunc('month', inOperDate)                            ;    -- первое число месяца
       vbEndDate := vbStartDate + interval '1 month' - interval '1 microseconds' ;    -- последнее число месяца
       -- Сначала проверяем что нет с такими ключами
       SELECT count(*) INTO vbMovementItemCount
        FROM MovementItem AS MI_SheetWorkTime
        JOIN Movement AS Movement_SheetWorkTime
          ON Movement_SheetWorkTime.Id = MI_SheetWorkTime.MovementId 
         AND Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() 
         AND Movement_SheetWorkTime.OperDate::Date BETWEEN vbStartDate AND vbEndDate
        JOIN MovementLinkObject AS MovementLinkObject_Unit 
          ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
         AND MovementLinkObject_Unit.ObjectId = inUnitId 
        JOIN MovementItemLinkObject AS MIObject_Position
          ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
         AND ((MIObject_Position.ObjectId IS NULL) OR (MIObject_Position.ObjectId = inPositionId))
         AND MIObject_Position.DescId = zc_MILinkObject_Position() 
        JOIN MovementItemLinkObject AS MIObject_PositionLevel
          ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
         AND ((MIObject_PositionLevel.ObjectId IS NULL) OR (MIObject_PositionLevel.ObjectId = inPositionLevelId))
         AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
        JOIN MovementItemLinkObject AS MIObject_PersonalGroup
          ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
         AND ((MIObject_PersonalGroup.ObjectId IS NULL) OR (MIObject_PersonalGroup.ObjectId = inPersonalGroupId))
         AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
       WHERE MI_SheetWorkTime.ObjectId = inMemberId;
       
       IF COALESCE(vbMovementItemCount, 0) <> 0 THEN
          RAISE EXCEPTION 'Сотрудник с такими свойствами уже есть в табеле!';
       END IF;

       CREATE TEMP TABLE _tmpMI (Id Integer) ON COMMIT DROP;

       -- Находим за месяц есть ли документы со старыми ключами во временную таблицу.
       INSERT INTO _tmpMI(Id)
       SELECT MI_SheetWorkTime.Id 
        FROM MovementItem AS MI_SheetWorkTime
        JOIN Movement AS Movement_SheetWorkTime
          ON Movement_SheetWorkTime.Id = MI_SheetWorkTime.MovementId 
         AND Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() 
         AND Movement_SheetWorkTime.OperDate::Date BETWEEN vbStartDate AND vbEndDate
        JOIN MovementLinkObject AS MovementLinkObject_Unit 
          ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
         AND MovementLinkObject_Unit.ObjectId = inUnitId 
        JOIN MovementItemLinkObject AS MIObject_Position
          ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
         AND ((MIObject_Position.ObjectId IS NULL) OR (MIObject_Position.ObjectId = inOldPositionId))
         AND MIObject_Position.DescId = zc_MILinkObject_Position() 
        JOIN MovementItemLinkObject AS MIObject_PositionLevel
          ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
         AND ((MIObject_PositionLevel.ObjectId IS NULL) OR (MIObject_PositionLevel.ObjectId = inOldPositionLevelId))
         AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
        JOIN MovementItemLinkObject AS MIObject_PersonalGroup
          ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
         AND ((MIObject_PersonalGroup.ObjectId IS NULL) OR (MIObject_PersonalGroup.ObjectId = inOldPersonalGroupId))
         AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
       WHERE MI_SheetWorkTime.ObjectId = inOldMemberId;
       -- а теперь меняем ключи
       -- Сначала Физ Лицо. А потом все остальные
       UPDATE MovementItem SET ObjectId = inMemberId WHERE Id IN (SELECT Id FROM _tmpMI);
       PERFORM 
           -- сохранили связь с <Группировки Сотрудников>
           lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalGroup(), Id, inPersonalGroupId),
           -- сохранили связь с <Должностью>
           lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), Id, inPositionId),
           -- сохранили связь с <Разряд>
           lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), Id, inPositionLevelId)
        FROM _tmpMI;     
     END IF;                   

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.01.14                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTime (, inSession:= '2')

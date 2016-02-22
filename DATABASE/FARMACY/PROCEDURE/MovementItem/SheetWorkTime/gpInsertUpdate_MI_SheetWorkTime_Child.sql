-- Function: gpInsertUpdate_MI_SheetWorkTime_Child()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_Child(Integer, Integer, Integer, Integer, TDateTime, Time, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_Child(Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SheetWorkTime_Child(
    IN inPersonalId          Integer   , -- Ключ сотрудник
    IN inPositionId          Integer   , -- Должность
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inOperDate            TDateTime , -- дата
 INOUT ioValue               TDateTime , -- время начала работы
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TDateTime
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId_Master Integer;
   DECLARE vbMovementItemId_Child Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbValue TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    vbValue:= ( '' ||inOperDate::Date || ' '||ioValue ::Time):: TDateTime ;
--RAISE EXCEPTION ' <%>', ioValue;
    ioValue:= vbValue ::TDateTime ;
    

    -- Для начала определим ID Movement, если таковой имеется. Ключом будет OperDate и UnitId
    vbMovementId := (SELECT Movement_SheetWorkTime.Id
                     FROM Movement AS Movement_SheetWorkTime
                          JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                                  ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                                 AND MovementLinkObject_Unit.ObjectId = inUnitId
                     WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() AND Movement_SheetWorkTime.OperDate = inOperDate
                    );
 
    -- сохранили <Документ>
    IF COALESCE (vbMovementId, 0) = 0
    THEN
        vbMovementId := lpInsertUpdate_Movement_SheetWorkTime(vbMovementId, '', inOperDate::DATE, inUnitId);
    END IF;

    -- Поиск MovementItemId_Master
    vbMovementItemId_Master := (SELECT MI_SheetWorkTime.Id 
                         FROM MovementItem AS MI_SheetWorkTime
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND COALESCE (MIObject_Position.ObjectId, 0) = COALESCE (inPositionId, 0)
                                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                             
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                          WHERE MI_SheetWorkTime.DescId = zc_MI_Master()
                            AND MI_SheetWorkTime.MovementId = vbMovementId 
                            AND MI_SheetWorkTime.ObjectId = inPersonalId);


    -- сохранили <родителя >
    IF COALESCE (vbMovementItemId_Master, 0) = 0
    THEN
    -- сохранили <Элемент документа>
     vbMovementItemId_Master := lpInsertUpdate_MovementItem (0, zc_MI_Master(), inPersonalId, vbMovementId, 0, NULL);
     
     -- сохранили связь с <Группировки Сотрудников>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalGroup(), vbMovementItemId_Master, inPersonalGroupId);
     -- сохранили связь с <Должностью>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), vbMovementItemId_Master, inPositionId);

    END IF;

    -- Поиск MovementItemId_Child
    vbMovementItemId_Child := (SELECT MI_CHILD.Id 
                               FROM MovementItem AS MI_MASTER
                                  LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                         ON MIObject_Position.MovementItemId = MI_MASTER.Id 
                                                                        AND COALESCE (MIObject_Position.ObjectId, 0) = COALESCE (inPositionId, 0)
                                                                        AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                             
                                  LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_MASTER.Id 
                                                                    AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                                  INNER JOIN MovementItem AS MI_CHILD
                                                          ON MI_CHILD.DescId = zc_MI_Child()
                                                         AND MI_CHILD.ParentId = vbMovementItemId_Master
                               WHERE MI_MASTER.DescId = zc_MI_Master()
                                 AND MI_MASTER.MovementId = vbMovementId 
                                 AND MI_MASTER.ObjectId = inPersonalId);   



    -- сохранили
    PERFORM lpInsertUpdate_MI_SheetWorkTime_Child     (inId                  := vbMovementItemId_Child  -- Ключ объекта <Элемент документа>
                                                     , inMovementId          := vbMovementId      -- ключ Документа
                                                     , inParentId            := vbMovementItemId_Master -- 
                                                     , inValue               := vbValue           -- время начала работы
                                                     , inUserId              := vbUserId
                                                     );                

    


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.16         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_SheetWorkTime_Child (, inSession:= '2')

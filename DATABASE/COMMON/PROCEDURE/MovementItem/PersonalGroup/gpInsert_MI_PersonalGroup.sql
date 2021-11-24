-- Function: gpInsert_MI_PersonalGroup()

DROP FUNCTION IF EXISTS gpInsert_MI_PersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_PersonalGroup(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbPersonalGroupId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroup());

     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.isErased = False AND MI.MovementId = inMovementId)
     THEN
          RAISE EXCEPTION 'Ошибка.Строчная часть документа уже заполнена';   --, lfGet_Object_ValueData ();
     END IF;

     --данные из шапки документа
     SELECT MovementLinkObject_Unit.ObjectId          AS UnitId
          , MovementLinkObject_PersonalGroup.ObjectId AS PersonalGroupId
          , Movement.OperDate                         AS OperDate
    INTO vbUnitId, vbPersonalGroupId, vbOperDate
     FROM MovementLinkObject AS MovementLinkObject_Unit
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                       ON MovementLinkObject_PersonalGroup.MovementId = MovementLinkObject_Unit.MovementId
                                      AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
          LEFT JOIN Movement ON Movement.Id = inMovementId
     WHERE MovementLinkObject_Unit.MovementId = inMovementId
       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

   
     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_PersonalGroup (ioId              := 0
                                                      , inMovementId      := inMovementId
                                                      , inPersonalId      := tmp.PersonalId
                                                      , inPositionId      := tmp.PositionId
                                                      , inPositionLevelId := tmp.PositionLevelId
                                                      , inAmount          := tmp.HoursDay
                                                      , inUserId          := vbUserId
                                                      ) 
     FROM (WITH tmpPersonal AS (SELECT lfSelect.MemberId
                                     , lfSelect.PersonalId
                                     , lfSelect.PositionId
                                     , ObjectLink_Personal_PositionLevel.ChildObjectId AS PositionLevelId
                                FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                     INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                           ON ObjectLink_Personal_PersonalGroup.ObjectId = lfSelect.PersonalId
                                                          AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                                          AND ObjectLink_Personal_PersonalGroup.ChildObjectId = vbPersonalGroupId
     
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                          ON ObjectLink_Personal_PositionLevel.ObjectId = lfSelect.PersonalId
                                                         AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                                WHERE lfSelect.UnitId = vbUnitId
                                 AND (lfSelect.DateOut >= vbOperDate AND lfSelect.DateIn <= vbOperDate)
                               )
              --штатное расписание №2Дневной план на человека 
              , tmpStaffList AS (SELECT ObjectLink_StaffList_Unit.ChildObjectId           AS UnitId
                                      , ObjectLink_StaffList_Position.ChildObjectId       AS PositionId
                                      , ObjectLink_StaffList_PositionLevel.ChildObjectId  AS PositionLevelId
                                      , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay
                                 FROM Object AS Object_StaffList
                                       INNER JOIN ObjectLink AS ObjectLink_StaffList_Position
                                                             ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                                            AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
                                       LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                                            ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                                                           AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
            
                                       LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                                            ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                                           AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit() 
                                       LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                                             ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                                                            AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
                                   WHERE Object_StaffList.DescId = zc_Object_StaffList()
                                    AND Object_StaffList.isErased = False
                                  GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
                                         , ObjectLink_StaffList_Position.ChildObjectId
                                         , ObjectLink_StaffList_PositionLevel.ChildObjectId
                       HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
                       )
            -- сотрудников получаем данніе из штатного
            SELECT tmpPersonal.PersonalId
                 , tmpPersonal.PositionId
                 , tmpPersonal.PositionLevelId
                 , COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) AS HoursDay
            FROM tmpPersonal    
                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmpPersonal.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmpPersonal.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = vbUnitId
                 --второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmpPersonal.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmpPersonal.PositionLevelId,0)
                                       AND tmpStaffList.PositionId  IS  NULL
            ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.21         *
*/

-- тест
--
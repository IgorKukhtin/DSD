-- Function: gpUpdate_MI_SheetWorkTime_byHospitalDoc()

DROP FUNCTION IF EXISTS gpUpdate_MI_SheetWorkTime_byHospitalDoc(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_SheetWorkTime_byHospitalDoc(
    IN inMovementId_hd     Integer   , -- ID Movement_MemberHoliday
    IN inSession           TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDAte   TDateTime;
   DECLARE vbPersonalId   Integer;
   DECLARE vbWorkTimeKindId Integer;
   DECLARE vbError TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    IF zfConvert_StringToNumber (inSession) < 0
    THEN vbUserId := lpGetUserBySession ((ABS (inSession :: Integer)) :: TVarChar);
    ELSE vbUserId := lpGetUserBySession (inSession);
    END IF;


     -- даты нач и окончания больничного
     vbStartDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId_hd AND MovementDate.DescId = zc_MovementDate_StartStop());
     vbEndDAte  := (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId_hd AND MovementDate.DescId = zc_MovementDate_EndStop());
     vbPersonalId     := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId_hd AND MovementLinkObject.DescId = zc_MovementLinkObject_Personal());
     vbWorkTimeKindId := (zc_Enum_WorkTimeKind_HospitalDoc());


     -- Проверка что незаполнен табель на дни больничного
     vbError := (WITH
                 tmpPersonal AS (SELECT lfSelect.MemberId
                                      , lfSelect.PersonalId
                                      , lfSelect.UnitId
                                      , lfSelect.PositionId
                                      , lfSelect.PositionLevelId
                                      , lfSelect.BranchId
                                 FROM lfSelect_Object_Member_findPersonal (CASE WHEN zfConvert_StringToNumber ('9457') < 0 THEN (ABS (9457 :: Integer)) :: TVarChar ELSE '9457' END) AS lfSelect
                                 WHERE lfSelect.MemberId = 13058 AND lfSelect.Ord = 1
                                 )
                         
               , tmpOperDate AS (SELECT GENERATE_SERIES ('01.07.2025'::TDateTime, '07.07.2025'::TDateTime, '1 DAY' :: INTERVAL) AS OperDate)

               SELECT STRING_AGG (zfConvert_DateShortToString (tmpOperDate.OperDate )::TVarchar ||' внесено '||zfCalc_ViewWorkHour (MI_SheetWorkTime.Amount, ObjectString_WorkTimeKind_ShortName.ValueData::TVarChar) , '; ') ::TVarChar AS Text
               FROM tmpOperDate
                    LEFT JOIN tmpPersonal ON 1 = 1
                    INNER JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                       AND Movement.DescId = zc_Movement_SheetWorkTime()
                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.ObjectId = tmpPersonal.UnitId
                    INNER JOIN MovementItem AS MI_SheetWorkTime 
                                            ON MI_SheetWorkTime.MovementId = Movement.Id
                                           AND MI_SheetWorkTime.isErased = FALSE
                                           AND MI_SheetWorkTime.ObjectId = tmpPersonal.MemberId
                    INNER JOIN MovementItemLinkObject AS MIObject_Position
                                                      ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                     AND MIObject_Position.DescId = zc_MILinkObject_Position()
                                                     AND MIObject_Position.ObjectId = tmpPersonal.PositionId
                    INNER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                                    AND COALESCE (MIObject_PositionLevel.ObjectId,0) = COALESCE (tmpPersonal.PositionLevelId,0)
                    LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                     ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                    AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                    LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = MIObject_WorkTimeKind.ObjectId
                    LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                           ON ObjectString_WorkTimeKind_ShortName.ObjectId = MIObject_WorkTimeKind.ObjectId --CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END
                                          AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
               WHERE MI_SheetWorkTime.Amount <> 0
                AND MIObject_WorkTimeKind.ObjectId <> zc_Enum_WorkTimeKind_HospitalDoc()
               GROUP BY tmpPersonal.MemberId
               );
      --если табель проставлен сохраняем ошибку в док. больн. лист
     IF COALESCE (vbError,'') = '' 
     THEN
          -- сохранили свойство <>
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_Error(), inMovementId_hd, vbError); 
          RETURN;
     ELSE
     -- иначе проставляем больничные в табеле
     -- автоматом проставляем в zc_Movement_SheetWorkTime сотруднику за период соответсвующий WorkTimeKind
     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime(inMemberId            := tmp.MemberId           :: Integer    -- Ключ физ. лицо
                                                     , inPositionId          := tmp.PositionId         :: Integer    -- Должность
                                                     , inPositionLevelId     := tmp.PositionLevelId    :: Integer    -- Разряд
                                                     , inUnitId              := tmp.UnitId             :: Integer    -- Подразделение
                                                     , inPersonalGroupId     := tmp.PersonalGroupId    :: Integer    -- Группировка Сотрудника
                                                     , inStorageLineId       := tmp.StorageLineId      :: Integer    -- линия произ-ва
                                                     , inOperDate            := tmp.OperDate           :: TDateTime  -- дата
                                                     , ioValue               := COALESCE (tmp.Value,NULL)  :: TVarChar   -- часы
                                                     , ioTypeId              := vbWorkTimeKindId       :: Integer    
                                                     , ioWorkTimeKindId_key  := NULL
                                                     , inIsPersonalGroup     := FALSE                  :: Boolean    -- используется при сохранении из списка бригад
                                                     , inSession             := inSession              :: TVarChar
                                                      )
     FROM (WITH
           tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId       
                                , lfSelect.PositionLevelId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (CASE WHEN zfConvert_StringToNumber (inSession) < 0 THEN (ABS (inSession :: Integer)) :: TVarChar ELSE inSession END) AS lfSelect
                           WHERE lfSelect.PersonalId = vbPersonalId AND lfSelect.Ord = 1
                           )
         , tmpOperDate AS (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate)
         
         SELECT tmpOperDate.OperDate
              , tmpPersonal.MemberId
              , tmpPersonal.PersonalId
              , tmpPersonal.PositionId
              , tmpPersonal.PositionLevelId
              , ObjectLink_Personal_PersonalGroup.ChildObjectId AS PersonalGroupId
              , ObjectLink_Personal_StorageLine.ChildObjectId   AS StorageLineId
              , tmpPersonal.UnitId
              , zfCalc_ViewWorkHour (0, ObjectString_ShortName.ValueData) ::TVarChar AS Value
         FROM tmpOperDate
             LEFT JOIN tmpPersonal ON 1=1
             LEFT JOIN ObjectString AS ObjectString_ShortName
                                    ON ObjectString_ShortName.ObjectId = vbWorkTimeKindId
                                   AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()

             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                  ON ObjectLink_Personal_PersonalGroup.ObjectId = tmpPersonal.PersonalId
                                 AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
       
             LEFT JOIN ObjectLink AS ObjectLink_Personal_StorageLine
                                  ON ObjectLink_Personal_StorageLine.ObjectId = tmpPersonal.PersonalId
                                 AND ObjectLink_Personal_StorageLine.DescId = zc_ObjectLink_Personal_StorageLine()
             LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = ObjectLink_Personal_StorageLine.ChildObjectId
     ) AS tmp;
     
     --проводим документ Больн. лист--
     PERFORM lpComplete_Movement (inMovementId := inMovementId_hd
                                , inDescId     := zc_Movement_HospitalDoc_1C()
                                , inUserId     := vbUserId
                                 );
     END IF;

    
    

    -- !!! ВРЕМЕННО !!!
    IF vbUserId = 5 OR vbUserId = 9457 THEN
        RAISE EXCEPTION 'Admin - Test = OK';
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.25         *
*/

-- тест
-- 
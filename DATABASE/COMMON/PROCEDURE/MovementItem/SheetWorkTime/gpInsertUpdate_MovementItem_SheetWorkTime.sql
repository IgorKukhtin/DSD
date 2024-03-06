-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(Integer, Integer, Integer, Integer, TDateTime, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTime(
    IN inMemberId            Integer   , -- Ключ физ. лицо
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inStorageLineId       Integer   , -- линия произ-ва
    IN inOperDate            TDateTime , -- дата
 INOUT ioValue               TVarChar  , -- часы
 INOUT ioTypeId              Integer   ,
 INOUT ioWorkTimeKindId_key  Integer   ,
   OUT OutAmountHours        TFloat    ,
    IN inIsPersonalGroup     Boolean   , -- вызов из док. список бригад
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbTypeId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbEndDate   TDateTime;

   DECLARE vbValue TFloat;
   DECLARE vbIsCheck Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());

    -- временно???
    IF inIsPersonalGroup = FALSE THEN inIsPersonalGroup:= inUnitId = 8451;
    END IF;


    IF zfConvert_StringToNumber (inSession) < 0
    THEN vbUserId := lpGetUserBySession ((ABS (inSession :: Integer)) :: TVarChar);
         vbIsCheck:= FALSE;
    ELSE vbUserId := lpGetUserBySession (inSession);
         vbIsCheck:= TRUE;
    END IF;


    -- последнее число месяца
    vbEndDate := DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

    -- Проверка - период закрыт
    IF  EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                             ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                            AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                                            AND MovementDate_OperDateEnd.ValueData >= inOperDate
                     LEFT JOIN MovementDate AS MovementDate_TimeClose
                                            ON MovementDate_TimeClose.MovementId = Movement.Id
                                           AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()
                     LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                               ON MovementBoolean_Closed.MovementId = Movement.Id
                                              AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()
                     LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAuto
                                               ON MovementBoolean_ClosedAuto.MovementId = Movement.Id
                                              AND MovementBoolean_ClosedAuto.DescId = zc_MovementBoolean_ClosedAuto()
                     LEFT JOIN MovementLinkObject AS MLO_Unit
                                                  ON MLO_Unit.MovementId = Movement.Id
                                                 AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                     LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAll
                                               ON MovementBoolean_ClosedAll.MovementId = Movement.Id
                                              AND MovementBoolean_ClosedAll.DescId     = zc_MovementBoolean_ClosedAll()
                                              
                WHERE Movement.DescId = zc_Movement_SheetWorkTimeClose()
                  AND Movement.OperDate <= inOperDate
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND (MovementBoolean_Closed.ValueData = TRUE
                    OR (MovementBoolean_ClosedAuto.ValueData = TRUE AND MovementDate_TimeClose.ValueData <= CURRENT_TIMESTAMP)
                      )
                  AND (COALESCE (MLO_Unit.ObjectId, 0)     <> COALESCE (inUnitId, 0)
                    OR MovementBoolean_ClosedAll.ValueData = TRUE
                      )
               )
   --OR vbUserId = 5
    AND vbUserId <> 5

    THEN
        RAISE EXCEPTION 'Ошибка.Период закрыт с <%>.'
                      , (SELECT CASE WHEN MovementBoolean_ClosedAuto.ValueData = TRUE
                                          THEN zfConvert_DateTimeShortToString (MovementDate_TimeClose.ValueData)
                                     ELSE zfConvert_DateToString (MovementDate_OperDateEnd.ValueData)
                                END
                         FROM Movement
                              INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                      ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                     AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                                                     AND MovementDate_OperDateEnd.ValueData >= inOperDate
                              LEFT JOIN MovementDate AS MovementDate_TimeClose
                                                     ON MovementDate_TimeClose.MovementId = Movement.Id
                                                    AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()
                              LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                                        ON MovementBoolean_Closed.MovementId = Movement.Id
                                                       AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()
                              LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAuto
                                                        ON MovementBoolean_ClosedAuto.MovementId = Movement.Id
                                                       AND MovementBoolean_ClosedAuto.DescId = zc_MovementBoolean_ClosedAuto()
                              LEFT JOIN MovementLinkObject AS MLO_Unit
                                                           ON MLO_Unit.MovementId = Movement.Id
                                                          AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                              LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAll
                                                        ON MovementBoolean_ClosedAll.MovementId = Movement.Id
                                                       AND MovementBoolean_ClosedAll.DescId     = zc_MovementBoolean_ClosedAll()

                         WHERE Movement.DescId = zc_Movement_SheetWorkTimeClose()
                           AND Movement.OperDate <= inOperDate
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND (MovementBoolean_Closed.ValueData = TRUE
                             OR (MovementBoolean_ClosedAuto.ValueData = TRUE AND MovementDate_TimeClose.ValueData <= CURRENT_TIMESTAMP)
                               )
                           AND (COALESCE (MLO_Unit.ObjectId, 0)     <> COALESCE (inUnitId, 0)
                             OR MovementBoolean_ClosedAll.ValueData = TRUE
                               )
                         LIMIT 1
                        )
                       ;
    END IF;

    -- Проверка
    IF NOT EXISTS (SELECT 1
                   FROM Object_Personal_View
                   WHERE Object_Personal_View.UnitId     = inUnitId
                     AND Object_Personal_View.MemberId   = inMemberId
                     AND Object_Personal_View.PositionId = inPositionId
                     AND Object_Personal_View.isErased   = FALSE
                  )
   --AND vbUserId <> 5
    THEN
        RAISE EXCEPTION 'Ошибка.В справочнике Сотрудников <%> <%>  <%> не найден.'
                      , lfGet_Object_ValueData_sh (inMemberId)
                      , lfGet_Object_ValueData_sh (inPositionId)
                      , lfGet_Object_ValueData_sh (inUnitId)
                        ;
    END IF;

    -- Проверка
    IF NOT EXISTS (SELECT 1
                   FROM Object_Personal_View
                   WHERE Object_Personal_View.DateIn     <= vbEndDate
                     AND Object_Personal_View.DateOut    >= vbEndDate
                     AND Object_Personal_View.UnitId     = inUnitId
                     AND Object_Personal_View.MemberId   = inMemberId
                     AND Object_Personal_View.PositionId = inPositionId
                  )
     --AND vbUserId <> 5
    THEN
        IF EXISTS (SELECT 1
                         FROM Object_Personal_View
                         WHERE Object_Personal_View.DateIn     > vbEndDate
                           AND Object_Personal_View.UnitId     = inUnitId
                           AND Object_Personal_View.MemberId   = inMemberId
                           AND Object_Personal_View.PositionId = inPositionId
                        )
        THEN
            RAISE EXCEPTION 'Ошибка. Сотрудник <%> <%>  <%> принят с <%>.Ввод в табеле возможен после этой даты.'
                          , lfGet_Object_ValueData_sh (inMemberId)
                          , lfGet_Object_ValueData_sh (inPositionId)
                          , lfGet_Object_ValueData_sh (inUnitId)
                          , (SELECT zfConvert_DateToString (MIN (Object_Personal_View.DateIn))
                             FROM Object_Personal_View
                             WHERE Object_Personal_View.DateIn     > vbEndDate
                               AND Object_Personal_View.UnitId     = inUnitId
                               AND Object_Personal_View.MemberId   = inMemberId
                               AND Object_Personal_View.PositionId = inPositionId
                            )
                           ;
        ELSE
            --дата увольнения   - рабочий день, иначе Ввод в табеле закрыт
            IF EXISTS (SELECT 1
                             FROM Object_Personal_View
                             WHERE Object_Personal_View.DateOut    < inOperDate
                               AND Object_Personal_View.UnitId     = inUnitId
                               AND Object_Personal_View.MemberId   = inMemberId
                               AND Object_Personal_View.PositionId = inPositionId
                            )
             --AND vbUserId <> 5
            THEN
                RAISE EXCEPTION 'Ошибка. Сотрудник <%> <%>  <%> уволен с <%>.Ввод в табеле закрыт.'
                              , lfGet_Object_ValueData_sh (inMemberId)
                              , lfGet_Object_ValueData_sh (inPositionId)
                              , lfGet_Object_ValueData_sh (inUnitId)
                              , (SELECT zfConvert_DateToString (MAX (Object_Personal_View.DateOut))
                                 FROM Object_Personal_View
                                 WHERE Object_Personal_View.DateOut    <= vbEndDate
                                   AND Object_Personal_View.UnitId     = inUnitId
                                   AND Object_Personal_View.MemberId   = inMemberId
                                   AND Object_Personal_View.PositionId = inPositionId
                                )
                               ;
            END IF;
        END IF;
    END IF;

   -- проверка если за этот день найден Документ Список бригады, выдавать сообщение при попытке исправить
   IF EXISTS (SELECT 1
              FROM Movement AS Movement_PersonalGroup
                   INNER JOIN MovementLinkObject AS MLO_Unit
                                                 ON MLO_Unit.MovementId = Movement_PersonalGroup.Id
                                                AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                AND MLO_Unit.ObjectId   = inUnitId
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement_PersonalGroup.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                   INNER JOIN MovementLinkObject AS MLO_PersonalGroup
                                                 ON MLO_PersonalGroup.MovementId = MovementItem.Id
                                                AND MLO_PersonalGroup.DescId         = zc_MovementLinkObject_PersonalGroup()
                                                AND MLO_PersonalGroup.ObjectId       = inPersonalGroupId
                   INNER JOIN Object_Personal_View ON Object_Personal_View.PersonalId = MovementItem.ObjectId
                                                  AND Object_Personal_View.MemberId   = inMemberId
               WHERE Movement_PersonalGroup.OperDate = inOperDate
                 AND Movement_PersonalGroup.DescId   = zc_Movement_PersonalGroup()
                 AND Movement_PersonalGroup.StatusId = zc_Enum_Status_Complete()
               )
      -- временно???
      AND 1=0
    THEN
        RAISE EXCEPTION 'Ошибка.%У сотрудника <%>%<%>%<%>%<%>%на <%> сформированы данные%в документе <Список бригады>.Корректировка невозможна.'
                               , CHR (13)
                               , lfGet_Object_ValueData_sh (inMemberId)
                               , CHR (13)
                               , lfGet_Object_ValueData_sh (inPositionId)
                               , CHR (13)
                               , lfGet_Object_ValueData_sh (inPersonalGroupId)
                               , CHR (13)
                               , lfGet_Object_ValueData_sh (inUnitId)
                               , CHR (13)
                               , zfConvert_DateToString(inOperDate)
                               , CHR (13)
                                ;
    END IF;

   -- проверка если за этот день найден отпуск, выдавать сообщение при попытке исправить
   IF EXISTS (SELECT 1
               FROM MovementLinkObject AS MovementLinkObject_Member
                    INNER JOIN Movement AS Movement_MemberHoliday
                                        ON Movement_MemberHoliday.Id = MovementLinkObject_Member.MovementId
                                       AND Movement_MemberHoliday.DescId = zc_Movement_MemberHoliday()
                                       AND Movement_MemberHoliday.StatusId = zc_Enum_Status_Complete()

                    INNER JOIN MovementDate AS MovementDate_BeginDateStart
                                            ON MovementDate_BeginDateStart.MovementId = MovementLinkObject_Member.MovementId
                                           AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()
                                           AND MovementDate_BeginDateStart.ValueData <= inOperDate
                    INNER JOIN MovementDate AS MovementDate_BeginDateEnd
                                            ON MovementDate_BeginDateEnd.MovementId = MovementDate_BeginDateStart.MovementId
                                           AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()
                                           AND MovementDate_BeginDateEnd.ValueData >= inOperDate
               WHERE MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                 AND MovementLinkObject_Member.ObjectId = inMemberId
               )
       AND ioTypeId NOT IN (zc_Enum_WorkTimeKind_Holiday(), zc_Enum_WorkTimeKind_HolidayNoZp())
    THEN
        RAISE EXCEPTION 'Ошибка.У сотрудника <%> <%>  <%> на <%> есть отпуск.%Нельзя установить значение <%>.'
                               , lfGet_Object_ValueData_sh (inMemberId)
                               , lfGet_Object_ValueData_sh (inPositionId)
                               , lfGet_Object_ValueData_sh (inUnitId)
                               , zfConvert_DateToString(inOperDate)
                               , CHR (13)
                               , lfGet_Object_ValueData_sh (ioTypeId)
                                ;
    END IF;

   -- проверка если за этот день найден отпуск, выдавать сообщение при попытке исправить
   IF ioTypeId IN (zc_Enum_WorkTimeKind_Holiday(), zc_Enum_WorkTimeKind_HolidayNoZp())
      AND vbIsCheck = TRUE
   THEN
        RAISE EXCEPTION 'Ошибка.У сотрудника <%> <%>  <%>%на <%>%нет прав устанавливать отпуск в табеле.%Только в документе <Приказ по отпускам>.'
                               , lfGet_Object_ValueData_sh (inMemberId)
                               , lfGet_Object_ValueData_sh (inPositionId)
                               , lfGet_Object_ValueData_sh (inUnitId)
                               , CHR (13)
                               , zfConvert_DateToString(inOperDate)
                               , CHR (13)
                               , CHR (13)
                                ;
    END IF;

    -- при вызове процедуры для док. Список бригады нужен для определения строки Тип. раб. времени
    vbTypeId := ioTypeId;

    IF ((ioValue = '0' OR TRIM (ioValue) = '')) AND ioTypeId NOT IN (zc_Enum_WorkTimeKind_Holiday(), zc_Enum_WorkTimeKind_HolidayNoZp())
    THEN
         ioTypeId := 0;
         vbValue  := 0;
    ELSE

        -- RAISE EXCEPTION '"%"  %  ', vbValue, POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId));

        IF ioValue = '-' AND inIsPersonalGroup = TRUE
        THEN
            IF ioTypeId IN (zc_Enum_WorkTimeKind_WorkD(), zc_Enum_WorkTimeKind_WorkN(), 8302788, 8302790)
            THEN
                ioValue:= (SELECT zfCalc_ViewWorkHour (0, OS.ValueData) FROM ObjectString AS OS WHERE OS.ObjectId = ioTypeId AND OS.DescId = zc_objectString_WorkTimeKind_ShortName());
            ELSE ioValue:= 0;
                 ioTypeId:= 0;
                 vbValue:= 0;
            END IF;
        END IF;


        IF EXISTS (SELECT 1
                   FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                   WHERE ObjectString_WorkTimeKind_ShortName.ValueData = UPPER (TRIM (ioValue))
                     AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                  )
        THEN
            ioTypeId:= (SELECT ObjectString_WorkTimeKind_ShortName.ObjectId
                        FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                        WHERE ObjectString_WorkTimeKind_ShortName.ValueData = UPPER (TRIM (ioValue))
                          AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                       );
            --
            vbValue:= 0;
        ELSE
/*        IF (vbValue >= 0 AND vbValue <= 24 AND POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId)) = 1) --  AND zfConvert_StringToNumber (ioValue) > 0)
        OR (ioTypeId = 0 AND vbValue >= 0 AND vbValue <= 24)
        THEN
*/

            IF zfConvert_StringToFloat(SPLIT_PART (UPPER (TRIM (ioValue)), '/', 1)) > 0 AND SPLIT_PART (UPPER (TRIM (ioValue)), '/', 2) <> ''
               AND EXISTS (SELECT 1
                           FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                           WHERE ObjectString_WorkTimeKind_ShortName.ValueData = 'FM99/' || SPLIT_PART (UPPER (TRIM (ioValue)), '/', 2)
                             AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                          )
               -- AND vbUserId = 5
            THEN
               ioTypeId:= (SELECT ObjectString_WorkTimeKind_ShortName.ObjectId
                           FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                           WHERE ObjectString_WorkTimeKind_ShortName.ValueData = 'FM99/' || SPLIT_PART (UPPER (TRIM (ioValue)), '/', 2)
                             AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                          );
            ELSE
               ioTypeId := CASE WHEN ioTypeId IN (zc_Enum_WorkTimeKind_Holiday(), zc_Enum_WorkTimeKind_HolidayNoZp())
                                     THEN ioTypeId
                                WHEN COALESCE (ioTypeId, 0) = 0 OR POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId)) = 0
                                     THEN zc_Enum_WorkTimeKind_Work()
                                ELSE ioTypeId
                           END;
            END IF;
        --
        vbValue := zfConvert_ViewWorkHourToHour (ioValue);

        END IF;

    END IF;



    ---
    IF 1 < (SELECT COUNT(*)
                     FROM Movement AS Movement_SheetWorkTime
                          JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                  ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id
                                                 AND MovementLinkObject_Unit.ObjectId = inUnitId
                     WHERE Movement_SheetWorkTime.OperDate = inOperDate
                       AND Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime()
                       AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()
                    )
    THEN
        RAISE EXCEPTION 'Ошибка.Найдено несколько Документов Табель %за <%> %для <%> %<%>'
                       , CHR (13)
                       , (zfConvert_DateToString (inOperDate))
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inUnitId)
                       , CHR (13)
                       , inUnitId
                        ;
    END IF;

    -- Для начала определим ID Movement, если таковой имеется. Ключом будет OperDate и UnitId
    vbMovementId := (SELECT Movement_SheetWorkTime.Id
                     FROM Movement AS Movement_SheetWorkTime
                          JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                  ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id
                                                 AND MovementLinkObject_Unit.ObjectId = inUnitId
                     WHERE Movement_SheetWorkTime.OperDate = inOperDate
                       AND Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime()
                       AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()
                    );

    -- сохранили <Документ>
    IF COALESCE (vbMovementId, 0) = 0
    THEN
        vbMovementId := lpInsertUpdate_Movement_SheetWorkTime(vbMovementId, '', inOperDate::DATE, inUnitId, vbUserId);
    END IF;

    -- Поиск MovementItemId
    IF 1 < (SELECT COUNT(*)
            FROM (SELECT MI_SheetWorkTime.Id
                  FROM MovementItem AS MI_SheetWorkTime
                       LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                              ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                             AND MIObject_Position.DescId = zc_MILinkObject_Position()
                       LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                              ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                             AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                       LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                              ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                             AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                       LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                              ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                             AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()

                       -- нужно учитывать тип Раб. времени только при вызове из док. список бригад
                       LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                        ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                       AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

                   WHERE MI_SheetWorkTime.MovementId = vbMovementId
                     AND MI_SheetWorkTime.ObjectId   = inMemberId
                     AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                     AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                     AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                     AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                     --
                     AND MI_SheetWorkTime.isErased   = FALSE
                     --
                     AND (inIsPersonalGroup = FALSE OR (inIsPersonalGroup = TRUE AND MIObject_WorkTimeKind.ObjectId = ioWorkTimeKindId_key))
                  LIMIT CASE WHEN inIsPersonalGroup = TRUE THEN 1 ELSE 100 END
                 ) AS tmp)
--        OR (vbUserId = 5 and ioWorkTimeKindId_key = 12917 and inMemberId in (8278565) and ioValue <> '0')
--        OR (vbUserId = 5 and inMemberId in (8262719))
    THEN
        RAISE EXCEPTION 'Ошибка.Найдено несколько элементов в Табеле%<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%>'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inMemberId) || '('|| inMemberId :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPositionId) || '('|| COALESCE (inPositionId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPositionLevelId) || '('|| COALESCE (inPositionLevelId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPersonalGroupId) || '('|| COALESCE (inPersonalGroupId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inStorageLineId) || '('|| COALESCE (inStorageLineId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (ioWorkTimeKindId_key) || '('|| COALESCE (ioWorkTimeKindId_key, 0) :: TVarChar || ')'
                       , CHR (13)
                       , inIsPersonalGroup
                       , CHR (13)
                       , ioValue
                       , CHR (13)
                       , vbValue
                       
                       , CHR (13)
                       , zfConvert_DateToString (inOperDate)

                       , CHR (13)
                       , (SELECT MIN (MI_SheetWorkTime.Id)
                          FROM MovementItem AS MI_SheetWorkTime
                               LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                      ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                     AND MIObject_Position.DescId = zc_MILinkObject_Position()
                               LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                      ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                     AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                               LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                      ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                                     AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                               LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                      ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                                     AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()

                               -- нужно учитывать тип Раб. времени только при вызове из док. список бригад
                               LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                               AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

                           WHERE MI_SheetWorkTime.MovementId = vbMovementId
                             AND MI_SheetWorkTime.ObjectId   = inMemberId
                             AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                             AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                             AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                             AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                             --
                             AND MI_SheetWorkTime.isErased   = FALSE
                             --
                             AND (inIsPersonalGroup = FALSE OR (inIsPersonalGroup = TRUE AND MIObject_WorkTimeKind.ObjectId = ioWorkTimeKindId_key))
                        --LIMIT CASE WHEN inIsPersonalGroup = TRUE THEN 1 ELSE 100 END
                         )

                       , CHR (13)
                       , (SELECT MAX (MI_SheetWorkTime.Id)
                          FROM MovementItem AS MI_SheetWorkTime
                               LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                      ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                     AND MIObject_Position.DescId = zc_MILinkObject_Position()
                               LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                      ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                     AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                               LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                      ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                                     AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                               LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                      ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                                     AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()

                               -- нужно учитывать тип Раб. времени только при вызове из док. список бригад
                               LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                               AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

                           WHERE MI_SheetWorkTime.MovementId = vbMovementId
                             AND MI_SheetWorkTime.ObjectId   = inMemberId
                             AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                             AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                             AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                             AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                             --
                             AND MI_SheetWorkTime.isErased   = FALSE
                             --
                             AND (inIsPersonalGroup = FALSE OR (inIsPersonalGroup = TRUE AND MIObject_WorkTimeKind.ObjectId = ioWorkTimeKindId_key))
                         --LIMIT CASE WHEN inIsPersonalGroup = TRUE THEN 1 ELSE 100 END
                         )
                        ;
    END IF;

    -- Поиск-1
    vbMovementItemId := (SELECT MI_SheetWorkTime.Id
                         FROM MovementItem AS MI_SheetWorkTime
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position()
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                     ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                                    AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()

                              -- нужно учитывать тип Раб. времени только при вызове из док. список бригад
                              LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                               ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                              AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

                          WHERE MI_SheetWorkTime.MovementId = vbMovementId
                            AND MI_SheetWorkTime.ObjectId   = inMemberId
                            AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                            AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                            AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                            AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                            --
                            AND MI_SheetWorkTime.isErased   = FALSE
                            --
                            AND (inIsPersonalGroup = FALSE OR (inIsPersonalGroup = TRUE AND MIObject_WorkTimeKind.ObjectId = ioWorkTimeKindId_key))
                         LIMIT CASE WHEN inIsPersonalGroup = TRUE THEN 1 ELSE 100 END
                        );
     -- Поиск-2
     IF COALESCE (vbMovementItemId, 0) = 0
     THEN
         vbMovementItemId := (SELECT MI_SheetWorkTime.Id
                              FROM MovementItem AS MI_SheetWorkTime
                                   LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                          ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                         AND MIObject_Position.DescId = zc_MILinkObject_Position()
                                   LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                          ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                         AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                   LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                          ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                                         AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                                   LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                          ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                                         AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()

                                   -- нужно учитывать тип Раб. времени только при вызове из док. список бригад
                                   LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                    ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                                   AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

                               WHERE MI_SheetWorkTime.MovementId = vbMovementId
                                 AND MI_SheetWorkTime.ObjectId   = inMemberId
                                 AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                                 AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                                 AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                                 AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                                 --
                                 AND MI_SheetWorkTime.isErased   = FALSE
                                 --
                                 AND (inIsPersonalGroup = FALSE OR (inIsPersonalGroup = TRUE AND MIObject_WorkTimeKind.ObjectId = ioTypeId))
                              LIMIT CASE WHEN inIsPersonalGroup = TRUE THEN 1 ELSE 100 END
                             );
     END IF;


     -- Проверка через УНИКАЛЬНОСТЬ
     IF COALESCE (vbMovementItemId, 0) = 0 AND 1=0
     THEN
         PERFORM lpInsert_LockUnique (inKeyData:= 'SheetWorkTime'
                                        || ';' || zc_Movement_SheetWorkTime() :: TVarChar
                                        || ';' || vbMovementId :: TVarChar
                                        || ';' || COALESCE (inMemberId, 0) :: TVarChar
                                        || ';' || COALESCE (inPositionId, 0) :: TVarChar
                                        || ';' || COALESCE (inPositionLevelId, 0) :: TVarChar
                                        || ';' || COALESCE (inPersonalGroupId, 0) :: TVarChar
                                        || ';' || COALESCE (inStorageLineId, 0) :: TVarChar
                                        || ';' || (CASE WHEN inIsPersonalGroup = FALSE THEN '0' ELSE COALESCE (ioTypeId, 0) :: TVarChar END) :: TVarChar
                                        || ';' || (CASE WHEN inIsPersonalGroup = FALSE THEN '0' ELSE COALESCE (ioWorkTimeKindId_key, 0) :: TVarChar END) :: TVarChar
                                    , inUserId:= vbUserId);
     END IF;

     -- замена
     IF inIsPersonalGroup = TRUE
     THEN
         ioWorkTimeKindId_key:= vbTypeId;
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

    -- сохранили
    vbMovementItemId:= lpInsertUpdate_MovementItem_SheetWorkTime (inMovementItemId      := vbMovementItemId  -- Ключ объекта <Элемент документа>
                                                                , inMovementId          := vbMovementId      -- ключ Документа
                                                                , inMemberId            := inMemberId        -- Физ. лицо
                                                                , inPositionId          := inPositionId      -- Должность
                                                                , inPositionLevelId     := inPositionLevelId -- Разряд
                                                                , inPersonalGroupId     := inPersonalGroupId -- Группировка Сотрудника
                                                                , inStorageLineId       := inStorageLineId   -- линия производства
                                                                , inAmount              := vbValue           -- Количество часов факт
                                                                , inWorkTimeKindId      := ioTypeId          -- Типы рабочего времени
                                                                 );

    --
    ioValue := zfGet_ViewWorkHour (vbValue, ioTypeId);


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = 'tmpoperdate')
     THEN
         DELETE FROM tmpOperDate;
         INSERT INTO tmpOperDate (OperDate)
             SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;
     ELSE
         -- пересчитываем итого рабочее время
         CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
             SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;
     END IF;

    OutAmountHours := (SELECT  SUM(MI_SheetWorkTime.Amount) as  AmountHours
                       FROM tmpOperDate
                        JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                     AND Movement.DescId = zc_Movement_SheetWorkTime()
                        JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                        LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                         ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                        AND MIObject_Position.DescId = zc_MILinkObject_Position()
                        LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                         ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                        AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                        LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                         ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                        AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                        LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                               ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                              AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                       WHERE MovementLinkObject_Unit.ObjectId = inUnitId
                         AND MI_SheetWorkTime.ObjectId = inMemberId
                         AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                         AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                         AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                         AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                       );


    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), vbMovementId, CURRENT_TIMESTAMP);
    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), vbMovementId, vbUserId);

    -- сохранили протокол
    IF vbUserId <> 5 OR 1=1
    THEN
        PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);
    END IF;

    if 0 = COALESCE ((SELECT COUNT(*) FROM MovementItemProtocol WHERE MovementItemProtocol.MovementItemId = vbMovementItemId), 0)
       -- AND vbUserId <> 5
    then
        RAISE EXCEPTION 'Ошибка.Данные протокола не сохранены (%)%<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%>'
                       , vbMovementItemId
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inMemberId) || '('|| inMemberId :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPositionId) || '('|| COALESCE (inPositionId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPositionLevelId) || '('|| COALESCE (inPositionLevelId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPersonalGroupId) || '('|| COALESCE (inPersonalGroupId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inStorageLineId) || '('|| COALESCE (inStorageLineId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (ioWorkTimeKindId_key) || '('|| COALESCE (ioWorkTimeKindId_key, 0) :: TVarChar || ')'
                       , CHR (13)
                       , inIsPersonalGroup
                       , CHR (13)
                       , ioValue
                       , CHR (13)
                       , vbValue
                      ;

    end if;

    -- для Admin
if 1=1 and vbUserId = 5 AND ioWorkTimeKindId_key = 8302790
then
        RAISE EXCEPTION 'Ошибка.Данные (%)%<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%> %<%>'
                       , vbMovementItemId
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inMemberId) || '('|| inMemberId :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPositionId) || '('|| COALESCE (inPositionId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPositionLevelId) || '('|| COALESCE (inPositionLevelId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inPersonalGroupId) || '('|| COALESCE (inPersonalGroupId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inStorageLineId) || '('|| COALESCE (inStorageLineId, 0) :: TVarChar || ')'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (ioWorkTimeKindId_key) || '('|| COALESCE (ioWorkTimeKindId_key, 0) :: TVarChar || ')'
                       , CHR (13)
                       , inIsPersonalGroup
                       , CHR (13)
                       , ioValue
                       , CHR (13)
                       , vbValue
                       , CHR (13)
                       , (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = vbMovementItemId)
                      ;
end if;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.17         * add StorageLine
 25.03.16         * add OutAmountHours
 07.01.14                         * Replace inPersonalId <> inMemberId
 25.11.13                         * Add inPositionLevelId
 17.10.13                         *
 03.10.13         *

*/
-- select * from Movement WHERE Id = 24343181
-- update Movement set StatusId = zc_enum_status_erased()  WHERE Id = 24343181
-- update Movement set StatusId = 7  WHERE Id = 24343196
/*SELECT *
-- update Movement set StatusId = zc_enum_status_erased()  
from
(
SELECT Movement_SheetWorkTime.Id, Movement_SheetWorkTime.OperDate, MovementLinkObject_Unit.ObjectId , Movement_SheetWorkTime.StatusId
 , ROW_NUMBER() OVER (PARTITION BY Movement_SheetWorkTime.OperDate, MovementLinkObject_Unit.ObjectId ) AS Ord
                     FROM Movement AS Movement_SheetWorkTime
                          JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                  ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id
                                                 AND MovementLinkObject_Unit.ObjectId = 8395 -- inUnitId 
                    WHERE Movement_SheetWorkTime.OperDate between '01.01.2023' and '31.01.2023'
--                     WHERE Movement_SheetWorkTime.OperDate between '01.01.2023' and '01.01.2023'
                       AND Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime()
                       AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()
 
) as a
 where ord = 1 
-- and Movement.Id = a.Id
-- 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTime (, inSession:= '2')
-- SELECT * FROM MovementItemProtocol WHERE MovementItemProtocol.MovementItemId = 233879947

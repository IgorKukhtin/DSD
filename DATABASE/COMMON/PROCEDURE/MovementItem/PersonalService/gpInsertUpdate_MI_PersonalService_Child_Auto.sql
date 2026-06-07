-- Function: gpInsertUpdate_MI_PersonalService_Child_Auto()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Auto (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Auto (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_Auto(
    IN inUnitId              Integer   , -- подразделение
    IN inPersonalServiceListId Integer   , -- ведомость начисления
    IN inMemberId            Integer   , -- физ.лицо
    IN inStartDate           TDateTime , -- дата
    IN inEndDate             TDateTime , -- дата
    IN inPositionId          Integer   , -- должность
    IN inPositionLevelId     Integer   , -- разряд должности
    IN inStaffListId         Integer   , -- штатное расписание
    IN inModelServiceId      Integer   , -- Модели начисления
    IN inStaffListSummKindId Integer   , -- Типы сумм для штатного расписания
    IN inAmount              TFloat    , --
    IN inMemberCount         TFloat    , --
    IN inDayCount            TFloat    , --
    IN inWorkTimeHoursOne    TFloat    , --
    IN inWorkTimeHours       TFloat    , --
    IN inPrice               TFloat    , --
    -- IN inHoursPlan           TFloat    , --
    -- IN inHoursDay            TFloat    , --
    -- IN inPersonalCount       TFloat    , --
    IN inGrossOne            TFloat    , --
    IN inKoeff               TFloat    , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbId_Master Integer;
   DECLARE vbId_Child Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIsMain Boolean;
   DECLARE vbIsAuto Boolean;

   DECLARE vbInfoMoneyId_def Integer;
   DECLARE ioId Integer;

   DECLARE vbHoursPlan TFloat;
   DECLARE vbHoursDay TFloat;
   DECLARE vbPersonalCount TFloat;
   DECLARE vbsummservice TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);


     -- врменно - пока не понятно зачем 0 в отчете
     IF COALESCE (inAmount, 0) = 0 AND COALESCE (inWorkTimeHoursOne, 0) = 0 AND COALESCE (inDayCount, 0) = 0
     THEN
         -- !!!ВЫХОД!!!
         RETURN;
     END IF;


     -- проверка
     IF COALESCE (inPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Ведомость Начисления>.';
     END IF;
     -- проверка
     IF COALESCE (inStaffListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Штатное расписание>.';
     END IF;
     -- проверка
     IF COALESCE (inModelServiceId, 0) = 0 AND COALESCE (inStaffListSummKindId, 0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.%Не установлено значение <Модель начисления>%или <Типы сумм для штатного расписания>.%<%> %<%> %<%> %<%>'
                      , CHR (13)
                      , CHR (13)
                      , CHR (13)
                      , lfGet_Object_ValueData_sh (inUnitId)
                      , CHR (13)
                      , lfGet_Object_ValueData_sh (inPersonalServiceListId)
                      , CHR (13)
                      , lfGet_Object_ValueData_sh (inMemberId)
                      , CHR (13)
                      , lfGet_Object_ValueData_sh (inPositionId)
                       ;
     END IF;


     -- поиск
     vbInfoMoneyId_def:= (SELECT Object_InfoMoney_View.InfoMoneyId FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_60101()); -- 60101 Заработная плата + Заработная плата


     IF EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_Personal() AND Object.Id = inMemberId)
     THEN
         -- Если передали Сотрудник
         SELECT Object_Personal.Id                                      AS PersonalId
              , COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE) AS isMain
                INTO vbPersonalId, vbIsMain
         FROM Object AS Object_Personal
              LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                      ON ObjectBoolean_Personal_Main.ObjectId = Object_Personal.Id
                                     AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
         WHERE Object_Personal.DescId = zc_Object_Personal()
           AND Object_Personal.Id     =  inMemberId;
     ELSE
         -- поиск сотрудника (ключ - физ.лицо + сотрудник + подразделение)
         WITH -- Список всех должностей
              tmp AS (SELECT ObjectLink_Personal_Member.ChildObjectId   AS MemberId
                           , Object_Personal.Id                         AS PersonalId
                           , ObjectLink_Personal_Unit.ChildObjectId     AS UnitId
                           , ObjectLink_Personal_Position.ChildObjectId AS PositionId
                      FROM ObjectLink AS ObjectLink_Personal_Member
                           LEFT JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_Member.ObjectId
                                                              AND Object_Personal.isErased = FALSE
                           LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                               AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                           LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                               AND ObjectLink_Personal_Position.DescId   = zc_ObjectLink_Personal_Position()
    
                      WHERE ObjectLink_Personal_Member.ChildObjectId   = inMemberId
                        AND ObjectLink_Personal_Member.DescId          = zc_ObjectLink_Personal_Member()
                     )
         -- выбираем только одного
         SELECT COALESCE (tmp1.PersonalId, tmp2.PersonalId, tmp3.PersonalId) AS PersonalId
              , COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE)                 AS isMain
                INTO vbPersonalId, vbIsMain
         FROM Object AS Object_Member
              -- первый приоритет - по всем параметрам
              LEFT JOIN tmp AS tmp1 ON tmp1.MemberId   = Object_Member.Id
                                   AND tmp1.UnitId     = inUnitId
                                   AND tmp1.PositionId = inPositionId
              -- второй приоритет - Подразделение
              LEFT JOIN tmp AS tmp2 ON tmp2.MemberId   = Object_Member.Id
                                   AND tmp2.UnitId     = inUnitId
              -- третий приоритет - Должность
              LEFT JOIN tmp AS tmp3 ON tmp3.MemberId   = Object_Member.Id
                                   AND tmp3.PositionId = inPositionId
              LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                      ON ObjectBoolean_Personal_Main.ObjectId = COALESCE (tmp1.PersonalId, tmp2.PersonalId, tmp3.PersonalId)
                                     AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
         WHERE Object_Member.DescId = zc_Object_Member()
           AND Object_Member.Id     =  inMemberId
         ORDER BY CASE WHEN ObjectBoolean_Personal_Main.ValueData = TRUE THEN 0 ELSE 1 END, COALESCE (tmp1.PersonalId, tmp2.PersonalId, tmp3.PersonalId)
         LIMIT 1
         ;
     END IF;
     
     -- Если нужен поиск по документам
     IF COALESCE (vbPersonalId, 0) = 0
     THEN
         -- Если был Прием на работу
         IF EXISTS (SELECT Movement.*
                    FROM MovementLinkObject AS MLO_Member
                         JOIN Movement ON Movement.Id       = MLO_Member.MovementId
                                      AND Movement.DescId   = zc_Movement_StaffListMember()
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                         JOIN MovementBoolean AS MB_Main
                                              ON MB_Main.MovementId = MLO_Member.MovementId
                                             AND MB_Main.DescId     = zc_MovementBoolean_Main()
                                             -- Только Основное место
                                             AND MB_Main.ValueData  = TRUE
                         -- Прием на работу
                         INNER JOIN MovementLinkObject AS MLO_StaffListKind
                                                       ON MLO_StaffListKind.MovementId = MLO_Member.MovementId
                                                      AND MLO_StaffListKind.DescId     = zc_MovementLinkObject_StaffListKind()
                                                      AND MLO_StaffListKind.ObjectId   = zc_Enum_StaffListKind_In()

                         INNER JOIN MovementLinkObject AS MLO_Unit
                                                       ON MLO_Unit.MovementId = MLO_Member.MovementId
                                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                      AND MLO_Unit.ObjectId   = inUnitId
                         INNER JOIN MovementLinkObject AS MLO_Position
                                                       ON MLO_Position.MovementId = MLO_Member.MovementId
                                                      AND MLO_Position.DescId     = zc_MovementLinkObject_Position()
                                                      AND MLO_Position.ObjectId   = inPositionId
                    WHERE MLO_Member.ObjectId = inMemberId
                      AND MLO_Member.DescId   = zc_MovementLinkObject_Member()
                   )
         -- Или был Перевод
         OR EXISTS (SELECT Movement.*
                    FROM MovementLinkObject AS MLO_Member
                         JOIN Movement ON Movement.Id       = MLO_Member.MovementId
                                      AND Movement.DescId   = zc_Movement_StaffListMember()
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                         JOIN MovementBoolean AS MB_Main
                                              ON MB_Main.MovementId = MLO_Member.MovementId
                                             AND MB_Main.DescId     = zc_MovementBoolean_Main()
                                             -- Только Основное место
                                             AND MB_Main.ValueData  = TRUE
                         -- Перевод
                         INNER JOIN MovementLinkObject AS MLO_StaffListKind
                                                       ON MLO_StaffListKind.MovementId = MLO_Member.MovementId
                                                      AND MLO_StaffListKind.DescId     = zc_MovementLinkObject_StaffListKind()
                                                      AND MLO_StaffListKind.ObjectId   = zc_Enum_StaffListKind_Send()

                         INNER JOIN MovementLinkObject AS MLO_Unit_old
                                                       ON MLO_Unit_old.MovementId = MLO_Member.MovementId
                                                      AND MLO_Unit_old.DescId     = zc_MovementLinkObject_Unit_old()
                                                      AND MLO_Unit_old.ObjectId   = inUnitId
                         INNER JOIN MovementLinkObject AS MLO_Position_old
                                                       ON MLO_Position_old.MovementId = MLO_Member.MovementId
                                                      AND MLO_Position_old.DescId     = zc_MovementLinkObject_Position_old()
                                                      AND MLO_Position_old.ObjectId   = inPositionId
                    WHERE MLO_Member.ObjectId = inMemberId
                      AND MLO_Member.DescId   = zc_MovementLinkObject_Member()
                   )
         THEN
             -- проверка
             IF 1 < (SELECT COUNT(*)
                     FROM ObjectLink AS ObjectLink_Personal_Member
                          INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_Member.ObjectId
                                                              AND Object_Personal.isErased = FALSE
                          INNER JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                                   ON ObjectBoolean_Personal_Main.ObjectId  = ObjectLink_Personal_Member.ObjectId
                                                  AND ObjectBoolean_Personal_Main.DescId    = zc_ObjectBoolean_Personal_Main()
                                                  AND ObjectBoolean_Personal_Main.ValueData = TRUE
                      WHERE ObjectLink_Personal_Member.ChildObjectId = inMemberId
                        AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                     )
             THEN
                 RAISE EXCEPTION 'Ошибка.Найдено несколько записей %Основное место работы = <ДА> %ФИО = <%> % <%> % <%> % Сумма = <%>.'
                               , CHR (13)
                               , CHR (13)
                               , lfGet_Object_ValueData (inMemberId)
                               , CHR (13)
                               , lfGet_Object_ValueData (inPositionId)
                               , CHR (13)
                               , lfGet_Object_ValueData (inUnitId)
                               , CHR (13)
                               , zfConvert_FloatToString (inAmount)
                                ;
             END IF;

             -- Тогда можно искать по Физ.Лицу + основное место работы
             SELECT ObjectLink_Personal_Member.ObjectId   AS PersonalId
                  , ObjectBoolean_Personal_Main.ValueData AS isMain
                    INTO vbPersonalId, vbIsMain
             FROM ObjectLink AS ObjectLink_Personal_Member
                  INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_Member.ObjectId
                                                      AND Object_Personal.isErased = FALSE
                  INNER JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                           ON ObjectBoolean_Personal_Main.ObjectId  = ObjectLink_Personal_Member.ObjectId
                                          AND ObjectBoolean_Personal_Main.DescId    = zc_ObjectBoolean_Personal_Main()
                                          AND ObjectBoolean_Personal_Main.ValueData = TRUE
              WHERE ObjectLink_Personal_Member.ChildObjectId = inMemberId
                AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
             ;
         END IF;

     END IF;



     -- проверка
     IF COALESCE (vbPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено <ФИО (сотрудник)> у <%> + <%> + <%> для Сумма = <%>.'
                       , lfGet_Object_ValueData (inMemberId)
                       , lfGet_Object_ValueData (inPositionId)
                       , lfGet_Object_ValueData (inUnitId)
                       , zfConvert_FloatToString (inAmount);
     END IF;


if vbUserId = 5 
then
    -- поиск документа (ключ - Месяц начислений + ведомость) - ТОЛЬКО ОДИН
    SELECT MovementDate_ServiceDate.MovementId
         , MLO_Juridical.ObjectId AS JuridicalId -- на которое происходит начисление(соц выплаты)
           INTO vbMovementId, vbJuridicalId
    FROM MovementDate AS MovementDate_ServiceDate
        INNER JOIN Movement ON Movement.Id       = MovementDate_ServiceDate.MovementId
                           AND Movement.DescId   = zc_Movement_PersonalService()
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                         --AND Movement.OperDate >= inEndDate
        INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                      ON MLO_PersonalServiceList.MovementId = Movement.Id
                                     AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                     AND MLO_PersonalServiceList.ObjectId   = inPersonalServiceListId
        LEFT JOIN MovementLinkObject AS MLO_Juridical
                                     ON MLO_Juridical.MovementId = Movement.Id
                                    AND MLO_Juridical.DescId     = zc_MovementLinkObject_Juridical()

        LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                  ON MovementBoolean_isAuto.MovementId = Movement.Id
                                 AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
    WHERE MovementDate_ServiceDate.ValueData = DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '0 MONTH'
      AND MovementDate_ServiceDate.DescId    = zc_MovementDate_ServiceDate()
    ORDER BY CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 0 ELSE 1 END, MovementDate_ServiceDate.MovementId
    LIMIT 1
   ;
else
    -- поиск документа (ключ - Месяц начислений + ведомость) - ТОЛЬКО ОДИН
    SELECT MovementDate_ServiceDate.MovementId
         , MLO_Juridical.ObjectId AS JuridicalId -- на которое происходит начисление(соц выплаты)
           INTO vbMovementId, vbJuridicalId
    FROM MovementDate AS MovementDate_ServiceDate
        INNER JOIN Movement ON Movement.Id       = MovementDate_ServiceDate.MovementId
                           AND Movement.DescId   = zc_Movement_PersonalService()
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                         --AND Movement.OperDate >= inEndDate
        INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                      ON MLO_PersonalServiceList.MovementId = Movement.Id
                                     AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                     AND MLO_PersonalServiceList.ObjectId   = inPersonalServiceListId
        LEFT JOIN MovementLinkObject AS MLO_Juridical
                                     ON MLO_Juridical.MovementId = Movement.Id
                                    AND MLO_Juridical.DescId     = zc_MovementLinkObject_Juridical()

        LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                  ON MovementBoolean_isAuto.MovementId = Movement.Id
                                 AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
    WHERE MovementDate_ServiceDate.ValueData = DATE_TRUNC ('MONTH', inEndDate)
      AND MovementDate_ServiceDate.DescId    = zc_MovementDate_ServiceDate()
    ORDER BY CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 0 ELSE 1 END, MovementDate_ServiceDate.MovementId
    LIMIT 1
   ;
end if;

      IF COALESCE (vbMovementId, 0) = 0
      THEN
          -- сохранили новый <Документ>
if vbUserId = 5 
then
          vbMovementId := lpInsertUpdate_Movement_PersonalService (ioId                      := 0
                                                                 , inInvNumber               := CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar) --inInvNumber
                                                                 , inOperDate                := inEndDate
                                                                 , inServiceDate             := DATE_TRUNC ('MONTH', inEndDate)  + INTERVAL '0 MONTH'
                                                                 , inComment                 := '' :: TVarChar
                                                                 , inPersonalServiceListId   := inPersonalServiceListId
                                                                 , inJuridicalId             := vbJuridicalId
                                                                 , inUserId                  := vbUserId
                                                                  );
          -- сохранили свойство <создан автоматически>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);
else
          vbMovementId := lpInsertUpdate_Movement_PersonalService (ioId                      := 0
                                                                 , inInvNumber               := CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar) --inInvNumber
                                                                 , inOperDate                := inEndDate
                                                                 , inServiceDate             := DATE_TRUNC ('MONTH', inEndDate) :: TDateTime
                                                                 , inComment                 := '' :: TVarChar
                                                                 , inPersonalServiceListId   := inPersonalServiceListId
                                                                 , inJuridicalId             := vbJuridicalId
                                                                 , inUserId                  := vbUserId
                                                                  );
          -- сохранили свойство <создан автоматически>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);
end if;
      END IF;


      -- поиск zc_MI_Master (ключ - документ + сотрудник + подразделение)
      SELECT MovementItem.Id                              AS Id_Master
           , COALESCE (MIBoolean_isAuto.ValueData, TRUE) AS isAuto
             INTO vbId_Master, vbIsAuto
      FROM MovementItem
           INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                            AND MILinkObject_Unit.ObjectId       = inUnitId
           INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                                            AND MILinkObject_Position.ObjectId       = inPositionId

           LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                         ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                        AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.ObjectId   = vbPersonalId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = FALSE;


      IF COALESCE (vbId_Master,0) = 0
      THEN
         -- сохранили zc_MI_Master
         vbId_Master:= (SELECT tmp.ioId
                        FROM lpInsertUpdate_MovementItem_PersonalService (ioId                     := vbId_Master
                                                                        , inMovementId             := vbMovementId
                                                                        , inPersonalId             := vbPersonalId
                                                                        , inIsMain                 := vbIsMain
                                                                        , inSummService            := 0 -- !!!потом зальем сумму!!!
                                                                        , inSummCardRecalc         := 0
                                                                        , inSummCardSecondRecalc   := 0
                                                                        , inSummCardSecondCash     := 0
                                                                        , inSummAvCardSecondRecalc := 0

                                                                        , inSummNalogRecalc        := 0
                                                                        , inSummNalogRetRecalc     := 0
                                                                        , inSummMinus              := 0
                                                                        , inSummAdd                := 0
                                                                        , inSummAddOthRecalc       := 0

                                                                        , inSummHoliday            := 0
                                                                        , inSummSocialIn           := 0
                                                                        , inSummSocialAdd          := 0
                                                                        , inSummChildRecalc        := 0
                                                                        , inSummMinusExtRecalc     := 0
                                                                        , inSummFine               := 0
                                                                        , inSummFineOthRecalc      := 0
                                                                        , inSummHosp               := 0
                                                                        , inSummHospOthRecalc      := 0
                                                                        , inSummCompensationRecalc := 0
                                                                        , inSummAuditAdd           := 0
                                                                        , inSummHouseAdd           := 0 
                                                                        , inSummAvanceRecalc       := 0

                                                                        , inNumber                 := ''
                                                                        , inComment                := ''
                                                                        , inInfoMoneyId            := vbInfoMoneyId_def
                                                                        , inUnitId                 := inUnitId
                                                                        , inPositionId             := inPositionId
                                                                        , inMemberId               := NULL
                                                                        , inPersonalServiceListId  := inPersonalServiceListId
                                                                        , inFineSubjectId          := 0
                                                                        , inUnitFineSubjectId      := 0
                                                                        , inUserId                 := vbUserId
                                                                         ) AS tmp);

         -- сохранили свойство <создан автоматически>
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), vbId_Master, TRUE);

      END IF;

      -- поиск zc_MI_Child
      vbId_Child:= 0 ;/*(SELECT MovementItem.Id
                    FROM MovementItem
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                         ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffList
                                                         ON MILinkObject_StaffList.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_StaffList.DescId = zc_MILinkObject_StaffList()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ModelService
                                                         ON MILinkObject_ModelService.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_ModelService.DescId = zc_MILinkObject_ModelService()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffListSummKind
                                                        ON MILinkObject_StaffListSummKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_StaffListSummKind.DescId = zc_MILinkObject_StaffListSummKind()
                    WHERE MovementItem.MovementId = vbMovementId
                      AND MovementItem.DescId     = zc_MI_Child()
                      AND MovementItem.ParentId   = vbId_Master
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.ObjectId   = inMemberId
                      AND (MILinkObject_PositionLevel.ObjectId     = inPositionLevelId     OR inPositionLevelId = 0)
                      AND (MILinkObject_StaffList.ObjectId         = inStaffListId         OR inStaffListId = 0)
                      AND (MILinkObject_ModelService.ObjectId      = inModelServiceId      OR inModelServiceId = 0)
                      AND (MILinkObject_StaffListSummKind.ObjectId = inStaffListSummKindId OR inStaffListSummKindId=0)
                   );*/

     -- получаем данные из спр. Штатное расписание
     SELECT ObjectFloat_HoursPlan.ValueData     AS HoursPlan
          , ObjectFloat_HoursDay.ValueData      AS HoursDay
          , ObjectFloat_PersonalCount.ValueData AS PersonalCount
            INTO vbHoursPlan, vbHoursDay, vbPersonalCount
     FROM Object AS Object_StaffList
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan
                                ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id
                               AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id
                               AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
          LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount
                                ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id
                               AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()
     WHERE Object_StaffList.Id     = inStaffListId;


      -- сохранили zc_MI_Child
      PERFORM lpInsertUpdate_MI_PersonalService_Child( ioId                   := vbId_Child
                                                     , inMovementId           := vbMovementId
                                                     , inParentId             := vbId_Master
                                                     , inMemberId             := inMemberId
                                                     , inPositionLevelId      := inPositionLevelId
                                                     , inStaffListId          := inStaffListId
                                                     , inModelServiceId       := inModelServiceId
                                                     , inStaffListSummKindId  := inStaffListSummKindId

                                                     , inAmount               := COALESCE (inAmount, 0)
                                                     , inMemberCount          := COALESCE (inMemberCount, 0)
                                                     , inDayCount             := COALESCE (inDayCount, 0)
                                                     , inWorkTimeHoursOne     := COALESCE (inWorkTimeHoursOne, 0)
                                                     , inWorkTimeHours        := COALESCE (inWorkTimeHours, 0)
                                                     , inPrice                := COALESCE (inPrice, 0)
                                                     , inHoursPlan            := COALESCE (vbHoursPlan, 0)
                                                     , inHoursDay             := COALESCE (vbHoursDay, 0)
                                                     , inPersonalCount        := COALESCE (vbPersonalCount, 0)
                                                     , inGrossOne             := COALESCE (inGrossOne, 0)
                                                     , inKoeff                := COALESCE (inKoeff,0)::TFloat
                                                     , inUserId               := vbUserId
                                                     );

    IF COALESCE (vbIsAuto, TRUE) = TRUE
    THEN
       vbSummService := (SELECT SUM (MovementItem.Amount) AS Amount
                         FROM MovementItem
                         WHERE MovementItem.ParentId = vbId_Master
                           AND MovementItem.DescId   = zc_MI_Child()
                           AND MovementItem.isErased = FALSE
                        );
       -- vbSummService := COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = vbId_Master), 0)
       --                + COALESCE (inAmount, 0);

       -- обновляем сумму мастера = итого по чайлд
       PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                     := vbId_Master
                                                          , inMovementId             := vbMovementId
                                                          , inPersonalId             := MovementItem.ObjectId
                                                          , inIsMain                 := COALESCE (MIBoolean_Main.ValueData, FALSE)
                                                          , inSummService            := vbSummService
                                                          , inSummCardRecalc         := COALESCE (MIFloat_SummCardRecalc.ValueData, 0)
                                                          , inSummCardSecondRecalc   := COALESCE (MIFloat_SummCardSecondRecalc.ValueData, 0)
                                                          , inSummCardSecondCash     := COALESCE (MIFloat_SummCardSecondCash.ValueData, 0)
                                                          , inSummAvCardSecondRecalc := COALESCE (MIFloat_SummAvCardSecondRecalc.ValueData, 0)

                                                          , inSummNalogRecalc        := COALESCE (MIFloat_SummNalogRecalc.ValueData, 0)
                                                          , inSummNalogRetRecalc     := COALESCE (MIFloat_SummNalogRetRecalc.ValueData, 0)
                                                          , inSummMinus              := COALESCE (MIFloat_SummMinus.ValueData, 0)
                                                          , inSummAdd                := COALESCE (MIFloat_SummAdd.ValueData, 0)
                                                          , inSummAddOthRecalc       := COALESCE (MIFloat_SummAddOthRecalc.ValueData, 0)

                                                          , inSummHoliday            := COALESCE (MIFloat_SummHoliday.ValueData, 0)
                                                          , inSummSocialIn           := COALESCE (MIFloat_SummSocialIn.ValueData, 0)
                                                          , inSummSocialAdd          := COALESCE (MIFloat_SummSocialAdd.ValueData, 0)
                                                          , inSummChildRecalc        := COALESCE (MIFloat_SummChildRecalc.ValueData, 0)
                                                          , inSummMinusExtRecalc     := COALESCE (MIFloat_SummMinusExtRecalc.ValueData, 0)
                                                          , inSummFine               := COALESCE (MIFloat_SummFine.ValueData, 0)
                                                          , inSummFineOthRecalc      := COALESCE (MIFloat_SummFineOthRecalc.ValueData, 0)
                                                          , inSummHosp               := COALESCE (MIFloat_SummHosp.ValueData, 0)
                                                          , inSummHospOthRecalc      := COALESCE (MIFloat_SummHospOthRecalc.ValueData, 0)
                                                          , inSummCompensationRecalc := COALESCE (MIFloat_SummCompensationRecalc.ValueData, 0)
                                                          , inSummAuditAdd           := COALESCE (MIFloat_SummAuditAdd.ValueData, 0)
                                                          , inSummHouseAdd           := COALESCE (MIFloat_SummHouseAdd.ValueData, 0)
                                                          , inSummAvanceRecalc       := COALESCE (MIFloat_SummAvanceRecalc.ValueData,0)

                                                          , inNumber                 := ''
                                                          , inComment                := MIString_Comment.ValueData
                                                          , inInfoMoneyId            := MILinkObject_InfoMoney.ObjectId
                                                          , inUnitId                 := inUnitId
                                                          , inPositionId             := inPositionId
                                                          , inMemberId               := MILinkObject_Member.ObjectId
                                                          , inPersonalServiceListId  := NULL
                                                          , inFineSubjectId          := COALESCE (MILinkObject_FineSubject.ObjectId,0)::Integer
                                                          , inUnitFineSubjectId      := COALESCE (MILinkObject_UnitFineSubject.ObjectId,0)::Integer
                                                          , inUserId                 := vbUserId
                                                           )
       FROM MovementItem
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                        ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                        ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                        ON MIFloat_SummCardSecondCash.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()
            LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                        ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummAvCardSecondRecalc.DescId         = zc_MIFloat_SummAvCardSecondRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRecalc
                                        ON MIFloat_SummNalogRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummNalogRecalc.DescId = zc_MIFloat_SummNalogRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRetRecalc
                                        ON MIFloat_SummNalogRetRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummNalogRetRecalc.DescId = zc_MIFloat_SummNalogRetRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                        ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
            LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                        ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
            LEFT JOIN MovementItemFloat AS MIFloat_SummAuditAdd
                                        ON MIFloat_SummAuditAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummAuditAdd.DescId = zc_MIFloat_SummAuditAdd()
            LEFT JOIN MovementItemFloat AS MIFloat_SummHouseAdd
                                        ON MIFloat_SummHouseAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummHouseAdd.DescId = zc_MIFloat_SummHouseAdd()
                                       
            LEFT JOIN MovementItemFloat AS MIFloat_SummAddOthRecalc
                                        ON MIFloat_SummAddOthRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummAddOthRecalc.DescId = zc_MIFloat_SummAddOthRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                        ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
            LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                        ON MIFloat_SummSocialIn.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
            LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                        ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
            LEFT JOIN MovementItemFloat AS MIFloat_SummChildRecalc
                                        ON MIFloat_SummChildRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummChildRecalc.DescId = zc_MIFloat_SummChildRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExtRecalc
                                        ON MIFloat_SummMinusExtRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummMinusExtRecalc.DescId = zc_MIFloat_SummMinusExtRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummFine
                                        ON MIFloat_SummFine.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummFine.DescId = zc_MIFloat_SummFine()
            LEFT JOIN MovementItemFloat AS MIFloat_SummHosp
                                        ON MIFloat_SummHosp.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummHosp.DescId = zc_MIFloat_SummHosp()

            LEFT JOIN MovementItemFloat AS MIFloat_SummFineOthRecalc
                                        ON MIFloat_SummFineOthRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummFineOthRecalc.DescId = zc_MIFloat_SummFineOthRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummHospOthRecalc
                                        ON MIFloat_SummHospOthRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummHospOthRecalc.DescId = zc_MIFloat_SummHospOthRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummCompensationRecalc
                                        ON MIFloat_SummCompensationRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummCompensationRecalc.DescId = zc_MIFloat_SummCompensationRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummAvanceRecalc
                                        ON MIFloat_SummAvanceRecalc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummAvanceRecalc.DescId = zc_MIFloat_SummAvanceRecalc()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                          ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId         = zc_MILinkObject_Member()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                             ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList() 
            LEFT JOIN MovementItemLinkObject AS MILinkObject_FineSubject
                                             ON MILinkObject_FineSubject.MovementItemId = MovementItem.Id
                                            AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_UnitFineSubject
                                             ON MILinkObject_UnitFineSubject.MovementItemId = MovementItem.Id
                                            AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
       WHERE MovementItem.Id       = vbId_Master
         AND MovementItem.DescId   = zc_MI_Master()
         AND MovementItem.isErased = FALSE;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.03.20         * SummAuditAdd
 27.01.20         * SummCompensationRecalc
 15.10.19         *
 29.07.19         *
 05.01.18         *
 20.06.17         * add inSummCardSecondCash
 21.06.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Child_Auto(inFromId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');

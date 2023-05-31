-- Function: gpInsertUpdate_MI_PersonalService_Avance()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Avance (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Avance (Integer, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Avance(
    IN inMovementId       Integer   , -- Ключ объекта <Документ>
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --                        
    IN inServiceDate      TDateTime , -- Месяц начислений
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbSummAvance TFloat;
   DECLARE vbHourAvance TFloat;
   DECLARE vbServiceDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());

     --находим значение суммы аванса для ведомости
     SELECT COALESCE (ObjectFloat_SummAvance.ValueData, 0) :: TFloat AS SummAvance
          , COALESCE (ObjectFloat_HourAvance.ValueData, 0) :: TFloat AS HourAvance
          , MovementLinkObject_PersonalServiceList.ObjectId          AS PersonalServiceListId
          , MovementDate_ServiceDate.ValueData         AS ServiceDate
    INTO vbSummAvance, vbHourAvance, vbPersonalServiceListId, vbServiceDate   
     FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
          INNER JOIN ObjectFloat AS ObjectFloat_SummAvance
                                 ON ObjectFloat_SummAvance.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId 
                                AND ObjectFloat_SummAvance.DescId = zc_ObjectFloat_PersonalServiceList_SummAvance()  

          LEFT JOIN ObjectFloat AS ObjectFloat_HourAvance
                                ON ObjectFloat_HourAvance.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId  
                               AND ObjectFloat_HourAvance.DescId = zc_ObjectFloat_PersonalServiceList_HourAvance()

          LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                 ON MovementDate_ServiceDate.MovementId = MovementLinkObject_PersonalServiceList.MovementId
                                AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
     WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
       AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
     ;

     IF COALESCE (vbSummAvance,0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.Сумма аванса для данной ведомости не установлена.';
     END IF;  
   

     -- Выбираем сохраненные данные из документа
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
            (SELECT tmp.*
             FROM gpSelect_MovementItem_PersonalService(inMovementId, FALSE, FALSE, inSession) AS tmp
            );
 

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate;        
                
      -- Выбираем данные из табеля             
     CREATE TEMP TABLE tmpData ON COMMIT DROP AS 

         WITH
         --подразделения для которых нужно заполнять авнс
         tmpUnit AS (SELECT ObjectBoolean.ObjectId AS UnitId
                     FROM ObjectBoolean
                     WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Unit_Avance()
                       AND ObjectBoolean.ValueData = TRUE
                     )

       , tmpMIAll AS (SELECT CASE WHEN MIObject_WorkTimeKind.ObjectId IN (zc_Enum_WorkTimeKind_WorkD()        -- день 12ч
                                                                        , zc_Enum_WorkTimeKind_WorkN()        -- ночь 12ч
                                                                        , zc_Enum_WorkTimeKind_Work()         -- Рабочие часы
                                                                        , zc_Enum_WorkTimeKind_Inventory()    -- Инвентаризация
                                                                        , zc_Enum_WorkTimeKind_RemoteAccess() -- Удаленый Доступ
                                                                         -- Стажер50% + Стажеры 60% + Стажеры 70% + Стажеры 80% + Стажеры 90% + Стажер День50% + Стажер Ночь50%
                                                                        , 7386821, 7386812, 7386818, 7386819, 12917, 8302788, 8302790
                                                                         -- Санобработка 
                                                                        , 7060854
                                                                         )
                                  THEN COALESCE (MI_SheetWorkTime.Amount, 0) ELSE 0 END AS Amount

                           , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                           , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                           , MIObject_WorkTimeKind.ObjectId                AS WorkTimeKindId
                           , MovementLinkObject_Unit.ObjectId              AS UnitId
                      FROM tmpOperDate
                           JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                        AND Movement.DescId = zc_Movement_SheetWorkTime()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                           JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                  AND MovementLinkObject_Unit.ObjectId IN (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)

                           JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                                AND MI_SheetWorkTime.DescId = zc_MI_Master()
                                                                AND MI_SheetWorkTime.isErased = FALSE
                           LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                            ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                           AND MIObject_Position.DescId = zc_MILinkObject_Position()
                           LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                            ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                           AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                           LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                            ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                           AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                      WHERE ( (COALESCE(MIObject_Position.ObjectId, 0) <> 12940 AND COALESCE(MIObject_PositionLevel.ObjectId, 0) <> 1673854)           --5) расчет часов по табелю исключить -А) Вантажник (добовий) + доплата за погр.убоя погрузчик:
                           OR (COALESCE(MIObject_Position.ObjectId, 0) <> 924983 AND COALESCE(MIObject_PositionLevel.ObjectId, 0) <> 3515083)          --5) расчет часов по табелю исключить -Б) Вантажник (-) + С доплатой за вождение кары
                           OR (COALESCE(MIObject_Position.ObjectId, 0) <> 714226)                                                                      --5) расчет часов по табелю исключить -В) Готувач фаршу с/к ковбас
                            )
                     )

        --сотрудники с прогулами
       , tmpSkip AS (SELECT DISTINCT tmpMIAll.MemberId
                     FROM tmpMIAll
                     WHERE tmpMIAll.WorkTimeKindId = zc_Enum_WorkTimeKind_Skip() 
                     )

       , tmpPersonal AS (SELECT lfSelect.MemberId
                              , lfSelect.PersonalId
                              , lfSelect.UnitId
                              , lfSelect.PositionId
                              , lfSelect.DateIn
                              , lfSelect.DateOut
                              , lfSelect.isMain
                              , PersonalServiceListId
                         FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                         WHERE lfSelect.Ord = 1
                        )
      
     ----исключить сотрудников, у которых найдены ведомости с заполненным св-вом zc_MIFloat_SummCardRecalc

     --выбираем все документы для тек.месяца начислений
     , tmpMovement_Avance AS (SELECT MovementDate_ServiceDate.MovementId             AS Id
                              FROM MovementDate AS MovementDate_ServiceDate
                                   JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                                AND Movement.DescId = zc_Movement_PersonalService()
                                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                              WHERE MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', vbServiceDate) AND (DATE_TRUNC ('MONTH', vbServiceDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                               -- and MovementDate_ServiceDate.MovementId  <> 24813367
                              )
     --  сотрудники у который в др. ведомостях выдан аванс
     , tmpMI_Avance AS (SELECT DISTINCT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                        FROM tmpMovement_Avance AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                             INNER JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                          ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc() --zc_MIFloat_SummAvanceRecalc()
                                                         AND COALESCE (MIFloat_SummCardRecalc.ValueData,0) <> 0
                             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                  ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                 AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                       )

     , tmpMemberGroup AS (SELECT tmpMIAll.MemberId
                               , SUM (COALESCE (tmpMIAll.Amount,0)) AS Amount 
                          FROM tmpMIAll
                              LEFT JOIN tmpSkip ON tmpSkip.MemberId = tmpMIAll.MemberId
                              LEFT JOIN tmpMI_Avance ON tmpMI_Avance.MemberId = tmpMIAll.MemberId

                          WHERE tmpSkip.MemberId IS NULL                                                    -- если в этом периоде в табеле есть хоть один прогул  
                            AND tmpMI_Avance.MemberId IS NULL                                               -- исключить сотрудников, у которых найдены ведомости с заполненным св-вом zc_MIFloat_SummCardRecalc
                          GROUP BY tmpMIAll.MemberId
                          )
  
       SELECT tmpMemberGroup.MemberId
            , tmpPersonal.PersonalId
            , tmpPersonal.PositionId
            , tmpPersonal.UnitId
            , tmpPersonal.PersonalServiceListId
            , tmpPersonal.isMain
            , tmpMemberGroup.Amount AS SumAmount 
       FROM tmpMemberGroup
           JOIN tmpPersonal ON tmpPersonal.MemberId = tmpMemberGroup.MemberId
          
           LEFT JOIN ObjectBoolean AS ObjectBoolean_AvanceNot
                                   ON ObjectBoolean_AvanceNot.ObjectId = tmpPersonal.PersonalServiceListId
                                  AND ObjectBoolean_AvanceNot.DescId = zc_ObjectBoolean_PersonalServiceList_AvanceNot() 
                                                                   
       WHERE COALESCE (ObjectBoolean_AvanceNot.ValueData,FALSE) = FALSE                  -- исключить сотрудников, у которых основная ведомость начисления - zc_ObjectBoolean_PersonalServiceList_AvanceNot
         AND ( tmpPersonal.DateOut >=(DATE_TRUNC ('MONTH', inEndDate ::TDatetime) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'))    --исключить если в этом периоде сотрудн уволен , т.е. проверка zc_ObjectDate_Personal_Out   , те.е дата увольнения вне периода  
       ;

    ----исключить сотрудников, у которых найдены ведомости с заполненным св-вом zc_MIFloat_SummCardRecalc
    
    
    
     -- добавиляем новые строки и обновляем существующие
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                    := COALESCE (tmpMI.Id,0)                                  ::Integer
                                                        , inMovementId            := inMovementId                                           ::Integer
                                                        , inPersonalId            := tmpData.PersonalId                                     ::Integer
                                                        , inIsMain                := COALESCE (tmpData.isMain, tmpMI.isMain)                ::Boolean
                                                        , inSummService           := 0                                                      ::TFloat
                                                        , inSummCardRecalc        := COALESCE (tmpMI.SummCardRecalc,0)                      ::TFloat
                                                        , inSummCardSecondRecalc  := COALESCE (tmpMI.SummCardSecondRecalc,0)                ::TFloat
                                                        , inSummCardSecondCash    := COALESCE (tmpMI.SummCardSecondCash,0)                  ::TFloat
                                                        , inSummNalogRecalc       := COALESCE (tmpMI.SummNalogRecalc,0)                     ::TFloat
                                                        , inSummNalogRetRecalc    := 0                                                      ::TFloat
                                                        , inSummMinus             := COALESCE (tmpMI.SummMinus,0)                           ::TFloat
                                                        , inSummAdd               := COALESCE (tmpMI.SummAdd,0)                             ::TFloat
                                                        , inSummAddOthRecalc      := COALESCE (tmpMI.SummAddOthRecalc,0)                    ::TFloat
                                                        , inSummHoliday           := COALESCE (tmpMI.SummHoliday,0)                         ::TFloat
                                                        , inSummSocialIn          := COALESCE (tmpMI.SummSocialIn,0)                        ::TFloat
                                                        , inSummSocialAdd         := COALESCE (tmpMI.SummSocialAdd,0)                       ::TFloat
                                                        , inSummChildRecalc       := COALESCE (tmpMI.SummChildRecalc,0)                     ::TFloat
                                                        , inSummMinusExtRecalc    := COALESCE (tmpMI.SummMinusExtRecalc,0)                  ::TFloat
                                                        , inSummFine              := COALESCE (tmpMI.SummFine,0)                            ::TFloat
                                                        , inSummFineOthRecalc     := COALESCE (tmpMI.SummFineOthRecalc,0)                   ::TFloat
                                                        , inSummHosp              := COALESCE (tmpMI.SummHosp,0)                            ::TFloat
                                                        , inSummHospOthRecalc     := COALESCE (tmpMI.SummHospOthRecalc,0)                   ::TFloat
                                                        , inSummCompensationRecalc:= COALESCE (tmpMI.SummCompensationRecalc,0)              ::TFloat
                                                        , inSummAuditAdd          := COALESCE (tmpMI.SummAuditAdd,0)                        ::TFloat
                                                        , inSummHouseAdd          := COALESCE (tmpMI.SummHouseAdd,0)                        ::TFloat 
                                                        , inSummAvanceRecalc      := vbSummAvance                                           ::TFloat
                                                        , inNumber                := COALESCE (tmpMI.Number,'')                             ::TVarChar
                                                        , inComment               := COALESCE (tmpMI.Comment, '')                           ::TVarChar
                                                        , inInfoMoneyId           := COALESCE (tmpMI.InfoMoneyId, zc_Enum_InfoMoney_60101())  ::Integer
                                                        , inUnitId                := COALESCE (tmpData.UnitId, tmpMI.UnitId)         ::Integer
                                                        , inPositionId            := COALESCE (tmpData.PositionId, tmpMI.PositionId) ::Integer
                                                        , inMemberId              := 0                                                      ::Integer    --COALESCE (tmpMemberMinus.MemberId, tmpMI.MemberId) 
                                                        , inPersonalServiceListId := COALESCE (tmpData.PersonalServiceListId, tmpMI.PersonalServiceListId) :: Integer
                                                        , inFineSubjectId         := COALESCE (tmpMI.FineSubjectId,0)                       ::Integer
                                                        , inUnitFineSubjectId     := COALESCE (tmpMI.UnitFineSubjectId,0)                   ::Integer
                                                        , inUserId                := vbUserId
                                                      ) 
     FROM tmpData
          LEFT JOIN tmpMI ON tmpMI.PersonalId = tmpData.PersonalId
                         AND tmpMI.MemberId_Personal = tmpData.MemberId
                         AND tmpMI.PositionId = tmpData.PositionId
                         AND tmpMI.UnitId = tmpData.UnitId
     WHERE tmpData.SumAmount >= vbHourAvance
       AND COALESCE (tmpMI.SummAvanceRecalc,0) = 0     
     ;
     
     --
     -- сохранили свойство <Протокол Дата/время начало>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartBegin(), inMovementId, inStartDate);
     -- сохранили свойство <Протокол Дата/время окончание>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), inMovementId, inEndDate); 
     
     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);
     -- сохранили свойство <Месяц начислений>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), inMovementId, inServiceDate);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     
     if (vbUserId = 5 OR vbUserId = 9457) AND 1=1
then
    RAISE EXCEPTION 'Admin - Errr _end - <%>', (SELECT COUNT(*) FROM tmpData WHERE tmpData.SumAmount >= vbHourAvance);
    -- 'Повторите действие через 3 мин.'
end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.03.23         *
*/

-- тест
-- 
-- Function: gpUpdate_MI_PersonalService_Compensation()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_Compensation (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_Compensation(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPersonalServiceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;

     -- определяем <Месяц начислений>
     vbOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate());

     -- определяем <Ведомости> - что б выбрать только этих Сотрудников
     CREATE TEMP TABLE _tmpList ON COMMIT DROP
       AS (SELECT OFl.ObjectId AS PersonalServiceListId
           FROM ObjectFloat AS OFl
           WHERE OFl.ValueData = EXTRACT (MONTH FROM vbOperDate)
             AND OFl.DescId    = zc_ObjectFloat_PersonalServiceList_Compensation()
          );

     -- данные - MovementItem
     CREATE TEMP TABLE _tmpMI ON COMMIT DROP
       AS (WITH -- текущие элементы
                tmpMI AS (SELECT MovementItem.Id                                        AS MovementItemId
                               , MovementItem.ObjectId                                  AS PersonalId
                               , MILinkObject_Unit.ObjectId                             AS UnitId
                               , MILinkObject_Position.ObjectId                         AS PositionId
                               , ObjectLink_Personal_Member.ChildObjectId               AS MemberId
                               , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId /*MovementItem.ObjectId*/, MILinkObject_Unit.ObjectId, MILinkObject_Position.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                    ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                   AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
      , tmpReport_all AS (SELECT tmpReport.*
                          FROM gpReport_HolidayCompensation (inStartDate:= DATE_TRUNC ('YEAR', vbOperDate) - INTERVAL '1 DAY'
                                                           , inUnitId   := 0
                                                           , inMemberId := 0
                                                           , inSession  := inSession
                                                            ) AS tmpReport
                         )
           -- Результат
           SELECT COALESCE (tmpMI.MovementItemId, 0) :: Integer AS MovementItemId
                , COALESCE (tmpReport_all.MemberId,   tmpMI.MemberId)   AS MemberId
                , COALESCE (tmpReport_all.PersonalId, tmpMI.PersonalId) AS PersonalId
                , COALESCE (tmpReport_all.PositionId, tmpMI.PositionId) AS PositionId
                , COALESCE (tmpReport_all.UnitId,     tmpMI.UnitId)     AS UnitId
                , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId
                , ObjectBoolean_Personal_Main.ValueData                 AS isMain
                , zc_Enum_InfoMoney_60101()                             AS InfoMoneyId -- 60101 Заработная плата + Заработная плата
                  -- Положено дней отпуска
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN COALESCE (tmpReport_all.Day_vacation, 0) ELSE 0 END AS Day_vacation
                  -- использовано дней отпуска
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN COALESCE (tmpReport_all.Day_holiday, 0) ELSE 0 END AS Day_holiday
                  -- дней компенсации
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN COALESCE (tmpReport_all.Day_diff, 0) ELSE 0 END AS Day_diff
                  -- Рабочих дней
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN COALESCE (tmpReport_all.Day_calendar, 0) ELSE 0 END AS Day_calendar
                  -- Ср. ЗП за день
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 THEN COALESCE (tmpReport_all.AmountCompensation, 0) ELSE 0 END AS AmountCompensation
           FROM tmpReport_all
                FULL JOIN tmpMI ON tmpMI.MemberId   = tmpReport_all.MemberId
                               AND tmpMI.PersonalId = tmpReport_all.PersonalId
                               AND tmpMI.PositionId = tmpReport_all.PositionId
                               AND tmpMI.UnitId     = tmpReport_all.UnitId
                LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                     ON ObjectLink_Personal_PersonalServiceList.ObjectId = COALESCE (tmpReport_all.PersonalId, tmpMI.PersonalId)
                                    AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                        ON ObjectBoolean_Personal_Main.ObjectId = COALESCE (tmpReport_all.PersonalId, tmpMI.PersonalId)
                                       AND ObjectBoolean_Personal_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                INNER JOIN _tmpList ON _tmpList.PersonalServiceListId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
          );

     UPDATE _tmpMI SET MovementItemId = lpInsertUpdate_MovementItem_PersonalService_item
                                                         (ioId                 := _tmpMI.MovementItemId
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := _tmpMI.PersonalId
                                                        , inIsMain             := _tmpMI.isMain
                                                        , inSummService        := 0
                                                        , inSummCardRecalc     := 0
                                                        , inSummCardSecondRecalc:=0
                                                        , inSummCardSecondCash := 0
                                                        , inSummNalogRecalc    := 0
                                                        , inSummNalogRetRecalc := 0
                                                        , inSummMinus          := 0
                                                        , inSummAdd            := 0
                                                        , inSummAddOthRecalc   := 0
                                                        , inSummHoliday        := 0
                                                        , inSummSocialIn       := 0
                                                        , inSummSocialAdd      := 0
                                                        , inSummChildRecalc    := 0
                                                        , inSummMinusExtRecalc := 0
                                                        , inSummFine           := 0
                                                        , inSummFineOthRecalc  := 0
                                                        , inSummHosp           := 0
                                                        , inSummHospOthRecalc  := 0
                                                        , inSummCompensationRecalc := COALESCE (_tmpMI.Day_diff * _tmpMI.AmountCompensation, 0.0)
                                                        , inComment            := ''
                                                        , inInfoMoneyId        := _tmpMI.InfoMoneyId
                                                        , inUnitId             := _tmpMI.UnitId
                                                        , inPositionId         := _tmpMI.PositionId
                                                        , inMemberId           := NULL
                                                        , inPersonalServiceListId := _tmpMI.PersonalServiceListId
                                                        , inUserId             := vbUserId
                                                         )
     WHERE _tmpMI.Day_diff > 0 OR _tmpMI.MovementItemId > 0;
                                                         
                                                              -- сохраняем элементы
     PERFORM -- Положено дней отпуска
             lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayVacation(), _tmpMI.MovementItemId, _tmpMI.Day_vacation)
             -- использовано дней отпуска
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayHoliday(), _tmpMI.MovementItemId, _tmpMI.Day_holiday)
             -- дней компенсации - кол-во дней отпуска за которые компенсация
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayCompensation(), _tmpMI.MovementItemId, _tmpMI.Day_diff)
             -- Рабочих дней
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayWork(), _tmpMI.MovementItemId, _tmpMI.Day_calendar)
             --  средняя зп для расчета суммы компенсации
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceCompensation(), _tmpMI.MovementItemId, _tmpMI.AmountCompensation)
             -- сумма компенсации
         --, lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensationRecalc(), _tmpMI.MovementItemId, (_tmpMI.Day_diff * _tmpMI.AmountCompensation))
     FROM _tmpMI
     WHERE _tmpMI.Day_diff > 0
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.20         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_PersonalService_Compensation (inMovementId:= 15739024, inSession:= zfCalc_UserAdmin())

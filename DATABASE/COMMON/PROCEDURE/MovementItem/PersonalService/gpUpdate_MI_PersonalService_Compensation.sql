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

     -- определяем <Ведомость> - что б выбрать только этих Сотрудников
     vbPersonalServiceListId := (SELECT MLO_PersonalServiceList.ObjectId 
                                 FROM MovementLinkObject AS MLO_PersonalServiceList
                                 WHERE MLO_PersonalServiceList.MovementId = inMovementId
                                   AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList());

     -- данные - MovementItem
     CREATE TEMP TABLE _tmpMI (MovementItemId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, Day_diff TFloat, AmountCompensation TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpMI (MovementItemId, PersonalId, PositionId, UnitId,  Day_diff, AmountCompensation)
     WITH 
          -- текущие элементы
          tmpMI AS (SELECT MovementItem.Id                                        AS MovementItemId
                         , MovementItem.ObjectId                                  AS PersonalId
                         , MILinkObject_Unit.ObjectId                             AS UnitId
                         , MILinkObject_Position.ObjectId                         AS PositionId
                         , ObjectLink_Personal_Member.ChildObjectId               AS MemberId
                         , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Unit.ObjectId, MILinkObject_Position.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                          ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                          ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()

                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                              ON ObjectLink_Personal_Member.ChildObjectId = tmpPersonal_all.MemberId
                                             AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                   )
        , tmpReport AS (SELECT tmpMI.MovementItemId
                             , tmp.MemberId
                             , tmp.PersonalId
                             , tmp.PositionId
                             , tmp.UnitId
                             , tmp.Day_vacation       -- Положено дней отпуска
                             , tmp.Day_holiday        -- использовано 
                             , tmp.Day_diff           -- не использовано   
                             , tmp.Day_calendar       -- Рабоч. дней
                             , tmp.AmountCompensation -- Ср. ЗП за день
                          FROM tmpMI
                               LEFT JOIN gpReport_HolidayCompensation (inStartDate:= vbOperDate, inUnitId:= tmpMI.UnitId, inMemberId:= tmpMIюMemberId, inSession:= inSession) AS tmp
                          WHERE tmpMI.Ord = 1
                         )
            SELECT tmp.MovementItemId
                 , tmp.PersonalId
                 , tmp.PositionId
                 , tmp.UnitId
                 , tmp.Day_diff           -- не использовано   
                 , tmp.AmountCompensation -- средняя зп для расчета суммы компенсации            
            FROM tmpReport AS tmp;
 
     -- сохраняем элементы
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensation(), _tmpMI.MovementItemId, (_tmpMI.Day_diff * _tmpMI.AmountCompensation))  --сумма компенсации
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayCompensation(), _tmpMI.MovementItemId, _tmpMI.Day_diff )                                -- дней компенсации
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceCompensation(), _tmpMI.MovementItemId, _tmpMI.AmountCompensatio))                     -- Ср. ЗП за день
     FROM _tmpMI;
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.20
*/

-- тест
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId :=0, inSession :='3':: TVarChar)

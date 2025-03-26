-- Function: gpInsertUpdate_MI_PersonalService_Child_Erased()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Erased (Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Erased (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_Erased(
    IN inUnitId                Integer   , -- подразделение
    IN inPersonalServiceListId Integer   , -- ведомость начисления
    IN inStartDate             TDateTime , -- дата
    IN inEndDate               TDateTime , -- дата
    IN inPositionId            Integer   , -- если = 0, тогда удалять все, иначе - только эту должность
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);

     
     inPositionId := COALESCE (inPositionId, 0);

     -- проверка
     IF COALESCE (inPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Ведомость Начисления>.';
     END IF;


if vbUserId = 5 
then
    -- поиск документа (ключ - Месяц начислений + ведомость) - ТОЛЬКО ОДИН
    vbMovementId:= (SELECT MovementDate_ServiceDate.MovementId
                    FROM MovementDate AS MovementDate_ServiceDate
                         INNER JOIN Movement ON Movement.Id       = MovementDate_ServiceDate.MovementId
                                            AND Movement.DescId   = zc_Movement_PersonalService()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                            -- AND Movement.OperDate >= inEndDate
                         INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                       ON MLO_PersonalServiceList.MovementId = Movement.Id
                                                      AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                      AND MLO_PersonalServiceList.ObjectId   = inPersonalServiceListId
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Child()
                                                AND MovementItem.isErased   = FALSE

                         LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                                   ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                  AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                    WHERE MovementDate_ServiceDate.ValueData = DATE_TRUNC ('MONTH', inEndDate)  + INTERVAL '0 MONTH'
                      AND MovementDate_ServiceDate.DescId    = zc_MovementDate_ServiceDate()
                    ORDER BY CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 0 ELSE 1 END, MovementDate_ServiceDate.MovementId
                    LIMIT 1
                   );
    -- RAISE EXCEPTION 'Ошибка.%  %', (select InvNumber from Movement where Movement.Id = vbMovement),  (select OperDate from Movement where Movement.Id = vbMovement);
else
    -- поиск документа (ключ - Месяц начислений + ведомость) - ТОЛЬКО ОДИН
    vbMovementId:= (SELECT MovementDate_ServiceDate.MovementId
                    FROM MovementDate AS MovementDate_ServiceDate
                         INNER JOIN Movement ON Movement.Id       = MovementDate_ServiceDate.MovementId
                                            AND Movement.DescId   = zc_Movement_PersonalService()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                            --AND Movement.OperDate >= inEndDate
                         INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                       ON MLO_PersonalServiceList.MovementId = Movement.Id
                                                      AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                      AND MLO_PersonalServiceList.ObjectId   = inPersonalServiceListId
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Child()
                                                AND MovementItem.isErased   = FALSE

                         LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                                   ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                  AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                    WHERE MovementDate_ServiceDate.ValueData = DATE_TRUNC ('MONTH', inEndDate)
                      AND MovementDate_ServiceDate.DescId    = zc_MovementDate_ServiceDate()
                    ORDER BY CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 0 ELSE 1 END, MovementDate_ServiceDate.MovementId
                    LIMIT 1
                   );
end if;
                   


      IF vbMovementId > 0
      THEN
          -- обнулим
          PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                     := MovementItem.Id
                                                             , inMovementId             := vbMovementId
                                                             , inPersonalId             := MovementItem.ObjectId
                                                             , inIsMain                 := MIBoolean_Main.ValueData
                                                             , inSummService            := 0 -- !!!обнулим сумму!!!
                                                             , inSummCardRecalc         := 0
                                                             , inSummCardSecondRecalc   := 0
                                                             , inSummCardSecondCash     := COALESCE (MIFloat_SummCardSecondCash.ValueData, 0)
                                                             , inSummNalogRecalc        := 0
                                                             , inSummNalogRetRecalc     := 0
                                                             , inSummMinus              := COALESCE (MIFloat_SummMinus.ValueData, 0)
                                                             , inSummAdd                := COALESCE (MIFloat_SummAdd.ValueData, 0)
                                                             , inSummAddOthRecalc       := COALESCE (MIFloat_SummAddOthRecalc.ValueData, 0)
                                                             , inSummHoliday            := COALESCE (MIFloat_SummHoliday.ValueData, 0)
                                                             , inSummSocialIn           := COALESCE (MIFloat_SummSocialIn.ValueData, 0)
                                                             , inSummSocialAdd          := COALESCE (MIFloat_SummSocialAdd.ValueData, 0)
                                                             , inSummChildRecalc        := 0
                                                             , inSummMinusExtRecalc     := 0
                                                             , inSummFine               := 0
                                                             , inSummFineOthRecalc      := 0
                                                             , inSummHosp               := 0
                                                             , inSummHospOthRecalc      := 0
                                                             , inSummCompensationRecalc := 0
                                                             , inSummAuditAdd           := COALESCE (MIFloat_SummAuditAdd.ValueData, 0)
                                                             , inSummHouseAdd           := COALESCE (MIFloat_SummHouseAdd.ValueData, 0) 
                                                             , inSummAvanceRecalc       := COALESCE (MIFloat_SummAvanceRecalc.ValueData,0)
                                                             , inNumber                 := MIString_Number.ValueData ::TVarChar
                                                             , inComment                := MIString_Comment.ValueData
                                                             , inInfoMoneyId            := MILinkObject_InfoMoney.ObjectId
                                                             , inUnitId                 := MILinkObject_Unit.ObjectId
                                                             , inPositionId             := MILinkObject_Position.ObjectId
                                                             , inMemberId               := MILinkObject_Member.ObjectId
                                                             , inPersonalServiceListId  := MILinkObject_PersonalServiceList.ObjectId
                                                             , inFineSubjectId          := COALESCE (MILinkObject_FineSubject.ObjectId,0)::Integer
                                                             , inUnitFineSubjectId      := COALESCE (MILinkObject_UnitFineSubject.ObjectId,0)::Integer
                                                             , inUserId                 := vbUserId
                                                              )
          FROM MovementItem
               INNER JOIN MovementItemBoolean AS MIBoolean_isAuto
                                              ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                             AND MIBoolean_isAuto.DescId         = zc_MIBoolean_isAuto()
                                             AND MIBoolean_isAuto.ValueData      = TRUE
                -- ограничиваем подразделением
               INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                 ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                                AND MILinkObject_Unit.ObjectId       = inUnitId
                -- ограничиваем должностью, если <> 0
               INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                                               AND (MILinkObject_Position.ObjectId      = inPositionId OR inPositionId = 0)

               LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                             ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                            AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()
               LEFT JOIN MovementItemString AS MIString_Number
                                            ON MIString_Number.MovementItemId = MovementItem.Id
                                           AND MIString_Number.DescId = zc_MIString_Number()

               LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                           ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummService.DescId = zc_MIFloat_SummService()

               LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                           ON MIFloat_SummCardSecondCash.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()
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

               LEFT JOIN MovementItemFloat AS MIFloat_SummAvanceRecalc
                                           ON MIFloat_SummAvanceRecalc.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummAvanceRecalc.DescId = zc_MIFloat_SummAvanceRecalc()

               LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                               AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()

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
          WHERE MovementItem.MovementId = vbMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE
            -- может так будет быстрее, если уже 1 раз обнулили ...
            AND MIFloat_SummService.ValueData <> 0
           ;


          -- удалим
          PERFORM lpSetErased_MovementItem (inMovementItemId:= tmp.Id
                                          , inUserId        := vbUserId
                                           ) 
                , lpInsert_MovementItemProtocol (tmp.Id, vbUserId, FALSE)
          FROM (WITH tmpMI_Master AS (SELECT MovementItem.Id
                                      FROM MovementItem
                                           -- удаляем только чайлды у которых в мастере тек. подразделение
                                           INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                                                            AND MILinkObject_Unit.ObjectId       = inUnitId
                                           -- удаляем только чайлды у которых в мастере тек. подразделение и выбранная должность , если =0 то все
                                           INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                                                                            AND (MILinkObject_Position.ObjectId      = inPositionId OR inPositionId = 0)

                                      WHERE MovementItem.MovementId = vbMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                                     )

                SELECT MovementItem.Id
                FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementId
                  AND MovementItem.DescId     = zc_MI_Child()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.ParentId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
               ) AS tmp;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.12.21         * add Number
 25.03.20         * SummAuditAdd
 17.11.19         * ограничиваем должностью
 15.10.19         *
 10.01.19         * ограничиваем подразделением
 05.01.18         *
 24.07.17                                        *
*/

-- тест
-- select * from gpInsertUpdate_MI_PersonalService_Child_Erased (inUnitId := 183292, inPersonalServiceListId := 0, inStartDate := ('01.06.2016')::TDateTime, inEndDate := ('01.06.2016')::TDateTime, inPositionId := 0, inSession := '3');

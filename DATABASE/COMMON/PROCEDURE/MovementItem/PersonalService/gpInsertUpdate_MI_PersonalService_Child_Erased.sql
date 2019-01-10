-- Function: gpInsertUpdate_MI_PersonalService_Child_Erased()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Erased (Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_Erased(
    IN inUnitId                Integer   , -- подразделение
    IN inPersonalServiceListId Integer   , -- ведомость начисления
    IN inStartDate             TDateTime , -- дата
    IN inEndDate               TDateTime , -- дата
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

     -- проверка
     IF COALESCE (inPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Ведомость Начисления>.';
     END IF;


    -- поиск документа (ключ - Месяц начислений + ведомость) - ТОЛЬКО ОДИН
    vbMovementId:= (SELECT MovementDate_ServiceDate.MovementId
                    FROM MovementDate AS MovementDate_ServiceDate
                         INNER JOIN Movement ON Movement.Id       = MovementDate_ServiceDate.MovementId
                                            AND Movement.DescId   = zc_Movement_PersonalService()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
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
                                                             , inSummCardSecondCash     := MIFloat_SummCardSecondCash.ValueData
                                                             , inSummNalogRecalc        := 0
                                                             , inSummNalogRetRecalc     := 0
                                                             , inSummMinus              := MIFloat_SummMinus.ValueData
                                                             , inSummAdd                := MIFloat_SummAdd.ValueData
                                                             , inSummAddOthRecalc       := MIFloat_SummAddOthRecalc.ValueData
                                                             , inSummHoliday            := MIFloat_SummHoliday.ValueData
                                                             , inSummSocialIn           := MIFloat_SummSocialIn.ValueData
                                                             , inSummSocialAdd          := MIFloat_SummSocialAdd.ValueData
                                                             , inSummChildRecalc        := 0
                                                             , inSummMinusExtRecalc     := 0
                                                             , inComment                := MIString_Comment.ValueData
                                                             , inInfoMoneyId            := MILinkObject_InfoMoney.ObjectId
                                                             , inUnitId                 := MILinkObject_Unit.ObjectId
                                                             , inPositionId             := MILinkObject_Position.ObjectId
                                                             , inMemberId               := MILinkObject_Member.ObjectId
                                                             , inPersonalServiceListId  := MILinkObject_PersonalServiceList.ObjectId
                                                             , inUserId                 := vbUserId
                                                              )
          FROM MovementItem
               INNER JOIN MovementItemBoolean AS MIBoolean_isAuto
                                              ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                             AND MIBoolean_isAuto.DescId         = zc_MIBoolean_isAuto()
                                             AND MIBoolean_isAuto.ValueData      = TRUE
               LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                             ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                            AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

               LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                           ON MIFloat_SummCardSecondCash.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()
               LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                           ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
               LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                           ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                          AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
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

               LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                               AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
               LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
               LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Member.DescId         = zc_MILinkObject_Member()
               LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                               AND MILinkObject_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()

          WHERE MovementItem.MovementId = vbMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;


          -- удалим
          PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                          , inUserId        := vbUserId
                                           )
          FROM MovementItem
          WHERE MovementItem.MovementId = vbMovementId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.01.18         *
 24.07.17                                        *
*/

-- тест
-- select * from gpInsertUpdate_MI_PersonalService_Child_Erased (inFromId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');

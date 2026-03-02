-- Function: gpUpdateMovement_OrderFinance_AllSignSB()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_AllSignSB (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_AllSignSB(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inStartWeekNumber   Integer   , --
    IN inEndWeekNumber     Integer   , -- временно, только 1 неделя
    IN inIsSignSB          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     --
     CREATE TEMP TABLE _tmpMovement ON COMMIT DROP
        AS (WITH
            tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                   UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                          )
            SELECT Movement.Id AS MovementId
            FROM Movement
                 INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                          ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                         AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
                                         AND MovementFloat_WeekNumber.ValueData BETWEEN inStartWeekNumber AND inEndWeekNumber
                INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                              ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                             AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                -- 
                LEFT JOIN ObjectBoolean  AS ObjectBoolean_SB
                                         ON ObjectBoolean_SB.ObjectId = MovementLinkObject_OrderFinance.ObjectId
                                        AND ObjectBoolean_SB.DescId = zc_ObjectBoolean_OrderFinance_SB()

            WHERE Movement.DescId = zc_Movement_OrderFinance()
              AND Movement.StatusId IN (SELECT tmpStatus.StatusId FROM tmpStatus)
              AND Movement.OperDate BETWEEN inStartDate - INTERVAL '14 DAY' AND inEndDate
              -- только те виды планировани, где нужно согласовывать СБ
              AND ObjectBoolean_SB.ValueData = TRUE
           );


     -- Проверка
     IF EXISTS (SELECT 1
                    FROM MovementItem
                    WHERE MovementItem.DescId = zc_MI_Detail()
                      AND MovementItem.MovementId IN (SELECT DISTINCT _tmpMovement.MovementId FROM _tmpMovement)
                      AND MovementItem.isErased   = FALSE
                    )
     THEN
          RAISE EXCEPTION 'Ошибка.Нет прав для исправлений.В документе найдены исправления финонсовой службой .';
     END IF;


     --
     -- сохранили свойство  <Виза СБ>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SignSB(), _tmpMovement.MovementId, inIsSignSB)
     FROM _tmpMovement;
     

     IF inIsSignSB = TRUE
     THEN
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), _tmpMovement.MovementId, CURRENT_TIMESTAMP)
         FROM _tmpMovement;

         -- сохранили <Платежный план на неделю>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_next(), MovementItem.Id, CASE WHEN MIBoolean_Sign.ValueData = TRUE THEN MovementItem.Amount ELSE 0 END)
         FROM MovementItem
              LEFT JOIN MovementItemBoolean AS MIBoolean_Sign
                                            ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                           AND MIBoolean_Sign.DescId         = zc_MIBoolean_Sign()
         WHERE MovementItem.MovementId IN (SELECT  DISTINCT _tmpMovement.MovementId FROM _tmpMovement)
           AND MovementItem.DescId     = zc_MI_Child()
           AND MovementItem.isErased   = FALSE
          ;

     ELSE
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), _tmpMovement.MovementId, NULL ::TDateTime)
         FROM _tmpMovement;

         -- обнулили <Платежный план на неделю>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_next(), MovementItem.Id, 0)
         FROM MovementItem
         WHERE MovementItem.MovementId IN (SELECT  DISTINCT _tmpMovement.MovementId FROM _tmpMovement)
           AND MovementItem.DescId     = zc_MI_Child()
           AND MovementItem.isErased   = FALSE
          ;

     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (_tmpMovement.MovementId)
     FROM _tmpMovement;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (_tmpMovement.MovementId, vbUserId, FALSE)
     FROM _tmpMovement;

     --
     if vbUserId IN (-5, 9457) THEN RAISE EXCEPTION 'Админ.Test Ok. <%>  <%>  <%>'
                                                  , inStartWeekNumber
                                                  , inEndWeekNumber
                                                  , (SELECT SUM (COALESCE (MIF.ValueData, 0))
                                                     FROM MovementItem
                                                          LEFT JOIN MovementItemFloat AS MIF
                                                                                        ON MIF.MovementItemId = MovementItem.Id
                                                                                       AND MIF.DescId         = zc_MIFloat_AmountPlan_next()
                                                     WHERE MovementItem.MovementId IN (SELECT  DISTINCT _tmpMovement.MovementId FROM _tmpMovement)
                                                       AND MovementItem.DescId     = zc_MI_Child()
                                                       AND MovementItem.isErased   = FALSE
                                                    )
                                                   ;
     end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.02.26                                        *
*/


-- тест
-- select * from gpUpdateMovement_OrderFinance_AllSignSB (inStartDate := ('27.10.2025')::TDateTime , inEndDate := ('27.10.2025')::TDateTime , inStartWeekNumber := 2 , inEndWeekNumber := 2 , inIsSignSB := 'True' ,  inSession := '9457');

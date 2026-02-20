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

     --
     -- сохранили свойство  <Виза СБ>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SignSB(), _tmpMovement.MovementId, inIsSignSB)
     FROM _tmpMovement;
     

     IF inIsSignSB = TRUE
     THEN
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), _tmpMovement.MovementId, CURRENT_TIMESTAMP)
         FROM _tmpMovement;

         -- сохранили <Итого>
         PERFORM lpInsertUpdate_MovementItem (tmpMI.Id, zc_MI_Master(), tmpMI.ObjectId, tmpMI.MovementId, tmpMI.Amount_sum, tmpMI.ParentId)
                 -- пн.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_1(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 1 THEN tmpMI.Amount_sum ELSE 0 END)
                 -- вт.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_2(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 2 THEN tmpMI.Amount_sum ELSE 0 END)
                 -- ср.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_3(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 3 THEN tmpMI.Amount_sum ELSE 0 END)
                 -- чт.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_4(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 4 THEN tmpMI.Amount_sum ELSE 0 END)
                 -- пт.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_5(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 5 THEN tmpMI.Amount_sum ELSE 0 END)

         FROM (WITH tmpMI_child AS (SELECT MovementItem.MovementId
                                         , MovementItem.ParentId
                                         , SUM (MovementItem.Amount) AS Amount_sum
                                    FROM MovementItem
                                          INNER JOIN MovementItemBoolean AS MIBoolean_Sign
                                                                         ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                                                        AND MIBoolean_Sign.DescId         = zc_MIBoolean_Sign()
                                                                        AND MIBoolean_Sign.ValueData      = TRUE
                                    WHERE MovementItem.MovementId IN (SELECT  DISTINCT _tmpMovement.MovementId FROM _tmpMovement)
                                      AND MovementItem.DescId     = zc_MI_Child()
                                      AND MovementItem.isErased   = FALSE
                                    GROUP BY MovementItem.ParentId
                                           , MovementItem.MovementId
                                   )
               SELECT MovementItem.*
                    , COALESCE (tmpMI_child.Amount_sum, 0) AS Amount_sum
                    , MovementItemDate_Amount.ValueData AS OperDate_amount
               FROM MovementItem
                    LEFT JOIN tmpMI_child ON tmpMI_child.ParentId = MovementItem.Id
                    LEFT JOIN MovementItemDate AS MovementItemDate_Amount
                                               ON MovementItemDate_Amount.MovementItemId = MovementItem.Id
                                              AND MovementItemDate_Amount.DescId         = zc_MIDate_Amount()

               WHERE MovementItem.MovementId IN (SELECT  DISTINCT _tmpMovement.MovementId FROM _tmpMovement)
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.iseRased   = FALSE
              ) AS tmpMI
          ;

     ELSE
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), _tmpMovement.MovementId, NULL ::TDateTime)
         FROM _tmpMovement;

         -- сохранили <Итого>
         PERFORM lpInsertUpdate_MovementItem (tmpMI.Id, zc_MI_Master(), tmpMI.ObjectId, tmpMI.MovementId, tmpMI.Amount_child, tmpMI.ParentId)
         FROM (WITH tmpMI_child AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                    FROM MovementItem
                                    WHERE MovementItem.MovementId IN (SELECT DISTINCT _tmpMovement.MovementId FROM _tmpMovement)
                                      AND MovementItem.DescId     = zc_MI_Child()
                                      AND MovementItem.isErased   = FALSE
                                    GROUP BY MovementItem.ParentId
                                   )
               SELECT MovementItem.*
                    , COALESCE (tmpMI_child.Amount, 0) AS Amount_child
               FROM MovementItem
                    LEFT JOIN tmpMI_child ON tmpMI_child.ParentId = MovementItem.Id
               WHERE MovementItem.MovementId IN (SELECT  DISTINCT _tmpMovement.MovementId FROM _tmpMovement)
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
              ) AS tmpMI;

     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (_tmpMovement.MovementId)
     FROM _tmpMovement;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (_tmpMovement.MovementId, vbUserId, FALSE)
     FROM _tmpMovement;

     --
     if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. <%>  <%>', inStartWeekNumber, inEndWeekNumber; end if;

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

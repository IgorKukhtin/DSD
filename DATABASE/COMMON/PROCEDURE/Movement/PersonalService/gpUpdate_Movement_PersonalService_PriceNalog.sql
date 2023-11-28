-- Function: gpUpdate_Movement_PersonalService_PriceNalog()

DROP FUNCTION IF EXISTS gpUpdate_Movement_PersonalService_PriceNalog (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_PersonalService_PriceNalog(
    IN inMovementId             Integer   , -- док. отпуска
    IN inPriceNalog             TFloat    , --
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd   TDateTime;
   DECLARE vbDayMonth  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());

     SELECT DATE_TRUNC ('MONTH', MovementDate_ServiceDate.ValueData)
          , DATE_TRUNC ('MONTH', MovementDate_ServiceDate.ValueData) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' 
          , (DATE_PART ('DAY', (DATE_TRUNC ('MONTH', MovementDate_ServiceDate.ValueData) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') :: TIMESTAMP - DATE_TRUNC ('MONTH', MovementDate_ServiceDate.ValueData) :: TIMESTAMP) + 1) 
   INTO vbDateStart, vbDateEnd, vbDayMonth
     FROM MovementDate AS MovementDate_ServiceDate
     WHERE MovementDate_ServiceDate.MovementId = inMovementId
       AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
     ;

     -- сохранили свойство Документа <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PriceNalog(), inMovementId, inPriceNalog);
     
     -- Сохранили свойства строк
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PriceNalog(), tmp.Id, CASE WHEN COALESCE (tmp.SummMinus,0) <> 0 THEN TRUE ELSE FALSE END)
           , lpInsertUpdate_MovementItemFloat   (zc_MIFloat_DayPriceNalog(), tmp.Id, tmp.DayPriceNalog)
           , lpInsertUpdate_MovementItemFloat   (zc_MIFloat_SummMinus(), tmp.Id, tmp.SummMinus)
     FROM (WITH
           tmpMI AS (SELECT tmp.* 
                          , ROW_NUMBER() OVER (PARTITION BY tmp.MemberId_Personal ORDER BY tmp.MemberId_Personal, tmp.isMain DESC, tmp.SummService DESC) AS Ord
                          , SUM (tmp.SummService) OVER(PARTITION BY tmp.MemberId_Personal) AS SummService_calc   -- сумма начислений по коду сотрудника в графе "Начисление" суммарно 
                     FROM gpSelect_MovementItem_PersonalService(inMovementId, FALSE, FALSE, inSession) AS tmp
                     )

         , tmpPersonal AS (SELECT tmpMI.Id 
                                , tmpMI.PersonalId
                                , tmpMI.SummNalog 
                                , tmpMI.SummService_calc
                                --, tmpMI.SummMinus
                                , (CASE WHEN ObjectDate_DateIn.ValueData >= vbDateStart AND ObjectDate_DateIn.ValueData <= vbDateEnd
                                             THEN ObjectDate_DateIn.ValueData
                                        ELSE vbDateStart
                                   END) :: TDateTime AS DateStart
                                , (CASE WHEN ObjectDate_DateOut.ValueData >= vbDateStart AND ObjectDate_DateOut.ValueData <= vbDateEnd
                                             THEN ObjectDate_DateOut.ValueData
                                        ELSE vbDateEnd
                                   END) :: TDateTime AS DateEnd
                           FROM tmpMI
                                LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                                     ON ObjectDate_DateIn.ObjectId = tmpMI.PersonalId
                                                    AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
                                LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                     ON ObjectDate_DateOut.ObjectId = tmpMI.PersonalId
                                                    AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()
                           WHERE tmpMI.Ord = 1
                           )
           SELECT tmpPersonal.*
                , (DATE_PART ('DAY', tmpPersonal.DateEnd :: TIMESTAMP - tmpPersonal.DateStart :: TIMESTAMP) + 1) ::TFloat AS DayPriceNalog
                , CASE WHEN COALESCE (tmpPersonal.SummService_calc,0) < 3400 THEN 0
                       WHEN tmpPersonal.SummNalog <> 0 THEN 0
                       ELSE CASE WHEN vbDayMonth <> 0
                                 THEN (inPriceNalog / vbDayMonth ) * (DATE_PART ('DAY', tmpPersonal.DateEnd :: TIMESTAMP - tmpPersonal.DateStart :: TIMESTAMP) + 1)
                                 ELSE 0
                            END
                  END ::TFloat AS SummMinus 
           FROM tmpPersonal
           ) AS tmp;

  
     IF vbUserId = '9457' 
     THEN
         --
         RAISE EXCEPTION 'Ошибка. Ставка налога <%>', inPriceNalog;
     END IF; 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.23         *
*/

-- тест
--
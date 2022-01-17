-- Function: gpInsertUpdate_Movement_WagesVIP_CalculationAllDay()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WagesVIP_CalculationAllDay (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WagesVIP_CalculationAllDay(
    IN inMovementId            Integer    , -- Ключ объекта <Документ продажи>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbOperDate    TDateTime;
   DECLARE vbStatusId    Integer;
   DECLARE vbTotalSummPhone   TFloat;
   DECLARE vbTotalSummSale    TFloat;
   DECLARE vbTotalSummSaleNP  TFloat;
   DECLARE vbHoursWork      TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WagesVIP());

    -- Провкряем элемент по документу
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Документ не сохранен';
    END IF;

      -- Получаем данные
    SELECT Movement.OperDate, Movement.StatusId
    INTO vbOperDate, vbStatusId
    FROM Movement
    WHERE Movement.Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF EXISTS(SELECT 1
              FROM  MovementItem
                   
                    INNER JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                   ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                                  AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()
                                                  AND MIBoolean_isIssuedBy.ValueData = TRUE

                                                    
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Ошибка. Зарплата выдана выполнения расчета запрещено.';
    END IF;
        
    -- Проведенные чеки
    CREATE TEMP TABLE tmpMovement ON COMMIT DROP AS
     (WITH tmpMovement AS (SELECT Movement.*
                                , MovementFloat_TotalSumm.ValueData                              AS TotalSumm
                                , COALESCE(MovementBoolean_CallOrder.ValueData,FALSE) :: Boolean AS isCallOrder
                                , False                                                          AS isOffsetVIP
                           FROM Movement

                                INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                          AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                          AND MovementBoolean_Deferred.ValueData = True

                                INNER JOIN MovementString AS MovementString_InvNumberOrder
                                                          ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                         AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                                                         AND MovementString_InvNumberOrder.ValueData <> ''

                                LEFT JOIN MovementBoolean AS MovementBoolean_CallOrder
                                                          ON MovementBoolean_CallOrder.MovementId = Movement.Id
                                                         AND MovementBoolean_CallOrder.DescId = zc_MovementBoolean_CallOrder()

                                LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                        ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                       AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                           WHERE Movement.OperDate >= DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '1 MONTH' + INTERVAL '4 DAY'
                             AND Movement.OperDate < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' + INTERVAL '4 DAY'
                             AND Movement.DescId = zc_Movement_Check()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                         UNION ALL
                         SELECT Movement.*
                              , MovementFloat_TotalSumm.ValueData                              AS TotalSumm
                              , False                                                          AS isCallOrder
                              , MovementBoolean_OffsetVIP.ValueData                            AS isOffsetVIP 
                         FROM Movement

                              INNER JOIN MovementBoolean AS MovementBoolean_OffsetVIP
                                                        ON MovementBoolean_OffsetVIP.MovementId = Movement.Id
                                                       AND MovementBoolean_OffsetVIP.DescId = zc_MovementBoolean_OffsetVIP()
                                                       AND MovementBoolean_OffsetVIP.ValueData = TRUE

                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                         
                         WHERE Movement.OperDate >= DATE_TRUNC ('MONTH', vbOperDate)
                           AND Movement.OperDate < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                           AND Movement.DescId = zc_Movement_Check()
                           AND Movement.StatusId = zc_Enum_Status_Complete())
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , CASE WHEN MIN(date_trunc('day', MovementProtocol.OperDate + INTERVAL '3 HOUR')) < DATE_TRUNC ('MONTH', vbOperDate)
                                                    AND date_trunc('day', Movement.OperDate) > DATE_TRUNC ('MONTH', vbOperDate)
                                                    AND date_trunc('day', Movement.OperDate) >= '01.01.2022'
                                                    OR Movement.isOffsetVIP = TRUE
                                               THEN date_trunc('day', Movement.OperDate)
                                               ELSE MIN(date_trunc('day', MovementProtocol.OperDate + INTERVAL '3 HOUR')) END   AS OperDate
                                   FROM tmpMovement AS Movement

                                        INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                   GROUP BY MovementProtocol.MovementId, date_trunc('day', Movement.OperDate), Movement.isOffsetVIP)

      SELECT tmpMovementProtocol.OperDate::TDateTime                                         AS OperDate
           , SUM(CASE WHEN Movement.isCallOrder = TRUE THEN Movement.TotalSumm END)::TFloat  AS SummPhone
           , SUM(CASE WHEN Movement.isCallOrder = FALSE THEN Movement.TotalSumm END)::TFloat AS SummSale
           , 0::TFloat                                                                       AS SummSaleNP
      FROM tmpMovement AS Movement
           INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.ID
      WHERE tmpMovementProtocol.OperDate >= DATE_TRUNC ('MONTH', vbOperDate)
        AND tmpMovementProtocol.OperDate < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
      GROUP BY tmpMovementProtocol.OperDate);

    -- Проведенные продажы "Новая почта"
    UPDATE tmpMovement SET SummSaleNP = COALESCE(MovementSale.TotalSumm, 0)
    FROM (WITH tmpMovement AS (SELECT date_trunc('day', Movement.OperDate)          AS OperDate
                                    , MovementFloat_TotalSumm.ValueData             AS TotalSumm
                               FROM Movement

                                    INNER JOIN MovementBoolean AS MovementBoolean_NP
                                                               ON MovementBoolean_NP.MovementId = Movement.Id
                                                              AND MovementBoolean_NP.DescId = zc_MovementBoolean_NP()
                                                              AND MovementBoolean_NP.ValueData = True

                                    LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                            ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                   /* LEFT JOIN MovementDate AS MovementDate_Insert
                                                           ON MovementDate_Insert.MovementId = Movement.Id
                                                          AND MovementDate_Insert.DescId = zc_MovementDate_Insert()*/

                               WHERE Movement.OperDate >= DATE_TRUNC ('MONTH', vbOperDate)
                                 AND Movement.OperDate < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                                 AND Movement.DescId = zc_Movement_Sale()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                            )

          SELECT Movement.OperDate
               , SUM(Movement.TotalSumm)       AS TotalSumm
          FROM tmpMovement AS Movement
          GROUP BY Movement.OperDate) AS MovementSale
    WHERE tmpMovement.OperDate = MovementSale.OperDate;


    -- таблица
    CREATE TEMP TABLE tmpCalculation ON COMMIT DROP AS
       (SELECT MovementItem.ObjectId                                                                                        AS UserId
             , DATE_TRUNC ('MONTH', vbOperDate) + (((MovementItemChild.Amount - 1)::Integer)::tvarchar||' DAY')::INTERVAL   AS OperDate
             , MovementItemChild.ObjectId                                                                                   AS PayrollTypeVIPID
             , (date_part('HOUR', MIDate_End.ValueData - MIDate_Start.ValueData) +
                   (date_part('MINUTE', MIDate_End.ValueData - MIDate_Start.ValueData)) / 60)::TFloat                       AS HoursWork
             , 0::TFloat                                                                                                    AS HoursWorkDay
             , 0::TFloat                                                                                                    AS Summa
        FROM Movement

             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                    AND MovementItem.DescId = zc_MI_Master()

             INNER JOIN MovementItem AS MovementItemChild
                                     ON MovementItemChild.MovementId = Movement.Id
                                    AND MovementItemChild.DescId = zc_MI_Child()
                                    AND MovementItemChild.ParentId = MovementItem.ID

             LEFT JOIN MovementItemDate AS MIDate_Start
                                        ON MIDate_Start.MovementItemId = MovementItemChild.Id
                                       AND MIDate_Start.DescId = zc_MIDate_Start()

             LEFT JOIN MovementItemDate AS MIDate_End
                                        ON MIDate_End.MovementItemId = MovementItemChild.Id
                                       AND MIDate_End.DescId = zc_MIDate_End()

        WHERE Movement.ID = (SELECT Movement.ID
                             FROM Movement
                             WHERE Movement.DescId = zc_Movement_EmployeeScheduleVIP()
                               AND Movement.OperDate = vbOperDate)
          AND MovementItem.IsErased = FALSE);

    IF NOT EXISTS(SELECT * FROM tmpCalculation)
    THEN
      RAISE EXCEPTION 'Ошибка. Не найден график работы VIP менеджеров.';
    END IF;

    UPDATE tmpCalculation SET HoursWorkDay = Calc.Summa
      FROM (SELECT tmpCalculation.OperDate
                 , SUM(tmpCalculation.HoursWork) AS Summa

            FROM tmpCalculation
            GROUP BY tmpCalculation.OperDate
            ) AS Calc
      WHERE tmpCalculation.OperDate = Calc.OperDate;


    UPDATE tmpCalculation SET Summa = Calc.Summa
    FROM (SELECT tmpCalculation.UserId
               , tmpCalculation.OperDate
               , ROUND((COALESCE(tmpMovement.SummPhone, 0) + COALESCE(tmpMovement.SummSaleNP, 0)) *
                        tmpCalculation.HoursWork * ObjectFloat_PercentPhone.ValueData / 100 / tmpCalculation.HoursWorkDay +
                       COALESCE(tmpMovement.SummSale, 0) *
                        tmpCalculation.HoursWork * ObjectFloat_PercentOther.ValueData / 100 / tmpCalculation.HoursWorkDay, 2) AS Summa

          FROM tmpCalculation

               LEFT JOIN ObjectFloat AS ObjectFloat_PercentPhone
                                     ON ObjectFloat_PercentPhone.ObjectId = tmpCalculation.PayrollTypeVIPId
                                    AND ObjectFloat_PercentPhone.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentPhone()

               LEFT JOIN ObjectFloat AS ObjectFloat_PercentOther
                                     ON ObjectFloat_PercentOther.ObjectId = tmpCalculation.PayrollTypeVIPId
                                    AND ObjectFloat_PercentOther.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentOther()

               LEFT JOIN tmpMovement ON tmpMovement.OperDate = tmpCalculation.OperDate

          ) AS Calc
    WHERE tmpCalculation.UserId = Calc.UserId
      AND tmpCalculation.OperDate = Calc.OperDate;

    IF NOT EXISTS(SELECT * FROM tmpCalculation)
    THEN        
      RAISE EXCEPTION 'Ошибка. Не найден график работы VIP менеджеров.';
    END IF;

    vbTotalSummPhone := 0;
    vbTotalSummSale := 0;
    vbTotalSummSaleNP := 0;
    vbHoursWork := 0;
    
    SELECT COALESCE(SUM(Movement.SummPhone), 0)::TFloat  AS SummPhone
         , COALESCE(SUM(Movement.SummSale), 0)::TFloat   AS SummSale
         , COALESCE(SUM(Movement.SummSaleNP), 0)::TFloat AS SummSaleNP
    INTO vbTotalSummPhone, vbTotalSummSale, vbTotalSummSaleNP
    FROM tmpMovement AS Movement;
    
    SELECT SUM(tmpCalculation.HoursWork)::TFloat AS HoursWork
    INTO vbHoursWork
    FROM tmpCalculation;
            
    -- сохранили отметку <Сумма реализации заказов принятых по телефону>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPhone(), inMovementId, vbTotalSummPhone);
    -- сохранили отметку <Сумма реализации заказов>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSale(), inMovementId, vbTotalSummSale);
    -- сохранили отметку <Сумма реализации заказов>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSaleNP(), inMovementId, vbTotalSummSaleNP);
    -- сохранили отметку <Отработано часов всеми сотрудниками>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), inMovementId, vbHoursWork);
    
          
    PERFORM lpInsertUpdate_MovementItem_WagesVIP_Calc (ioId              := COALESCE(tmpMI.Id, 0)
                                                     , inMovementId      := inMovementId
                                                     , inUserWagesId     := COALESCE(tmpCalc.UserID, tmpMI.UserID)
                                                     , inAmountAccrued   := COALESCE(tmpCalc.Summa, 0)
                                                     , inHoursWork       := COALESCE(tmpCalc.HoursWork, 0)
                                                     , inUserId          := vbUserId)
    FROM (SELECT tmpCalculation.UserId
               , SUM(tmpCalculation.Summa) AS Summa
               , SUM(tmpCalculation.HoursWork)::TFloat AS HoursWork
          FROM tmpCalculation
          GROUP BY tmpCalculation.UserId) AS tmpCalc
    
         FULL JOIN (SELECT MovementItem.Id                    AS Id
                         , MovementItem.ObjectId              AS UserID
                         , MovementItem.Amount                AS AmountAccrued
                         , MIFloat_HoursWork.ValueData        AS HoursWork
                    FROM  MovementItem
                   
                          LEFT JOIN MovementItemFloat AS MIFloat_HoursWork
                                                      ON MIFloat_HoursWork.MovementItemId = MovementItem.Id
                                                     AND MIFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
                                                    
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()) AS tmpMI ON tmpMI.UserID = tmpCalc.UserID
         
    WHERE COALESCE(tmpMI.AmountAccrued, 0) <> COALESCE(tmpCalc.Summa, 0)
       OR COALESCE(tmpMI.HoursWork, 0) <> COALESCE(tmpCalc.HoursWork, 0);
               
    
    -- сохранили свойство <Дата расчета>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Calculation(), inMovementId, CURRENT_TIMESTAMP);    

      -- Пересчитали итоговые суммы
--    PERFORM lpInsertUpdate_Movement_WagesVIP_TotalSumm (inMovementId);

 --   RAISE EXCEPTION '------> % % %  - %', vbTotalSummPhone, vbTotalSummSale, vbTotalSummSaleNP, vbHoursWork;      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.08.19                                                        *
*/

-- 
select * from gpInsertUpdate_Movement_WagesVIP_CalculationAllDay(inMovementId := 26289531 ,  inSession := '3');
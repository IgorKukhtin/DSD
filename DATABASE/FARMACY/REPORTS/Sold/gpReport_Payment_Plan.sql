DROP FUNCTION IF EXISTS gpReport_Payment_Plan (TDateTime, TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Payment_Plan(
    IN inStartDate        TDateTime , -- дата начала
    IN inEndDate          TDateTime , -- дата окончания
    IN inOurJuridicalId   integer   , -- наше юр.лицо
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate            TDateTime,  --Месяц плана
               JuridicalId_Income  integer  ,  
               JuridicalName       TVarChar,   --поставщик
               TotalSumm           TFloat,     --Сумма по накладным 
               PaySumm             TFloat,     --Сумма к оплате
               PaymentSum          TFloat      --Сумма оплат приходов из док оплат
)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    PERFORM lpCheckingUser_Juridical(inOurJuridicalId, inSession);
    
    raise notice 'Value 1: %', CLOCK_TIMESTAMP();
    
    -- документы прихода
    CREATE TEMP TABLE tmpIncome ON COMMIT DROP AS
     SELECT MovementDate_Payment.ValueData               AS Date_Payment
          , MovementLinkObject_From.ObjectId             AS JuridicalId_Income             -- поставщик
          , MovementFloat_TotalSumm.ValueData            AS TotalSumm
          , Movement.Id                                  AS MovementId
          , MovementLinkObject_Juridical_Income.ObjectId AS JuridicalId                    -- наше юр.лицо
     FROM Movement
          --дата оплаты                       
          INNER JOIN MovementDate AS MovementDate_Payment
                                  ON MovementDate_Payment.MovementId =  Movement.Id
                                 AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                                 AND MovementDate_Payment.ValueData >= inStartDate 
                                 AND MovementDate_Payment.ValueData < inEndDate + INTERVAL '1 day'
          -- на какое наше юр лицо был приход
          INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical_Income
                                        ON MovementLinkObject_Juridical_Income.MovementId = Movement.Id
                                       AND MovementLinkObject_Juridical_Income.DescId = zc_MovementLinkObject_Juridical()          
                                       AND (MovementLinkObject_Juridical_Income.ObjectId = inOurJuridicalId OR inOurJuridicalId = 0)
          -- от кого приход Поставщик                   
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
               
          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
      WHERE Movement.DescId = zc_Movement_Income()
        AND Movement.StatusId = zc_Enum_Status_Complete();
    
    ANALYSE tmpIncome;
    
    raise notice 'Value 2: %', CLOCK_TIMESTAMP();
    
    -- выбираем оплаты приходов
    CREATE TEMP TABLE tmpPayment ON COMMIT DROP AS
     SELECT Movement_Payment.* 
     FROM Movement AS Movement_Payment
          INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                        ON MovementLinkObject_Juridical.MovementId = Movement_Payment.Id
                                       AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                       AND (MovementLinkObject_Juridical.ObjectId = inOurJuridicalId OR inOurJuridicalId = 0)
     WHERE Movement_Payment.DescId = zc_Movement_Payment()
       AND Movement_Payment.StatusId = zc_Enum_Status_Complete();
                     
    ANALYSE tmpPayment;
  
    raise notice 'Value 3: %', CLOCK_TIMESTAMP();

    RETURN QUERY
        WITH
      tmpMIPayment_All AS (SELECT MovementItem.*
                        FROM tmpPayment
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpPayment.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE

                             INNER JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                                            ON MIBoolean_NeedPay.MovementItemId = MovementItem.Id
                                                           AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                                                           AND COALESCE (MIBoolean_NeedPay.ValueData, FALSE) = TRUE
                        ) 
    , tmpMIPayment AS (SELECT tmpIncome.MovementId AS MovementId_Income
                            , SUM (COALESCE (tmpMIPayment_All.Amount, 0) 
                                 + COALESCE (MIFloat_CorrBonus.ValueData, 0) 
                                 + COALESCE (MIFloat_CorrReturnOut.ValueData, 0) 
                                 + COALESCE (MIFloat_CorrOther.ValueData, 0) 
                                  ) AS AmountPay
                       FROM tmpMIPayment_All
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_IncomeId
                                                              ON MIFloat_IncomeId.MovementItemId = tmpMIPayment_All.Id
                                                             AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId()
                            --LEFT OUTER JOIN Movement AS Movement_Income ON Movement_Income.Id = MIFloat_IncomeId.ValueData::INTEGER
                            INNER JOIN tmpIncome ON tmpIncome.MovementId = MIFloat_IncomeId.ValueData::Integer --Movement_Income.Id

                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrBonus
                                                              ON MIFloat_CorrBonus.MovementItemId = tmpMIPayment_All.Id
                                                             AND MIFloat_CorrBonus.DescId = zc_MIFloat_CorrBonus()
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrReturnOut
                                                              ON MIFloat_CorrReturnOut.MovementItemId = tmpMIPayment_All.Id
                                                             AND MIFloat_CorrReturnOut.DescId = zc_MIFloat_CorrReturnOut()
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_CorrOther
                                                              ON MIFloat_CorrOther.MovementItemId = tmpMIPayment_All.Id
                                                             AND MIFloat_CorrOther.DescId = zc_MIFloat_CorrOther()
                       GROUP BY tmpIncome.MovementId
                       )               
    -- приходы + оплаты
    , tmpMovementIncome AS ( SELECT DATE_TRUNC('DAY', tmpIncome.Date_Payment) :: TDateTime AS Date_Payment
                                  , tmpIncome.JuridicalId_Income                           AS JuridicalId_Income             -- поставщик
                                  , SUM(tmpIncome.TotalSumm)                               AS TotalSumm
                                  , SUM (Container.Amount)                                 AS PaySumm
                                  , SUM (tmpMIPayment.AmountPay)                           AS PaymentSum
                             FROM tmpIncome
                                  -- Партия накладной
                                  LEFT JOIN Object AS Object_Movement
                                                   ON Object_Movement.ObjectCode = tmpIncome.MovementId 
                                                  AND Object_Movement.DescId = zc_Object_PartionMovement()
                                  LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                     AND Container.ObjectId = Object_Movement.Id
                                                     AND Container.KeyValue like '%,'||tmpIncome.JuridicalId||';%'

                                  LEFT JOIN tmpMIPayment ON tmpMIPayment.MovementId_Income = tmpIncome.MovementId
                              GROUP BY DATE_TRUNC('DAY', tmpIncome.Date_Payment)
                                     , tmpIncome.JuridicalId_Income
                           )
 /*   -- определяем даты интервала для выборки документов чек
    , tmpDate AS (SELECT MIN(tmpMovementIncome.Date_Payment) AS DateStart
                       , MAX(tmpMovementIncome.Date_Payment) AS DateEnd
                  FROM tmpMovementIncome
                  )
    -- подразделения по выбранному юр.лицу
    , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical         
                  WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    AND (ObjectLink_Unit_Juridical.ChildObjectId = inOurJuridicalId OR inOurJuridicalId = 0)
                    )*/
     -- 
    , tmpFull AS (SELECT tmpMovementIncome.Date_Payment     AS OperDate --COALESCE (tmpMovementIncome.Date_Payment, tmpMovementCheck.OperDate_Check) AS OperDate
                       , tmpMovementIncome.JuridicalId_Income             -- поставщик
                       , tmpMovementIncome.TotalSumm   
                       , tmpMovementIncome.PaySumm
                       , tmpMovementIncome.PaymentSum
                  FROM tmpMovementIncome 
                  )
        -- результат
        SELECT tmpFull.OperDate 
             , tmpFull.JuridicalId_Income             -- поставщик
             , Object_Juridical.ValueData      AS JuridicalName
             , tmpFull.TotalSumm  ::TFloat
             , tmpFull.PaySumm    ::TFloat
             , tmpFull.PaymentSum ::TFloat
        FROM tmpFull
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpFull.JuridicalId_Income;
            
    raise notice 'Value 20: %', CLOCK_TIMESTAMP();
            

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 27.06.18         *
 05.10.16         * parce
 09.09.16         *
*/
--test
--

select * from gpReport_Payment_Plan(inStartDate := ('01.06.2023')::TDateTime , inEndDate := ('30.06.2023')::TDateTime , inOurJuridicalId := 393052 ,  inSession := '3');


-- Function: gpUpdate_Movement_Sale_Pay()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Pay  (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Pay(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inPaidKindId       Integer,    -- ФО
    IN inJuridicalId      Integer,    -- Юр лицо
    IN inContractId       Integer,    -- договор (для оплаты и продажи - должны совпадать)
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDatePay TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     --получаем данные оплат из отчета
     CREATE TEMP TABLE _tmpReport ON COMMIT DROP AS
     SELECT tmp.MovementId
          , COALESCE (tmp.Summ_Pay,0)      AS Summ_Pay
          , COALESCE (tmp.Summ_ReturnIn,0) AS Summ_ReturnIn
          
          , COALESCE (tmp.SumPay1,0)     AS SumPay1
          , COALESCE (tmp.SumPay2,0)     AS SumPay2
          , COALESCE (tmp.SumReturn_1,0) AS SumReturn_1
          , COALESCE (tmp.SumReturn_2,0) AS SumReturn_2
          , tmp.DatePay_1                AS DatePay_1
          , tmp.DatePay_2                AS DatePay_2
          , tmp.DateReturn_1             AS DateReturn_1
          , tmp.DateReturn_2             AS DateReturn_2 
          
     FROM gpReport_Sale_BankAccount (inStartDate, inEndDate, inPaidKindId, inJuridicalId, inContractId, inSession) AS tmp
     WHERE (COALESCE (tmp.Summ_Pay,0) <> 0
        OR COALESCE (tmp.Summ_ReturnIn,0) <> 0)
        AND COALESCE (tmp.MovementId,0) > 0;

     -- если нет данных выход   
     IF NOT EXISTS (SELECT 1 FROM _tmpReport LIMIT 1)  
     THEN
         RETURN;
     END IF;

     --Месяц оплаты 
     vbDatePay := DATE_TRUNC ('MONTH', inStartDate);
     --данные из док. продажи

     

     PERFORM CASE WHEN COALESCE (tmpData.Summ_Pay,0) <> 0 THEN lpInsertUpdate_MovementDate (tmpData.Desc_datePay, tmpData.MovementId, vbDatePay) END
           , CASE WHEN COALESCE (tmpData.Summ_Pay,0) <> 0 THEN lpInsertUpdate_MovementFloat (tmpData.Desc_sumPay, tmpData.MovementId, tmpData.Summ_Pay::TFloat) END
           , CASE WHEN COALESCE (tmpData.Summ_ReturnIn,0) <> 0 THEN lpInsertUpdate_MovementDate (tmpData.Desc_dateReturn, tmpData.MovementId, vbDatePay) END
           , CASE WHEN COALESCE (tmpData.Summ_ReturnIn,0) <> 0 THEN lpInsertUpdate_MovementFloat (tmpData.Desc_sumReturn, tmpData.MovementId, tmpData.Summ_ReturnIn::TFloat) END
     FROM (
           /* --в отчете есть данные распределения по док. продажи
           WITH
           tmp AS (SELECT Movement.Id                                    AS MovementId
                        , MovementFloat_Pay_1.ValueData      ::TFloat    AS SumPay1
                        , MovementFloat_Pay_2.ValueData      ::TFloat    AS SumPay2
                        , MovementFloat_Return_1.ValueData   ::TFloat    AS SumReturn_1
                        , MovementFloat_Return_2.ValueData   ::TFloat    AS SumReturn_2    
                        
                        , MovementDate_Pay_1.ValueData       ::TDateTime AS DatePay_1
                        , MovementDate_Pay_2.ValueData       ::TDateTime AS DatePay_2
                        , MovementDate_Return_1.ValueData    ::TDateTime AS DateReturn_1
                        , MovementDate_Return_2.ValueData    ::TDateTime AS DateReturn_2 
                        , _tmpReport.Summ_Pay
                        , _tmpReport.Summ_ReturnIn
                   FROM _tmpReport 
                      --данные из док. продажи
                      INNER JOIN Movement ON Movement.Id = _tmpReport.MovementId
                                         AND Movement.DescId = zc_Movement_Sale()
             
                      LEFT JOIN MovementDate AS MovementDate_Pay_1
                                             ON MovementDate_Pay_1.MovementId = Movement.Id
                                            AND MovementDate_Pay_1.DescId = zc_MovementDate_Pay_1()
                      LEFT JOIN MovementDate AS MovementDate_Pay_2
                                             ON MovementDate_Pay_2.MovementId = Movement.Id
                                            AND MovementDate_Pay_2.DescId = zc_MovementDate_Pay_2()
                      LEFT JOIN MovementDate AS MovementDate_Return_1
                                             ON MovementDate_Return_1.MovementId = Movement.Id
                                            AND MovementDate_Return_1.DescId = zc_MovementDate_Return_1()
                      LEFT JOIN MovementDate AS MovementDate_Return_2
                                             ON MovementDate_Return_2.MovementId = Movement.Id
                                            AND MovementDate_Return_2.DescId = zc_MovementDate_Return_2()
             
                      LEFT JOIN MovementFloat AS MovementFloat_Pay_1
                                              ON MovementFloat_Pay_1.MovementId = Movement.Id
                                             AND MovementFloat_Pay_1.DescId = zc_MovementFloat_Pay_1()
                      LEFT JOIN MovementFloat AS MovementFloat_Pay_2
                                              ON MovementFloat_Pay_2.MovementId = Movement.Id
                                             AND MovementFloat_Pay_2.DescId = zc_MovementFloat_Pay_2()
                      LEFT JOIN MovementFloat AS MovementFloat_Return_1
                                              ON MovementFloat_Return_1.MovementId = Movement.Id
                                             AND MovementFloat_Return_1.DescId = zc_MovementFloat_Return_1()
                      LEFT JOIN MovementFloat AS MovementFloat_Return_2
                                              ON MovementFloat_Return_2.MovementId = Movement.Id
                                             AND MovementFloat_Return_2.DescId = zc_MovementFloat_Return_2() 
                   )
                   */
                   
          SELECT CASE WHEN COALESCE (tmp.Summ_Pay,0) <> 0 
                      THEN CASE WHEN COALESCE (tmp.DatePay_1, vbDatePay) ::TDateTime >= vbDatePay THEN zc_MovementDate_Pay_1() ELSE zc_MovementDate_Pay_2() END
                      ELSE 0 
                 END AS Desc_datePay
               , CASE WHEN COALESCE (tmp.Summ_Pay,0) <> 0 
                      THEN CASE WHEN COALESCE (tmp.DatePay_1, vbDatePay) ::TDateTime >= vbDatePay THEN zc_MovementFloat_Pay_1() ELSE zc_MovementFloat_Pay_2() END
                      ELSE 0 
                 END AS Desc_sumPay
               , CASE WHEN COALESCE (tmp.Summ_ReturnIn,0) <> 0 
                      THEN CASE WHEN COALESCE (tmp.DatePay_1, vbDatePay) ::TDateTime >= vbDatePay THEN zc_MovementDate_Return_1() ELSE zc_MovementDate_Return_2() END
                      ELSE 0 
                 END AS Desc_dateReturn
               , CASE WHEN COALESCE (tmp.Summ_ReturnIn,0) <> 0 
                      THEN CASE WHEN COALESCE (tmp.DatePay_1, vbDatePay) ::TDateTime >= vbDatePay THEN zc_MovementFloat_Return_1() ELSE zc_MovementFloat_Return_2() END
                      ELSE 0 
                 END AS Desc_sumReturn
               , tmp.Summ_Pay
               , tmp.Summ_ReturnIn
               , tmp.MovementId
          FROM _tmpReport AS tmp
          ) AS tmpData 
         WHERE tmpData.Desc_datePay <> 0 OR tmpData.Desc_dateReturn <> 0                                   
     ;

   /*
   IF vbUserId = 9457 
   THEN
        RAISE EXCEPTION 'Test.OK';
   END IF;
  */

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.24         *
*/
-- тест
--

/*
select * from gpUpdate_Movement_Sale_Pay(inStartDate := ('01.06.2024')::TDateTime , inEndDate := ('30.06.2024')::TDateTime , inPaidKindId := 3 , inJuridicalId := 15410 , inContractId := 1183579 ,  inSession := '9457');
select * from gpReport_Sale_BankAccount (inStartDate := ('01.06.2024')::TDateTime , inEndDate := ('30.06.2024')::TDateTime , inPaidKindId := 3 , inJuridicalId := 15410 , inContractId := 1183579 ,  inSession := '9457');
*/
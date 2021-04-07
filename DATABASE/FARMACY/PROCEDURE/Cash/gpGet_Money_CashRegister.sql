DROP FUNCTION IF EXISTS gpGet_Money_CashRegister (TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Money_CashRegister(
    IN inCashRegisterName  TVarChar, -- Касса
    IN inCheckOut           Integer,  -- Чеков продажи
    IN inCheckIn          Integer,  -- Чеков возврата
   OUT outSummsCash        TFloat,   -- Сумма выручки за день
    IN inSession           TVarChar  -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
  vbUserId:= lpGetUserBySession (inSession);
  vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
  IF vbUnitKey = '' THEN
    vbUnitKey := '0';
  END IF;   
  vbUnitId := vbUnitKey::Integer;

  WITH tmpCheck AS (SELECT Movement.*
                         , MovementString_FiscalCheckNumber.ValueData                                          AS FiscalCheckNumber
                         , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                THEN COALESCE(MovementFloat_TotalSumm.ValueData, 0)
                                ELSE COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCash
                         , ROW_NUMBER()OVER(ORDER BY MovementString_FiscalCheckNumber.ValueData::Integer DESC) as ORD
                    FROM Movement

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                                   
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                      ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                     AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                         LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId
             		                      
                         LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                                  ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                                 AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
                                                     
                         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                         LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                                 ON MovementFloat_TotalSummPayAdd.MovementId =  Movement.Id
                                                AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                                      ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                                     AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()

                    WHERE Movement.OperDate >= CURRENT_DATE 
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                      AND Movement.DescId = zc_Movement_Check()
                      AND MovementLinkObject_Unit.ObjectId = vbUnitId
                      AND Object_CashRegister.ValueData = inCashRegisterName)
     , tmpReturnIn AS (SELECT Movement.*
                            , MovementString_FiscalCheckNumber.ValueData                                          AS FiscalCheckNumber
                            , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                   THEN COALESCE(MovementFloat_TotalSumm.ValueData, 0)
                                   ELSE COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCash
                            , ROW_NUMBER()OVER(ORDER BY MovementString_FiscalCheckNumber.ValueData::Integer DESC) as ORD
                       FROM Movement

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                                       
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId
                 		                      
                            LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                                     ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                                    AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
                                                         
                            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                                    ON MovementFloat_TotalSummPayAdd.MovementId =  Movement.Id
                                                   AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()
 
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                                         ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                                        AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()

                       WHERE Movement.OperDate >= CURRENT_DATE 
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND Movement.DescId = zc_Movement_ReturnIn()
                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                         AND Object_CashRegister.ValueData = inCashRegisterName)
     , tmpSum AS (SELECT sum(tmpCheck.SummCash) AS SummCash
                  FROM tmpCheck
                  WHERE tmpCheck.ORD <= inCheckOut
                  UNION ALL
                  SELECT - sum(tmpReturnIn.SummCash) 
                  FROM tmpReturnIn
                  WHERE tmpReturnIn.ORD <= inCheckIn)
                      
  SELECT sum(tmpSum.SummCash)
  INTO outSummsCash
  FROM tmpSum;
               

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Money_CashRegister (TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 06.04.21                                                      * 

*/

-- тест
-- SELECT * FROM gpGet_Money_CashRegister ('3000007988', 31, 1, '3')
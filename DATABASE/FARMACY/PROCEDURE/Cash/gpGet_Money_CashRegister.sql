--DROP FUNCTION IF EXISTS gpGet_Money_CashRegister (TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Money_CashRegister (TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Money_CashRegister(
    IN inCashRegisterName  TVarChar, -- �����
    IN inZReport           Integer,  -- Z �����
    IN inCheckOut          Integer,  -- ����� �������
    IN inCheckIn           Integer,  -- ����� ��������
   OUT outSummsCash        TFloat,   -- ����� ������� �� ���� ���
   OUT outSummsCard        TFloat,   -- ����� ������� �� ���� �����
    IN inSession           TVarChar  -- ������ ������������
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
  vbUserId:= lpGetUserBySession (inSession);
  vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
  IF vbUnitKey = '' THEN
    vbUnitKey := '0';
  END IF;   
  vbUnitId := vbUnitKey::Integer;
  
  IF COALESCE (inZReport, 0) = 0 OR
     NOT EXISTS(SELECT 1
                FROM Movement

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                                     
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                  ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                 AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                     LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

                     LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                             ON MovementFloat_ZReport.MovementId =  Movement.Id
                                            AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()

                WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY' 
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                  AND Movement.DescId in (zc_Movement_Check(), zc_Movement_ReturnIn(), zc_Movement_Sale())
                  AND MovementLinkObject_Unit.ObjectId = vbUnitId
                  AND Object_CashRegister.ValueData = inCashRegisterName
                  AND COALESCE(MovementFloat_ZReport.ValueData, - 1)::Integer = inZReport - 1)
  THEN

    WITH tmpCheck AS (SELECT Movement.*
                           , MovementString_FiscalCheckNumber.ValueData                                          AS FiscalCheckNumber
                           , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                  THEN COALESCE(MovementFloat_TotalSumm.ValueData, 0)
                                  ELSE COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCash
                           , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                  THEN 0
                                  ELSE COALESCE(MovementFloat_TotalSumm.ValueData, 0) - 
                                       COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCard
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
                              , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                     THEN 0
                                     ELSE COALESCE(MovementFloat_TotalSumm.ValueData, 0) - 
                                          COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCard
                              , ROW_NUMBER()OVER(ORDER BY Movement.Id DESC) as ORD
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
                         , sum(tmpCheck.SummCard) AS SummCard
                    FROM tmpCheck
                    WHERE tmpCheck.ORD <= inCheckOut
                    UNION ALL
                    SELECT - sum(tmpReturnIn.SummCash) 
                         , - sum(tmpReturnIn.SummCard) 
                    FROM tmpReturnIn
                    WHERE tmpReturnIn.ORD <= inCheckIn)
                        
    SELECT COALESCE(sum(tmpSum.SummCash), 0), COALESCE(sum(tmpSum.SummCard), 0)
    INTO outSummsCash, outSummsCard
    FROM tmpSum;
  ELSE
    WITH tmpCheck AS (SELECT Movement.*
                           , MovementString_FiscalCheckNumber.ValueData                                          AS FiscalCheckNumber
                           , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                  THEN COALESCE(MovementFloat_TotalSumm.ValueData, 0)
                                  ELSE COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCash
                           , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                  THEN 0
                                  ELSE COALESCE(MovementFloat_TotalSumm.ValueData, 0) - 
                                       COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCard
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

                           LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                                   ON MovementFloat_ZReport.MovementId =  Movement.Id
                                                  AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()

                      WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '1 DAY'
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.DescId = zc_Movement_Check()
                        AND MovementLinkObject_Unit.ObjectId = vbUnitId
                        AND Object_CashRegister.ValueData = inCashRegisterName
                        AND COALESCE(MovementFloat_ZReport.ValueData, - 1)::Integer = inZReport)
       , tmpReturnIn AS (SELECT Movement.*
                              , MovementString_FiscalCheckNumber.ValueData                                          AS FiscalCheckNumber
                              , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                     THEN COALESCE(MovementFloat_TotalSumm.ValueData, 0)
                                     ELSE COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCash
                              , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                     THEN 0
                                     ELSE COALESCE(MovementFloat_TotalSumm.ValueData, 0) - 
                                          COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCard
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

                              LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                                      ON MovementFloat_ZReport.MovementId =  Movement.Id
                                                     AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()

                         WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '1 DAY' 
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_ReturnIn()
                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
                           AND Object_CashRegister.ValueData = inCashRegisterName
                           AND COALESCE(MovementFloat_ZReport.ValueData, - 1)::Integer = inZReport)
       , tmpSale AS (SELECT Movement.*
                          , MovementString_FiscalCheckNumber.ValueData                                          AS FiscalCheckNumber
                          , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                 THEN COALESCE(MovementFloat_TotalSumm.ValueData, 0)
                                 ELSE COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCash
                          , CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                 THEN 0
                                 ELSE COALESCE(MovementFloat_TotalSumm.ValueData, 0) - 
                                      COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END                  AS SummCard
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

                          LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                                  ON MovementFloat_ZReport.MovementId =  Movement.Id
                                                 AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()

                     WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY' 
                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                       AND Movement.DescId = zc_Movement_Sale()
                       AND MovementLinkObject_Unit.ObjectId = vbUnitId
                       AND Object_CashRegister.ValueData = inCashRegisterName
                       AND COALESCE(MovementFloat_ZReport.ValueData, - 1)::Integer = inZReport)
       , tmpSum AS (SELECT sum(tmpCheck.SummCash) AS SummCash
                         , sum(tmpCheck.SummCard) AS SummCard
                    FROM tmpCheck
                    UNION ALL
                    SELECT - sum(tmpReturnIn.SummCash) 
                         , - sum(tmpReturnIn.SummCard) 
                    FROM tmpReturnIn
                    UNION ALL
                    SELECT sum(tmpSale.SummCash) 
                         , sum(tmpSale.SummCard) 
                    FROM tmpSale)
                        
    SELECT COALESCE(sum(tmpSum.SummCash), 0), COALESCE(sum(tmpSum.SummCard), 0)
    INTO outSummsCash, outSummsCard
    FROM tmpSum;
  
  END IF;
               
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Money_CashRegister (TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 06.04.21                                                      * 

*/

-- ����
-- 
select * from gpGet_Money_CashRegister(inCashRegisterName := '3000381611' , inZReport := 2010 , inCheckOut := 20 , inCheckIn := 0 ,  inSession := '3');
DROP FUNCTION IF EXISTS gpSelect_Report_Payment_Plan (TDateTime, TDateTime, integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Payment_Plan(
    IN inStartDate        TDateTime , -- ���� ������
    IN inEndDate          TDateTime , -- ���� ���������
    IN inOurJuridicalId   integer   , -- 
    IN isOurJuridical     Boolean   ,
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (
    Date_Payment      TDateTime,  --����� �����
    FromId            integer,
    FromName          TVarChar,   --���������
    OurJuridicalId    integer,
    OurJuridicalName  TVarChar,   --���������

    TotalSumm         TFloat,     --����� ���������
    PaySumm           TFloat     --����� ������

)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    inStartDate := date_trunc('month', inStartDate);
    inEndDate := date_trunc('month', inEndDate) + Interval '1 MONTH';

    RETURN QUERY
        WITH
         tmpMovementIncome AS ( SELECT date_trunc('day', MovementDate_Payment.ValueData) AS Date_Payment
                                     , MovementLinkObject_From.ObjectId                 AS FromId             -- ���������
                                     , CASE WHEN isOurJuridical = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END  AS OurJuridicalId  -- ���� �� ���� ��� ������
                                     , SUM(MovementFloat_TotalSumm.ValueData)           AS TotalSumm
                                     , SUM(Container.Amount)                            AS PaySumm
                                FROM Movement
                                     /*--���� ������� �� ������
                                     INNER JOIN MovementDate AS MovementDate_Branch
                                                             ON MovementDate_Branch.MovementId = Movement.Id
                                                            AND MovementDate_Branch.DescId = zc_MovementDate_Branch()*/
                                     --���� ������                       
                                     INNER JOIN MovementDate AS MovementDate_Payment
                                                             ON MovementDate_Payment.MovementId =  Movement.Id
                                                            AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                                                            AND date_trunc('day', MovementDate_Payment.ValueData) between '01.06.2016' and '10.06.2016' --inDateStart AND inDateFinal           
                                     -- �� ���� ������ ���������                   
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    -- �� ����� ���� �� ���� ��� ������
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical_Income
                                                                 ON MovementLinkObject_Juridical_Income.MovementId = Movement.Id
                                                                AND MovementLinkObject_Juridical_Income.DescId = zc_MovementLinkObject_Juridical()
                                                          
                                    LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                            ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                    -- ������ ���������
                                    LEFT JOIN Object AS Object_Movement
                                                     ON Object_Movement.ObjectCode = Movement.Id 
                                                    AND Object_Movement.DescId = zc_Object_PartionMovement()
                                    LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                       AND Container.ObjectId = Object_Movement.Id
                                                       AND Container.KeyValue like '%,'||MovementLinkObject_Juridical.ObjectId||';%'

                                 WHERE Movement.DescId = zc_Movement_Income()
                                   AND Movement.StatusId = zc_Enum_Status_Complete() 
                                 GROUP BY MovementLinkObject_From.ObjectId 
                                        , CASE WHEN isOurJuridical = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END 
                                        , date_trunc('day', MovementDate_Payment.ValueData)
                              )

, tmpCheck AS (SELECT Movement.OperDate
                    , ObjectLink_Unit_Juridical.ChildObjectId        -- ���� ��.����
                    , SUM(MovementFloat_TotalSumm.ValueData)          AS TotalSumm
               FROM Movement 
                 LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                         ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                        AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                      ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
               WHERE Movement.DescId = zc_Movement_Check()
                 AND Movement.OperDate >= '01.06.2016' AND Movement.OperDate < '15.06.2016'  --inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 Day'
                 AND Movement.StatusId = zc_Enum_Status_Complete() 
               )

            SELECT tmp.Date_Payment
                 , tmp.FromId             -- ���������
                 , Object_From.ValueDate      AS FromName
                 , tmp.OurJuridicalId     -- ���� �� ���� ��� ������
                 , Object_Juridical.ValueDate AS OurJuridicalName
                 , tmp.TotalSumm
                 , tmp.PaySumm
            FROM tmpMovementIncome AS tmp
                 LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmp.OurJuridicalId
                 LEFT JOIN Object AS Object_From ON Object_From.Id = tmp.FromId
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 09.09.16         *
*/

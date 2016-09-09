DROP FUNCTION IF EXISTS gpSelect_Report_Payment_Plan (TDateTime, TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Payment_Plan(
    IN inStartDate        TDateTime , -- ���� ������
    IN inEndDate          TDateTime , -- ���� ���������
    IN inOurJuridicalId   integer   , -- 
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (
    OperDate            TDateTime,  --����� �����
    JuridicalId_Income  integer,
    JuridicalName       TVarChar,   --���������
    TotalSumm           TFloat,     --����� ���������
    PaySumm             TFloat,     --����� ������
    SummaSale           TFloat     --����� ���������� 

)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  
    RETURN QUERY
        WITH
         tmpMovementIncome AS ( SELECT date_trunc('day', MovementDate_Payment.ValueData) :: TDateTime AS Date_Payment
                                     , MovementLinkObject_From.ObjectId                 AS JuridicalId_Income             -- ���������
                                  --   , CASE WHEN isOurJuridical = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END  AS OurJuridicalId  -- ���� �� ���� ��� ������
                                     , SUM(MovementFloat_TotalSumm.ValueData)           AS TotalSumm
                                     , SUM(Container.Amount)                            AS PaySumm
                                FROM Movement
                                     --���� ������                       
                                     INNER JOIN MovementDate AS MovementDate_Payment
                                                             ON MovementDate_Payment.MovementId =  Movement.Id
                                                            AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                                                            AND date_trunc('day', MovementDate_Payment.ValueData) between inStartDate and inEndDate
                                     -- �� ����� ���� �� ���� ��� ������
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical_Income
                                                                   ON MovementLinkObject_Juridical_Income.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Juridical_Income.DescId = zc_MovementLinkObject_Juridical()          
                                                                  AND (MovementLinkObject_Juridical_Income.ObjectId = inOurJuridicalId OR inOurJuridicalId = 0)
                                     -- �� ���� ������ ���������                   
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                          
                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                     -- ������ ���������
                                     LEFT JOIN Object AS Object_Movement
                                                      ON Object_Movement.ObjectCode = Movement.Id 
                                                     AND Object_Movement.DescId = zc_Object_PartionMovement()
                                     LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                        AND Container.ObjectId = Object_Movement.Id
                                                        AND Container.KeyValue like '%,'||MovementLinkObject_Juridical_Income.ObjectId||';%'
                                 WHERE Movement.DescId = zc_Movement_Income()
                                   AND Movement.StatusId = zc_Enum_Status_Complete() 
                                 GROUP BY MovementLinkObject_From.ObjectId 
                                        , date_trunc('day', MovementDate_Payment.ValueData)
                              )
    , tmpDate AS (SELECT Min(tmpMovementIncome.Date_Payment) AS DateStart
                       , Max(tmpMovementIncome.Date_Payment) AS DateEnd
                  FROM tmpMovementIncome
                  )
     , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical         
                   WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     AND (ObjectLink_Unit_Juridical.ChildObjectId = inOurJuridicalId OR inOurJuridicalId = 0)
                   )
       , tmpCheckMI AS (SELECT MIContainer.ContainerId
                        , date_trunc('day', Movement_Check.OperDate) :: TDateTime  AS  OperDate_Check                         
                        , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                   FROM tmpDate
                        INNER JOIN Movement AS Movement_Check
                                            ON Movement_Check.DescId = zc_Movement_Check()
                                           AND Movement_Check.OperDate >= tmpDate.DateStart AND Movement_Check.OperDate < tmpDate.DateEnd + INTERVAL '1 DAY'  -- Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId 
                                                   
                        INNER JOIN MovementItem AS MI_Check 
                                                ON MI_Check.MovementId = Movement_Check.Id
                                               AND MI_Check.DescId = zc_MI_Master()
                                               AND MI_Check.isErased = FALSE
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        LEFT JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.MovementItemId = MI_Check.Id
                                                       AND MIContainer.DescId = zc_MIContainer_Count() 
                   GROUP BY MIContainer.ContainerId
                          , date_trunc('day', Movement_Check.OperDate) 
                   HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                  )
  , tmpMovementCheck AS (SELECT tmpMI.OperDate_Check
                              , MovementLinkObject_From_Income.ObjectId   AS JuridicalId_Income   --���������
                              , SUM(tmpMI.SummaSale) AS SummaSale
                         FROM tmpCheckMI AS tmpMI
                              -- ����� ������
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = tmpMI.ContainerId
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId

                              -- ������� �������
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                              -- ���������, ��� �������� ������� �� ���������� (��� NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                         GROUP BY tmpMI.OperDate_Check, MovementLinkObject_From_Income.ObjectId
                        )

 , tmpFull AS (SELECT COALESCE (tmpMovementIncome.Date_Payment, tmpMovementCheck.OperDate_Check) AS OperDate
                    , tmpMovementIncome.JuridicalId_Income             -- ���������
                    , tmpMovementIncome.TotalSumm   
                    , tmpMovementIncome.PaySumm
                    , tmpMovementCheck.SummaSale
               FROM tmpMovementIncome 
                     left JOIN tmpMovementCheck ON tmpMovementCheck.OperDate_Check = tmpMovementIncome.Date_Payment
                                               AND tmpMovementCheck.JuridicalId_Income = tmpMovementIncome.JuridicalId_Income
               )

            SELECT tmpFull.OperDate
                 , tmpFull.JuridicalId_Income             -- ���������
                 , Object_Juridical.ValueData      AS JuridicalName
                
                 , tmpFull.TotalSumm  ::TFloat
                 , tmpFull.PaySumm    ::TFloat
                 , tmpFull.SummaSale  ::TFloat
            FROM tmpFull
                LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpFull.JuridicalId_Income
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 09.09.16         *
*/

-- Function: spReport_FinancialMonitoring()

DROP FUNCTION IF EXISTS gpReport_FinancialMonitoring (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_FinancialMonitoring(
    IN inStartDate     TDateTime , -- ������ �������
    IN inEndDate       TDateTime , -- ����� �������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());


    --���������� + �������
    CREATE TEMP TABLE tmpSale ON COMMIT DROP AS
    (WITH
        tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                         , Object_Juridical.Id                AS JuridicalId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical

                       INNER JOIN Object AS Object_Juridical
                                         ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                        AND Object_Juridical.isErased = False

                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND ObjectLink_Unit_Juridical.ChildObjectId <> 393053
                    ),
        tmpItemContainer AS (SELECT MovementItem.UnitID
                                  , MovementItem.OperDate
                                  , SUM(MovementItem.AmountCheckSum)                                                AS AmountCheckSum
                                  , SUM(MovementItem.AmountSaleSum)                                                 AS AmountSaleSum
                                  , SUM(MovementItem.AmountReturnInSum)                                             AS AmountReturnInSum
                                  , SUM(MovementItem.SaldoSum)                                                      AS SaldoSum
                             FROM AnalysisContainerItem AS MovementItem
                             WHERE MovementItem.UnitID in (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                               AND MovementItem.OperDate BETWEEN inStartDate AND inEndDate
                             GROUP BY MovementItem.UnitID
                                    , MovementItem.OperDate),
        tmpSPKind AS (SELECT MovementLinkObject_Unit.ObjectId                     AS UnitID
                           , sum(CASE WHEN Movement.DescId = zc_Movement_Check() THEN MovementFloat_TotalSummChangePercent.ValueData
                             ELSE COALESCE(MovementFloat_TotalSummSale.ValueData, 0) - COALESCE(MovementFloat_TotalSumm.ValueData, 0) END)  AS SummChange
                     FROM Movement

                          INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                        ON MovementLinkObject_SPKind.MovementID = Movement.ID
                                                       AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                       AND MovementLinkObject_SPKind.ObjectId in (zc_Enum_SPKind_1303(), zc_Enum_SPKind_SP())

                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementID = Movement.ID
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                   ON MovementFloat_TotalSummChangePercent.MovementID = Movement.ID
                                                  AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                  ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                                  ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

                     WHERE Movement.OperDate >= inStartDate
                       AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                       AND Movement.DescId in (zc_Movement_Check(), zc_Movement_Sale())
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                     GROUP BY  MovementLinkObject_Unit.ObjectId ),
        tmpDiscount AS (SELECT MovementLinkObject_Unit.ObjectId                     AS UnitID
                            , sum(CASE WHEN Movement.DescId = zc_Movement_Check() THEN MovementFloat_TotalSummChangePercent.ValueData
                              ELSE COALESCE(MovementFloat_TotalSummSale.ValueData, 0) - COALESCE(MovementFloat_TotalSumm.ValueData, 0) END)  AS SummChange
                       FROM Movement

                            INNER JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                                          ON MovementLinkObject_DiscountCard.MovementID = Movement.ID
                                                         AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
                                                         AND MovementLinkObject_DiscountCard.ObjectId <> 0

                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementID = Movement.ID
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                     ON MovementFloat_TotalSummChangePercent.MovementID = Movement.ID
                                                    AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                                    ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                                   AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

                       WHERE Movement.OperDate >= inStartDate
                         AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                         AND Movement.DescId = zc_Movement_Check()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                       GROUP BY  MovementLinkObject_Unit.ObjectId )
                              
         SELECT tmpUnit.JuridicalId
              , MovementItem.OperDate
              , SUM(MovementItem.AmountCheckSum)::TFloat          AS AmountCheckSum
              , SUM(MovementItem.AmountSaleSum)::TFloat           AS AmountSaleSum
              , SUM(MovementItem.AmountReturnInSum)::TFloat       AS AmountReturnInSum
              , SUM(MovementItem.SaldoSum)::TFloat                AS SaldoSum
         FROM tmpItemContainer AS MovementItem   
                           
              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementItem.UnitID
                            
         GROUP BY tmpUnit.JuridicalId
                , MovementItem.OperDate

         ORDER BY tmpUnit.JuridicalId
                , MovementItem.OperDate);   
                
    -- �������� �������
    UPDATE tmpSale SET SaldoSum = T1.SaldoSum
    FROM (WITH
              tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                               , Object_Juridical.Id                AS JuridicalId
                          FROM ObjectLink AS ObjectLink_Unit_Juridical

                             INNER JOIN Object AS Object_Juridical
                                               ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                              AND Object_Juridical.isErased = False

                             INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                   ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                  AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                          WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            AND ObjectLink_Unit_Juridical.ChildObjectId <> 393053
                          ),

              tmpContainer AS (SELECT Movement.UnitID
                                    , SUM(Movement.Price * Movement.Saldo)                                                      AS SaldoSum
                               FROM AnalysisContainer AS Movement
                               WHERE Movement.UnitID in (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                               GROUP BY Movement.UnitID),
              tmpItemContainerIn AS (SELECT MovementItem.UnitID
                                          , SUM(MovementItem.SaldoSum)                                                         AS SaldoSum
                                     FROM AnalysisContainerItem AS MovementItem
                                     WHERE MovementItem.UnitID in (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                                       AND MovementItem.OperDate > inEndDate
                                     GROUP BY MovementItem.UnitID),
              tmpSaldoIn AS (SELECT tmpUnit.JuridicalId
                                  , SUM(Movement.SaldoSum + COALESCE(tmpItemContainerIn.SaldoSum , 0))::TFloat                 AS SaldoSum
                             FROM tmpContainer AS Movement
                                               
                                  INNER JOIN tmpUnit ON tmpUnit.UnitId = Movement.UnitID

                                  LEFT JOIN tmpItemContainerIn ON tmpItemContainerIn.UnitId = Movement.UnitID
                                                
                             GROUP BY tmpUnit.JuridicalId)
              SELECT tmpSale.JuridicalId
                   , tmpSale.OperDate
                   , (tmpSaldoIn.SaldoSum - COALESCE(SUM(Sale.SaldoSum) , 0))::TFloat                 AS SaldoSum
              FROM tmpSale
              
                   LEFT JOIN tmpSaldoIn ON tmpSaldoIn.JuridicalId = tmpSale.JuridicalId

                   LEFT JOIN tmpSale AS Sale 
                                     ON Sale.JuridicalId = tmpSale.JuridicalId
                                    AND Sale.OperDate > tmpSale.OperDate
                   
              GROUP BY tmpSale.JuridicalId
                     , tmpSale.OperDate   
                     , tmpSaldoIn.SaldoSum   
              ) AS T1
    WHERE tmpSale.JuridicalId = T1.JuridicalId
      AND tmpSale.OperDate = T1.OperDate;
    

    -- �� + �������
    CREATE TEMP TABLE tmpChange ON COMMIT DROP AS
    (WITH
        tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                         , Object_Juridical.Id                AS JuridicalId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical

                       INNER JOIN Object AS Object_Juridical
                                         ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                        AND Object_Juridical.isErased = False

                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND ObjectLink_Unit_Juridical.ChildObjectId <> 393053
                    ),

        tmpSPKind AS (SELECT MovementLinkObject_Unit.ObjectId                     AS UnitID
                           , date_trunc('DAY', Movement.OperDate)                 AS OperDate
                           , sum(CASE WHEN Movement.DescId = zc_Movement_Check() THEN MovementFloat_TotalSummChangePercent.ValueData
                             ELSE COALESCE(MovementFloat_TotalSummSale.ValueData, 0) - COALESCE(MovementFloat_TotalSumm.ValueData, 0) END)  AS SummChange
                     FROM Movement

                          INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                        ON MovementLinkObject_SPKind.MovementID = Movement.ID
                                                       AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                       AND MovementLinkObject_SPKind.ObjectId in (zc_Enum_SPKind_1303(), zc_Enum_SPKind_SP())

                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementID = Movement.ID
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                   ON MovementFloat_TotalSummChangePercent.MovementID = Movement.ID
                                                  AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                  ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                                  ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

                     WHERE Movement.OperDate >= inStartDate
                       AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                       AND Movement.DescId in (zc_Movement_Check(), zc_Movement_Sale())
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                     GROUP BY date_trunc('DAY', Movement.OperDate) 
                         , MovementLinkObject_Unit.ObjectId ),
        tmpDiscount AS (SELECT MovementLinkObject_Unit.ObjectId                     AS UnitID
                            , date_trunc('DAY', Movement.OperDate)                  AS OperDate
                            , sum(CASE WHEN Movement.DescId = zc_Movement_Check() THEN MovementFloat_TotalSummChangePercent.ValueData
                              ELSE COALESCE(MovementFloat_TotalSummSale.ValueData, 0) - COALESCE(MovementFloat_TotalSumm.ValueData, 0) END)  AS SummChange
                       FROM Movement

                            INNER JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                                          ON MovementLinkObject_DiscountCard.MovementID = Movement.ID
                                                         AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
                                                         AND MovementLinkObject_DiscountCard.ObjectId <> 0

                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementID = Movement.ID
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                     ON MovementFloat_TotalSummChangePercent.MovementID = Movement.ID
                                                    AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                                    ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                                   AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

                       WHERE Movement.OperDate >= inStartDate
                         AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                         AND Movement.DescId = zc_Movement_Check()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                       GROUP BY date_trunc('DAY', Movement.OperDate)
                              , MovementLinkObject_Unit.ObjectId )
                              
         SELECT tmpUnit.JuridicalId
              , COALESCE(SPKind.OperDate, Discount.OperDate)      AS OperDate 
              , SUM(COALESCE(SPKind.SummChange, 0) + COALESCE(Discount.SummChange, 0))::TFloat  AS SummChange
         FROM tmpSPKind AS SPKind
         
              FULL JOIN tmpDiscount AS Discount
                                    ON Discount.UnitID = SPKind.UnitID
                                   AND Discount.OperDate = SPKind.OperDate     
                           
              INNER JOIN tmpUnit ON tmpUnit.UnitId = COALESCE(SPKind.UnitID, Discount.UnitID) 
                            
         GROUP BY tmpUnit.JuridicalId
                , COALESCE(SPKind.OperDate, Discount.OperDate)

         ORDER BY tmpUnit.JuridicalId
                , COALESCE(SPKind.OperDate, Discount.OperDate));   

    --������� �� ���������� �����
    CREATE TEMP TABLE tmpBankAccount ON COMMIT DROP AS
    (WITH
        tmpUnit AS (SELECT DISTINCT Object_Juridical.Id                AS JuridicalId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical

                       INNER JOIN Object AS Object_Juridical
                                         ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                        AND Object_Juridical.isErased = False

                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND ObjectLink_Unit_Juridical.ChildObjectId <> 393053
                    ),

        tmpBankAccount AS (SELECT
                                   Movement.OperDate - INTERVAL '1 DAY'              AS OperDate
                                 , MovementLinkObject_Juridical.ObjectId             AS JuridicalId
                                 , CASE WHEN MovementItem.Amount > 0 THEN
                                             MovementItem.Amount
                                        ELSE
                                            0
                                        END::TFloat AS AmountIn
                                 , CASE WHEN MovementItem.Amount < 0 THEN
                                             -1 * MovementItem.Amount
                                        ELSE
                                            0
                                        END::TFloat AS AmountOut
                                                                           
                             FROM (SELECT Movement.Id
                                        , Movement.StatusId
                                   FROM Movement 
                                   WHERE Movement.OperDate BETWEEN inStartDate + INTERVAL '1 DAY' AND inEndDate + INTERVAL '1 DAY' 
                                     AND Movement.DescId = zc_Movement_BankAccount() 
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                  ) AS tmpMovement
                                  
                                  LEFT JOIN Movement ON Movement.id = tmpMovement.id

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id 
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id 
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                        
                                  LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                                 ON MovementLinkMovement_Child.MovementId = Movement.Id
                                                                AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()

                                  LEFT JOIN Movement AS Movement_Income 
                                                     ON Movement_Income.Id = MovementLinkMovement_Child.MovementChildId
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                                               AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                               AND MovementLinkObject_Juridical.ObjectId  in (SELECT DISTINCT tmpUnit.JuridicalId FROM tmpUnit))
                              
         SELECT MovementItem.JuridicalId
              , MovementItem.OperDate
              , SUM(MovementItem.AmountIn)::TFloat          AS AmountIn
              , SUM(MovementItem.AmountOut)::TFloat         AS AmountOut
         FROM tmpBankAccount AS MovementItem   
                                                       
         GROUP BY MovementItem.JuridicalId
                , MovementItem.OperDate

         ORDER BY MovementItem.JuridicalId
                , MovementItem.OperDate);                   
                
    -- ����� 
  OPEN cur1 FOR
  WITH
    tmpSaleSum AS (SELECT SUM(COALESCE(Sale.AmountCheckSum , 0) +
                              COALESCE(Sale.AmountSaleSum , 0) -
                              COALESCE(Sale.AmountReturnInSum , 0))            AS SummaSale 
                        , SUM(Sale.SaldoSum)                                   AS SaldoSum      
                FROM tmpSale AS Sale
                ),
    tmpChangeSum AS (SELECT SUM(COALESCE(Change.SummChange , 0))               AS SummChange 
                     FROM tmpChange AS Change
                     ),
    tmpBankAccountSum AS (SELECT SUM(COALESCE(BankAccount.AmountOut , 0) - COALESCE(BankAccount.AmountIn, 0))      AS SummaBankAccount 
                          FROM tmpBankAccount AS BankAccount
                )

    SELECT (COALESCE(Sale.SummaSale, 0) + COALESCE(ChangeSum.SummChange, 0))::TFloat         AS SummaSale
         , BankAccount.SummaBankAccount::TFloat                                              AS SummaBankAccount
         , (COALESCE(Sale.SummaSale, 0) + COALESCE(ChangeSum.SummChange, 0) - 
           COALESCE(BankAccount.SummaBankAccount, 0))::TFloat                                AS SummaDelta
         , Sale.SaldoSum                                                                     AS SaldoSum

    FROM tmpSaleSum AS Sale
    
         FULL JOIN tmpBankAccountSum AS BankAccount ON 1=1
         
         LEFT JOIN tmpChangeSum AS ChangeSum ON 1=1
         
    
    ;

  RETURN NEXT cur1;

    -- ����������� ���������
  OPEN cur2 FOR
  WITH
    tmpSaleSum AS (SELECT Sale.OperDate
                        , SUM(COALESCE(Sale.AmountCheckSum , 0) +
                              COALESCE(Sale.AmountSaleSum , 0) -
                              COALESCE(Sale.AmountReturnInSum , 0))            AS SummaSale 
                        , SUM(Sale.SaldoSum)                                   AS SaldoSum
                FROM tmpSale AS Sale
                GROUP BY Sale.OperDate
                ),
    tmpChangeSum AS (SELECT Change.OperDate
                          , SUM(COALESCE(Change.SummChange , 0))               AS SummChange 
                     FROM tmpChange AS Change
                     GROUP BY Change.OperDate
                     ),
    tmpBankAccountSum AS (SELECT BankAccount.OperDate
                               , SUM(COALESCE(BankAccount.AmountOut , 0) - COALESCE(BankAccount.AmountIn, 0))     AS SummaBankAccount 
                          FROM tmpBankAccount AS BankAccount
                          GROUP BY BankAccount.OperDate
                          )

    SELECT COALESCE (BankAccount.OperDate, SaleSum.OperDate)::TDateTime                  AS OperDate
         , (COALESCE(SaleSum.SummaSale, 0) + COALESCE(ChangeSum.SummChange, 0))::TFloat  AS SummaSale
         , BankAccount.SummaBankAccount::TFloat  AS SummaBankAccount
         , (COALESCE(SaleSum.SummaSale, 0) + COALESCE(ChangeSum.SummChange, 0) - 
           COALESCE(BankAccount.SummaBankAccount, 0))::TFloat                            AS SummaDelta
         , SaleSum.SaldoSum
    FROM tmpSaleSum AS SaleSum
        
         FULL JOIN tmpBankAccountSum AS BankAccount ON BankAccount.OperDate = SaleSum.OperDate
        
         LEFT JOIN tmpChangeSum AS ChangeSum ON ChangeSum.OperDate = COALESCE (BankAccount.OperDate, SaleSum.OperDate)
         
    WHERE COALESCE (BankAccount.OperDate, SaleSum.OperDate) < CURRENT_DATE
         
    ORDER BY COALESCE (BankAccount.OperDate, SaleSum.OperDate);
     
    RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 27.08.18        *
 09.08.18        *
*/

-- ����
-- BEGIN TRANSACTION;
-- select * from gpReport_FinancialMonitoring(inStartDate := ('01.12.2021')::TDateTime , inEndDate := ('31.12.2021')::TDateTime ,  inSession := '3');
-- COMMIT TRANSACTION;
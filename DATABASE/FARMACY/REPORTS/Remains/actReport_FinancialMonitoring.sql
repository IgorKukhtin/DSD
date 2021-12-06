-- Function: actReport_FinancialMonitoring()

DROP FUNCTION IF EXISTS actReport_FinancialMonitoring (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION actReport_FinancialMonitoring(
    IN inStartDate     TDateTime , -- Начало периода
    IN inEndDate       TDateTime , -- Конец периода
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());


    --Реализайия + продажи
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
                             FROM AnalysisContainerItem AS MovementItem
                             WHERE MovementItem.UnitID in (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                               AND MovementItem.OperDate BETWEEN inStartDate AND inEndDate
                             GROUP BY MovementItem.UnitID
                                    , MovementItem.OperDate)
                              
         SELECT tmpUnit.JuridicalId
              , MovementItem.OperDate
              , SUM(MovementItem.AmountCheckSum)::TFloat          AS AmountCheckSum
              , SUM(MovementItem.AmountSaleSum)::TFloat           AS AmountSaleSum
              , SUM(MovementItem.AmountReturnInSum)::TFloat       AS AmountReturnInSum
         FROM tmpItemContainer AS MovementItem   
                           
              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementItem.UnitID
                            
         GROUP BY tmpUnit.JuridicalId
                , MovementItem.OperDate

         ORDER BY tmpUnit.JuridicalId
                , MovementItem.OperDate);   

    --Расходы по расчетному счету
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
                
    -- Итоги 
  OPEN cur1 FOR
  WITH
    tmpSaleSum AS (SELECT SUM(COALESCE(Sale.AmountCheckSum , 0) +
                              COALESCE(Sale.AmountSaleSum , 0) -
                              COALESCE(Sale.AmountReturnInSum , 0))            AS SummaSale 
                FROM tmpSale AS Sale
                ),
    tmpBankAccountSum AS (SELECT SUM(COALESCE(BankAccount.AmountOut , 0) - COALESCE(BankAccount.AmountIn, 0))      AS SummaBankAccount 
                          FROM tmpBankAccount AS BankAccount
                )

    SELECT Sale.SummaSale
         , BankAccount.SummaBankAccount 
         , COALESCE(Sale.SummaSale, 0) - COALESCE(BankAccount.SummaBankAccount, 0) AS SummaDelta

    FROM tmpSaleSum AS Sale
    
         FULL JOIN tmpBankAccountSum AS BankAccount ON 1=1
    ;

  RETURN NEXT cur1;

    -- Неоплаченые накладные
  OPEN cur2 FOR
  WITH
    tmpSaleSum AS (SELECT Sale.OperDate
                        , SUM(COALESCE(Sale.AmountCheckSum , 0) +
                              COALESCE(Sale.AmountSaleSum , 0) -
                              COALESCE(Sale.AmountReturnInSum , 0))            AS SummaSale 
                FROM tmpSale AS Sale
                GROUP BY Sale.OperDate
                ),
    tmpBankAccountSum AS (SELECT BankAccount.OperDate
                               , SUM(COALESCE(BankAccount.AmountOut , 0) - COALESCE(BankAccount.AmountIn, 0))     AS SummaBankAccount 
                          FROM tmpBankAccount AS BankAccount
                          GROUP BY BankAccount.OperDate
                          )

    SELECT COALESCE (BankAccount.OperDate, SaleSum.OperDate)::TDateTime      AS OperDate
         , SaleSum.SummaSale::TFloat AS SummaSale
         , BankAccount.SummaBankAccount::TFloat  AS SummaBankAccount
         , COALESCE(SaleSum.SummaSale, 0) - COALESCE(BankAccount.SummaBankAccount, 0)::TFloat AS SummaDelta
    FROM tmpSaleSum AS SaleSum
        
         FULL JOIN tmpBankAccountSum AS BankAccount ON BankAccount.OperDate = SaleSum.OperDate
        
    ORDER BY COALESCE (BankAccount.OperDate, SaleSum.OperDate);
     
    RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 27.08.18        *
 09.08.18        *
*/

-- тест
-- BEGIN TRANSACTION;
-- 
select * from actReport_FinancialMonitoring (inStartDate := ('01.08.2021')::TDateTime , inEndDate := ('30.08.2021')::TDateTime , inSession := '3');
-- COMMIT TRANSACTION;
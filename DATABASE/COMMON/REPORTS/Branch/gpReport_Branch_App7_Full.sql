-- Function: gpReport_Branch_App7()

DROP FUNCTION IF EXISTS gpReport_Branch_App7_Full (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App7_Full(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- Филиал
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (BranchCode integer, BranchName TVarChar
             , GoodsSummStart TFloat, GoodsSummEnd TFloat, GoodsSummIn TFloat, GoodsSummOut TFloat
             , GoodsSummSale_SF TFloat, GoodsSummReturnIn_SF TFloat
             , CashSummStart TFloat, CashSummEnd TFloat, CashSummIn TFloat, CashSummOut TFloat, CashAmount TFloat
             , JuridicalSummStart TFloat, JuridicalSummEnd TFloat, JuridicalSummOut TFloat, JuridicalSummIn TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- CREATE TEMP TABLE _tmpBranch (BranchId Integer) ON COMMIT DROP;

    -- Филиал
    IF COALESCE (inBranchId, 0) = 0 AND 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
       RAISE EXCEPTION 'Ошибка. Не выбран Филиал.';
    /*ELSE
    IF COALESCE(inBranchId,0) = 0
    THEN
     --RAISE EXCEPTION 'Ошибка. Не выбран Филиал.';
       INSERT INTO _tmpBranch (BranchId)
           SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch() and Object.Id <> zc_Branch_Basis() and Object.isErased = False AND Object.ObjectCode not in (6,8,10) ;
    ELSE
       INSERT INTO _tmpBranch (BranchId)
           SELECT inBranchId;
    END IF;*/
    END IF;


    -- Результат
     RETURN QUERY
   WITH 
        _tmpBranch AS (SELECT Object.Id AS BranchId 
                       FROM Object WHERE Object.DescId = zc_Object_Branch() 
                        AND Object.Id <> zc_Branch_Basis() 
                        AND Object.isErased = False 
                        AND Object.ObjectCode not in (6,8,10)
                        AND COALESCE (inBranchId,0) = 0
                    UNION 
                       SELECT inBranchId 
                       WHERE inBranchId <> 0
                       )
         -- 
      , tmpUnitList AS (SELECT Object_Unit_View.*
                        FROM _tmpBranch
                            INNER JOIN Object_Unit_View ON Object_Unit_View.BranchId = _tmpBranch.BranchId
                        )

      , tmpCashList AS (SELECT Cash_Branch.ObjectId AS CashId
                              , _tmpBranch.BranchId
                        FROM _tmpBranch
                             INNER JOIN ObjectLink AS Cash_Branch
                                                   ON Cash_Branch.ChildObjectId = _tmpBranch.BranchId
                                                  AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                        )
      -- выбираем запасы и Прибыль будущих периодов
      , tmpObject_Account_View AS (SELECT *
                                   FROM Object_Account_View
                                   WHERE Object_Account_View.AccountDirectionId IN (zc_Enum_AccountDirection_20700(), zc_Enum_AccountDirection_60200())
                                  )
 
      , tmpContainerList AS (SELECT *
                             FROM tmpUnitList
                                 INNER JOIN ContainerLinkObject AS CLO_Unit
                                                    ON CLO_Unit.ObjectId = tmpUnitList.Id
                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                 INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                                     AND Container.DescId = zc_Container_Summ()
                                 INNER JOIN tmpObject_Account_View AS Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                             --WHERE Object_Account_View.AccountDirectionId IN ( zc_Enum_AccountDirection_20700()
                            )

      , tmpGoods AS (SELECT tmpContainerList.BranchId
                          , tmpContainerList.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0)                                              AS AmountStart
                          , tmpContainerList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE 
                                      THEN MIContainer.Amount ELSE 0 END)                                                                               AS SummIn
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE 
                                      THEN -1 * MIContainer.Amount ELSE 0 END)                                                                          AS SummOut
                     FROM tmpContainerList
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.ContainerId = tmpContainerList.ContainerId
                                                          AND MIContainer.OperDate >= inStartDate
                     GROUP BY tmpContainerList.ContainerId, tmpContainerList.Amount, tmpContainerList.BranchId
                    )


      , tmpGoodsSaleReturn AS (SELECT _tmpBranch.BranchId
                                     , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN  MIContainer.Amount                      --Sale
                                               ELSE 0 END) AS SummSale
                                     , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN -1* MIContainer.Amount               ---ReturnIn
                                               ELSE 0 END) AS SummReturnIn
                               FROM _tmpBranch
                                     INNER JOIN ContainerLinkObject AS CLO_Branch
                                                                    ON CLO_Branch.ObjectId = _tmpBranch.BranchId
                                                                   AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                     INNER JOIN Container ON Container.Id = CLO_Branch.ContainerId
                                                         AND Container.DescId = zc_Container_Summ()
                                     LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = Container.Id
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                     INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                               ON CLO_PaidKind.ContainerId = CLO_Branch.ContainerId
                                                              AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                              AND CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                               GROUP BY CLO_Branch.ContainerId, Container.Amount, _tmpBranch.BranchId
                               )

         -- нач. кон. сальдо касса , движение
      , tmpCash AS (SELECT tmpCashList.BranchId
                         , CLO_Cash.ContainerId
                         , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)                                                            AS AmountStart      -- остаток денег на начало периода
                         , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                         , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE 
                                     THEN MIContainer.Amount ELSE 0 END)                                                                        AS SummIn
                         , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE 
                                     THEN -1 * MIContainer.Amount ELSE 0 END)                                                                   AS SummOut
                    FROM tmpCashList
                        INNER JOIN ContainerLinkObject AS CLO_Cash
                                                       ON CLO_Cash.ObjectId = tmpCashList.CashId
                                                      AND CLO_Cash.DescId = zc_ContainerLinkObject_Cash()
                        INNER JOIN Container ON Container.Id = CLO_Cash.ContainerId
                                            AND Container.DescId = zc_Container_Summ()
                        LEFT JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.ContainerId = Container.Id
                                                       AND MIContainer.OperDate >= inStartDate
                    GROUP BY CLO_Cash.ContainerId, Container.Amount, tmpCashList.BranchId
                   )

      , tmpJuridical AS (SELECT _tmpBranch.BranchId
                              , SUM (CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount>0) THEN MIContainer.Amount ELSE 0 END) AS AmountDebet
                              , SUM (CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount<0) THEN MIContainer.Amount ELSE 0 END) AS AmountKredit
                              , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)                                                                            AS AmountStart -- остаток денег на начало периода
                              , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)                 AS AmountEnd
                              , SUM (CASE WHEN (MIContainer.MovementDescId = zc_Movement_Cash() 
                                            AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate ) THEN MIContainer.Amount ELSE 0 END)                         AS AmountCash  -- оплаты
                         FROM _tmpBranch
                              INNER JOIN ContainerLinkObject AS CLO_Branch
                                                             ON CLO_Branch.ObjectId = _tmpBranch.BranchId
                                                            AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()

                              INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                             ON CLO_Juridical.ContainerId = CLO_Branch.ContainerId
                                                            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND CLO_Juridical.ObjectId <> 0
                              INNER JOIN Container ON Container.Id     = CLO_Juridical.ContainerId
                                                  AND Container.DescId = zc_Container_Summ()
                              -- Только Дебиторы + покупатели                     
                              INNER JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                                                            AND Object_Account_View.AccountDirectionId IN (zc_Enum_AccountDirection_30100())
                              
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = Container.Id
                                                             AND MIContainer.OperDate >= inStartDate
                              INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                             ON CLO_PaidKind.ContainerId = CLO_Juridical.ContainerId
                                                            AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                            AND CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                         GROUP BY CLO_Juridical.ContainerId, Container.Amount, _tmpBranch.BranchId
                       )
      , tmpAll AS (SELECT tmpGoods.BranchId
                        , CAST (SUM (tmpGoods.AmountStart) AS NUMERIC (16, 2)) AS AmountStart
                        , CAST (SUM (tmpGoods.AmountEnd) AS NUMERIC (16, 2))   AS AmountEnd
                        , CAST (SUM (tmpGoods.SummIn) AS NUMERIC (16, 2))      AS SummIn
                        , CAST (SUM (tmpGoods.SummOut) AS NUMERIC (16, 2))     AS SummOut
                        , 0 AS SummSale
                        , 0 AS SummReturnIn
                        , 0 AS AmountStartCash
                        , 0 AS AmountEndCash
                        , 0 AS SummInCash
                        , 0 AS SummOutCash
 
                        , 0 AS AmountStartJuridical
                        , 0 AS AmountEndJuridical
                        , 0 AS AmountKreditJuridical
                        , 0 AS AmountDebetJuridical
                        , 0 AS CashAmountJuridical
 
                   FROM tmpGoods
                   GROUP BY tmpGoods.BranchId
                UNION ALL
                   SELECT tmpGoodsSaleReturn.BranchId
                        , 0 AS AmountStart
                        , 0 AS AmountEnd
                        , 0 AS SummIn
                        , 0 AS SummOut
                        , CAST (SUM (tmpGoodsSaleReturn.SummSale) AS NUMERIC (16, 2))       AS SummSale
                        , CAST (SUM (tmpGoodsSaleReturn.SummReturnIn) AS NUMERIC (16, 2))   AS SummReturnIn
                        , 0 AS AmountStartCash
                        , 0 AS AmountEndCash
                        , 0 AS SummInCash
                        , 0 AS SummOutCash
 
                        , 0 AS AmountStartJuridical
                        , 0 AS AmountEndJuridical
                        , 0 AS AmountKreditJuridical
                        , 0 AS AmountDebetJuridical
                        , 0 AS CashAmountJuridical
 
                   FROM tmpGoodsSaleReturn
                   GROUP BY tmpGoodsSaleReturn.BranchId
                UNION ALL
                   SELECT tmpCash.BranchId
                        , 0 AS AmountStart
                        , 0 AS AmountEnd
                        , 0 AS SummIn
                        , 0 AS SummOut
                        , 0 AS SummSale
                        , 0 AS SummReturnIn
                        , CAST (SUM (tmpCash.AmountStart) AS NUMERIC (16, 2)) AS AmountStartCash
                        , CAST (SUM (tmpCash.AmountEnd) AS NUMERIC (16, 2))   AS AmountEndCash
                        , CAST (SUM (tmpCash.SummIn) AS NUMERIC (16, 2))      AS SummInCash
                        , CAST (SUM (tmpCash.SummOut) AS NUMERIC (16, 2))     AS SummOutCash
                        , 0 AS AmountStartJuridical
                        , 0 AS AmountEndJuridical
                        , 0 AS AmountKreditJuridical
                        , 0 AS AmountDebetJuridical
                        , 0 AS CashAmountJuridical
                   FROM tmpCash
                   GROUP BY tmpCash.BranchId
                UNION ALL
                   SELECT tmpJuridical.BranchId
                        , 0 AS AmountStart
                        , 0 AS AmountEnd
                        , 0 AS SummIn
                        , 0 AS SummOut
                        , 0 AS SummSale
                        , 0 AS SummReturnIn
                        , 0 AS AmountStartCash
                        , 0 AS AmountEndCash
                        , 0 AS SummInCash
                        , 0 AS SummOutCash
                        , CAST (SUM (tmpJuridical.AmountStart) AS NUMERIC (16, 2))       AS AmountStartJuridical
                        , CAST (SUM (tmpJuridical.AmountEnd) AS NUMERIC (16, 2))         AS AmountEndJuridical
                        , CAST (-1* SUM (tmpJuridical.AmountKredit) AS NUMERIC (16, 2))  AS AmountKreditJuridical
                        , CAST (SUM (tmpJuridical.AmountDebet) AS NUMERIC (16, 2))       AS AmountDebetJuridical
                        , CAST (-1* SUM (tmpJuridical.AmountCash) AS NUMERIC (16, 2))    AS CashAmountJuridical
                   FROM tmpJuridical
                   GROUP BY tmpJuridical.BranchId
               )
   -- результат  
   SELECT Object_Branch.ObjectCode              AS BranchCode
        , Object_Branch.ValueData  ::TVarChar   AS BranchName

        , CAST (SUM (tmpAll.AmountStart)         AS TFloat) AS GoodsSummStart
        , CAST (SUM (tmpAll.AmountEnd)           AS TFloat) AS GoodsSummEnd
        , CAST (SUM (tmpAll.SummIn)              AS TFloat) AS GoodsSummIn
        , CAST (SUM (tmpAll.SummOut)             AS TFloat) AS GoodsSummOut

        , CAST (SUM (tmpAll.SummSale)      AS TFloat) AS GoodsSummSale_SF
        , CAST (SUM (tmpAll.SummReturnIn)  AS TFloat) AS GoodsSummReturnIn_SF

        , CAST (SUM (tmpAll.AmountStartCash)         AS TFloat) AS CashSummStart
        , CAST (SUM (tmpAll.AmountEndCash)           AS TFloat) AS CashSummEnd
        , CAST (SUM (tmpAll.SummInCash)              AS TFloat) AS CashSummIn
        , CAST (SUM (tmpAll.SummOutCash)             AS TFloat) AS CashSummOut

        , CAST (SUM (tmpAll.CashAmountJuridical)     AS TFloat) AS CashAmount

        , CAST (SUM (tmpAll.AmountStartJuridical)         AS TFloat) AS JuridicalSummStart
        , CAST (SUM (tmpAll.AmountEndJuridical)           AS TFloat) AS JuridicalSummEnd
        , CAST (SUM (tmpAll.AmountKreditJuridical)        AS TFloat) AS JuridicalSummOut
        , CAST (SUM (tmpAll.AmountDebetJuridical)         AS TFloat) AS JuridicalSummIn

   FROM tmpAll
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpAll.BranchId   --CASE WHEN COALESCE(inBranchId,0) <> 0 THEN inBranchId END
   GROUP BY  Object_Branch.ValueData  ,Object_Branch.ObjectCode
   ORDER BY Object_Branch.ValueData
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.11.15         *
*/

-- тест
-- SELECT * FROM gpReport_Branch_App7_Full (inStartDate:= '01.08.2017', inEndDate:= '01.08.2017', inBranchId:= 8374, inSession:= zfCalc_UserAdmin())

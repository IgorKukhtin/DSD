-- Function: gpUpdate_Movement_PromoTradeHistory()

DROP FUNCTION IF EXISTS gpUpdate_Movement_PromoTradeHistory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_PromoTradeHistory(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd   TDateTime;
   DECLARE vbOperDate      TDateTime;
   DECLARE vbJuridicalId   Integer;
   DECLARE vbContractId    Integer;
   DECLARE vbAccountId     Integer;
   DECLARE vbPaidKindId    Integer;

   DECLARE vbMovementId_PromoTradeHistory Integer;
  -- DECLARE vbRetailId      Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());


     -- ��������� �� ���������
     SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
          , MovementLinkObject_Contract.ObjectId        AS ContractId
          , ObjectLink_Contract_PaidKind.ChildObjectId  AS PaidKindId
            -- ���������� ������/�������� �� ��������� 3 ������
          , MovementDate_OperDateStart.ValueData        AS OperDateStart
            -- ���������� ������/�������� �� ��������� 3 ������
          , MovementDate_OperDateEnd.ValueData          AS OperDateEnd

          , Movement_PromoTrade.OperDate

            INTO vbJuridicalId, vbContractId, vbPaidKindId
               , vbOperDateStart, vbOperDateEnd, vbOperDate
     FROM Movement AS Movement_PromoTrade
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement_PromoTrade.Id
                                      AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()

          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                               ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                               ON ObjectLink_Contract_PaidKind.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement_PromoTrade.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement_PromoTrade.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

     WHERE Movement_PromoTrade.Id = inMovementId
    ;

     -- ��������� - ����
     vbAccountId:= (SELECT Object_Account_View.AccountId
                    FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                         LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                              ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Contract_InfoMoney.ChildObjectId
                                             AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                         INNER JOIN Object_Account_View
                                 ON Object_Account_View.InfoMoneyDestinationId = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
                                 -- 30000; "��������"; 30100; "����������"
                                AND Object_Account_View.AccountDirectionId     = zc_Enum_AccountDirection_30100()
                    WHERE ObjectLink_Contract_InfoMoney.ObjectId = vbContractId
                      AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                   );

     IF COALESCE (vbAccountId, 0) = 0
     THEN
         RAISE EXCEPTION '������.���� �� ������ ��� <%> + <%>.'
                       , lfGet_Object_ValueData (vbContractId)
                       , lfGet_Object_ValueData ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbContractId AND OL.DescId   = zc_ObjectLink_Contract_InfoMoney()))
                        ;
     END IF;



    -- ����� PromoTradeCondition - ������� �������
    vbMovementId_PromoTradeHistory := (SELECT Movement.Id
                                       FROM Movement
                                       WHERE Movement.DescId    = zc_Movement_PromoTradeHistory()
                                         AND Movement.ParentId =  inMovementId
                                      );

    -- ���� �� �����
    IF COALESCE (vbMovementId_PromoTradeHistory,0) = 0
    THEN
        -- ������� ��������
        vbMovementId_PromoTradeHistory:= (SELECT lpInsertUpdate_Movement (0, zc_Movement_PromoTradeHistory(), Movement.InvNumber, Movement.OperDate, Movement.Id, 0)
                                          FROM Movement
                                          WHERE Movement.Id = inMovementId
                                         );
    END IF;


     -- ������ �� ������������ ����������� �������������
     CREATE TEMP TABLE _tmpJuridical (AccountId Integer, JuridicalId Integer, PartnerId Integer, BranchId Integer, PaidKindId Integer, ContractId Integer
                                      -- ���� � ���������
                                    , DefermentPaymentRemains TFloat
                                      -- ���� � ��������� - �� ���������
                                    , TotalSumm_diff_Deferment TFloat
                                      -- ���. ���� ��������
                                    , DayCount_condition TFloat
                                      -- ���������� ���� - �� ���������
                                    , DelayDay_calc TFloat
                                      -- �����
                                    , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
                                     ) ON COMMIT DROP;

     -- ������
     INSERT INTO _tmpJuridical (AccountId, JuridicalId, PartnerId, BranchId, PaidKindId, ContractId
                                -- ���� � ���������
                              , DefermentPaymentRemains
                                -- ���� � ��������� - �� ���������
                              , TotalSumm_diff_Deferment
                                -- ���. ���� ��������
                              , DayCount_condition
                                -- ���������� ���� - �� ���������
                              , DelayDay_calc
                                -- �����
                              , SaleSumm1, SaleSumm2, SaleSumm3, SaleSumm4, SaleSumm5
                               )
        -- ���������
        SELECT gpReport.AccountId, gpReport.JuridicalId, gpReport.PartnerId, gpReport.BranchId, gpReport.PaidKindId, gpReport.ContractId
               -- ���� � ���������
             , gpReport.DefermentPaymentRemains
               -- ���� � ��������� - �� ���������
             , gpReport.TotalSumm_diff_Deferment
               -- ���. ���� ��������
             , gpReport.DayCount_condition
               -- ���������� ���� - �� ���������
             , gpReport.DelayDay_calc
               -- �����
             , gpReport.SaleSumm1, gpReport.SaleSumm2, gpReport.SaleSumm3, gpReport.SaleSumm4, gpReport.SaleSumm5

        FROM gpReport_JuridicalDefermentPaymentMovement_jur(inOperDate         := vbOperDate
                                                          , inEmptyParam       := vbOperDate
                                                          , inAccountId        := vbAccountId
                                                          , inPaidKindId       := vbPaidKindId
                                                          , inBranchId         := 0
                                                          , inJuridicalGroupId := 0
                                                          , inJuridicalId      := vbJuridicalId
                                                          , inContractId       := vbContractId
                                                          , inSession          := inSession
                                                           ) AS gpReport;


     -- ������ �� ��������/���������
     CREATE TEMP TABLE _tmpData (SaleAmount TFloat, ReturnAmount TFloat, SaleSumm TFloat, ReturnSumm TFloat) ON COMMIT DROP;

     -- ������
     INSERT INTO _tmpData (SaleAmount, ReturnAmount, SaleSumm, ReturnSumm)
        WITH tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                                  , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                             FROM Constant_ProfitLoss_AnalyzerId_View
                            )
           , tmpContainer AS (SELECT MIContainer.ObjectId_analyzer    AS GoodsId
                                   , MIContainer.ObjectIntId_analyzer AS GoodsKindId

                                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()
                                                    THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                               ELSE 0
                                          END) AS Sale_AmountPartner
                                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800()
                                                    THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                               ELSE 0
                                          END) AS Return_AmountPartner

                                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                                   , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ
                              FROM tmpAnalyzer
                                     INNER JOIN MovementItemContainer AS MIContainer
                                                                      ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                     AND MIContainer.OperDate BETWEEN vbOperDateStart AND vbOperDateEnd     --'01.06.2024' AND '31.08.2024'--
                                                                     AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                     INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                    ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                                   AND ContainerLO_Juridical.DescId      = zc_ContainerLinkObject_Juridical()
                                                                   AND ContainerLO_Juridical.ObjectId    = vbJuridicalId  --15412  -- 14866 --vbJuridicalId inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)

                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                   ON MovementLinkObject_Contract.MovementId = MIContainer.MovementId
                                                                  AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                  AND MovementLinkObject_Contract.ObjectId   = vbContractId

                                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                         ON ObjectLink_Goods_Measure.ObjectId = MIContainer.ObjectId_analyzer
                                                        AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                          ON ObjectFloat_Weight.ObjectId = MIContainer.ObjectId_analyzer
                                                         AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                                     --INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                                      --                  AND (COALESCE (tmpGoods.GoodsKindId,0) = COALESCE (MIContainer.ObjectIntId_analyzer,0) OR COALESCE (tmpGoods.GoodsKindId,0) = 0)

                              GROUP BY MIContainer.ObjectId_analyzer
                                     , MIContainer.ObjectIntId_analyzer
                              )
        -- ���������
        SELECT SUM (tmpContainer.Sale_AmountPartner)   AS SaleAmount
             , SUM (tmpContainer.Return_AmountPartner) AS ReturnAmount
             , SUM (tmpContainer.Sale_Summ)            AS SaleSumm
             , SUM (tmpContainer.Return_Summ)          AS ReturnSumm
        FROM tmpContainer
       ;


      -- ��������� -
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountSale(), vbMovementId_PromoTradeHistory, COALESCE (_tmpData.SaleAmount, 0))
            , lpInsertUpdate_MovementFloat (zc_MovementFloat_SummSale(), vbMovementId_PromoTradeHistory, COALESCE (_tmpData.SaleSumm, 0))
            , lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountReturnIn(), vbMovementId_PromoTradeHistory, COALESCE (_tmpData.ReturnAmount, 0))
            , lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReturnIn(), vbMovementId_PromoTradeHistory, COALESCE (_tmpData.ReturnSumm, 0))
      FROM (SELECT 1 AS x) AS a
           CROSS JOIN _tmpData
     ;


      -- ���������
      PERFORM -- ������������ ����������� �������������, ����
              lpInsertUpdate_MovementFloat (zc_MovementFloat_DebtDay(), vbMovementId_PromoTradeHistory, COALESCE (_tmpJuridical.DelayDay_calc, 0))

              -- ������������ ����������� �������������, ����
              -- lpInsertUpdate_MovementFloat (zc_MovementFloat_DebtDay(), vbMovementId_PromoTradeHistory, COALESCE (_tmpJuridical.DelayDay_calc_1 + _tmpJuridical.DelayDay_calc_2 + _tmpJuridical.DelayDay_calc_3 + _tmpJuridical.DelayDay_calc_4 + _tmpJuridical.DelayDay_calc_5, 0))

              -- ������������ ����������� �������������, ��� 
               , lpInsertUpdate_MovementFloat (zc_MovementFloat_DebtSumm(), vbMovementId_PromoTradeHistory, COALESCE (_tmpJuridical.TotalSumm_diff_Deferment, 0))

              -- ������������ ����������� �������������, ��� 
            --, lpInsertUpdate_MovementFloat (zc_MovementFloat_DebtSumm(), vbMovementId_PromoTradeHistory, COALESCE (_tmpJuridical.DefermentPaymentRemains, 0))

      FROM (SELECT 1 AS x) AS a
           CROSS JOIN (SELECT -- ���� � ���������
                              SUM (_tmpJuridical.DefermentPaymentRemains)  AS DefermentPaymentRemains
                              -- ���� � ��������� - �� ���������
                            , SUM (_tmpJuridical.TotalSumm_diff_Deferment) AS TotalSumm_diff_Deferment
                            
                              -- ���������� ���� - �� ���������
                            , MAX (CASE WHEN _tmpJuridical.TotalSumm_diff_Deferment > 0 THEN _tmpJuridical.DelayDay_calc ELSE 0 END) AS DelayDay_calc

                              -- ���������� ���� - �� ���������
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm1) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_1
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm2) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_2
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm3) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_3
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm4) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_4
                            , CASE WHEN SUM (_tmpJuridical.SaleSumm5) > 0 THEN 7 ELSE 0 END AS DelayDay_calc_5

                       FROM _tmpJuridical
                      ) AS _tmpJuridical
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.09.24         *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_PromoTradeHistory (inMovementId:= 29309489 , inSession:= zfCalc_UserAdmin())

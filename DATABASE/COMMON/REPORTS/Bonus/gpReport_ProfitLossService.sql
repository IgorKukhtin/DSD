-- Function: gpReport_ProfitLossService ()

DROP FUNCTION IF EXISTS gpReport_ProfitLossService (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLossService (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, MovementDescName TVarChar
              -- ��.�. - �������
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
               -- ��.�. - ����
             , JuridicalId_baza Integer, JuridicalCode_baza Integer, JuridicalName_baza TVarChar
               -- ������� (����)
             , ContractChildCode Integer, ContractChildName TVarChar
               -- ������� (����������)
             , ContractCode Integer, ContractName TVarChar
               -- ������� (�������)
             , ContractCode_Master Integer, ContractName_Master TVarChar
               -- ���� ������� ���������
             , ContractConditionKindName TVarChar

             , PaidKindName TVarChar, PaidKindName_Child TVarChar
             , InfoMoneyName TVarChar, InfoMoneyName_Child TVarChar

             , MovementId_doc Integer, OperDate_Doc TDateTime, InvNumber_doc TVarChar, InvNumber_full_doc TVarChar, MovementDescName_doc TVarChar
             --, TradeMarkName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , MeasureName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupPropertyId Integer, GoodsGroupPropertyName TVarChar
             , GoodsGroupPropertyId_Parent Integer, GoodsGroupPropertyName_Parent TVarChar
             , AmountIn TFloat, AmountOut TFloat, Amount TFloat

               -- ����������� �� ���, �� - ***�����
             , AmountMarket        TFloat
               -- �����������,��� - ***�����
             , SummMarket          TFloat
               -- ��������� �������,��� - ***�����
             , CostPromo_m         TFloat
               -- ��������� ������� - ***�����-���������
             , CostPromo_mi        TFloat

             , SummAmount          TFloat -- ����� �������
             , TotalSumm           TFloat -- ����� ������� �� ��.���� + �������
             , TotalSumm_tm        TFloat --
             , TotalSumm_gp        TFloat --
             , TotalSumm_gpp       TFloat --

             , Persent_part        TFloat
             , Persent_part_tm     TFloat
             , Persent_part_gp     TFloat
             , Persent_part_gpp    TFloat

               -- ������ - �����������, ���
             , SummMarket_calc     TFloat --
               -- ������ - ��������� �������,��� (�����)
             , CostPromo_m_calc    TFloat --
               -- ������ - ��������� �������, ��� (�����-���������)
             , CostPromo_mi_calc   TFloat --
             )

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- ���������
    RETURN QUERY
      WITH
      -- ������� - ProfitLossService + Service
      tmpMovement_all AS (SELECT Movement.*
                          FROM Movement
                          WHERE Movement.OperDate BETWEEN CASE WHEN vbUserId = 5 AND 1=1 THEN DATE_TRUNC ('MONTH', inStartDate + INTERVAL '1 MONTH') ELSE inStartDate END
                                                      AND CASE WHEN vbUserId = 5 AND 1=1 THEN DATE_TRUNC ('MONTH', inStartDate + INTERVAL '1 MONTH')  + INTERVAL '1 MONTH' ELSE inEndDate   END
                            AND Movement.DescId   IN (zc_Movement_ProfitLossService(), zc_Movement_Service())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                         )
      -- ������� ���� - ��� ����� / �����-���������
    , tmpMLM_doc AS (SELECT MLM.*
                     FROM MovementLinkMovement AS MLM
                     WHERE MLM.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                       AND MLM.DescId = zc_MovementLinkMovement_Doc()
                       AND MLM.MovementChildId > 0
                    )
      -- ������� ���� �� - ����� �� ���� �������� (�� ����� ���� + ������ ���.����)
    , tmpMLO_TM AS (SELECT MovementLinkObject.*
                    FROM MovementLinkObject
                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                      AND MovementLinkObject.DescId = zc_MovementLinkObject_TradeMark()
                      AND MovementLinkObject.ObjectId > 0
                   )
     -- ���������� ������ - ������ �� ��� ����� ������������ - �� + ��� ����� / �����-���������
   , tmpMovement_find AS (SELECT Movement.*
                               , COALESCE (tmpMLM_doc.MovementChildId, 0) AS MovementId_doc
                               , COALESCE (tmpMLO_TM.ObjectId, 0)         AS TradeMarkId
                          FROM tmpMovement_all AS Movement
                               LEFT JOIN tmpMLM_doc ON tmpMLM_doc.MovementId = Movement.Id
                               LEFT JOIN tmpMLO_TM  ON tmpMLO_TM.MovementId  = Movement.Id
                          -- ���� �� ��� ��� ����� / �����-���������
                          WHERE tmpMLM_doc.MovementId > 0
                             OR tmpMLO_TM.MovementId  > 0
                         )
      -- ����� ���������� - �������
    , tmpMI AS (SELECT MovementItem.MovementId
                     , MovementItem.Id
                     , MovementItem.ObjectId
                     , CASE WHEN 1=0 -- MovementItem.Amount > 0
                                 THEN MovementItem.Amount
                            ELSE 0
                       END::TFloat AS AmountIn
                     , CASE WHEN 1=1 -- MovementItem.Amount < 0
                                 THEN -1 * MovementItem.Amount - MovementItem.Amount
                            ELSE 0
                       END::TFloat AS AmountOut
                     , -1 * MovementItem.Amount AS Amount
                FROM MovementItem
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_find.Id FROM tmpMovement_find)
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                  AND MovementItem.Amount <> 0
               )
      -- ��-��  - �������
    , tmpMILO AS (SELECT MovementItemLinkObject.*
                  FROM MovementItemLinkObject
                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                    AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Contract()
                                                        , zc_MILinkObject_ContractMaster()
                                                        , zc_MILinkObject_ContractChild()
                                                        , zc_MILinkObject_InfoMoney()
                                                        , zc_MILinkObject_PaidKind()
                                                        , zc_MILinkObject_ContractConditionKind()
                                                         )
                  )
      -- ���������� ������ - ������ �� ��� ����� ������������ - �� + ProfitLossService + Service
    , tmpMovement AS (SELECT Movement.Id              AS MovementId
                             -- ProfitLossService or Service
                           , Movement.DescId          AS MovementDescId
                             --
                           , Movement.OperDate
                           , Movement.InvNumber
                             -- ��� ���� - ����� / �����-���������
                           , Movement.MovementId_doc
                             -- ��� ��
                           , Movement.TradeMarkId

                           , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0)                AS JuridicalId
                           , CASE WHEN ObjectLink_Partner_Juridical.ChildObjectId > 0 THEN MovementItem.ObjectId ELSE 0 END AS PartnerId

                             -- ������� (���������� ������)
                           , MILinkObject_Contract.ObjectId               AS ContractId
                             -- ������� (����)
                           , COALESCE (MILinkObject_ContractChild.ObjectId, 0) AS ContractChildId
                             -- ������� (�������)
                           , MILinkObject_ContractMaster.ObjectId         AS ContractMasterId
                             -- ���� ������� ���������
                           , MILinkObject_ContractConditionKind.ObjectId  AS ContractConditionKindId
                             -- ��-������ � ���������� ������
                           , MILinkObject_InfoMoney.ObjectId              AS InfoMoneyId
                           , MILinkObject_PaidKind.ObjectId               AS PaidKindId

                           , MovementItem.AmountIn
                           , MovementItem.AmountOut
                           , MovementItem.Amount

                      FROM tmpMovement_find AS Movement
                           LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

                           -- �� ����, ���� ������ ���������� �� ��� �� ����
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                           -- �������(����)
                           LEFT JOIN tmpMILO AS MILinkObject_ContractChild
                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()

                           LEFT JOIN tmpMILO AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           -- �������(�������)
                           LEFT JOIN tmpMILO AS MILinkObject_ContractMaster
                                             ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
                           -- ������� (����������)
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                            ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                           -- ����� ������
                           LEFT JOIN tmpMILO AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

                           -- ���� ������� ���������
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                            ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                     )
      -- �������� ����� / �����-���������
    , tmpMI_doc AS (SELECT MovementItem.*
                           -- � �/�
                         , ROW_NUMBER() OVER (PARTITION BY MovementItem.MovementId ORDER BY MovementItem.Id ASC) AS Ord
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMLM_doc.MovementChildId AS MovementId_doc FROM tmpMLM_doc)
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                    )
      -- ����� - ��������� �������
    , tmpMovementFloat_CostPromo AS (SELECT MovementFloat.*
                                     FROM MovementFloat
                                     WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMLM_doc.MovementChildId FROM tmpMLM_doc)
                                       AND MovementFloat.DescId     = zc_MovementFloat_CostPromo()  -- ��������� ������� - ***�����
                                       AND MovementFloat.ValueData  <> 0
                                    )
      -- ����� - �������� ����� / �����-���������
    , tmpMIFloat_doc AS (SELECT MovementItemFloat.*
                         FROM MovementItemFloat
                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_doc.Id FROM tmpMI_doc)
                           AND MovementItemFloat.DescId IN (zc_MIFloat_AmountMarket()  -- ����������� �� ���, �� - ***�����
                                                          , zc_MIFloat_SummOutMarket() -- �����������,��� - ***�����
                                                          , zc_MIFloat_SummInMarket()  -- ������������� �����������,��� - ***�����
                                                          , zc_MIFloat_Summ()          -- ��������� ������� - ***�����-���������
                                                           )
                           AND MovementItemFloat.ValueData <> 0
                        )
      -- ��-�� - �������� ����� / �����-���������
    , tmpMILO_doc AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_doc.Id FROM tmpMI_doc)
                        AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()           -- ��� ������
                                                            , zc_MILinkObject_TradeMark()           -- �������� �����
                                                            , zc_MILinkObject_GoodsGroupProperty()  -- ������������� �������������
                                                            , zc_MILinkObject_GoodsGroupDirection() -- ������������� ������ �����������
                                                            )

                     )
      -- �������� ��� ��.� ��� ����������� - �� ��� ��� �������
    , tmpData_Contact AS (-- �����
                          SELECT DISTINCT
                                 Movement_Partner.ParentId AS MovementId_doc
                               , zc_Movement_Promo()       AS MovementDescId
                                 -- ����� ������ ��� ���� - �����
                               , COALESCE (MLO_PaidKind.ObjectId, 0) AS PaidKindId
                                 -- ������������� ������� ���� �� ���������� ������
                               , COALESCE (MLO_Contract.ObjectId, tmpMovement.ContractChildId, tmpMovement_next.ContractChildId, 0) AS ContractId
                                 --
                               , CASE WHEN Object_Partner.DescId = zc_Object_Juridical() THEN Object_Partner.Id ELSE 0 END AS JuridicalId
                               , CASE WHEN Object_Partner.DescId = zc_Object_Partner()   THEN Object_Partner.Id ELSE 0 END AS PartnerId
                                 -- ��-������, ���� ����� ���������� ������
                               , COALESCE (tmpMovement.InfoMoneyId, 0) AS InfoMoneyId_service

                          FROM Movement AS Movement_Partner
                               -- ����� ������ ��� ���� - �����
                               LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                                            ON MLO_PaidKind.MovementId = Movement_Partner.ParentId
                                                           AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()

                               -- ������� - ���� ����
                               LEFT JOIN MovementLinkObject AS MLO_Contract
                                                            ON MLO_Contract.MovementId = Movement_Partner.Id
                                                           AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                               -- ���������� or �� ���� or �� �������� ����
                               LEFT JOIN MovementLinkObject AS MLO_Partner
                                                            ON MLO_Partner.MovementId = Movement_Partner.Id
                                                           AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MLO_Partner.ObjectId

                               -- ��� - ��-������
                               LEFT JOIN Movement AS Movement_InfoMoney ON Movement_InfoMoney.ParentId = Movement_Partner.ParentId
                                                                       AND Movement_InfoMoney.DescId   = zc_Movement_InfoMoney()
                                                                       AND Movement_InfoMoney.StatusId <> zc_Enum_Status_Erased()
                               --  ������ ��� ����� �����������
                               LEFT JOIN MovementLinkObject AS MLO_InfoMoney_Market
                                                            ON MLO_InfoMoney_Market.MovementId = Movement_InfoMoney.Id
                                                           AND MLO_InfoMoney_Market.DescId     = zc_MovementLinkObject_InfoMoney_Market()
                               -- ������ ��� ��������� �������
                               LEFT JOIN MovementLinkObject AS MLO_InfoMoney_CostPromo
                                                            ON MLO_InfoMoney_CostPromo.MovementId = Movement_InfoMoney.Id
                                                           AND MLO_InfoMoney_CostPromo.DescId     = zc_MovementLinkObject_InfoMoney_CostPromo()
                                                           AND MLO_InfoMoney_CostPromo.ObjectId   <> MLO_InfoMoney_Market.ObjectId

                               -- ����� ������� � ���������� ������
                               LEFT JOIN (SELECT tmpMovement.MovementId_doc, tmpMovement.InfoMoneyId
                                                 -- �� ������ ������
                                               , MIN (tmpMovement.ContractChildId) AS ContractChildId
                                          FROM tmpMovement
                                          GROUP BY tmpMovement.MovementId_doc, tmpMovement.InfoMoneyId
                                         ) AS tmpMovement
                                           ON tmpMovement.MovementId_doc = Movement_Partner.ParentId
                                          AND (tmpMovement.InfoMoneyId    = MLO_InfoMoney_CostPromo.ObjectId
                                            OR tmpMovement.InfoMoneyId    = MLO_InfoMoney_Market.ObjectId
                                              )
                               -- ����� ������� � ���������� ������
                               LEFT JOIN (SELECT DISTINCT
                                                 tmpMovement.MovementId_doc
                                                 -- ???�� ������ ������???
                                               , (tmpMovement.ContractChildId) AS ContractChildId
                                          FROM tmpMovement
                                          -- GROUP BY tmpMovement.MovementId_doc
                                         ) AS tmpMovement_next
                                           ON tmpMovement_next.MovementId_doc = Movement_Partner.ParentId
                                          -- ���� � ��� ��� - ��-������
                                          AND Movement_InfoMoney.ParentId IS NULL

                          WHERE Movement_Partner.DescId = zc_Movement_PromoPartner()
                            AND Movement_Partner.StatusId <> zc_Enum_Status_Erased()
                            AND Movement_Partner.ParentId IN (SELECT DISTINCT tmpMLM_doc.MovementChildId FROM tmpMLM_doc)

                         UNION
                          -- �����-���������
                          SELECT MLO_Contract.MovementId  AS MovementId_doc
                               , zc_Movement_PromoTrade() AS MovementDescId
                                 -- ����� ������ ��� ���� - �����-���������
                               , COALESCE (MLO_PaidKind.ObjectId, 0) AS PaidKindId
                                 -- ������� ����
                               , MLO_Contract.ObjectId    AS ContractId
                                 -- �� ������������
                               , 0 AS JuridicalId
                               , 0 AS PartnerId
                                 --
                               , 0 AS InfoMoneyId_service
                          FROM MovementLinkObject AS MLO_Contract
                               -- ����� ������ ��� ���� - �����-���������
                               LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                                            ON MLO_PaidKind.MovementId = MLO_Contract.MovementId
                                                           AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                          WHERE MLO_Contract.MovementId IN (SELECT DISTINCT tmpMLM_doc.MovementChildId AS MovementId_doc FROM tmpMLM_doc)
                            AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                            -- ������ ���� ������
                            AND MLO_Contract.ObjectId > 0

                         /*UNION
                          -- ���������� ������
                          SELECT DISTINCT
                                 tmpMovement.MovementId_doc  AS MovementId_doc
                               , 0                           AS MovementDescId
                                 -- ����� ������ ��� ���� - ����� / �����-���������
                               , COALESCE (MLO_PaidKind.ObjectId, 0) AS PaidKindId
                                 -- ������� ����
                               , tmpMovement.ContractChildId    AS ContractId
                                 -- �� ������������
                               , 0 AS JuridicalId
                               , 0 AS PartnerId
                                 --
                               , 0 AS InfoMoneyId_service

                          FROM tmpMovement
                               LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                                            ON MLO_PaidKind.MovementId = tmpMovement.MovementId_doc
                                                           AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()*/
                         )

      -- ������� + ����� / �����-���������
    , tmpData AS (SELECT tmpMovement.MovementId
                       , tmpMovement.MovementDescId
                       , tmpMovement.OperDate
                       , tmpMovement.InvNumber
                         -- �� � ��������� ���������� ������
                       , COALESCE (tmpMovement.TradeMarkId, 0)         AS TradeMarkId

                        -- �������� ����� / �����-���������
                       , tmpMovement.MovementId_doc

                         -- �� � ������� ����� / �����-���������
                       , COALESCE (MILinkObject_TradeMark.ObjectId, 0) AS TradeMarkId_doc

                         -- ������������� ������������� - �������-1 - � ������� ����� / �����-���������
                       , COALESCE (Object_GoodsGroupPropertyParent.Id, 0)            AS GoodsGroupPropertyId_Parent
                         -- ������������� ������������� - �������-2 - � ������� ����� / �����-���������
                       , COALESCE (Object_GoodsGroupProperty.Id, 0)                  AS GoodsGroupPropertyId
                         -- ������������� ������ ����������� - � ������� ����� / �����-���������
                       , COALESCE (MILinkObject_GoodsGroupDirection.ObjectId, 0)     AS GoodsGroupDirectionId

                         -- �� ���� / ���������� - � ��������� ���������� ������
                       , tmpMovement.JuridicalId
                       , tmpMovement.PartnerId
                         -- ������� (���������� ������)
                       , tmpMovement.ContractId
                         -- ������� (���� - � ���������� ������)
                       , tmpMovement.ContractChildId
                         -- ������� (������� - � ���������� ������)
                       , tmpMovement.ContractMasterId
                         -- ������������ (� ���������� ������)
                       , tmpMovement.PaidKindId
                         -- �� ������ (� ���������� ������)
                       , tmpMovement.InfoMoneyId
                         -- ������������ (� ���������� ������)
                       , tmpMovement.ContractConditionKindId

                         -- �� � ��������� ����� / �����-���������
                       , COALESCE (MLO_PaidKind.ObjectId, 0) AS PaidKindId_doc
                         -- �������� ���� - 1:N ��� �� ������
                       , 0 AS RetaillId_doc
                         -- ��.�. - 1:N ��� �� ������
                       , 0 AS JuridicalId_doc
                         -- ���������� - 1:N ��� �� ������
                       , 0 AS PartnerId_doc
                         -- ������� - 1:N ��� 1:1 ��� �� ������
                       , COALESCE (MLO_Contract.ObjectId, 0) AS ContractId_doc

                         -- ����
                       , COALESCE (MovementItem.ObjectId, 0) AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                         -- �������
                       , tmpMovement.AmountIn
                       , tmpMovement.AmountOut
                       , tmpMovement.Amount

                         -- ����������� �� ���, �� - ***�����
                       , CASE WHEN tmpMovement.InfoMoneyId = MLO_InfoMoney_Market.ObjectId OR tmpMovementFloat_CostPromo.MovementId IS NULL
                                   THEN COALESCE (MIFloat_AmountMarket.ValueData, 0)
                              ELSE 0
                         END ::TFloat AS AmountMarket

                         -- �����������,��� - ***�����
                       , CASE -- ���� ��� �������
                              --WHEN (tmpMovement.InfoMoneyId = MLO_InfoMoney_Market.ObjectId OR tmpMovementFloat_CostPromo.MovementId IS NULL)
                              -- AND Movement_Doc.DescId = zc_Movement_Promo() AND COALESCE (MovementItem.ObjectId, 0) = 0
                              --     THEN tmpMovement.Amount

                              WHEN tmpMovement.InfoMoneyId = MLO_InfoMoney_Market.ObjectId OR tmpMovementFloat_CostPromo.MovementId IS NULL
                                   THEN (COALESCE (MIFloat_SummOutMarket.ValueData, 0) - COALESCE (MIFloat_SummInMarket.ValueData, 0))
                              ELSE 0
                         END ::TFloat AS SummMarket

                         -- ��������� �������,��� - ***�����
                       , CASE -- ���� ��� �������
                              --WHEN COALESCE (MovementItem.Ord, 0) <= 1
                              -- AND (tmpMovement.InfoMoneyId = MLO_InfoMoney_CostPromo.ObjectId OR tmpMovementFloat_CostPromo.MovementId IS NULL)
                              -- AND Movement_Doc.DescId = zc_Movement_Promo() AND COALESCE (MovementItem.ObjectId, 0) = 0
                              --     THEN tmpMovement.Amount

                              WHEN COALESCE (MovementItem.Ord, 0) <= 1
                               AND (tmpMovement.InfoMoneyId = MLO_InfoMoney_CostPromo.ObjectId OR tmpMovementFloat_CostPromo.MovementId IS NULL)
                                   THEN COALESCE (tmpMovementFloat_CostPromo.ValueData, 0)
                              ELSE 0
                         END ::TFloat AS CostPromo_m

                         -- ��������� ������� - ***�����-���������
                       , CASE -- ���� ��� �������
                              --WHEN Movement_Doc.DescId = zc_Movement_PromoTrade() AND COALESCE (MovementItem.ObjectId, 0) = 0
                              --     THEN tmpMovement.Amount

                              WHEN Movement_Doc.DescId = zc_Movement_PromoTrade()
                                   THEN COALESCE (MIFloat_Summ.ValueData, 0)
                              ELSE 0
                         END ::TFloat AS CostPromo_mi

                         -- ������ ��� ��������� �������
                       , MLO_InfoMoney_CostPromo.ObjectId AS InfoMoneyId_CostPromo
                         --  ������ ��� ����� �����������
                       , MLO_InfoMoney_Market.ObjectId    AS InfoMoneyId_Market

                  FROM tmpMovement
                       -- ����� / �����-���������
                       LEFT JOIN Movement AS Movement_Doc ON Movement_Doc.Id = tmpMovement.MovementId_doc

                       -- ����� - ��������� �������
                       LEFT JOIN tmpMovementFloat_CostPromo ON tmpMovementFloat_CostPromo.MovementId = tmpMovement.MovementId_doc

                       -- ����� - ��� ��-������
                       LEFT JOIN Movement AS Movement_InfoMoney ON Movement_InfoMoney.ParentId = tmpMovement.MovementId_doc
                                                               AND Movement_InfoMoney.DescId   = zc_Movement_InfoMoney()
                                                               AND Movement_InfoMoney.StatusId <> zc_Enum_Status_Erased()
                       --  ������ ��� ����� �����������
                       LEFT JOIN MovementLinkObject AS MLO_InfoMoney_Market
                                                    ON MLO_InfoMoney_Market.MovementId = Movement_InfoMoney.Id
                                                   AND MLO_InfoMoney_Market.DescId     = zc_MovementLinkObject_InfoMoney_Market()
                       -- ������ ��� ��������� �������
                       LEFT JOIN MovementLinkObject AS MLO_InfoMoney_CostPromo
                                                    ON MLO_InfoMoney_CostPromo.MovementId = Movement_InfoMoney.Id
                                                   AND MLO_InfoMoney_CostPromo.DescId     = zc_MovementLinkObject_InfoMoney_CostPromo()
                                                   AND MLO_InfoMoney_CostPromo.ObjectId    <> MLO_InfoMoney_Market.ObjectId

                       -- ����� ������ ��� ���� - ����� / �����-���������
                       LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                                    ON MLO_PaidKind.MovementId = tmpMovement.MovementId_doc
                                                   AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()

                       -- ������� ��� ���� - �����-���������
                       LEFT JOIN MovementLinkObject AS MLO_Contract
                                                    ON MLO_Contract.MovementId = tmpMovement.MovementId_doc
                                                   AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()

                       -- ������� ����� / �����-���������
                       LEFT JOIN tmpMI_doc AS MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_doc
                       -- ����
                       LEFT JOIN tmpMILO_doc AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       -- ����������� �� ���, �� - ***�����
                       LEFT JOIN tmpMIFloat_doc AS MIFloat_AmountMarket
                                                ON MIFloat_AmountMarket.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountMarket.DescId = zc_MIFloat_AmountMarket()
                       -- �����������,��� - ***�����
                       LEFT JOIN tmpMIFloat_doc AS MIFloat_SummOutMarket
                                                ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                               AND MIFloat_SummOutMarket.DescId = zc_MIFloat_SummOutMarket()
                       -- ������������� �����������,��� - ***�����
                       LEFT JOIN tmpMIFloat_doc AS MIFloat_SummInMarket
                                                ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                               AND MIFloat_SummInMarket.DescId = zc_MIFloat_SummInMarket()
                       -- ��������� ������� - ***�����-���������
                       LEFT JOIN tmpMIFloat_doc AS MIFloat_Summ
                                                ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                               AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                       -- �� ��� ����� - �� �� ����� ����� ������ �������������
                       LEFT JOIN tmpMILO_doc AS MILinkObject_TradeMark
                                             ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                            AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()
                                            -- !!!���� �� ������ �����!!!
                                            AND COALESCE (MovementItem.ObjectId, 0) = 0

                       -- ������������� �������������
                       LEFT JOIN tmpMILO_doc AS MILinkObject_GoodsGroupProperty
                                             ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()
                                            -- !!!���� �� ������ �����!!!
                                            AND COALESCE (MovementItem.ObjectId, 0) = 0
                       -- ������������� �������������, ���� ��� ������� - 2, ������ ������� - 1
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                            ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = MILinkObject_GoodsGroupProperty.ObjectId
                                           AND ObjectLink_GoodsGroupProperty_Parent.DescId   = zc_ObjectLink_GoodsGroupProperty_Parent()
                       -- ������� - 1
                       LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
                       -- ������� - 2
                       LEFT JOIN Object AS Object_GoodsGroupProperty       ON Object_GoodsGroupProperty.Id = MILinkObject_GoodsGroupProperty.ObjectId
                                                                          AND ObjectLink_GoodsGroupProperty_Parent.ChildObjectId > 0
                       -- ������������� ������ �����������
                       LEFT JOIN tmpMILO_doc AS MILinkObject_GoodsGroupDirection
                                             ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsGroupDirection.DescId         = zc_MILinkObject_GoodsGroupDirection()
                                            -- !!!���� �� ������ �����!!!
                                            AND COALESCE (MovementItem.ObjectId, 0) = 0
                  )


      -- ������� / �������
    , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                           , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                      FROM Constant_ProfitLoss_AnalyzerId_View
                      WHERE Constant_ProfitLoss_AnalyzerId_View.isCost = FALSE
                     )
      -- ������� ����� ������� �� ��������� / ��.�. / ������������
    , tmpContainer AS (SELECT tmp.JuridicalId
                            , tmp.PartnerId
                            , tmp.PaidKindId
                            , tmp.ContractId
                            , tmp.GoodsId
                            , tmp.GoodsKindId
                            , ObjectLink_Goods_TradeMark.ChildObjectId           AS TradeMarkId
                            , ObjectLink_GoodsGroupProperty_Parent.ChildObjectId AS GoodsGroupPropertyId_Parent
                            , ObjectLink_Goods_GoodsGroupProperty.ChildObjectId  AS GoodsGroupPropertyId
                            , ObjectLink_Goods_GoodsGroupDirection.ChildObjectId AS GoodsGroupDirectionId
                              --
                            , tmp.SummOperCount
                            , tmp.SummAmount

                       FROM (SELECT ContainerLO_Juridical.ObjectId           AS JuridicalId
                                  , ContainerLO_Contract.ObjectId            AS ContractId
                                  , ContainerLO_PaidKind.ObjectId            AS PaidKindId
                                  , MIContainer.ObjectExtId_Analyzer         AS PartnerId
                                  , MIContainer.ObjectId_analyzer            AS GoodsId
                                  , MIContainer.ObjectIntId_analyzer         AS GoodsKindId

                                /*, SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_AmountPartner
                                  , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_AmountPartner

                                  , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                                  , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ

                                  , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS SummAmount
                                */

                                    -- ����� ���-�� ������� ����� �������
                                  , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount ELSE 0 END
                                       - CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount ELSE 0 END
                                        ) AS SummOperCount
                                    -- ����� �����  ������� ����� �������
                                  , SUM (CASE WHEN tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN MIContainer.Amount ELSE 0 END) AS SummAmount

                             FROM tmpAnalyzer
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate     --'01.06.2024' AND '31.08.2024'--
                                                                  AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                  LEFT JOIN ContainerLinkObject AS ContainerLO_Contract
                                                                ON ContainerLO_Contract.ContainerId = MIContainer.ContainerId_Analyzer
                                                               AND ContainerLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                                  LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                               AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                  LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                                ON ContainerLO_PaidKind.ContainerId = MIContainer.ContainerId_Analyzer
                                                               AND ContainerLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                  -- �������(����)
                                  LEFT JOIN (SELECT DISTINCT
                                                    tmpData_Contact.ContractId
                                              FROM tmpData_Contact
                                              WHERE tmpData_Contact.ContractId > 0
                                             ) AS tmpMov_Contact ON tmpMov_Contact.ContractId = ContainerLO_Contract.ObjectId

                                  -- Juridical
                                  LEFT JOIN (SELECT DISTINCT
                                                    tmpData_Contact.JuridicalId
                                              FROM tmpData_Contact
                                              WHERE tmpData_Contact.JuridicalId > 0
                                                -- ��� ��������
                                                AND tmpData_Contact.ContractId = 0
                                             ) AS tmpMov_Jur ON tmpMov_Jur.JuridicalId = ContainerLO_Juridical.ObjectId

                                  -- Partner
                                  LEFT JOIN (SELECT DISTINCT
                                                    tmpData_Contact.PartnerId
                                              FROM tmpData_Contact
                                              WHERE tmpData_Contact.PartnerId > 0
                                                -- ��� ��������
                                                AND tmpData_Contact.ContractId = 0
                                                -- ��� ��.�.
                                                AND tmpData_Contact.JuridicalId = 0
                                             ) AS tmpMov_Partner ON tmpMov_Partner.PartnerId = MIContainer.ObjectExtId_Analyzer

                                            --AND ((tmpMovement.GoodsId = MIContainer.ObjectId_analyzer AND tmpMovement.GoodsKindId = MIContainer.ObjectIntId_analyzer AND COALESCE (tmpMovement.TradeMarkId,0) = 0))
                             WHERE tmpMov_Contact.ContractId > 0
                                OR tmpMov_Jur.JuridicalId    > 0
                                OR tmpMov_Partner.PartnerId  > 0

                             GROUP BY ContainerLO_Juridical.ObjectId
                                    , ContainerLO_Contract.ObjectId
                                    , ContainerLO_PaidKind.ObjectId
                                    , MIContainer.ObjectExtId_Analyzer
                                    , MIContainer.ObjectId_analyzer
                                    , MIContainer.ObjectIntId_analyzer
                             ) AS tmp
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                  ON ObjectLink_Goods_TradeMark.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                                  ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsGroupDirection.DescId   = zc_ObjectLink_Goods_GoodsGroupDirection()

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId   = zc_ObjectLink_Goods_GoodsGroupProperty()

                             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId
                                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId   = zc_ObjectLink_GoodsGroupProperty_Parent()

                      )
    /*, tmpSaleReturn AS (SELECT tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.TradeMarkId
                             , tmp.GoodsGroupPropertyId_Parent
                             , tmp.GoodsGroupPropertyId
                             , tmp.SummAmount
                             , tmp.Sale_Summ
                             , tmp.Return_Summ
                             --����� �� ��.���� + �������
                             , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSumm
                             --����� �� ��.���� + ������� + �������� �����
                             , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.TradeMarkId) AS TotalSumm_tm
                             --����� �� ��.���� + ������� + GoodsGroupPropertyId
                             , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.GoodsGroupPropertyId) AS TotalSumm_gp
                             --����� �� ��.���� + ������� + GoodsGroupPropertyId_Parent
                             , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.GoodsGroupPropertyId_Parent) AS TotalSumm_gpp
                        FROM tmpContainer AS tmp
                        )*/
                        
       -- �������� + �����
     , tmpData_Contact_goods AS (SELECT tmpData_Contact.MovementId_doc
                                      , tmpData_Contact.ContractId
                                      , tmpData_Contact.JuridicalId
                                      , tmpData_Contact.PartnerId
                                      , tmpData_Contact.PaidKindId
                                      , tmpData_Goods.TradeMarkId_doc
                                      , tmpData_Goods.GoodsGroupPropertyId_Parent
                                      , tmpData_Goods.GoodsGroupPropertyId
                                      , tmpData_Goods.GoodsGroupDirectionId
                                 FROM (-- ������������� �� ������ ������
                                       SELECT DISTINCT 
                                              tmpData_Contact.MovementId_doc
                                            , tmpData_Contact.ContractId
                                            , tmpData_Contact.JuridicalId
                                            , tmpData_Contact.PartnerId
                                            , tmpData_Contact.PaidKindId
                                       FROM tmpData_Contact
                                      ) AS tmpData_Contact
                                      JOIN (SELECT DISTINCT
                                                   tmpData.MovementId_doc
                                                 , tmpData.TradeMarkId_doc
                                                 , tmpData.GoodsGroupPropertyId_Parent
                                                 , tmpData.GoodsGroupPropertyId
                                                 , tmpData.GoodsGroupDirectionId
                                            FROM tmpData
                                            WHERE tmpData.GoodsId = 0
                                              AND tmpData.MovementId_doc > 0
                                              AND (tmpData.TradeMarkId_doc             > 0
                                                OR tmpData.GoodsGroupPropertyId_Parent > 0
                                                OR tmpData.GoodsGroupPropertyId        > 0
                                                OR tmpData.GoodsGroupDirectionId       > 0
                                                  )
                                           ) AS tmpData_Goods
                                             ON tmpData_Goods.MovementId_doc = tmpData_Contact.MovementId_doc
                                )
       -- ����� ����� ������ �� ContractId
     , tmpData_1 AS (SELECT tmpData_Contact.MovementId_doc
                          , tmpData_Contact.ContractId
                          , tmpContainer.GoodsId
                          , tmpContainer.GoodsKindId
                          , SUM (tmpContainer.SummOperCount) AS SummOperCount
                          , SUM (tmpContainer.SummAmount)    AS SummAmount
                            --
                          , tmpData_Contact.TradeMarkId_doc
                          , tmpData_Contact.GoodsGroupPropertyId_Parent
                          , tmpData_Contact.GoodsGroupPropertyId
                          , tmpData_Contact.GoodsGroupDirectionId
                            --
                          --, tmpContainer.TradeMarkId
                          --, tmpContainer.GoodsGroupPropertyId_Parent
                          --, tmpContainer.GoodsGroupPropertyId
                          --, tmpContainer.GoodsGroupDirectionId

                     FROM tmpData_Contact_goods AS tmpData_Contact
                          JOIN tmpContainer ON tmpContainer.ContractId   = tmpData_Contact.ContractId
                                           AND (tmpContainer.JuridicalId = tmpData_Contact.JuridicalId OR tmpData_Contact.JuridicalId = 0)
                                           AND (tmpContainer.PartnerId   = tmpData_Contact.PartnerId   OR tmpData_Contact.PartnerId   = 0)
                                           AND (tmpContainer.PaidKindId  = tmpData_Contact.PaidKindId  OR tmpData_Contact.PaidKindId  = 0)
                                           --
                                           AND (tmpContainer.TradeMarkId                 = tmpData_Contact.TradeMarkId_doc             OR tmpData_Contact.TradeMarkId_doc             = 0)
                                           AND (tmpContainer.GoodsGroupPropertyId_Parent = tmpData_Contact.GoodsGroupPropertyId_Parent OR tmpData_Contact.GoodsGroupPropertyId_Parent = 0)
                                           AND (tmpContainer.GoodsGroupPropertyId        = tmpData_Contact.GoodsGroupPropertyId        OR tmpData_Contact.GoodsGroupPropertyId        = 0)
                                           AND (tmpContainer.GoodsGroupDirectionId       = tmpData_Contact.GoodsGroupDirectionId       OR tmpData_Contact.GoodsGroupDirectionId       = 0)
                     WHERE tmpData_Contact.ContractId > 0
                     GROUP BY tmpData_Contact.MovementId_doc
                            , tmpData_Contact.ContractId
                            , tmpContainer.GoodsId
                            , tmpContainer.GoodsKindId
                              --
                            , tmpData_Contact.TradeMarkId_doc
                            , tmpData_Contact.GoodsGroupPropertyId_Parent
                            , tmpData_Contact.GoodsGroupPropertyId
                            , tmpData_Contact.GoodsGroupDirectionId
                    )
       -- ����� ����� ������ �� JuridicalId
     , tmpData_2 AS (SELECT tmpData_Contact.MovementId_doc
                          , tmpContainer.GoodsId
                          , tmpContainer.GoodsKindId
                          , SUM (tmpContainer.SummOperCount) AS SummOperCount
                          , SUM (tmpContainer.SummAmount)    AS SummAmount
                            --
                          , tmpData_Contact.TradeMarkId_doc
                          , tmpData_Contact.GoodsGroupPropertyId_Parent
                          , tmpData_Contact.GoodsGroupPropertyId
                          , tmpData_Contact.GoodsGroupDirectionId
                     FROM tmpData_Contact_goods AS tmpData_Contact
                          JOIN tmpContainer ON tmpContainer.JuridicalId = tmpData_Contact.JuridicalId
                                           AND (tmpContainer.PaidKindId  = tmpData_Contact.PaidKindId  OR tmpData_Contact.PaidKindId  = 0)
                                           --
                                           AND (tmpContainer.TradeMarkId                 = tmpData_Contact.TradeMarkId_doc             OR tmpData_Contact.TradeMarkId_doc             = 0)
                                           AND (tmpContainer.GoodsGroupPropertyId_Parent = tmpData_Contact.GoodsGroupPropertyId_Parent OR tmpData_Contact.GoodsGroupPropertyId_Parent = 0)
                                           AND (tmpContainer.GoodsGroupPropertyId        = tmpData_Contact.GoodsGroupPropertyId        OR tmpData_Contact.GoodsGroupPropertyId        = 0)
                                           AND (tmpContainer.GoodsGroupDirectionId       = tmpData_Contact.GoodsGroupDirectionId       OR tmpData_Contact.GoodsGroupDirectionId       = 0)
                     WHERE tmpData_Contact.JuridicalId > 0
                       -- ��� ��������
                       AND tmpData_Contact.ContractId = 0
                     GROUP BY tmpData_Contact.MovementId_doc
                            , tmpContainer.GoodsId
                            , tmpContainer.GoodsKindId
                              --
                            , tmpData_Contact.TradeMarkId_doc
                            , tmpData_Contact.GoodsGroupPropertyId_Parent
                            , tmpData_Contact.GoodsGroupPropertyId
                            , tmpData_Contact.GoodsGroupDirectionId
                    )

    , tmpRes AS (--����������� ���� ��� ������, ���� ������ � �����
                 SELECT tmpData.MovementId
                      , tmpData.MovementDescId
                      , tmpData.OperDate
                      , tmpData.InvNumber
                        -- �� ���� / ���������� - � ��������� ���������� ������
                      , tmpData.JuridicalId
                      , tmpData.PartnerId
                        -- ������� (���������� ������)
                      , tmpData.ContractId
                        -- ������� (���� - � ���������� ������)
                      , tmpData.ContractChildId
                        -- ������� (������� - � ���������� ������)
                      , tmpData.ContractMasterId
                        -- ������������ (� ���������� ������)
                      , tmpData.PaidKindId
                        -- �� ������ (� ���������� ������)
                      , tmpData.InfoMoneyId
                        -- ������������ (� ���������� ������)
                      , tmpData.ContractConditionKindId

                        -- �������� ����� / �����-���������
                      , tmpData.MovementId_doc
                        -- �� � ��������� ����� / �����-���������
                      , tmpData.PaidKindId_doc

                        -- 
                      , tmpData.RetaillId_doc
                      , tmpData.JuridicalId_doc
                      , tmpData.PartnerId_doc
                         -- �������
                       , tmpData.ContractId_doc

                        -- �� � ��������� ���������� ������
                      , tmpData.TradeMarkId

                        -- �� � ������� ����� / �����-���������
                      , tmpData.TradeMarkId_doc

                      , tmpData.GoodsGroupPropertyId_Parent
                      , tmpData.GoodsGroupPropertyId
                      , tmpData.GoodsGroupDirectionId
                      , tmpData.GoodsId
                      , tmpData.GoodsKindId

                      , tmpData.Amount
                      , tmpData.AmountIn
                      , tmpData.AmountOut

                        -- ����������� �� ���, �� - ***�����
                      , tmpData.AmountMarket
                        -- �����������,��� - ***�����
                      , tmpData.SummMarket
                        -- ��������� �������,��� - ***�����
                      , tmpData.CostPromo_m
                        -- ��������� ������� - ***�����-���������
                      , tmpData.CostPromo_mi

                        -- ����� ������
                      , COALESCE (tmpData_find_1.SummAmount, 0) + COALESCE (tmpData_find_2.SummAmount, 0) + COALESCE (tmpData_find_3.SummAmount, 0) AS SummAmount

                        -- ��� �����
                      , 0 AS TotalSumm
                      , 0 AS TotalSumm_tm
                      , 0 AS TotalSumm_gp
                      , 0 AS TotalSumm_gpp

                        -- �����
                      , 0 AS Persent_part
                      , 0 AS Persent_part_tm
                      , 0 AS Persent_part_gp
                      , 0 AS Persent_part_gpp

                        -- ������ �����
                      , 1 AS GroupId

                        -- ������� �� � ����������� +/- ������� ����
                      --, 2

                        -- ������� ��, ������ � ����������� +/- ������� ����
                      --, 3

-- �� MovementId_baza - ����������� ����

-- ���� ���. ����-��������� � ��������
-- 1. �� - ��� ��� ����

                 FROM tmpData
                      -- ����� ����� ������ �� ContractId
                      LEFT JOIN (SELECT tmpData_Contact.MovementId_doc
                                      , tmpData_Contact.ContractId
                                      , tmpContainer.GoodsId
                                      , tmpContainer.GoodsKindId
                                      , SUM (tmpContainer.SummOperCount) AS SummOperCount
                                      , SUM (tmpContainer.SummAmount)    AS SummAmount
                                 FROM (-- ������������� �� ������ ������
                                       SELECT DISTINCT 
                                              tmpData_Contact.MovementId_doc
                                            , tmpData_Contact.ContractId
                                            , tmpData_Contact.JuridicalId
                                            , tmpData_Contact.PartnerId
                                            , tmpData_Contact.PaidKindId
                                       FROM tmpData_Contact
                                       WHERE tmpData_Contact.ContractId > 0
                                      ) AS tmpData_Contact
                                      JOIN tmpContainer ON tmpContainer.ContractId   = tmpData_Contact.ContractId
                                                       AND (tmpContainer.JuridicalId = tmpData_Contact.JuridicalId OR tmpData_Contact.JuridicalId = 0)
                                                       AND (tmpContainer.PartnerId   = tmpData_Contact.PartnerId   OR tmpData_Contact.PartnerId   = 0)
                                                       AND (tmpContainer.PaidKindId  = tmpData_Contact.PaidKindId  OR tmpData_Contact.PaidKindId  = 0)
                                 GROUP BY tmpData_Contact.MovementId_doc
                                        , tmpData_Contact.ContractId
                                        , tmpContainer.GoodsId
                                        , tmpContainer.GoodsKindId
                                ) AS tmpData_find_1
                                  ON tmpData_find_1.MovementId_doc = tmpData.MovementId_doc
                                 AND tmpData_find_1.ContractId     = tmpData.ContractChildId -- ContractId_doc
                                 AND tmpData_find_1.GoodsId        = tmpData.GoodsId
                                 AND tmpData_find_1.GoodsKindId    = tmpData.GoodsKindId

                      -- ����� ����� ������ �� JuridicalId
                      LEFT JOIN (SELECT tmpData_Contact.MovementId_doc
                                      , tmpContainer.GoodsId
                                      , tmpContainer.GoodsKindId
                                      , SUM (tmpContainer.SummOperCount) AS SummOperCount
                                      , SUM (tmpContainer.SummAmount)    AS SummAmount
                                 FROM (-- ������������� �� ������ ������
                                       SELECT DISTINCT 
                                              tmpData_Contact.MovementId_doc
                                            , tmpData_Contact.JuridicalId
                                            , tmpData_Contact.PaidKindId
                                       FROM tmpData_Contact
                                       WHERE tmpData_Contact.JuridicalId > 0
                                         -- ��� ��������
                                         AND tmpData_Contact.ContractId = 0
                                      ) AS tmpData_Contact
                                      JOIN tmpContainer ON tmpContainer.JuridicalId = tmpData_Contact.JuridicalId
                                                       AND (tmpContainer.PaidKindId = tmpData_Contact.PaidKindId OR tmpData_Contact.PaidKindId  = 0)
                                 GROUP BY tmpData_Contact.MovementId_doc
                                        , tmpContainer.GoodsId
                                        , tmpContainer.GoodsKindId
                                ) AS tmpData_find_2
                                  ON tmpData_find_2.MovementId_doc = tmpData.MovementId_doc
                                 AND tmpData_find_2.GoodsId        = tmpData.GoodsId
                                 AND tmpData_find_2.GoodsKindId    = tmpData.GoodsKindId
                                 -- !!!
                                 AND tmpData.ContractChildId = 0 -- ContractId_doc

                      -- ����� ����� ������ �� PartnerId
                      LEFT JOIN (SELECT tmpData_Contact.MovementId_doc
                                      , tmpContainer.GoodsId
                                      , tmpContainer.GoodsKindId
                                      , SUM (tmpContainer.SummOperCount) AS SummOperCount
                                      , SUM (tmpContainer.SummAmount)    AS SummAmount
                                 FROM (-- ������������� �� ������ ������
                                       SELECT DISTINCT 
                                              tmpData_Contact.MovementId_doc
                                            , tmpData_Contact.PartnerId
                                            , tmpData_Contact.PaidKindId
                                       FROM tmpData_Contact
                                       WHERE tmpData_Contact.PartnerId > 0
                                         -- ��� ��������
                                         AND tmpData_Contact.ContractId = 0
                                      ) AS tmpData_Contact
                                      JOIN tmpContainer ON tmpContainer.PartnerId   = tmpData_Contact.PartnerId
                                                       AND (tmpContainer.PaidKindId = tmpData_Contact.PaidKindId OR tmpData_Contact.PaidKindId  = 0)
                                 GROUP BY tmpData_Contact.MovementId_doc
                                        , tmpContainer.GoodsId
                                        , tmpContainer.GoodsKindId
                                ) AS tmpData_find_3
                                  ON tmpData_find_3.MovementId_doc = tmpData.MovementId_doc
                                 AND tmpData_find_3.GoodsId        = tmpData.GoodsId
                                 AND tmpData_find_3.GoodsKindId    = tmpData.GoodsKindId
                                 -- !!!
                                 AND tmpData.ContractChildId = 0 -- ContractId_doc

                 -- !!!���� ������ �����!!!
                 WHERE tmpData.GoodsId > 0
                   AND tmpData.MovementId_doc > 0


                UNION ALL
                 --����������� ���� ��� ������, ���� ������ � �����
                 SELECT tmpData.MovementId
                      , tmpData.MovementDescId
                      , tmpData.OperDate
                      , tmpData.InvNumber
                        -- �� ���� / ���������� - � ��������� ���������� ������
                      , tmpData.JuridicalId
                      , tmpData.PartnerId
                        -- ������� (���������� ������)
                      , tmpData.ContractId
                        -- ������� (���� - � ���������� ������)
                      , tmpData.ContractChildId
                        -- ������� (������� - � ���������� ������)
                      , tmpData.ContractMasterId
                        -- ������������ (� ���������� ������)
                      , tmpData.PaidKindId
                        -- �� ������ (� ���������� ������)
                      , tmpData.InfoMoneyId
                        -- ������������ (� ���������� ������)
                      , tmpData.ContractConditionKindId

                        -- �������� ����� / �����-���������
                      , tmpData.MovementId_doc
                        -- �� � ��������� ����� / �����-���������
                      , tmpData.PaidKindId_doc

                        -- 
                      , tmpData.RetaillId_doc
                      , tmpData.JuridicalId_doc
                      , tmpData.PartnerId_doc
                         -- �������
                       , tmpData.ContractId_doc

                        -- �� � ��������� ���������� ������
                      , tmpData.TradeMarkId

                        -- �� � ������� ����� / �����-���������
                      , tmpData.TradeMarkId_doc

                      , tmpData.GoodsGroupPropertyId_Parent
                      , tmpData.GoodsGroupPropertyId
                      , tmpData.GoodsGroupDirectionId
                      , COALESCE (tmpData_find_1.GoodsId, tmpData_find_2.GoodsId) AS GoodsId
                      , COALESCE (tmpData_find_1.GoodsKindId, tmpData_find_2.GoodsKindId) AS GoodsKindId

                      , tmpData.Amount
                      , tmpData.AmountIn
                      , tmpData.AmountOut

                        -- ����������� �� ���, �� - ***�����
                      , tmpData.AmountMarket
                        -- �����������,��� - ***�����
                      , tmpData.SummMarket
                        -- ��������� �������,��� - ***�����
                      , tmpData.CostPromo_m
                        -- ��������� ������� - ***�����-���������
                      , tmpData.CostPromo_mi

                        -- ����� ������
                      , COALESCE (tmpData_find_1.SummAmount, 0) + COALESCE (tmpData_find_2.SummAmount, 0) AS SummAmount

                        -- ��� �����
                      , COALESCE (tmpData_find_1_sum.SummAmount, 0) + COALESCE (tmpData_find_2_sum.SummAmount, 0) AS TotalSumm
                      , 0 AS TotalSumm_tm
                      , 0 AS TotalSumm_gp
                      , 0 AS TotalSumm_gpp

                        -- �����
                      , CASE WHEN COALESCE (tmpData_find_1_sum.SummAmount, 0) + COALESCE (tmpData_find_2_sum.SummAmount, 0) > 0
                             THEN (COALESCE (tmpData_find_1.SummAmount, 0) + COALESCE (tmpData_find_2.SummAmount, 0))
                                / (COALESCE (tmpData_find_1_sum.SummAmount, 0) + COALESCE (tmpData_find_2_sum.SummAmount, 0))
                             ELSE 0
                        END  AS Persent_part
                      , 0 AS Persent_part_tm
                      , 0 AS Persent_part_gp
                      , 0 AS Persent_part_gpp

                        -- ������ �����
                      , 2 AS GroupId

                        -- ������� �� � ����������� +/- ������� ����
                      --, 2

                        -- ������� ��, ������ � ����������� +/- ������� ����
                      --, 3

-- �� MovementId_baza - ����������� ����

-- ���� ���. ����-��������� � ��������
-- 1. �� - ��� ��� ����

                 FROM tmpData
                      -- ����� ����� ������ �� ContractId
                      LEFT JOIN tmpData_1 AS tmpData_find_1
                                          ON tmpData_find_1.MovementId_doc = tmpData.MovementId_doc
                                         AND tmpData_find_1.ContractId     = tmpData.ContractChildId -- ContractId_doc
                                         --
                                         AND tmpData_find_1.TradeMarkId_doc             = tmpData.TradeMarkId_doc
                                         AND tmpData_find_1.GoodsGroupPropertyId_Parent = tmpData.GoodsGroupPropertyId_Parent
                                         AND tmpData_find_1.GoodsGroupPropertyId        = tmpData.GoodsGroupPropertyId
                                         AND tmpData_find_1.GoodsGroupDirectionId       = tmpData.GoodsGroupDirectionId

                      -- ����� ����� ������ �� ContractId
                      LEFT JOIN (SELECT tmpData_1.MovementId_doc, tmpData_1.ContractId, SUM (tmpData_1.SummAmount) AS SummAmount
                                      , tmpData_1.TradeMarkId_doc
                                      , tmpData_1.GoodsGroupPropertyId_Parent
                                      , tmpData_1.GoodsGroupPropertyId
                                      , tmpData_1.GoodsGroupDirectionId
                                 FROM tmpData_1
                                 GROUP BY tmpData_1.MovementId_doc, tmpData_1.ContractId
                                        , tmpData_1.TradeMarkId_doc
                                        , tmpData_1.GoodsGroupPropertyId_Parent
                                        , tmpData_1.GoodsGroupPropertyId
                                        , tmpData_1.GoodsGroupDirectionId
                                ) AS tmpData_find_1_sum
                                  ON tmpData_find_1_sum.MovementId_doc = tmpData.MovementId_doc
                                 AND tmpData_find_1_sum.ContractId     = tmpData.ContractChildId -- ContractId_doc
                                 --
                                 AND tmpData_find_1_sum.TradeMarkId_doc             = tmpData.TradeMarkId_doc
                                 AND tmpData_find_1_sum.GoodsGroupPropertyId_Parent = tmpData.GoodsGroupPropertyId_Parent
                                 AND tmpData_find_1_sum.GoodsGroupPropertyId        = tmpData.GoodsGroupPropertyId
                                 AND tmpData_find_1_sum.GoodsGroupDirectionId       = tmpData.GoodsGroupDirectionId

                      -- ����� ����� ������ �� JuridicalId
                      LEFT JOIN tmpData_2 AS tmpData_find_2
                                          ON tmpData_find_2.MovementId_doc = tmpData.MovementId_doc
                                         --
                                         AND tmpData_find_2.TradeMarkId_doc             = tmpData.TradeMarkId_doc
                                         AND tmpData_find_2.GoodsGroupPropertyId_Parent = tmpData.GoodsGroupPropertyId_Parent
                                         AND tmpData_find_2.GoodsGroupPropertyId        = tmpData.GoodsGroupPropertyId
                                         AND tmpData_find_2.GoodsGroupDirectionId       = tmpData.GoodsGroupDirectionId
                                         -- !!!
                                         AND tmpData.ContractChildId = 0 -- ContractId_doc
                      -- ����� ����� ������ �� JuridicalId
                      LEFT JOIN (SELECT tmpData_2.MovementId_doc, SUM (tmpData_2.SummAmount) AS SummAmount
                                      , tmpData_2.TradeMarkId_doc
                                      , tmpData_2.GoodsGroupPropertyId_Parent
                                      , tmpData_2.GoodsGroupPropertyId
                                      , tmpData_2.GoodsGroupDirectionId
                                 FROM tmpData_2
                                 GROUP BY tmpData_2.MovementId_doc
                                        , tmpData_2.TradeMarkId_doc
                                        , tmpData_2.GoodsGroupPropertyId_Parent
                                        , tmpData_2.GoodsGroupPropertyId
                                        , tmpData_2.GoodsGroupDirectionId
                                ) AS tmpData_find_2_sum
                                  ON tmpData_find_2_sum.MovementId_doc = tmpData.MovementId_doc
                                 --
                                 AND tmpData_find_2_sum.TradeMarkId_doc             = tmpData.TradeMarkId_doc
                                 AND tmpData_find_2_sum.GoodsGroupPropertyId_Parent = tmpData.GoodsGroupPropertyId_Parent
                                 AND tmpData_find_2_sum.GoodsGroupPropertyId        = tmpData.GoodsGroupPropertyId
                                 AND tmpData_find_2_sum.GoodsGroupDirectionId       = tmpData.GoodsGroupDirectionId
                                 -- !!!
                                 AND tmpData.ContractChildId = 0 -- ContractId_doc

                 -- !!!���� �� ������ �����!!!
                 WHERE tmpData.GoodsId = 0
                   AND tmpData.MovementId_doc > 0
                )


             SELECT tmpData.MovementId
                  , tmpData.OperDate
                  , tmpData.InvNumber
                  , MovementDesc.ItemName       AS MovementDescName
                    -- �� ���� (���������� ������)
                  , Object_Juridical.Id         AS JuridicalId
                  , Object_Juridical.ObjectCode AS JuridicalCode
                  , Object_Juridical.ValueData  AS JuridicalName

                    -- �� ���� - ����
                  , Object_Juridical_baza.Id         AS JuridicalId_baza
                  , Object_Juridical_baza.ObjectCode AS JuridicalCode_baza
                  , Object_Juridical_baza.ValueData  AS JuridicalName_baza

                    -- ������� (���� - � ���������� ������)
                  , Object_ContractChild.ObjectCode AS ContractChildCode
                  , Object_ContractChild.ValueData  AS ContractChildName
                    -- ������� (���������� ������)
                  , Object_Contract.ObjectCode AS ContractCode
                  , Object_Contract.ValueData  AS ContractName
                    -- ������� (������� - � ���������� ������)
                  , Object_Contract_Master.ObjectCode AS ContractCode_Master
                  , Object_Contract_Master.ValueData  AS ContractName_Master

                    -- ������������ ������� �������� (� ���������� ������)
                  , Object_ContractConditionKind.ValueData  AS ContractConditionKindName

                    -- ������������ (� ���������� ������)
                  , Object_PaidKind.ValueData       ::TVarChar AS PaidKindName
                    -- �� � ��������� ����� / �����-���������
                  , Object_PaidKind_Child.ValueData ::TVarChar AS PaidKindName_Child

                    -- �� ������ (� ���������� ������)
                  , View_InfoMoney.InfoMoneyName_all AS InfoMoneyName
                  , Object_InfoMoneyChild_View.InfoMoneyName_all AS InfoMoneyName_Child

                  , CASE WHEN COALESCE (Movement_Doc.Id,0) <> 0 THEN Movement_Doc.Id ELSE -1 END ::Integer AS MovementId_doc
                  , Movement_Doc.OperDate       AS OperDate_Doc
                  , Movement_Doc.InvNumber      AS InvNumber_doc
                  , zfCalc_PartionMovementName (Movement_Doc.DescId, MovementDesc_Doc.ItemName, Movement_Doc.InvNumber, Movement_Doc.OperDate) :: TVarChar AS InvNumber_full_doc
                  , MovementDesc_Doc.ItemName   AS MovementDescName_doc
                  --, Object_TradeMark.ValueData  AS TradeMarkName

                  , Object_Goods.Id             AS GoodsId
                  , Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName

                  , Object_Measure.ValueData           AS MeasureName
                  , Object_TradeMark.Id                AS TradeMarkId
                  , Object_TradeMark.ValueData         AS TradeMarkName
                  , Object_GoodsGroup.ValueData        AS GoodsGroupName
                  , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
                  , Object_GoodsGroupProperty.Id              AS GoodsGroupPropertyId
                  , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
                  , Object_GoodsGroupPropertyParent.Id        AS GoodsGroupPropertyId_Parent
                  , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent

                  , tmpData.AmountIn         :: TFloat --����� ����� ���. ����������
                  , tmpData.AmountOut        :: TFloat --������ ����� ���. ����������
                  , tmpData.Amount           :: TFloat --����� ���. ����������

                    -- ����������� �� ���, �� - ***�����
                  , tmpData.AmountMarket
                    -- �����������,��� - ***�����
                  , tmpData.SummMarket
                    -- ��������� �������,��� - ***�����
                  , tmpData.CostPromo_m
                    -- ��������� ������� - ***�����-���������
                  , tmpData.CostPromo_mi

                  , tmpData.SummAmount       :: TFloat --����� �������
                  , tmpData.TotalSumm        :: TFloat --����� ����� ������� �� �� ���� + �������
                  , tmpData.TotalSumm_tm     :: TFloat --
                  , tmpData.TotalSumm_gp     :: TFloat --
                  , tmpData.TotalSumm_gpp    :: TFloat --

                  , tmpData.Persent_part     :: TFloat
                  , tmpData.Persent_part_tm  :: TFloat
                  , tmpData.Persent_part_gp  :: TFloat
                  , tmpData.Persent_part_gpp :: TFloat

/*                  , CASE WHEN COALESCE (tmpData.TradeMarkId,0) = 0 AND COALESCE (tmpData.GoodsGroupPropertyId,0) = 0 AND COALESCE (tmpData.GoodsGroupPropertyId_Parent,0) = 0
                         THEN CASE WHEN COALESCE (tmpData.SummMarket,0) <> 0 THEN tmpData.SummMarket ELSE (ABS(tmpData.Amount) * tmpData.Persent_part)/100 END
                         ELSE 0
                    END  :: TFloat  AS SummMarket_calc

                  , CASE WHEN COALESCE (tmpData.TradeMarkId,0) <> 0 THEN (COALESCE (tmpData.SummMarket, ABS(tmpData.Amount)) * tmpData.Persent_part_tm)/100 ELSE 0 END                   :: TFloat  AS SummMarket_tm_calc
                  , CASE WHEN COALESCE (tmpData.GoodsGroupPropertyId,0) <> 0 THEN (COALESCE (tmpData.SummMarket, ABS(tmpData.Amount)) * tmpData.Persent_part_gp)/100 ELSE 0 END          :: TFloat  AS SummMarket_gp_calc
                  , CASE WHEN COALESCE (tmpData.GoodsGroupPropertyId_Parent,0) <> 0 THEN (COALESCE (tmpData.SummMarket, ABS(tmpData.Amount)) * tmpData.Persent_part_gpp)/100 ELSE 0 END  :: TFloat  AS SummMarket_gpp_calc*/

                    -- ������ - �����������, ���
                  , CASE WHEN tmpData.GroupId = 1
                              THEN tmpData.SummMarket
                         WHEN tmpData.GroupId = 2
                              THEN tmpData.SummMarket * tmpData.Persent_part -- / 100 
                         ELSE 0
                    END :: TFloat AS SummMarket_calc

                    -- ������ - ��������� �������,��� (�����)
                  , CASE WHEN tmpData.GroupId = 1
                              THEN tmpData.CostPromo_m
                         WHEN tmpData.GroupId = 2
                              THEN tmpData.CostPromo_m * tmpData.Persent_part -- / 100 
                         ELSE 0
                    END :: TFloat AS CostPromo_m_calc

                    -- ������ - ��������� �������, ��� (�����-���������)
                  , CASE WHEN tmpData.GroupId = 1
                              THEN tmpData.CostPromo_mi
                         WHEN tmpData.GroupId = 2
                              THEN tmpData.CostPromo_mi * tmpData.Persent_part -- / 100 
                         ELSE 0
                    END :: TFloat AS CostPromo_mi_calc

             FROM tmpRes AS tmpData
                LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
               -- LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

                LEFT JOIN Movement AS Movement_Doc ON Movement_Doc.Id = tmpData.MovementId_doc
                LEFT JOIN MovementDesc AS MovementDesc_Doc ON MovementDesc_Doc.Id = Movement_Doc.DescId

                -- ���� ���������
                LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId

                -- �� ������ (� ���������� ������)
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpData.InfoMoneyId

                -- �� �������� ������
                LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
                -- ������� (����)
                LEFT JOIN Object AS Object_ContractChild ON Object_ContractChild.Id = tmpData.ContractChildId

                LEFT JOIN Object AS Object_PaidKind_Child ON Object_PaidKind_Child.Id = tmpData.PaidKindId_doc

                -- ???�� ������ (���.����) - ����� ���� �� ��������
                LEFT JOIN ObjectLink AS ObjectLink_ContractChild_InfoMoney
                                     ON ObjectLink_ContractChild_InfoMoney.ObjectId = tmpData.ContractChildId
                                    AND ObjectLink_ContractChild_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN Object_InfoMoney_View AS Object_InfoMoneyChild_View ON Object_InfoMoneyChild_View.InfoMoneyId = ObjectLink_ContractChild_InfoMoney.ChildObjectId

                -- ������� (����������)
                LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId
                -- ������� (�������)
                LEFT JOIN Object AS Object_Contract_Master ON Object_Contract_Master.Id = tmpData.ContractMasterId
                -- ���� ������� ���������
                LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpData.ContractConditionKindId

                -- ��.�. - ����
                LEFT JOIN Object AS Object_Juridical_baza ON Object_Juridical_baza.Id = tmpData.JuridicalId_doc

                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical_baza.Id
                                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId


                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                     ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
                LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                     ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                    AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId


                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                       ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.08.24         *
*/

-- ����
-- SELECT * FROM gpReport_ProfitLossService (inStartDate:= '01.09.2024', inEndDate:= '30.09.2024', inSession:= zfCalc_UserAdmin());

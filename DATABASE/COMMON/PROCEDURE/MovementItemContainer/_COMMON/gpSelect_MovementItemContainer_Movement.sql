-- ������ ���������� ��� �������� �� ���������
-- Function: gpSelect_MovementItemContainer_Movement()

DROP FUNCTION IF EXISTS gpSelect_MovementItemContainer_Movement (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItemContainer_Movement (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItemContainer_Movement (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItemContainer_Movement (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement(
    IN inMovementId         Integer      , -- ���� ���������
    IN inIsDestination      Boolean      , -- 
    IN inIsParentDetail     Boolean      , -- 
    IN inIsInfoMoneyDetail  Boolean      , -- 
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (InvNumber Integer, OperDate TDateTime
             , AccountCode Integer
             , DebetAmount TFloat, DebetAccountGroupName TVarChar, DebetAccountDirectionName TVarChar, DebetAccountName TVarChar
             , KreditAmount TFloat, KreditAccountGroupName TVarChar, KreditAccountDirectionName TVarChar, KreditAccountName  TVarChar
             , Amount_Currency TFloat
             , Price TFloat
             , AccountOnComplete Boolean
             , DirectionObjectCode Integer, DirectionObjectName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , BusinessCode Integer, BusinessName TVarChar
             , GoodsGroupCode Integer, GoodsGroupName TVarChar
             , DestinationObjectCode Integer, DestinationObjectName TVarChar
             , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , GoodsKindName TVarChar
             , ObjectCostId Integer, MIId_Parent Integer, GoodsCode_Parent Integer, GoodsName_Parent TVarChar, GoodsKindName_Parent TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyCode_Detail Integer, InfoMoneyName_Detail TVarChar
             , CurrencyName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MIContainer_Movement());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������� �������
     inIsDestination:= inIsDestination OR inIsParentDetail OR inIsInfoMoneyDetail;
     -- ������� �������
     inIsParentDetail:= inIsParentDetail OR inIsInfoMoneyDetail;

     -- !!!�������� ������ � ������!!!
     IF 1 = 1 AND EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), 10898)) -- ������ (��������������)
     THEN

     RETURN QUERY 
       WITH tmpMovement AS (SELECT Movement.Id AS MovementId, Movement.DescId AS MovementDescId, Movement.InvNumber, inIsDestination AS isDestination, inIsParentDetail AS isParentDetail, inIsInfoMoneyDetail AS isInfoMoneyDetail FROM Movement WHERE Movement.Id = inMovementId
                           UNION ALL
                            SELECT Movement.Id AS MovementId, Movement.DescId AS MovementDescId, Movement.InvNumber, inIsDestination AS isDestination, inIsParentDetail AS isParentDetail, inIsInfoMoneyDetail AS isInfoMoneyDetail FROM Movement WHERE Movement.ParentId = inMovementId
                           )
                    -- ��� ��������: �������������� + ��������
                  , tmpMIContainer_all AS (SELECT MIContainer.DescId AS MIContainerDescId
                                                , MIContainer.Id
                                                , COALESCE (MIContainer.MovementItemId, 0) AS MovementItemId -- !!!����� ���� NULL!!!
                                                , MIContainer.ParentId
                                                , MIContainer.ContainerId
                                                , MIContainer.OperDate
                                                , MIContainer.isActive
                                                , CASE WHEN MIContainer.isActive = TRUE OR MIContainer.DescId = zc_MIContainer_Summ() THEN 1 ELSE -1 END * MIContainer.Amount AS Amount
                                                , tmpMovement.MovementId
                                                , tmpMovement.MovementDescId
                                                , tmpMovement.InvNumber
                                                , tmpMovement.isDestination
                                                , tmpMovement.isParentDetail
                                                , tmpMovement.isInfoMoneyDetail
                                           FROM tmpMovement
                                                LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId = tmpMovement.MovementId
                                          )
               -- ��������: ������ �������� + ������������ ����
             , tmpMIContainer_Summ_all AS (SELECT tmpMIContainer_all.*
                                                , Container.ObjectId AS AccountId
                                                , COALESCE (tmpMIContainerCurrency_all.ContainerId, 0) AS ContainerId_Currency, COALESCE (tmpMIContainerCurrency_all.Amount, 0) AS Amount_Currency
                                           FROM tmpMIContainer_all
                                                LEFT JOIN Container ON Container.Id = tmpMIContainer_all.ContainerId
                                                LEFT JOIN Container AS Container_Parent ON Container_Parent.ParentId = Container.Id
                                                LEFT JOIN tmpMIContainer_all AS tmpMIContainerCurrency_all ON tmpMIContainerCurrency_all.ContainerId = Container_Parent.Id
                                           WHERE tmpMIContainer_all.MIContainerDescId = zc_MIContainer_Summ()
                                          )
               -- ��������: ������ �������������� + ������������ GoodsId + (����� ��� ������� ����)
            , tmpMIContainer_Count_all AS (SELECT tmpMIContainer_all.*
                                                , COALESCE (Container.ObjectId, 0) AS GoodsId
                                           FROM tmpMIContainer_all
                                                LEFT JOIN Container ON Container.Id = tmpMIContainer_all.ContainerId
                                           WHERE tmpMIContainer_all.MIContainerDescId = zc_MIContainer_Count()
                                             AND tmpMIContainer_all.isDestination     = TRUE
                                          )
                -- ��������: �������������� + ������������ GoodsKindId
              , tmpMIContainer_Count_2 AS (SELECT tmpMIContainer_Count_all.GoodsId
                                                , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                                , tmpMIContainer_Count_all.MovementItemId
                                                , tmpMIContainer_Count_all.ParentId
                                                , tmpMIContainer_Count_all.isActive
                                                , tmpMIContainer_Count_all.Amount AS Amount_Count
                                                , tmpMIContainer_Count_all.MovementId
                                                , tmpMIContainer_Count_all.MovementDescId
                                                , tmpMIContainer_Count_all.InvNumber
                                                , tmpMIContainer_Count_all.isDestination
                                                , tmpMIContainer_Count_all.isParentDetail
                                                , tmpMIContainer_Count_all.isInfoMoneyDetail
                                           FROM tmpMIContainer_Count_all
                                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                              ON CLO_GoodsKind.ContainerId = tmpMIContainer_Count_all.ContainerId
                                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                          )
                -- ��������: �������������� + ������������ MovementItemId_Parent + ContainerId_Parent
              , tmpMIContainer_Count_3 AS (SELECT COALESCE (MIContainer_Parent.MovementItemId, tmpMIContainer_Count_2.MovementItemId) AS MovementItemId_Parent
                                                , MIContainer_Parent.ContainerId                                                      AS ContainerId_Parent
                                                , tmpMIContainer_Count_2.GoodsId
                                                , tmpMIContainer_Count_2.GoodsKindId
                                                , tmpMIContainer_Count_2.MovementItemId
                                                , tmpMIContainer_Count_2.isActive
                                                , tmpMIContainer_Count_2.Amount_Count
                                                , tmpMIContainer_Count_2.MovementId
                                                , tmpMIContainer_Count_2.MovementDescId
                                                , tmpMIContainer_Count_2.InvNumber
                                                , tmpMIContainer_Count_2.isDestination
                                                , tmpMIContainer_Count_2.isParentDetail
                                                , tmpMIContainer_Count_2.isInfoMoneyDetail
                                           FROM tmpMIContainer_Count_2
                                                LEFT JOIN MovementItemContainer AS MIContainer_Parent ON MIContainer_Parent.Id = tmpMIContainer_Count_2.ParentId
                                                                                                     AND tmpMIContainer_Count_2.isParentDetail = TRUE
                                          )
                -- ��������: �������������� + ������������ GoodsId_Parent + GoodsKindId_Parent (����� ��� ����������� ������ �������)
              , tmpMIContainer_Count_4 AS (SELECT COALESCE (Container.ObjectId, tmpMIContainer_Count_3.GoodsId)         AS GoodsId_Parent
                                                , COALESCE (CLO_GoodsKind.ObjectId, tmpMIContainer_Count_3.GoodsKindId) AS GoodsKindId_Parent
                                                , tmpMIContainer_Count_3.MovementItemId_Parent
                                                , tmpMIContainer_Count_3.GoodsId
                                                , tmpMIContainer_Count_3.GoodsKindId
                                                , tmpMIContainer_Count_3.MovementItemId
                                                , tmpMIContainer_Count_3.isActive
                                                , tmpMIContainer_Count_3.Amount_Count
                                                , tmpMIContainer_Count_3.MovementId
                                                , tmpMIContainer_Count_3.MovementDescId
                                                , tmpMIContainer_Count_3.InvNumber
                                                , tmpMIContainer_Count_3.isDestination
                                                , tmpMIContainer_Count_3.isParentDetail
                                                , tmpMIContainer_Count_3.isInfoMoneyDetail
                                           FROM tmpMIContainer_Count_3
                                                LEFT JOIN Container ON Container.Id = tmpMIContainer_Count_3.ContainerId_Parent
                                                                   AND tmpMIContainer_Count_3.isParentDetail = TRUE
                                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                              ON CLO_GoodsKind.ContainerId = tmpMIContainer_Count_3.ContainerId_Parent
                                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                                                            AND tmpMIContainer_Count_3.isParentDetail = TRUE
                                          )
                    -- ��������: �������������� + ���� �� ��� ����� ����� MovementItemId
                  , tmpMIContainer_Count AS (SELECT tmpMIContainer_Count_4.MovementItemId        AS MovementItemId
                                                  , tmpMIContainer_Count_4.MovementItemId_Parent AS MovementItemId_Parent
                                                  , tmpMIContainer_Count_4.GoodsId_Parent
                                                  , tmpMIContainer_Count_4.GoodsKindId_Parent
                                                  , tmpMIContainer_Count_4.GoodsId
                                                  , tmpMIContainer_Count_4.GoodsKindId
                                                  , tmpMIContainer_Count_4.isActive
                                                  , tmpMIContainer_Count_4.Amount_Count
                                                  , tmpMIContainer_Count_4.MovementId
                                                  , tmpMIContainer_Count_4.MovementDescId
                                                  , tmpMIContainer_Count_4.InvNumber
                                                  , tmpMIContainer_Count_4.isDestination
                                                  , tmpMIContainer_Count_4.isParentDetail
                                                  , tmpMIContainer_Count_4.isInfoMoneyDetail
                                             FROM tmpMIContainer_Count_4
                                            UNION ALL
                                             SELECT tmpMIContainer_Summ_all.MovementItemId
                                                  , NULL AS MovementItemId_Parent
                                                  , NULL AS GoodsId_Parent
                                                  , NULL AS GoodsKindId_Parent
                                                  , NULL AS GoodsId
                                                  , NULL AS GoodsKindId
                                                  , tmpMIContainer_Summ_all.isActive
                                                  , NULL AS Amount_Count
                                                  , tmpMIContainer_Summ_all.MovementId
                                                  , tmpMIContainer_Summ_all.MovementDescId
                                                  , tmpMIContainer_Summ_all.InvNumber
                                                  , tmpMIContainer_Summ_all.isDestination
                                                  , tmpMIContainer_Summ_all.isParentDetail
                                                  , tmpMIContainer_Summ_all.isInfoMoneyDetail
                                             FROM tmpMIContainer_Summ_all
                                                  LEFT JOIN tmpMIContainer_Count_all ON tmpMIContainer_Count_all.MovementId = tmpMIContainer_Summ_all.MovementId
                                             WHERE tmpMIContainer_Count_all.MovementId IS NULL
                                             GROUP BY tmpMIContainer_Summ_all.MovementItemId
                                                    , tmpMIContainer_Summ_all.isActive
                                                    , tmpMIContainer_Summ_all.MovementId
                                                    , tmpMIContainer_Summ_all.MovementDescId
                                                    , tmpMIContainer_Summ_all.InvNumber
                                                    , tmpMIContainer_Summ_all.isDestination
                                                    , tmpMIContainer_Summ_all.isParentDetail
                                                    , tmpMIContainer_Summ_all.isInfoMoneyDetail
                                            )
            -- ��������: � �������������� ������������� �������� !!!�� MovementItemId + IsActive!!!
          , tmpMIContainer AS (SELECT tmpMIContainer_Summ_all.Id
                                    , tmpMIContainer_Summ_all.MovementItemId
                                    , tmpMIContainer_Summ_all.ParentId
                                    , tmpMIContainer_Summ_all.ContainerId
                                    , tmpMIContainer_Summ_all.AccountId
                                    , tmpMIContainer_Summ_all.Amount
                                    , tmpMIContainer_Summ_all.OperDate
                                    , tmpMIContainer_Summ_all.IsActive

                                    , tmpMIContainer_Count.MovementItemId_Parent
                                    , tmpMIContainer_Count.GoodsId_Parent
                                    , tmpMIContainer_Count.GoodsKindId_Parent
                                    , tmpMIContainer_Count.GoodsId
                                    , tmpMIContainer_Count.GoodsKindId
                                    , tmpMIContainer_Count.Amount_Count

                                    , tmpMIContainer_Count.MovementId
                                    , tmpMIContainer_Count.MovementDescId
                                    , tmpMIContainer_Count.InvNumber

                                    , tmpMIContainer_Summ_all.ContainerId_Currency
                                    , tmpMIContainer_Summ_all.Amount_Currency

                                    , tmpMIContainer_Count.isDestination
                                    , tmpMIContainer_Count.isParentDetail
                                    , tmpMIContainer_Count.isInfoMoneyDetail
                               FROM tmpMIContainer_Count
                                    INNER JOIN tmpMIContainer_Summ_all ON tmpMIContainer_Summ_all.MovementItemId = tmpMIContainer_Count.MovementItemId
                                                                      AND tmpMIContainer_Summ_all.IsActive = tmpMIContainer_Count.IsActive
                              )
        -- ��������: � �������� ������������� �������� "�������" (���� ��� ����������� "��������" + ��� � �������� ��������� �������� �� ��������-��������������)
     , tmpMIContainer_Summ AS (SELECT tmpMIContainer.Id
                                    , tmpMIContainer.MovementItemId
                                    , tmpMIContainer.ParentId
                                    , tmpMIContainer.ContainerId
                                    , tmpMIContainer.AccountId
                                    , tmpMIContainer.Amount
                                    , tmpMIContainer.OperDate
                                    , tmpMIContainer.IsActive

                                    , CASE WHEN tmpMIContainer.AccountId = zc_Enum_Account_100301() AND 1 = 0 -- !!!�� ������� ���� ��� �� �������� �� ��������-��������������!!!!
                                                THEN COALESCE (tmpMIContainer_parent.ContainerId, tmpMIContainer.ContainerId)
                                           ELSE tmpMIContainer.ContainerId
                                      END AS ContainerId_find
                                    , COALESCE (tmpMIContainer_parent.MovementItemId_Parent, tmpMIContainer.MovementItemId_Parent) AS MovementItemId_Parent
                                    , COALESCE (tmpMIContainer_parent.GoodsId_Parent, tmpMIContainer.GoodsId_Parent)               AS GoodsId_Parent
                                    , COALESCE (tmpMIContainer_parent.GoodsKindId_Parent, tmpMIContainer.GoodsKindId_Parent)       AS GoodsKindId_Parent
                                    , tmpMIContainer.GoodsId
                                    , tmpMIContainer.GoodsKindId
                                    , tmpMIContainer.Amount_Count

                                    , tmpMIContainer.MovementId
                                    , tmpMIContainer.MovementDescId
                                    , tmpMIContainer.InvNumber

                                    , tmpMIContainer.ContainerId_Currency
                                    , tmpMIContainer.Amount_Currency

                                    , tmpMIContainer.isDestination
                                    , tmpMIContainer.isParentDetail
                                    , tmpMIContainer.isInfoMoneyDetail
                               FROM tmpMIContainer
                                    LEFT JOIN tmpMIContainer AS tmpMIContainer_parent ON tmpMIContainer_parent.Id = tmpMIContainer.ParentId
                              )
                      -- ����� ����: �������� ��������������: �������� ���-�� ��������������� ������ ������� (���� ��� ������� ���� ������ ����� inIsParentDetail = TRUE)
                    , tmpPrice_Parent AS (SELECT tmpMIContainer_Count.GoodsId_Parent
                                               , tmpMIContainer_Count.GoodsKindId_Parent
                                               , tmpMIContainer_Count.GoodsId
                                               , tmpMIContainer_Count.GoodsKindId
                                               , tmpMIContainer_Count.isActive
                                               , SUM (tmpMIContainer_Count.Amount_Count) AS Amount_Count
                                          FROM tmpMIContainer_Count_4 AS tmpMIContainer_Count
                                          WHERE tmpMIContainer_Count.isParentDetail = TRUE AND tmpMIContainer_Count.isInfoMoneyDetail = FALSE
                                          GROUP BY tmpMIContainer_Count.GoodsId_Parent
                                                 , tmpMIContainer_Count.GoodsKindId_Parent
                                                 , tmpMIContainer_Count.GoodsId
                                                 , tmpMIContainer_Count.GoodsKindId
                                                 , tmpMIContainer_Count.isActive
                                          )
                             -- ����� ����: �������� ��������������: �������� ���-�� ��������������� ������ ������� (���� ��� ������� ���� ������ ����� inIsDestination = TRUE)
                           , tmpPrice AS (SELECT tmpMIContainer_Count.GoodsId
                                               , tmpMIContainer_Count.GoodsKindId
                                               , tmpMIContainer_Count.isActive
                                               , SUM (tmpMIContainer_Count.Amount_Count) AS Amount_Count
                                          FROM tmpMIContainer_Count_2 AS tmpMIContainer_Count
                                          WHERE tmpMIContainer_Count.isDestination = TRUE AND tmpMIContainer_Count.isParentDetail = FALSE
                                          GROUP BY tmpMIContainer_Count.GoodsId
                                                 , tmpMIContainer_Count.GoodsKindId
                                                 , tmpMIContainer_Count.isActive
                                          )
            -- ����: ��� ProductionSeparate + ������ (�.�. ����� ����� �������� ���� �������)
          , tmpPrice_ProductionSeparate AS (SELECT -- Id
                                                   MovementItemId
                                                 -- , CASE WHEN Amount_Count <> 0 THEN (CASE WHEN isActive = TRUE THEN 1 ELSE -1 END * Amount) / Amount_Count ELSE 0 END AS Price
                                                 , CASE WHEN Amount_Count <> 0 THEN SUM (CASE WHEN isActive = TRUE THEN 1 ELSE -1 END * Amount) / Amount_Count ELSE 0 END AS Price
                                            FROM tmpMIContainer
                                            WHERE isInfoMoneyDetail = TRUE
                                              AND MovementDescId = zc_Movement_ProductionSeparate()
                                              AND isActive = FALSE
                                            GROUP BY MovementItemId, Amount_Count
                                           )
            -- ����: ��� ProductionSeparate + ������ (�.�. ����� ����� �������� ���� �������)
          , tmpPriceGroup_ProductionSeparate AS (SELECT tmpMIContainer.GoodsId
                                                      , tmpMIContainer.GoodsKindId
                                                      , CASE WHEN Amount_Count <> 0 THEN -1 * Amount / Amount_Count ELSE 0 END AS Price
                                                 FROM (SELECT GoodsId, GoodsKindId, SUM (Amount_Count) AS Amount_Count FROM tmpMIContainer_Count_2 WHERE MovementDescId = zc_Movement_ProductionSeparate() AND isActive = FALSE AND isParentDetail = TRUE AND isInfoMoneyDetail = FALSE GROUP BY GoodsId, GoodsKindId) AS tmpMIContainer
                                                      LEFT JOIN (SELECT GoodsId, GoodsKindId, SUM (Amount) AS Amount FROM tmpMIContainer_Summ WHERE MovementDescId = zc_Movement_ProductionSeparate() AND isActive = FALSE AND isParentDetail = TRUE AND isInfoMoneyDetail = FALSE GROUP BY GoodsId, GoodsKindId) AS tmpMIContainerSumm
                                                               ON tmpMIContainerSumm.GoodsId = tmpMIContainer.GoodsId
                                                              AND tmpMIContainerSumm.GoodsKindId = tmpMIContainer.GoodsKindId
                                                )

       SELECT
             zfConvert_StringToNumber (tmpMovementItemContainer.InvNumber) AS InvNumber
           , tmpMovementItemContainer.OperDate
           , CAST (Object_Account_View.AccountCode AS Integer) AS AccountCode

           , CAST (CASE WHEN tmpMovementItemContainer.isActive = TRUE THEN tmpMovementItemContainer.Amount ELSE 0 END AS TFloat) AS DebetAmount
           , CAST (CASE WHEN tmpMovementItemContainer.isActive = TRUE /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountGroupName ELSE NULL END  AS TVarChar) AS DebetAccountGroupName
           , CAST (CASE WHEN tmpMovementItemContainer.isActive = TRUE /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountDirectionName ELSE NULL END  AS TVarChar) AS DebetAccountDirectionName
           , CAST (CASE WHEN tmpMovementItemContainer.isActive = TRUE /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountName_all ELSE NULL END  AS TVarChar) AS DebetAccountName

           , CAST (CASE WHEN tmpMovementItemContainer.isActive = FALSE THEN -1 * tmpMovementItemContainer.Amount ELSE 0 END AS TFloat) AS KreditAmount
           , CAST (CASE WHEN tmpMovementItemContainer.isActive = FALSE /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountGroupName ELSE NULL END  AS TVarChar) AS KreditAccountGroupName
           , CAST (CASE WHEN tmpMovementItemContainer.isActive = FALSE /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountDirectionName ELSE NULL END  AS TVarChar) AS KreditAccountDirectionName
           , CAST (CASE WHEN tmpMovementItemContainer.isActive = FALSE /*COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active()*/ THEN Object_Account_View.AccountName_all ELSE NULL END  AS TVarChar) AS KreditAccountName

           , CAST (tmpMovementItemContainer.Amount_Currency AS TFloat) AS Amount_Currency

           , CASE WHEN tmpMovementItemContainer.MovementDescId = zc_Movement_ProductionSeparate() AND tmpMovementItemContainer.IsActive = FALSE AND tmpMovementItemContainer.isParentDetail = TRUE AND tmpMovementItemContainer.isInfoMoneyDetail = FALSE
                       THEN tmpPriceGroup_ProductionSeparate.Price
                  WHEN tmpMovementItemContainer.isParentDetail = TRUE AND tmpPrice_Parent.Amount_Count <> 0
                       THEN CASE WHEN tmpMovementItemContainer.isActive = TRUE THEN 1 ELSE -1 END  * tmpMovementItemContainer.Amount / tmpPrice_Parent.Amount_Count
                  WHEN tmpMovementItemContainer.isDestination = TRUE AND tmpPrice.Amount_Count <> 0
                       THEN CASE WHEN tmpMovementItemContainer.isActive = TRUE THEN 1 ELSE -1 END  * tmpMovementItemContainer.Amount / tmpPrice.Amount_Count
                  ELSE tmpMovementItemContainer.Price
             END :: TFloat AS Price

           , Object_Account_View.onComplete AS AccountOnComplete
           , tmpMovementItemContainer.DirectionObjectCode
           , CAST (tmpMovementItemContainer.DirectionObjectName AS TVarChar) AS DirectionObjectName
           , tmpMovementItemContainer.BranchCode
           , tmpMovementItemContainer.BranchName
           , tmpMovementItemContainer.BusinessCode
           , tmpMovementItemContainer.BusinessName
           , tmpMovementItemContainer.GoodsGroupCode
           , tmpMovementItemContainer.GoodsGroupName
           , tmpMovementItemContainer.DestinationObjectCode
           , tmpMovementItemContainer.DestinationObjectName
           , tmpMovementItemContainer.JuridicalBasisCode
           , tmpMovementItemContainer.JuridicalBasisName
           , tmpMovementItemContainer.GoodsKindName
           , tmpMovementItemContainer.ObjectCostId
           , tmpMovementItemContainer.MIId_Parent
           , tmpMovementItemContainer.GoodsCode_Parent
           , tmpMovementItemContainer.GoodsName_Parent
           , tmpMovementItemContainer.GoodsKindName_Parent
           , tmpMovementItemContainer.InfoMoneyCode
           , tmpMovementItemContainer.InfoMoneyName
           , tmpMovementItemContainer.InfoMoneyCode_Detail
           , tmpMovementItemContainer.InfoMoneyName_Detail
           , Object_Currency.ValueData AS CurrencyName
       FROM 
           (SELECT
                  tmpMIContainer_Summ.InvNumber
                , tmpMIContainer_Summ.OperDate
                , tmpMIContainer_Summ.MovementDescId
                , tmpMIContainer_Summ.AccountId
                , SUM (tmpMIContainer_Summ.Amount)  AS Amount
                , SUM (tmpMIContainer_Summ.Amount_Currency) AS Amount_Currency
                , tmpMIContainer_Summ.isActive

                , tmpMIContainer_Summ.Id
                , tmpMIContainer_Summ.ContainerId        AS ObjectCostId
                , SUM (tmpMIContainer_Summ.Amount_Count) AS Amount_Count

                , Object_JuridicalBasis.ObjectCode AS JuridicalBasisCode
                , Object_JuridicalBasis.ValueData  AS JuridicalBasisName
                , Object_Business.ObjectCode  AS BusinessCode
                , Object_Business.ValueData   AS BusinessName
                , Object_Branch.ObjectCode    AS BranchCode
                , Object_Branch.ValueData     AS BranchName

                , CASE WHEN Object_ProfitLoss_View.ProfitLossName_all IS NOT NULL
                            THEN Object_ProfitLoss_View.ProfitLossCode
                       ELSE Object_Direction.ObjectCode
                  END AS DirectionObjectCode
                , CASE WHEN Object_ProfitLoss_View.ProfitLossName_all IS NOT NULL
                            THEN Object_ProfitLoss_View.ProfitLossName_all
                       ELSE Object_Direction.ValueData
                  END AS DirectionObjectName


                , COALESCE (Object_Destination.Id, 0) AS DestinationId
                , Object_Destination.ObjectCode       AS DestinationObjectCode
                , Object_Destination.ValueData        AS DestinationObjectName
                , Object_GoodsGroup.ObjectCode        AS GoodsGroupCode
                , Object_GoodsGroup.ValueData         AS GoodsGroupName
                , COALESCE (Object_GoodsKind.Id, 0)   AS GoodsKindId
                , Object_GoodsKind.ValueData          AS GoodsKindName

                , tmpMIContainer_Summ.CurrencyId

                , View_InfoMoney.InfoMoneyCode
                , View_InfoMoney.InfoMoneyName
                , View_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
                , View_InfoMoney_Detail.InfoMoneyName AS InfoMoneyName_Detail

                , tmpMIContainer_Summ.MovementItemId_Parent AS MIId_Parent
                , tmpMIContainer_Summ.GoodsId_Parent        AS GoodsId_Parent
                , tmpMIContainer_Summ.GoodsKindId_parent    AS GoodsKindId_parent
                , Object_Goods_Parent.ObjectCode            AS GoodsCode_Parent
                , Object_Goods_Parent.ValueData             AS GoodsName_Parent
                , Object_GoodsKind_Parent.ValueData         AS GoodsKindName_Parent

                , CASE WHEN tmpMIContainer_Summ.MovementDescId = zc_Movement_ProductionSeparate()
                        AND tmpMIContainer_Summ.isActive = FALSE
                        AND tmpMIContainer_Summ.isInfoMoneyDetail = TRUE 
                          THEN tmpPrice_ProductionSeparate.Price
                       WHEN SUM (tmpMIContainer_Summ.Amount_Count) <> 0
                          THEN SUM (CASE WHEN tmpMIContainer_Summ.isActive = TRUE THEN 1 ELSE -1 END * tmpMIContainer_Summ.Amount) / SUM (tmpMIContainer_Summ.Amount_Count)
                       ELSE 0
                  END AS Price

                , tmpMIContainer_Summ.isDestination
                , tmpMIContainer_Summ.isParentDetail
                , tmpMIContainer_Summ.isInfoMoneyDetail

            FROM
           (SELECT
                  tmpMIContainer_Summ.InvNumber
                , tmpMIContainer_Summ.OperDate
                , tmpMIContainer_Summ.MovementDescId
                , tmpMIContainer_Summ.AccountId
                , tmpMIContainer_Summ.Amount
                , tmpMIContainer_Summ.Amount_Currency

                , tmpMIContainer_Summ.isActive

                , CASE WHEN tmpMIContainer_Summ.isInfoMoneyDetail = TRUE THEN tmpMIContainer_Summ.Id             ELSE 0 END AS Id
                , CASE WHEN tmpMIContainer_Summ.isInfoMoneyDetail = TRUE THEN tmpMIContainer_Summ.ContainerId    ELSE 0 END AS ContainerId
                , CASE WHEN tmpMIContainer_Summ.isInfoMoneyDetail = TRUE THEN tmpMIContainer_Summ.MovementItemId ELSE 0 END AS MovementItemId
                , CASE WHEN tmpMIContainer_Summ.isInfoMoneyDetail = TRUE THEN tmpMIContainer_Summ.Amount_Count   ELSE 0 END AS Amount_Count

                , CASE WHEN ContainerLinkObject_ProfitLoss.ObjectId <> 0
                            THEN ContainerLinkObject_ProfitLoss.ObjectId
                       WHEN ContainerLinkObject_Cash.ObjectId <> 0
                            THEN ContainerLinkObject_Cash.ObjectId

                       WHEN ContainerLinkObject_BankAccount.ObjectId <> 0
                            THEN ContainerLinkObject_BankAccount.ObjectId
                       WHEN ContainerLinkObject_Juridical.ObjectId <> 0
                            THEN ContainerLinkObject_Juridical.ObjectId
                       WHEN ContainerLinkObject_Founder.ObjectId <> 0
                            THEN ContainerLinkObject_Founder.ObjectId

                       WHEN ContainerLinkObject_Member.ObjectId <> 0
                            THEN ContainerLinkObject_Member.ObjectId
                       WHEN ContainerLinkObject_Car.ObjectId <> 0
                            THEN ContainerLinkObject_Car.ObjectId
                       WHEN ContainerLinkObject_Unit.ObjectId <> 0
                            THEN ContainerLinkObject_Unit.ObjectId
                  END AS DirectionId
                , CASE WHEN tmpMIContainer_Summ.isDestination = TRUE THEN tmpMIContainer_Summ.GoodsId ELSE 0 END     AS DestinationId
                , CASE WHEN tmpMIContainer_Summ.isDestination = TRUE THEN tmpMIContainer_Summ.GoodsKindId ELSE 0 END AS GoodsKindId

                , ContainerLO_JuridicalBasis.ObjectId     AS JuridicalBasisId
                , ContainerLinkObject_Business.ObjectId   AS BusinessId
                , ContainerLinkObject_ProfitLoss.ObjectId AS ProfitLossId
                , MILinkObject_Branch.ObjectId            AS BranchId


                , ContainerLinkObject_Currency.ObjectId AS CurrencyId
                , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                , CASE WHEN tmpMIContainer_Summ.isInfoMoneyDetail = FALSE THEN 0 WHEN ContainerLinkObject_InfoMoneyDetail.ObjectId <> 0 THEN ContainerLinkObject_InfoMoneyDetail.ObjectId ELSE ContainerLinkObject_InfoMoney.ObjectId END AS InfoMoneyId_Detail

                , CASE WHEN tmpMIContainer_Summ.isInfoMoneyDetail = TRUE THEN tmpMIContainer_Summ.MovementItemId_Parent ELSE 0 END AS MovementItemId_Parent
                , CASE WHEN tmpMIContainer_Summ.isParentDetail = TRUE THEN tmpMIContainer_Summ.GoodsId_Parent ELSE 0 END           AS GoodsId_Parent
                , CASE WHEN tmpMIContainer_Summ.isParentDetail = TRUE THEN tmpMIContainer_Summ.GoodsKindId_parent ELSE 0 END       AS GoodsKindId_parent

                , tmpMIContainer_Summ.isDestination
                , tmpMIContainer_Summ.isParentDetail
                , tmpMIContainer_Summ.isInfoMoneyDetail

            FROM tmpMIContainer_Summ
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                               ON ContainerLinkObject_Juridical.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Founder
                                               ON ContainerLinkObject_Founder.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_Founder.DescId = zc_ContainerLinkObject_Founder()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Member
                                               ON ContainerLinkObject_Member.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_Member.DescId = zc_ContainerLinkObject_Member()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                               ON ContainerLinkObject_Unit.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                               ON ContainerLinkObject_Car.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                               ON ContainerLinkObject_Cash.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_Cash.DescId = zc_ContainerLinkObject_Cash()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_BankAccount
                                               ON ContainerLinkObject_BankAccount.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()

                 LEFT JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                               ON ContainerLO_JuridicalBasis.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                               ON ContainerLinkObject_Business.ContainerId = tmpMIContainer_Summ.ContainerId -- tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_ProfitLoss
                                               ON ContainerLinkObject_ProfitLoss.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                 -- ��� ��� "������" �������� ������
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                  ON MILinkObject_Branch.MovementItemId = tmpMIContainer_Summ.MovementItemId -- MIReport_MI.MovementItemId -- COALESCE (MovementItemContainer.MovementItemId, MIReport_MI.MovementItemId)
                                                 AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Currency
                                               ON ContainerLinkObject_Currency.ContainerId = tmpMIContainer_Summ.ContainerId
                                              AND ContainerLinkObject_Currency.DescId = zc_ContainerLinkObject_Currency()

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                               ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                               ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpMIContainer_Summ.ContainerId_find
                                              AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                              -- AND 1=0
           ) AS tmpMIContainer_Summ

                 LEFT JOIN tmpPrice_ProductionSeparate ON tmpPrice_ProductionSeparate.MovementItemId = tmpMIContainer_Summ.MovementItemId
                 -- LEFT JOIN tmpPrice_ProductionSeparate ON tmpPrice_ProductionSeparate.Id = tmpMIContainer_Summ.Id

                 LEFT JOIN Object_ProfitLoss_View ON Object_ProfitLoss_View.ProfitLossId = tmpMIContainer_Summ.ProfitLossId
                 LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmpMIContainer_Summ.DirectionId
                 LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmpMIContainer_Summ.DestinationId

                 LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpMIContainer_Summ.JuridicalBasisId
                 LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpMIContainer_Summ.BusinessId
                 LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpMIContainer_Summ.BranchId

                 LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpMIContainer_Summ.InfoMoneyId
                 LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Detail ON View_InfoMoney_Detail.InfoMoneyId = tmpMIContainer_Summ.InfoMoneyId_Detail

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMIContainer_Summ.DestinationId
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_Summ.GoodsKindId
                 LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = tmpMIContainer_Summ.GoodsId_Parent
                 LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = tmpMIContainer_Summ.GoodsKindId_parent

            GROUP BY tmpMIContainer_Summ.InvNumber
                   , tmpMIContainer_Summ.OperDate
                   , tmpMIContainer_Summ.isActive
                   , tmpMIContainer_Summ.AccountId
                   , tmpMIContainer_Summ.ContainerId
                   , tmpMIContainer_Summ.MovementItemId_Parent
                   , tmpMIContainer_Summ.Id
                   , tmpMIContainer_Summ.MovementDescId

                   , tmpMIContainer_Summ.GoodsId_Parent
                   , tmpMIContainer_Summ.GoodsKindId_parent

                   , tmpMIContainer_Summ.CurrencyId

                   , Object_Branch.ObjectCode
                   , Object_Branch.ValueData
                   , Object_Business.ObjectCode
                   , Object_Business.ValueData
                   , Object_Direction.ObjectCode
                   , Object_Direction.ValueData
                   , Object_ProfitLoss_View.ProfitLossCode
                   , Object_ProfitLoss_View.ProfitLossName_all
                   , Object_GoodsGroup.ObjectCode
                   , Object_GoodsGroup.ValueData
                   , Object_Destination.Id
                   , Object_Destination.ObjectCode
                   , Object_Destination.ValueData
                   , Object_GoodsKind.Id
                   , Object_GoodsKind.ValueData
                   , Object_Goods_Parent.ObjectCode
                   , Object_Goods_Parent.ValueData
                   , Object_GoodsKind_Parent.ValueData
                   , Object_JuridicalBasis.ObjectCode
                   , Object_JuridicalBasis.ValueData
                   , View_InfoMoney.InfoMoneyCode
                   , View_InfoMoney.InfoMoneyName
                   , View_InfoMoney_Detail.InfoMoneyCode
                   , View_InfoMoney_Detail.InfoMoneyName
                   , tmpPrice_ProductionSeparate.Price

                   , tmpMIContainer_Summ.isDestination
                   , tmpMIContainer_Summ.isParentDetail
                   , tmpMIContainer_Summ.isInfoMoneyDetail

           ) AS tmpMovementItemContainer

           LEFT JOIN tmpPrice_Parent ON tmpPrice_Parent.GoodsId_Parent = tmpMovementItemContainer.GoodsId_Parent
                                    AND tmpPrice_Parent.GoodsKindId_Parent = tmpMovementItemContainer.GoodsKindId_Parent
                                    AND tmpPrice_Parent.GoodsId = tmpMovementItemContainer.DestinationId
                                    AND tmpPrice_Parent.GoodsKindId = tmpMovementItemContainer.GoodsKindId
                                    AND tmpPrice_Parent.isActive = tmpMovementItemContainer.isActive
           LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpMovementItemContainer.DestinationId
                             AND tmpPrice.GoodsKindId = tmpMovementItemContainer.GoodsKindId
                             AND tmpPrice.isActive = tmpMovementItemContainer.isActive
           LEFT JOIN tmpPriceGroup_ProductionSeparate ON tmpPriceGroup_ProductionSeparate.GoodsId = tmpMovementItemContainer.DestinationId
                                                     AND tmpPriceGroup_ProductionSeparate.GoodsKindId = tmpMovementItemContainer.GoodsKindId

           LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpMovementItemContainer.AccountId
           LEFT JOIN ObjectLink AS ObjectLink_AccountKind
                                ON ObjectLink_AccountKind.ObjectId = tmpMovementItemContainer.AccountId
                               AND ObjectLink_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
           LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = tmpMovementItemContainer.CurrencyId
     ;
     END IF;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement (Integer, Boolean, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 23.08.14                                        * add !!!�������� ������ � ������!!!
 10.08.14                                        * add ��� ��� "������" �������� ������
 27.01.14                                        * add zc_ContainerLinkObject_JuridicalBasis
 13.01.14                                        * add Branch : ��� ��� "�� ������" �������� ������
 21.12.13                                        * Personal -> Member
 01.11.13                                        * change DebetAccountName and KreditAccountName
 31.10.13                                        * add InvNumber and OperDate
 21.10.13                                        * add zc_ContainerLinkObject_Business
 12.10.13                                        * rename to DirectionObject and DestinationObject
 06.10.13                                        * add ParentId = inMovementId
 02.10.13                                        * calc DebetAccountName and KreditAccountName
 08.09.13                                        * add zc_ContainerLinkObject_ProfitLoss
 02.09.13                        * ����� ���� ������
 25.08.13                                        * add zc_Enum_AccountKind_Active
 10.08.13                                        * add isActive
 06.08.13                                        * add MIId_Parent
 05.08.13                                        * add Goods_Parent and InfoMoney
 11.07.13                                        * add zc_ObjectLink_Account_AccountKind
 08.07.13                                        * add AccountOnComplete
 04.07.13                                        * rename AccountId to ObjectId
 03.07.13                                        *
*/

/*
��� ��.����.
DirectionObjectCode

������ �����������
DirectionObjectName

��� ��.����.
DestinationObjectCode

������ ����������
DestinationObjectName
*/
-- ����
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 386405, inIsDestination:= FALSE, inIsParentDetail:= FALSE, inIsInfoMoneyDetail:= FALSE, inSession:= zfCalc_UserAdmin())

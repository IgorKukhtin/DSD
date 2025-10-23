-- Function: lpReport_bi_ProfitLoss()

DROP FUNCTION IF EXISTS lpReport_bi_ProfitLoss (TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpReport_bi_ProfitLoss(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inUserId                   Integer     -- ������ ������������
)
RETURNS TABLE (ContainerId_pl      Integer,
               -- ����
               OperDate            TDateTime,
               -- Id ���������
               MovementId          Integer,
               -- ��� ���������
               MovementDescId      Integer,
               MovementDescName    TVarChar,
               MovementDescCode    TVarChar,

               -- � ���������
               -- InvNumber           Integer,

               -- ���������� ��������
               MovementId_comment  Integer,

               -- ������ ����
               ProfitLossId            Integer,
               ProfitLossCode          Integer,
               ProfitLossGroupName     TVarChar,
               ProfitLossDirectionName TVarChar,
               ProfitLossName          TVarChar,
               ProfitLossName_all      TVarChar,

               -- ������
               BusinessId         Integer,

               -- ������ ������ (Գ��)
               BranchId_pl         Integer,
               BranchCode_pl       Integer,
               BranchName_pl       TVarChar,

               -- ������������� ������ (ϳ������)
               UnitId_pl           Integer,
               UnitCode_pl         Integer,
               UnitName_pl         TVarChar,

               -- ������ ��
               InfoMoneyId Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,


               -- ������������� ����� (̳��� �����)
               UnitId              Integer,
               -- ������������ (����������� ������)
               AssetId             Integer,
               -- ���������� (����������� ������, ����� �����)
               CarId               Integer,
               -- ��������� (����������� ������, ����� �����)
               MemberId            Integer,
               MemberDescId        Integer,
               MemberCode          Integer,
               MemberName          TVarChar,
               -- ������ �������� (������ ��������, ����������� ������)
               ArticleLossId       Integer,

               -- ��'��� �����������
               DirectionId         Integer,
               DirectionCode       Integer,
               DirectionName       TVarChar,
               -- ��'��� �����������
               DestinationId       Integer,
               DestinationCode     Integer,
               DestinationName     TVarChar,

               -- �� ���� (����� �����) - ������������
               FromId              Integer,
               -- ���� (����� �����, ����������� ������) - ������������
               ToId                Integer,

               -- �����
               GoodsId    Integer,
               -- ��� ������
               GoodsKindId         Integer,
               -- ��� ������ (������ ��� ������������ ����� ��)
               GoodsKindId_gp      Integer,

               -- ���-�� (���)
               OperCount           TFloat,
               -- ���-�� (��.)
               OperCount_sh        TFloat,
               -- �����
               OperSumm            TFloat
              )
AS
$BODY$
BEGIN
     -- ���������
     RETURN QUERY
     WITH --
         tmpMIContainer AS (SELECT MIContainer.ContainerId
                                   --
                                 , MIContainer.OperDate
                                 , MIContainer.MovementId
                                 , MIContainer.MovementItemId
                                 , MIContainer.MovementDescId

                                 , -1 * (MIContainer.Amount) AS Amount

                                   -- 1.1. ������������ (����)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                             -- ������������ (����), � ����� ���� UnitId_Route
                                             THEN MIContainer.ObjectIntId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Income()) AND MIContainer.ObjectIntId_Analyzer > 0
                                             -- ������������ (����), � ����� ���� UnitId_Route
                                             THEN MIContainer.ObjectIntId_Analyzer
                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Income())
                                             -- ����������
                                             THEN MIContainer.WhereObjectId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Loss()) AND MLO_ArticleLoss.ObjectId = MIContainer.ObjectExtId_Analyzer
                                             -- �� ������ ��������
                                             THEN COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit() THEN Object_To.Id   END
                                                          , CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id END
                                                           )

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_Send())
                                             -- ������������ ���� � �� ������ �������� ��� ...
                                             THEN MIContainer.ObjectExtId_Analyzer

                                        ELSE MIContainer.WhereObjectId_Analyzer

                                   END AS UnitId_pl

                                   -- 1.2. ����������� (����)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Loss())
                                             -- ������ ��������
                                             THEN MLO_ArticleLoss.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Transport())
                                             THEN -- �������� UnitId_ProfitLoss
                                                  MIContainer.ObjectIntId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_TransportService())
                                             -- �������
                                             THEN MILO_Route_01.ObjectId

                                        WHEN MIContainer.ObjectExtId_Analyzer > 0
                                             -- ������
                                             THEN MIContainer.ObjectExtId_Analyzer

                                        -- ������
                                        ELSE MIContainer.WhereObjectId_Analyzer

                                   END AS DirectionId
                               --, MIContainer.WhereObjectId_Analyzer AS DirectionId

                                   -- 1.3. ���������� (����)
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport())
                                             -- �������� ���
                                             THEN MIContainer.ObjectId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_TransportService())
                                             -- ��� ������ ���������-������
                                             THEN MovementItem_01.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                             -- �����
                                             THEN MIContainer.ObjectId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount())
                                             -- �����/ �.����
                                             THEN MovementItem_01.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
                                             -- ��� ������ ������
                                             THEN MovementItem_01.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalService())
                                             -- ���������
                                             THEN MIContainer.ObjectIntId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalReport())
                                             -- ���������
                                             THEN MovementItem_01.ObjectId

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_MobileBills())
                                             -- � ���� �������� �������
                                             THEN MILO_Employee_01.ObjectId

                                        ELSE 0

                                   END AS DestinationId

                                   -- 1.4. �� ������
                                 , COALESCE (MILO_InfoMoney_01.ObjectId
                                           , ObjectLink_ArticleLoss_InfoMoney.ChildObjectId
                                           , ObjectLink_Goods_InfoMoney.ChildObjectId
                                           , CASE WHEN ObjectId_Analyzer.DescId = zc_Object_InfoMoney() THEN ObjectId_Analyzer.Id END
                                             -- ��� Transport - �� + ���
                                           , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport()
                                                       THEN CASE WHEN ObjectId_Analyzer.DescId IN (zc_Object_Personal(), zc_Object_Member())
                                                                      -- ��� Transport - ��
                                                                      THEN zc_Enum_InfoMoney_60101()
                                                                 -- ��� Transport - ���
                                                                 ELSE  zc_Enum_InfoMoney_20401()
                                                            END
                                             END
                                            ) AS InfoMoneyId

                                   -- 2.1. ������������� �����
                                 , MLO_From.ObjectId         AS UnitId

                                   -- 2.2. ������������ (����������� ������)
                                 , COALESCE (MILO_Asset_1.ObjectId, MLO_Asset_2.ObjectId) AS AssetId

                                   -- 2.3. ���������� (����������� ������, ����� �����)
                                 , COALESCE (MILO_Car_1.ObjectId, MLO_Car_2.ObjectId
                                           , CASE WHEN Object_To.DescId   = zc_Object_Car() THEN Object_To.Id   END
                                           , CASE WHEN Object_From.DescId = zc_Object_Car() THEN Object_From.Id END
                                            ) AS CarId

                                   -- 2.4. ��������� (����������� ������, ����� �����)
                                 , COALESCE (MILO_Employee_01.ObjectId
                                           , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalService()) THEN MovementItem_01.ObjectId END
                                           , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalReport())  THEN MovementItem_01.ObjectId END
                                           , CASE WHEN Object_To.DescId   IN (zc_Object_Personal(), zc_Object_Member()) THEN Object_To.Id   END
                                           , CASE WHEN Object_From.DescId IN (zc_Object_Personal(), zc_Object_Member()) THEN Object_From.Id END
                                           , CASE WHEN ObjectId_Analyzer.DescId IN (zc_Object_Personal(), zc_Object_Member()) THEN ObjectId_Analyzer.Id END
                                            ) AS MemberId

                                   -- 2.5. ������ ��������
                                 , MLO_ArticleLoss.ObjectId  AS ArticleLossId

                                   -- 3. �� ������, �������������� �� ������� �������
                                 , MIContainer.ContainerIntId_analyzer AS MovementItemId_sale_transport

                                 -- 4.1. �� ����
                                 , MLO_From.ObjectId AS FromId
                                 -- 4.2. ����
                                 , MLO_To.ObjectId   AS ToId

                                 -- 5.1.
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Transport()) AND ObjectId_Analyzer.DescId IN (zc_Object_Fuel(), zc_Object_Goods())
                                             -- �������� ���
                                             THEN MIContainer.ObjectId_Analyzer

                                        WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                             -- �����
                                             THEN MIContainer.ObjectId_Analyzer
                                        ELSE 0
                                   END AS GoodsId

                                 -- 5.2.
                                 , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                             -- �����
                                             THEN MIContainer.ObjectIntId_Analyzer
                                        ELSE 0
                                   END AS GoodsKindId

                                   -- ����� - ���������
                                 /*, MovementItem_02.ObjectId       AS GoodsId_transport
                                   -- ��� ������ - ���������
                                 , MILO_GoodsKind_02.ObjectId       AS GoodsKindId_transport*/

                            FROM MovementItemContainer AS MIContainer
                                 LEFT JOIN MovementItem AS MovementItem_01
                                                        ON MovementItem_01.Id = MIContainer.MovementItemId
                                                       AND MovementItem_01.DescId = zc_MI_Master()
                                                       AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_Service(), zc_Movement_TransportService()
                                                                                        , zc_Movement_PersonalService(), zc_Movement_ProfitLossService(), zc_Movement_MobileBills()
                                                                                        , zc_Movement_PersonalReport(), zc_Movement_LossPersonal(), zc_Movement_LossDebt()
                                                                                         )
                                 LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney_01
                                                                  ON MILO_InfoMoney_01.MovementItemId = MovementItem_01.Id
                                                                 AND MILO_InfoMoney_01.DescId         = zc_MILinkObject_InfoMoney()

                                 -- � ���� �������� �������
                                 LEFT JOIN MovementItemLinkObject AS MILO_Employee_01
                                                                  ON MILO_Employee_01.MovementItemId = MovementItem_01.Id
                                                                 AND MILO_Employee_01.DescId         = zc_MILinkObject_Employee()
                                                                 AND MIContainer.MovementDescId      IN (zc_Movement_MobileBills())
                                 -- �������
                                 LEFT JOIN MovementItemLinkObject AS MILO_Route_01
                                                                  ON MILO_Route_01.MovementItemId = MovementItem_01.Id
                                                                 AND MILO_Route_01.DescId         = zc_MILinkObject_Route()
                                                                 AND MIContainer.MovementDescId   IN (zc_Movement_TransportService())

                                 -- ���� ��������� �������� � ������� ��
                                 /*LEFT JOIN MovementItem AS MovementItem_02
                                                        ON -- �� ������, �������������� �� ������� �������
                                                           MovementItem_02.Id = MIContainer.ContainerIntId_analyzer
                                                       AND MovementItem_02.DescId = zc_MI_Master()
                                                       AND MIContainer.MovementDescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                 LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind_02
                                                                  ON -- �� ������, �������������� �� ������� �������
                                                                     MILO_GoodsKind_02.MovementItemId = MIContainer.ContainerIntId_analyzer
                                                                 AND MILO_GoodsKind_02.DescId         = zc_MILinkObject_GoodsKind()
                                                                 --AND 1=0
                                 -- ���� ��������� �������� � ������� - ���������� � �������
                                 LEFT JOIN MovementLinkObject AS MLO_To_02
                                                              ON MLO_To_02.MovementId = MovementItem_02.MovementId
                                                             AND MLO_To_02.DescId     = zc_MovementLinkObject_To()*/

                                 -- ������������ (����������� ������)
                                 LEFT JOIN MovementItemLinkObject AS MILO_Asset_1
                                                                  ON MILO_Asset_1.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Asset_1.DescId         = zc_MILinkObject_Asset()
                                 LEFT JOIN MovementLinkObject AS MLO_Asset_2
                                                              ON MLO_Asset_2.MovementId = MIContainer.MovementId
                                                             AND MLO_Asset_2.DescId     = NULL -- zc_MovementLinkObject_Asset()
                                 -- ���������� (����������� ������, ����� �����)
                                 LEFT JOIN MovementItemLinkObject AS MILO_Car_1
                                                                  ON MILO_Car_1.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_Car_1.DescId         = zc_MILinkObject_Car()
                                 LEFT JOIN MovementLinkObject AS MLO_Car_2
                                                              ON MLO_Car_2.MovementId = MIContainer.MovementId
                                                             AND MLO_Car_2.DescId     = zc_MovementLinkObject_Car()



                                 -- ������ �������� (������ ��������, ����������� ������)
                                 LEFT JOIN MovementLinkObject AS MLO_ArticleLoss
                                                              ON MLO_ArticleLoss.MovementId = MIContainer.MovementId
                                                             AND MLO_ArticleLoss.DescId     = zc_MovementLinkObject_ArticleLoss()
                                 LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney
                                                      ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = MLO_ArticleLoss.ObjectId
                                                     AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
                                                     -- AND 1=0
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId = MIContainer.ObjectId_Analyzer
                                                     AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                                     AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory())
                                                     -- AND 1=0

                                 -- �� ����
                                 LEFT JOIN MovementLinkObject AS MLO_From
                                                              ON MLO_From.MovementId = MIContainer.MovementId
                                                             AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
                                 -- ����
                                 LEFT JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = MIContainer.MovementId
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                 LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

                                 -- ObjectId_Analyzer
                                 LEFT JOIN Object AS ObjectId_Analyzer ON ObjectId_Analyzer.Id = MIContainer.ObjectId_Analyzer

                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.AccountId = zc_Enum_Account_100301()
                              AND MIContainer.isActive = FALSE
                            --AND (MIContainer.MovementId = 20615866 OR vbUserId <> 5)
                            --AND (MIContainer.MovementDescId = zc_Movement_Transport() OR vbUserId <> 5)
                            --AND (MIContainer.ObjectIntId_Analyzer = 8429 or vbUserId <> 5)
                            --AND (MIContainer.MovementId in (25881365, 25834263)  or vbUserId <> 5)
                           )

          , tmpMI_count AS (SELECT MAX (tmpMIContainer.ContainerId) AS ContainerId
                                   --
                                 , MAX (tmpMIContainer.OperDate) AS OperDate
                                 , tmpMIContainer.MovementId
                                 , tmpMIContainer.MovementItemId
                                 , MAX (tmpMIContainer.MovementDescId) AS MovementDescId

                                   -- ������������ (����)
                                 , MAX (tmpMIContainer.UnitId_pl) AS UnitId_pl

                                   -- ���������� (����)
                                 , MAX (tmpMIContainer.DestinationId) AS DestinationId

                                   -- ����������� (����)
                                 , MAX (tmpMIContainer.DirectionId) AS DirectionId

                                   -- �� ������
                                 , MAX (tmpMIContainer.InfoMoneyId) AS InfoMoneyId

                                   -- ������������� �����
                                 , MAX (tmpMIContainer.UnitId) AS UnitId

                                   -- ������������ (����������� ������)
                                 , MAX (tmpMIContainer.AssetId) AS AssetId

                                   -- ���������� (����������� ������, ����� �����)
                                 , MAX (tmpMIContainer.CarId) AS CarId

                                   -- ��������� (����������� ������, ����� �����)
                                 , MAX (tmpMIContainer.MemberId) AS MemberId

                                   -- ������ ��������
                                 , MAX (tmpMIContainer.ArticleLossId) AS ArticleLossId

                                   -- �� ����
                                 , MAX (tmpMIContainer.FromId) AS FromId
                                   -- ����
                                 , MAX (tmpMIContainer.ToId) AS ToId

                                 , MAX (tmpMIContainer.GoodsId)     AS GoodsId
                                 , MAX (tmpMIContainer.GoodsKindId) AS GoodsKindId

                            FROM tmpMIContainer
                            WHERE tmpMIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                                  , zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_Inventory()
                                                                   )
                            GROUP BY tmpMIContainer.MovementId
                                   , tmpMIContainer.MovementItemId
                           )
             -- ���������
             SELECT
                     Operation.ContainerId AS ContainerId_pl
                     --
                   , Operation.OperDate :: TDateTime
                   , Operation.MovementId
                   , Operation.MovementDescId
                   , MovementDesc.ItemName AS MovementDescName
                   , MovementDesc.Code     AS MovementDescCode

                   , MS_Comment.MovementId AS MovementId_comment

                    -- ������ ����
                   , View_ProfitLoss.ProfitLossId
                   , View_ProfitLoss.ProfitLossCode
                   , View_ProfitLoss.ProfitLossGroupName
                   , View_ProfitLoss.ProfitLossDirectionName
                   , View_ProfitLoss.ProfitLossName
                   , View_ProfitLoss.ProfitLossName_all

                     -- ������
                   , CLO_Business.ObjectId AS BusinessId

                     -- ������ ������ (Գ��)
                   , Object_Branch.Id         AS BranchId_pl
                   , Object_Branch.ObjectCode AS BranchCode_pl
                   , Object_Branch.ValueData  AS BranchName_pl

                     -- ������������� ������ (ϳ������)
                   , Object_Unit_pl.Id         AS UnitId_pl
                   , Object_Unit_pl.ObjectCode AS UnitCode_pl
                   , Object_Unit_pl.ValueData  AS UnitName_pl

                     -- ������ ��
                   , Object_InfoMoney_View.InfoMoneyId
                   , Object_InfoMoney_View.InfoMoneyGroupName
                   , Object_InfoMoney_View.InfoMoneyDestinationName
                   , Object_InfoMoney_View.InfoMoneyCode
                   , Object_InfoMoney_View.InfoMoneyName
                   , Object_InfoMoney_View.InfoMoneyName_all

                     -- ������������� �����
                   , Operation.UnitId
                     -- ������������ (����������� ������)
                   , Operation.AssetId
                     -- ���������� (����������� ������, ����� �����)
                   , Operation.CarId
                     -- ��������� (����������� ������, ����� �����)
                   , Object_Member.Id         AS MemberId
                   , Object_Member.DescId     AS MemberDescId
                   , Object_Member.ObjectCode AS MemberCode
                   , Object_Member.ValueData  AS MemberName
                     -- ������ ��������
                   , Operation.ArticleLossId

                     -- ����������� (����)
                   , Object_Direction.Id           AS DirectionId
                   , Object_Direction.ObjectCode   AS DirectionCode
                   , Object_Direction.ValueData    AS DirectionName
                     -- ���������� (����)
                   , Object_Destination.Id         AS DestinationId
                   , Object_Destination.ObjectCode AS DestinationCode
                   , Object_Destination.ValueData  AS DestinationName

                     -- �� ����
                   , Operation.FromId
                     -- ����
                   , Operation.ToId

                   , Operation.GoodsId
                   , Operation.GoodsKindId
                   , Operation.GoodsKindId_gp :: Integer

                     -- ���-�� (���)
                   ,  (Operation.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount
                     -- ��.
                   , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                THEN Operation.OperCount
                            ELSE 0
                      END) :: TFloat AS OperCount_sh

                     --
                   , Operation.OperSumm :: TFloat

             FROM
                  (-- �����
                   SELECT tmpMIContainer.ContainerId
                          --
                        , tmpMIContainer.OperDate
                        , tmpMIContainer.MovementId
                        , tmpMIContainer.MovementDescId

                        , SUM (tmpMIContainer.Amount) AS OperSumm
                        , 0                           AS OperCount

                          -- ������������ (����)
                        , tmpMIContainer.UnitId_pl

                          -- ���������� (����)
                        , tmpMIContainer.DestinationId

                          -- ����������� (����)
                        , tmpMIContainer.DirectionId

                          -- �� ������
                        , tmpMIContainer.InfoMoneyId

                          -- ������������� �����
                        , tmpMIContainer.UnitId

                          -- ������������ (����������� ������)
                        , tmpMIContainer.AssetId

                          -- ���������� (����������� ������, ����� �����)
                        , tmpMIContainer.CarId

                          -- ��������� (����������� ������, ����� �����)
                        , tmpMIContainer.MemberId

                          -- ������ ��������
                        , tmpMIContainer.ArticleLossId

                          -- �� ����
                        , tmpMIContainer.FromId
                          -- ����
                        , tmpMIContainer.ToId

                        , tmpMIContainer.GoodsId
                        , tmpMIContainer.GoodsKindId
                        , 0 AS GoodsKindId_gp

                   FROM tmpMIContainer
                   GROUP BY tmpMIContainer.ContainerId
                            --
                          , tmpMIContainer.OperDate
                          , tmpMIContainer.MovementId
                          , tmpMIContainer.MovementDescId

                            -- ������������ (����)
                          , tmpMIContainer.UnitId_pl

                            -- ���������� (����)
                          , tmpMIContainer.DestinationId

                            -- ����������� (����)
                          , tmpMIContainer.DirectionId

                            -- �� ������
                          , tmpMIContainer.InfoMoneyId

                            -- ������������� �����
                          , tmpMIContainer.UnitId

                            -- ������������ (����������� ������)
                          , tmpMIContainer.AssetId

                            -- ���������� (����������� ������, ����� �����)
                          , tmpMIContainer.CarId

                            -- ��������� (����������� ������, ����� �����)
                          , tmpMIContainer.MemberId

                            -- ������ ��������
                          , tmpMIContainer.ArticleLossId

                            -- �� ����
                          , tmpMIContainer.FromId
                            -- ����
                          , tmpMIContainer.ToId

                          , tmpMIContainer.GoodsId
                          , tmpMIContainer.GoodsKindId

                  -- ���-��
                  UNION ALL
                   SELECT tmpMIContainer.ContainerId
                          --
                        , tmpMIContainer.OperDate
                        , tmpMIContainer.MovementId
                        , tmpMIContainer.MovementDescId

                        , 0 AS OperSumm
                        , -1 * SUM (MIContainer.Amount)    AS OperCount

                          -- ������������ (����)
                        , tmpMIContainer.UnitId_pl

                          -- ���������� (����)
                        , tmpMIContainer.DestinationId

                          -- ����������� (����)
                        , tmpMIContainer.DirectionId

                          -- �� ������
                        , tmpMIContainer.InfoMoneyId

                          -- ������������� �����
                        , tmpMIContainer.UnitId

                          -- ������������ (����������� ������)
                        , tmpMIContainer.AssetId

                          -- ���������� (����������� ������, ����� �����)
                        , tmpMIContainer.CarId

                          -- ��������� (����������� ������, ����� �����)
                        , tmpMIContainer.MemberId

                          -- ������ ��������
                        , tmpMIContainer.ArticleLossId

                          -- �� ����
                        , tmpMIContainer.FromId
                          -- ����
                        , tmpMIContainer.ToId

                        , tmpMIContainer.GoodsId
                        , tmpMIContainer.GoodsKindId
                        , 0 AS GoodsKindId_gp

                   FROM tmpMI_count AS tmpMIContainer
                        INNER JOIN MovementItemContainer AS MIContainer
                                                         ON MIContainer.MovementId     = tmpMIContainer.MovementId
                                                        AND MIContainer.MovementItemId = tmpMIContainer.MovementItemId
                                                        AND MIContainer.DescId         = zc_MIContainer_Count()
                   GROUP BY tmpMIContainer.ContainerId
                            --
                          , tmpMIContainer.OperDate
                          , tmpMIContainer.MovementId
                          , tmpMIContainer.MovementDescId

                            -- ������������ (����)
                          , tmpMIContainer.UnitId_pl

                            -- ���������� (����)
                          , tmpMIContainer.DestinationId

                            -- ����������� (����)
                          , tmpMIContainer.DirectionId

                            -- �� ������
                          , tmpMIContainer.InfoMoneyId

                            -- ������������� �����
                          , tmpMIContainer.UnitId

                            -- ������������ (����������� ������)
                          , tmpMIContainer.AssetId

                            -- ���������� (����������� ������, ����� �����)
                          , tmpMIContainer.CarId

                            -- ��������� (����������� ������, ����� �����)
                          , tmpMIContainer.MemberId

                            -- ������ ��������
                          , tmpMIContainer.ArticleLossId

                            -- �� ����
                          , tmpMIContainer.FromId
                            -- ����
                          , tmpMIContainer.ToId

                          , tmpMIContainer.GoodsId
                          , tmpMIContainer.GoodsKindId

                  ) AS Operation

                  LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                ON CLO_ProfitLoss.ContainerId = Operation.ContainerId
                                               AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
                  LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.ContainerId = Operation.ContainerId
                                               AND CLO_Branch.DescId      =  zc_ContainerLinkObject_Branch()
                  LEFT JOIN ContainerLinkObject AS CLO_Business
                                                ON CLO_Business.ContainerId = Operation.ContainerId
                                               AND CLO_Business.DescId      =  zc_ContainerLinkObject_Business()

                  -- ������
                  LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                       ON ObjectLink_Personal_Member.ObjectId = Operation.MemberId
                                      AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                  -- Goods_InfoMoney
                  /*LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Operation.GoodsId
                                      AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()*/

                  -- �������� INNER
                  INNER JOIN Object_ProfitLoss_View AS View_ProfitLoss        ON View_ProfitLoss.ProfitLossId     = CLO_ProfitLoss.ObjectId
                  
                  -- ��-��
                  LEFT JOIN Object                 AS Object_Branch          ON Object_Branch.Id                  = CLO_Branch.ObjectId

                  LEFT JOIN Object                 AS Object_Direction        ON Object_Direction.Id              = Operation.DirectionId
                  LEFT JOIN Object                 AS Object_Destination      ON Object_Destination.Id            = Operation.DestinationId

                  LEFT JOIN Object                 AS Object_Unit_pl         ON Object_Unit_pl.Id                 = Operation.UnitId_pl
                  LEFT JOIN Object_InfoMoney_View  AS Object_InfoMoney_View  ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
                  LEFT JOIN Object                 AS Object_Member          ON Object_Member.Id                  = COALESCE (ObjectLink_Personal_Member.ChildObjectId, Operation.MemberId)

                  LEFT JOIN Object                 AS Object_Goods           ON Object_Goods.Id                   = Operation.GoodsId
                  LEFT JOIN Object                 AS Object_GoodsKind       ON Object_GoodsKind.Id               = Operation.GoodsKindId

                  -- ��.���. ������
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                       ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                  -- ��� ������
                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                        ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                       AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                  LEFT JOIN MovementString AS MS_Comment
                                           ON MS_Comment.MovementId = Operation.MovementId
                                          AND MS_Comment.DescId     = zc_MovementString_Comment()
                                          AND MS_Comment.ValueData  <> ''

                  LEFT JOIN MovementDesc ON MovementDesc.Id = Operation.MovementDescId

-- where (COALESCE (Object_Direction.ValueData, '') not ilike '���������%'
--   AND COALESCE (Object_Destination.ValueData, '') not ilike '���������%'
--   AND COALESCE (Object_Member.ValueData, '') not ilike '���������%'
--   ) or inUserId = 0
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.09.25                                        *
*/

-- ����
-- where DirectionName ilike '���������%' or DestinationName ilike '���������%' or MemberName ilike  '���������%'
-- SELECT sum (OperCount) as OperCount, sum (OperSumm) as OperSumm, ProfitLossName_all FROM lpReport_bi_ProfitLoss (inStartDate:= '01.09.2025', inEndDate:= '01.09.2025', inUserId:= zfCalc_UserAdmin() :: Integer) group by ProfitLossName_all ORDER BY ProfitLossName_all

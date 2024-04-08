 -- Function: gpReport_GoodsMI_SendOnPrice ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SendOnPrice (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_SendOnPrice (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_SendOnPrice (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SendOnPrice (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inFromId            Integer   ,
    IN inToId              Integer   ,
    IN inGoodsGroupId      Integer   ,
    IN inIsTradeMark       Boolean   , --
    IN inIsGoods           Boolean   , --
    IN inIsGoodsKind       Boolean   , --
    IN inIsMovement        Boolean   , --
    In inIsSubjectDoc      Boolean   , --
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , FromCode Integer, FromName TVarChar
             , ToCode Integer, ToName TVarChar
             , SubjectDocName TVarChar

             , OperCount_total          TFloat  -- ��� ����� (����: � �������� � �������)
             , OperCount_real           TFloat  -- ��� �����
             , OperCount_110000_A       TFloat  -- ��� ����� ������� ������
             , OperCount_110000_P       TFloat  -- ��� ����� ������� ������
             , OperCount                TFloat  -- *��� ����� (�� ���� ����������, �.�. ������������)

             , OperCount_Change          TFloat  -- *��� ������ �� ��� (�� ���� ������, �.�. ������������)
             , OperCount_Change_110000_A TFloat  -- *��� ������ �� ��� ������� ������ (�� ���� ������, �.�. ������������)
             , OperCount_Change_110000_P TFloat  -- *��� ������ �� ��� ������� ������ (�� ���� ������, �.�. ������������)
             , OperCount_Change_real     TFloat  -- ��� ������ �� ��� (�� ���� ����������, �.�. ����)

             , OperCount_40200          TFloat  -- *��� ������� � ���� (�� ���� ������, �.�. ������������)
             , OperCount_40200_110000_A TFloat  -- *��� ������� � ���� ������� ������ (�� ���� ������, �.�. ������������)
             , OperCount_40200_110000_P TFloat  -- *��� ������� � ���� ������� ������ (�� ���� ������, �.�. ������������)
             , OperCount_40200_real     TFloat  -- ��� ������� � ���� (�� ���� ����������, �.�. ����)

             , OperCount_Loss           TFloat  -- !!!���-��!!! ��������
             , SummIn_Loss              TFloat  -- ���������� (��� ������������� ������ ����� ���������)
             , SummIn_Loss_zavod        TFloat  -- � ���������� �������� ���������

             , OperCount_Partner          TFloat  -- *��� ���������� (�� ���� ������, �.�. ������������)
             , OperCount_Partner_110000_A TFloat  -- *��� ���������� ������� ������ (�� ���� ������, �.�. ������������)
             , OperCount_Partner_110000_P TFloat  -- *��� ���������� ������� ������ (�� ���� ������, �.�. ������������)
             , OperCount_Partner_real     TFloat  -- ��� ���������� (�� ���� ����������, �.�. ����)
             , OperCount_sh_Partner_real  TFloat  -- ��. ���������� (�� ���� ����������, �.�. ����)

             , SummIn_zavod_total           TFloat  -- ����� (����: � �������� � �������) ������������� � ���������
             , SummIn_zavod_real            TFloat  -- ����� ������������� � ���������
             , SummIn_110000_A              TFloat  -- ����� ������������� ������� ������ (���������� + ���������)
             , SummIn_110000_P              TFloat  -- ����� ������������� ������� ������ (���������� + ���������)
             , SummIn_zavod                 TFloat  -- *����� ������������� � ��������� + (�� ���� ����������, �.�. ������������)

             , SummIn_Change_zavod          TFloat  -- *������ �� ��� ������������� ��������� + (�� ���� ������, �.�. ������������)
             , SummIn_Change_110000_A       TFloat  -- *������ �� ��� ����� ������������� ������� ������ (���������� + ���������) + (�� ���� ������, �.�. ������������)
             , SummIn_Change_110000_P       TFloat  -- *������ �� ��� ����� ������������� ������� ������ (���������� + ���������) + (�� ���� ������, �.�. ������������)
             , SummIn_Change_zavod_real     TFloat  -- ������ �� ��� ������������� ��������� + (�� ���� ����������, �.�. ����)

             , SummIn_40200_zavod           TFloat  -- *������� � ���� ������������� ��������� + (�� ���� ������, �.�. ������������)
             , SummIn_40200_110000_A        TFloat  -- *������� � ���� ����� ������������� ������� ������ (���������� + ���������) + (�� ���� ������, �.�. ������������)
             , SummIn_40200_110000_P        TFloat  -- *������� � ���� ����� ������������� ������� ������ (���������� + ���������) + (�� ���� ������, �.�. ������������)
             , SummIn_40200_zavod_real      TFloat  -- ������� � ���� ������������� ��������� + (�� ���� ����������, �.�. ����)

             , SummIn_Partner_zavod         TFloat  -- *���������� ������������� ��������� + (�� ���� ������, �.�. ������������)
             , SummIn_Partner_110000_A      TFloat  -- *���������� ������������� ������� ������ (���������� + ���������) + (�� ���� ������, �.�. ������������)
             , SummIn_Partner_110000_P      TFloat  -- *���������� ������������� ������� ������ (���������� + ���������) + (�� ���� ������, �.�. ������������)
             , SummIn_Partner_zavod_real    TFloat  -- ���������� ������������� ��������� + (�� ���� ����������, �.�. ����)

             , SummOut_Partner              TFloat  -- *���������� ����� (�� ���� ������, �.�. ������������)
             , SummOut_Partner_110000_A     TFloat  -- *���������� ����� ������� ������ (�� ���� ������, �.�. ������������)
             , SummOut_Partner_110000_P     TFloat  -- *���������� ����� ������� ������ (�� ���� ������, �.�. ������������)
             , SummOut_Partner_real         TFloat  -- ���������� ����� (�� ���� ����������, �.�. ����)

             , Summ_pl                      TFloat
             , Summ_pl_real                 TFloat

             , PriceIn_zavod                TFloat  --
             , PriceOut_Partner             TFloat  --
             
             , WeightTotal                  TFloat -- ��� � �������� - GoodsByGoodsKind

             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
 
     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- ������� -
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;
     END IF;*/


    -- ���������
    RETURN QUERY

     WITH -- ����������� �� ������
          _tmpGoods AS -- (GoodsId, InfoMoneyId, TradeMarkId, MeasureId, Weight)
          (SELECT lfSelect.GoodsId, COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, 0) AS InfoMoneyId, COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) AS TradeMarkId
                , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                , ObjectFloat_Weight.ValueData           AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = lfSelect.GoodsId
                                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfSelect.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0
        UNION ALL
           SELECT Object.Id, COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, 0) AS InfoMoneyId, COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) AS TradeMarkId
                , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                , ObjectFloat_Weight.ValueData           AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = Object.Id
                                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = Object.Id
                                    AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0
          )

        -- ������ ������������� ��� �������������
      , tmpFrom AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect WHERE inFromId > 0
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit() AND inFromId = 0 -- AND vbIsGroup = TRUE
                    UNION
                     SELECT tmp.UnitId FROM (SELECT 8459 AS UnitId -- ����� ����������
                                            UNION
                                             SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect_Object_Unit_byGroup -- �������� �����
                                            ) AS tmp
                     WHERE inFromId = -123
                    )
         , tmpTo AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect WHERE inToId > 0
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit() AND inToId = 0
                    UNION
                     SELECT tmp.UnitId FROM (SELECT 8459 AS UnitId -- ����� ����������
                                            UNION
                                             SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect_Object_Unit_byGroup -- �������� �����
                                            ) AS tmp
                     WHERE inToId = -123
                   )
    ,  _tmpUnit AS (SELECT tmpFrom.UnitId, COALESCE (tmpTo.UnitId, 0) AS UnitId_by, FALSE AS isActive FROM tmpFrom LEFT JOIN tmpTo ON tmpTo.UnitId > 0
               --  UNION
               --   SELECT tmpTo.UnitId, COALESCE (tmpFrom.UnitId, 0) AS UnitId_by, TRUE AS isActive FROM tmpTo LEFT JOIN tmpFrom ON tmpFrom.UnitId > 0
                )

        , tmpAccount AS (SELECT Object_Account_View.AccountGroupId, Object_Account_View.AccountId
                         FROM Object_Account_View
                         WHERE Object_Account_View.AccountGroupId IN (zc_Enum_AccountGroup_110000() -- �������
                                                                     )
                        /*UNION
                         SELECT 0 AS AccountGroupId, zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId -- �����, �� ������ ������������ ����, ������ ����. ���. ��������, ���� ���� ������� � AccountId, ��� ���� ContainerId - ����������� � � ��� ������ AccountId
                        UNION
                         SELECT 0 AS AccountGroupId, zc_Enum_AnalyzerId_SummOut_110101() AS AccountId -- �����, �� ������ ������������ ����, ������ ����. ���. ��������, ���� ���� ������� � AccountId, ��� ���� ContainerId - ����������� � � ��� ������ AccountId
                        */
                        )
    , tmpUnit_from AS (SELECT DISTINCT _tmpUnit.UnitId FROM _tmpUnit)
    , tmpMovement_pl AS (SELECT Movement.Id, Movement.OperDate, MovementDate_OperDatePartner.ValueData AS OperDatePartner
                              , MovementLinkObject_From.ObjectId       AS FromId
                              , MovementLinkObject_To.ObjectId         AS ToId
                              , Object_SubjectDoc.ValueData            AS SubjectDocName
                         FROM Movement
                              LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                     ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                    AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN tmpUnit_from AS _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_From.ObjectId
                                                                 -- AND _tmpUnit.UnitId_by = MovementLinkObject_To.ObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                           ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                                          AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                              LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_SendOnPrice()
                        UNION
                         SELECT Movement.Id, Movement.OperDate, MovementDate_OperDatePartner.ValueData AS OperDatePartner
                              , MovementLinkObject_From.ObjectId       AS FromId
                              , MovementLinkObject_To.ObjectId         AS ToId
                              , Object_SubjectDoc.ValueData            AS SubjectDocName
                         FROM MovementDate AS MovementDate_OperDatePartner
                              INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                 AND Movement.DescId = zc_Movement_SendOnPrice()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN tmpUnit_from AS _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_From.ObjectId
                                                                 -- AND _tmpUnit.UnitId_by = MovementLinkObject_To.ObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                           ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                                          AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                              LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

                         WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                           AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                        )
       -- ���������
       SELECT Movement.InvNumber
         , Movement.OperDate
         , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
         , Object_GoodsGroup.Id                       AS GoodsGroupId
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , Object_TradeMark.ValueData                 AS TradeMarkName

         , Object_From.ObjectCode AS FromCode
         , Object_From.ValueData  AS FromName

         , Object_To.ObjectCode AS ToCode
         , Object_To.ValueData  AS ToName

         , tmpOperationGroup.SubjectDocName :: TVarChar
           -- 1.1. ���, ��� AnalyzerId, �.�. ��� �� ������, �� �������, � ��������
         , (tmpOperationGroup.OperCount_real) :: TFloat AS OperCount_total
         , ((tmpOperationGroup.OperCount_real     - tmpOperationGroup.OperCount_Change          + tmpOperationGroup.OperCount_40200          * 1)) :: TFloat AS OperCount_real
         , ((tmpOperationGroup.OperCount_110000_A - tmpOperationGroup.OperCount_Change_110000_A + tmpOperationGroup.OperCount_40200_110000_A * 1)) :: TFloat AS OperCount_110000_A
         , ((tmpOperationGroup.OperCount_110000_P - tmpOperationGroup.OperCount_Change_110000_P + tmpOperationGroup.OperCount_40200_110000_P * 1)) :: TFloat AS OperCount_110000_P
         , ((tmpOperationGroup.OperCount          - tmpOperationGroup.OperCount_Change_real     + tmpOperationGroup.OperCount_40200_real     * 1)) :: TFloat AS OperCount

           -- 2.1. ��� - ������ �� ���
         , (tmpOperationGroup.OperCount_Change)          :: TFloat AS OperCount_Change
         , (tmpOperationGroup.OperCount_Change_110000_A) :: TFloat AS OperCount_Change_110000_A
         , (tmpOperationGroup.OperCount_Change_110000_P) :: TFloat AS OperCount_Change_110000_P
         , (tmpOperationGroup.OperCount_Change_real)     :: TFloat AS OperCount_Change_real

           -- 3.1. ���-�� ������� � ����
         , (tmpOperationGroup.OperCount_40200)          :: TFloat AS OperCount_40200
         , (tmpOperationGroup.OperCount_40200_110000_A) :: TFloat AS OperCount_40200_110000_A
         , (tmpOperationGroup.OperCount_40200_110000_P) :: TFloat AS OperCount_40200_110000_P
         , (tmpOperationGroup.OperCount_40200_real)     :: TFloat AS OperCount_40200_real

           -- 4.1. ���-�� ��������
         , tmpOperationGroup.OperCount_Loss :: TFloat AS OperCount_Loss
           -- 4.2. ������������� - ��������
         , tmpOperationGroup.SummIn_Loss                                          :: TFloat AS SummIn_Loss        -- ���������� (��� ������������� ������ ����� ���������)
         , (tmpOperationGroup.SummIn_Loss + tmpOperationGroup.SummIn_Loss_60000)  :: TFloat AS SummIn_Loss_zavod  -- � ���������� �������� ���������

           -- 5.1. ���-�� � ����������
         , (tmpOperationGroup.OperCount_Partner)          :: TFloat AS OperCount_Partner
         , (tmpOperationGroup.OperCount_Partner_110000_A) :: TFloat AS OperCount_Partner_110000_A
         , (tmpOperationGroup.OperCount_Partner_110000_P) :: TFloat AS OperCount_Partner_110000_P
         , (tmpOperationGroup.OperCount_Partner_real)     :: TFloat AS OperCount_Partner_real
         , tmpOperationGroup.OperCount_sh_Partner_real    :: TFloat AS OperCount_sh_Partner_real

           -- 1.2. �������������, ��� AnalyzerId, �.�. ���������� + ��������� � ��� �� ������, �� �������, � �������� (!!!� �������� ���������� ���!!!)
         , (tmpOperationGroup.SummIn_real)     :: TFloat AS SummIn_zavod_total   -- ����� (����: � �������� � �������) ������������� � ���������

         , (tmpOperationGroup.SummIn_real  - tmpOperationGroup.SummIn_Change + tmpOperationGroup.SummIn_40200 * 1) :: TFloat AS SummIn_zavod_real  -- � ���������� �������� ���������

         , (tmpOperationGroup.SummIn_110000_A) :: TFloat AS SummIn_110000_A -- ����� ��� ���������� + ���������
         , (tmpOperationGroup.SummIn_110000_P) :: TFloat AS SummIn_110000_P -- ����� ��� ���������� + ���������
         , (tmpOperationGroup.SummIn)          :: TFloat AS SummIn_zavod    -- � ���������� �������� ���������

           -- 2.2. ������������� - ������ �� ���
         , (tmpOperationGroup.SummIn_Change)          :: TFloat AS SummIn_Change_zavod   -- ���������� (��� ������������� ������ ����� ���������)
         , tmpOperationGroup.SummIn_Change_110000_A   :: TFloat AS SummIn_Change_110000_A -- ����� ��� ���������� + ���������
         , tmpOperationGroup.SummIn_Change_110000_P   :: TFloat AS SummIn_Change_110000_P -- ����� ��� ���������� + ���������
         , (tmpOperationGroup.SummIn_Change_real)     :: TFloat AS SummIn_Change_zavod_real   -- ���������� (��� ������������� ������ ����� ���������)

           -- 3.2. ������������� - ������� � ����
         , (tmpOperationGroup.SummIn_40200 )          :: TFloat AS SummIn_40200_zavod   -- ���������� (��� ������������� ������ ����� ���������)
         , tmpOperationGroup.SummIn_40200_110000_A    :: TFloat AS SummIn_40200_110000_A -- ����� ��� ���������� + ���������
         , tmpOperationGroup.SummIn_40200_110000_P    :: TFloat AS SummIn_40200_110000_P -- ����� ��� ���������� + ���������
         , (tmpOperationGroup.SummIn_40200_real)      :: TFloat AS SummIn_40200_zavod_real   -- ���������� (��� ������������� ������ ����� ���������)

           -- 5.2. ������������� � ����������
         , (tmpOperationGroup.SummIn_Partner)         :: TFloat AS SummIn_Partner_zavod    -- � ���������� �������� ���������
         , (tmpOperationGroup.SummIn_Partner_110000_A):: TFloat AS SummIn_Partner_110000_A -- ����� ��� ���������� + ���������
         , (tmpOperationGroup.SummIn_Partner_110000_P):: TFloat AS SummIn_Partner_110000_P -- ����� ��� ���������� + ���������
         , (tmpOperationGroup.SummIn_Partner_real)    :: TFloat AS SummIn_Partner_zavod_real    -- � ���������� �������� ���������

           -- 5.3. ����� � ����������
         , (tmpOperationGroup.SummIn_Partner + tmpOperationGroup.SummOut_Partner_real + tmpOperationGroup.SummOut_Partner_110000_A - tmpOperationGroup.SummOut_Partner_110000_P) :: TFloat AS SummOut_Partner
         , (tmpOperationGroup.SummIn_Partner_110000_A + tmpOperationGroup.SummOut_Partner_110000_A) :: TFloat AS SummOut_Partner_110000_A
         , (tmpOperationGroup.SummIn_Partner_110000_P + tmpOperationGroup.SummOut_Partner_110000_P) :: TFloat AS SummOut_Partner_110000_P
         , (tmpOperationGroup.SummIn_Partner_real     + tmpOperationGroup.SummOut_Partner_real)     :: TFloat AS SummOut_Partner_real

         , tmpOperationGroup.Summ_pl      :: TFloat AS Summ_pl
         , tmpOperationGroup.Summ_pl_real :: TFloat AS Summ_pl_real

           -- ���� �/�
         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN  tmpOperationGroup.SummIn_Partner_real                                           / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS PriceIn_zavod

           -- ���� ����������
         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN tmpOperationGroup.SummOut_Partner_real   / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS PriceOut_Partner

           -- ��� � �������� - GoodsByGoodsKind
         , ObjectFloat_WeightTotal.ValueData   :: TFloat  AS WeightTotal

         , View_InfoMoney_Goods.InfoMoneyGroupName              AS InfoMoneyGroupName_goods
         , View_InfoMoney_Goods.InfoMoneyDestinationName        AS InfoMoneyDestinationName_goods
         , View_InfoMoney_Goods.InfoMoneyCode                   AS InfoMoneyCode_goods
         , View_InfoMoney_Goods.InfoMoneyName                   AS InfoMoneyName_goods

     FROM (SELECT tmpContainer.MovementId
                , tmpContainer.FromId
                , tmpContainer.ToId
                , STRING_AGG (DISTINCT tmpContainer.SubjectDocName, '; ')  :: TVarChar  AS SubjectDocName
                , CASE WHEN inIsGoods = TRUE THEN tmpContainer.GoodsId ELSE 0 END AS GoodsId
                , tmpContainer.GoodsKindId
                , _tmpGoods.InfoMoneyId AS InfoMoneyId_goods
                , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN _tmpGoods.TradeMarkId ELSE 0 END AS TradeMarkId

                  -- 1.1. ���-��, ��� AnalyzerId
                , SUM (tmpContainer.OperCount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.OperCount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.OperCount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_110000_P
                  -- 1.2. �������������, ��� AnalyzerId
                , SUM (tmpContainer.SummIn) AS SummIn
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.SummIn ELSE 0 END) AS SummIn_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.SummIn ELSE 0 END) AS SummIn_110000_P

                  -- 1.3. �����, ��� AnalyzerId (�� ����� ���� ��� OperCount_Partner)
                , SUM (tmpContainer.SummOut_Partner_60000) AS SummOut_Partner_real
                , SUM (CASE WHEN /*tmpAccount.AccountGroupId >= 0*/ tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.SummOut_Partner_60000 ELSE 0 END) AS SummOut_Partner_110000_A
                , SUM (CASE WHEN /*tmpAccount.AccountGroupId >= 0*/ tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.SummOut_Partner_60000 ELSE 0 END) AS SummOut_Partner_110000_P

                  -- 2.1. ���-�� - ������ �� ���
                , SUM (tmpContainer.OperCount_Change * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount_Change_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount_Change * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.OperCount_Change * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.OperCount_Change * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Change_110000_P
                  -- 2.2. ������������� - ������ �� ���
                , SUM (tmpContainer.SummIn_Change) AS SummIn_Change_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change_110000_P

                  -- 3.1. ���-�� ������� � ����
                , SUM (tmpContainer.OperCount_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount_40200_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_40200
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.OperCount_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_40200_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.OperCount_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_40200_110000_P
                  -- 3.2. ������������� - ������� � ����
                , SUM (tmpContainer.SummIn_40200) AS SummIn_40200_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200_110000_P

                  -- 4.1. ���-�� ��������
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_Loss * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Loss
                  -- 4.2. ������������� - ��������
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Loss ELSE 0 END) AS SummIn_Loss
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Loss ELSE 0 END) AS SummIn_Loss_60000

                  -- 5.1. ���-�� � ����������
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.OperCount_Partner ELSE 0 END)                    AS OperCount_sh_Partner_real
                , SUM (tmpContainer.OperCount_Partner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount_Partner_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount_Partner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.OperCount_Partner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.OperCount_Partner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Partner_110000_P
                  -- 5.2. ������������� � ����������
                , SUM (tmpContainer.SummIn_Partner) AS SummIn_Partner_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN -1 * tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN  1 * tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_110000_P

                , SUM (tmpContainer.Summ_pl) AS Summ_pl
                , SUM (tmpContainer.Summ_pl_real) AS Summ_pl_real

           FROM (SELECT CASE WHEN inIsMovement = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                      , MIContainer.WhereObjectId_analyzer            AS FromId
                      , MIContainer.ObjectExtId_Analyzer              AS ToId
                      , Object_SubjectDoc.ValueData AS SubjectDocName
                      , MIContainer.ObjectId_analyzer                 AS GoodsId
                      , CASE WHEN inIsGoodsKind    = TRUE THEN MIContainer.ObjectIntId_analyzer ELSE 0 END AS GoodsKindId
                      , MIContainer.ContainerId_analyzer
                      , MIContainer.ContainerIntId_analyzer
                      , MIContainer.isActive
                      , CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SummIn_110101(), zc_Enum_AnalyzerId_SummOut_110101()) THEN MIContainer.AnalyzerId ELSE COALESCE (MIContainer.AccountId, 0) END AS AccountId

                        -- 1.1. ���-��, ��� AnalyzerId
                      , SUM (CASE WHEN MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossCount_20200() AND MIContainer.DescId = zc_MIContainer_Count()
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount
                        -- 1.2. �������������, ��� AnalyzerId
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()
                                   AND MIContainer.AnalyzerId NOT IN (zc_Enum_AnalyzerId_SummOut_80401(), zc_Enum_AnalyzerId_SummIn_80401(), zc_Enum_AnalyzerId_LossSumm_20200())
                                   AND MIContainer.AccountId NOT IN (zc_Enum_AnalyzerId_SummOut_80401(), zc_Enum_AnalyzerId_SummIn_80401())
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn
                        -- 1.3. �����***, ��� AnalyzerId (�� ����� ���� ��� OperCount_Partner)
                      , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SummOut_80401(), zc_Enum_AnalyzerId_SummOut_110101())
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummOut_Partner_60000

                        -- 2.1. ���-�� - ������ �� ���
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendCount_10500()
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Change
                        -- 2.2. ������������� - ������ �� ���
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_10500()
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Change

                        -- 3.1. ���-�� ������� � ����
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendCount_40200()
                                       THEN 1 * MIContainer.Amount -- !!! �� �������� ����, �.�. ���� �������� +/-!!!
                                  ELSE 0
                             END) AS OperCount_40200
                        -- 3.2. ������������� - ������� � ����
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_40200()
                                       THEN 1 * MIContainer.Amount -- !!! �� �������� ����, �.�. ���� �������� +/-!!!
                                  ELSE 0
                             END) AS SummIn_40200

                        -- 4.1. ���-�� ��������
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() THEN -1 * MIContainer.Amount ELSE 0 END) AS OperCount_Loss
                        -- 4.2. ������������� - ��������
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200()  THEN -1 * MIContainer.Amount ELSE 0 END) AS SummIn_Loss

                        -- 5.1. ���-�� � ����������
                      , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SendCount_in(), zc_Enum_AnalyzerId_LossCount_10900())
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Partner
                        -- 5.2. ������������� � ����������
                      , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SendSumm_in(), zc_Enum_AnalyzerId_LossSumm_10900())
                                       THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Partner

                      , 0 AS Summ_pl
                      , 0 AS Summ_pl_real

                 FROM _tmpUnit
                      INNER JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                      AND MIContainer.WhereObjectId_analyzer = _tmpUnit.UnitId
                                                      AND MIContainer.ObjectExtId_Analyzer   = _tmpUnit.UnitId_by
                                                      AND (MIContainer.isActive = FALSE
                                                        OR (MIContainer.isActive = TRUE AND MIContainer.AccountId IN (zc_Enum_Account_110101(), zc_Enum_Account_110102()
                                                                                                                    , zc_Enum_Account_110111(), zc_Enum_Account_110112()
                                                                                                                    , zc_Enum_Account_110121(), zc_Enum_Account_110122()
                                                                                                                    , zc_Enum_Account_110131(), zc_Enum_Account_110132()

                                                                                                                    , zc_Enum_Account_110151(), zc_Enum_Account_110152(), zc_Enum_Account_110153()
                                                                                                                    , zc_Enum_Account_110161(), zc_Enum_Account_110162()
                                                                                                                    , zc_Enum_Account_110171(), zc_Enum_Account_110172(), zc_Enum_Account_110173()
                                                                                                                    , zc_Enum_Account_110181(), zc_Enum_Account_110182()
                                                                                                                     ))
                                                        OR MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SummOut_80401(), zc_Enum_AnalyzerId_SummOut_110101())
                                                          )
                                                      AND COALESCE (MIContainer.AccountId, 0) <>  zc_Enum_Account_100301() -- ������� �������� �������
                                                      

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                   ON MovementLinkObject_SubjectDoc.MovementId = MIContainer.MovementId
                                                  AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                      LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

                 GROUP BY CASE WHEN inIsMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                        , MIContainer.WhereObjectId_analyzer
                        , MIContainer.ObjectExtId_Analyzer
                        , MIContainer.ObjectId_analyzer
                        , CASE WHEN inIsGoodsKind    = TRUE THEN MIContainer.ObjectIntId_analyzer ELSE 0 END
                        , MIContainer.ContainerId_analyzer
                        , MIContainer.ContainerIntId_analyzer
                        , CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SummIn_110101(), zc_Enum_AnalyzerId_SummOut_110101()) THEN MIContainer.AnalyzerId ELSE COALESCE (MIContainer.AccountId, 0) END
                        , MIContainer.isActive
                        , Object_SubjectDoc.ValueData
                UNION ALL
                 SELECT tmp.*
                 FROM
                (SELECT CASE WHEN inIsMovement = TRUE THEN tmpMovement_pl.Id ELSE 0 END AS MovementId
                      , tmpMovement_pl.FromId
                      , COALESCE (MILinkObject_Unit.ObjectId, tmpMovement_pl.ToId) AS ToId
                      , tmpMovement_pl.SubjectDocName           AS SubjectDocName
                      , MovementItem.ObjectId                                      AS GoodsId
                      , CASE WHEN inIsGoodsKind = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END AS GoodsKindId
                      , 0     AS ContainerId_analyzer
                      , 0     AS ContainerIntId_analyzer
                      , FALSE AS isActive
                      , 0     AS AccountId

                      , 0 AS OperCount
                      , 0 AS SummIn
                      , 0 AS SummOut_Partner_60000

                      , 0 AS OperCount_Change
                      , 0 AS SummIn_Change

                      , 0 AS OperCount_40200
                      , 0 AS SummIn_40200

                      , 0 AS OperCount_Loss
                      , 0 AS SummIn_Loss

                      , 0 AS OperCount_Partner
                      , 0 AS SummIn_Partner

                      , SUM (CASE WHEN tmpMovement_pl.OperDate BETWEEN inStartDate AND inEndDate THEN COALESCE (MIFloat_SummPriceList.ValueData, 0)  ELSE 0 END) AS Summ_pl
                      , SUM (CASE WHEN tmpMovement_pl.OperDatePartner BETWEEN inStartDate AND inEndDate THEN COALESCE (MIFloat_SummPriceList.ValueData, 0)  ELSE 0 END) AS Summ_pl_real

                 FROM tmpMovement_pl
                      INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_pl.Id
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = FALSE
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                       ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemFloat AS MIFloat_SummPriceList
                                                  ON MIFloat_SummPriceList.MovementItemId = MovementItem.Id
                                                 AND MIFloat_SummPriceList.DescId = zc_MIFloat_SummPriceList()

                      INNER JOIN _tmpUnit ON _tmpUnit.UnitId    = tmpMovement_pl.FromId -- tmp.FromId
                                         AND _tmpUnit.UnitId_by = COALESCE (MILinkObject_Unit.ObjectId, tmpMovement_pl.ToId) -- tmp.ToId

                 GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMovement_pl.Id ELSE 0 END
                        , tmpMovement_pl.FromId
                        , COALESCE (MILinkObject_Unit.ObjectId, tmpMovement_pl.ToId)
                        , MovementItem.ObjectId
                        , CASE WHEN inIsGoodsKind = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END
                        , tmpMovement_pl.SubjectDocName
                ) AS tmp

                  ) AS tmpContainer
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpContainer.GoodsId

                      LEFT JOIN tmpAccount ON tmpAccount.AccountId = tmpContainer.AccountId

                      GROUP BY tmpContainer.MovementId
                             , tmpContainer.FromId
                             , tmpContainer.ToId
                             , CASE WHEN inIsGoods = TRUE THEN tmpContainer.GoodsId ELSE 0 END
                             , tmpContainer.GoodsKindId
                             , _tmpGoods.InfoMoneyId
                             , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN _tmpGoods.TradeMarkId ELSE 0 END
                             , CASE WHEN inIsSubjectDoc = TRUE THEN tmpContainer.SubjectDocName ELSE '' END

                    ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpOperationGroup.FromId
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpOperationGroup.ToId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpOperationGroup.TradeMarkId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Goods ON View_InfoMoney_Goods.InfoMoneyId = tmpOperationGroup.InfoMoneyId_goods

          LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  tmpOperationGroup.MovementId
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

          -- ����� � ��� ������
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpOperationGroup.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpOperationGroup.GoodsKindId
          -- ��� � ��������: "������" ��� + ��� 1-��� ������
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.gjghj,eq
 31.01.16                                        *
*/

-- ����
-- SELECT * FROM gpReport_GoodsMI_SendOnPrice (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inFromId:= 8459, inToId:= 0, inGoodsGroupId:= 0, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inIsMovement:= FALSE, inSession:= zfCalc_UserAdmin()); -- ����� ����������
-- select * from gpReport_GoodsMI_SendOnPrice (inStartDate := ('13.02.2020')::TDateTime , inEndDate := ('13.02.2020')::TDateTime , inFromId := 8411 , inToId := 0 , inGoodsGroupId := 0 , inIsTradeMark := 'False' , inIsGoods := 'False' , inIsGoodsKind := 'False' , inIsMovement := 'False' , inIsSubjectDoc:= 'False',  inSession := '5');

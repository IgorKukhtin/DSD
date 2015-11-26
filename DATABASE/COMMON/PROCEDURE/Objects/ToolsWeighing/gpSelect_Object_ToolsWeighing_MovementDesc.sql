-- Function: gpSelect_Object_ToolsWeighing_MovementDesc()

-- DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_MovementDesc (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_MovementDesc (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_MovementDesc(
    IN inIsCeh       Boolean   , --
    IN inBranchCode  Integer   , --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Number             Integer
             , MovementDescId     Integer
             , FromId             Integer, FromCode         Integer, FromName      TVarChar
             , ToId               Integer, ToCode           Integer, ToName        TVarChar
             , PaidKindId         Integer, PaidKindName     TVarChar
             , InfoMoneyId        Integer, InfoMoneyCode    Integer, InfoMoneyName TVarChar
             , PriceListId        Integer, PriceListCode    Integer, PriceListName TVarChar
             , GoodsKindWeighingGroupId Integer
             , ColorGridValue     Integer
             , MovementDescName        TVarChar
             , MovementDescName_master TVarChar
             , OrderById          Integer
             , isSendOnPriceIn    Boolean
             , isPartionGoodsDate Boolean
             , isTransport_link   Boolean
               )
AS
$BODY$
   DECLARE vbUserId     Integer;

   DECLARE vbLevelMain  TVarChar;
   DECLARE vbCount      Integer;
   DECLARE vbBranchId   Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


    -- !!!����� ����� - ������������ ������� �����!!!
    vbLevelMain:= CASE WHEN inIsCeh = TRUE THEN 'ScaleCeh_' || inBranchCode ELSE 'Scale_' || inBranchCode END;


    -- ������������ ���-�� ��������
    vbCount:= (SELECT gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', '', 'Count', '10', inSession));
    -- ������������
    vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                      ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                 END;


    -- ��������� �������
    CREATE TEMP TABLE _tmpToolsWeighing (Number                   Integer
                                       , MovementDescId           Integer
                                       , FromId                   Integer
                                       , ToId                     Integer
                                       , PaidKindId               Integer
                                       , InfoMoneyId              Integer
                                       , GoodsKindWeighingGroupId Integer
                                       , ColorGridValue           Integer
                                       , OrderById                Integer
                                       , isSendOnPriceIn          Boolean
                                       , isPartionGoodsDate       Boolean
                                       , isTransport_link         Boolean
                                       , ItemName                 TVarChar
                                        ) ON COMMIT DROP;
    -- ������������
    INSERT INTO _tmpToolsWeighing (Number, MovementDescId, FromId, ToId, PaidKindId, InfoMoneyId, GoodsKindWeighingGroupId, ColorGridValue, OrderById, isSendOnPriceIn, isPartionGoodsDate, isTransport_link, ItemName)
       SELECT tmp.Number
            , CASE WHEN TRIM (tmp.MovementDescId)           <> '' THEN TRIM (tmp.MovementDescId)           ELSE '0' END :: Integer AS MovementDescId
            , CASE WHEN TRIM (tmp.FromId)                   <> '' THEN TRIM (tmp.FromId)                   ELSE '0' END :: Integer AS FromId
            , CASE WHEN TRIM (tmp.ToId)                     <> '' THEN TRIM (tmp.ToId)                     ELSE '0' END :: Integer AS ToId
            , CASE WHEN TRIM (tmp.PaidKindId)               <> '' THEN TRIM (tmp.PaidKindId)               ELSE '0' END :: Integer AS PaidKindId
            , CASE WHEN TRIM (tmp.InfoMoneyId)              <> '' THEN TRIM (tmp.InfoMoneyId)              ELSE '0' END :: Integer AS InfoMoneyId
            , CASE WHEN TRIM (tmp.GoodsKindWeighingGroupId) <> '' THEN TRIM (tmp.GoodsKindWeighingGroupId) ELSE '0' END :: Integer AS GoodsKindWeighingGroupId
            , CASE WHEN TRIM (tmp.ColorGridValue)           <> '' THEN TRIM (tmp.ColorGridValue)           ELSE '0' END :: Integer AS ColorGridValue
            , CASE WHEN tmp.MovementDescId = zc_Movement_Income() :: TVarChar
                        THEN 1
                   WHEN tmp.MovementDescId = zc_Movement_ReturnOut() :: TVarChar
                        THEN 2
                   WHEN tmp.MovementDescId = zc_Movement_Sale() :: TVarChar
                        THEN 3
                   WHEN tmp.MovementDescId = zc_Movement_ReturnIn() :: TVarChar
                        THEN 4
                   WHEN tmp.MovementDescId = zc_Movement_Send() :: TVarChar
                        THEN 5
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() :: TVarChar
                        THEN 0 -- ����� ��������� �����, �� �� ������� ��� ������������, � ������������� 6,7
                   WHEN tmp.MovementDescId = zc_Movement_Loss() :: TVarChar
                        THEN 8
                   WHEN tmp.MovementDescId = zc_Movement_ProductionSeparate() :: TVarChar
                        THEN 9
                   WHEN tmp.MovementDescId = zc_Movement_ProductionUnion() :: TVarChar
                        THEN 10
                   WHEN tmp.MovementDescId = zc_Movement_Inventory() :: TVarChar
                        THEN 11
                   ELSE 0
              END * 1000 AS OrderById
            , CASE WHEN inIsCeh = TRUE
                        THEN tmp.isProductionIn = 'TRUE' -- ��� ������������ - � ����������
                   WHEN vbBranchId = zc_Branch_Basis() AND (Object_From.Id IS NULL OR ObjectLink_UnitFrom_Branch.ChildObjectId > 0)
                        THEN TRUE -- ��� �������� - ������ �� ����
                   WHEN vbBranchId = zc_Branch_Basis()
                        THEN FALSE -- ��� �������� - ������ � ����
                   WHEN vbBranchId = ObjectLink_UnitTo_Branch.ChildObjectId
                        THEN TRUE -- ��� ������� - ������ �� ����
                   ELSE FALSE -- ��� ������� - ������ � ����
              END AS isSendOnPriceIn

            , CASE WHEN tmp.isPartionGoodsDate = 'TRUE' THEN TRUE ELSE FALSE END AS isPartionGoodsDate
            , CASE WHEN tmp.isTransport_link   = 'TRUE' THEN TRUE ELSE FALSE END AS isTransport_link

            , CASE WHEN tmp.MovementDescId IN (zc_Movement_ProductionUnion() :: TVarChar) AND inBranchCode = 201 -- ���� �������
                        THEN '��������'
                   WHEN tmp.MovementDescId IN (zc_Movement_ProductionUnion() :: TVarChar, zc_Movement_ProductionSeparate() :: TVarChar)
                        THEN '������������'
                   ELSE MovementDesc.ItemName
              END AS ItemName

       FROM (SELECT tmp.Number
                  , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'DescId'    ,               '0',      inSession) AS MovementDescId
                  , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'FromId'    ,               '0',      inSession) AS FromId
                  , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ToId'      ,               '0',      inSession) AS ToId
                  , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ColorGrid' ,               '0',      inSession) AS ColorGridValue
                  , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'GoodsKindWeighingGroupId', '345238', inSession) AS GoodsKindWeighingGroupId -- �������
                  , CASE WHEN inIsCeh = TRUE THEN '0' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END     || tmp.Number, 'PaidKindId',         '0',                                   inSession) END AS PaidKindId
                  , CASE WHEN inIsCeh = TRUE THEN '0' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END     || tmp.Number, 'InfoMoneyId',        zc_Enum_InfoMoney_30101() :: TVarChar, inSession) END AS InfoMoneyId -- ������ + ��������� + ������� ���������
                  , CASE WHEN inIsCeh = TRUE THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END              || tmp.Number, 'isProductionIn',     'TRUE',                                inSession) ELSE '' END AS isProductionIn
                  , CASE WHEN inIsCeh = TRUE THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END              || tmp.Number, 'isPartionGoodsDate', 'FALSE',                               inSession) ELSE '' END AS isPartionGoodsDate
                  , CASE WHEN inIsCeh = TRUE THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isTransport_link',   'FALSE',                               inSession) END AS isTransport_link
             FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
            ) AS tmp
            LEFT JOIN Object AS Object_From ON Object_From.Id = CASE WHEN TRIM (tmp.FromId) <> '' THEN TRIM (tmp.FromId) ELSE '0' END :: Integer
            LEFT JOIN Object AS Object_To   ON Object_To.Id   = CASE WHEN TRIM (tmp.ToId)   <> '' THEN TRIM (tmp.ToId)   ELSE '0' END :: Integer
            LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                 ON ObjectLink_UnitFrom_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                 ON ObjectLink_UnitTo_Branch.ObjectId = Object_To.Id
                                AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN MovementDesc ON MovementDesc.Id = CASE WHEN TRIM (tmp.MovementDescId) <> '' THEN TRIM (tmp.MovementDescId) ELSE '0' END :: Integer
      ;

    -- ����� ��������� � � ����. �������, �� �� ������� ��� ������������
    UPDATE _tmpToolsWeighing SET OrderById = 1000 * CASE WHEN vbBranchId = zc_Branch_Basis() AND _tmpToolsWeighing.isSendOnPriceIn = FALSE
                                                              THEN 6 -- ��� �������� - ������ � ����, ����� � ������ ������
                                                         WHEN vbBranchId = zc_Branch_Basis()
                                                              THEN 7 -- ��� �������� - ������ �� ����, ����� � ������ �����
                                                         WHEN _tmpToolsWeighing.isSendOnPriceIn = TRUE
                                                              THEN 6 -- ��� ������� - ������ �� ����, ����� � ������ ������
                                                         ELSE 7 -- ��� ������� - ������ � ����, ����� � ������ �����
                                                    END
                               , ItemName = CASE WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND _tmpToolsWeighing.isSendOnPriceIn = FALSE
                                                  AND vbBranchId = zc_Branch_Basis()
                                                      THEN '������ �� ������'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND vbBranchId = zc_Branch_Basis()
                                                      THEN '������� � �������'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND _tmpToolsWeighing.isSendOnPriceIn = TRUE
                                                      THEN '������ �� ������'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                      THEN '������� � �������'
                                                 ELSE _tmpToolsWeighing.ItemName
                                            END
    WHERE _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice();


    -- ���������
    RETURN QUERY
      SELECT _tmpToolsWeighing.Number                        AS Number
           , _tmpToolsWeighing.MovementDescId                AS MovementDescId
           , COALESCE (Object_From.Id, 0) :: Integer         AS FromId
           , Object_From.ObjectCode                          AS FromCode
           , Object_From.ValueData                           AS FromName
           , COALESCE (Object_To.Id, 0) :: Integer           AS ToId
           , Object_To.ObjectCode                            AS ToCode
           , Object_To.ValueData                             AS ToName
           , Object_PaidKind.Id                              AS PaidKindId
           , Object_PaidKind.ValueData                       AS PaidKindName
           , COALESCE (Object_InfoMoney.Id, 0) :: Integer    AS InfoMoneyId
           , Object_InfoMoney.ObjectCode                     AS InfoMoneyCode
           , Object_InfoMoney.ValueData                      AS InfoMoneyName
           , Object_PriceList.Id                             AS PriceListId
           , Object_PriceList.ObjectCode                     AS PriceListCode
           , Object_PriceList.ValueData                      AS PriceListName
           , Object_GoodsKindWeighingGroup.Id                AS GoodsKindWeighingGroupId
           , _tmpToolsWeighing.ColorGridValue                AS ColorGridValue

           , ('(' || _tmpToolsWeighing.Number :: TVarChar ||') '
          || CASE WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_PaidKind.ValueData, '')
                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                       THEN COALESCE (Object_PaidKind.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Loss())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || CASE WHEN Object_To.Id > 0 THEN ' ' || COALESCE (Object_To.ValueData, '') ELSE '' END

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                       THEN CASE WHEN _tmpToolsWeighing.isSendOnPriceIn = TRUE THEN '������' ELSE '��C���' END
                  || ' ' || COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  ELSE TRIM (COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, ''))
              END) :: TVarChar AS MovementDescName


           , ('(' || _tmpToolsWeighing.Number :: TVarChar ||') '
          || _tmpToolsWeighing.ItemName -- MovementDesc.ItemName
          || ': '
          || CASE WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_PaidKind.ValueData, '')
                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                       THEN COALESCE (Object_PaidKind.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Loss())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || CASE WHEN Object_To.Id > 0 THEN ' ' || COALESCE (Object_To.ValueData, '') ELSE '' END

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                       THEN CASE WHEN _tmpToolsWeighing.isSendOnPriceIn = TRUE THEN '������' ELSE '��C���' END
                  || ' ' || COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  ELSE TRIM (COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, ''))
             END) :: TVarChar AS MovementDescName_master

           , (_tmpToolsWeighing.OrderById + _tmpToolsWeighing.Number) :: Integer AS OrderById
           , _tmpToolsWeighing.isSendOnPriceIn
           , _tmpToolsWeighing.isPartionGoodsDate
           , _tmpToolsWeighing.isTransport_link

       FROM _tmpToolsWeighing
            LEFT JOIN Object AS Object_PriceList              ON Object_PriceList.Id              = zc_PriceList_Basis() AND _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
            LEFT JOIN Object AS Object_From                   ON Object_From.Id                   = _tmpToolsWeighing.FromId
            LEFT JOIN Object AS Object_To                     ON Object_To.Id                     = _tmpToolsWeighing.ToId
            LEFT JOIN Object AS Object_PaidKind               ON Object_PaidKind.Id               = _tmpToolsWeighing.PaidKindId
            LEFT JOIN Object AS Object_InfoMoney              ON Object_InfoMoney.Id              = _tmpToolsWeighing.InfoMoneyId
            LEFT JOIN Object AS Object_GoodsKindWeighingGroup ON Object_GoodsKindWeighingGroup.Id = _tmpToolsWeighing.GoodsKindWeighingGroupId
            -- LEFT JOIN MovementDesc ON MovementDesc.Id = _tmpToolsWeighing.MovementDescId
       WHERE _tmpToolsWeighing.MovementDescId > 0
      UNION
       -- ��� ������
       SELECT 0                                   AS Number
            ,(-1 * tmp.MovementDescId) :: Integer AS MovementDescId
            , 0                                   AS FromId
            , 0                                   AS FromCode
            , '' :: TVarChar                      AS FromName
            , 0                                   AS ToId
            , 0                                   AS ToCode
            , '' :: TVarChar                      AS ToName
            , 0                                   AS PaidKindId
            , '' :: TVarChar                      AS PaidKindName
            , 0                                   AS InfoMoneyId
            , 0                                   AS InfoMoneyCode
            , '' :: TVarChar                      AS InfoMoneyName
            , 0                                   AS PriceListId
            , 0                                   AS PriceListCode
            , '' :: TVarChar                      AS PriceListName
            , 0                                   AS GoodsKindWeighingGroupId
            , 0                                   AS ColorGridValue
            , CASE WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND tmp.isSendOnPriceIn = FALSE
                    AND vbBranchId = zc_Branch_Basis()
                        THEN '������ �� ������'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND vbBranchId = zc_Branch_Basis()
                        THEN '������� � �������'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND tmp.isSendOnPriceIn = TRUE
                        THEN '������ �� ������'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                        THEN '������� � �������'
                   ELSE tmp.ItemName -- MovementDesc.ItemName
              END :: TVarChar AS MovementDescName
            , '' :: TVarChar                      AS MovementDescName_master
            , tmp.OrderById                       AS OrderById
            , tmp.isSendOnPriceIn
            , FALSE AS isPartionGoodsDate
            , FALSE AS isTransport_link
       FROM (SELECT _tmpToolsWeighing.MovementDescId, _tmpToolsWeighing.OrderById, CASE WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice() THEN _tmpToolsWeighing.isSendOnPriceIn ELSE FALSE END AS isSendOnPriceIn, _tmpToolsWeighing.ItemName FROM _tmpToolsWeighing WHERE _tmpToolsWeighing.MovementDescId > 0 GROUP BY _tmpToolsWeighing.MovementDescId, _tmpToolsWeighing.OrderById, CASE WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice() THEN _tmpToolsWeighing.isSendOnPriceIn ELSE FALSE END, _tmpToolsWeighing.ItemName) AS tmp
            -- LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.MovementDescId
      ORDER BY OrderById;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing_MovementDesc (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.01.15                                        * all
 20.03.14                                                         *
 14.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ToolsWeighing_MovementDesc (TRUE, 201, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_MovementDesc (FALSE, 1, zfCalc_UserAdmin())

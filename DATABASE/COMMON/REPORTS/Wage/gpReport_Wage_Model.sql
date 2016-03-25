DROP FUNCTION IF EXISTS gpSelect_Report_Wage_1(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Integer,   --������������� 
    Integer,   --������ ����������
    Integer,   --���������
    Integer,   --���������
    TVarChar   --������ ������������
);

DROP FUNCTION IF EXISTS gpSelect_Report_Wage_Model(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Integer,   --������������� 
    Integer,   --������ ����������
    Integer,   --���������
    Integer,   --���������
    TVarChar   --������ ������������
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage_Model(
    IN inDateStart      TDateTime, --���� ������ �������
    IN inDateFinal      TDateTime, --���� ��������� �������
    IN inUnitId         Integer,   --������������� 
    IN inModelServiceId Integer,   --������ ����������
    IN inMemberId       Integer,   --���������
    IN inPositionId     Integer,   --���������
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     StaffList                      Integer
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,PersonalCount                  Integer
    ,HoursPlan                      TFloat
    ,HoursDay                       TFloat
    ,PersonalGroupId                Integer
    ,PersonalGroupName              TVarChar
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SheetWorkTime_Date             TDateTime
    ,SUM_MemberHours                TFloat
    ,SheetWorkTime_Amount           TFloat
    ,ServiceModelId                 Integer
    ,ServiceModelCode               Integer
    ,ServiceModelName               TVarChar
    ,Price                          TFloat
    ,FromId                         Integer
    ,FromName                       TVarChar
    ,ToId                           Integer
    ,ToName                         TVarChar
    ,MovementDescId                 Integer
    ,MovementDescName               TVarChar
    ,SelectKindId                   Integer
    ,SelectKindName                 TVarChar
    ,Ratio                          TFloat
    ,ModelServiceItemChild_FromId   Integer
    ,ModelServiceItemChild_FromDescId   Integer
    ,ModelServiceItemChild_FromName TVarChar
    ,ModelServiceItemChild_ToId     Integer
    ,ModelServiceItemChild_ToDescId     Integer
    ,ModelServiceItemChild_ToName   TVarChar
    ,OperDate                       TDateTime
    ,Count_MemberInDay              Integer
    ,Gross                          TFloat
    ,GrossOnOneMember               TFloat
    ,Amount                         TFloat
    ,AmountOnOneMember              TFloat
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;

    -- ������ ����
    CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series (inDateStart, inDateFinal, '1 DAY' :: INTERVAL) AS OperDate;

    -- ���������
    CREATE TEMP TABLE Setting_Wage_1(
        StaffListId Integer
       ,UnitId Integer
       ,UnitName TVarChar
       ,PositionId Integer
       ,PositionName TVarChar
       ,isPositionLevel_all Boolean
       ,PositionLevelId Integer
       ,PositionLevelName TVarChar
       ,PersonalCount Integer
       ,HoursPlan TFloat
       ,HoursDay TFloat
       ,ServiceModelKindId Integer
       ,ServiceModelId Integer
       ,ServiceModelCode Integer
       ,ServiceModelName TVarChar
       ,Price TFloat
       ,FromId Integer
       ,FromName TVarChar
       ,ToId Integer
       ,ToName TVarChar
       ,MovementDescId Integer
       ,MovementDescName TVarChar
       ,SelectKindId Integer
       ,SelectKindCode Integer
       ,SelectKindName TVarChar
       ,isActive Boolean
       ,Ratio TFloat
       ,ModelServiceItemChild_FromId Integer
       ,ModelServiceItemChild_FromDescId Integer
       ,ModelServiceItemChild_FromName TVarChar
       ,ModelServiceItemChild_ToId Integer
       ,ModelServiceItemChild_ToDescId Integer
       ,ModelServiceItemChild_ToName TVarChar) ON COMMIT DROP;


    -- �������� ���������
    INSERT INTO Setting_Wage_1 (StaffListId,UnitId,UnitName,PositionId,PositionName, isPositionLevel_all, PositionLevelId, PositionLevelName, PersonalCount,HoursPlan,HoursDay, ServiceModelKindId, ServiceModelId,ServiceModelCode
                              , ServiceModelName,Price,FromId,FromName,ToId,ToName,MovementDescId,MovementDescName, SelectKindId, SelectKindCode, SelectKindName, isActive
                              , Ratio,ModelServiceItemChild_FromId,ModelServiceItemChild_FromDescId,ModelServiceItemChild_FromName,ModelServiceItemChild_ToId,ModelServiceItemChild_ToDescId,ModelServiceItemChild_ToName)
    SELECT
        Object_StaffList.Id                                 AS StaffListId            -- ������� ����������
       ,ObjectLink_StaffList_Unit.ChildObjectId             AS UnitId                 -- ������������
       ,Object_Unit.ValueData                               AS UnitName
       ,ObjectLink_StaffList_Position.ChildObjectId         AS PositionId             -- ���������
       ,Object_Position.ValueData                           AS PositionName
       ,COALESCE (ObjectBoolean_PositionLevel.ValueData, FALSE) AS isPositionLevel_all
       ,CASE WHEN ObjectBoolean_PositionLevel.ValueData = TRUE THEN 0 ELSE ObjectLink_StaffList_PositionLevel.ChildObjectId END AS PositionLevelId -- ������ ���������
       ,Object_PositionLevel.ValueData                      AS PositionLevelName
       ,ObjectFloat_PersonalCount.ValueData::Integer        AS PersonalCount          -- !!!������������!!! ���-�� ����������� (�� ����������� ������� ����������)
       ,ObjectFloat_HoursPlan.ValueData                     AS HoursPlan              -- !!!������������!!! 1.����� ���� ����� � ����� �� �������� (�� ����������� ������� ����������)
       ,ObjectFloat_HoursDay.ValueData                      AS HoursDay               -- !!!������������!!! 2.������� ���� ����� �� �������� (�� ����������� ������� ����������)
       ,ObjectLink_ModelService_ModelServiceKind.ChildObjectId AS ServiceModelKindId  -- ��� ������ ����������
       ,ObjectLink_StaffListCost_ModelService.ChildObjectId    AS ServiceModelId      -- ������ ����������
       ,Object_ModelService.ObjectCode::Integer                AS ServiceModelCode
       ,Object_ModelService.ValueData                          AS ServiceModelName
       ,ObjectFloat_StaffListCost_Price.ValueData           AS Price                  -- �������� ���./��. (�� ����������� �������� �������� ���������� ��� ������ ����������)
       ,Object_From.Id                                      AS FromId                 -- �������������(�� ����) (�� ����������� ������� �������� ������ ����������)
       ,Object_From.ValueData                               AS FromName
       ,Object_To.Id                                        AS ToId                   -- �������������(����) (�� ����������� ������� �������� ������ ����������)
       ,Object_To.ValueData                                 AS ToName
       ,MovementDesc.Id                                     AS MovementDescId         -- ��� ��������� (�� ����������� ������� �������� ������ ����������)
       ,MovementDesc.ItemName                               AS MovementDescName
       ,Object_SelectKind.Id                                AS SelectKindId           -- ��� ������ ������ (�� ����������� ������� �������� ������ ����������)
       ,Object_SelectKind.ObjectCode                        AS SelectKindCode
       ,Object_SelectKind.ValueData                         AS SelectKindName
       ,CASE WHEN MovementDesc.Id = zc_Movement_Send()
                  THEN FALSE
             WHEN Object_SelectKind.Id IN (zc_Enum_SelectKind_InAmount(), zc_Enum_SelectKind_InWeight(), zc_Enum_SelectKind_InHead()) -- ���-�� ������
                  THEN TRUE
              WHEN Object_SelectKind.Id IN (zc_Enum_SelectKind_OutAmount(), zc_Enum_SelectKind_OutWeight(), zc_Enum_SelectKind_OutHead()) -- ���-�� ������
                  THEN FALSE
        END                                                 AS isActive              -- ��� ������ ������
       ,ObjectFloat_Ratio.ValueData                         AS Ratio                 -- ����������� ��� ������ ������
       ,ModelServiceItemChild_From.Id                       AS ModelServiceItemChild_FromId       -- �����,������(�� ����) (�� ����������� ����������� �������� ������ ����������)
       ,ModelServiceItemChild_From.DescId                   AS ModelServiceItemChild_FromDescId
       ,ModelServiceItemChild_From.ValueData                AS ModelServiceItemChild_FromName
       ,ModelServiceItemChild_To.Id                         AS ModelServiceItemChild_ToId         -- �����,������(����) (�� ����������� ����������� �������� ������ ����������)
       ,ModelServiceItemChild_To.DescId                     AS ModelServiceItemChild_ToDescId
       ,ModelServiceItemChild_To.ValueData                  AS ModelServiceItemChild_ToName
    FROM Object as Object_StaffList
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PositionLevel
                                ON ObjectBoolean_PositionLevel.ObjectId = Object_StaffList.Id 
                               AND ObjectBoolean_PositionLevel.DescId = zc_ObjectBoolean_StaffList_PositionLevel()
        --Unit �������������
        LEFT OUTER JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                   ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                  AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
        LEFT OUTER JOIN Object AS Object_Unit
                               ON Object_Unit.Id = ObjectLink_StaffList_Unit.ChildObjectId
        --Position  ���������
        LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                             ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                            AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
        LEFT JOIN Object AS Object_Position 
                         ON Object_Position.Id = ObjectLink_StaffList_Position.ChildObjectId
        --PositionLevel ������ ���������
        LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                             ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                            AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
        LEFT JOIN Object AS Object_PositionLevel 
                         ON Object_PositionLevel.Id = ObjectLink_StaffList_PositionLevel.ChildObjectId
        --PersonalCount  ���-�� ����������� � �������������/���������/�������
        LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount 
                              ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()
        --HoursPlan  1.���.��.�.� ���. �� ��������
        LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan 
                              ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()
        --HoursDay  2.������� ��.�. �� ��������
        LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay 
                              ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
        --StaffListCost
        INNER JOIN ObjectLink AS ObjectLink_StaffListCost_StaffList
                              ON ObjectLink_StaffListCost_StaffList.ChildObjectId = Object_StaffList.ID
                             AND ObjectLink_StaffListCost_StaffList.DescId = zc_ObjectLink_StaffListCost_StaffList()
        INNER JOIN Object AS Object_StaffListCost
                          ON Object_StaffListCost.Id = ObjectLink_StaffListCost_StaffList.ObjectId
                         AND Object_StaffListCost.isErased = FALSE
        --Price ��������
        LEFT JOIN ObjectFloat AS ObjectFloat_StaffListCost_Price 
                              ON ObjectFloat_StaffListCost_Price.ObjectId = Object_StaffListCost.Id 
                             AND ObjectFloat_StaffListCost_Price.DescId = zc_ObjectFloat_StaffListCost_Price()
        --ModelService  ������ ����������
        LEFT OUTER JOIN ObjectLink AS ObjectLink_StaffListCost_ModelService
                                   ON ObjectLink_StaffListCost_ModelService.ObjectId = Object_StaffListCost.Id
                                  AND ObjectLink_StaffListCost_ModelService.DescId = zc_ObjectLink_StaffListCost_ModelService()
        LEFT OUTER JOIN Object AS Object_ModelService
                               ON Object_ModelService.Id = ObjectLink_StaffListCost_ModelService.ChildObjectId
                              AND Object_ModelService.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelService_ModelServiceKind
                                   ON ObjectLink_ModelService_ModelServiceKind.ObjectId = Object_ModelService.Id
                                  AND ObjectLink_ModelService_ModelServiceKind.DescId = zc_ObjectLink_ModelService_ModelServiceKind()
        --ModelServiceItemMaster ���� ���������� ��� ���������
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_ModelService
                                   ON ObjectLink_ModelServiceItemMaster_ModelService.ChildObjectId = Object_ModelService.Id
                                  AND ObjectLink_ModelServiceItemMaster_ModelService.DescId = zc_ObjectLink_ModelServiceItemMaster_ModelService()
        INNER JOIN Object AS Object_ModelServiceItemMaster
                          ON Object_ModelServiceItemMaster.Id       = ObjectLink_ModelServiceItemMaster_ModelService.ObjectId
                         AND Object_ModelServiceItemMaster.isErased = FALSE
                         -- AND Object_ModelServiceItemMaster.DescId   = zc_Object_ModelServiceItemMaster()
        --Ftom  ��������� �� ����
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_From
                                   ON ObjectLink_ModelServiceItemMaster_From.ObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemMaster_From.DescId = zc_ObjectLink_ModelServiceItemMaster_From()
        LEFT OUTER JOIN Object AS Object_From 
                               ON Object_From.Id = ObjectLink_ModelServiceItemMaster_From.ChildObjectId
        --To  ��������� ����
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_To
                                   ON ObjectLink_ModelServiceItemMaster_To.ObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemMaster_To.DescId = zc_ObjectLink_ModelServiceItemMaster_To()
        LEFT OUTER JOIN Object AS Object_To 
                               ON Object_To.Id = ObjectLink_ModelServiceItemMaster_To.ChildObjectId
        --SelectKind ��� ������
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_SelectKind
                                   ON ObjectLink_ModelServiceItemMaster_SelectKind.ObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemMaster_SelectKind.DescId = zc_ObjectLink_ModelServiceItemMaster_SelectKind()
        LEFT OUTER JOIN Object AS Object_SelectKind 
                               ON Object_SelectKind.Id = ObjectLink_ModelServiceItemMaster_SelectKind.ChildObjectId
        --MovementDesc  ��� ���������
        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_MovementDesc 
                                    ON ObjectFloat_MovementDesc.ObjectId = Object_ModelServiceItemMaster.Id 
                                   AND ObjectFloat_MovementDesc.DescId = zc_ObjectFloat_ModelServiceItemMaster_MovementDesc()
        LEFT OUTER JOIN MovementDesc ON MovementDesc.Id = ObjectFloat_MovementDesc.ValueData
        --Ratio ����������
        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Ratio 
                                    ON ObjectFloat_Ratio.ObjectId = Object_ModelServiceItemMaster.Id 
                                   AND ObjectFloat_Ratio.DescId = zc_ObjectFloat_ModelServiceItemMaster_Ratio()
        --����������� �� ������ / ������
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ModelServiceItemMaster
                                   ON ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ChildObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.DescId = zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster()
        LEFT OUTER JOIN Object AS Object_ModelServiceItemChild
                               ON Object_ModelServiceItemChild.Id = ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ObjectId
                              AND Object_ModelServiceItemChild.DescId = zc_Object_ModelServiceItemChild()
                              AND Object_ModelServiceItemChild.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_From
                                   ON ObjectLink_ModelServiceItemChild_From.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_ModelServiceItemChild_From.DescId = zc_ObjectLink_ModelServiceItemChild_From()
        LEFT OUTER JOIN Object AS ModelServiceItemChild_From 
                               ON ModelServiceItemChild_From.Id = ObjectLink_ModelServiceItemChild_From.ChildObjectId
                              AND ModelServiceItemChild_From.isErased = FALSE 
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_To
                                   ON ObjectLink_ModelServiceItemChild_To.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_ModelServiceItemChild_To.DescId = zc_ObjectLink_ModelServiceItemChild_To()
        LEFT JOIN Object AS ModelServiceItemChild_To
                         ON ModelServiceItemChild_To.Id = ObjectLink_ModelServiceItemChild_To.ChildObjectId
                        AND ModelServiceItemChild_To.isErased = FALSE
    WHERE Object_StaffList.DescId = zc_Object_StaffList()
        AND (ObjectLink_StaffList_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
        AND (ObjectLink_StaffList_Position.ChildObjectId = inPositionId OR inPositionId = 0)
        AND (ObjectLink_StaffListCost_ModelService.ChildObjectId = inModelServiceId OR inModelServiceId = 0)
   ;

    -- ���������    
    RETURN QUERY
    WITH -- ��� ��������� ��� ������� �� ��������� ���./��.
         tmpMovement AS 
       (SELECT
            MovementItemContainer.OperDate
           ,MovementItemContainer.MovementDescId
           ,MovementItemContainer.IsActive
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectExtId_Analyzer
                 ELSE MovementItemContainer.WhereObjectId_Analyzer
            END AS FromId
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.WhereObjectId_Analyzer
                 ELSE MovementItemContainer.ObjectExtId_Analyzer
            END AS ToId
           ,CASE WHEN MovementItemContainer.IsActive = TRUE 
                      THEN MovementItemContainer.ObjectId_Analyzer -- NULL::Integer
                 ELSE MovementItemContainer.ObjectId_Analyzer
            END AS GoodsId_from
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectId_Analyzer
                 ELSE Container.ObjectId
            END AS GoodsId_to
           ,SUM (CASE  WHEN MovementItemContainer.IsActive = TRUE
                            THEN MovementItemContainer.Amount
                       ELSE -1 * MovementItemContainer.Amount
                 END)::TFloat as Amount
           ,MovementItemContainer.ObjectIntId_Analyzer AS GoodsKindId

        FROM (SELECT DISTINCT
                     Setting.MovementDescId
              FROM Setting_Wage_1 as Setting
              WHERE Setting.MovementDescId IS NOT NULL
             ) AS SettingDesc
             INNER JOIN MovementItemContainer ON MovementItemContainer.MovementDescId = SettingDesc.MovementDescId
                                             AND MovementItemContainer.DescId         = zc_MIContainer_Count()
                                             AND MovementItemContainer.OperDate BETWEEN inDateStart AND inDateFinal
             LEFT OUTER JOIN Container ON Container.Id = MovementItemContainer.ContainerId_Analyzer
        GROUP BY
            MovementItemContainer.OperDate
           ,MovementItemContainer.MovementDescId
           ,MovementItemContainer.IsActive
           ,MovementItemContainer.ObjectIntId_Analyzer
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE
                    THEN MovementItemContainer.ObjectExtId_Analyzer
            ELSE MovementItemContainer.WhereObjectId_Analyzer
            END
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE 
                    THEN MovementItemContainer.WhereObjectId_Analyzer
            ELSE MovementItemContainer.ObjectExtId_Analyzer
            END
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE 
                    THEN MovementItemContainer.ObjectId_Analyzer -- NULL::Integer
            ELSE MovementItemContainer.ObjectId_Analyzer
            END
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE 
                    THEN MovementItemContainer.ObjectId_Analyzer
            ELSE Container.ObjectId
            END
       )
         -- ������ ���������� + ����������� ��������� ��� ������� �� ���-�� �����
       , tmpMovement_HeadCount AS
       (SELECT tmpMI.OperDate
             , tmpMI.MovementDescId
             , tmpMI.IsActive
             , tmpMI.FromId
             , tmpMI.ToId
             , tmpMI.GoodsId_from
             , tmpMI.GoodsId_to
             , tmpMI.GoodsKindId
             , SUM (MIFloat_HeadCount.ValueData) AS Amount
        FROM
        (SELECT DISTINCT MovementItemContainer.MovementItemId
           ,MovementItemContainer.OperDate
           ,MovementItemContainer.MovementDescId
           ,MovementItemContainer.IsActive
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectExtId_Analyzer
                 ELSE MovementItemContainer.WhereObjectId_Analyzer
            END AS FromId
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.WhereObjectId_Analyzer
                 ELSE MovementItemContainer.ObjectExtId_Analyzer
            END AS ToId
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectId_Analyzer -- NULL::Integer
                 ELSE MovementItemContainer.ObjectId_Analyzer
            END AS GoodsId_from
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectId_Analyzer
                 ELSE Container.ObjectId
            END AS GoodsId_to
           ,MovementItemContainer.ObjectIntId_Analyzer AS GoodsKindId

        FROM (SELECT DISTINCT Setting.MovementDescId FROM Setting_Wage_1 AS Setting WHERE Setting.SelectKindId IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead())) AS tmp  -- ���-�� ����� ������ + ���-�� ����� ������
             INNER JOIN MovementItemContainer ON MovementItemContainer.MovementDescId = tmp.MovementDescId
                                             AND MovementItemContainer.DescId         = zc_MIContainer_Count()
                                             AND MovementItemContainer.OperDate BETWEEN inDateStart AND inDateFinal
             LEFT OUTER JOIN Container ON Container.Id = MovementItemContainer.ContainerId_Analyzer
       ) AS tmpMI
             INNER JOIN MovementItemFloat AS MIFloat_HeadCount
                                          ON MIFloat_HeadCount.MovementItemId = tmpMI.MovementItemId
                                         AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
        GROUP BY tmpMI.OperDate
               , tmpMI.MovementDescId
               , tmpMI.IsActive
               , tmpMI.FromId
               , tmpMI.ToId
               , tmpMI.GoodsId_from
               , tmpMI.GoodsId_to
               , tmpMI.GoodsKindId
       )

         -- ������ ���������� + ����������� ��������� ��� ������� �� ��������� ���./��.
       , tmpGoodsByGoodsKind AS
       (SELECT Object_GoodsByGoodsKind_View.Id, Object_GoodsByGoodsKind_View.GoodsId, Object_GoodsByGoodsKind_View.GoodsKindId
        FROM (SELECT 0 AS X FROM Setting_Wage_1 AS Setting WHERE Setting.SelectKindId = zc_Enum_SelectKind_InPack() LIMIT 1) AS tmp  -- ���-�� �������� ������ (������)
             INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsKindId > tmp.X
       )
         -- ������ ���������� + ����������� ��������� ��� ������� �� ��������� ���./��.
       , ServiceModelMovement AS
       (SELECT
            Setting.StaffListId
           ,Setting.UnitId
           ,Setting.PositionId
           ,Setting.PositionLevelId
           ,Setting.ServiceModelId
           ,Setting.Price
           ,Setting.FromId
           ,Setting.ToId
           ,Setting.MovementDescId
           ,Setting.SelectKindCode
           ,Setting.SelectKindId
           ,Setting.ModelServiceItemChild_FromId
           ,Setting.ModelServiceItemChild_ToId
           , COALESCE (tmpMovement.OperDate, tmpMovement_HeadCount.OperDate) AS OperDate
           , SUM (CASE WHEN Setting.SelectKindId IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead()) -- ���-�� �����
                            THEN tmpMovement_HeadCount.Amount
                       WHEN Setting.SelectKindId = zc_Enum_SelectKind_InPack() -- ���-�� �������� ������ (������)
                            THEN CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                                           THEN CAST ((tmpMovement.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                                    / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                                      ELSE 0
                                 END
                       ELSE tmpMovement.Amount
                  END) :: TFloat AS Gross  -- ����� ����, ���-��
           , ROUND (Setting.Price * Setting.Ratio
           * SUM (CASE WHEN Setting.SelectKindId IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead()) -- ���-�� �����
                            THEN tmpMovement_HeadCount.Amount
                       WHEN Setting.SelectKindId = zc_Enum_SelectKind_InPack() -- ���-�� �������� ������ (������)
                            THEN CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                                           THEN CAST ((tmpMovement.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                                    / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                                      ELSE 0
                                 END
                       ELSE tmpMovement.Amount
                  END)
           , 2) :: TFloat AS Amount -- ����� �����, ���
        FROM Setting_Wage_1 AS Setting
             LEFT JOIN tmpMovement ON tmpMovement.MovementDescId = Setting.MovementDescId
                                  AND tmpMovement.IsActive = Setting.IsActive
                                  AND Setting.SelectKindId NOT IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead())
             LEFT JOIN tmpMovement_HeadCount ON tmpMovement_HeadCount.MovementDescId = Setting.MovementDescId
                                            AND tmpMovement_HeadCount.IsActive = Setting.IsActive
                                            AND Setting.SelectKindId IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead())

             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = tmpMovement.GoodsId_from
                                          AND tmpGoodsByGoodsKind.GoodsKindId = tmpMovement.GoodsKindId
             LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                   ON ObjectFloat_WeightTotal.ObjectId = tmpGoodsByGoodsKind.Id
                                  AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = tmpMovement.GoodsId_from
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpMovement.GoodsId_from
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        WHERE (Setting.FromId IS NULL OR COALESCE (tmpMovement_HeadCount.FromId, tmpMovement.FromId) IN (SELECT UnitTree.UnitId FROM lfSelect_Object_Unit_byGroup (Setting.FromId) AS UnitTree))
          AND (Setting.ToId   IS NULL OR COALESCE (tmpMovement_HeadCount.ToId,   tmpMovement.ToId)   IN (SELECT UnitTree.UnitId FROM lfSelect_Object_Unit_byGroup (Setting.ToId)   AS UnitTree))
          AND (Setting.ModelServiceItemChild_FromId IS NULL OR (Setting.ModelServiceItemChild_FromDescId = zc_Object_Goods()
                                                            AND COALESCE (tmpMovement_HeadCount.GoodsId_from, tmpMovement.GoodsId_from) = Setting.ModelServiceItemChild_FromId
                                                               )
                                                            OR (Setting.ModelServiceItemChild_FromDescId = zc_Object_GoodsGroup()
                                                            AND COALESCE (tmpMovement_HeadCount.GoodsId_from, tmpMovement.GoodsId_from) IN (SELECT GoodsTree.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (Setting.ModelServiceItemChild_FromId) AS GoodsTree)
                                                               )
              )
          AND (Setting.ModelServiceItemChild_ToId IS NULL OR (Setting.ModelServiceItemChild_ToDescId = zc_Object_Goods()
                                                          AND COALESCE (tmpMovement_HeadCount.GoodsId_to, tmpMovement.GoodsId_to) = Setting.ModelServiceItemChild_ToId
                                                             )
                                                          OR (Setting.ModelServiceItemChild_ToDescId = zc_Object_GoodsGroup()
                                                          AND COALESCE (tmpMovement_HeadCount.GoodsId_to, tmpMovement.GoodsId_to) IN (SELECT GoodsTree.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (Setting.ModelServiceItemChild_ToId) AS GoodsTree)
                                                             )
              )
        GROUP BY
             Setting.StaffListId
           , Setting.UnitId
           , Setting.PositionId
           , Setting.PositionLevelId
           , Setting.ServiceModelId
           , Setting.Price
           , Setting.FromId
           , Setting.ToId
           , Setting.MovementDescId
           , Setting.SelectKindId
           , Setting.SelectKindCode
           , Setting.ModelServiceItemChild_FromId
           , Setting.ModelServiceItemChild_ToId
           , COALESCE (tmpMovement.OperDate, tmpMovement_HeadCount.OperDate)
           , Setting.Price 
           , Setting.Ratio
       )
         -- ������ - ��� � ����� ��� �������
       , Movement_Sheet AS
      (SELECT
            Movement.OperDate               AS OperDate
           ,MI_SheetWorkTime.ObjectId       AS MemberId
           ,Object_Member.ValueData         AS MemberName
           ,MIObject_PersonalGroup.ObjectId AS PersonalGroupId
           ,MIObject_Position.ObjectId      AS PositionId
           ,MIObject_PositionLevel.ObjectId AS PositionLevelId
           ,MI_SheetWorkTime.Amount         AS Amount
           , SUM (MI_SheetWorkTime.Amount) OVER (PARTITION BY MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId) AS SUM_MemberHours
           , SUM (MI_SheetWorkTime.Amount) OVER (PARTITION BY Movement.OperDate, MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId) AS AmountInDay
           , COUNT(*) OVER (PARTITION BY Movement.OperDate, MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId) AS Count_MemberInDay
        FROM Movement
             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                          AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
             INNER JOIN MovementItem AS MI_SheetWorkTime
                                     ON MI_SheetWorkTime.MovementId = Movement.Id
                                    AND MI_SheetWorkTime.Amount > 0
                                    AND MI_SheetWorkTime.isErased = FALSE

             INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                               ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                              AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
             INNER JOIN Object_WorkTimeKind_Wages_View AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = MIObject_WorkTimeKind.ObjectId
             LEFT JOIN Object AS Object_Member ON Object_Member.Id = MI_SheetWorkTime.ObjectId

             LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                    ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                   AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
             LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                    ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                   AND MIObject_Position.DescId = zc_MILinkObject_Position() 
             LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                    ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                   AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
            
        WHERE Movement.DescId = zc_Movement_SheetWorkTime()
          AND Movement.OperDate BETWEEN inDateStart AND inDateFinal
       )
         -- ������ - ���� ����������� ���� �� �����
       , Movement_SheetGroup AS
      (SELECT Movement_Sheet.MemberId
            , Movement_Sheet.MemberName
            , Movement_Sheet.PersonalGroupId
            , Movement_Sheet.PositionId
            , Movement_Sheet.PositionLevelId
            , (Movement_Sheet.Amount) AS Amount
            , SUM (Movement_Sheet.Amount) OVER (PARTITION BY Movement_Sheet.PositionId, Movement_Sheet.PositionLevelId) AS AmountInMonth
            , COUNT(*) OVER (PARTITION BY Movement_Sheet.PositionId, Movement_Sheet.PositionLevelId) AS Count_Member
       FROM (SELECT Movement_Sheet.MemberId
                  , Movement_Sheet.MemberName
                  , Movement_Sheet.PersonalGroupId
                  , Movement_Sheet.PositionId
                  , Movement_Sheet.PositionLevelId
                  , SUM (Movement_Sheet.Amount) AS Amount
             FROM Movement_Sheet
             GROUP BY Movement_Sheet.MemberId
                    , Movement_Sheet.MemberName
                    , Movement_Sheet.PersonalGroupId
                    , Movement_Sheet.PositionId
                    , Movement_Sheet.PositionLevelId
            ) AS Movement_Sheet
       )

    -- ���������
    SELECT 
        Setting.StaffListId
       ,Setting.UnitId
       ,Setting.UnitName
       ,Setting.PositionId
       ,Setting.PositionName
       ,Setting.PositionLevelId
       ,Setting.PositionLevelName
       ,Setting.PersonalCount
       ,Setting.HoursPlan
       ,Setting.HoursDay
       , Object_PersonalGroup.Id        AS PersonalGroupId
       , Object_PersonalGroup.ValueData AS PersonalGroupName
       ,COALESCE (Movement_SheetGroup.MemberId,   Movement_Sheet.MemberId)   :: Integer  AS MemberId
       ,COALESCE (Movement_SheetGroup.MemberName, Movement_Sheet.MemberName) :: TVarChar AS MemberName
       ,tmpOperDate.OperDate :: TDateTime        AS SheetWorkTime_Date
       ,Movement_Sheet.SUM_MemberHours :: TFloat AS SUM_MemberHours
       ,Movement_Sheet.Amount                    AS SheetWorkTime_Amount
       ,Setting.ServiceModelId
       ,Setting.ServiceModelCode
       ,Setting.ServiceModelName
       ,Setting.Price
       ,Setting.FromId
       ,Setting.FromName
       ,Setting.ToId
       ,Setting.ToName
       ,Setting.MovementDescId
       ,Setting.MovementDescName
       ,Setting.SelectKindId
       ,Setting.SelectKindName
       ,Setting.Ratio
       ,Setting.ModelServiceItemChild_FromId
       ,Setting.ModelServiceItemChild_FromDescId
       ,Setting.ModelServiceItemChild_FromName
       ,Setting.ModelServiceItemChild_ToId
       ,Setting.ModelServiceItemChild_ToDescId
       ,Setting.ModelServiceItemChild_ToName
       , tmpOperDate.OperDate :: TDateTime
       , COALESCE (Movement_SheetGroup.Count_Member, Movement_Sheet.Count_MemberInDay) :: Integer
       , ServiceModelMovement.Gross
       , (ServiceModelMovement.Gross
        / NULLIF (
          CASE WHEN (Movement_Sheet.AmountInDay = 0 OR ServiceModelMovement.Amount = 0) AND Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_DayHoursSheetWorkTime () -- �� ���� + �� ����� ������
                    THEN 0
               WHEN Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_DayHoursSheetWorkTime () -- �� ���� + �� ����� ������
                    THEN Movement_Sheet.AmountInDay / NULLIF (ServiceModelMovement.Amount, 0)
               ELSE COALESCE (Movement_SheetGroup.Count_Member, Movement_Sheet.Count_MemberInDay)
          END, 0)) :: TFloat AS GrossOnOneMember
       , ServiceModelMovement.Amount
       , ROUND (ServiceModelMovement.Amount
              / NULLIF (
                CASE WHEN (Movement_Sheet.AmountInDay = 0 OR ServiceModelMovement.Amount = 0) AND Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_DayHoursSheetWorkTime () -- �� ���� + �� ����� ������
                          THEN 0
                     WHEN Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_DayHoursSheetWorkTime () -- �� ���� + �� ����� ������
                          THEN Movement_Sheet.AmountInDay / NULLIF (ServiceModelMovement.Amount, 0)
                     ELSE COALESCE (Movement_SheetGroup.Count_Member, Movement_Sheet.Count_MemberInDay)
                END, 0)
              , 2) :: TFloat AS AmountOnOneMember
    FROM Setting_Wage_1 AS Setting
         CROSS JOIN tmpOperDate
         LEFT OUTER JOIN Movement_SheetGroup ON COALESCE (Movement_SheetGroup.PositionId, 0)      = COALESCE (Setting.PositionId, 0)
                                            AND COALESCE (Movement_SheetGroup.PositionLevelId, 0) = COALESCE (Setting.PositionLevelId, 0)
                                            AND Setting.ServiceModelKindId                        = zc_Enum_ModelServiceKind_MonthSheetWorkTime() -- �� ����� ������
         LEFT OUTER JOIN Movement_Sheet ON COALESCE (Movement_Sheet.PositionId, 0)      = COALESCE (Setting.PositionId, 0)
                                       AND COALESCE (Movement_Sheet.PositionLevelId, 0) = COALESCE (Setting.PositionLevelId, 0)
                                       AND Movement_Sheet.OperDate                      = tmpOperDate.OperDate
                                       AND (COALESCE (Movement_Sheet.MemberId, 0)       = Movement_SheetGroup.MemberId OR Movement_SheetGroup.MemberId IS NULL)

        LEFT OUTER JOIN ServiceModelMovement ON COALESCE (Setting.StaffListId, 0)                  = COALESCE (ServiceModelMovement.StaffListId, 0)
                                            AND COALESCE (Setting.UnitId, 0)                       = COALESCE (ServiceModelMovement.UnitId, 0)
                                            AND COALESCE (Setting.PositionId, 0)                   = COALESCE (ServiceModelMovement.PositionId, 0)
                                            AND COALESCE (Setting.PositionLevelId, 0)              = COALESCE (ServiceModelMovement.PositionLevelId, 0)
                                            AND COALESCE (Setting.ServiceModelId, 0)               = COALESCE (ServiceModelMovement.ServiceModelId, 0)
                                            AND COALESCE (Setting.Price, 0)                        = COALESCE (ServiceModelMovement.Price, 0)
                                            AND COALESCE (Setting.FromId, 0)                       = COALESCE (ServiceModelMovement.FromId, 0)
                                            AND COALESCE (Setting.ToId, 0)                         = COALESCE (ServiceModelMovement.ToId, 0)
                                            AND COALESCE (Setting.MovementDescId, 0)               = COALESCE (ServiceModelMovement.MovementDescId, 0)
                                            AND COALESCE (Setting.SelectKindId, 0)                 = COALESCE (ServiceModelMovement.SelectKindId, 0)
                                            AND COALESCE (Setting.ModelServiceItemChild_FromId, 0) = COALESCE (ServiceModelMovement.ModelServiceItemChild_FromId, 0)
                                            AND COALESCE (Setting.ModelServiceItemChild_ToId, 0)   = COALESCE (ServiceModelMovement.ModelServiceItemChild_ToId, 0)
                                            AND ServiceModelMovement.OperDate                      = tmpOperDate.OperDate

        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = COALESCE (Movement_SheetGroup.PersonalGroupId, Movement_Sheet.PersonalGroupId)
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_Wage_Model (TDateTime,TDateTime,Integer,Integer,Integer,Integer,TVarChar) OWNER TO postgres;

/*
Select * from gpSelect_Report_Wage_Model(
    inDateStart      := '20150701'::TDateTime, --���� ������ �������
    inDateFinal      := '20150731'::TDateTime, --���� ��������� �������
    inUnitId         := 8448::Integer,   --������������� 
    inModelServiceId := 0::Integer,   --������ ����������
    inMemberId     := 0::Integer,   --���������
    inPositionId     := 0::Integer,   --���������
    inSession        := '5');
*/

-- Function: lpUpdate_Movement_ProductionUnion_Pack (Boolean, TDateTime, TDateTime, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_ProductionUnion_Pack (Boolean, TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ProductionUnion_Pack(
    IN inIsUpdate     Boolean   , --
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- 
    IN inUserId       Integer     -- ������������
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, isDelete Boolean, DescId_mi Integer, MovementItemId Integer, ContainerId Integer
             , OperCount TFloat, OperCount_Weight TFloat, OperCount_two TFloat
             , ReceiptCode_master Integer, ReceiptName_master TVarChar
             , GoodsCode_master Integer, GoodsName_master TVarChar, GoodsKindName_master TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , MovementItemId_master Integer, ContainerId_master Integer
              )
AS
$BODY$
BEGIN
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpresult')
     THEN
         DELETE FROM _tmpResult;
         DELETE FROM _tmpResult_child;
     ELSE
         -- ������� - 
         CREATE TEMP TABLE _tmpResult (MovementId Integer, OperDate TDateTime, MovementItemId Integer, ContainerId Integer, GoodsId Integer, ReceiptId_in Integer, GoodsId_child Integer, DescId_mi Integer, OperCount TFloat, OperCount_Weight TFloat, OperCount_two TFloat, isDelete Boolean) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpResult_child (MovementId Integer, OperDate TDateTime, MovementItemId_master Integer, MovementItemId Integer, ContainerId_master Integer, ContainerId Integer, GoodsId Integer, OperCount TFloat, isDelete Boolean) ON COMMIT DROP;
     END IF;

     -- ������ �� ������/������ "��� ��������" + ��������� MovementItemId (!!!��� zc_MI_Child!!! ����� �� ������������)
     INSERT INTO _tmpResult (MovementId, OperDate, MovementItemId, ContainerId, GoodsId, ReceiptId_in, GoodsId_child, DescId_mi, OperCount, OperCount_Weight, OperCount_two, isDelete)
             WITH tmpUnit AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect -- ������ ���� + ����������
                             UNION
                              SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect -- �������� �����
                             UNION
                              SELECT Object.Id AS UnitId FROM Object WHERE Object.Id = 8452 -- ����� �������
                             )
                , tmpMI AS (-- ��������:
                            SELECT tmp.ContainerId
                                 , tmp.OperDate
                                 , tmp.DescId_mi
                                 , SUM (tmp.OperCount) AS OperCount
                            FROM
                            -- �������� ��������: ������/������
                           (SELECT MIContainer.ContainerId
                                 , MIContainer.OperDate
                                   -- ������ ����� zc_MI_Master() ������ ����� zc_MI_Child
                                 , CASE WHEN MIContainer.isActive = FALSE THEN zc_MI_Master() ELSE zc_MI_Child() END   AS DescId_mi
                                 , SUM (MIContainer.Amount * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS OperCount
                            FROM MovementItemContainer AS MIContainer
                                 INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.AnalyzerId
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.MovementDescId         = zc_Movement_Send()
                            GROUP BY MIContainer.ContainerId
                                   , MIContainer.OperDate
                                   , MIContainer.isActive
                           UNION ALL
                            -- ���� zc_Enum_AnalyzerId_ReWork
                            SELECT MIContainer.ContainerId
                                 , MIContainer.OperDate
                                 , zc_MI_Master() AS DescId_mi
                                 , -1 * SUM (MIContainer.Amount) AS OperCount
                            FROM MovementItemContainer AS MIContainer 
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.AnalyzerId             = zc_Enum_AnalyzerId_ReWork() -- 
                              AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                              AND MIContainer.isActive               = FALSE
                            GROUP BY MIContainer.ContainerId
                                   , MIContainer.OperDate
                           ) AS tmp
                            GROUP BY tmp.ContainerId
                                   , tmp.OperDate
                                   , tmp.DescId_mi
                            HAVING SUM (tmp.OperCount) > 0
                           )
            , tmpMI_all AS (-- ������������ "������������" ��� isAuto = TRUE
                            SELECT MIContainer.MovementId
                                 , MIContainer.ContainerId
                                 , MIContainer.MovementItemId
                                 , MIContainer.OperDate
                                 , CASE WHEN MIContainer.isActive = TRUE THEN zc_MI_Master() ELSE zc_MI_Child() END AS DescId_mi
                            FROM MovementItemContainer AS MIContainer
                                 INNER JOIN MovementBoolean AS MovementBoolean_isAuto ON MovementBoolean_isAuto.MovementId = MIContainer.MovementId
                                                                                     AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                                     AND MovementBoolean_isAuto.ValueData  = TRUE
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.AnalyzerId             = inUnitId
                              AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                           )
          , tmpMovement AS (-- ����� ������ ��������� �� OperDate
                            SELECT tmpMI_all.OperDate
                                 , MAX (tmpMI_all.MovementId) AS MovementId
                            FROM tmpMI_all
                            GROUP BY tmpMI_all.OperDate
                           )
           , tmpMI_find AS (-- ����� ������ ���� �� ��������� ������� � ��-�� (�� ���� ����� Update, ����� Insert, ��������� Delete)
                            SELECT tmpMI_all.ContainerId
                                 , tmpMI_all.OperDate
                                 , MAX (tmpMI_all.MovementItemId) AS MovementItemId
                            FROM tmpMovement
                                 INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMovement.MovementId
                            WHERE tmpMI_all.DescId_mi = zc_MI_Master()
                            GROUP BY tmpMI_all.ContainerId
                                   , tmpMI_all.OperDate
                           )
         , tmpMI_result AS (-- ������ �� ��������� ������� � ��-��
                            SELECT COALESCE (tmpMovement.MovementId, 0)    AS MovementId
                                 , COALESCE (tmpMI_find.MovementItemId, 0) AS MovementItemId
                                 , Container.ObjectId                      AS GoodsId
                                 , COALESCE (CLO_GoodsKind.ObjectId)       AS GoodsKindId
                                 , tmpMI.OperDate
                                 , tmpMI.ContainerId
                                 , tmpMI.DescId_mi
                                 , tmpMI.OperCount
                            FROM tmpMI
                                 LEFT JOIN tmpMovement ON tmpMovement.OperDate = tmpMI.OperDate
                                 LEFT JOIN Container ON Container.Id = tmpMI.ContainerId
                                 LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                               ON CLO_GoodsKind.ContainerId = tmpMI.ContainerId
                                                              AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                 LEFT JOIN tmpMI_find ON tmpMI_find.ContainerId = tmpMI.ContainerId
                                                     AND tmpMI_find.OperDate    = tmpMI.OperDate
                                 LEFT JOIN tmpMI_all ON tmpMI_all.MovementItemId = tmpMI_find.MovementItemId
                            WHERE tmpMI.DescId_mi = zc_MI_Master() -- !!!�.�. ������!!!
                              AND tmpMI.OperCount <> 0
                           )
   , tmpMI_child_result AS (-- ������ �� ��������� ������ �� ��-��
                            SELECT Container.ObjectId                      AS GoodsId
                                 , tmpMI.OperDate
                                 , tmpMI.ContainerId
                                 , tmpMI.DescId_mi
                                 , tmpMI.OperCount
                            FROM tmpMI
                                 LEFT JOIN Container ON Container.Id = tmpMI.ContainerId
                            WHERE tmpMI.DescId_mi = zc_MI_Child()
                              AND tmpMI.OperCount <> 0
                           )
          , tmpMI_list AS (-- ������ ��������� ��������� ������� � ��-��
                            SELECT tmpMI_result.MovementId, 0                           AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementId     <> 0
                      UNION SELECT 0         AS MovementId, tmpMI_result.MovementItemId AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementItemId <> 0
                           )
            , tmpReceipt AS (-- ����� ��������
                             SELECT tmpGoods.GoodsId
                                  , tmpGoods.GoodsKindId
                                  , MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                             FROM (SELECT tmpMI_result.GoodsId, tmpMI_result.GoodsKindId FROM tmpMI_result GROUP BY tmpMI_result.GoodsId, tmpMI_result.GoodsKindId) AS tmpGoods
                                  INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                        ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                       AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                  INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                        ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                       AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                       AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpGoods.GoodsKindId
                                  INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                     AND Object_Receipt.isErased = FALSE
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                           ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                          AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                          AND ObjectBoolean_Main.ValueData = TRUE
                             GROUP BY tmpGoods.GoodsId
                                    , tmpGoods.GoodsKindId
                            )

          -- ���������:
          -- �������� ������� � ��-��
          SELECT tmpMI_result.MovementId
               , tmpMI_result.OperDate
               , tmpMI_result.MovementItemId
               , tmpMI_result.ContainerId
               , tmpMI_result.GoodsId
               , COALESCE (tmpReceipt.ReceiptId, 0)                                             AS ReceiptId_in
               , COALESCE (ObjectLink_Receipt_Goods_parent.ChildObjectId, tmpMI_result.GoodsId) AS GoodsId_child
               , tmpMI_result.DescId_mi
               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN tmpMI_result.OperCount - COALESCE (tmpMI_child_result.OperCount, 0) ELSE 0 END AS OperCount
               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN tmpMI_result.OperCount - COALESCE (tmpMI_child_result.OperCount, 0) ELSE 0 END
               * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS OperCount_Weight
               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN COALESCE (tmpMI_child_result.OperCount, 0) ELSE tmpMI_result.OperCount END AS OperCount_two
               , FALSE AS isDelete
          FROM tmpMI_result
               LEFT JOIN tmpMI_child_result ON tmpMI_child_result.ContainerId = tmpMI_result.ContainerId
                                           AND tmpMI_child_result.OperDate    = tmpMI_result.OperDate
               LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId = tmpMI_result.GoodsId
                                   AND tmpReceipt.GoodsKindId = tmpMI_result.GoodsKindId
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                    ON ObjectLink_Receipt_Parent.ObjectId = tmpReceipt.ReceiptId
                                   AND ObjectLink_Receipt_Parent.DescId   = zc_ObjectLink_Receipt_Parent()
               LEFT JOIN Object AS Object_Receipt_parent ON Object_Receipt_parent.Id       = ObjectLink_Receipt_Parent.ChildObjectId
                                                        AND Object_Receipt_parent.isErased = FALSE
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                     ON ObjectLink_Receipt_Goods_parent.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                    AND ObjectLink_Receipt_Goods_parent.DescId   = zc_ObjectLink_Receipt_Goods()
                                    AND ObjectLink_Receipt_Goods_parent.ChildObjectId > 0

               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_result.GoodsId
                                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
               LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                     ON ObjectFloat_Weight.ObjectId = tmpMI_result.GoodsId
                                    AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
         UNION ALL
          -- ������ ��� "�����" ������� (����������� �����)
          SELECT 0 AS MovementId
               , tmpMI_child_result.OperDate
               , 0 AS MovementItemId
               , tmpMI_child_result.ContainerId
               , tmpMI_child_result.GoodsId
               , 0 AS ReceiptId_in    -- �� �����
               , 0 AS GoodsId_child   -- �� �����
               , tmpMI_child_result.DescId_mi
               , CASE WHEN tmpMI_child_result.OperCount > COALESCE (tmpMI_result.OperCount, 0) THEN tmpMI_child_result.OperCount - COALESCE (tmpMI_result.OperCount, 0) ELSE 0 END AS OperCount
               , 0 AS OperCount_Weight -- �� �����
               , tmpMI_child_result.OperCount AS OperCount_two -- ������������, ��� �����
               , FALSE AS isDelete
          FROM tmpMI_child_result
               LEFT JOIN tmpMI_result ON tmpMI_result.ContainerId = tmpMI_child_result.ContainerId
                                     AND tmpMI_result.OperDate    = tmpMI_child_result.OperDate

         UNION ALL
          -- ������ ��� ������������ ������� (����������� �����)
          SELECT tmpMI_all.MovementId
               , tmpMI_all.OperDate
               , tmpMI_all.MovementItemId
               , tmpMI_all.ContainerId
               , 0 AS GoodsId         -- �� �����
               , 0 AS ReceiptId_in    -- �� �����
               , 0 AS GoodsId_child   -- �� �����
               , tmpMI_all.DescId_mi
               , 0 AS OperCount            -- �� �����
               , 0 AS OperCount_Weight     -- �� �����
               , 0 AS OperCount_two        -- �� �����
               , FALSE AS isDelete
          FROM tmpMI_all
          WHERE tmpMI_all.DescId_mi = zc_MI_Child()
         UNION
          -- ��������� ������� ���� �������
          SELECT tmpMI_all.MovementId
               , zc_DateStart() AS OperDate
               , 0 AS MovementItemId
               , 0 AS ContainerId
               , 0 AS GoodsId
               , 0 AS ReceiptId_in
               , 0 AS GoodsId_child
               , tmpMI_all.DescId_mi
               , 0 AS OperCount
               , 0 AS OperCount_Weight
               , 0 AS OperCount_two
               , TRUE AS isDelete
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementId = tmpMI_all.MovementId
          WHERE tmpMI_all.DescId_mi = zc_MI_Master() -- !!!������ ��� zc_MI_Master!!!
            AND tmpMI_list.MovementId IS NULL
         UNION
          -- �������� ������� ���� �������
          SELECT tmpMI_all.MovementId     AS MovementId
               , zc_DateStart()           AS OperDate
               , tmpMI_all.MovementItemId AS MovementItemId
               , 0 AS ContainerId
               , 0 AS GoodsId
               , 0 AS ReceiptId_in
               , 0 AS GoodsId_child
               , tmpMI_all.DescId_mi
               , 0 AS OperCount
               , 0 AS OperCount_Weight
               , 0 AS OperCount_two
               , TRUE AS isDelete
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementItemId = tmpMI_all.MovementItemId
          WHERE tmpMI_all.DescId_mi = zc_MI_Master() -- !!!������ ��� zc_MI_Master!!!
            AND tmpMI_list.MovementItemId IS NULL
         ;



     -- ������
     INSERT INTO _tmpResult_child (MovementId, OperDate, MovementItemId_master, MovementItemId, ContainerId_master, ContainerId, GoodsId, OperCount, isDelete)
       WITH tmpResult_MI_all AS (-- ������� ParentId ���� ������������ ��������� ������� �� ��-��
                                 SELECT _tmpResult.*, MovementItem.ParentId
                                 FROM _tmpResult
                                      INNER JOIN MovementItem ON MovementItem.Id = _tmpResult.MovementItemId
                                 WHERE _tmpResult.DescId_mi = zc_MI_Child()
                                   AND _tmpResult.MovementItemId > 0
                                )
       , tmpResult_MI_find_all AS (-- �������� ������ 1-� ��� ������� ContainerId + ParentId
                                   SELECT tmpResult_MI_all.ContainerId, MAX (tmpResult_MI_all.MovementItemId) AS MovementItemId
                                   FROM tmpResult_MI_all
                                   GROUP BY tmpResult_MI_all.ContainerId, tmpResult_MI_all.ParentId
                                  )
           , tmpResult_MI_find AS (-- �������� ��� ��������� ��� ���������
                                   SELECT tmpResult_MI_all.*
                                   FROM tmpResult_MI_find_all
                                        LEFT JOIN tmpResult_MI_all ON tmpResult_MI_all.MovementItemId = tmpResult_MI_find_all.MovementItemId
                                  )

          , tmpResult_master AS (-- ����� ������, ������� ����� � zc_MI_Master
                                 SELECT _tmpResult.* FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND (_tmpResult.OperCount + _tmpResult.OperCount_two) > 0)
           , tmpResult_child AS (-- ����� ������, ������� ����� � zc_MI_Child
                                 SELECT _tmpResult.* FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Child()  AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount > 0)

          , tmpAll AS (-- ������ zc_MI_Master, ���� ����� �������� �� ��������� "�������" �������
                       SELECT tmpResult_master.OperDate, tmpResult_master.GoodsId, tmpResult_master.GoodsId_child            FROM tmpResult_master WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0 GROUP BY tmpResult_master.OperDate, tmpResult_master.GoodsId, tmpResult_master.GoodsId_child
                      UNION
                       -- ������ zc_MI_Master, ��� ����� �������� �� ����� ����
                       SELECT tmpResult_master.OperDate, tmpResult_master.GoodsId, tmpResult_master.GoodsId AS GoodsId_child FROM tmpResult_master WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0 GROUP BY tmpResult_master.OperDate, tmpResult_master.GoodsId
                      )
          , tmpAll_total AS (-- ���� �� ������� zc_MI_Master, ���� �� ������� ��� "�� ���� ����� ��������"
                             SELECT tmpResult_master.OperDate, tmpAll.GoodsId_child, SUM (tmpResult_master.OperCount_Weight) AS OperCount_Weight
                             FROM tmpAll
                                  INNER JOIN tmpResult_master ON tmpResult_master.GoodsId = tmpAll.GoodsId AND tmpResult_master.OperDate = tmpAll.OperDate
                             GROUP BY tmpResult_master.OperDate, tmpAll.GoodsId_child
                            )
                              
          , tmpResult_new AS (-- ��������� - ������������� + ����� �� ������������ MovementItemId
                              SELECT tmpResult_MI_find.MovementId     AS MovementId
                                   , tmpResult_child.OperDate         AS OperDate
                                   , tmpResult_master.MovementItemId  AS MovementItemId_master
                                   , tmpResult_master.ContainerId     AS ContainerId_master
                                   , tmpResult_MI_find.MovementItemId AS MovementItemId
                                   , tmpResult_child.ContainerId      AS ContainerId
                                   , tmpResult_child.GoodsId          AS GoodsId
                                   , CASE WHEN tmpAll_total.OperCount_Weight = 0 THEN tmpResult_child.OperCount ELSE CAST (tmpResult_child.OperCount * tmpResult_master.OperCount_Weight / tmpAll_total.OperCount_Weight AS NUMERIC(16, 4)) END AS OperCount
                                   , FALSE AS isPeresort
                              FROM tmpResult_child
                                   INNER JOIN tmpAll_total     ON tmpAll_total.GoodsId_child     = tmpResult_child.GoodsId
                                                              AND tmpAll_total.OperDate          = tmpResult_child.OperDate
                                   INNER JOIN tmpAll           ON tmpAll.GoodsId_child           = tmpAll_total.GoodsId_child
                                                              AND tmpAll.OperDate                = tmpAll_total.OperDate
                                   INNER JOIN tmpResult_master ON tmpResult_master.GoodsId       = tmpAll.GoodsId
                                                              AND tmpResult_master.OperDate      = tmpAll.OperDate
                                                              -- AND tmpResult_master.OperCount     <> 0 
                                   LEFT JOIN tmpResult_MI_find ON tmpResult_MI_find.ParentId    = tmpResult_master.MovementItemId
                                                              AND tmpResult_MI_find.ContainerId = tmpResult_child.ContainerId
                             UNION ALL
                              -- ��������� "�����������" + ����� �� ������������ MovementItemId
                              SELECT tmpResult_MI_find.MovementId     AS MovementId
                                   , tmpResult_master.OperDate        AS OperDate
                                   , tmpResult_master.MovementItemId  AS MovementItemId_master
                                   , tmpResult_master.ContainerId     AS ContainerId_master
                                   , tmpResult_MI_find.MovementItemId AS MovementItemId
                                   , tmpResult_master.ContainerId     AS ContainerId
                                   , tmpResult_master.GoodsId         AS GoodsId
                                   , tmpResult_master.OperCount_two   AS OperCount
                                   , TRUE AS isPeresort
                              FROM tmpResult_master
                                   LEFT JOIN tmpResult_MI_find ON tmpResult_MI_find.ParentId    = tmpResult_master.MovementItemId
                                                              AND tmpResult_MI_find.ContainerId = tmpResult_master.ContainerId
                              WHERE tmpResult_master.OperCount_two > 0
                             )
         , tmpResult_diff AS (-- ���� - ������� ���������� ����������� �� "�������" ����� �������������
                              SELECT tmpResult_child.OperDate                  AS OperDate
                                   , tmpResult_child.ContainerId               AS ContainerId
                                   , tmpResult_child.OperCount - tmp.OperCount AS OperCount
                              FROM (SELECT tmpResult_new.OperDate, tmpResult_new.ContainerId, SUM (tmpResult_new.OperCount) AS OperCount FROM tmpResult_new WHERE tmpResult_new.isPeresort = FALSE GROUP BY tmpResult_new.OperDate, tmpResult_new.ContainerId) AS tmp
                                   INNER JOIN tmpResult_child  ON tmpResult_child.ContainerId     = tmp.ContainerId
                                                              AND tmpResult_child.OperDate        = tmp.OperDate
                              WHERE tmp.OperCount <> tmpResult_child.OperCount
                             )
    , tmpResult_diff_find AS (-- ������� ��� "�����������" ����� ContainerId: ������� � MAX (OperCount) ����� MAX (ContainerId_master)
                              SELECT tmp.OperDate                           AS OperDate
                                   , tmp.ContainerId                        AS ContainerId
                                   , MAX (tmpResult_new.ContainerId_master) AS ContainerId_master
                              FROM (SELECT tmpResult_diff.OperDate, tmpResult_diff.ContainerId, MAX (tmpResult_new.OperCount) AS OperCount
                                    FROM tmpResult_diff
                                         INNER JOIN tmpResult_new ON tmpResult_new.ContainerId =  tmpResult_diff.ContainerId
                                    GROUP BY tmpResult_diff.OperDate, tmpResult_diff.ContainerId
                                   ) AS tmp
                                   INNER JOIN tmpResult_new ON tmpResult_new.OperDate    =  tmp.OperDate
                                                           AND tmpResult_new.ContainerId =  tmp.ContainerId
                                                           AND tmpResult_new.OperCount   =  tmp.OperCount
                              GROUP BY tmp.OperDate, tmp.ContainerId
                             )
          -- ��������
          SELECT tmpResult_new.MovementId
               , tmpResult_new.OperDate
               , tmpResult_new.MovementItemId_master
               , tmpResult_new.MovementItemId
               , tmpResult_new.ContainerId_master
               , tmpResult_new.ContainerId
               , tmpResult_new.GoodsId
               , SUM (tmpResult_new.OperCount + COALESCE (tmpResult_diff.OperCount, 0)) AS OperCount
               , FALSE AS isDelete
          FROM tmpResult_new
               LEFT JOIN tmpResult_diff_find ON tmpResult_diff_find.OperDate           = tmpResult_new.OperDate
                                            AND tmpResult_diff_find.ContainerId_master = tmpResult_new.ContainerId_master
                                            AND tmpResult_diff_find.ContainerId = tmpResult_new.ContainerId
                                            AND tmpResult_new.isPeresort = FALSE
               LEFT JOIN tmpResult_diff ON tmpResult_diff.OperDate    = tmpResult_diff_find.OperDate
                                       AND tmpResult_diff.ContainerId = tmpResult_diff_find.ContainerId
          GROUP BY tmpResult_new.MovementId
                 , tmpResult_new.OperDate
                 , tmpResult_new.MovementItemId_master
                 , tmpResult_new.MovementItemId
                 , tmpResult_new.ContainerId_master
                 , tmpResult_new.ContainerId
                 , tmpResult_new.GoodsId
         UNION ALL
          -- �������� ������� ���� �������
          SELECT tmpResult_MI_all.MovementId
               , zc_DateStart() AS OperDate
               , 0 AS MovementItemId_master
               , tmpResult_MI_all.MovementItemId
               , 0 AS ContainerId_master
               , 0 AS ContainerId
               , 0 AS GoodsId
               , 0 AS OperCount
               , TRUE AS isDelete
          FROM tmpResult_MI_all
               LEFT JOIN tmpResult_new ON tmpResult_new.MovementItemId = tmpResult_MI_all.MovementItemId
          WHERE tmpResult_new.MovementItemId IS NULL
      ;


     -- !!!�� ������!!!
     IF inIsUpdate = TRUE
     THEN

     -- �������� - �������� - Master
     IF EXISTS (SELECT 1 FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount + _tmpResult.OperCount_two < 0)
     THEN
         RAISE EXCEPTION 'Error. Master.Amount < 0 : (%) <%>  <%> Amount = <%> + <%> Count = <%> <%>'
                               , (SELECT _tmpResult.ContainerId   FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount + _tmpResult.OperCount_two < 0 ORDER BY _tmpResult.GoodsId LIMIT 1)
                               , lfGet_Object_ValueData ((SELECT _tmpResult.GoodsId FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount + _tmpResult.OperCount_two < 0 ORDER BY _tmpResult.GoodsId LIMIT 1))
                               , lfGet_Object_ValueData ((SELECT CLO_GoodsKind.ObjectId FROM _tmpResult LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind() WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount + _tmpResult.OperCount_two < 0 ORDER BY _tmpResult.GoodsId LIMIT 1))
                               , (SELECT _tmpResult.OperCount     FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount + _tmpResult.OperCount_two < 0 ORDER BY _tmpResult.GoodsId LIMIT 1)
                               , (SELECT _tmpResult.OperCount_two FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount + _tmpResult.OperCount_two < 0 ORDER BY _tmpResult.GoodsId LIMIT 1)
                               , (SELECT COUNT (*) FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount + _tmpResult.OperCount_two < 0)
                               , DATE (inStartDate)
                                ;
     END IF;
     -- �������� - �������� - Child
     IF EXISTS (SELECT 1 FROM _tmpResult_child WHERE _tmpResult_child.isDelete = FALSE AND _tmpResult_child.OperCount < 0)
     THEN
         RAISE EXCEPTION 'Error. Child.Amount < 0 : (%) <%>  <%> Amount = <%> Count = <%> <%>'
                               , (SELECT _tmpResult_child.ContainerId FROM _tmpResult_child WHERE _tmpResult_child.isDelete = FALSE AND _tmpResult_child.OperCount < 0 ORDER BY _tmpResult_child.GoodsId LIMIT 1)
                               , lfGet_Object_ValueData ((SELECT _tmpResult_child.GoodsId FROM _tmpResult_child WHERE _tmpResult_child.isDelete = FALSE AND _tmpResult_child.OperCount < 0 ORDER BY _tmpResult_child.GoodsId LIMIT 1))
                               , lfGet_Object_ValueData ((SELECT CLO_GoodsKind.ObjectId FROM _tmpResult_child LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpResult_child.ContainerId AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind() WHERE _tmpResult_child.isDelete = FALSE AND _tmpResult_child.OperCount < 0 ORDER BY _tmpResult_child.GoodsId LIMIT 1))
                               , (SELECT _tmpResult_child.OperCount   FROM _tmpResult_child WHERE _tmpResult_child.isDelete = FALSE AND _tmpResult_child.OperCount < 0 ORDER BY _tmpResult_child.GoodsId LIMIT 1)
                               , (SELECT COUNT (*) FROM _tmpResult_child WHERE _tmpResult_child.isDelete = FALSE AND _tmpResult_child.OperCount < 0)
                               , DATE (inStartDate)
                                ;
     END IF;

     -- �����������
     PERFORM lpUnComplete_Movement (inMovementId     := tmp.MovementId
                                  , inUserId         := inUserId)
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.MovementId <> 0 GROUP BY _tmpResult.MovementId) AS tmp
          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete();

     -- ��������� ��������� !!!����� MovementItemId = 0!!!
     PERFORM lpSetErased_Movement (inMovementId:= tmp.MovementId
                                 , inUserId    := inUserId
                                  )
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = TRUE AND _tmpResult.MovementId <> 0 AND _tmpResult.MovementItemId = 0 GROUP BY _tmpResult.MovementId) AS tmp
    ;
     -- ��������� �������� - Master
     PERFORM lpSetErased_MovementItem (inMovementItemId:= _tmpResult.MovementItemId
                                     , inUserId        := inUserId
                                      )
     FROM _tmpResult
          LEFT JOIN _tmpResult AS _tmpResult_movement ON _tmpResult_movement.MovementId     = _tmpResult.MovementId
                                                     AND _tmpResult_movement.isDelete       = TRUE
                                                     AND _tmpResult_movement.MovementItemId = 0 -- !!!����� MovementItemId = 0!!!
     WHERE _tmpResult.isDelete = TRUE AND _tmpResult.MovementItemId <> 0
       AND _tmpResult_movement.MovementId IS NULL -- �.�. ������ �� ������� �� ������ � �������� ����������
    ;
     -- ��������� �������� - Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= _tmpResult_child.MovementItemId
                                     , inUserId        := inUserId
                                      )
     FROM _tmpResult_child
          LEFT JOIN _tmpResult AS _tmpResult_movement ON _tmpResult_movement.MovementId     = _tmpResult_child.MovementId
                                                     AND _tmpResult_movement.isDelete       = TRUE
                                                     AND _tmpResult_movement.MovementItemId = 0 -- !!!����� MovementItemId = 0!!!
     WHERE _tmpResult_child.isDelete = TRUE -- AND _tmpResult_child.MovementItemId <> 0
       AND _tmpResult_movement.MovementId IS NULL -- �.�. ������ �� ������� �� ������ � �������� ����������
    ;

     -- ��������� ��������� - <������������ ����������>
     UPDATE _tmpResult SET MovementId = CASE WHEN _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE THEN tmp.MovementId ELSE _tmpResult.MovementId END -- !!!����� InsertUpdate_Movement ��� ������ ������!!!
     FROM (SELECT tmp.OperDate
                , lpInsertUpdate_Movement_ProductionUnion (ioId                    := 0
                                                         , inInvNumber             := CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar)
                                                         , inOperDate              := tmp.OperDate
                                                         , inFromId                := inUnitId
                                                         , inToId                  := inUnitId
                                                         , inDocumentKindId        := 0
                                                         , inIsPeresort            := FALSE
                                                         , inUserId                := inUserId
                                                          ) AS MovementId
           FROM (SELECT _tmpResult.OperDate
                 FROM _tmpResult
                 WHERE _tmpResult.MovementId = 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE
                 GROUP BY _tmpResult.OperDate
                 ) AS tmp
          ) AS tmp
     WHERE _tmpResult.OperDate = tmp.OperDate
       AND _tmpResult.MovementId = 0
       -- AND _tmpResult.DescId_mi = zc_MI_Master() -- !!!����� InsertUpdate_Movement ��� ������ ������!!!
       -- AND _tmpResult.isDelete = FALSE           -- !!!����� InsertUpdate_Movement ��� ������ ������!!!
    ;


    -- ��������
    -- IF EXISTS (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
    IF 1 <> (SELECT COUNT(*) FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp)
    THEN RAISE EXCEPTION 'Error.Many find MovementId: Date = <%>  Min = <%>  Max = <%> Count = <%>', (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp
                                                                               WHERE tmp.OperDate IN (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
                                                                                                      ORDER BY tmp.OperDate LIMIT 1)
                                                                                                   , (SELECT tmp.MovementId FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp
                                                                               WHERE tmp.OperDate IN (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
                                                                                                      ORDER BY tmp.OperDate, tmp.MovementId LIMIT 1)
                                                                                                   , (SELECT tmp.MovementId FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp
                                                                               WHERE tmp.OperDate IN (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
                                                                                                      ORDER BY tmp.OperDate, tmp.MovementId DESC LIMIT 1)
                                                                                                   , (SELECT COUNT(*) FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp
                                                                               WHERE tmp.OperDate IN (SELECT tmp.OperDate FROM (SELECT _tmpResult.MovementId, _tmpResult.OperDate FROM _tmpResult WHERE _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE GROUP BY _tmpResult.MovementId, _tmpResult.OperDate) AS tmp GROUP BY tmp.OperDate HAVING COUNT(*) > 1)
                                                                                                     )
        ;
    END IF;

     -- ����������� �������� - Master
     UPDATE _tmpResult SET MovementItemId = lpInsertUpdate_MI_ProductionUnion_Master
                                                  (ioId                     := _tmpResult.MovementItemId
                                                 , inMovementId             := _tmpResult.MovementId
                                                 , inGoodsId                := _tmpResult.GoodsId
                                                 , inAmount                 := _tmpResult.OperCount + _tmpResult.OperCount_two
                                                 , inCount                  := 0
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := tmp.GoodsKindId
                                                 , inUserId                 := inUserId
                                                  )
     FROM (SELECT _tmpResult.ContainerId, CLO_GoodsKind.ObjectId AS GoodsKindId
           FROM _tmpResult
                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                              ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
           WHERE _tmpResult.DescId_mi   = zc_MI_Master()
             AND _tmpResult.isDelete    = FALSE
           GROUP BY _tmpResult.ContainerId, CLO_GoodsKind.ObjectId
          ) AS tmp
     WHERE _tmpResult.ContainerId = tmp.ContainerId
       AND _tmpResult.DescId_mi   = zc_MI_Master()
       AND _tmpResult.isDelete    = FALSE;


     -- ����������� �������� - Child �� �������������
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child
                                                  (ioId                     := _tmpResult_child.MovementItemId
                                                 , inMovementId             := _tmpResult.MovementId
                                                 , inGoodsId                := _tmpResult_child.GoodsId
                                                 , inAmount                 := _tmpResult_child.OperCount
                                                 , inParentId               := _tmpResult.MovementItemId
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                 , inGoodsKindCompleteId    := NULL
                                                 , inCount_onCount          := 0
                                                 , inUserId                 := inUserId
                                                  )
     FROM _tmpResult_child
          LEFT JOIN _tmpResult ON _tmpResult.ContainerId = _tmpResult_child.ContainerId_master
                              AND _tmpResult.OperDate    = _tmpResult_child.OperDate
                              AND _tmpResult.DescId_mi   = zc_MI_Master()
                              AND _tmpResult.isDelete    = FALSE
          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                        ON CLO_GoodsKind.ContainerId = _tmpResult_child.ContainerId
                                       AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
     WHERE _tmpResult_child.isDelete    = FALSE;

     -- ����������� �������� - Child �� �������
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child
                                                  (ioId                     := 0
                                                 , inMovementId             := _tmpResult.MovementId
                                                 , inGoodsId                := ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                 , inAmount                 := (_tmpResult.OperCount + _tmpResult.OperCount_two) * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData
                                                 , inParentId               := _tmpResult.MovementItemId
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                 , inGoodsKindCompleteId    := NULL
                                                 , inCount_onCount          := 0
                                                 , inUserId                 := inUserId
                                                  )
     FROM _tmpResult
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = _tmpResult.ReceiptId_in
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                   ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = _tmpResult.ReceiptId_in
                                                  AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND Object_InfoMoney_View.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_30000()             -- ������
                                                              AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����

     WHERE _tmpResult.DescId_mi   = zc_MI_Master()
       AND _tmpResult.isDelete    = FALSE;

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
     -- !!!�������� �� �� �Ѩ!!!
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := tmp.MovementId
                                                , inIsHistoryCost  := TRUE
                                                , inUserId         := inUserId)
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() GROUP BY _tmpResult.MovementId) AS tmp
          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
    ;

     END IF; -- if inIsUpdate = TRUE -- !!!�.�. �� ������!!!


    IF inUserId = zfCalc_UserAdmin() :: Integer
    THEN

    -- ���������
    RETURN QUERY
    SELECT _tmpResult.MovementId
         , _tmpResult.OperDate
         , Movement.InvNumber
         , _tmpResult.isDelete
         , _tmpResult.DescId_mi
         , _tmpResult.MovementItemId, _tmpResult.ContainerId
         , _tmpResult.OperCount
         , _tmpResult.OperCount_Weight
         , _tmpResult.OperCount_two
         , Object_Receipt_master.ObjectCode AS ReceiptCode_master
         , Object_Receipt_master.ValueData  AS ReceiptName_master
         , Object_Goods_master.ObjectCode AS GoodsCode_master
         , Object_Goods_master.ValueData  AS GoodsName_master
         , NULL :: TVarChar AS GoodsKindName_master

         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData  AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
         , 0 AS MovementItemId_master
         , 0 AS ContainerId_master

    FROM _tmpResult
         LEFT JOIN Movement ON Movement.Id = _tmpResult.MovementId
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpResult.GoodsId
         LEFT JOIN Object AS Object_Goods_master ON Object_Goods_master.Id = _tmpResult.GoodsId_child
         LEFT JOIN Object AS Object_Receipt_master ON Object_Receipt_master.Id = _tmpResult.ReceiptId_in
         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                       ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                      AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = CLO_GoodsKind.ObjectId
   UNION ALL
    SELECT _tmpResult.MovementId
         , _tmpResult.OperDate
         , Movement.InvNumber
         , _tmpResult_child.isDelete
         , -1 AS DescId_mi
         , _tmpResult_child.MovementItemId, _tmpResult_child.ContainerId
         , _tmpResult_child.OperCount
         , _tmpResult.OperCount_Weight
         , _tmpResult.OperCount_two
         , Object_Receipt_master.ObjectCode AS ReceiptCode_master
         , Object_Receipt_master.ValueData  AS ReceiptName_master
         , Object_Goods_master.ObjectCode AS GoodsCode_master
         , Object_Goods_master.ValueData  AS GoodsName_master
         , Object_GoodsKind_master.ValueData AS GoodsKindName_master
         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData  AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
         , _tmpResult_child.MovementItemId_master
         , _tmpResult_child.ContainerId_master
    FROM _tmpResult_child
         LEFT JOIN _tmpResult ON _tmpResult.ContainerId = _tmpResult_child.ContainerId_master
                             AND _tmpResult.DescId_mi   = zc_MI_Master()
                             AND _tmpResult.OperDate    = _tmpResult_child.OperDate
                             AND _tmpResult.isDelete    = FALSE

         LEFT JOIN Movement ON Movement.Id = _tmpResult.MovementId
         LEFT JOIN Object AS Object_Goods_master ON Object_Goods_master.Id = _tmpResult.GoodsId
         LEFT JOIN Object AS Object_Receipt_master ON Object_Receipt_master.Id = _tmpResult.ReceiptId_in
         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind_master
                                       ON CLO_GoodsKind_master.ContainerId = _tmpResult.ContainerId
                                      AND CLO_GoodsKind_master.DescId = zc_ContainerLinkObject_GoodsKind()
         LEFT JOIN Object AS Object_GoodsKind_master ON Object_GoodsKind_master.Id = CLO_GoodsKind_master.ObjectId

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpResult_child.GoodsId
         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                       ON CLO_GoodsKind.ContainerId = _tmpResult_child.ContainerId
                                      AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = CLO_GoodsKind.ObjectId
    ;
    END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.15                                        *
*/

-- ����
-- select * from lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '04.05.2016', inEndDate:= '04.05.2016', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer)

-- where ContainerId = 568111
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= FALSE, inStartDate:= '04.05.2016', inEndDate:= '04.05.2016', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- ��� ��������
-- where ContainerId = 119808 119834 -- select * from MovementItemContainer where MovementItemId = 50132454 
-- where (DescId_mi < 0 and GoodsCode in (101, 2207)) or (DescId_mi IN (  1,  zc_MI_Child())   and (GoodsCode in (101, 2207) or GoodsCode_master = 101))
-- where GoodsCode in (101, 2207) or GoodsCode_master in (101, 2207)
-- order by DescId_mi desc, GoodsName_master, GoodsKindName_master, GoodsName, GoodsKindName, OperDate


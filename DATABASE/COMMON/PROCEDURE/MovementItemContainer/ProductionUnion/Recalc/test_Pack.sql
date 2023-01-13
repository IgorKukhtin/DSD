
     -- ������ �� ������/������ "��� ��������" + ��������� MovementItemId (!!!��� zc_MI_Child!!! ����� �� ������������)
     
             WITH tmpUnit AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect -- ������ ���� + ����������
                             UNION
                              SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect -- �������� �����
                             UNION
                              SELECT Object.Id AS UnitId FROM Object WHERE Object.Id = 8452 -- ����� �������
                             )
              , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                             FROM Object_InfoMoney_View AS View_InfoMoney
                                   JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                                  AND ObjectLink_Goods_InfoMoney.ChildObjectId = View_InfoMoney.InfoMoneyId
                             WHERE View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                                                                           , zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                                                                           , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                            )
                               AND View_InfoMoney.InfoMoneyId <> zc_Enum_InfoMoney_30102() -- �������
                             )
                , tmpMI AS (-- ��������:
                            SELECT tmp.ContainerId
                                 , tmp.OperDate
                                 , tmp.DescId_mi
                                 , SUM (tmp.OperCount) AS OperCount

                            FROM  -- �������� ��������: ������/������
                                 (SELECT MIContainer.ContainerId
                                       , MIContainer.OperDate
                                         -- ������ ����� zc_MI_Master() ������ ����� zc_MI_Child
                                       , CASE WHEN MIContainer.isActive = FALSE THEN zc_MI_Master() ELSE zc_MI_Child() END   AS DescId_mi
                                       , SUM (MIContainer.Amount * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS OperCount
                                  FROM MovementItemContainer AS MIContainer
                                       INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.ObjectExtId_Analyzer
                                       INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.OperDate BETWEEN '10.12.2022' AND '10.12.2022'
                                    AND MIContainer.DescId                 = zc_MIContainer_Count()
                                    AND MIContainer.WhereObjectId_Analyzer = 8451 -- inUnitId
                                    AND MIContainer.MovementDescId         = zc_Movement_Send()
                                  GROUP BY MIContainer.ContainerId
                                         , MIContainer.OperDate
                                         , MIContainer.isActive
                                 UNION ALL
                                  -- �������� ��������: ������/������ - !!!�������� �������!!!
                                  SELECT MIContainer.ContainerId
                                       , MIContainer.OperDate
                                         -- ������ ����� zc_MI_Master() ������ ����� zc_MI_Child
                                       , CASE WHEN MIContainer.isActive = FALSE THEN zc_MI_Master() ELSE zc_MI_Child() END   AS DescId_mi
                                       , SUM (MIContainer.Amount * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS OperCount
                                  FROM MovementItemContainer AS MIContainer 
                                       INNER JOIN MovementLinkObject AS MLO_DocumentKind
                                                                     ON MLO_DocumentKind.MovementId = MIContainer.MovementId
                                                                    AND MLO_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
                                                                    AND MLO_DocumentKind.ObjectId   > 0
                                       INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                       LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                                                 ON MovementBoolean_isAuto.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                AND MovementBoolean_isAuto.ValueData  = TRUE
                                  WHERE MIContainer.OperDate BETWEEN '10.12.2022' AND '10.12.2022'
                                    AND MIContainer.DescId                 = zc_MIContainer_Count()
                                    AND MIContainer.WhereObjectId_Analyzer = 8451 -- inUnitId
                                    AND MIContainer.ObjectExtId_Analyzer   = 8451 -- inUnitId
                                    AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                                    AND MovementBoolean_isAuto.MovementId  IS NULL
                                  GROUP BY MIContainer.ContainerId
                                         , MIContainer.OperDate
                                         , MIContainer.isActive
                                 UNION ALL
                                  -- ���� ������������ ��� ����������� - � zc_MI_Child
                                  SELECT MIContainer.ContainerId
                                       , MIContainer.OperDate
                                       , zc_MI_Child() AS DescId_mi
                                       , SUM (MIContainer.Amount) AS OperCount
                                  FROM MovementItemContainer AS MIContainer 
                                       INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.OperDate BETWEEN '10.12.2022' AND '10.12.2022'
                                    AND MIContainer.DescId                 = zc_MIContainer_Count()
                                    AND MIContainer.WhereObjectId_Analyzer = 8451 -- inUnitId
                                    -- AND MIContainer.ObjectExtId_Analyzer   <> inUnitId -- �� ���� ������
                                    AND MIContainer.ObjectExtId_Analyzer   = 981821 -- ��� �����. ����
                                    AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                                    AND MIContainer.isActive               = TRUE
                                  GROUP BY MIContainer.ContainerId
                                         , MIContainer.OperDate
                                 UNION ALL
                                  -- !!!����!!! ����������� zc_Enum_AnalyzerId_ReWork
                                  SELECT MIContainer.ContainerId
                                       , MIContainer.OperDate
                                       , zc_MI_Master() AS DescId_mi
                                       , -1 * SUM (MIContainer.Amount) AS OperCount
                                  FROM MovementItemContainer AS MIContainer 
                                       INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.OperDate BETWEEN '10.12.2022' AND '10.12.2022'
                                    AND MIContainer.DescId                 = zc_MIContainer_Count()
                                    AND MIContainer.WhereObjectId_Analyzer = 8451 -- inUnitId
                                    AND MIContainer.ObjectExtId_Analyzer   <> 8451 -- inUnitId -- ���� ����
                                    AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                                    AND MIContainer.isActive               = FALSE
                                  GROUP BY MIContainer.ContainerId
                                         , MIContainer.OperDate
                                 UNION ALL
                                  -- !!!����!!! ��������
                                  SELECT MIContainer.ContainerId
                                       , MIContainer.OperDate
                                       , zc_MI_Master() AS DescId_mi
                                       , -1 * SUM (MIContainer.Amount) AS OperCount
                                  FROM MovementItemContainer AS MIContainer 
                                       INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.OperDate BETWEEN '10.12.2022' AND '10.12.2022'
                                    AND MIContainer.DescId                 = zc_MIContainer_Count()
                                    AND MIContainer.WhereObjectId_Analyzer = 8451 -- inUnitId
                                    AND MIContainer.MovementDescId         = zc_Movement_Loss()
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
                                 LEFT JOIN MovementLinkMovement AS MLM_ProductionUnion
                                                                ON MLM_ProductionUnion.MovementId      = MIContainer.MovementId
                                                               AND MLM_ProductionUnion.DescId          = zc_MovementLinkMovement_Production()
                                                               AND MLM_ProductionUnion.MovementChildId > 0
                            WHERE MIContainer.OperDate BETWEEN '10.12.2022' AND '10.12.2022'
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = 8451 -- inUnitId
                              AND MIContainer.AnalyzerId             = 8451 -- inUnitId
                              AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                              AND MLM_ProductionUnion.MovementId     IS NULL
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
                             FROM (SELECT DISTINCT tmpMI_result.GoodsId, tmpMI_result.GoodsKindId FROM tmpMI_result) AS tmpGoods
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
     /*, tmpMI_result_find AS (-- ���-�� �������� ������
                             SELECT tmp.GoodsId
                             FROM
                            (SELECT tmpMI_result.GoodsId
                                  , COALESCE (ObjectLink_Receipt_Goods_parent.ChildObjectId, tmpMI_result.GoodsId) AS GoodsId_child
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
                             WHERE tmpMI_result.OperCount > 0
                               AND tmpMI_result.DescId_mi = zc_MI_Master()
                            ) AS tmp
                             GROUP BY tmp.GoodsId
                             HAVING COUNT (*) > 1
                            )*/

          -- ���������:
          -- �������� ������� � ��-��
, _tmpResult AS (          SELECT tmpMI_result.MovementId
               , tmpMI_result.OperDate
               , tmpMI_result.MovementItemId
               , tmpMI_result.ContainerId
               , tmpMI_result.GoodsId
               , CASE WHEN ObjectBoolean_ParentMulti.ValueData = TRUE THEN -1 ELSE 1 END * COALESCE (tmpReceipt.ReceiptId, 0) AS ReceiptId_in
               , CASE WHEN ObjectBoolean_ParentMulti.ValueData = TRUE THEN -1 ELSE COALESCE (ObjectLink_Receipt_Parent.ChildObjectId, 0) END AS ReceiptId_child
               , CASE WHEN ObjectBoolean_ParentMulti.ValueData = TRUE THEN 0  ELSE COALESCE (ObjectLink_Receipt_Goods_parent.ChildObjectId, tmpMI_result.GoodsId) END AS GoodsId_child
               , tmpMI_result.DescId_mi

               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN tmpMI_result.OperCount - COALESCE (tmpMI_child_result.OperCount, 0) ELSE 0 END AS OperCount
               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN tmpMI_result.OperCount - COALESCE (tmpMI_child_result.OperCount, 0) ELSE 0 END
               * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS OperCount_Weight

               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN COALESCE (tmpMI_child_result.OperCount, 0) ELSE tmpMI_result.OperCount END AS OperCount_two
               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN COALESCE (tmpMI_child_result.OperCount, 0) ELSE tmpMI_result.OperCount END
               * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                 -- ���-�� �������� ������
               * 0
               /* * CASE WHEN tmpMI_result_find.GoodsId IS NULL THEN 1 ELSE 0 END*/
                 AS OperCount_Weight_two

               , FALSE AS isDelete
          FROM tmpMI_result
               -- LEFT JOIN tmpMI_result_find ON tmpMI_result_find.GoodsId = tmpMI_result.GoodsId
               LEFT JOIN tmpMI_child_result ON tmpMI_child_result.ContainerId = tmpMI_result.ContainerId
                                           AND tmpMI_child_result.OperDate    = tmpMI_result.OperDate
               LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId = tmpMI_result.GoodsId
                                   AND tmpReceipt.GoodsKindId = tmpMI_result.GoodsKindId
               LEFT JOIN ObjectBoolean AS ObjectBoolean_ParentMulti
                                       ON ObjectBoolean_ParentMulti.ObjectId = tmpReceipt.ReceiptId
                                      AND ObjectBoolean_ParentMulti.DescId = zc_ObjectBoolean_Receipt_ParentMulti()
                                    --AND 1=0
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                    ON ObjectLink_Receipt_Parent.ObjectId = tmpReceipt.ReceiptId
                                   AND ObjectLink_Receipt_Parent.DescId   = zc_ObjectLink_Receipt_Parent()
               LEFT JOIN Object AS Object_Receipt_parent ON Object_Receipt_parent.Id       = ObjectLink_Receipt_Parent.ChildObjectId
                                                        AND Object_Receipt_parent.isErased = FALSE
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                    ON ObjectLink_Receipt_Goods_parent.ObjectId = Object_Receipt_parent.Id -- ObjectLink_Receipt_Parent.ChildObjectId
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
               , 0  AS ReceiptId_in    -- �� �����
               , -1 AS ReceiptId_child -- �� �����
               , 0  AS GoodsId_child   -- �� �����
               , tmpMI_child_result.DescId_mi
               , CASE WHEN tmpMI_child_result.OperCount > COALESCE (tmpMI_result.OperCount, 0) THEN tmpMI_child_result.OperCount - COALESCE (tmpMI_result.OperCount, 0) ELSE 0 END AS OperCount
               , 0 AS OperCount_Weight -- �� �����
               , tmpMI_child_result.OperCount AS OperCount_two -- ������������, ��� �����
               , 0 AS OperCount_Weight_two -- �� �����
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
               , 0  AS GoodsId         -- �� �����
               , 0  AS ReceiptId_in    -- �� �����
               , -1 AS ReceiptId_child -- �� �����
               , 0  AS GoodsId_child   -- �� �����
               , tmpMI_all.DescId_mi
               , 0 AS OperCount            -- �� �����
               , 0 AS OperCount_Weight     -- �� �����
               , 0 AS OperCount_two        -- �� �����
               , 0 AS OperCount_Weight_two -- �� �����
               , FALSE AS isDelete
          FROM tmpMI_all
          WHERE tmpMI_all.DescId_mi = zc_MI_Child()
         UNION
          -- ��������� ������� ���� �������
          SELECT tmpMI_all.MovementId
               , zc_DateStart() AS OperDate
               , 0  AS MovementItemId
               , 0  AS ContainerId
               , 0  AS GoodsId
               , 0  AS ReceiptId_in
               , -1 AS ReceiptId_child -- �� �����
               , 0  AS GoodsId_child
               , tmpMI_all.DescId_mi
               , 0  AS OperCount
               , 0  AS OperCount_Weight
               , 0  AS OperCount_two
               , 0  AS OperCount_Weight_two
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
               , 0  AS ContainerId
               , 0  AS GoodsId
               , 0  AS ReceiptId_in
               , -1 AS ReceiptId_child -- �� �����
               , 0  AS GoodsId_child
               , tmpMI_all.DescId_mi
               , 0  AS OperCount
               , 0  AS OperCount_Weight
               , 0  AS OperCount_two
               , 0  AS OperCount_Weight_two
               , TRUE AS isDelete
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementItemId = tmpMI_all.MovementItemId
          WHERE tmpMI_all.DescId_mi = zc_MI_Master() -- !!!������ ��� zc_MI_Master!!!
            AND tmpMI_list.MovementItemId IS NULL
         )

       , tmpResult_MI_all AS (-- ������� ParentId ���� ������������ ��������� ������� �� ��-��
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

       , tmpReceipt_find_all AS (-- ����� ��� ������ - � ������ ��� ������ ������ - �� ���� �� ��������
                       SELECT tmpResult_master.OperDate, tmpResult_master.GoodsId, ObjectLink_ReceiptChild_Goods.ChildObjectId AS GoodsId_child
                            , tmpResult_master.ReceiptId_in
                            , tmpResult_master.ReceiptId_child
                            , ObjectFloat_Value.ValueData AS Value
                       FROM tmpResult_master
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = ABS (tmpResult_master.ReceiptId_in) :: Integer
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ABS (tmpResult_master.ReceiptId_in) :: Integer
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                    ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ABS (tmpResult_master.ReceiptId_in) :: Integer
                                                   AND ObjectLink_ReceiptChild_Receipt.DescId        = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId   = zc_ObjectLink_ReceiptChild_Goods()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()             -- ������
                                                                OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                                                                  )
                       WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0
                      )
           , tmpReceipt_find AS (-- ����� ������ - � ������ ��� ������ ������ - �� ���� �� ��������
                       SELECT tmpReceipt_find_all.OperDate, tmpReceipt_find_all.GoodsId, tmpReceipt_find_all.GoodsId_child
                           ,  ROW_NUMBER() OVER (PARTITION BY tmpReceipt_find_all.OperDate, tmpReceipt_find_all.GoodsId ORDER BY COALESCE (tmpReceipt_find_all.Value, 0) DESC) AS Ord
                       FROM tmpReceipt_find_all
                       WHERE tmpReceipt_find_all.ReceiptId_in > 0
                         AND tmpReceipt_find_all.ReceiptId_child = 0
                      )
      -- ��� - �� ����� �� ����������� ����� ��
    , tmpReceipt_next_find AS (SELECT tmpReceipt_find_all.OperDate, tmpReceipt_find_all.GoodsId, tmpReceipt_find_all.GoodsId_child
                               FROM tmpReceipt_find_all
                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_ParentMulti
                                                              ON ObjectBoolean_ParentMulti.ObjectId  = ABS (tmpReceipt_find_all.ReceiptId_in) :: Integer
                                                             AND ObjectBoolean_ParentMulti.DescId    = zc_ObjectBoolean_Receipt_ParentMulti()
                                                             AND ObjectBoolean_ParentMulti.ValueData = TRUE
                               WHERE tmpReceipt_find_all.GoodsId <> tmpReceipt_find_all.GoodsId_child
                                 AND ObjectBoolean_ParentMulti.ObjectId > 0
                               --AND ObjectBoolean_ParentMulti.ObjectId IS NULL
                              )
   -- ��� - ���� �� � ���� � � �, ����� � <-> �
 , tmpReceipt_next AS (-- 
                       SELECT tmpReceipt_next_find.OperDate, tmpReceipt_next_find.GoodsId, ObjectLink_Receipt_Goods.ChildObjectId AS GoodsId_child
                       FROM tmpReceipt_next_find
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ChildObjectId = tmpReceipt_next_find.GoodsId_child
                                                  AND ObjectLink_ReceiptChild_Goods.DescId        = zc_ObjectLink_ReceiptChild_Goods()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Goods.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE

                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                    ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                                                   AND ObjectLink_ReceiptChild_Receipt.DescId   = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                                                                 AND Object_Receipt.isErased = FALSE

                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                                                   AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = Object_Receipt.Id
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0

                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()             -- ������
                                                                OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                                                                  )
                      )

, tmpReceipt_child_find AS (-- ����� ������ - � ������ ��� ������ ������ - �� ���� �� ��������
                       SELECT DISTINCT tmpResult_master.OperDate, tmpResult_master.GoodsId, ObjectLink_Receipt_Goods.ChildObjectId AS GoodsId_child
                         --,  ROW_NUMBER() OVER (PARTITION BY tmpResult_master.OperDate, tmpResult_master.GoodsId ORDER BY COALESCE (ObjectFloat_Value.ValueData, 0) DESC) AS Ord --  � �/�
                       FROM tmpResult_master
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ChildObjectId = tmpResult_master.GoodsId
                                                  AND ObjectLink_ReceiptChild_Goods.DescId        = zc_ObjectLink_ReceiptChild_Goods()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Goods.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE

                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                    ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                                                   AND ObjectLink_ReceiptChild_Receipt.DescId   = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                                                                 AND Object_Receipt.isErased = FALSE

                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                                                   AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = Object_Receipt.Id
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0


                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()             -- ������
                                                                OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                                                                  )
                       WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0
                      )
          /*, tmpAll2 AS (-- -- ������ zc_MI_Master, ��� ����� �������� �� ����� ����
                        SELECT DISTINCT tmpResult_master.OperDate, tmpResult_master.GoodsId, tmpResult_master.GoodsId AS GoodsId_child, 0 AS Koeff
                               -- ���� �� 5% - ����� !!!������!!! ��� � ����
                             , CASE WHEN tmpResult_master.OperCount + tmpResult_master.OperCount_two = 0
                                        THEN 0
                                    WHEN ((100 * tmp.OperCount / (tmpResult_master.OperCount + tmpResult_master.OperCount_two)) <  4
                                      AND (100 * tmp.OperCount / (tmpResult_master.OperCount + tmpResult_master.OperCount_two)) > -4
                                          )
                                     -- or tmpResult_master.GoodsId = 7837
                                        THEN tmpResult_master.ContainerId
                                    ELSE 0
                               END AS ContainerId
                        FROM tmpResult_master
                             INNER JOIN (SELECT tmpResult_child.OperDate, tmpResult_child.ContainerId, SUM (tmpResult_child.OperCount) AS OperCount FROM tmpResult_child GROUP BY tmpResult_child.OperDate, tmpResult_child.ContainerId
                                        ) AS tmp ON tmp.OperDate    = tmpResult_master.OperDate
                                                AND tmp.ContainerId = tmpResult_master.ContainerId
                        WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0
                       )*/
          , tmpAll_all AS (-- ������ zc_MI_Master, ���� ����� �������� �� ��������� "�������" �������
                       SELECT DISTINCT 0 AS ReceiptId_in, tmpResult_master.OperDate, tmpResult_master.GoodsId, tmpResult_master.GoodsId_child, 0 AS Koeff, 0 AS ContainerId FROM tmpResult_master WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0 AND tmpResult_master.GoodsId_child > 0 AND tmpResult_master.GoodsId <> tmpResult_master.GoodsId_child
                      UNION
                       SELECT DISTINCT 0 AS ReceiptId_in, tmpReceipt_find.OperDate,  tmpReceipt_find.GoodsId,  tmpReceipt_find.GoodsId_child,  0 AS Koeff, 0 AS ContainerId FROM tmpReceipt_find WHERE tmpReceipt_find.Ord = 1 AND tmpReceipt_find.GoodsId_child > 0 AND tmpReceipt_find.GoodsId <> tmpReceipt_find.GoodsId_child
                    --UNION
                    -- SELECT DISTINCT tmpReceipt_find.OperDate,  tmpReceipt_find.GoodsId_child, tmpReceipt_find.GoodsId,   0 AS Koeff, 0 AS ContainerId FROM tmpReceipt_find WHERE tmpReceipt_find.Ord = 1 AND tmpReceipt_find.GoodsId_child > 0 AND tmpReceipt_find.GoodsId <> tmpReceipt_find.GoodsId_child
                    --UNION
                    -- SELECT DISTINCT tmpResult_master.OperDate, tmpResult_master.GoodsId_child, tmpResult_master.GoodsId, 0 AS Koeff, 0 AS ContainerId FROM tmpResult_master WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0 AND tmpResult_master.GoodsId_child > 0 AND tmpResult_master.GoodsId <> tmpResult_master.GoodsId_child
                  /*  
                      UNION


                       -- ������ - ���� �� � ���� �, ����� �� � ���� �
                       SELECT DISTINCT 5 AS ReceiptId_in, tmpReceipt_find.OperDate,  tmpReceipt_find.GoodsId, tmpReceipt_find.GoodsId_child,   0 AS Koeff, 0 AS ContainerId
                       FROM tmpReceipt_child_find AS tmpReceipt_find
                            -- ��� ��� ����, �� ���� �����������
                          left join  (SELECT tmpResult_master.GoodsId, tmpResult_master.GoodsId_child FROM tmpResult_master WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0 AND tmpResult_master.GoodsId_child > 0 AND tmpResult_master.GoodsId <> tmpResult_master.GoodsId_child
                           UNION
                            SELECT tmpReceipt_find.GoodsId,  tmpReceipt_find.GoodsId_child  FROM tmpReceipt_find WHERE tmpReceipt_find.Ord = 1 AND tmpReceipt_find.GoodsId_child > 0 AND tmpReceipt_find.GoodsId <> tmpReceipt_find.GoodsId_child
                           ) AS tmpCheck
                             ON tmpCheck.GoodsId       = tmpReceipt_find.GoodsId
                            AND tmpCheck.GoodsId_child = tmpReceipt_find.GoodsId_child

                       WHERE tmpReceipt_find.GoodsId_child > 0 AND tmpReceipt_find.GoodsId <> tmpReceipt_find.GoodsId_child
                         -- �� ���� �����������
                         AND tmpCheck.GoodsId IS NULL
-- and 1=0
*/
                      UNION

                       -- ��� - ���� �� � ���� � � �������, ����� � -> �������
                       SELECT DISTINCT 5 AS ReceiptId_in, tmpReceipt_find.OperDate,  tmpReceipt_find.GoodsId, tmpReceipt_find.GoodsId_child,   0 AS Koeff, 0 AS ContainerId
                       FROM tmpReceipt_next AS tmpReceipt_find
                            -- ��� ��� ����, �� ���� �����������
                          left join  (SELECT tmpResult_master.GoodsId, tmpResult_master.GoodsId_child FROM tmpResult_master WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0 AND tmpResult_master.GoodsId_child > 0 AND tmpResult_master.GoodsId <> tmpResult_master.GoodsId_child
                           UNION
                            SELECT tmpReceipt_find.GoodsId,  tmpReceipt_find.GoodsId_child  FROM tmpReceipt_find WHERE tmpReceipt_find.Ord = 1 AND tmpReceipt_find.GoodsId_child > 0 AND tmpReceipt_find.GoodsId <> tmpReceipt_find.GoodsId_child
                           ) AS tmpCheck
                             ON tmpCheck.GoodsId       = tmpReceipt_find.GoodsId
                            AND tmpCheck.GoodsId_child = tmpReceipt_find.GoodsId_child
                       WHERE tmpReceipt_find.GoodsId_child > 0 AND tmpReceipt_find.GoodsId <> tmpReceipt_find.GoodsId_child
                         -- �� ���� �����������
                         AND tmpCheck.GoodsId IS NULL
-- and 1=0

                    
-- UNION
-- SELECT DISTINCT tmpResult_master.OperDate, 2537, 8003459, 0 AS Koeff, 0 AS ContainerId FROM tmpResult_master
-- UNION
-- SELECT DISTINCT tmpResult_master.OperDate, 8003459, 2537, 0 AS Koeff, 0 AS ContainerId FROM tmpResult_master


/*
 UNION
 SELECT DISTINCT tmpResult_master.OperDate, 5445599 , 489150, 0 AS Koeff, 0 AS ContainerId FROM tmpResult_master
UNION
 SELECT DISTINCT tmpResult_master.OperDate, 489150, 5445599 , 0 AS Koeff, 0 AS ContainerId FROM tmpResult_master
*/



                     
                       )
        , tmpKoeff AS (-- ������ zc_MI_Master, ����� ����� �������� �� ������� ���� ParentMulti
                       SELECT DISTINCT tmpResult_master.OperDate, tmpResult_master.GoodsId, ObjectLink_ReceiptChild_Goods.ChildObjectId AS GoodsId_child
                            , CASE WHEN (ObjectFloat_Value_master.ValueData * CASE WHEN ObjectLink_Measure_master.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight_master.ValueData ELSE 1 END) <> 0
                                        THEN (ObjectFloat_Value.ValueData        * CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                           / (ObjectFloat_Value_master.ValueData * CASE WHEN ObjectLink_Measure_master.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight_master.ValueData ELSE 1 END)
                                   ELSE 0
                              END
                              AS Koeff
                            , 0 AS ContainerId
                       FROM tmpResult_master
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = (-1 * tmpResult_master.ReceiptId_in) :: Integer
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                    ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = (-1 * tmpResult_master.ReceiptId_in) :: Integer
                                                   AND ObjectLink_ReceiptChild_Receipt.DescId        = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId   = zc_ObjectLink_ReceiptChild_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId   = zc_ObjectLink_ReceiptChild_GoodsKind()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()             -- ������
                                                                OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                                                                  )
                              LEFT JOIN ObjectLink AS ObjectLink_Measure_master
                                                   ON ObjectLink_Measure_master.ObjectId = tmpResult_master.GoodsId
                                                  AND ObjectLink_Measure_master.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight_master
                                                    ON ObjectFloat_Weight_master.ObjectId = tmpResult_master.GoodsId
                                                   AND ObjectFloat_Weight_master.DescId = zc_ObjectFloat_Goods_Weight()

                              LEFT JOIN ObjectLink AS ObjectLink_Measure
                                                   ON ObjectLink_Measure.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                       WHERE (tmpResult_master.OperCount + tmpResult_master.OperCount_two) > 0
                      )

          , tmpAll AS (-- ������ All
                       SELECT tmpAll_all.OperDate, tmpAll_all.GoodsId, tmpAll_all.GoodsId_child, tmpAll_all.Koeff, tmpAll_all.ContainerId FROM tmpAll_all
                            LEFT JOIN tmpKoeff AS tmpKoeff_ch
                                               ON tmpKoeff_ch.GoodsId       = tmpAll_all.GoodsId
                                              AND tmpKoeff_ch.GoodsId_child = tmpAll_all.GoodsId_child
                       WHERE tmpKoeff_ch.GoodsId IS NULL  

                      UNION
                       SELECT DISTINCT tmpAll_all.OperDate, tmpAll_all.GoodsId, tmpAll_all_2.GoodsId_child, tmpAll_all.Koeff, tmpAll_all.ContainerId
                       FROM tmpAll_all
                            LEFT JOIN _tmpResult AS _tmpResult_1 ON _tmpResult_1.GoodsId       = tmpAll_all.GoodsId
                                                                AND _tmpResult_1.ReceiptId_in  < 0
                            LEFT JOIN _tmpResult AS _tmpResult_2 ON _tmpResult_2.GoodsId       = tmpAll_all.GoodsId_child
                                                                AND _tmpResult_2.ReceiptId_in  < 0
                            -- ��� GoodsId, ������� �������� �� GoodsId_child
                            INNER JOIN tmpAll_all AS tmpAll_all_1 ON tmpAll_all_1.GoodsId_child = tmpAll_all.GoodsId_child
                                                               --AND tmpAll_all_1.ReceiptId_in  >= 0
                            -- ��� GoodsId, ����� �� GoodsId_child
                            INNER JOIN tmpAll_all AS tmpAll_all_2 ON tmpAll_all_2.GoodsId       = tmpAll_all_1.GoodsId
                                                               --AND tmpAll_all_2.ReceiptId_in  >= 0
                       WHERE _tmpResult_1.GoodsId IS NULL AND _tmpResult_2.GoodsId IS NULL
                         AND tmpAll_all.ReceiptId_in <> 5
and 1=0

-- and tmpAll_all.GoodsId <> 2357 
-- and tmpAll_all_2.GoodsId_child <> 427122 
-- select * from object where Id = 427122 
 -- and 1=0
                      UNION
                       -- ������ zc_MI_Master, ����� ����� �������� �� ������� ���� ParentMulti
                       SELECT DISTINCT tmpKoeff.OperDate, tmpKoeff.GoodsId, tmpKoeff.GoodsId_child
                            , tmpKoeff.Koeff
                            , tmpKoeff.ContainerId
                       FROM tmpKoeff
-- where 1=0
                     UNION
                       -- ��� - ���� �� � ���� � � �������, ����� � -> �������
                       SELECT tmpKoeff.OperDate, tmpKoeff.GoodsId, tmpReceipt_next.GoodsId_child
                            , MAX (tmpKoeff.Koeff) AS Koeff
                            , MAX (tmpKoeff.ContainerId) AS ContainerId
                       FROM tmpKoeff
                            JOIN tmpReceipt_next ON tmpReceipt_next.GoodsId = tmpKoeff.GoodsId
                            LEFT JOIN tmpKoeff AS tmpKoeff_ch
                                               ON tmpKoeff_ch.GoodsId       = tmpKoeff.GoodsId
                                              AND tmpKoeff_ch.GoodsId_child = tmpReceipt_next.GoodsId_child

                            LEFT JOIN tmpAll_all
                                               ON tmpAll_all.GoodsId       = tmpKoeff.GoodsId
                                              AND tmpAll_all.GoodsId_child = tmpReceipt_next.GoodsId_child

                       WHERE tmpKoeff_ch.GoodsId IS NULL
  and 1=0
                       GROUP BY tmpKoeff.OperDate, tmpKoeff.GoodsId, tmpReceipt_next.GoodsId_child

                    /*UNION
                       -- ��� - ���� �� � ���� � � �������, ����� ������� -> �
                       SELECT tmpKoeff.OperDate, tmpKoeff.GoodsId, tmpReceipt_next.GoodsId
                            , MAX (tmpKoeff.Koeff) AS Koeff
                            , MAX (tmpKoeff.ContainerId) AS ContainerId
                       FROM tmpKoeff
                            JOIN tmpReceipt_next ON tmpReceipt_next.GoodsId_child = tmpKoeff.GoodsId
                       GROUP BY tmpKoeff.OperDate, tmpKoeff.GoodsId, tmpReceipt_next.GoodsId*/
                      )
          , tmpAll_total AS (-- ���� �� ������� zc_MI_Master, ���� �� ������� ��� "�� ���� ����� ��������"
                             SELECT tmpResult_master.OperDate, tmpAll.GoodsId_child, tmpAll.ContainerId
                                  , SUM (CASE WHEN tmpResult_master.OperCount_Weight <> 0
                                                   THEN tmpResult_master.OperCount_Weight
                                              ELSE tmpResult_master.OperCount_Weight_two
                                         END
                                       * CASE WHEN tmpAll.Koeff <> 0
                                                   THEN tmpAll.Koeff
                                              ELSE 1
                                         END
                                        ) AS OperCount_Weight
                             FROM tmpAll
                                  INNER JOIN tmpResult_master ON tmpResult_master.GoodsId = tmpAll.GoodsId AND tmpResult_master.OperDate = tmpAll.OperDate
                             GROUP BY tmpResult_master.OperDate, tmpAll.GoodsId_child, tmpAll.ContainerId
                            )
                              
          , tmpResult_new AS (-- ��������� - ������������� + ����� �� ������������ MovementItemId
                              SELECT tmpResult_MI_find.MovementId     AS MovementId
                                   , tmpResult_child.OperDate         AS OperDate
                                   , tmpResult_master.MovementItemId  AS MovementItemId_master
                                   , tmpResult_master.ContainerId     AS ContainerId_master
                                   , tmpResult_MI_find.MovementItemId AS MovementItemId
                                   , tmpResult_child.ContainerId      AS ContainerId
                                   , tmpResult_child.GoodsId          AS GoodsId
                                   , CASE WHEN tmpAll_total.OperCount_Weight = 0
                                               THEN tmpResult_child.OperCount
                                          ELSE CASE WHEN tmpResult_master.OperCount_Weight <> 0
                                                         THEN CAST (tmpResult_child.OperCount * tmpResult_master.OperCount_Weight / tmpAll_total.OperCount_Weight
                                                                  * CASE WHEN tmpAll.Koeff <> 0 THEN tmpAll.Koeff ELSE 1 END
                                                                    AS NUMERIC(16, 4))
                                                    ELSE CAST (tmpResult_child.OperCount * tmpResult_master.OperCount_Weight_two / tmpAll_total.OperCount_Weight
                                                             * CASE WHEN tmpAll.Koeff <> 0 THEN tmpAll.Koeff ELSE 1 END
                                                               AS NUMERIC(16, 4))
                                               END
                                     END AS OperCount
                                   , FALSE AS isPeresort
                              FROM tmpResult_child
                                   -- �� ���� ����� ������ ��� � ����
                                   LEFT JOIN (SELECT DISTINCT tmpAll.ContainerId FROM tmpAll WHERE tmpAll.ContainerId > 0
                                             ) AS tmp ON tmp.ContainerId = tmpResult_child.ContainerId
                                   INNER JOIN tmpAll_total     ON tmpAll_total.GoodsId_child     = tmpResult_child.GoodsId
                                                              AND tmpAll_total.OperDate          = tmpResult_child.OperDate
                                                              AND (tmpAll_total.ContainerId      = tmpResult_child.ContainerId
                                                                OR (tmpAll_total.ContainerId     = 0 AND tmp.ContainerId IS NULL))
                                                             -- OR tmpResult_child.ContainerId   = 0)
                                                             -- OR (tmpAll_total.ContainerId     = 0 AND tmpResult_child.ContainerId   = 0))

                                   INNER JOIN tmpAll           ON tmpAll.GoodsId_child           = tmpAll_total.GoodsId_child
                                                              AND tmpAll.OperDate                = tmpAll_total.OperDate
                                                              AND tmpAll.ContainerId             = tmpAll_total.ContainerId

                                   INNER JOIN tmpResult_master ON tmpResult_master.GoodsId       = tmpAll.GoodsId
                                                              AND tmpResult_master.OperDate      = tmpAll.OperDate
                                                              -- AND tmpResult_master.OperCount     <> 0 
                                                              AND (tmpResult_master.ContainerId  = tmpAll.ContainerId
                                                                OR tmpAll.ContainerId      = 0)

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

, _tmpResult_child  as (
          -- ��������
          SELECT tmpResult_new.MovementId
               , tmpResult_new.OperDate
               , tmpResult_new.MovementItemId_master
               , tmpResult_new.MovementItemId
               , tmpResult_new.ContainerId_master
               , tmpResult_new.ContainerId
               , tmpResult_new.GoodsId
               , CASE WHEN SUM (tmpResult_new.OperCount + COALESCE (tmpResult_diff.OperCount, 0)) > 0
                           THEN SUM (tmpResult_new.OperCount + COALESCE (tmpResult_diff.OperCount, 0))
                      ELSE SUM (tmpResult_new.OperCount)
                 END AS OperCount
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
)
/* select * from Object WHERE id in (
select GoodsId_child from tmpAll -- _tmpResult_child 
where goodsId  = 2507  -- and GoodsId_child = 
)*/
select * from tmpAll where goodsId  = 489150   -- and GoodsId_child =  
order by GoodsId_child
 -- select * from Object WHERE id = 2507
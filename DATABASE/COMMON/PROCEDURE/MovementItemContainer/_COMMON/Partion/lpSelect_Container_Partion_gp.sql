-- ������ ���������� ������ ������
-- Function: lpSelect_Container_Partion_gp()

DROP FUNCTION IF EXISTS lpSelect_Container_Partion_gp (Integer, Integer);
DROP FUNCTION IF EXISTS lpSelect_Container_Partion_gp (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Container_Partion_gp(
    IN inOperDate  TDateTime, --
    IN inUnitId    Integer,   --
    IN inUserId    Integer    -- ������������
)
RETURNS TABLE (MovementItemId Integer
             , ContainerId    Integer
             , GoodsId        Integer
             , GoodsKindId    Integer
             , OperCount      TFloat
              )
AS
$BODY$
BEGIN

     -- !!!��� �����!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('_tmpItem'))
     AND inUserId <= 5
     THEN
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , GoodsId        Integer
                                   , GoodsKindId    Integer
                                   , OperCount      TFloat
                                   , InfoMoneyDestinationId Integer
                                    ) ON COMMIT DROP;
         --
         INSERT INTO  _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount, InfoMoneyDestinationId)
            SELECT MovementItem.Id
                 , MovementItem.ObjectId
                 , MILinkObject_GoodsKind.ObjectId
                 , MovementItem.Amount
                 , View_InfoMoney.InfoMoneyDestinationId
            FROM MovementItem
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                      ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                     AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()

                 LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                 ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
            WHERE MovementItem.MovementId = ABS (inUserId)
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased   = FALSE
           ;

     END IF;
     -- !!!��� �����!!!



     -- ���������
     RETURN QUERY
        WITH -- ������� ������ ��� ����� �������
              tmpMI_summ AS (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId, SUM (_tmpItem.OperCount) AS OperCount
                             FROM _tmpItem
                             WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                     , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                      )
                             GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                            )
       -- ������ ���� �������� ������ - ����������� PartionGoodsDate � ������
     , tmpContainer_list AS (-- ��� zc_ContainerLinkObject_Unit
                             SELECT tmpMI.GoodsId
                                  , tmpMI.GoodsKindId
                                  , Container.Id                                          AS ContainerId
                                  , Container.Amount                                      AS Amount
                                  , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                             FROM tmpMI_summ AS tmpMI
                                  INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                      AND Container.DescId   = zc_Container_Count()
                                  INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                 ON CLO_Unit.ContainerId = Container.Id
                                                                AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                AND CLO_Unit.ObjectId    = inUnitId
                                  LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                ON CLO_GoodsKind.ContainerId = Container.Id
                                                               AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                  -- !!!
                                  LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                ON CLO_Account.ContainerId = Container.Id
                                                               AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                                  -- !!!
                                  LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                ON CLO_PartionGoods.ContainerId = Container.Id
                                                               AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                  LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                          AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                             WHERE COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI.GoodsKindId
                                -- !!!�.�. ��� ����� �������!!!
                               AND CLO_Account.ContainerId IS NULL
                               -- ��������
                               AND COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) > zc_DateStart()
                            )
     -- ������� �� ����� ���
   , tmpContainer_rem AS (SELECT tmpContainer_list.ContainerId
                               , tmpContainer_list.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_rem
                          FROM tmpContainer_list
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId = tmpContainer_list.ContainerId
                                                              -- !!!�� ����� ���
                                                              AND MIContainer.OperDate    > inOperDate

                          GROUP BY tmpContainer_list.ContainerId, tmpContainer_list.Amount
                          HAVING tmpContainer_list.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) > 0
                         )
    -- �������� ����� - ������� �� �������
  , tmpContainer_all AS (SELECT tmpMI.GoodsId
                              , tmpMI.GoodsKindId
                                -- ����� ���-�� � �������
                              , tmpMI.OperCount AS Amount
                                -- ������
                              , tmpContainer_list.ContainerId  AS ContainerId
                                --
                              , COALESCE (tmpContainer_rem.Amount_rem, tmpContainer_list.Amount)       AS Amount_container
                                --
                              , SUM (COALESCE (tmpContainer_rem.Amount_rem, tmpContainer_list.Amount))
                                                 OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                       ORDER BY tmpContainer_list.PartionGoodsDate ASC
                                                              , tmpContainer_list.ContainerId      ASC
                                                      )  AS AmountSUM --
                              , ROW_NUMBER()     OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                       ORDER BY tmpContainer_list.PartionGoodsDate ASC
                                                              , tmpContainer_list.ContainerId      ASC
                                                      ) AS Ord      -- !!!���� �������� ���������!!!

                         FROM tmpMI_summ AS tmpMI
                              -- ������ ���� ������
                              INNER JOIN tmpContainer_list ON tmpContainer_list.GoodsId     = tmpMI.GoodsId
                                                          AND tmpContainer_list.GoodsKindId = tmpMI.GoodsKindId
                              -- ������� �� ����� ���
                              LEFT JOIN tmpContainer_rem ON tmpContainer_rem.ContainerId = tmpContainer_list.ContainerId

                         WHERE COALESCE (tmpContainer_rem.Amount_rem, tmpContainer_list.Amount) > 0
                        )
      -- ����� ��������� - ���-�� ������� ������� �� ������� ContainerId
    , tmpContainer_partion AS (SELECT DD.ContainerId
                                    , DD.GoodsId
                                    , DD.GoodsKindId
                                      -- ���-�� ��� �������
                                    , CASE WHEN DD.Amount - DD.AmountSUM > 0 -- !!!AND DD.Ord <> 1
                                                THEN DD.Amount_container
                                           ELSE DD.Amount - DD.AmountSUM + DD.Amount_container
                                      END AS Amount
                               FROM (SELECT * FROM tmpContainer_all) AS DD
                               WHERE DD.Amount - (DD.AmountSUM - DD.Amount_container) > 0
                              )
      -- �������� ������������� �����
    , tmpContainer_sum AS (SELECT tmpContainer.ContainerId
                                , tmpContainer.GoodsId
                                , tmpContainer.GoodsKindId
                                  -- ���-�� ��� �������
                                , tmpContainer.Amount
                                  -- ���������� �� ContainerId
                                , SUM (tmpContainer.Amount) OVER (PARTITION BY tmpContainer.GoodsId, tmpContainer.GoodsKindId ORDER BY tmpContainer.ContainerId ASC) AS AmountSUM
                           FROM tmpContainer_partion AS tmpContainer
                          )
      -- �������� � �/�, ���� ������������ ������������� �������
    , tmpContainer_NUMBER AS (SELECT tmpContainer.ContainerId
                                   , tmpContainer.GoodsId
                                   , tmpContainer.GoodsKindId
                                     -- ���-�� ��� �������
                                   , tmpContainer.Amount
                                     -- ���-�� ��� ������� - ������������
                                   , tmpContainer.AmountSUM
                                     -- ���� ���-�� ����� � � �/� = 1
                                   , ROW_NUMBER() OVER (PARTITION BY tmpContainer.GoodsId, tmpContainer.GoodsKindId ORDER BY tmpContainer.AmountSUM DESC) AS Ord
                              FROM tmpContainer_sum AS tmpContainer
                             )
      -- ������������� ������� - ����� �������
    , tmpContainer_group AS (SELECT tmpContainer.ContainerId
                                  , tmpContainer.GoodsId
                                  , tmpContainer.GoodsKindId
                                    -- ���-�� ��� �������
                                  , tmpContainer.Amount
                                    -- ���-�� ��� ������� - ������������
                                  , tmpContainer.AmountSUM
                                    -- � ������������
                                  , COALESCE (tmpContainer_old.AmountSUM, 0) AS Amount_min
                                    -- �������� ��������� ���-��, ���� ������ �� ������, ��� � ��� ����� �� ���� ContainerId (���� ��� � ��� ������ ������� tmpContainer_partion)
                                  , CASE WHEN tmpContainer.Ord = 1 THEN tmpContainer.AmountSUM * 1000 ELSE tmpContainer.AmountSUM END AS Amount_max
                              FROM tmpContainer_NUMBER AS tmpContainer
                                   LEFT JOIN tmpContainer_NUMBER AS tmpContainer_old
                                                                 ON tmpContainer_old.GoodsId     = tmpContainer.GoodsId
                                                                AND tmpContainer_old.GoodsKindId = tmpContainer.GoodsKindId
                                                                AND tmpContainer_old.Ord         = tmpContainer.Ord + 1
                             )
          -- �������� � �/�, ���� ������������ ������������� ������� MI
        , tmpMI_NUMBER AS (SELECT tmpMI.MovementItemId
                                , tmpMI.GoodsId
                                , tmpMI.GoodsKindId
                                , tmpMI.OperCount
                                  -- 
                                , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.MovementItemId ASC) AS Ord
                                  -- ���������� �� MovementItemId
                                , SUM (tmpMI.OperCount) OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.MovementItemId ASC) AS OperCountSUM
                           FROM _tmpItem AS tmpMI
                          )
          -- ������������� ������� - ������� MI
         , tmpMI_group AS (SELECT tmpMI.MovementItemId
                                , tmpMI.GoodsId
                                , tmpMI.GoodsKindId
                                , tmpMI.OperCount
                                  -- � min
                                , COALESCE (tmpMI_old.OperCountSUM, 0) AS OperCount_min
                                  -- �� max
                                , tmpMI.OperCountSUM AS OperCount_max
                                  --
                                , tmpMI.Ord
                           FROM tmpMI_NUMBER AS tmpMI
                                LEFT JOIN tmpMI_NUMBER AS tmpMI_old
                                                       ON tmpMI_old.GoodsId     = tmpMI.GoodsId
                                                      AND tmpMI_old.GoodsKindId = tmpMI.GoodsKindId
                                                      AND tmpMI_old.Ord -1      = tmpMI.Ord
                          )
      -- ������ ���������� � MI
    , tmpContainer AS (SELECT tmpMI_group.MovementItemId
                            , tmpMI_group.GoodsId
                            , tmpMI_group.GoodsKindId
                              -- ���������� �� MI
                            , CASE WHEN tmpMI_group.OperCount_min BETWEEN tmpContainer_group.Amount_min AND tmpContainer_group.Amount_max
                                    AND tmpMI_group.OperCount_max >= tmpContainer_group.Amount_max
                                        THEN tmpContainer_group.Amount

                                   WHEN tmpMI_group.OperCount_min < tmpContainer_group.Amount_min
                                    AND tmpMI_group.OperCount_max BETWEEN tmpContainer_group.Amount_min AND tmpContainer_group.Amount_max
                                        THEN tmpMI_group.OperCount_max - tmpContainer_group.Amount_min

                                   ELSE -1

                              END AS Amount
                              --
                            , tmpContainer_group.ContainerId
                      FROM tmpMI_group
                           LEFT JOIN tmpContainer_group ON tmpContainer_group.GoodsId     = tmpMI_group.GoodsId
                                                       AND tmpContainer_group.GoodsKindId = tmpMI_group.GoodsKindId
                                                       AND ((tmpMI_group.OperCount_min BETWEEN tmpContainer_group.Amount_min AND tmpContainer_group.Amount_max)
                                                         OR (tmpContainer_group.Amount_min BETWEEN tmpMI_group.OperCount_min AND tmpMI_group.OperCount_max)
                                                           )

                     )
        -- ���������
        /*SELECT tmpContainer.MovementItemId
             , tmpContainer.ContainerId
             , tmpContainer.GoodsId
             , tmpContainer.GoodsKindId
             , tmpContainer.Amount         :: TFloat AS OperCount
        FROM tmpContainer*/

        SELECT tmpMI.MovementItemId
             , tmpContainer.ContainerId
             , tmpContainer.GoodsId
             , tmpContainer.GoodsKindId
             , tmpContainer.Amount         :: TFloat AS OperCount
        FROM tmpContainer_partion AS tmpContainer
             LEFT JOIN _tmpItem AS tmpMI
                                ON tmpMI.GoodsId     = tmpContainer.GoodsId
                               AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.02.24                                        *
*/

-- ����
-- SELECT * FROM lpSelect_Container_Partion_gp (inOperDate:= CURRENT_DATE + INTERVAL '2 DAY', inUnitId:= 8459, inUserId:= -27553498 )

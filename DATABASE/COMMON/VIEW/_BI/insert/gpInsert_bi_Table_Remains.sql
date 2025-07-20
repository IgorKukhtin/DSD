-- Function: gpInsert_bi_Table_Remains

DROP FUNCTION IF EXISTS gpInsert_bi_Table_Remains (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_Remains(
    IN inOperDate     TDateTime ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
    -- inStartDate:='01.06.2014';
    --

     IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) --OR 1=1
     THEN
         DELETE FROM _bi_Table_Remains WHERE OperDate BETWEEN DATE_TRUNC ('DAY', inOperDate) AND inOperDate + INTERVAL '1 DAY';
     END IF;


    WITH tmpUnit AS (-- Филиалы
                     SELECT ObjectLink_Unit_Branch.ObjectId AS UnitId
                     FROM ObjectLink AS ObjectLink_Unit_Branch
                           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
                     WHERE ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                       AND ObjectLink_Unit_Branch.ChildObjectId > 0
                       AND ObjectLink_Unit_Branch.ChildObjectId <> zc_Branch_Basis()
 
                    UNION
                     SELECT Object_Unit.Id AS UnitId
                     FROM Object AS Object_Unit
                     WHERE  Object_Unit.DescId = zc_Object_Unit()
                        AND Object_Unit.Id IN (zc_Unit_RK() -- 
                                             , 8020706      -- 50034 Склады (Ирна)
                                             , 9558031      -- 50059 Склад Неликвид
                                              )
                    )
       , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                      FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                           ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                      WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        -- учет - партии по датам + ячейки
                        AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                    , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                     )
                     )
       , tmpRemains_count
                      AS (SELECT Container.Id                 AS ContainerId
                               , tmpGoods.GoodsId             AS GoodsId
                               , CLO_GoodsKind.ObjectId       AS GoodsKindId
                               , CLO_PartionGoods.ObjectId    AS PartionGoodsId
                               , CLO_Unit.ObjectId            AS UnitId
                               , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
 
                          FROM tmpGoods
                               INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                   AND Container.DescId   = zc_Container_Count()
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId
                               -- без Товар в пути
                               LEFT JOIN ContainerLinkObject AS CLO_Account
                                                             ON CLO_Account.ContainerId = Container.Id
                                                            AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                             ON CLO_GoodsKind.ContainerId = Container.Id
                                                            AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               -- !!!
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId = Container.Id
                                                              AND MIContainer.OperDate   >= inOperDate
                          -- !!!без Товар в пути!!!
                          WHERE CLO_Account.ObjectId IS NULL
                          GROUP BY Container.Id
                                 , tmpGoods.GoodsId
                                 , CLO_GoodsKind.ObjectId
                                 , CLO_PartionGoods.ObjectId
                                 , CLO_Unit.ObjectId
                          HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                         )
       , tmpRemains_summ
                      AS (SELECT Container.Id                 AS ContainerId
                               , Container.ParentId           AS ContainerId_count
                               , tmpGoods.GoodsId             AS GoodsId
                               , CLO_GoodsKind.ObjectId       AS GoodsKindId
                               , CLO_PartionGoods.ObjectId    AS PartionGoodsId
                               , CLO_Unit.ObjectId            AS UnitId
                               , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
 
                          FROM tmpGoods
                               INNER JOIN ContainerLinkObject AS CLO_Goods
                                                              ON CLO_Goods.ObjectId = tmpGoods.GoodsId
                                                             AND CLO_Goods.DescId   = zc_ContainerLinkObject_Goods()
                               INNER JOIN Container ON Container.Id     = CLO_Goods.ContainerId
                                                   AND Container.DescId = zc_Container_Summ()
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId

                               -- без Товар в пути
                               LEFT JOIN ContainerLinkObject AS CLO_Account
                                                             ON CLO_Account.ContainerId = Container.ParentId
                                                            AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()

                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                             ON CLO_GoodsKind.ContainerId = Container.Id
                                                            AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               -- !!!
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId = Container.Id
                                                              AND MIContainer.OperDate   >= inOperDate
                          -- !!!без Товар в пути!!!
                          WHERE CLO_Account.ObjectId IS NULL
                          GROUP BY Container.Id
                                 , Container.ParentId
                                 , tmpGoods.GoodsId
                                 , CLO_GoodsKind.ObjectId
                                 , CLO_PartionGoods.ObjectId
                                 , CLO_Unit.ObjectId
                          HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                         )
 
           , tmpRemains_all AS (SELECT tmpRemains_count.GoodsId
                                     , tmpRemains_count.GoodsKindId
                                     , tmpRemains_count.PartionGoodsId
                                     , tmpRemains_count.UnitId
                                     , tmpRemains_count.Amount AS Amount
                                     , 0                       AS SummCost
                                FROM tmpRemains_count
                               UNION ALL
                                SELECT tmpRemains_summ.GoodsId
                                     , tmpRemains_summ.GoodsKindId
                                     , tmpRemains_summ.PartionGoodsId
                                     , tmpRemains_summ.UnitId
                                     , 0                      AS Amount
                                     , tmpRemains_summ.Amount AS SummCost
                                FROM tmpRemains_summ
                               )
       , tmpPriceStart AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , lfObjectHistory_PriceListItem.GoodsKindId
                                , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inOperDate) AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )

      -- РЕЗУЛЬТАТ
      INSERT INTO _bi_Table_Remains ( -- Дата + время остатков
                                      OperDate
                                      -- Подразделение
                                    , UnitId
                                      -- Товар
                                    , GoodsId
                                      -- Вид Товара
                                    , GoodsKindId
                                      -- Партия Товара
                                    , PartionId
                                      -- Партия Товара - дата
                                    , PartionDate
                        
                                      -- Вес Остатки
                                    , Amount
                                      -- Шт. Остатки
                                    , Amount_sh
                        
                                      -- Сумма с/с
                                    , SummCost
                                      -- Сумма по ценам прайса
                                    , SummPriceList
                            )
        SELECT CURRENT_TIMESTAMP AS OperDate
             , tmpRemains_all.UnitId
             , tmpRemains_all.GoodsId
             , tmpRemains_all.GoodsKindId
             , tmpRemains_all.PartionGoodsId
             , ObjectDate_Value.ValueData AS PartionDate
  
             , SUM (tmpRemains_all.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount
             , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpRemains_all.Amount ELSE 0 END)                                AS Amount_sh

             , SUM (tmpRemains_all.SummCost)  AS SummCost
             , SUM (tmpRemains_all.Amount * COALESCE (tmpPriceStart_kind.Price, tmpPriceStart.Price, 0)) AS Amount
  
        FROM tmpRemains_all
             LEFT JOIN ObjectDate AS ObjectDate_Value
                                  ON ObjectDate_Value.ObjectId = tmpRemains_all.PartionGoodsId
                                 AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpRemains_all.GoodsId
                                                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = tmpRemains_all.GoodsId
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

             -- привязываем цены 2 раза по виду товара и без
             LEFT JOIN tmpPriceStart ON tmpPriceStart.GoodsId = tmpRemains_all.GoodsId
                                    AND tmpPriceStart.GoodsKindId IS NULL
             LEFT JOIN tmpPriceStart AS tmpPriceStart_kind
                                     ON tmpPriceStart_kind.GoodsId = tmpRemains_all.GoodsId
                                    AND COALESCE (tmpPriceStart_kind.GoodsKindId,0) = COALESCE (tmpRemains_all.GoodsKindId, 0)
        GROUP BY tmpRemains_all.UnitId
               , tmpRemains_all.GoodsId
               , tmpRemains_all.GoodsKindId
               , tmpRemains_all.PartionGoodsId
               , ObjectDate_Value.ValueData
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.25                                        * all
*/

/*
SELECT *
FROM _bi_Table_Remains
     LEFT JOIN Object AS Object_Unit      ON Object_Unit.Id      = _bi_Table_Remains.UnitId
     LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = _bi_Table_Remains.GoodsId
     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _bi_Table_Remains.GoodsKindId
WHERE OperDate = '15.07.2025 9:00'
--
-- SELECT DISTINCT OperDate FROM _bi_Table_Remains ORDER BY 1
*/
-- тест
-- DELETE FROM  _bi_Table_Remains WHERE OperDate between '20.07.2025 9:00' and '20.07.2025 9:10'
-- UPDATE  _bi_Table_Remains SET OperDate = '20.07.2025 9:00' WHERE OperDate between '20.07.2025 11:00' and '20.07.2025 11:10'
-- SELECT * FROM gpInsert_bi_Table_Remains (inOperDate:= '14.07.2025', inSession:= zfCalc_UserAdmin())

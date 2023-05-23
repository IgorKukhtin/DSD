-- Function: gpSelect_Object_PartionGoods20202()


DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods20202 (Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods20202 (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoods20202(
    IN inGoodsId      Integer   ,
    IN inUnitId       Integer   ,
    IN inShowAll      Boolean   ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime, Price TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , StorageId Integer, StorageName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Amount TFloat
             , isErased boolean
              ) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

      WITH
       tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                    FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                    WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                      AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20202() --Спецодежда

                   UNION
                    SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                    FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                         INNER JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                               ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                              AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                              AND ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_20300(), zc_Enum_InfoMoneyDestination_70100(), zc_Enum_InfoMoneyDestination_70200())
                                              AND vbUserId IN (5)
                    WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   )
     , tmpContainer_Count AS (SELECT Container.ObjectId AS GoodsId
                                   , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                   , Container.Amount
                              FROM Container
                                   INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                                   LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = Container.Id
                                                                            AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                           -- AND CLO_Unit.ObjectId > 0

                                   LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = Container.Id
                                                                              AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                            --  AND CLO_Member.ObjectId > 0

                                   LEFT JOIN ContainerLinkObject AS CLO_Car ON CLO_Car.ContainerId = Container.Id
                                                                           AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
                                                                           --  AND CLO_Car.ObjectId > 0

                                   LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                    AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                              WHERE (Container.ObjectId = inGoodsId OR inGoodsId = 0)
                                AND Container.DescId = zc_Container_Count()
                                AND (CLO_Unit.ObjectId = inUnitId OR CLO_Member.ObjectId = inUnitId OR CLO_Car.ObjectId = inUnitId OR inUnitId = 0)
                                AND (Container.Amount <> 0 OR inShowAll = TRUE)

                             UNION
                              SELECT Container.ObjectId AS GoodsId
                                   , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                   , Container.Amount
                              FROM Container
                                   -- INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                                   LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = Container.Id
                                                                            AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                           -- AND CLO_Unit.ObjectId > 0

                                   LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = Container.Id
                                                                              AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                            --  AND CLO_Member.ObjectId > 0

                                   LEFT JOIN ContainerLinkObject AS CLO_Car ON CLO_Car.ContainerId = Container.Id
                                                                           AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
                                                                           --  AND CLO_Car.ObjectId > 0

                                   LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                    AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                              WHERE (Container.ObjectId = inGoodsId OR inGoodsId = 0)
                                AND Container.DescId = zc_Container_Count()
                                AND (CLO_Unit.ObjectId = inUnitId OR CLO_Member.ObjectId = inUnitId OR CLO_Car.ObjectId = inUnitId)
                                AND Container.Amount <> 0
                                AND CLO_PartionGoods.ObjectId <> 0
                             )

     SELECT
             Object_PartionGoods.Id          AS Id
           , CASE WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0 AND Object_PartionGoods.ObjectCode > 0
                       THEN zfCalc_PartionGoodsName_Asset (inMovementId      := Object_PartionGoods.ObjectCode          --
                                                         , inInvNumber       := Object_PartionGoods.ValueData           -- Инвентарный номер
                                                         , inOperDate        := ObjectDate_PartionGoods_Value.ValueData -- Дата ввода в эксплуатацию
                                                         , inUnitName        := Object_Unit.ValueData                   -- Подразделение использования
                                                         , inStorageName     := Object_Storage.ValueData                -- Место хранения
                                                         , inGoodsName       := ''                                      -- Основные средства или Товар
                                                          )
                  WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0
                       THEN zfCalc_PartionGoodsName_InvNumber (inInvNumber       := Object_PartionGoods.ValueData             -- Инвентарный номер
                                                             , inOperDate        := ObjectDate_PartionGoods_Value.ValueData   -- Дата перемещения
                                                             , inPrice           := ObjectFloat_PartionGoods_Price.ValueData  -- Цена
                                                             , inUnitName_Partion:= Object_Unit.ValueData                     -- Подразделение(для цены)
                                                             , inStorageName     := Object_Storage.ValueData                  -- Место хранения
                                                             , inGoodsName       := ''                                        -- Товар
                                                              )
                  ELSE COALESCE (Object_PartionGoods.ValueData, '')
             END :: TVarChar AS InvNumber
           , ObjectDate_PartionGoods_Value.ValueData      AS OperDate
           , ObjectFloat_PartionGoods_Price.ValueData     AS Price

           , Object_Goods.Id                 AS GoodsId
           , Object_Goods.ObjectCode         AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName

           , Object_Storage.Id               AS StorageId
           , Object_Storage.ValueData        AS StorageName

           , Object_Unit.Id                  AS UnitId
           , Object_Unit.ValueData           AS UnitName
           , tmpContainer_Count.Amount       AS Amount

           , Object_PartionGoods.isErased    AS isErased

     FROM tmpContainer_Count

          -- товар
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpContainer_Count.GoodsId
          -- партия
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpContainer_Count.PartionGoodsId
          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = tmpContainer_Count.PartionGoodsId
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
          -- подразделение
          LEFT JOIN ObjectLink AS ObjectLink_Unit
                               ON ObjectLink_Unit.ObjectId = tmpContainer_Count.PartionGoodsId
                              AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
          -- место хранения
          LEFT JOIN ObjectLink AS ObjectLink_Storage
                               ON ObjectLink_Storage.ObjectId = tmpContainer_Count.PartionGoodsId
                              AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
          LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId
          -- дата
          LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                               ON ObjectDate_PartionGoods_Value.ObjectId = tmpContainer_Count.PartionGoodsId
                              AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
          -- цена
          LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                ON ObjectFloat_PartionGoods_Price.ObjectId = tmpContainer_Count.PartionGoodsId
                               AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price()
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14         *
*/

-- тест
-- select * from gpSelect_Object_PartionGoods20202(inGoodsId := 416148 , inUnitId := 8456, inShowAll := 'True' ,  inSession := '5');
-- select * from gpSelect_Object_PartionGoods20202(inGoodsId := 416148 , inUnitId := 8456, inShowAll := 'False',  inSession := '5');

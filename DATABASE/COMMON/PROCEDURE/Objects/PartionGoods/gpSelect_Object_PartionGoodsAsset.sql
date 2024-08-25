-- Function: gpSelect_Object_PartionGoodsAsset()

DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoodsAsset (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoodsAsset(
    IN inGoodsId      Integer   ,
    IN inUnitId       Integer   ,
    IN inShowAll      Boolean   ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, PartNumber TVarChar
             , OperDate TDateTime, Price TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , StorageId Integer, StorageName TVarChar
             , UnitName_Storage     TVarChar
             , BranchName_Storage   TVarChar
             , AreaUnitName_Storage TVarChar
             , Room_Storage         TVarChar
             , Address_Storage      TVarChar
             , UnitId Integer, UnitName TVarChar 
             , BranchId Integer, BranchName TVarChar
             , PartionModelId Integer, PartionModelName TVarChar 
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , Amount TFloat
             , isErased boolean
              ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());

     RETURN QUERY

  WITH
       tmpInfoMoney AS (SELECT Object_InfoMoney_View.InfoMoneyId
                        FROM Object_InfoMoney_View
                        WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20300()
                                                                             , zc_Enum_InfoMoneyDestination_70100()
                                                                             , zc_Enum_InfoMoneyDestination_70200()
                                                                             )
                        )

     , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                         , ObjectLink_Goods_InfoMoney.ChildObjectId AS InfoMoneyId
                    FROM ObjectLink AS ObjectLink_Goods_InfoMoney 
                    WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                      AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (SELECT tmpInfoMoney.InfoMoneyId FROM tmpInfoMoney)
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

           , ObjectString_PartionGoods_PartNumber.ValueData ::TVarChar AS PartNumber
           , ObjectDate_PartionGoods_Value.ValueData      AS OperDate
           , ObjectFloat_PartionGoods_Price.ValueData     AS Price

           , Object_Goods.Id                 AS GoodsId
           , Object_Goods.ObjectCode         AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName

           , COALESCE (Object_Storage.Id,0) ::Integer AS StorageId
           , Object_Storage.ValueData                 AS StorageName
           , Object_Unit_Storage.ValueData            AS UnitName_Storage
           , Object_Branch_Storage.ValueData          AS BranchName_Storage
           , Object_AreaUnit_Storage.ValueData        AS AreaUnitName_Storage
           , ObjectString_Storage_Room.ValueData      AS Room_Storage
           , ObjectString_Storage_Address.ValueData   AS Address_Storage

           , Object_Unit.Id                  AS UnitId
           , Object_Unit.ValueData           AS UnitName
           
           , Object_Branch.Id                AS BranchId
           , Object_Branch.ValueData         AS BranchName

           , Object_PartionModel.Id          AS PartionModelId
           , Object_PartionModel.ValueData   AS PartionModelName
           
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all
           
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

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
          -- место хранения
          LEFT JOIN ObjectLink AS ObjectLink_Storage
                               ON ObjectLink_Storage.ObjectId = tmpContainer_Count.PartionGoodsId
                              AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
          LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Storage_Address
                                 ON ObjectString_Storage_Address.ObjectId = Object_Storage.Id 
                                AND ObjectString_Storage_Address.DescId = zc_ObjectString_Storage_Address()
          LEFT JOIN ObjectString AS ObjectString_Storage_Room
                                 ON ObjectString_Storage_Room.ObjectId = Object_Storage.Id 
                                AND ObjectString_Storage_Room.DescId = zc_ObjectString_Storage_Room()
          LEFT JOIN ObjectLink AS ObjectLink_Storage_AreaUnit
                               ON ObjectLink_Storage_AreaUnit.ObjectId = Object_Storage.Id 
                              AND ObjectLink_Storage_AreaUnit.DescId = zc_ObjectLink_Storage_AreaUnit()
          LEFT JOIN Object AS Object_AreaUnit_Storage ON Object_AreaUnit_Storage.Id = ObjectLink_Storage_AreaUnit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Storage_Unit
                               ON ObjectLink_Storage_Unit.ObjectId = Object_Storage.Id 
                              AND ObjectLink_Storage_Unit.DescId = zc_ObjectLink_Storage_Unit()
          LEFT JOIN Object AS Object_Unit_Storage ON Object_Unit_Storage.Id = ObjectLink_Storage_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_st
                               ON ObjectLink_Unit_Branch_st.ObjectId = Object_Unit_Storage.Id
                              AND ObjectLink_Unit_Branch_st.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_Branch_Storage ON Object_Branch_Storage.Id = ObjectLink_Unit_Branch_st.ChildObjectId

          -- модель
          LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                               ON ObjectLink_PartionModel.ObjectId = tmpContainer_Count.PartionGoodsId		        
                              AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
          LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId
          -- дата
          LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                               ON ObjectDate_PartionGoods_Value.ObjectId = tmpContainer_Count.PartionGoodsId
                              AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
          -- цена
          LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                ON ObjectFloat_PartionGoods_Price.ObjectId = tmpContainer_Count.PartionGoodsId
                               AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price() 

          -- № по тех паспорту
          LEFT JOIN ObjectString AS ObjectString_PartionGoods_PartNumber
                                 ON ObjectString_PartionGoods_PartNumber.ObjectId = tmpContainer_Count.PartionGoodsId
                                AND ObjectString_PartionGoods_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = tmpContainer_Count.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.05.23         *
*/

-- тест
-- select * from gpSelect_Object_PartionGoodsAsset(inGoodsId := 0 , inUnitId := 13177 , inShowAll := 'False',  inSession := '5');

-- Function: gpReport_Remains_Partion()

DROP FUNCTION IF EXISTS gpReport_Remains_Partion (Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Remains_Partion (Integer, Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Remains_Partion(
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inUnitId             Integer   ,
    IN inIsShowAll          Boolean   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE  (ContainerId        Integer
              , GoodsId            Integer
              , GoodsCode          Integer
              , GoodsName          TVarChar
              , GoodsGroupNameFull TVarChar
              , Amount             TFloat
              , GoodsKindName      TVarChar
              , LocationCode       Integer
              , LocationName       TVarChar
              , LocationDescName   TVarChar
              , PartionGoodsId     Integer
              , InvNumber          TVarChar
              , InvNumber_calc     TVarChar
              , OperDate           TDateTime
              , Price              TFloat
              , StorageName        TVarChar
              , PartionModelName   TVarChar
              , PartNumber         TVarChar
              , UnitName_partion   TVarChar
              , UnitName_storage   TVarChar
              , BranchName_storage TVarChar
              , AreaUnitName_storage TVarChar
              , Room_storage       TVarChar
              , Address_storage    TVarChar
              , Comment_storage    TVarChar
              , UnitName           TVarChar
              , BranchName         TVarChar
              , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
              , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inGoodsGroupId,0) = 0 AND COALESCE (inGoodsId,0) = 0
   THEN
        RAISE EXCEPTION 'Ошибка. Не выбран Товар или Группа товаров.';
   END IF;
   
   -- Результат
    RETURN QUERY
    WITH 
         tmpGoods AS (SELECT inGoodsId AS GoodsId
                      WHERE COALESCE (inGoodsId <> 0)
                     UNION
                      SELECT lfSelect.GoodsId
                      FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                      WHERE inGoodsId = 0 AND inGoodsGroupId <> 0
                      )

       , tmpWhere AS (SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Car() AS DescId FROM Object WHERE Object.DescId = zc_Object_Car()
                     UNION
                      SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Member() AS DescId FROM Object WHERE Object.DescId = zc_Object_Member()
                     UNION
                      SELECT Object_Unit.Id AS LocationId, zc_ContainerLinkObject_Unit() AS DescId FROM Object AS Object_Unit WHERE Object_Unit.DescId = zc_Object_Unit()
                    )
       , tmpPersonal AS (SELECT lfSelect.MemberId
                              , lfSelect.UnitId
                         FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                        )

       , tmpContainer AS (SELECT Container.Id          AS ContainerId
                                     , CLO_Location.ObjectId AS LocationId
                                     , COALESCE (ObjectLink_Car_Unit.ChildObjectId, tmpPersonal.UnitId, CLO_Location.ObjectId) AS UnitId
                                     , Container.ObjectId    AS GoodsId
                                    -- , COALESCE (CLO_GoodsKind.ObjectId, 0)    AS GoodsKindId
                                     , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                     , (COALESCE (Container.Amount,0)) AS Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND (COALESCE (Container.Amount,0) <> 0 OR inIsShowAll = TRUE)
                                     INNER JOIN ContainerLinkObject AS CLO_Location
                                                                    ON CLO_Location.ContainerId = Container.Id
                                                                   AND CLO_Location.DescId IN (zc_ContainerLinkObject_Car(), zc_ContainerLinkObject_Unit(),zc_ContainerLinkObject_Member())--  tmpWhere.DescId
                                                                   --AND CLO_Location.ObjectId = tmpWhere.LocationId
                                    /* LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()*/
                                     INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                                                  AND COALESCE (CLO_PartionGoods.ObjectId, 0) <> 0
                                     LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                   ON CLO_Account.ContainerId = Container.Id
                                                                  AND CLO_Account.DescId = zc_ContainerLinkObject_Account() 
                                     -- если это авто - находим его через zc_ObjectLink_Car_Unit, если физ лицо - находим в сотрудниках основное место работы, там подразделение
                                     LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                                          ON ObjectLink_Car_Unit.ObjectId = CLO_Location.ObjectId
                                                         AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                                     LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = CLO_Location.ObjectId

                                WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                                  AND COALESCE (CLO_Location.ObjectId,0) <> 0
                                  AND (COALESCE (ObjectLink_Car_Unit.ChildObjectId, tmpPersonal.UnitId, CLO_Location.ObjectId) = inUnitId OR inUnitId = 0)
                               )

       , tmpCLO_GoodsKind AS (SELECT ContainerLinkObject.*
                              FROM ContainerLinkObject
                              WHERE ContainerLinkObject.DescId = zc_ContainerLinkObject_GoodsKind()
                                AND ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                              )

       , tmpPartion AS (SELECT Object_PartionGoods.Id          AS Id
                             , Object_PartionGoods.ValueData   AS InvNumber
                             , Object_PartionGoods.ObjectCode  AS Code
                             , ObjectDate_Value.ValueData      AS OperDate
                             , ObjectFloat_Price.ValueData     AS Price
                  
                             , Object_Storage.Id               AS StorageId
                             , Object_Storage.ValueData        AS StorageName
                            
                             , Object_Unit.Id                  AS UnitId
                             , Object_Unit.ValueData           AS UnitName 
                             
                             , Object_PartionModel.Id          AS PartionModelId
                             , Object_PartionModel.ValueData   AS PartionModelName
                             
                             , ObjectString_PartNumber.ValueData AS PartNumber 
                        FROM (SELECT DISTINCT tmpContainer.PartionGoodsId FROM tmpContainer) AS tmp
                            INNER JOIN Object as Object_PartionGoods  ON Object_PartionGoods.Id = tmp.PartionGoodsId                       --партия

                            LEFT JOIN ObjectDate AS ObjectDate_Value
                                                 ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id                    -- дата
                                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()

                            LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                   ON ObjectString_PartNumber.ObjectId = Object_PartionGoods.Id                    -- дата
                                                  AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

                            LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                  ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id                       -- цена
                                                 AND ObjectFloat_Price.DescId = zc_ObjectFloat_PartionGoods_Price()    

                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = Object_PartionGoods.Id		        -- подразделение
                                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
                                    
                            LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                 ON ObjectLink_Storage.ObjectId = Object_PartionGoods.Id	                -- склад
                                                AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId  

                            LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                 ON ObjectLink_PartionModel.ObjectId = Object_PartionGoods.Id		        -- модель
                                                AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
                            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId
                        )

       , tmpStorage AS (SELECT spSelect.*
                        FROM gpSelect_Object_Storage (inSession) AS spSelect
                        )


       SELECT  tmpContainer.ContainerId
             , Object_Goods.Id                 AS GoodsId
             , Object_Goods.ObjectCode         AS GoodsCode
             , Object_Goods.ValueData          AS GoodsName
             , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
             , tmpContainer.Amount           ::TFloat
             , Object_GoodsKind.ValueData  AS GoodsKindName 
             , Object_Location.ObjectCode  AS LocationCode
             , Object_Location.ValueData   AS LocationName
             , ObjectDesc.ItemName         AS LocationDescName
             , tmpPartion.Id               AS PartionGoodsId
             , tmpPartion.InvNumber    

             , CASE WHEN tmpPartion.UnitId <> 0 AND tmpPartion.Code > 0
                       THEN zfCalc_PartionGoodsName_Asset (inMovementId      := tmpPartion.Code                --
                                                         , inInvNumber       := tmpPartion.InvNumber           -- Инвентарный номер
                                                         , inOperDate        := tmpPartion.OperDate            -- Дата ввода в эксплуатацию
                                                         , inUnitName        := tmpPartion.UnitName            -- Подразделение использования
                                                         , inStorageName     := tmpPartion.StorageName         -- Место хранения
                                                         , inGoodsName       := ''                             -- Основные средства или Товар
                                                          )
                  WHEN tmpPartion.UnitId <> 0
                       THEN zfCalc_PartionGoodsName_InvNumber (inInvNumber       := tmpPartion.InvNumber       -- Инвентарный номер
                                                             , inOperDate        := tmpPartion.OperDate        -- Дата перемещения
                                                             , inPrice           := tmpPartion.Price           -- Цена
                                                             , inUnitName_Partion:= tmpPartion.UnitName        -- Подразделение(для цены)
                                                             , inStorageName     := tmpPartion.StorageName     -- Место хранения
                                                             , inGoodsName       := ''                         -- Товар
                                                              )
                  ELSE COALESCE (tmpPartion.InvNumber, '')
             END :: TVarChar AS InvNumber_calc
             
             , tmpPartion.OperDate
             , tmpPartion.Price
             , tmpPartion.StorageName
             , tmpPartion.PartionModelName
             , tmpPartion.PartNumber
             , tmpPartion.UnitName     AS UnitName_partion
             , tmpStorage.UnitName     AS UnitName_storage
             , tmpStorage.BranchName   AS BranchName_storage
             , tmpStorage.AreaUnitName AS AreaUnitName_storage
             , tmpStorage.Room         AS Room_storage
             , tmpStorage.Address      AS Address_storage
             , tmpStorage.Comment      AS Comment_storage  

             , Object_Unit.ValueData   AS UnitName
             , Object_Branch.ValueData AS BranchName 
             
             , View_InfoMoney.InfoMoneyGroupName
             , View_InfoMoney.InfoMoneyDestinationName
             , View_InfoMoney.InfoMoneyCode
             , View_InfoMoney.InfoMoneyName
             , View_InfoMoney.InfoMoneyName_all
         FROM tmpContainer
              LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                            ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                           AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
              LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (CLO_GoodsKind.ObjectId, 0) 

              LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpContainer.LocationId
              LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location.DescId
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpContainer.GoodsId
              LEFT JOIN tmpPartion ON tmpPartion.Id = tmpContainer.PartionGoodsId 
              LEFT JOIN tmpStorage ON tmpStorage.Id = tmpPartion.StorageId

              LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                     ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                    AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpContainer.UnitId
              LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                   ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                  AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
              LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                   ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
              LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.23         *
*/

-- SELECT * FROM gpReport_Remains_Partion(inGoodsGroupId := 0, inGoodsId:= 7144, inIsShowAll:=true, inSession := zfCalc_UserAdmin():: TVarChar ) as tmp

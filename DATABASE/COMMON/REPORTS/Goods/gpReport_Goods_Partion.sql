-- Function: gpReport_Goods_Partion ()

DROP FUNCTION IF EXISTS gpReport_Goods_Partion (TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_Partion (
    IN inOperDate          TDateTime ,
    IN inUnitGroupId       Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inLocationId        Integer,    --
    IN inGoodsGroupId      Integer   ,
    IN inGoodsId           Integer   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , LocationId Integer, LocationCode Integer, LocationName TVarChar
             , PartionGoodsName_1 TVarChar, PartionGoodsName_2 TVarChar
             
             , MovementId_1       Integer
             , OperDate_1         TDateTime
             , InvNumber_1        TVarChar
             , MovementDescName_1 TVarChar
             , MovementId_2       Integer
             , OperDate_2         TDateTime
             , InvNumber_2        TVarChar
             , MovementDescName_2 TVarChar 
             , Amount             TFloat
             )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inOperDate, inOperDate, NULL, NULL, NULL, vbUserId);

     -- Результат
    RETURN QUERY

     WITH -- Ограничения по товару
           tmpGoods AS (SELECT lfSelect.GoodsId
                        FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                        WHERE inGoodsGroupId <> 0
                     UNION
                        SELECT Object.Id AS GoodsId
                        FROM Object
                        WHERE Object.DescId = zc_Object_Goods()
                          AND COALESCE (inGoodsGroupId, 0) = 0 
                          AND (Object.Id = inGoodsId OR inGoodsId = 0)
                     UNION
                        SELECT Object.Id AS GoodsId
                        FROM Object
                        WHERE Object.DescId = zc_Object_Asset()
                          AND (Object.Id = inGoodsId OR inGoodsId = 0)
                          AND COALESCE (inGoodsGroupId, 0) = 0
                        )

       , tmpWhere AS (SELECT lfSelect.UnitId AS LocationId, zc_ContainerLinkObject_Unit() AS DescId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect WHERE inLocationId = 0
                     UNION
                      SELECT lfSelect.UnitId AS LocationId, zc_ContainerLinkObject_Unit() AS DescId FROM lfSelect_Object_Unit_byGroup (inLocationId) AS lfSelect WHERE inLocationId <> 0
                     UNION
                      SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Car() AS DescId FROM Object WHERE Object.DescId = zc_Object_Car() AND (Object.Id = inLocationId OR (COALESCE(inLocationId, 0) = 0 AND COALESCE(inUnitGroupId, 0) = 0))
                     UNION
                      SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Member() AS DescId FROM Object WHERE Object.DescId = zc_Object_Member() AND (Object.Id = inLocationId OR (COALESCE(inLocationId, 0) = 0 AND COALESCE(inUnitGroupId, 0) = 0))
                     UNION
                      SELECT Object_Unit.Id AS LocationId, zc_ContainerLinkObject_Unit() AS DescId FROM Object AS Object_Unit WHERE Object_Unit.DescId = zc_Object_Unit() AND COALESCE (inLocationId, 0) = 0 AND COALESCE (inUnitGroupId, 0) = 0
                    )
       , tmpContainer_Count AS (SELECT Container.Id          AS ContainerId
                                     , CLO_Location.ObjectId AS LocationId
                                     , Container.ObjectId    AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , Container.Amount
                                FROM Container
                                     INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId 
                                   
                                     INNER JOIN ContainerLinkObject AS CLO_Location
                                                                    ON CLO_Location.ContainerId = Container.Id
                                     INNER JOIN tmpWhere ON tmpWhere.LocationId = CLO_Location.ObjectId
                                                        AND tmpWhere.DescId = CLO_Location.DescId
   
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()

                                     LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                   ON CLO_Account.ContainerId = Container.Id
                                                                  AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                WHERE Container.DescId = zc_Container_Count()
                                   AND COALESCE (Container.Amount,0) <> 0
                                   AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!    
                               )
         --остатки
       , tmpMIContainer AS (SELECT tmpContainer_Count.ContainerId
                                 , tmpContainer_Count.LocationId
                                 , tmpContainer_Count.GoodsId
                                 , tmpContainer_Count.GoodsKindId
                                 , tmpContainer_Count.Amount - SUM (COALESCE (MIContainer.Amount,0)) AS Amount
                            FROM tmpContainer_Count
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                AND MIContainer.OperDate >= inOperDate

                            GROUP BY tmpContainer_Count.ContainerId
                                   , tmpContainer_Count.LocationId
                                   , tmpContainer_Count.GoodsId
                                   , tmpContainer_Count.GoodsKindId
                                   , tmpContainer_Count.Amount
                            HAVING  tmpContainer_Count.Amount - SUM (COALESCE (MIContainer.Amount,0)) <> 0
                            )
                            
       , tmpMIContainer_1 AS (SELECT *
                              FROM (SELECT MIContainer.ContainerId
                                         , Movement.Id AS MovementId
                                         , Movement.OperDate
                                         , Movement.InvNumber
                                         , Movement.DescId
                                         , ROW_NUMBER () OVER (PARTITION BY MIContainer.ContainerId ORDER BY MIContainer.ContainerId, Movement.OperDate DESC, Movement.Id DESC) AS ord  
                                    FROM MovementItemContainer AS MIContainer
                                         LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId 
                                    WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpMIContainer.ContainerId FROM tmpMIContainer)
                                      AND COALESCE (MIContainer.Amount,0) > 0
                                    ) AS tmp
                              WHERE tmp.Ord = 1
                              )
       --ищем контейнер по которому gjnjv найдем контейнер прихода
       , tmp_analyzer AS (SELECT MIContainer.ContainerId
                               , MIContainer.ContainerintId_analyzer
                               , CLO_PartionGoods.ObjectId AS PartionGoodsId
                               , CLO_PartionGoods_analyzer.ObjectId AS PartionGoodsId_analyzer 
                          FROM MovementItemContainer AS MIContainer
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                            AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods_analyzer 
                                                             ON CLO_PartionGoods_analyzer.ContainerId = MIContainer.ContainerintId_analyzer
                                                            AND CLO_PartionGoods_analyzer.DescId = zc_ContainerLinkObject_PartionGoods()
                          WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpMIContainer.ContainerId FROM tmpMIContainer)
                            AND COALESCE (MIContainer.Amount,0) > 0 
                          )
       --
       , tmpMIContainer_2 AS (SELECT *
                              FROM (SELECT MIContainer.ContainerId
                                          , Movement.Id AS MovementId
                                          , Movement.OperDate
                                          , Movement.InvNumber
                                          , Movement.DescId
                                          , ROW_NUMBER () OVER (PARTITION BY MIContainer.ContainerId ORDER BY MIContainer.ContainerId, Movement.OperDate DESC, Movement.Id DESC) AS ord
                                     FROM MovementItemContainer AS MIContainer
                                           LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                                     WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmp_analyzer.ContainerintId_analyzer FROM tmp_analyzer)
                                       AND COALESCE (MIContainer.Amount,0) > 0
                                     ) AS tmp
                               WHERE tmp.Ord = 1
                               )
       
       , tmpRez AS (SELECT tmpMIContainer.ContainerId
                         , tmpMIContainer.LocationId
                         , tmpMIContainer.GoodsId
                         , tmpMIContainer.GoodsKindId 
                         , tmpMIContainer.Amount 
                         , tmp_analyzer.PartionGoodsId 
                         , tmp_analyzer.PartionGoodsId_analyzer
                         , tmpMIContainer_1.MovementId AS MovementId_1
                         , tmpMIContainer_1.OperDate   AS OperDate_1
                         , tmpMIContainer_1.InvNumber  AS InvNumber_1
                         , tmpMIContainer_1.DescId     AS DescId_1
                         , tmpMIContainer_2.MovementId AS MovementId_2
                         , tmpMIContainer_2.OperDate   AS OperDate_2
                         , tmpMIContainer_2.InvNumber  AS InvNumber_2
                         , tmpMIContainer_2.DescId     AS DescId_2
                    FROM tmpMIContainer
                    left join tmp_analyzer ON tmp_analyzer.ContainerId = tmpMIContainer.ContainerId
                    LEFT JOIN tmpMIContainer_1 ON tmpMIContainer_1.ContainerId = tmpMIContainer.ContainerId
                    LEFT JOIN tmpMIContainer_2 ON tmpMIContainer_2.ContainerId = tmp_analyzer.ContainerintId_analyzer       
                    )
  
       , tmpPartionGoods AS (SELECT tmpPartionGoods.PartionGoodsId
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
                                    END :: TVarChar AS PartionGoodsName

                             FROM (SELECT tmpRez.PartionGoodsId AS PartionGoodsId FROM tmpRez
                                 UNION
                                   SELECT tmpRez.PartionGoodsId_analyzer AS PartionGoodsId FROM tmpRez
                                   ) AS tmpPartionGoods
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpPartionGoods.PartionGoodsId

                                LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                     ON ObjectLink_Goods.ObjectId = tmpPartionGoods.PartionGoodsId
                                                    AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()

                                LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                     ON ObjectLink_Unit.ObjectId = tmpPartionGoods.PartionGoodsId
                                                    AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                     ON ObjectLink_Storage.ObjectId = tmpPartionGoods.PartionGoodsId
                                                    AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                                LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId

                                LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                     ON ObjectDate_PartionGoods_Value.ObjectId = tmpPartionGoods.PartionGoodsId
                                                    AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()

                                LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                                      ON ObjectFloat_PartionGoods_Price.ObjectId = tmpPartionGoods.PartionGoodsId
                                                     AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price()

                                LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                     ON ObjectLink_PartionModel.ObjectId = tmpPartionGoods.PartionGoodsId
                                                    AND ObjectLink_PartionModel.DescId   = zc_ObjectLink_PartionGoods_PartionModel()
                                LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId

                                LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                       ON ObjectString_PartNumber.ObjectId = tmpPartionGoods.PartionGoodsId
                                                      AND ObjectString_PartNumber.DescId   = zc_ObjectString_PartionGoods_PartNumber()
                              )
  

             
       -- Результаті
       SELECT Object_GoodsGroup.Id                       AS GoodsGroupId
            , Object_GoodsGroup.ValueData                AS GoodsGroupName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
            , Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , Object_GoodsKind.ValueData                 AS GoodsKindName
            , Object_Measure.ValueData                   AS MeasureName
            , Object_Location.Id                         AS LocationId
            , Object_Location.ObjectCode                 AS LocationCode
            , Object_Location.ValueData                  AS LocationName
            , tmpPartionGoods.PartionGoodsName           AS PartionGoodsName_1
            , tmpPartionGoods_analyzer.PartionGoodsName  AS PartionGoodsName_2

            , tmpRez.MovementId_1
            , tmpRez.OperDate_1
            , tmpRez.InvNumber_1
            , MovementDesc_1.ItemName AS MovementDescName_1
            , tmpRez.MovementId_2
            , tmpRez.OperDate_2
            , tmpRez.InvNumber_2
            , MovementDesc_2.ItemName AS MovementDescName_2 
            , tmpRez.Amount ::TFloat
     FROM tmpRez
          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpRez.LocationId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpRez.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpRez.GoodsKindId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN tmpPartionGoods ON tmpPartionGoods.PartionGoodsId = tmpRez.PartionGoodsId
          LEFT JOIN tmpPartionGoods AS tmpPartionGoods_analyzer ON tmpPartionGoods_analyzer.PartionGoodsId = tmpRez.PartionGoodsId_analyzer
       
          LEFT JOIN MovementDesc AS MovementDesc_1 ON MovementDesc_1.Id = tmpRez.DescId_1
          LEFT JOIN MovementDesc AS MovementDesc_2 ON MovementDesc_2.Id = tmpRez.DescId_2
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.23         *
*/

-- тест
-- SELECT * FROM gpReport_Goods_Partion (inOperDate:= '01.11.2023', inUnitGroupId:=0, inLocationId:= 0 , inGoodsGroupId:= 0, inGoodsId:= 3037534, inSession:= zfCalc_UserAdmin()); 
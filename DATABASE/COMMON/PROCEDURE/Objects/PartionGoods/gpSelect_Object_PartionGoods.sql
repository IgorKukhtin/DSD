-- Function: gpSelect_Object_PartionGoods()


DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoods(
    IN inGoodsId      Integer   ,
    IN inUnitId       Integer   ,    
    IN inShowAll      Boolean,     
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar 
             , OperDate TDateTime, Price TFloat
             , GoodsId Integer, GoodsName TVarChar
             , StorageId Integer, StorageName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Amount TFloat
             , isErased boolean
              ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());

     RETURN QUERY 
  
  WITH tmpContainer_Count AS (SELECT Container.ObjectId AS GoodsId
                                   , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                   , Container.Amount
                              FROM Container 
                                   LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = Container.Id
                                                                            AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                           -- AND CLO_Unit.ObjectId > 0
                                  
                                   LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = Container.Id
                                                                              AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                            --  AND CLO_Member.ObjectId > 0
                                                                              
                                  LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                    AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                
                             WHERE  (Container.ObjectId = inGoodsId OR (inGoodsId = 0 AND inUnitId > 0))
                                AND Container.DescId = zc_Container_Count()
                                AND ((CLO_Unit.ObjectId = inUnitId) OR (CLO_Member.ObjectId = inUnitId) OR inUnitId = 0)
                                AND (Container.Amount > 0 OR inShowAll = False)
                             )

     SELECT
             Object_PartionGoods.Id          AS Id
           , Object_PartionGoods.ValueData AS InvNumber
           , ObjectDate_Value.ValueData    AS  OperDate
           , ObjectFloat_Price.ValueData   AS  Price
           
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ValueData   AS GoodsName

           , Object_Storage.Id          AS StorageId
           , Object_Storage.ValueData   AS StorageName
          
           , Object_Unit.Id          AS UnitId
           , Object_Unit.ValueData   AS UnitName
           , tmpContainer_Count.Amount
                     
           , Object_PartionGoods.isErased AS isErased

     FROM ObjectLink AS ObjectLink_Goods
          INNER JOIN Object as Object_PartionGoods  ON Object_PartionGoods.Id = ObjectLink_Goods.ObjectId                       --партия

          INNER JOIN ObjectDate as objectdate_value ON objectdate_value.ObjectId = ObjectLink_Goods.ObjectId                    -- дата
                                                   AND objectdate_value.DescId = zc_ObjectDate_PartionGoods_Value()
                                                        
          JOIN ObjectFloat AS ObjectFloat_Price ON ObjectFloat_Price.ObjectId = ObjectLink_Goods.ObjectId                       -- цена
                                               AND ObjectFloat_Price.DescId = zc_ObjectFloat_PartionGoods_Price()    

          LEFT JOIN ObjectLink AS ObjectLink_Unit ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId		        -- подразделение
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                                  --AND (ObjectLink_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
          JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
                                    
          LEFT JOIN ObjectLink AS ObjectLink_Storage ON ObjectLink_Storage.ObjectId = ObjectLink_Goods.ObjectId		-- склад
                                                     AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
          LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId  
                                                                                 
          INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId                                 -- товар         

          JOIN  tmpContainer_Count ON tmpContainer_Count.PartionGoodsId =  Object_PartionGoods.Id
                                       AND tmpContainer_Count.GoodsId =  ObjectLink_Goods.ChildObjectId   
            
     WHERE (ObjectLink_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
       AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods();

  
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
-- select * from gpSelect_Object_PartionGoods(inGoodsId := 18385 , inUnitId := 13103, inShowAll := 'True' ,  inSession := '5');
-- select * from gpSelect_Object_PartionGoods(inGoodsId := 18385 , inUnitId := 13103, inShowAll := 'False',  inSession := '5');

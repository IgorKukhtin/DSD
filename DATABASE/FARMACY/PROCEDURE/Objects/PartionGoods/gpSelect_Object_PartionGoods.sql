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
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());

    RETURN QUERY 
        WITH tmpContainer_Count 
        AS 
        (
            SELECT 
                Container.ObjectId                      AS GoodsId
               ,COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
               ,CLO_Unit.ObjectId                       AS UnitId
               ,Container.Amount                        AS Amount
            FROM 
                Container 
                LEFT JOIN ContainerLinkObject AS CLO_Unit 
                                              ON CLO_Unit.ContainerId = Container.Id
                                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()

                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods 
                                              ON CLO_PartionGoods.ContainerId = Container.Id
                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionMovementItem()

            WHERE
                Container.ObjectId = inGoodsId
                AND
                Container.DescId = zc_Container_Count()
                AND
                (
                    CLO_Unit.ObjectId = inUnitId
                    OR 
                    inUnitId = 0
                )
                AND
                (
                    Container.Amount > 0 
                    OR 
                    inShowAll = TRUE
                )
        )
        SELECT
            Object_PartionGoods.Id            AS Id
           ,Movement.InvNumber                AS InvNumber
           ,Movement.OperDate                 AS  OperDate
           ,MovementItemFloat_Price.ValueData AS  Price
           
           ,Object_Goods.Id                   AS GoodsId
           ,Object_Goods.ValueData            AS GoodsName
           
           ,NULL::Integer                     AS StorageId
           ,NULL::TVarChar                    AS StorageName
           
           ,Object_Unit.Id                    AS UnitId
           ,Object_Unit.ValueData             AS UnitName
           ,tmpContainer_Count.Amount         AS Amount
                     
           ,Object_PartionGoods.isErased      AS isErased

        FROM 
            tmpContainer_Count
            LEFT JOIN Object AS Object_PartionGoods  
                              ON Object_PartionGoods.Id = tmpContainer_Count.PartionGoodsId            --партия

            LEFT JOIN MovementItem ON MovementItem.Id = Object_PartionGoods.ObjectCode                 -- дата
            LEFT JOIN Movement ON MovementItem.MovementId = Movement.Id                                -- дата
                                                        
            LEFT JOIN MovementItemFloat AS MovementItemFloat_Price 
                             ON MovementItemFloat_Price.MovementItemId = MovementItem.Id               -- цена
                            AND MovementItemFloat_Price.DescId = zc_MIFloat_Price()    

            LEFT JOIN Object AS Object_Unit 
                        ON Object_Unit.Id = tmpContainer_Count.UnitId
                                    
            LEFT JOIN Object AS Object_Goods 
                              ON Object_Goods.Id = tmpContainer_Count.GoodsId                          -- товар   
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
--select * from gpSelect_Object_PartionGoods(inGoodsId := 18385 , inUnitId := 13103, inShowAll := 'True' ,  inSession := '5');
--select * from gpSelect_Object_PartionGoods(inGoodsId := 18385 , inUnitId := 13103, inShowAll := 'False' ,  inSession := '5');
-- Function: gpSelect_Object_PartionGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (Integer, Integer, TVarChar);
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
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());

     RETURN QUERY 
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
                     
           , Object_PartionGoods.isErased AS isErased
           
       FROM Object AS Object_PartionGoods
            JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id 
                                               AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()

            JOIN ObjectFloat AS ObjectFloat_Price ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id 
                                               AND ObjectFloat_Price.DescId = zc_ObjectFloat_PartionGoods_Price()
                                                                                                          
            JOIN ObjectLink AS ObjectLink_PartionGoods_Goods ON ObjectLink_PartionGoods_Goods.ObjectId = Object_PartionGoods.Id 
                                                            AND ObjectLink_PartionGoods_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
                                                            AND (ObjectLink_PartionGoods_Goods.ChildObjectId = inGoodsId or inGoodsId = 0)
            JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PartionGoods_Goods.ChildObjectId         
           
            LEFT  JOIN ObjectLink AS ObjectLink_PartionGoods_Storage ON ObjectLink_PartionGoods_Storage.ObjectId = Object_PartionGoods.Id 
                                                                    AND ObjectLink_PartionGoods_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_PartionGoods_Storage.ChildObjectId  
           
            JOIN ObjectLink AS ObjectLink_PartionGoods_Unit ON ObjectLink_PartionGoods_Unit.ObjectId = Object_PartionGoods.Id 
                                                           AND ObjectLink_PartionGoods_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                                           And (ObjectLink_PartionGoods_Unit.ChildObjectId = inUnitId Or inUnitId =0) 
            JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_PartionGoods_Unit.ChildObjectId

      WHERE Object_PartionGoods.DescId = zc_Object_PartionGoods();
  
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
--SELECT * FROM gpSelect_Object_PartionGoods('2')
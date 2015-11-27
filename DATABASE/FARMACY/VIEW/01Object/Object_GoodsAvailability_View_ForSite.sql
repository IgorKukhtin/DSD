-- View: Object_GoodsAvailability_View_ForSite

DROP VIEW IF EXISTS Object_GoodsAvailability_View_ForSite;

CREATE OR REPLACE VIEW Object_GoodsAvailability_View_ForSite AS
    SELECT 
        Object_Goods.Id                                         as product_id
       ,Object_Price.UnitId                                     as pharmacy_id
       ,SUM(Container.Amount)::TFloat                           as quantity
       ,Object_Price.Price                                      as Price
       ,CASE WHEN Object_Goods.isErased = TRUE THEN 1::Integer ELSE 0::Integer END as deleted
       ,Object_Goods.ObjectId as ObjectId
    FROM Object_Goods_View AS Object_Goods
        LEFT OUTER JOIN Object_Price_View AS Object_Price
                                          ON Object_Price.GoodsId = Object_Goods.ID
        LEFT OUTER JOIN Container ON Container.ObjectId = Object_Goods.Id
                                 AND Container.WhereObjectId = Object_Price.UnitId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    GROUP BY 
        Object_Goods.Id
       ,Object_Price.UnitId
       ,Object_Price.Price
       ,Object_Goods.isErased
       ,Object_Goods.ObjectId;
       
ALTER TABLE Object_GoodsAvailability_View_ForSite  OWNER TO postgres;
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 26.11.15                                                          *
*/

--Select * from Object_GoodsAvailability_View_ForSite as Object_GoodsAvailability Where Object_GoodsAvailability.ObjectId = lpGet_DefaultValue('zc_Object_Retail', 3)::Integer /*AND Object_GoodsAvailability.product_id = 5787*/
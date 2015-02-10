-- View: Object_Unit_View

DROP VIEW IF EXISTS MovementItem_ReturnOut_View;

CREATE OR REPLACE VIEW MovementItem_ReturnOut_View AS 
       SELECT
             MovementItem.Id                    AS Id
           , MovementItem.ObjectId              AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , MovementItem.Amount                AS Amount
           , MIFloat_Price.ValueData            AS Price
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
           , MovementItem.isErased              AS isErased
           , MovementItem.MovementId            AS MovementId
           , MovementItem.ParentId              AS ParentId

       FROM  MovementItem 
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

   WHERE MovementItem.DescId     = zc_MI_Master();


ALTER TABLE MovementItem_ReturnOut_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.02.15                        * 
*/

-- тест
-- SELECT * FROM Movement_Income_View where id = 805

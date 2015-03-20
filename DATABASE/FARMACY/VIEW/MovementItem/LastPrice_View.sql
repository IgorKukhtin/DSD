-- View: Object_Unit_View

DROP VIEW IF EXISTS LastPrice_View;

CREATE OR REPLACE VIEW LastPrice_View AS 
SELECT MainGoods.GoodsCode, 
       MainGoods.GoodsName, 
       MainGoods.NDS, 
       Amount AS Price, 
       Juridical.ValueData AS JuridicalName, 
       Contract.ValueData AS ContractName,
       JuridicalGoods.goodscode AS JuridicalGoodsCode,
       JuridicalGoods.goodsName AS JuridicalGoodsName

FROM LastPriceList_View

   JOIN MovementItem AS PriceList ON PriceList.movementid = LastPriceList_View.MovementId
   JOIN object_goods_Main_view AS MainGoods ON MainGoods.Id = PriceList.ObjectId
   JOIN OBJECT AS Juridical ON Juridical.Id = LastPriceList_View.JuridicalId
   LEFT JOIN OBJECT AS Contract ON Contract.Id = LastPriceList_View.ContractId
   LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                    ON MILinkObject_Goods.MovementItemId = PriceList.Id
                                   AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
   LEFT JOIN object_goods_view AS JuridicalGoods ON JuridicalGoods.Id = MILinkObject_Goods.ObjectId;


ALTER TABLE LastPrice_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.15                        * 
*/

-- тест
-- SELECT * FROM Movement_Income_View where id = 805

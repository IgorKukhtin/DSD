-- Function: gpSelect_Update_LeftTheMarket()

DROP FUNCTION IF EXISTS gpSelect_Update_LeftTheMarket(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Update_LeftTheMarket(
    IN inSession           TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    --
    vbUserId := lpGetUserBySession (inSession);
   
    PERFORM gpUpdate_Goods_isLeftTheMarket (T1.GoodsId, T1.isLeftTheMarket, inSession)
    FROM (
      WITH tmpLoadPriceList AS (SELECT DISTINCT LoadPriceListItem.GoodsId 
                                FROM LoadPriceList
                                   
                                     INNER JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.id
                                                                 AND LoadPriceListItem.GoodsId IS NOT NULL
                                       
                                )
         , tmpPriceList AS (SELECT DISTINCT MovementItem.ObjectId   AS GoodsId
                            FROM Movement

                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = False
                                                        AND MovementItem.ObjectId IS NOT NULL
                                                         
                            WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '45 DAY'
                              AND Movement.DescId = zc_Movement_PriceList()
                              AND Movement.StatusId  <> zc_Enum_Status_Erased()
                            )
         , tmpGoods AS (SELECT COALESCE (tmpLoadPriceList.GoodsId, tmpPriceList.GoodsId)  AS GoodsId
                        FROM tmpLoadPriceList
                          
                             FULL JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpLoadPriceList.GoodsId
                        )
                                  
                                  
                                  
      SELECT Object_Goods_Main.Id                 AS GoodsId
            , COALESCE(tmpGoods.GoodsId, 0) = 0   AS isLeftTheMarket
      FROM Object_Goods_Main
        
           LEFT JOIN tmpGoods ON tmpGoods.GoodsId = Object_Goods_Main.Id
             
      WHERE Object_Goods_Main.isLeftTheMarket <> (COALESCE(tmpGoods.GoodsId, 0) = 0)) AS  T1;
    

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.08.22                                                       *
*/    

SELECT * FROM gpSelect_Update_LeftTheMarket (inSession := zfCalc_UserAdmin());
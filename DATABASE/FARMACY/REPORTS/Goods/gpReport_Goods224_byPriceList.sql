-- Function: gpReport_Goods224_byPriceList()

DROP FUNCTION IF EXISTS gpReport_Goods224_byPriceList (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods224_byPriceList(
    IN inPrice         TFloat     --
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer
             , GoodsCode_int Integer, GoodsCode TVarChar
             , GoodsName TVarChar
             , RetailName TVarChar
             , NDS TFloat
             , PriceWithVAT TFloat
             , PercentMarkup  TFloat
             , isTop Boolean
             , isSp Boolean
              )


AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH
    -- товары постановления 224
    tmpGoods_224 AS (SELECT Object_Goods_Main.Id   AS GoodsMainId
                          , Object_Goods_Main.ObjectCode AS ObjectCode--, Object_Goods_Retail.Id AS goodsId     -- товар сети , если нужно будет 
                          , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)    ::TFloat  AS NDS
                          , COALESCE (ObjectBoolean_Goods_SP.ValueData, FALSE) ::Boolean AS isSp
                     FROM Object_Goods_Main
                        -- LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id and  1 = 0
                         LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                               ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                              AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SP
                                                 ON ObjectBoolean_Goods_SP.ObjectId = Object_Goods_Main.Id
                                                AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                                   
                     WHERE Object_Goods_Main.isResolution_224 = TRUE
                     )

  , tmpLoadPriceListItem AS (SELECT LoadPriceListItem.*
                                  , ROW_NUMBER() OVER (PARTITION BY LoadPriceListItem.GoodsId ORDER BY LoadPriceListItem.Id DESC) AS ord
                             FROM LoadPriceListItem
                                  INNER JOIN tmpGoods_224 ON tmpGoods_224.GoodsMainId = LoadPriceListItem.GoodsId
                             )

  , tmpData AS (SELECT LoadPriceListItem.*
                     , tmpGoods_224.NDS
                     , tmpGoods_224.isSp
                     , tmpGoods_224.ObjectCode 
                     , (LoadPriceListItem.Price * (1+ tmpGoods_224.NDS / 100)) AS PriceWithVAT
                FROM tmpGoods_224
                 INNER JOIN (SELECT tmpLoadPriceListItem.*
                             FROM tmpLoadPriceListItem
                             WHERE tmpLoadPriceListItem.Ord = 1) AS LoadPriceListItem
                                              ON LoadPriceListItem.GoodsId = tmpGoods_224.GoodsMainId
                WHERE (LoadPriceListItem.Price * ( 1+ tmpGoods_224.NDS / 100)) <= inPrice
                )


      --

      SELECT tmpData.GoodsId                          AS GoodsId
           , tmpData.ObjectCode                       AS GoodsCode_int 
           , tmpData.GoodsCode         ::TVarChar     AS GoodsCode
           
           , tmpData.GoodsName                        AS GoodsName
           , Object_Retail.ValueData                  AS RetailName
           , tmpData.NDS               ::TFloat       AS NDS
           , tmpData.PriceWithVAT      ::TFloat       AS PriceWithVAT

           , Object_Goods_Retail.PercentMarkup :: TFloat
           , Object_Goods_Retail.isTop         :: Boolean
           , tmpData.isSp                      :: Boolean

      FROM tmpData

        LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = tmpData.GoodsId

        INNER JOIN Object AS Object_Retail ON Object_Retail.Id = Object_Goods_Retail.RetailId
      ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.12.20         *

*/

-- тест
--SELECT * FROM gpReport_Goods224_byPriceList (inPrice:= 25, inSession:= '3') order by  1, 5,7
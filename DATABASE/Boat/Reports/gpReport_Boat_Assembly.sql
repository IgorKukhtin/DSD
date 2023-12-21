-- Function: gpReport_Boat_Assembly

DROP FUNCTION IF EXISTS gpReport_Boat_Assembly (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Boat_Assembly (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Boat_Assembly(
    IN inisGoods            Boolean , --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (ClientId Integer, ClientCode Integer, ClientName TVarChar
             , TaxKindName_Client TVarChar
             , MovementId_OrderClient Integer, InvNumberFull_OrderClient TVarChar, InvNumber_OrderClient TVarChar, OperDate_OrderClient TDateTime
             , StateText TVarChar
             , StateText_Complete TVarChar
             , DateBegin TDateTime  
             , NPP_OrderClient Integer
             , NPP_2 Integer  
             , ProductName TVarChar
             , ObjectId Integer
             , ObjectCode Integer
             , ObjectName TVarChar
             , Article_all TVarChar
             , GoodsGroupNameFull TVarChar

             --
             , TotalCount  TFloat
             , Remains_111 TFloat
             , Remains_112 TFloat
             , Amount      TFloat  
            --
             , Amount_111 TVarChar
             , Amount_112 TVarChar
             , Amount_12  TVarChar
             , Amount_13  TVarChar
             , Amount_14  TVarChar
             , Amount_15  TVarChar
             , Amount_16  TVarChar
             , Amount_17  TVarChar
             , Amount_18  TVarChar
             , Amount_19  TVarChar
          
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMemberId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
     WITH
     tmpProduct AS(SELECT gpSelect.*
                   FROM gpSelect_Object_Product (0, FALSE, FALSE, '') AS gpSelect
                  -- WHERE gpSelect.OperDate_OrderClient BETWEEN inStartDate AND inEndDate
                  )
   -- комплектующие из док заказов    
   , tmpGoods AS (
                 SELECT  
                        MovementItem.Id                           AS MovementItemId
                      , MovementItem.MovementId                   AS MovementId
                      , MovementItem.PartionId                    AS PartionId
                      , MILinkObject_Unit.ObjectId                AS UnitId
                      , MILinkObject_Partner.ObjectId             AS PartnerId
                        -- какой Узел собирается
                      , COALESCE (MILinkObject_Goods.ObjectId, 0) AS GoodsId
                        -- Комплектующие
                      , MovementItem.ObjectId                     AS ObjectId
                      , MovementItem.Amount                       AS Amount
                      --, SUM (COALESCE (MovementItem.Amount,0)) OVER (PARTITION BY MovementItem.ObjectId) AS TotalAmount 
                      , COUNT (*) OVER (PARTITION BY MovementItem.MovementId) AS TotalCount 
                      , ROW_NUMBER () OVER (PARTITION BY MovementItem.ObjectId ORDER BY tmp.NPP_2) AS Ord
                 FROM (SELECT DISTINCT tmpProduct.MovementId_OrderClient AS MovementId
                            , tmpProduct.NPP_2
                       FROM tmpProduct) AS tmp
                      INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                             AND MovementItem.DescId IN (zc_MI_Child(), zc_MI_Detail())
                                             AND MovementItem.isErased = FALSE

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                       ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                       ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                       ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                 )
   , tmpGoods_mi AS (SELECT tmpGoods.MovementId
                            , tmpGoods.ObjectId
                          , SUM (COALESCE (tmpGoods_2.Amount,0))  AS Amount_total 
                     FROM tmpGoods 
                         LEFT JOIN tmpGoods AS tmpGoods_2
                                            ON tmpGoods_2.ObjectId = tmpGoods.ObjectId
                                           AND tmpGoods_2.Ord < tmpGoods.Ord 
                     GROUP BY tmpGoods.MovementId
                            , tmpGoods.ObjectId
                            , tmpGoods.Amount
                     )

    -- остатки текущие Основной склад - 35139
   , tmpContainer_111 AS (SELECT Container.ObjectId                  AS GoodsId
                                -- Остаток кол-во
                               , SUM (COALESCE (Container.Amount,0))  AS Remains
                          FROM Container
                           WHERE Container.DescId = zc_Container_Count() 
                             AND Container.WhereObjectId = 35139      
                             AND Container.Amount <> 0
                          GROUP BY Container.ObjectId
                         )
    --остатки текущие Участок сборки Стеклопластик  - 253868
   , tmpContainer_112 AS (SELECT Container.ObjectId                  AS GoodsId
                                -- Остаток кол-во
                               , SUM (COALESCE (Container.Amount,0))  AS Remains
                          FROM Container
                           WHERE Container.DescId = zc_Container_Count() 
                             AND Container.WhereObjectId = 253868    
                             AND Container.Amount <> 0
                          GROUP BY Container.ObjectId
                         )
    -- 
   , tmpData AS (SELECT tmpGoods.MovementId
                      , CASE WHEN inisGoods = TRUE THEN tmpGoods.ObjectId ELSE 0 END AS ObjectId 
                      , tmpGoods.TotalCount
                      , SUM (COALESCE (tmpGoods.Amount,0)) AS Amount
                      , SUM (COALESCE (tmpContainer_111.Remains,0)) AS Remains_111
                      , SUM (COALESCE (tmpContainer_112.Remains,0)) AS Remains_112
                      , SUM (COALESCE (tmpGoods_mi.Amount_total,0)) AS Amount_total  --сколько уже в использовании в др. заказах
                      , SUM (CASE WHEN COALESCE (tmpContainer_111.Remains,0) - COALESCE (tmpGoods_mi.Amount_total,0) < tmpGoods.Amount THEN 0 ELSE 1 END) AS Count_111
                      , SUM (CASE WHEN COALESCE (tmpContainer_112.Remains,0) - COALESCE (tmpGoods_mi.Amount_total,0) < tmpGoods.Amount THEN 0 ELSE 1 END) AS Count_112 
                      
                 FROM tmpGoods
                      LEFT JOIN tmpGoods_mi ON tmpGoods_mi.ObjectId = tmpGoods.ObjectId
                                           AND tmpGoods_mi.MovementId = tmpGoods.MovementId
                      LEFT JOIN tmpContainer_111 ON tmpContainer_111.GoodsId = tmpGoods.ObjectId
                      LEFT JOIN tmpContainer_112 ON tmpContainer_112.GoodsId = tmpGoods.ObjectId
                 GROUP BY tmpGoods.MovementId
                        , CASE WHEN inisGoods = TRUE THEN tmpGoods.ObjectId ELSE 0 END 
                        , tmpGoods.TotalCount
                )


     SELECT
            tmpProduct.ClientId
          , tmpProduct.ClientCode
          , tmpProduct.ClientName
          , tmpProduct.TaxKindName_Client
          , tmpProduct.MovementId_OrderClient
          , tmpProduct.InvNumberFull_OrderClient 
          , tmpProduct.InvNumber_OrderClient
          , tmpProduct.OperDate_OrderClient
         
          , tmpProduct.StateText
          , CASE WHEN tmpProduct.StateText = 'Готова' THEN 'Completed'
                 ELSE '' 
            END :: TVarChar AS StateText_Complete
          , tmpProduct.DateBegin  
          , tmpProduct.NPP_OrderClient
          , tmpProduct.NPP_2 
          
          , tmpProduct.Name AS ProductName
          
          , Object_Object.Id         AS ObjectId
          , Object_Object.ObjectCode AS ObjectCode
          , Object_Object.ValueData  AS ObjectName
          , zfCalc_Article_all (ObjectString_Article.ValueData)::TVarChar AS Article_all
          , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull

            --
          , tmpData.TotalCount :: TFloat
          , tmpData.Remains_111    :: TFloat
          , tmpData.Remains_112    :: TFloat 
          , tmpData.Amount     :: TFloat
          --
          , (''||tmpData.Count_111 ||' из '|| tmpData.TotalCount)::TVarChar AS Amount_111
          , (''||tmpData.Count_112 ||' из '|| tmpData.TotalCount)::TVarChar AS Amount_112
          , ''::TVarChar AS Amount_12
          , ''::TVarChar AS Amount_13
          , ''::TVarChar AS Amount_14
          , ''::TVarChar AS Amount_15
          , ''::TVarChar AS Amount_16
          , ''::TVarChar AS Amount_17
          , ''::TVarChar AS Amount_18
          , ''::TVarChar AS Amount_19

   FROM tmpProduct
       LEFT JOIN tmpData ON tmpData.MovementId = tmpProduct.MovementId_OrderClient
       LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpData.ObjectId 

       LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                              ON ObjectString_GoodsGroupFull.ObjectId = tmpData.ObjectId
                             AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
       LEFT JOIN ObjectString AS ObjectString_Article
                              ON ObjectString_Article.ObjectId = tmpData.ObjectId
                             AND ObjectString_Article.DescId = zc_ObjectString_Article()

  ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.12.23         *
*/

-- тест
-- 
-- SELECT * FROM gpReport_Boat_Assembly(inisGoods := false ,  inSession := '5')
--where MovementId_OrderClient = 708;

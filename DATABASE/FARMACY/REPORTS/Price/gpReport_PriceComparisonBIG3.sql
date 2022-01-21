-- Function: gpReport_PriceComparisonBIG3()

DROP FUNCTION IF EXISTS gpReport_PriceComparisonBIG3 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PriceComparisonBIG3(
    IN inLoadPriceListId  Integer   , -- Прайс
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Price TFloat
             , ContractName1 TVarChar, AreaName1 TVarChar, Price1 TFloat, D1 TFloat
             , ContractName2 TVarChar, AreaName2 TVarChar, Price2 TFloat, D2 TFloat
             , ContractName3 TVarChar, AreaName3 TVarChar, Price3 TFloat, D3 TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAreaId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT LoadPriceList.AreaId 
    INTO vbAreaId 
    FROM LoadPriceList
    WHERE LoadPriceList.Id = inLoadPriceListId;
     
    RETURN QUERY 
    WITH tmpLoadPriceListBIG3 AS (SELECT ROW_NUMBER()OVER(PARTITION BY LoadPriceList.JuridicalId ORDER BY CASE WHEN LoadPriceList.AreaId = COALESCE(vbAreaId, 0) THEN 0 ELSE 1 END,
                                                                            CASE WHEN COALESCE (ObjectBoolean_Report.ValueData, FALSE) = TRUE THEN 0 ELSE 1 END,
                                                                            CASE WHEN LoadPriceList.AreaId = COALESCE(0 , 0) THEN 0 ELSE 1 END,
                                                                            CASE WHEN LoadPriceList.AreaId = COALESCE(5803492 , 0) THEN 0 ELSE 1 END)  as ORD
                                       , LoadPriceList.Id
                                       , LoadPriceList.ContractId
                                       , Object_Contract.ValueData   AS ContractName
                                       , LoadPriceList.JuridicalId 
                                       , LoadPriceList.AreaId 
                                       , Object_Area.ValueData      AS AreaName
                                  FROM LoadPriceList

                                       LEFT JOIN ObjectBoolean AS ObjectBoolean_Report
                                                               ON ObjectBoolean_Report.ObjectId = LoadPriceList.ContractId 
                                                              AND ObjectBoolean_Report.DescId = zc_ObjectBoolean_Contract_Report()

                                       JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId 

                                       LEFT JOIN Object AS Object_Area ON Object_Area.Id = LoadPriceList.AreaId 

                                  WHERE LoadPriceList.JuridicalId in (59610, 59611, 59612)
                                 )
       , tmpLoadPriceListItem AS (SELECT LoadPriceListItem.GoodsId
                                       , MAX(LoadPriceListItem.Price)::TFloat AS Price

                                  FROM LoadPriceListItem
                                  WHERE LoadPriceListItem.LoadPriceListId = inLoadPriceListId
                                  GROUP BY LoadPriceListItem.GoodsId)
       , tmpLoadPriceList1 AS (SELECT tmpLoadPriceListBIG3.Id
                                    , tmpLoadPriceListBIG3.ContractName
                                    , tmpLoadPriceListBIG3.AreaName
                               FROM tmpLoadPriceListBIG3 
                               WHERE tmpLoadPriceListBIG3.ORD = 1 
                                 AND tmpLoadPriceListBIG3.JuridicalId = 59610)
       , tmpLoadPriceListItem1 AS (SELECT LoadPriceListItem.GoodsId
                                        , MAX(LoadPriceListItem.Price)::TFloat AS Price
                                   FROM tmpLoadPriceList1 
                                   
                                        JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = tmpLoadPriceList1.Id
                                   
                                   GROUP BY LoadPriceListItem.GoodsId 
                                   )
       , tmpLoadPriceList2 AS (SELECT tmpLoadPriceListBIG3.Id
                                    , tmpLoadPriceListBIG3.ContractName
                                    , tmpLoadPriceListBIG3.AreaName
                               FROM tmpLoadPriceListBIG3 
                               WHERE tmpLoadPriceListBIG3.ORD = 1 
                                 AND tmpLoadPriceListBIG3.JuridicalId = 59611)
       , tmpLoadPriceListItem2 AS (SELECT LoadPriceListItem.GoodsId
                                        , MAX(LoadPriceListItem.Price)::TFloat AS Price
                                   FROM tmpLoadPriceList2 
                                   
                                        JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = tmpLoadPriceList2.Id
                                    
                                   GROUP BY LoadPriceListItem.GoodsId 
                                   )
       , tmpLoadPriceList3 AS (SELECT tmpLoadPriceListBIG3.Id
                                    , tmpLoadPriceListBIG3.ContractName
                                    , tmpLoadPriceListBIG3.AreaName
                               FROM tmpLoadPriceListBIG3 
                               WHERE tmpLoadPriceListBIG3.ORD = 1 
                                 AND tmpLoadPriceListBIG3.JuridicalId = 59612)
       , tmpLoadPriceListItem3 AS (SELECT LoadPriceListItem.GoodsId
                                        , MAX(LoadPriceListItem.Price)::TFloat AS Price
                                   FROM tmpLoadPriceList3 
                                   
                                        JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = tmpLoadPriceList3.Id
                                    
                                   GROUP BY LoadPriceListItem.GoodsId 
                                   )
    

    SELECT LoadPriceListItem.GoodsId
         , Object_Goods.ObjectCode
         , Object_Goods.Name
         , LoadPriceListItem.Price

         , tmpLoadPriceList1.ContractName
         , tmpLoadPriceList1.AreaName
         , tmpLoadPriceListItem1.Price
         , (LoadPriceListItem.Price - tmpLoadPriceListItem1.Price)::TFloat AS D

         , tmpLoadPriceList2.ContractName
         , tmpLoadPriceList2.AreaName
         , tmpLoadPriceListItem2.Price
         , (LoadPriceListItem.Price - tmpLoadPriceListItem2.Price)::TFloat AS D

         , tmpLoadPriceList3.ContractName
         , tmpLoadPriceList3.AreaName
         , tmpLoadPriceListItem3.Price
         , (LoadPriceListItem.Price - tmpLoadPriceListItem3.Price)::TFloat AS D
    FROM tmpLoadPriceListItem AS LoadPriceListItem
    
         JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId 
         
         LEFT JOIN tmpLoadPriceList1 ON 1 = 1
         LEFT JOIN tmpLoadPriceListItem1 ON tmpLoadPriceListItem1.GoodsId = LoadPriceListItem.GoodsId
         LEFT JOIN tmpLoadPriceList2 ON 1 = 1
         LEFT JOIN tmpLoadPriceListItem2 ON tmpLoadPriceListItem2.GoodsId = LoadPriceListItem.GoodsId
         LEFT JOIN tmpLoadPriceList3 ON 1 = 1
         LEFT JOIN tmpLoadPriceListItem3 ON tmpLoadPriceListItem3.GoodsId = LoadPriceListItem.GoodsId
         
    ORDER BY Object_Goods.Name      
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.01.22                                                       *
*/


select * from gpReport_PriceComparisonBIG3(inLoadPriceListId := 37317 ,  inSession := '3');
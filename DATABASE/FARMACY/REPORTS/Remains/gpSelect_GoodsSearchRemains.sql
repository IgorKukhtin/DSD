-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSearchRemains(
    IN inCodeSearch     TVarChar,    -- поиск товаров по коду
    IN inGoodsSearch    TVarChar,    -- поиск товаров
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar
             , NDSkindName TVarChar
             , GoodsGroupName TVarChar
             , UnitName TVarChar, Phone TVarChar
             , Amount TFloat, AmountIncome TFloat, AmountAll TFloat
             , PriceSale  TFloat
             , SummaSale TFloat
             , PriceSaleIncome  TFloat
             
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRemainsDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbRemainsDate = CURRENT_TIMESTAMP;

    -- Результат
    RETURN QUERY
        WITH 
        tmpGoods AS (SELECT Object.Id
                     FROM Object 
                     WHERE Object.DescId = zc_Object_Goods()
                       AND (upper(CAST(Object.ObjectCode AS TVarChar)) LIKE UPPER(inCodeSearch) AND inCodeSearch <> '')
                       OR (upper(Object.ValueData) LIKE UPPER('%'||inGoodsSearch||'%')  AND inGoodsSearch <> '' AND inCodeSearch = '')
                     )

           , containerCount AS (SELECT Container.Id                AS ContainerId
                                     , Container.Amount
                                     , Container.ObjectID          AS GoodsId
                                     , Container.WhereObjectId     AS UnitId
                                FROM tmpGoods
                                   LEFT JOIN Container ON Container.ObjectID = tmpGoods.Id
                                WHERE Container.descid = zc_container_count()
                                )

           , tmpData AS (SELECT tmpData_all.UnitId
                              , tmpData_all.GoodsId
                              , SUM (tmpData_all.Amount)   AS Amount
                         FROM (  SELECT ContainerCount.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS Amount
                                      , ContainerCount.GoodsId 
                                      , ContainerCount.UnitId 
                                 FROM ContainerCount
                                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                                      ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                                     AND MIContainer.OperDate >= vbRemainsDate
                                 GROUP BY ContainerCount.ContainerId, containerCount.GoodsId, containerCount.Amount, ContainerCount.GoodsId , ContainerCount.UnitId 
                                 ) AS tmpData_all
                         GROUP BY tmpData_all.GoodsId
                                , tmpData_all.UnitId
                         HAVING (SUM (tmpData_all.Amount) <> 0)                                
                          )

               ,  tmpIncome AS (SELECT MovementLinkObject_To.ObjectId          AS UnitId
                                     , MI_Income.ObjectId                      AS GoosdId
                                     , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome  
                                     , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale    
                                FROM Movement AS Movement_Income
                                     INNER JOIN MovementDate AS MovementDate_Branch
                                                             ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                            AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                            AND date_trunc('day', MovementDate_Branch.ValueData) between date_trunc('day', CURRENT_TIMESTAMP)-interval '1 day' AND date_trunc('day', CURRENT_TIMESTAMP)
                                      
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                     LEFT JOIN MovementItem AS MI_Income 
                                                            ON MI_Income.MovementId = Movement_Income.Id
                                                           AND MI_Income.isErased   = False

                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                 ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                                     -- left join  Object ON Object.id = MI_Income.ObjectId
                                     -- left join  Object AS Object1 ON Object1.id = MovementLinkObject_To.ObjectId                  
                                 WHERE Movement_Income.DescId = zc_Movement_Income()
                                   AND Movement_Income.StatusId = zc_Enum_Status_UnComplete() 
                                 GROUP BY MI_Income.ObjectId
                                        , MovementLinkObject_To.ObjectId 
                              )                          


        SELECT Object_Goods_View.Id                         as Id
             , Object_Goods_View.GoodsCodeInt    :: Integer as GoodsCode
             , Object_Goods_View.GoodsName                  as GoodsName
             , Object_Goods_View.NDSkindName                as NDSkindName
             , Object_Goods_View.GoodsGroupName             AS GoodsGroupName
             , Object_Unit.ValueData                        AS UnitName
             , ObjectString_Phone.ValueData                 AS Phone
             , COALESCE(tmpData.Amount,0)         :: TFloat AS Amount
             , COALESCE(tmpIncome.AmountIncome,0)                                  :: TFloat AS AmountIncome
             , (COALESCE(tmpData.Amount,0) + COALESCE(tmpIncome.AmountIncome,0))   :: TFloat AS AmountAll
             , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)                    :: TFloat AS PriceSale
             , (tmpData.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) :: TFloat AS SummaSale
             , CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE(tmpIncome.SummSale,0) / COALESCE(tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome
              
        FROM tmpGoods
            LEFT JOIN Object AS Object_Unit ON Object_Unit.DescId = zc_Object_Unit()
            LEFT JOIN tmpData ON tmpData.GoodsId = tmpGoods.Id
                             AND tmpData.UnitId  = Object_Unit.Id

            LEFT JOIN tmpIncome ON tmpIncome.GoosdId = tmpGoods.Id
                               AND tmpIncome.UnitId  = Object_Unit.Id
                               
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpGoods.Id

            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON Object_Price.GoodsId = tmpGoods.Id     
                                             AND Object_Price.UnitId  = Object_Unit.Id  

            -- получаем значения цены и НТЗ из истории значений на дату на начало                                                          
            LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                    ON ObjectHistory_Price.ObjectId = Object_Price.Id
                                   AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                   AND vbRemainsDate >= ObjectHistory_Price.StartDate AND vbRemainsDate < ObjectHistory_Price.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()

            LEFT JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                 ON ContactPerson_ContactPerson_Object.ChildObjectId = Object_Unit.Id
                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = ContactPerson_ContactPerson_Object.ObjectId
                                  AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                  
          WHERE COALESCE(tmpData.Amount,0)<>0 OR COALESCE(tmpIncome.AmountIncome,0)<>0
          ORDER BY Object_Unit.ValueData 
                 , Object_Goods_View.GoodsGroupName
                 , Object_Goods_View.GoodsName 
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.05.16         *
 18.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsSearchRemains ('4282', 'глюкоз', inSession := '3')

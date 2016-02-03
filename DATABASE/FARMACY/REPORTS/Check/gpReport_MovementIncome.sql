-- Function:  gpReport_Movement_Income()

DROP FUNCTION IF EXISTS gpReport_Movement_Income (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Income(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  GoodsId        integer, 
  GoodsCode      Integer, 
  GoodsName      TVarChar,
  GoodsGroupName TVarChar, 
  NDSKindName    TVarChar,
  Amount         TFloat,
  Price          TFloat,
  PriceWithVAT   TFloat,
  PriceSale      TFloat,
  Summa          TFloat,
  SummaSale      TFloat,
  SummaMargin    TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
        SELECT
             Object_Goods_View.Id                           AS GoodsId
           , Object_Goods_View.GoodsCodeInt  ::Integer      AS GoodsCode
           , Object_Goods_View.GoodsName                    AS GoodsName
           , Object_Goods_View.GoodsGroupName               AS GoodsGroupName
           , Object_Goods_View.NDSKindName                  AS NDSKindName

           , SUM(MI_Income.Amount)::TFloat                  AS Amount

           , MI_Income.Price       ::TFloat                 AS Price
           , MI_Income.PriceWithVAT       ::TFloat          AS PriceWithVAT
           , MI_Income.PriceSale   ::TFloat                 AS PriceSale
           , SUM(MI_Income.AmountSumm)::TFloat              AS Summa
           , SUM(MI_Income.SummSale)::TFloat                AS SummaSale
           , (SUM(MI_Income.SummSale)
             - SUM(MI_Income.AmountSumm))::TFloat           AS SummaMargin
        FROM Movement_Income_View
          
            INNER JOIN MovementItem_Income_View AS MI_Income 
                                                ON MI_Income.MovementId = Movement_Income_View.Id
                                               AND MI_Income.isErased   = False
            
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MI_Income.GoodsId
            
        WHERE date_trunc('day', Movement_Income_View.OperDate) between inDateStart AND inDateFinal
          AND Movement_Income_View.StatusId = zc_Enum_Status_Complete()
          AND Movement_Income_View.ToId = inUnitId
        GROUP BY
            Object_Goods_View.Id
           ,Object_Goods_View.GoodsCodeInt
           ,Object_Goods_View.GoodsName
           ,Object_Goods_View.GoodsGroupName
           ,Object_Goods_View.NDSKindName 
           , MI_Income.Price   
           , MI_Income.PriceSale 
           , MI_Income.PriceWithVAT
     --  HAVING
          -- SUM(MI_Income.Amount) <> 0 
        ORDER BY
            GoodsGroupName, GoodsName;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION  gpReport_Movement_Income (Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 03.02.16         * 

*/

-- тест
-- SELECT * FROM gpReport_Movement_Income (inUnitId := 0, inDateStart = '20150801'::TDateTime, inDateFinal := '20150810'::TDateTime, inWithPartionGoods := FALSE, inSession := '3')

--select * from MovementItem_Income_View 
--where price <> 0 and pricesale <> 0 limit 10
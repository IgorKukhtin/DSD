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
    WITH tmpMovementIncome AS ( SELECT Movement_Income.Id AS MovementId
                                     , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
                                     , ObjectFloat_NDSKind_NDS.ValueData          AS NDS
                                FROM Movement AS Movement_Income
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = inUnitId
                                     INNER JOIN MovementDate AS MovementDate_Branch
                                                             ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                            AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                            AND date_trunc('day', MovementDate_Branch.ValueData) between inDateStart AND inDateFinal

                                     LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                               ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Income.Id
                                                              AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                  ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                                                 AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                     LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId
                                     LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                           ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                          AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                                          
                                 WHERE Movement_Income.DescId = zc_Movement_Income()
                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete() 
                                    
    
                              )
        SELECT
             Object_Goods_View.Id                           AS GoodsId
           , Object_Goods_View.GoodsCodeInt  ::Integer      AS GoodsCode
           , Object_Goods_View.GoodsName                    AS GoodsName
           , Object_Goods_View.GoodsGroupName               AS GoodsGroupName
           , Object_Goods_View.NDSKindName                  AS NDSKindName

           , SUM(MI_Income.Amount)::TFloat                  AS Amount

           , MIFloat_Price.ValueData      ::TFloat                 AS Price
           , CASE WHEN tmpMovementIncome.PriceWithVAT 
                  THEN  MIFloat_Price.ValueData
                  ELSE (MIFloat_Price.ValueData * (1 + tmpMovementIncome.NDS/100))
             END                                     ::TFloat          AS PriceWithVAT
           , COALESCE(MIFloat_PriceSale.ValueData,0) ::TFloat                 AS PriceSale

           , SUM((COALESCE (MI_Income.Amount, 0) * MIFloat_Price.ValueData)::NUMERIC (16, 2))    ::TFloat AS Summa
           , SUM((COALESCE (MI_Income.Amount, 0) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))::TFloat AS SummaSale
           
           , (SUM((COALESCE (MI_Income.Amount, 0) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))
             - SUM((COALESCE (MI_Income.Amount, 0) * MIFloat_Price.ValueData)::NUMERIC (16, 2))) ::TFloat AS SummaMargin


        FROM tmpMovementIncome 
           
            INNER JOIN MovementItem AS MI_Income 
                                    ON MI_Income.MovementId = tmpMovementIncome.MovementId
                                   AND MI_Income.isErased   = False

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MI_Income.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

            
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MI_Income.ObjectId
          
        GROUP BY
            Object_Goods_View.Id
           ,Object_Goods_View.GoodsCodeInt
           ,Object_Goods_View.GoodsName
           ,Object_Goods_View.GoodsGroupName
           ,Object_Goods_View.NDSKindName 
           , MIFloat_Price.ValueData 
           , CASE WHEN tmpMovementIncome.PriceWithVAT 
                  THEN  MIFloat_Price.ValueData
                  ELSE (MIFloat_Price.ValueData * (1 + tmpMovementIncome.NDS/100))
             END                     
           , COALESCE(MIFloat_PriceSale.ValueData,0) 
        ORDER BY
            GoodsGroupName, GoodsName;
----

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

--select * from MovementItem         limit 10    _Income    _View 
--where price <> 0 and pricesale <> 0 limit 10
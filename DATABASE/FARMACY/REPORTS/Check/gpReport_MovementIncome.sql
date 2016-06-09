-- Function:  gpReport_Movement_Income()

DROP FUNCTION IF EXISTS gpReport_Movement_Income (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Income (Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Income(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inIsPartion        Boolean,    -- 
    IN inisPartionPrice   Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  GoodsId        integer, 
  GoodsCode      Integer, 
  GoodsName      TVarChar,
  GoodsGroupName TVarChar, 
  NDSKindName    TVarChar,
  FromName       TVarChar,
  ToName         TVarChar,
  OurJuridicalName TVarChar,
  InvNumber        TVarChar,
  OperDate         TDateTime,
  DescName         TVarChar,

  Price           TFloat,
  PriceWithOutVAT TFloat,
  PriceWithVAT    TFloat,
  PriceSale       TFloat,
  Amount          TFloat,
  OrderAmount     TFloat,
  OverAmount      TFloat,

  Summa              TFloat,
  SummaWithOutVAT    TFloat,
  SummaWithVAT       TFloat,
  SummaSale          TFloat,
  SummaMargin        TFloat,
  SummaMarginWithVAT TFloat,
  SummaWithOutVATOrder  TFloat,
  SummaWithOutVATOver   TFloat

  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH
         tmpMovementIncome AS ( SELECT Movement_Income.Id AS MovementId
                                     , CASE WHEN inIsPartion = TRUE THEN MovementDesc_Income.ItemName ELSE CAST (NULL AS TVarChar) END AS DescName
                                     , CASE WHEN inIsPartion = TRUE THEN Movement_Income.InvNumber ELSE CAST (NULL AS TVarChar) END AS InvNumber
                                     , CASE WHEN inIsPartion = TRUE THEN Movement_Income.OperDate ELSE CAST (NULL AS TDateTime) END AS OperDate
                                     , MovementLinkObject_NDSKind.ObjectId        AS NDSKindId
                                     , MovementLinkObject_From.ObjectId           AS FromId
                                     , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END AS OurJuridicalId
                                     , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END               AS ToId
                                     , MLM_Order.MovementChildId                  AS Movement_OrderId
                                     , MovementLinkObject_From_Order.ObjectId     AS FromOrderId
                                FROM Movement AS Movement_Income
                                     -- куда был приход
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = inUnitId
                                     --дата прихода на аптеку
                                     INNER JOIN MovementDate AS MovementDate_Branch
                                                             ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                            AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                            AND date_trunc('day', MovementDate_Branch.ValueData) between inDateStart AND inDateFinal
                                     -- от кого приход    Поставщик                   
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                  ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                                                 AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                     
                                     -- на какое наше юр лицо был приход
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical_Income
                                                                 ON MovementLinkObject_Juridical_Income.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_Juridical_Income.DescId = zc_MovementLinkObject_Juridical()
                                                          
                                     LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                           ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                          AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                                     LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId                                                          

                                     LEFT JOIN MovementLinkMovement AS MLM_Order
                                                                    ON MLM_Order.MovementId = Movement_Income.Id
                                                                   AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                     -- на кого заявка    Поставщик                    
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Order
                                                                  ON MovementLinkObject_From_Order.MovementId = MLM_Order.MovementChildId 
                                                                 AND MovementLinkObject_From_Order.DescId = zc_MovementLinkObject_From()                                                                   
                                 WHERE Movement_Income.DescId = zc_Movement_Income()
                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete() 
                              )

, tmpData_1 AS (SELECT tmpMovementIncome.InvNumber
                   , tmpMovementIncome.OperDate
                   , tmpMovementIncome.DescName
                   , tmpMovementIncome.FromId
                   , tmpMovementIncome.ToId
                   , tmpMovementIncome.OurJuridicalId
                  -- , tmpMovementIncome.PriceWithVAT
                   , tmpMovementIncome.NDSKindId
                   , MI_Income.ObjectId                              AS GoodsId
                   , COALESCE (MIFloat_JuridicalPrice.ValueData, 0)  AS Price
                   , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) AS PriceWithOutVAT
                   , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    AS PriceWithVAT                   
                   , COALESCE (MIFloat_PriceSale.ValueData, 0)       AS PriceSale
                   , SUM (COALESCE (MI_Income.Amount, 0))                                                   AS Amount
                   , SUM (COALESCE (MI_Order.Amount, 0))                                                    AS AmountOrder
                   , SUM (COALESCE (MI_Income.Amount, 0) * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                   , SUM (COALESCE (MI_Income.Amount, 0) * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                   , SUM (COALESCE (MI_Income.Amount, 0) * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT                   
                   , SUM (COALESCE (MI_Income.Amount, 0) * COALESCE (MIFloat_PriceSale.ValueData, 0))       AS SummaSale
                   , SUM (COALESCE (MI_Order.Amount, 0)  * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVATOrder  
                   , CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.Movement_OrderId ELSE 0 END AS Movement_OrderId           
              FROM tmpMovementIncome
                  INNER JOIN MovementItem AS MI_Income 
                                          ON MI_Income.MovementId = tmpMovementIncome.MovementId
                                         AND MI_Income.isErased   = False
                  LEFT JOIN MovementItem AS MI_Order 
                                         ON MI_Order.MovementId = tmpMovementIncome.Movement_OrderId
                                        AND MI_Order.isErased   = False
                                        AND MI_Order.ObjectId   = MI_Income.ObjectId 
                                         
                  -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                  LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                              ON MIFloat_JuridicalPrice.MovementItemId = MI_Income.Id
                                             AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                   -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                               ON MIFloat_PriceWithVAT.MovementItemId = MI_Income.Id
                                              AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                   -- цена без учета НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                               ON MIFloat_PriceWithOutVAT.MovementItemId = MI_Income.Id
                                              AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()    
                   --цена реализации
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                               ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                              AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()  
              GROUP BY tmpMovementIncome.InvNumber
                     , tmpMovementIncome.OperDate
                     , tmpMovementIncome.DescName
                     , tmpMovementIncome.FromId
                     , tmpMovementIncome.ToId
                     , tmpMovementIncome.OurJuridicalId
                  --   , tmpMovementIncome.PriceWithVAT
                     , tmpMovementIncome.NDSKindId                                   
                     , MI_Income.ObjectId
                     , COALESCE (MIFloat_JuridicalPrice.ValueData, 0)
                     , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)
                     , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)
                     , COALESCE (MIFloat_PriceSale.ValueData, 0)
                     , CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.Movement_OrderId ELSE 0 END
              ) 
              
, tmpData_2 AS (SELECT tmpMovementIncome.InvNumber
                     , tmpMovementIncome.OperDate
                     , tmpMovementIncome.DescName
                   , CASE WHEN inIsPartion = TRUE THEN Movement.InvNumber ELSE tmpMovementIncome.InvNumber END AS InvNumberOrder
                   , CASE WHEN inIsPartion = TRUE THEN Movement.OperDate ELSE tmpMovementIncome.OperDate END AS OperDateOrder
                   , CASE WHEN inIsPartion = TRUE THEN MovementDesc.ItemName ELSE tmpMovementIncome.DescName END AS DescNameOrder
                   ,  CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.FromOrderId ELSE tmpMovementIncome.FromId END AS FromId
                   --, tmpMovementIncome.FromOrderId AS FromId
                 /*  , tmpMovementIncome.ToId
                   , tmpMovementIncome.OurJuridicalId
                   , tmpMovementIncome.NDSKindId*/
                   , MI_Order.ObjectId                        AS GoodsId
                   , CAST( COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))   AS PriceWithOutVAT                  
                   , SUM (COALESCE (MI_Order.Amount, 0))      AS AmountOrder
                   
                   , SUM (COALESCE (MI_Order.Amount, 0)  * COALESCE (MIFloat_Price.ValueData, 0))    AS SummaWithVATOrder             
                   , CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.Movement_OrderId ELSE 0 END AS Movement_OrderId      
              FROM tmpMovementIncome
                  
                  INNER JOIN MovementItem AS MI_Order 
                                         ON MI_Order.MovementId = tmpMovementIncome.Movement_OrderId
                                        AND MI_Order.isErased   = False
                                         
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MI_Order.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                  LEFT JOIN Movement ON Movement.Id = tmpMovementIncome.Movement_OrderId
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId 
                  
              GROUP BY  tmpMovementIncome.InvNumber
                     , tmpMovementIncome.OperDate
                     , tmpMovementIncome.DescName
                     , CASE WHEN inIsPartion = TRUE THEN Movement.InvNumber ELSE tmpMovementIncome.InvNumber END 
                    , CASE WHEN inIsPartion = TRUE THEN Movement.OperDate ELSE tmpMovementIncome.OperDate END 
                     , CASE WHEN inIsPartion = TRUE THEN MovementDesc.ItemName ELSE tmpMovementIncome.DescName END
                   ,  CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.FromOrderId ELSE tmpMovementIncome.FromId END--  , tmpMovementIncome.FromOrderId
                     /*, tmpMovementIncome.ToId
                     , tmpMovementIncome.OurJuridicalId
                     , tmpMovementIncome.NDSKindId                                   */
                     , MI_Order.ObjectId
                     , COALESCE (MIFloat_Price.ValueData, 0)
                     , CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.Movement_OrderId ELSE 0 END
              ) 
              
, tmpData AS (SELECT  COALESCE (tmpData_1.InvNumber, tmpData_2.InvNumberOrder) AS InvNumber
                   , COALESCE (tmpData_1.OperDate, tmpData_2.OperDateOrder) AS OperDate
                   , COALESCE (tmpData_1.DescName,tmpData_2.DescNameOrder) AS DescName
                   , COALESCE (tmpData_1.FromId, tmpData_2.FromId) AS FromId
                   , COALESCE (tmpData_1.ToId, 0) AS ToId
                   , COALESCE (tmpData_1.OurJuridicalId,0) AS OurJuridicalId
                   , COALESCE (tmpData_1.NDSKindId,0) AS NDSKindId
                   , COALESCE (tmpData_1.GoodsId, tmpData_2.GoodsId) AS GoodsId
                   , COALESCE (tmpData_1.Price,0) AS Price
                   , COALESCE (tmpData_1.PriceWithOutVAT, tmpData_2.PriceWithOutVAT)   AS PriceWithOutVAT
                   , COALESCE (tmpData_1.PriceWithVAT,0) AS PriceWithVAT
                   , COALESCE (tmpData_1.PriceSale,0) AS PriceSale
                   , COALESCE (tmpData_1.Amount,0) AS Amount
                   , COALESCE (tmpData_2.AmountOrder,0) AS AmountOrder
                   , COALESCE (tmpData_1.Summa,0) AS Summa
                   , COALESCE (tmpData_1.SummaWithOutVAT, 0) AS SummaWithOutVAT
                   , COALESCE (tmpData_1.SummaWithVAT,0) AS SummaWithVAT
                   , COALESCE (tmpData_1.SummaSale,0) AS SummaSale
                   , COALESCE (tmpData_2.SummaWithVATOrder,0) AS SummaWithOutVATOrder                
              FROM tmpData_1
                  
                   FULL JOIN tmpData_2 ON tmpData_2.GoodsId = tmpData_1.GoodsId
                                     AND tmpData_2.FromId  = tmpData_1.FromId
                                    AND tmpData_2.PriceWithOutVAT  = tmpData_1.PriceWithOutVAT
                                    AND ( tmpData_2.InvNumber  = tmpData_1.InvNumber OR inIsPartion = False )
                                  --  AND tmpData_2.Movement_OrderId  = tmpData_1.Movement_OrderId
 
              ) 


        SELECT
             Object_Goods_View.Id                           AS GoodsId
           , Object_Goods_View.GoodsCodeInt  ::Integer      AS GoodsCode
           , Object_Goods_View.GoodsName                    AS GoodsName
           , Object_Goods_View.GoodsGroupName               AS GoodsGroupName
           , Object_Goods_View.NDSKindName                  AS NDSKindName

           , Object_From.ValueData                          AS FromName
           , Object_To.ValueData                            AS ToName
           , Object_OurJuridical.ValueData                  AS OurJuridicalName

           , tmpData.InvNumber
           , tmpData.OperDate
           , tmpData.DescName

           , tmpData.Price             ::TFloat AS Price
           , tmpData.PriceWithOutVAT   ::TFloat AS PriceWithOutVAT
           , tmpData.PriceWithVAT      ::TFloat AS PriceWithVAT
           , tmpData.PriceSale         ::TFloat AS PriceSale
           
           , tmpData.Amount            ::TFloat AS Amount
           , tmpData.AmountOrder       ::TFloat AS OrderAmount
           , CASE WHEN (tmpData.Amount - tmpData.AmountOrder) > 0 THEN (tmpData.Amount - tmpData.AmountOrder) ELSE 0 END  ::TFloat AS OverAmount

           , tmpData.Summa             ::TFloat AS Summa
           , tmpData.SummaWithOutVAT   ::TFloat AS SummaWithOutVAT
           , tmpData.SummaWithVAT      ::TFloat AS SummaWithVAT
           , tmpData.SummaSale         ::TFloat AS SummaSale
           
           , (tmpData.SummaSale - tmpData.Summa)        :: TFloat AS SummaMargin
           , (tmpData.SummaSale - tmpData.SummaWithVAT) :: TFloat AS SummaMarginWithVAT

           , tmpData.SummaWithOutVATOrder ::TFloat AS SummaWithOutVATOrder
           , CASE WHEN (tmpData.Amount - tmpData.AmountOrder) > 0 THEN (tmpData.SummaWithOutVAT - tmpData.SummaWithOutVATOrder) ELSE 0 END ::TFloat AS SummaWithOutVATOver

        FROM tmpData 
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpData.GoodsId
            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = tmpData.NDSKindId
            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
            LEFT JOIN Object AS Object_To ON Object_To.Id = tmpData.ToId
            LEFT JOIN Object AS Object_OurJuridical ON Object_OurJuridical.Id = tmpData.OurJuridicalId
            
        ORDER BY
            GoodsGroupName, GoodsName;
----

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 31.03.16         *
 03.02.16         * 

*/

-- тест
--select * from gpReport_Movement_Income(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateFinal := ('01.02.2016')::TDateTime , inIsPartion := 'False' , inisPartionPrice := 'False' ,  inSession := '3');
--select * from gpReport_Movement_Income(inUnitId := 183292 , inDateStart := ('05.05.2016')::TDateTime , inDateFinal := ('05.05.2016')::TDateTime , inIsPartion := 'true' , inisPartionPrice := 'False' ,  inSession := '3')
--select * from gpReport_Movement_Income(inUnitId := 183292 , inDateStart := ('05.05.2016')::TDateTime , inDateFinal := ('05.05.2016')::TDateTime , inIsPartion := 'False' , inisPartionPrice := 'False' ,  inSession := '3')
--where GoodsCode = 10830
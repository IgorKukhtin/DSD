-- Function: gpSelect_MI_PromoGoods_Calc()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoGoods_Calc (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoGoods_Calc(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (NUM Integer --
      , Id                  Integer --идентификатор
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , PriceIn             TFloat --Себ-ть прод, грн/кг
      , AmountRetIn         TFloat --Кол-во возврат (факт)
      , ContractCondition   TFloat --бонус сети
      , AmountOut           TFloat --Кол-во реализация (факт)
      , SummaOut            TFloat --Кол-во реализация (факт)
      , PriceSale           TFloat --Цена в прайсе
      , PriceWithVAT        TFloat --Цена отгрузки с учетом НДС, с учетом скидки, грн
      , PromoCondition      TFloat --
      , Profit              TFloat --прибыль
      
      , Color_PriceIn       Integer
      , Color_RetIn         Integer
      , Color_ContractCond  Integer
      , Color_AmountOut     Integer
      , Color_SummaOut      Integer
      , Color_PriceSale     Integer
      , Color_PriceWithVAT  Integer
      , Color_PromoCond     Integer
      , Color_Profit        Integer
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH
    ---- Значение (% скидки / % компенсации)
    tmpMIChild AS (SELECT MovementItem.Amount        -- Значение (% скидки / % компенсации)
                   FROM  MovementItem
                   WHERE MovementItem.MovementId = inMovementId 
                     AND MovementItem.DescId = zc_MI_Child()
                     AND MovementItem.isErased = FALSE
                  )
    -- все данные
  , tmpData AS (SELECT MovementItem.Id                        AS Id                  --идентификатор
                     , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
                     , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
                     , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
               
                     , MovementItem.Amount                    AS Amount              --% скидки на товар
                     
                     , MIFloat_PriceIn1.ValueData             AS PriceIn1            --Себ-ть - 1 прод, грн/кг
                     , MIFloat_PriceIn2.ValueData             AS PriceIn2            --Себ-ть - 2 прод, грн/кг
                     , MIFloat_PriceSale.ValueData            AS PriceSale           --Цена в прайсе
                     , MIFloat_PriceSale.ValueData * (100 - tmpMIChild.Amount) / 100  AS PriceWithVAT        --Цена отгрузки с учетом НДС, с учетом скидки, грн
               
                     , MIFloat_AmountOut.ValueData            AS AmountOut           --Кол-во реализация (факт)
                     , (MIFloat_AmountOut.ValueData * MIFloat_PriceSale.ValueData)   AS SummaOut           --Кол-во реализация (факт) 
                     , MIFloat_AmountRetIn.ValueData          AS AmountRetIn            --Кол-во возврат (факт)
                     , MIFloat_ContractCondition.ValueData    AS ContractCondition
                     , tmpMIChild.Amount                      AS PromoCondition 
                FROM MovementItem
                     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                 ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                                
                     LEFT JOIN MovementItemFloat AS MIFloat_PriceIn1
                                                 ON MIFloat_PriceIn1.MovementItemId = MovementItem.Id
                                                AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
                     LEFT JOIN MovementItemFloat AS MIFloat_PriceIn2
                                                 ON MIFloat_PriceIn2.MovementItemId = MovementItem.Id
                                                AND MIFloat_PriceIn2.DescId = zc_MIFloat_PriceIn2()
             
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                                 ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountRetIn
                                                 ON MIFloat_AmountRetIn.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountRetIn.DescId = zc_MIFloat_AmountRetIn()
     
                     LEFT JOIN MovementItemFloat AS MIFloat_ContractCondition
                                                 ON MIFloat_ContractCondition.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContractCondition.DescId = zc_MIFloat_ContractCondition()
                                                
                     LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                          ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                         AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                     LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                     
                     LEFT JOIN tmpMIChild ON 1=1 
                WHERE MovementItem.MovementId = inMovementId 
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                )
 
  , tmpData_All AS (SELECT 1                       AS NUM
                         , tmpData.Id                  --идентификатор
                         , tmpData.GoodsId             --ИД объекта <товар>
                         , tmpData.GoodsCode           --код объекта  <товар>
                         , tmpData.GoodsName           --наименование объекта <товар>
                   
                         , 0                       AS PriceIn  
                         , tmpData.Amount          AS AmountRetIn           
                         , tmpData.ContractCondition AS ContractCondition   -- бонус сети
                         , 0                       AS AmountOut
                         , 0                       AS SummaOut
                         , 0                       AS PriceSale
                         , tmpData.PromoCondition  AS PriceWithVAT
                         , tmpData.PromoCondition  AS PromoCondition      --  Компенсация по доп.счету, грн/кг
                         , 0                       AS Profit              -- прибыль
                               
                         , zc_Color_White()  AS Color_PriceIn
                         , 16764159          AS Color_RetIn
                         , 11658012          AS Color_ContractCond
                         , zc_Color_White()  AS Color_AmountOut
                         , zc_Color_White()  AS Color_SummaOut
                         , zc_Color_White()  AS Color_PriceSale 
                         , 11658012          AS Color_PriceWithVAT
                         , 11658012          AS Color_PromoCond
                         , zc_Color_White()  AS Color_Profit
                    FROM tmpData
                         
                  UNION
                    SELECT 2                       AS NUM
                         , tmpData.Id                  --идентификатор
                         , tmpData.GoodsId             --ИД объекта <товар>
                         , tmpData.GoodsCode           --код объекта  <товар>
                         , tmpData.GoodsName           --наименование объекта <товар>
                         
                         , tmpData.PriceIn1        AS PriceIn  
                         , tmpData.AmountRetIn     AS AmountRetIn           
                         , CASE WHEN tmpData.AmountOut <> 0 THEN tmpData.SummaOut * tmpData.ContractCondition / tmpData.AmountOut ELSE 0 END  AS ContractCondition   -- бонус сети
                         , tmpData.AmountOut       AS AmountOut
                         , tmpData.SummaOut
                         , tmpData.PriceSale  
                         , tmpData.PriceWithVAT
                         , tmpData.PriceSale * tmpData.PromoCondition / 100  AS PromoCondition         --  Компенсация по доп.счету, грн/кг
                         , tmpData.SummaOut - (tmpData.PriceIn1 
                                              + tmpData.AmountRetIn 
                                              + CASE WHEN tmpData.AmountOut <>0 THEN tmpData.SummaOut * tmpData.PromoCondition / tmpData.AmountOut ELSE 0 END
                                              ) 
                                              * tmpData.AmountOut            AS Profit               -- прибыль

                         , 11658012          AS Color_PriceIn
                         , zc_Color_White()  AS Color_RetIn
                         , zc_Color_White()  AS Color_ContractCond
                         , 11658012          AS Color_AmountOut
                         , zc_Color_White()  AS Color_SummaOut
                         , 11658012          AS Color_PriceSale 
                         , zc_Color_White()  AS Color_PriceWithVAT
                         , zc_Color_White()  AS Color_PromoCond
                         , zc_Color_Yelow()  AS Color_Profit
                    FROM tmpData
                         LEFT JOIN tmpMIChild ON 1=1
                  UNION
                    SELECT 3                       AS NUM
                         , tmpData.Id                  --идентификатор
                         , tmpData.GoodsId             --ИД объекта <товар>
                         , tmpData.GoodsCode           --код объекта  <товар>
                         , tmpData.GoodsName           --наименование объекта <товар>
                   
                         , 0                       AS PriceIn  
                         , tmpData.Amount          AS AmountRetIn           
                         , 12                      AS ContractCondition      -- бонус сети
                         , 0                       AS AmountOut
                         , 0                       AS SummaOut
                         , 0                       AS PriceSale
                         , tmpData.PromoCondition  AS PriceWithVAT
                         , tmpData.PromoCondition  AS PromoCondition         --  Компенсация по доп.счету, грн/кг
                         , 0                       AS Profit                 -- прибыль
                                                  
                         , zc_Color_White()  AS Color_PriceIn 
                         , 16764159          AS Color_RetIn
                         , 11658012          AS Color_ContractCond
                         , zc_Color_White()  AS Color_AmountOut
                         , zc_Color_White()  AS Color_SummaOut
                         , zc_Color_White()  AS Color_PriceSale 
                         , 11658012          AS Color_PriceWithVAT
                         , 11658012          AS Color_PromoCond
                         , zc_Color_White()  AS Color_Profit
                    FROM tmpData
                  UNION
                    SELECT 4                       AS NUM
                         , tmpData.Id                  --идентификатор
                         , tmpData.GoodsId             --ИД объекта <товар>
                         , tmpData.GoodsCode           --код объекта  <товар>
                         , tmpData.GoodsName           --наименование объекта <товар>
                         
                         , tmpData.PriceIn2        AS PriceIn  
                         , tmpData.AmountRetIn     AS AmountRetIn           
                         , CASE WHEN tmpData.AmountOut <>0 THEN tmpData.SummaOut * 12 / tmpData.AmountOut ELSE 0 END  AS ContractCondition   -- бонус сети
                         , tmpData.AmountOut       AS AmountOut
                         , tmpData.SummaOut        AS SummaOut
                         , tmpData.PriceSale       AS PriceSale
                         , tmpData.PriceWithVAT    AS PriceWithVAT
                         , tmpData.PriceSale * tmpData.PromoCondition / 100  AS PromoCondition         --  Компенсация по доп.счету, грн/кг
                         , tmpData.SummaOut - (tmpData.PriceIn2 
                                              + tmpData.AmountRetIn 
                                              + CASE WHEN tmpData.AmountOut <>0 THEN tmpData.SummaOut * tmpData.PromoCondition / tmpData.AmountOut ELSE 0 END
                                              ) 
                                              * tmpData.AmountOut             AS Profit               -- прибыль
                         
                         , 11658012 AS Color_PriceIn
                         , zc_Color_White()  AS Color_RetIn
                         , zc_Color_White()  AS Color_ContractCond
                         , 11658012          AS Color_AmountOut
                         , zc_Color_White()  AS Color_SummaOut
                         , 11658012          AS Color_PriceSale 
                         , zc_Color_White()  AS Color_PriceWithVAT
                         , zc_Color_White()  AS Color_PromoCond
                         , zc_Color_Yelow()  AS Color_Profit
                    FROM tmpData
                  UNION
                    --между товарами вставляем пустую строку
                    SELECT 5             AS NUM
                         , tmpData.Id       --идентификатор
                         , 0                --ИД объекта <товар>
                         , 0                          --код объекта  <товар>
                         , ''                         --наименование объекта <товар>
                         , 0            AS PriceIn  
                         , 0            AS AmountRetIn           
                         , 0            AS ContractCondition   -- бонус сети
                         , 0            AS AmountOut
                         , 0            AS SummaOut
                         , 0            AS PriceSale   
                         , 0            AS PriceWithVAT
                         , 0            AS PromoCondition         --  Компенсация по доп.счету, грн/кг
                         , 0            AS Profit                 -- прибыль
                         , zc_Color_White() AS Color_PriceIn
                         , zc_Color_White() AS Color_RetIn
                         , zc_Color_White() AS Color_ContractCond
                         , zc_Color_White() AS Color_AmountOut
                         , zc_Color_White() AS Color_SummaOut
                         , zc_Color_White() AS Color_PriceSale 
                         , zc_Color_White() AS Color_PriceWithVAT
                         , zc_Color_White() AS Color_PromoCond
                         , zc_Color_White() AS Color_Profit
                    FROM tmpData
                   )   
                   
    -- результат
    SELECT CASE WHEN tmpData_All.NUM = 5 THEN 0 ELSE tmpData_All.NUM END
         , CASE WHEN tmpData_All.NUM = 5 THEN 0 ELSE tmpData_All.Id END  --идентификатор
         , tmpData_All.GoodsId                         --ИД объекта <товар>
         , tmpData_All.GoodsCode                       --код объекта  <товар>
         , tmpData_All.GoodsName           ::TVarChar  --наименование объекта <товар>
         
         , tmpData_All.PriceIn             :: TFloat
         , tmpData_All.AmountRetIn         :: TFloat       
         , tmpData_All.ContractCondition   :: TFloat   -- бонус сети
         , tmpData_All.AmountOut           :: TFloat
         , tmpData_All.SummaOut            :: TFloat
         , tmpData_All.PriceSale           :: TFloat
         , tmpData_All.PriceWithVAT        :: TFloat
         , tmpData_All.PromoCondition      :: TFloat      
         , tmpData_All.Profit              :: TFloat
         
         , tmpData_All.Color_PriceIn
         , tmpData_All.Color_RetIn
         , tmpData_All.Color_ContractCond
         , tmpData_All.Color_AmountOut
         , tmpData_All.Color_SummaOut
         , tmpData_All.Color_PriceSale 
         , tmpData_All.Color_PriceWithVAT
         , tmpData_All.Color_PromoCond
         , tmpData_All.Color_Profit
    FROM tmpData_All
    ORDER BY  tmpData_All.Id, tmpData_All.NUM 
                     
;
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 03.08.17         *
*/
--тест
-- SELECT * FROM gpSelect_MI_PromoGoods_Calc (5083159 , False, '5');
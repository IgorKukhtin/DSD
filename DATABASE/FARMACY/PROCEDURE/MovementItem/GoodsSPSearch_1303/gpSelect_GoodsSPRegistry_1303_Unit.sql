 -- Function: gpSelect_GoodsSPRegistry_1303_Unit()

DROP FUNCTION IF EXISTS gpSelect_GoodsSPRegistry_1303_Unit (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSPRegistry_1303_Unit(
    IN inUnitId      Integer   ,    -- Подразделение
    IN inGoodsId     Integer   ,    -- Товар
    IN inisCalc      Boolean   ,    -- Выполнять
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId         Integer
             , GoodsMainId     Integer
             , NDS             TFloat
             , PriceOptSP      TFloat
             , PriceSale       TFloat
             , Remains         TFloat
             , PriceSaleIncome TFloat
             , MovementItemId  Integer
             )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;  
    DECLARE vbGoodsId Integer;  
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);
    
    IF COALESCE (inisCalc, FALSE) = False
    THEN
      Return;
    END IF;

    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');
    vbGoodsId := (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inGoodsId);

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('__tmpGoodsSPRegistry_1303'))
    THEN
      DROP TABLE __tmpGoodsSPRegistry_1303;
    END IF;
    
    CREATE TEMP TABLE __tmpGoodsSPRegistry_1303 ON COMMIT DROP AS 
                                   (WITH
                                    tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                                        , ObjectFloat_NDSKind_NDS.ValueData
                                                   FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                   WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
                                                   
                                    SELECT MovementItem.Id               AS MovementItemId
                                         , MovementItem.ObjectId         AS GoodsId
                                         , COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat       AS NDS
                                         , MIFloat_PriceOptSP.ValueData                                 AS PriceOptSP
                                         , ROUND(MIFloat_PriceOptSP.ValueData  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2)::TFloat AS PriceSale

                                                                          -- № п/п - на всякий случай
                                         , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, MIDate_OrderDateSP.ValueData DESC) AS Ord
                                    FROM Movement
                                         INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                                AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                                AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                                         INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                                AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                                AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                                         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                                               AND COALESCE (MovementItem.ObjectId, 0) <> 0
                                                               AND (MovementItem.ObjectId = vbGoodsId OR COALESCE (vbGoodsId, 0) = 0)

                                         LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                                     ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                                         LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                                                     ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  
                                         LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                                    ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                                   AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()

                                         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
                                         LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                              ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

                                    WHERE Movement.DescId = zc_Movement_GoodsSPSearch_1303()
                                      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                      AND COALESCE (MovementItem.ObjectId, 0) <> 0
                                   );
                                   
    ANALYSE __tmpGoodsSPRegistry_1303;
    

    RETURN QUERY
    WITH
         tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                             , ObjectFloat_NDSKind_NDS.ValueData
                        FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                        WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
       , tmpContainer AS (SELECT Container.ObjectId
                               , SUM(Container.Amount)                  AS Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.Amount <> 0
                            AND Container.WhereObjectId = inUnitId
                            AND (Container.ObjectId = inGoodsId OR COALESCE (inGoodsId, 0) = 0)
                          GROUP BY Container.ObjectId
                         )
       , tmpData_1303 AS (SELECT Object_Goods_Retail.Id    AS GoodsId
                               , Object_Goods.Id           AS GoodsMainId  

                               , tmpGoodsSPRegistry_1303.NDS                          AS NDS
                               , tmpGoodsSPRegistry_1303.PriceOptSP                   AS PriceOptSP
                               , tmpGoodsSPRegistry_1303.PriceSale                    AS PriceSale
                                 
                               , tmpContainer.Amount::TFloat      AS Remains

                               , tmpGoodsSPRegistry_1303.MovementItemId

                          FROM __tmpGoodsSPRegistry_1303 AS tmpGoodsSPRegistry_1303
                          
                               LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = tmpGoodsSPRegistry_1303.GoodsId
                               LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods.Id
                                                                                   AND Object_Goods_Retail.RetailId = vbObjectId
                              
                               LEFT JOIN tmpContainer ON tmpContainer.ObjectId = Object_Goods_Retail.Id 
                                                    
                          WHERE COALESCE (Object_Goods_Retail.Id, 0) <> 0
                            AND tmpGoodsSPRegistry_1303.Ord = 1
                          )
       , tmpIncome_All AS (SELECT Container.ObjectId                                          AS GoodsId
                                , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)   AS MovementId
                                , MovementLinkObject_To.ObjectId                              AS UnitId
                            FROM Container 
                                 INNER JOIN ContainerLinkObject AS CLI_MI 
                                                                ON CLI_MI.ContainerId = Container.Id
                                                               AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                 INNER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                                 INNER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer
                                 -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                             ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                            AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                 -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                 LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()   

                              WHERE Container.ObjectId IN (SELECT tmpData_1303.GoodsId FROM tmpData_1303)
                                AND Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = inUnitId
                                AND Container.ID > 10000000
                              )
       , tmpIncome_Last AS (SELECT tmpIncome_All.GoodsId
                                 , tmpIncome_All.MovementId
                                 , ROW_NUMBER() OVER (PARTITION BY tmpIncome_All.GoodsId ORDER BY tmpIncome_All.UnitId <> inUnitId, tmpIncome_All.MovementId DESC) AS ord   -- Люба сказала смотреть по последней партии
                             FROM tmpIncome_All                                
                             )
       , tmpIncome_1303 AS (SELECT tmpIncome_Last.GoodsId
                                , Max(COALESCE(MIFloat_PriceSample.ValueData, 
                                      CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN MIFloat_Price.ValueData
                                           ELSE (MIFloat_Price.ValueData * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData,1)/100))::TFloat 
                                           END) * 1.1)::TFloat    AS PriceSale   -- цена отпускная 1303
                            FROM tmpIncome_Last 
                            
                                 LEFT JOIN MovementItem ON MovementItem.MovementId =  tmpIncome_Last.MovementId
                                                       AND MovementItem.ObjectId = tmpIncome_Last.GoodsId

                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_PriceSample
                                                             ON MIFloat_PriceSample.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PriceSample.DescId = zc_MIFloat_PriceSample()

                                 LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                           ON MovementBoolean_PriceWithVAT.MovementId =  tmpIncome_Last.MovementId
                                                          AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                              ON MovementLinkObject_NDSKind.MovementId = tmpIncome_Last.MovementId
                                                             AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                 LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId

                              WHERE tmpIncome_Last.ord = 1
                              GROUP BY tmpIncome_Last.GoodsId
                              )
                          
    SELECT tmpData_1303.GoodsId
         , tmpData_1303.GoodsMainId  
         , tmpData_1303.NDS
         , tmpData_1303.PriceOptSP
         , tmpData_1303.PriceSale
         , tmpData_1303.Remains
         , tmpIncome_1303.PriceSale AS PriceSaleIncome
         , tmpData_1303.MovementItemId
    FROM tmpData_1303  
    
         LEFT JOIN tmpIncome_1303 ON tmpIncome_1303.GoodsId = tmpData_1303.GoodsId
    ;                        
      

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.22                                                       *
*/

--ТЕСТ
-- select * from gpSelect_GoodsSPRegistry_1303_Unit(inUnitId := 13338606, inGoodsId := 16242420, inisCalc := True, inSession := '3');


SELECT * 
FROM gpSelect_GoodsSPRegistry_1303_Unit (inUnitId := 183289 , inGoodsId := 0, inisCalc := True, inSession := '3')
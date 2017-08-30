-- Function:  gpReport_Movement_Check_Light()

DROP FUNCTION IF EXISTS gpReport_Check_Assortment (Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_Assortment(
    IN inUnitId           Integer  ,  -- Подразделение
    --IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inisUnitList       Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  GoodsId        Integer, 
  GoodsCode      Integer, 
  GoodsName      TVarChar,
  GoodsGroupName TVarChar, 
  NDSKindName    TVarChar,
  ConditionsKeepName    TVarChar,
  Amount                TFloat,
  Price                 TFloat,
  PriceSale             TFloat,
  PriceWithVAT          Tfloat,      --Цена поставщика с учетом НДС (без % корр.)
  PriceWithOutVAT       Tfloat, 
  Summa                 TFloat,
  SummaSale             TFloat,
  SummaWithVAT          Tfloat,      --Сумма поставщика с учетом НДС (без % корр.)
  SummaWithOutVAT       Tfloat,
  SummaMargin           TFloat,
  SummaMarginWithVAT    TFloat,

  UnitName              Tblob,
  
  IsClose Boolean, UpdateDate TDateTime,
  isTop boolean, isFirst boolean , isSecond boolean,
  isSP Boolean, isPromo boolean
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDateStartPromo TDateTime;
   DECLARE vbDatEndPromo TDateTime;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    AND ObjectLink_Unit_Juridical.ObjectId = inUnitId);
  
    -- Результат
    RETURN QUERY
    WITH
    tmpUnit AS (SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0 
               UNION 
                SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  AND inisUnitList = FALSE
               UNION
                SELECT ObjectBoolean_Report.ObjectId          AS UnitId
                FROM ObjectBoolean AS ObjectBoolean_Report
                WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                  AND ObjectBoolean_Report.ValueData = TRUE
                  AND inisUnitList = TRUE
             )
             
  , tmpData_Container AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                               , COALESCE (MIContainer.AnalyzerId,0)         AS MovementItemId_Income
                               , MIContainer.ObjectId_analyzer               AS GoodsId
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                          FROM MovementItemContainer AS MIContainer
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                          WHERE MIContainer.DescId = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            AND MIContainer.OperDate >= inDateStart AND MIContainer.OperDate < inDateFinal + INTERVAL '1 DAY'
                          GROUP BY COALESCE (MIContainer.AnalyzerId,0)
                                 , MIContainer.ObjectId_analyzer
                                 , MIContainer.WhereObjectId_analyzer 
                          HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                          )
  , tmpAssortment AS (SELECT DISTINCT tmpData_Container.GoodsId
                      FROM tmpData_Container
                      WHERE tmpData_Container.UnitId = inUnitId
                      )
                          
  , tmpData_all AS (SELECT MI_Income.MovementId      AS MovementId_Income
                         , MI_Income_find.MovementId AS MovementId_find
                         , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                         , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                         , tmpData_Container.UnitId
                         , tmpData_Container.GoodsId
                         , SUM (COALESCE (tmpData_Container.Amount, 0))    AS Amount
                         , SUM (COALESCE (tmpData_Container.SummaSale, 0)) AS SummaSale
                    FROM tmpData_Container
                         LEFT JOIN tmpAssortment ON tmpAssortment.GoodsId = tmpData_Container.GoodsId
                          -- элемент прихода
                         LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_Container.MovementItemId_Income

                         -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                         LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                     ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                    AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                         -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                         
                    WHERE tmpData_Container.UnitId <> inUnitId
                      AND tmpAssortment.GoodsId IS NULL
                      --AND tmpData_Container.GoodsId NOT IN (SELECT tmpAssortment.GoodsId FROM tmpAssortment) 

                    GROUP BY COALESCE (MI_Income_find.Id,         MI_Income.Id)
                           , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) 
                           , MI_Income.MovementId
                           , MI_Income_find.MovementId  
                           , tmpData_Container.GoodsId
                           , tmpData_Container.UnitId
                   )

           , tmpData AS (SELECT MovementLinkObject_NDSKind_Income.ObjectId                                 AS NDSKindId_Income
                              , tmpData_all.UnitId
                              , tmpData_all.GoodsId
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale
                                -- таким образом выделим цены = 0 (что б не искажать среднюю с/с)
                              , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END AS isPrice
                         FROM tmpData_all
                              -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                          ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                              -- цена без учета НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                          ON MIFloat_PriceWithOutVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()

                              -- Вид НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()

                         GROUP BY MovementLinkObject_NDSKind_Income.ObjectId
                                , tmpData_all.GoodsId
                                , tmpData_all.UnitId
                                , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
 
                        )

   , tmpDataRez AS (SELECT tmpData.NDSKindId_Income
                         , STRING_AGG (Object_Unit.ValueData, '; ') AS UnitName
                         , tmpData.GoodsId
                         , SUM (tmpData.Summa)           AS Summa
                         , SUM (tmpData.SummaWithOutVAT) AS SummaWithOutVAT
                         , SUM (tmpData.SummaWithVAT)    AS SummaWithVAT
                         , SUM (tmpData.Amount)          AS Amount
                         , SUM (tmpData.SummaSale)       AS SummaSale
                         , tmpData.isPrice
                    FROM tmpData
                         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
                    GROUP BY tmpData.NDSKindId_Income
                           , tmpData.GoodsId
                           , tmpData.isPrice
                           --, tmpData.UnitId
                    )

        -- Маркетинговый контракт
      , GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                         --   , tmp.ChangePercent
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    /*INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId*/
                         )

        -- результат
        SELECT
             Object_Goods.Id                                                   AS GoodsId
           , Object_Goods.ObjectCode                                           AS GoodsCode
           , Object_Goods.ValueData                                            AS GoodsName
           , Object_GoodsGroup.ValueData                                       AS GoodsGroupName
           , Object_NDSKind_Income.ValueData                                   AS NDSKindName
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar          AS ConditionsKeepName           

           , tmpData.Amount          :: TFloat

           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale       / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT

           , tmpData.Summa           :: TFloat AS Summa
           , tmpData.SummaSale       :: TFloat AS SummaSale
           , tmpData.SummaWithVAT    :: TFloat AS SummaWithVAT
           , tmpData.SummaWithOutVAT :: TFloat AS SummaWithOutVAT

           , (tmpData.SummaSale - tmpData.Summa)                   :: TFloat  AS SummaMargin
           , (tmpData.SummaSale - tmpData.SummaWithVAT)            :: TFloat  AS SummaMarginWithVAT

           , tmpData.UnitName                                      :: Tblob   AS UnitName

           , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean AS isClose
           , COALESCE(ObjectDate_Update.ValueData, Null)          ::TDateTime AS UpdateDate   
           
           , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean AS isTOP
           , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean AS isFirst
           , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean AS isSecond
           
           , COALESCE (ObjectBoolean_Goods_SP.ValueData,False)     :: Boolean AS isSP
           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
        FROM tmpDataRez AS tmpData
             LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = tmpData.NDSKindId_Income

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

             LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods.Id
             -- условия хранения
             LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                  ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
 
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                     ON ObjectBoolean_Goods_Close.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  
             LEFT JOIN ObjectDate AS ObjectDate_Update
                                  ON ObjectDate_Update.ObjectId = Object_Goods.Id
                                 AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()  

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                     ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                     ON ObjectBoolean_Goods_First.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                     ON ObjectBoolean_Goods_Second.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second() 
             -- получается GoodsMainId
             LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                      AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
             LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                     AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
             LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                      ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                     AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                                                                                       
        ORDER BY Object_GoodsGroup.ValueData
               , Object_Goods.ValueData
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 29.08.17         *
*/

-- тест
 --select * from gpReport_Check_Assortment(inUnitId := 183292 , inDateStart := ('01.01.2016')::TDateTime , inDateFinal := ('01.01.2016')::TDateTime , inisUnitList := 'False' :: Boolean,  inSession := '3'::TVarChar);
 --select * from gpReport_Check_Assortment(inUnitId := 394426 , inDateStart := ('01.11.2016')::TDateTime , inDateFinal := ('30.11.2016')::TDateTime , inisUnitList := 'False' ,  inSession := '3');
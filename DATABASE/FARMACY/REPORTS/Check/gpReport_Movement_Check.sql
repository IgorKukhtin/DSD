-- Function:  gpReport_Movement_Check()

DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Check(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inIsPartion        Boolean,    -- 
    IN inisPartionPrice   Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  JuridicalCode  Integer, 
  JuridicalName  TVarChar,
  GoodsId        Integer, 
  GoodsCode      Integer, 
  GoodsName      TVarChar,
  GoodsGroupName TVarChar, 
  NDSKindName    TVarChar,
  Amount                TFloat,
  Price                 TFloat,
 -- Price_original        TFloat,
  PriceSale             TFloat,
  PriceWithVAT          Tfloat,      --Цена поставщика с учетом НДС (без % корр.)
  PriceWithOutVAT       Tfloat, 
  Summa                 TFloat,
  SummaSale             TFloat,
  SummaWithVAT          Tfloat,      --Сумма поставщика с учетом НДС (без % корр.)
  SummaWithOutVAT       Tfloat,
  SummaMargin           TFloat,
  SummaMarginWithVAT    TFloat,
  PartionDescName       TVarChar,
  PartionInvNumber      TVarChar,
  PartionOperDate       TDateTime,
  PartionPriceDescName  TVarChar,
  PartionPriceInvNumber TVarChar,
  PartionPriceOperDate  TDateTime,

  UnitName              TVarChar,
  OurJuridicalName      TVarChar
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
          WITH tmpMI AS (SELECT MIContainer.ContainerId
                              , MI_Check.ObjectId AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() 
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inDateStart AND Movement_Check.OperDate < inDateFinal + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MI_Check.ObjectId
                                , MIContainer.ContainerId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )
       , tmpData_all AS (SELECT MI_Income.MovementId      AS MovementId_Income
                              , MI_Income_find.MovementId AS MovementId_find
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              , tmpMI.GoodsId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM tmpMI
                              -- нашли партию
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = tmpMI.ContainerId
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId

                              -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                        )
           , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                              , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END AS MovementId_find
                              , MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income
                              , MovementLinkObject_NDSKind_Income.ObjectId                                 AS NDSKindId_Income
                              , tmpData_all.GoodsId
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              --, SUM (tmpData_all.Amount * COALESCE (MIFloat_Income_Price.ValueData, 0))    AS Summa_original
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale
                                -- таким образом выделим цены = 0 (что б не искажать среднюю с/с)
                              , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END AS isPrice
                              --
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END AS OurJuridicalId_Income
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END               AS ToId_Income
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
                              -- цена "оригинал", для элемента прихода от поставщика (или NULL)
                             /* LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                          ON MIFloat_Income_Price.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 
                             */
                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                              -- Вид НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                              -- куда был приход от поставщика (склад или аптека)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              -- на какое наше юр лицо был приход
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical_Income
                                                           ON MovementLinkObject_Juridical_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_Juridical_Income.DescId = zc_MovementLinkObject_Juridical()
                              --LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical_Income.ObjectId

                         GROUP BY CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END
                                , MovementLinkObject_From_Income.ObjectId
                                , MovementLinkObject_NDSKind_Income.ObjectId
                                , tmpData_all.GoodsId
                                , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END    
                        )
        SELECT
            Object_From_Income.ObjectCode                                      AS JuridicalCode
           ,Object_From_Income.ValueData                                       AS JuridicalName

           ,Object_Goods_View.Id                                                AS GoodsId
           ,Object_Goods_View.GoodsCodeInt  ::Integer                           AS GoodsCode
           ,Object_Goods_View.GoodsName                                         AS GoodsName
           ,Object_Goods_View.GoodsGroupName                                    AS GoodsGroupName
           -- ,Object_Goods_View.NDSKindName                                       AS NDSKindName
           ,Object_NDSKind_Income.ValueData                                     AS NDSKindName

           , tmpData.Amount :: TFloat AS Amount
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
           --, CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa_original  / tmpData.Amount ELSE 0 END :: TFloat AS Price_original
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale       / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT

           , tmpData.Summa           :: TFloat AS Summa
           , tmpData.SummaSale       :: TFloat AS SummaSale
           , tmpData.SummaWithVAT    :: TFloat AS SummaWithVAT
           , tmpData.SummaWithOutVAT :: TFloat AS SummaWithOutVAT

           , (tmpData.SummaSale - tmpData.Summa)        :: TFloat AS SummaMargin
           , (tmpData.SummaSale - tmpData.SummaWithVAT) :: TFloat AS SummaMarginWithVAT

           , MovementDesc_Income.ItemName AS PartionDescName
           , Movement_Income.InvNumber    AS PartionInvNumber
           , Movement_Income.OperDate     AS PartionOperDate
           , COALESCE (MovementDesc_Price.ItemName, MovementDesc_Income.ItemName) AS PartionPriceDescName
           , COALESCE (Movement_Price.InvNumber, Movement_Income.InvNumber)       AS PartionPriceInvNumber
           , COALESCE (Movement_Price.OperDate, Movement_Income.OperDate)         AS PartionPriceOperDate

           , Object_To_Income.ValueData              AS UnitName
           , Object_OurJuridical_Income.ValueData    AS OurJuridicalName
        FROM tmpData
             LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
             LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = tmpData.NDSKindId_Income
             LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpData.GoodsId

             LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
             LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
             LEFT JOIN Movement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

             LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
             LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId

        ORDER BY
            GoodsGroupName, GoodsName;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 14.03.16                                        * ALL
 28.01.16         * 
 11.08.15                                                                       *
*/

-- тест
-- SELECT * FROM gpReport_Movement_Check(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateFinal := ('29.02.2016')::TDateTime , inIsPartion := 'False' ,  inSession := '3');
-- SELECT * FROM gpReport_Movement_Check (inUnitId:= 0, inDateStart:= '20150801'::TDateTime, inDateFinal:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')

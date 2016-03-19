-- ЗДЕСЬ РАСЧЕТ С/С - происходит заново

DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Check(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inIsPartion        Boolean,    -- 
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
  Amount         TFloat,
  Price          TFloat,
  Price_original TFloat,
  PriceSale      TFloat,
  Summa          TFloat,
  SummaSale      TFloat,
  SummaMargin    TFloat,
  PartionDescName  TVarChar,
  PartionInvNumber TVarChar,
  PartionOperDate  TDateTime,
  PartionPriceDescName  TVarChar,
  PartionPriceInvNumber TVarChar,
  PartionPriceOperDate  TDateTime
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
       , tmpData_all AS (SELECT MI_Income.MovementId AS MovementId_Income
                              , COALESCE (Movement_Income.DescId, 0) AS MovementDescId
                              , Movement_Income.OperDate AS OperDate_Income
                              , Object_PartionMovementItem.ObjectCode AS MovementItemId_Income
                              , tmpMI.GoodsId
                              , SUM (tmpMI.Amount)    AS Amount
                              , SUM (tmpMI.SummaSale) AS SummaSale
                         FROM tmpMI
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem 
                                                            ON ContainerLinkObject_MovementItem.Containerid = tmpMI.ContainerId
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MI_Income.MovementId
                         GROUP BY MI_Income.MovementId
                                , COALESCE (Movement_Income.DescId, 0)
                                , Movement_Income.OperDate
                                , Object_PartionMovementItem.ObjectCode
                                , tmpMI.GoodsId
                        )
    , tmpIncome_find AS (SELECT DISTINCT
                                tmpData_all.MovementItemId_Income
                              , tmpData_all.OperDate_Income
                              , tmpData_all.GoodsId
                         FROM tmpData_all
                         WHERE tmpData_all.MovementDescId = zc_Movement_Inventory()
                        )
     , tmpIncome_all AS (SELECT *
                         FROM
                        (SELECT Movement.Id AS MovementId
                              , MI.Id       AS MovementItemId
                              , tmpIncome_find.MovementItemId_Income
                              , tmpIncome_find.GoodsId
                              , ROW_NUMBER() OVER (PARTITION BY tmpIncome_find.MovementItemId_Income, tmpIncome_find.GoodsId ORDER BY CASE WHEN Movement.OperDate >= tmpIncome_find.OperDate_Income THEN Movement.OperDate - tmpIncome_find.OperDate_Income ELSE tmpIncome_find.OperDate_Income - Movement.OperDate END, Movement.OperDate) AS myRow
                         FROM tmpIncome_find
                              INNER JOIN Movement ON Movement.DescId = zc_Movement_Income() AND Movement.StatusId = zc_Enum_Status_Complete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                    ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical_find
                                                    ON ObjectLink_Unit_Juridical_find.ChildObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                   AND ObjectLink_Unit_Juridical_find.ObjectId = inUnitId
                                                   AND ObjectLink_Unit_Juridical_find.DescId = zc_ObjectLink_Unit_Juridical()
                              INNER JOIN MovementItem AS MI
                                                      ON MI.MovementId = Movement.Id
                                                     AND MI.DescId = zc_MI_Master()
                                                     AND MI.isErased = FALSE
                                                     AND MI.ObjectId = tmpIncome_find.GoodsId
                                                     AND MI.Amount <> 0
                        ) AS tmp
                         WHERE tmp.myRow = 1
                        )
         , tmpIncome AS (SELECT tmpIncome_all.MovementId
                              , tmpIncome_all.MovementItemId_Income
                              , tmpIncome_all.GoodsId
                              , MovementLinkObject_From_Income.ObjectId      AS JuridicalId_Income
                              , MovementLinkObject_NDSKind_Income.ObjectId   AS NDSKindId_Income
                              , COALESCE (MIFloat_Income_Price.ValueData, 0) AS Price_original
                              , COALESCE (MIFloat_Income_Price.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END AS Price
                         FROM tmpIncome_all
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpIncome_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId = zc_MovementLinkObject_From()

                              LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId = tmpIncome_all.MovementId
                                                       AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpIncome_all.MovementId
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                              LEFT JOIN ObjectFloat AS ObjectFloat_NDS_Income
                                                    ON ObjectFloat_NDS_Income.ObjectId = MovementLinkObject_NDSKind_Income.ObjectId
                                                   AND ObjectFloat_NDS_Income.DescId = zc_ObjectFloat_NDSKind_NDS()
                              LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                          ON MIFloat_Income_Price.MovementItemId = tmpIncome_all.MovementItemId
                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 
                        )
           , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                              , CASE WHEN inIsPartion = TRUE THEN CASE WHEN tmpData_all.MovementDescId = zc_Movement_Inventory() THEN tmpIncome.MovementId ELSE tmpData_all.MovementId_Income END ELSE 0 END AS MovementId_Price
                              , COALESCE (tmpIncome.JuridicalId_Income, MovementLinkObject_From_Income.ObjectId)    AS JuridicalId_Income
                              , COALESCE (tmpIncome.NDSKindId_Income,   MovementLinkObject_NDSKind_Income.ObjectId) AS NDSKindId_Income
                              , tmpData_all.GoodsId
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale
                              , SUM (tmpData_all.Amount * COALESCE (tmpIncome.Price_original, COALESCE (MIFloat_Income_Price.ValueData, 0))) AS Summa_original
                              , SUM (tmpData_all.Amount * COALESCE (tmpIncome.Price, COALESCE (MIFloat_Income_Price.ValueData, 0)
                                                                                   * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END)
                                    ) AS Summa
                              , CASE WHEN COALESCE (tmpIncome.Price_original, COALESCE (MIFloat_Income_Price.ValueData, 0)) = 0 THEN 0 ELSE 1 END AS isPrice
                         FROM tmpData_all
                              LEFT JOIN tmpIncome ON tmpIncome.MovementItemId_Income = tmpData_all.MovementItemId_Income
                                                 AND tmpIncome.GoodsId               = tmpData_all.GoodsId
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId_Income
                                                          AND MovementLinkObject_From_Income.DescId = zc_MovementLinkObject_From()
                                                          AND tmpData_all.MovementDescId = zc_Movement_Income() 

                              LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId = tmpData_all.MovementId_Income
                                                       AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                                       AND tmpData_all.MovementDescId = zc_Movement_Income() 

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId_Income
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                                                          AND tmpData_all.MovementDescId = zc_Movement_Income() 
                              LEFT JOIN ObjectFloat AS ObjectFloat_NDS_Income
                                                    ON ObjectFloat_NDS_Income.ObjectId = MovementLinkObject_NDSKind_Income.ObjectId
                                                   AND ObjectFloat_NDS_Income.DescId = zc_ObjectFloat_NDSKind_NDS()

                              LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                          ON MIFloat_Income_Price.MovementItemId = tmpData_all.MovementItemId_Income
                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 
                                                         AND tmpData_all.MovementDescId = zc_Movement_Income() 
                         GROUP BY CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN CASE WHEN tmpData_all.MovementDescId = zc_Movement_Inventory() THEN tmpIncome.MovementId ELSE tmpData_all.MovementId_Income END ELSE 0 END
                                , COALESCE (tmpIncome.JuridicalId_Income, MovementLinkObject_From_Income.ObjectId)
                                , COALESCE (tmpIncome.NDSKindId_Income,   MovementLinkObject_NDSKind_Income.ObjectId)
                                , tmpData_all.GoodsId
                                , tmpIncome.GoodsId
                                , CASE WHEN COALESCE (tmpIncome.Price_original, COALESCE (MIFloat_Income_Price.ValueData, 0)) = 0 THEN 0 ELSE 1 END
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
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa          / tmpData.Amount ELSE 0 END :: TFloat AS Price
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa_original / tmpData.Amount ELSE 0 END :: TFloat AS Price_original
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale      / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale

           , tmpData.Summa     :: TFloat AS Summa
           , tmpData.SummaSale :: TFloat AS SummaSale

           , (tmpData.SummaSale - tmpData.Summa) :: TFloat AS SummaMargin

           , MovementDesc_Income.ItemName AS PartionDescName
           , Movement_Income.InvNumber    AS PartionInvNumber
           , Movement_Income.OperDate     AS PartionOperDate
           , MovementDesc_Price.ItemName  AS PartionPriceDescName
           , Movement_Price.InvNumber     AS PartionPriceInvNumber
           , Movement_Price.OperDate      AS PartionPriceOperDate

        FROM tmpData
             LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
             LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = tmpData.NDSKindId_Income
             LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpData.GoodsId

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
             LEFT JOIN Movement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_Price

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
-- SELECT * FROM gpReport_Movement_Check (inUnitId:= 0, inDateStart:= '20150801'::TDateTime, inDateFinal:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')

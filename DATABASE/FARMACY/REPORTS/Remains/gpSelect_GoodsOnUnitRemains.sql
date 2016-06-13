-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRemainsDate      TDateTime,  -- Дата остатка
    IN inIsPartion        Boolean,    -- 
    IN inisPartionPrice   Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId integer, Id integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupName TVarChar, NDSKindName TVarChar
             , Amount TFloat, Price TFloat, PriceWithVAT TFloat, PriceWithOutVAT TFloat, PriceSale  TFloat
             
             , Summa TFloat, SummaWithVAT TFloat, SummaWithOutVAT TFloat, SummaSale TFloat
             , MinExpirationDate TDateTime
             , PartionDescName TVarChar, PartionInvNumber TVarChar, PartionOperDate TDateTime
             , PartionPriceDescName TVarChar, PartionPriceInvNumber TVarChar, PartionPriceOperDate TDateTime

             , UnitName TVarChar, OurJuridicalName TVarChar
             , JuridicalCode  Integer, JuridicalName  TVarChar
             , MP_JuridicalName TVarChar
             , MP_ContractName TVarChar
             , MinPriceOnDate TFloat, MP_Summa TFloat
             , MinPriceOnDateVAT TFloat, MP_SummaVAT TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
        WITH ContainerCount AS (SELECT Container.Id                AS ContainerId
                                     , Container.Amount
                                     , Container.ObjectID          AS GoodsId
                                     , MI_Income.MovementId        AS MovementId_Income
                                     , MI_Income_find.MovementId   AS MovementId_find
                                     , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                                     , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              
                                FROM Container
                                    -- партия
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                        ON CLI_MI.ContainerId = Container.Id
                                                                       AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    -- элемент прихода
                                    LEFT OUTER JOIN MovementItem AS MI_Income
                                                                 ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                                                 
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                WHERE Container.DescId = zc_Container_count()
                                  AND Container.WhereObjectId = inUnitId)

           , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.ContainerId ELSE 0 END AS ContainerId
                              , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                              , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END AS MovementId_find
                              , MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income
                              , MovementLinkObject_NDSKind_Income.ObjectId                                 AS NDSKindId_Income
                              , tmpData_all.GoodsId
                              , SUM (tmpData_all.Amount)                                                   AS Amount
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              --
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END AS OurJuridicalId_Income
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END               AS ToId_Income
                              
                         FROM (
                                 SELECT ContainerCount.ContainerId
                                      , ContainerCount.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                      , ContainerCount.GoodsId 
                                      , ContainerCount.MovementId_Income
                                      , ContainerCount.MovementId_find
                                      , ContainerCount.MovementId
                                      , ContainerCount.MovementItemId
                                 FROM ContainerCount
                                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                                      ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                                     AND MIContainer.OperDate >= inRemainsDate
                                 GROUP BY ContainerCount.ContainerId, ContainerCount.GoodsId, ContainerCount.Amount
                                      , ContainerCount.MovementId_Income
                                      , ContainerCount.MovementId_find
                                      , ContainerCount.MovementId
                                      , ContainerCount.MovementItemId
                                 ) AS tmpData_all

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
                                                          
                         GROUP BY CASE WHEN inIsPartion = TRUE THEN tmpData_all.ContainerId ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END
                                , MovementLinkObject_From_Income.ObjectId
                                , MovementLinkObject_NDSKind_Income.ObjectId
                                , tmpData_all.GoodsId
                                , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END                                                              
                         HAVING (SUM (tmpData_all.Amount) <> 0)                                
                          )


        SELECT tmpData.ContainerId
             , Object_Goods_View.Id                         as Id
             , Object_Goods_View.GoodsCodeInt ::Integer     as GoodsCode
             , Object_Goods_View.GoodsName                  as GoodsName
             , Object_Goods_View.GoodsGroupName             AS GoodsGroupName
             , Object_NDSKind_Income.ValueData              AS NDSKindName
             
           , tmpData.Amount :: TFloat AS Amount
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT
           , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)                 :: TFloat AS PriceSale
           
           , tmpData.Summa           :: TFloat AS Summa
           , tmpData.SummaWithVAT    :: TFloat AS SummaWithVAT
           , tmpData.SummaWithOutVAT :: TFloat AS SummaWithOutVAT
           , (tmpData.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) :: TFloat AS SummaSale

           , SelectMinPrice_AllGoods.MinExpirationDate    AS MinExpirationDate

           , MovementDesc_Income.ItemName AS PartionDescName
           , Movement_Income.InvNumber    AS PartionInvNumber
           , Movement_Income.OperDate     AS PartionOperDate
           , COALESCE (MovementDesc_Price.ItemName, MovementDesc_Income.ItemName) AS PartionPriceDescName
           , COALESCE (Movement_Price.InvNumber, Movement_Income.InvNumber)       AS PartionPriceInvNumber
           , COALESCE (Movement_Price.OperDate, Movement_Income.OperDate)         AS PartionPriceOperDate

           , Object_To_Income.ValueData              AS UnitName
           , Object_OurJuridical_Income.ValueData    AS OurJuridicalName
             
           , Object_From_Income.ObjectCode           AS JuridicalCode
           , Object_From_Income.ValueData            AS JuridicalName

           , SelectMinPrice_AllGoods_onDate.JuridicalName AS MP_JuridicalName
           , Object_Contract.ValueData                    AS MP_ContractName
           , SelectMinPrice_AllGoods_onDate.Price         AS MinPriceOnDate
           , (SelectMinPrice_AllGoods_onDate.Price * tmpData.Amount) :: TFloat    AS MP_Summa
           , (SelectMinPrice_AllGoods_onDate.Price * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) :: TFloat                     AS MinPriceOnDateVAT
           , (SelectMinPrice_AllGoods_onDate.Price * tmpData.Amount * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) :: TFloat    AS MP_SummaVAT
        FROM tmpData
            LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
            LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = tmpData.NDSKindId_Income
            LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
            LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

            LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
            LEFT JOIN Movement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

            LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
            LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId
        
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpData.GoodsId

            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = tmpData.NDSKindId_Income
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON Object_Price.GoodsId = tmpData.GoodsId
                                             AND Object_Price.UnitId = inUnitId

            -- получаем значения цены и НТЗ из истории значений на дату на начало                                                          
            LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                    ON ObjectHistory_Price.ObjectId = Object_Price.Id
                                   AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                   AND inRemainsDate >= ObjectHistory_Price.StartDate AND inRemainsDate < ObjectHistory_Price.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                                                        
            LEFT JOIN lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                inObjectId := vbObjectId, 
                                                inUserId := vbUserId) AS SelectMinPrice_AllGoods
                                                                      ON SelectMinPrice_AllGoods.GoodsId = Object_Goods_View.Id
            LEFT JOIN lpSelectMinPrice_AllGoods_onDate(inOperDate := inRemainsDate,
                                                       inUnitId   := inUnitId,
                                                       inObjectId := vbObjectId, 
                                                       inUserId   := vbUserId) AS SelectMinPrice_AllGoods_onDate
                                                                               ON SelectMinPrice_AllGoods_onDate.GoodsId = Object_Goods_View.Id
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = SelectMinPrice_AllGoods_onDate.ContractId
                                                                         
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.05.16         *
 27.03.16         *
 28.01.16         *
 02.06.15                        *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnitRemains (inUnitId := 377613 , inRemainsDate := ('10.05.2016')::TDateTime, inIsPartion:= FALSE, inisPartionPrice:= FALSE, inSession := '3');

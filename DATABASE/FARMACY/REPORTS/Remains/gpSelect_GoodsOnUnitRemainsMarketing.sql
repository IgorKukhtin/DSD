 -- Function: gpSelect_GoodsOnUnitRemainsMarketing()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemainsMarketing (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemainsMarketing(
    IN inUnitId            Integer  ,  -- Подразделение
    IN inRemainsDate       TDateTime,  -- Дата остатка
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer
             , Id Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupName TVarChar
             , NDS TFloat
             , isSP Boolean, isPromo boolean
             , ConditionsKeepName TVarChar
             , Amount TFloat, Price TFloat, PriceWithVAT TFloat, PriceWithOutVAT TFloat, PriceSale  TFloat

             , Summa TFloat, SummaWithVAT TFloat, SummaWithOutVAT TFloat, SummaSale TFloat
             , MinExpirationDate TDateTime
             , PartionDescName TVarChar, PartionInvNumber TVarChar, PartionOperDate TDateTime
             , PartionPriceDescName TVarChar, PartionPriceInvNumber TVarChar, PartionPriceOperDate TDateTime

             , UnitName TVarChar, OurJuridicalName TVarChar
             , JuridicalCode  Integer, JuridicalName  TVarChar
             
             , GoodsGroupPromoName TVarChar, PriceSip TFloat, ChangePercent TFloat, MakerName TVarChar
             , SommaBonus TFloat

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
    -- Контролшь использования подразделения
    inUnitId := gpGet_CheckingUser_Unit(inUnitId, inSession);
    
    CREATE TEMP TABLE tmpContainerCount (ContainerId Integer, GoodsId Integer, Amount TFloat, ExpirationDate TDateTime) ON COMMIT DROP;
    --CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;

    -- raise notice 'Value 01: %', CLOCK_TIMESTAMP();

    WITH tmpContainerPD AS (SELECT Container.ParentId          AS ContainerId
                                 , MIN(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate  
                            FROM Container

                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.ContainerId = Container.Id
                                                               AND MIContainer.OperDate >= inRemainsDate

                                LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                             AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                     ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                    AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.WhereObjectId = inUnitId
                            GROUP BY Container.ParentId, Container.Amount
                            HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)

    INSERT INTO tmpContainerCount(ContainerId, GoodsId, Amount, ExpirationDate)
                                SELECT Container.Id                AS ContainerId
                                     , Container.ObjectId          AS GoodsId
                                     , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                     , tmpContainerPD.ExpirationDate
                                FROM Container
                                    --INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = Container.Id
                                                                   AND MIContainer.OperDate >= inRemainsDate
                                    LEFT JOIN tmpContainerPD ON tmpContainerPD.ContainerId = Container.Id 
                                WHERE Container.DescId = zc_Container_count()
                                  AND Container.WhereObjectId = inUnitId
                                GROUP BY Container.Id
                                     , Container.Amount
                                     , Container.ObjectId
                                     , tmpContainerPD.ExpirationDate
                                HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0;

     ANALYZE tmpContainerCount;

     -- raise notice 'Value 02: % <%>', CLOCK_TIMESTAMP(), (select count(*) from tmpContainerCount);

    CREATE TEMP TABLE tmpData ON COMMIT DROP AS
        WITH
                tmpData_all AS (SELECT tmpContainerCount.ContainerId
                                     , tmpContainerCount.Amount  AS Amount
                                     , tmpContainerCount.GoodsId
                                     , MI_Income.MovementId        AS MovementId_Income
                                     , MI_Income_find.MovementId   AS MovementId_find
                                     , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                                     , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                                     , tmpContainerCount.ExpirationDate
                                FROM tmpContainerCount
                                    -- партия
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI
                                                                        ON CLI_MI.ContainerId = tmpContainerCount.ContainerId
                                                                       AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    -- элемент прихода
                                    LEFT OUTER JOIN MovementItem AS MI_Income
                                                                 ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer

                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                )
           , tmpExpirationDate AS(SELECT MIDate_ExpirationDate.MovementItemId
                                       , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate
                                  FROM MovementItemDate AS MIDate_ExpirationDate
                                  WHERE MIDate_ExpirationDate.MovementItemId IN (SELECT DISTINCT tmpData_all.MovementItemId FROM tmpData_all)
                                    AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                 )

           , tmpMIFloat AS (SELECT MovementItemFloat.*
                                  FROM MovementItemFloat
                                  WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpData_all.MovementItemId FROM tmpData_all)
                                    AND MovementItemFloat.DescId IN (zc_MIFloat_JuridicalPrice()
                                                                   , zc_MIFloat_PriceWithVAT()
                                                                   , zc_MIFloat_PriceWithOutVAT()
                                                                   )
                           )

           , tmpMLO AS (SELECT MovementLinkObject.*
                        FROM MovementLinkObject
                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpData_all.MovementId FROM tmpData_all)
                          AND MovementLinkObject.DescId IN (zc_MovementLinkObject_NDSKind()
                                                          , zc_MovementLinkObject_From()
                                                          , zc_MovementLinkObject_To()
                                                          , zc_MovementLinkObject_Juridical()
                                                          )
                       )

           SELECT tmpData_all.MovementId_Income AS MovementId_Income
                , tmpData_all.MovementId_find   AS MovementId_find
                , MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income
                , MovementLinkObject_NDSKind_Income.ObjectId                                 AS NDSKindId_Income
                , tmpData_all.ContainerId                                                    AS ContainerId
                , tmpData_all.GoodsId
                , SUM (tmpData_all.Amount)                                                   AS Amount
                , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                --
                , MovementLinkObject_Juridical_Income.ObjectId                               AS OurJuridicalId_Income
                , MovementLinkObject_To.ObjectId                                             AS ToId_Income
                              
                , COALESCE(tmpData_all.ExpirationDate, tmpExpirationDate.ExpirationDate)     AS ExpirationDate   

           FROM  tmpData_all

                -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                LEFT JOIN tmpMIFloat AS MIFloat_JuridicalPrice
                                     ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                    AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                LEFT JOIN tmpMIFloat AS MIFloat_PriceWithVAT
                                     ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                    AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                -- цена без учета НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                LEFT JOIN tmpMIFloat AS MIFloat_PriceWithOutVAT
                                     ON MIFloat_PriceWithOutVAT.MovementItemId = tmpData_all.MovementItemId
                                    AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                -- Поставшик, для элемента прихода от поставщика (или NULL)
                LEFT JOIN tmpMLO AS MovementLinkObject_From_Income
                                 ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                -- Вид НДС, для элемента прихода от поставщика (или NULL)
                LEFT JOIN tmpMLO AS MovementLinkObject_NDSKind_Income
                                 ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                                AND COALESCE (MovementLinkObject_NDSKind_Income.ObjectId, 0) <> 13937605
                -- куда был приход от поставщика (склад или аптека)
                LEFT JOIN tmpMLO AS MovementLinkObject_To
                                 ON MovementLinkObject_To.MovementId = tmpData_all.MovementId
                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                -- на какое наше юр лицо был приход
                LEFT JOIN tmpMLO AS MovementLinkObject_Juridical_Income
                                 ON MovementLinkObject_Juridical_Income.MovementId = tmpData_all.MovementId
                                AND MovementLinkObject_Juridical_Income.DescId = zc_MovementLinkObject_Juridical()

                LEFT JOIN tmpExpirationDate ON tmpExpirationDate.MovementItemId = tmpData_all.MovementItemId

           GROUP BY tmpData_all.MovementId_Income
                  , tmpData_all.MovementId_find
                  , MovementLinkObject_From_Income.ObjectId
                  , MovementLinkObject_NDSKind_Income.ObjectId
                  , tmpData_all.GoodsId
                  , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
                  , MovementLinkObject_Juridical_Income.ObjectId
                  , MovementLinkObject_To.ObjectId
                  , tmpData_all.ContainerId
                  , COALESCE(tmpData_all.ExpirationDate, tmpExpirationDate.ExpirationDate)
           HAVING SUM (tmpData_all.Amount) <> 0;                        

     ANALYZE tmpData;

     -- raise notice 'Value 02: % <%>', CLOCK_TIMESTAMP(), (select count(*) from tmpData);



    -- Результат
    RETURN QUERY
        WITH
            -- Маркетинговый контракт
            GoodsPromo AS (SELECT tmpGoodsRetail.GoodsMainId AS GoodsId
                                , tmp.ChangePercent
                                , tmp.Price
                                , tmp.GoodsGroupPromoName
                                , tmp.MakerID
                                , ROW_NUMBER() OVER (PARTITION BY tmpGoodsRetail.GoodsMainId ORDER BY tmp.MovementId DESC) AS Ord
                           FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp        -- inRemainsDate   --CURRENT_DATE
                                LEFT JOIN Object_Goods_Retail AS tmpGoodsRetail ON tmpGoodsRetail.Id = tmp.GoodsId
                           )

          , Object_Price AS (SELECT Object_Price.Id       AS Id
                                  , Object_Price.GoodsId  AS GoodsId
                                  , Object_Price.Price    AS Price
                             FROM Object_Price_View AS Object_Price
                             WHERE Object_Price.UnitId = inUnitId
                           )
          , tmpMovement AS (SELECT Movement.*
                            FROM Movement
                            WHERE Movement.Id IN (SELECT DISTINCT tmpData.MovementId_Income FROM tmpData
                                                 UNION 
                                                  SELECT DISTINCT tmpData.MovementId_find FROM tmpData)
                            )

          , tmpObjectFloat_NDSKind_NDS AS (SELECT ObjectFloat.*
                                           FROM ObjectFloat
                                           WHERE ObjectFloat.DescId = zc_ObjectFloat_NDSKind_NDS()  
                                           )
               

        -- Результат
        SELECT tmpData.ContainerId                           :: Integer   AS ContainerId
             , tmpGoodsRetail.Id                                          AS Id
             , tmpGoods.ObjectCode                           ::Integer    AS GoodsCode
             , tmpGoods.Name                                              AS GoodsName
             , Object_GoodsGroup.ValueData                                AS GoodsGroupName
             , ObjectFloat_NDSKind_NDS.ValueData                          AS NDS
             , COALESCE (tmpGoodsSP.isSP, False)                          AS isSP
             , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo
             , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar   AS ConditionsKeepName

             , tmpData.Amount :: TFloat AS Amount
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT
             , COALESCE (Object_Price.Price, 0)                                                       :: TFloat AS PriceSale

             , tmpData.Summa                                 :: TFloat    AS Summa
             , tmpData.SummaWithVAT                          :: TFloat    AS SummaWithVAT
             , tmpData.SummaWithOutVAT                       :: TFloat    AS SummaWithOutVAT
             , (tmpData.Amount * COALESCE (Object_Price.Price, 0)) :: TFloat AS SummaSale

             , tmpData.ExpirationDate                                     AS MinExpirationDate

             , MovementDesc_Income.ItemName                               AS PartionDescName
             , Movement_Income.InvNumber                                  AS PartionInvNumber
             , Movement_Income.OperDate                                   AS PartionOperDate
             , COALESCE (MovementDesc_Price.ItemName, MovementDesc_Income.ItemName) AS PartionPriceDescName
             , COALESCE (Movement_Price.InvNumber, Movement_Income.InvNumber)       AS PartionPriceInvNumber
             , COALESCE (Movement_Price.OperDate, Movement_Income.OperDate)         AS PartionPriceOperDate

             , Object_To_Income.ValueData                                 AS UnitName
             , Object_OurJuridical_Income.ValueData                       AS OurJuridicalName

             , Object_From_Income.ObjectCode                              AS JuridicalCode
             , Object_From_Income.ValueData                               AS JuridicalName
             
             , GoodsPromo.GoodsGroupPromoName                             AS GoodsGroupPromoName
             , GoodsPromo.Price                                           AS PriceSip
             , COALESCE(tmpGoods.PromoBonus, GoodsPromo.ChangePercent)::TFloat    AS ChangePercent
             , Object_Maker.ValueData                                     AS MakerName
             
             , CASE WHEN COALESCE(GoodsPromo.GoodsId, 0) = 0
                    THEN Null 
                    WHEN COALESCE(GoodsPromo.Price, 0) = 0
                    THEN tmpData.Summa * COALESCE(tmpGoods.PromoBonus, GoodsPromo.ChangePercent) / 100
                    ELSE GoodsPromo.Price * tmpData.Amount * COALESCE(tmpGoods.PromoBonus, GoodsPromo.ChangePercent) / 100 END :: TFloat   SommaBonus  
        FROM tmpData
             LEFT JOIN Object_Goods_Retail AS tmpGoodsRetail ON tmpGoodsRetail.Id = tmpData.GoodsId
             LEFT JOIN Object_Goods_Main AS tmpGoods ON tmpGoods.Id = tmpGoodsRetail.GoodsMainId
             LEFT JOIN Object_Goods_SP AS tmpGoodsSP ON tmpGoodsSP.Id = tmpGoodsRetail.GoodsMainId
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoods.GoodsGroupId AND Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = tmpGoods.ConditionsKeepId

             LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income

             LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
             LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

             LEFT JOIN tmpMovement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
             LEFT JOIN tmpMovement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

             LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
             LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId

             LEFT JOIN tmpObjectFloat_NDSKind_NDS AS ObjectFloat_NDSKind_NDS
                                                  ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (tmpData.NDSKindId_Income, tmpGoods.NDSKindId)
                                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

             LEFT JOIN Object_Price ON Object_Price.GoodsId = tmpData.GoodsId
 
             LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = tmpGoods.Id
                                 AND GoodsPromo.Ord = 1
                                                        
             LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = GoodsPromo.MakerID
         ;

     -- raise notice 'Value 20: %', CLOCK_TIMESTAMP();

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 18.10.23                                                                     *
*/

-- тест
--

select * from gpSelect_GoodsOnUnitRemainsMarketing(inUnitId := 377594 , inRemainsDate := ('06.09.2023')::TDateTime ,  inSession := '3');
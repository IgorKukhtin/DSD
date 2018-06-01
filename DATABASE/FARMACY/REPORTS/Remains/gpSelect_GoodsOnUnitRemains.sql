 -- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, Integer, TDateTime, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains(
    IN inUnitId           Integer  ,  -- Подразделение
    --IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inRemainsDate      TDateTime,  -- Дата остатка
    IN inIsPartion        Boolean,    -- 
    IN inisPartionPrice   Boolean,    -- 
    IN inisJuridical      Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer
             , Id Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupName TVarChar
             , NDSKindName TVarChar, NDS TFloat
             , isSP Boolean, isPromo boolean
             , ConditionsKeepName TVarChar
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


    CREATE TEMP TABLE tmpContainerCount (ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;
    
    -- список подразделений
   /* INSERT INTO tmpUnit (UnitId)
                SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0
               UNION 
                SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                               OR (inRetailId = 0 AND inUnitId = 0))
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();
     
    */        
    INSERT INTO tmpContainerCount(ContainerId, GoodsId, Amount)
                                SELECT Container.Id                AS ContainerId
                                     , Container.ObjectId          AS GoodsId
                                     , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                FROM Container
                                    --INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = Container.Id
                                                                   AND MIContainer.OperDate >= inRemainsDate
                                WHERE Container.DescId = zc_Container_count()
                                  AND Container.WhereObjectId = inUnitId
                                GROUP BY Container.Id  
                                     , Container.Amount 
                                     , Container.ObjectId
                                HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0;

      --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE tmpContainerCount;

    -- Результат
    RETURN QUERY
        WITH  
       /* tmpContainerCount AS (SELECT Container.Id                AS ContainerId
                                   , Container.ObjectId          AS GoodsId
                                   , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                              FROM Container
                                  --INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                  LEFT JOIN MovementItemContainer AS MIContainer 
                                                                  ON MIContainer.ContainerId = Container.Id
                                                                 AND MIContainer.OperDate >= inRemainsDate
                              WHERE Container.DescId = zc_Container_count()
                                AND Container.WhereObjectId = inUnitId
                              GROUP BY Container.Id  
                                   , Container.Amount 
                                   , Container.ObjectId
                              HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                              )

              ,*/ tmpData_all AS (SELECT tmpContainerCount.ContainerId
                                     , tmpContainerCount.Amount  AS Amount
                                     , tmpContainerCount.GoodsId
                                     , MI_Income.MovementId        AS MovementId_Income
                                     , MI_Income_find.MovementId   AS MovementId_find
                                     , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                                     , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              
                                FROM tmpContainerCount
                                    -- партия
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                        ON CLI_MI.ContainerId = tmpContainerCount.ContainerId
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
                                )

           , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                              , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END AS MovementId_find
                              --, MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income
                              , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END  AS JuridicalId_Income
                              , MovementLinkObject_NDSKind_Income.ObjectId                                 AS NDSKindId_Income
                              , CASE WHEN inIsPartion = TRUE THEN tmpData_all.ContainerId ELSE 0 END       AS ContainerId
                              , tmpData_all.GoodsId
                              , SUM (tmpData_all.Amount)                                                   AS Amount
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              --
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END AS OurJuridicalId_Income
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END               AS ToId_Income
                              
                         FROM  tmpData_all

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
                                                    
                         GROUP BY CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END
                                , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END
                                , MovementLinkObject_NDSKind_Income.ObjectId
                                , tmpData_all.GoodsId
                                , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END                                                              
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.ContainerId ELSE 0 END
                         HAVING SUM (tmpData_all.Amount) <> 0
                        )

  , tmpGoods AS (SELECT tmp.GoodsId
                      , ObjectLink_Goods_GoodsGroup.ChildObjectId                     AS GoodsGroupId
                      , ObjectLink_Goods_ConditionsKeep.ChildObjectId                 AS ConditionsKeepId
                      , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP
                 FROM (SELECT DISTINCT tmpData.GoodsId
                       FROM tmpData) AS tmp

                      LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = tmp.GoodsId
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                      -- условия хранения
                      LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                             ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmp.GoodsId
                            AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                      -- получается GoodsMainId
                      LEFT JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                            AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                      LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                            AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SP 
                             ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                            AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                 )
                 
    -- Маркетинговый контракт
  , GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                     --   , tmp.ChangePercent
                   FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp        -- inRemainsDate   --CURRENT_DATE
                                INNER JOIN ObjectLink AS ObjectLink_Child
                                                      ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                     AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                         AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                               AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                      ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                     AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                   )

  , SelectMinPrice_AllGoods AS (SELECT tmp.*
                                FROM lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                               inObjectId := vbObjectId, 
                                                               inUserId := vbUserId) AS tmp -- limit 1
                               )
            
  , SelectMinPrice_AllGoods_onDate AS (SELECT tmp.*
                                       FROM lpSelectMinPrice_AllGoods_onDate(inOperDate := inRemainsDate,
                                                                             inUnitId   := inUnitId,
                                                                             inObjectId := vbObjectId, 
                                                                             inUserId   := vbUserId) AS tmp -- limit 1
                                       WHERE 1=0 -- работает больше 1 мин.  много документов и строк более 180тыщ.
                                       )
  , Object_Price AS (SELECT Object_Price.Id       AS Id
                          , Object_Price.GoodsId  AS GoodsId
                     FROM Object_Price_View AS Object_Price
                     WHERE Object_Price.UnitId = inUnitId 
                   )

        -- Результат
        SELECT tmpData.ContainerId                           :: Integer   AS ContainerId
             , Object_Goods.Id                                            AS Id
             , Object_Goods.ObjectCode                       ::Integer    AS GoodsCode
             , Object_Goods.ValueData                                     AS GoodsName
             , Object_GoodsGroup.ValueData                                AS GoodsGroupName
             , Object_NDSKind_Income.ValueData                            AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData                          AS NDS
             , tmpGoods.isSP                                 :: Boolean   AS isSP
             , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo
             , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar   AS ConditionsKeepName
             
             , tmpData.Amount :: TFloat AS Amount
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT
             , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)                 :: TFloat AS PriceSale
           
             , tmpData.Summa                                 :: TFloat    AS Summa
             , tmpData.SummaWithVAT                          :: TFloat    AS SummaWithVAT
             , tmpData.SummaWithOutVAT                       :: TFloat    AS SummaWithOutVAT
             , (tmpData.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) :: TFloat AS SummaSale

             , SelectMinPrice_AllGoods.MinExpirationDate                  AS MinExpirationDate

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

             , SelectMinPrice_AllGoods_onDate.JuridicalName               AS MP_JuridicalName
             , Object_Contract.ValueData                                  AS MP_ContractName
             , SelectMinPrice_AllGoods_onDate.Price                       AS MinPriceOnDate
             , (SelectMinPrice_AllGoods_onDate.Price * tmpData.Amount) :: TFloat    AS MP_Summa
             , (SelectMinPrice_AllGoods_onDate.Price * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) :: TFloat                     AS MinPriceOnDateVAT
             , (SelectMinPrice_AllGoods_onDate.Price * tmpData.Amount * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) :: TFloat    AS MP_SummaVAT

        FROM tmpData
             LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpData.GoodsId
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoods.GoodsGroupId
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = tmpGoods.ConditionsKeepId
             LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                        ON ObjectLink_Goods_NDSKind.ObjectId = tmpData.GoodsId
                                       AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()

 /*           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
*/
            LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
            LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = COALESCE (tmpData.NDSKindId_Income, ObjectLink_Goods_NDSKind.ChildObjectId)
            
            LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
            LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

            LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
            LEFT JOIN Movement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

            LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
            LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId
        
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (tmpData.NDSKindId_Income, ObjectLink_Goods_NDSKind.ChildObjectId)
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

            LEFT OUTER JOIN Object_Price ON Object_Price.GoodsId = tmpData.GoodsId
                                        
            -- получаем значения цены и НТЗ из истории значений на дату на начало                                                          
            LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                    ON ObjectHistory_Price.ObjectId = Object_Price.Id
                                   AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                   AND inRemainsDate >= ObjectHistory_Price.StartDate AND inRemainsDate < ObjectHistory_Price.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                                                        
            LEFT JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.GoodsId_Retail = tmpData.GoodsId           -- связали по товару сети
            LEFT JOIN SelectMinPrice_AllGoods_onDate ON SelectMinPrice_AllGoods_onDate.GoodsId = tmpData.GoodsId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = SelectMinPrice_AllGoods_onDate.ContractId
            
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = tmpData.GoodsId
            -- условия хранения
            /*LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
            */

         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.18         *
 07.01.18         *
 12.08.17         *
 24.05.17         *
 12.01.17         *
 05.10.16         * add inisJuridical
 04.05.16         *
 27.03.16         *
 28.01.16         *
 02.06.15                        *
*/

-- тест
--
-- SELECT * FROM gpSelect_GoodsOnUnitRemains (inUnitId := 377613 , inRemainsDate := ('10.05.2016')::TDateTime, inIsPartion:= FALSE, inisPartionPrice:= FALSE, inisJuridical:=True, inSession := '3'::tvarchar);
--select * from gpSelect_GoodsOnUnitRemains(inUnitId := 7433764 , inRemainsDate := ('24.05.2018')::TDateTime , inIsPartion := 'False' , inisPartionPrice := 'False' , inisJuridical := 'False' ,  inSession := '7670317');
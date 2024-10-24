 -- Function: gpSelect_GoodsOnUnitRemains()

--DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains (Integer, TDateTime, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains(
    IN inUnitId            Integer  ,  -- Подразделение
    --IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inRemainsDate       TDateTime,  -- Дата остатка
    IN inIsPartion         Boolean,    --
    IN inisPartionPrice    Boolean,    --
    IN inisJuridical       Boolean,    --
    IN inisVendorminPrices Boolean,    --
    IN inisNotIncome       Boolean,    -- Без прихода на аптеку
    IN inSession           TVarChar    -- сессия пользователя
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

             , MakerName  TVarChar, BarCode TVarChar, MorionCode Integer, BadmCode TVarChar, OptimaCode TVarChar, AccommodationName TVarChar
             , CodeUKTZED TVarChar, FormDispensingName TVarChar, Measure TVarChar, PartionGoods TVarChar
             , isNoGoodsIncome Boolean, Color_calc Integer
             , isForRealize Boolean
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


    -- 
    CREATE TEMP TABLE tmpGoodsIncome (GoodsId Integer) ON COMMIT DROP;

    IF inisNotIncome = TRUE
    THEN
      INSERT INTO tmpGoodsIncome
      SELECT DISTINCT MIC.ObjectId_Analyzer FROM MovementItemContainer AS MIC
      WHERE MIC.DescId = zc_MIContainer_Count()
        AND MIC.WhereObjectId_Analyzer = inUnitId;    
    END IF;

    ANALYZE tmpGoodsIncome;
    
    CREATE TEMP TABLE tmpContainerCount (ContainerId Integer, GoodsId Integer, Amount TFloat, ExpirationDate TDateTime) ON COMMIT DROP;
    --CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;

     -- -- raise notice 'Value 01: %', CLOCK_TIMESTAMP();

    WITH tmpContainerPD AS (SELECT Container.ParentId          AS ContainerId
                                 , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
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
                            GROUP BY Container.Id, Container.ParentId, Container.Amount
                            HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)

    INSERT INTO tmpContainerCount(ContainerId, GoodsId, Amount, ExpirationDate)
                                SELECT Container.Id                AS ContainerId
                                     , Container.ObjectId          AS GoodsId
                                     , COALESCE(tmpContainerPD.Amount, Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) AS Amount
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
                                     , tmpContainerPD.Amount
                                     , tmpContainerPD.ExpirationDate
                                HAVING COALESCE(tmpContainerPD.Amount, Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0;

      --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE tmpContainerCount;

     -- raise notice 'Value 02: % <%>', CLOCK_TIMESTAMP(), (select count(*) from tmpContainerCount);

     CREATE TEMP TABLE tmpMakerNameAll ON COMMIT DROP AS
                           (SELECT  Object_Goods_Juridical.GoodsMainId
                                   , replace(replace(replace(COALESCE(Object_Goods_Juridical.MakerName, ''),'"',''),'&','&amp;'),'''','') AS MakerName
                                   , ROW_NUMBER()OVER(PARTITION BY Object_Goods_Juridical.GoodsMainId ORDER BY Object_Goods_Juridical.JuridicalId) as ORD
                            FROM
                                Object_Goods_Juridical
                            WHERE COALESCE(Object_Goods_Juridical.MakerName, '') <> ''
                           );
                       
     ANALYSE tmpMakerNameAll;

     -- raise notice 'Value 3: %', CLOCK_TIMESTAMP();

    -- Результат
    RETURN QUERY
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
                                    AND inIsPartion = TRUE
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
                                                          , zc_MovementLinkObject_Contract()
                                                          )
                       )

           , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                              , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END AS MovementId_find
                              --, MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income
                              , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END  AS JuridicalId_Income
                              , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN Max(MovementLinkObject_Contract_Income.ObjectId)::Integer ELSE 0 END  AS ContractId_Income
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
                              
                              , COALESCE(tmpData_all.ExpirationDate, tmpExpirationDate.ExpirationDate)                         AS ExpirationDate   
                              , CASE WHEN inIsPartion = TRUE THEN MIString_Measure.ValueData ELSE '' END::TVarChar             AS Measure
                              , CASE WHEN inIsPartion = TRUE THEN MIString_PartionGoods.ValueData ELSE '' END::TVarChar        AS PartionGoods

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
                              -- Серия из прихода
                              LEFT JOIN MovementItemString AS MIString_Measure
                                                           ON MIString_Measure.MovementItemId = tmpData_all.MovementItemId
                                                          AND MIString_Measure.DescId = zc_MIString_Measure()
                              -- Ед. изм из прихода
                              LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                           ON MIString_PartionGoods.MovementItemId = tmpData_all.MovementItemId
                                                          AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
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
                              -- на какое наше юр лицо был приход
                              LEFT JOIN tmpMLO AS MovementLinkObject_Contract_Income
                                               ON MovementLinkObject_Contract_Income.MovementId = tmpData_all.MovementId
                                              AND MovementLinkObject_Contract_Income.DescId = zc_MovementLinkObject_Contract()

                              LEFT JOIN tmpExpirationDate ON tmpExpirationDate.MovementItemId = tmpData_all.MovementItemId
                                                         AND inIsPartion = TRUE

                         GROUP BY CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END
                                , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END
                                , MovementLinkObject_NDSKind_Income.ObjectId
                                , tmpData_all.GoodsId
                                , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.ContainerId ELSE 0 END
                                , COALESCE(tmpData_all.ExpirationDate, tmpExpirationDate.ExpirationDate)
                                , CASE WHEN inIsPartion = TRUE THEN MIString_Measure.ValueData ELSE '' END
                                , CASE WHEN inIsPartion = TRUE THEN MIString_PartionGoods.ValueData ELSE '' END
                         HAVING SUM (tmpData_all.Amount) <> 0
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
                                       FROM lpSelect_GoodsMinPrice_onDate(inOperDate := inRemainsDate,
                                                                          inUnitId   := inUnitId,
                                                                          inObjectId := vbObjectId,
                                                                          inUserId   := vbUserId) AS tmp -- limit 1
                                       WHERE inisVendorminPrices = True -- работает больше 1 мин.  много документов и строк более 180тыщ.
                                       )
  , Object_Price AS (SELECT Object_Price.Id       AS Id
                          , Object_Price.GoodsId  AS GoodsId
                     FROM Object_Price_View AS Object_Price
                     WHERE Object_Price.UnitId = inUnitId
                   )
  , tmpMovement AS (SELECT Movement.*
                    FROM Movement
                    WHERE Movement.Id IN (SELECT DISTINCT tmpData_all.MovementId_Income FROM tmpData_all
                                         UNION 
                                          SELECT DISTINCT tmpData_all.MovementId_find FROM tmpData_all)
                    )

  , tmpOL_Goods_NDSKind AS (SELECT ObjectLink.*
                            FROM ObjectLink
                            WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                              AND ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind()
                            )

  , tmpObjectFloat_NDSKind_NDS AS (SELECT ObjectFloat.*
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.ObjectId IN (SELECT DISTINCT tmpData.NDSKindId_Income FROM tmpData
                                                                 UNION
                                                                  SELECT DISTINCT tmpOL_Goods_NDSKind.ChildObjectId FROM tmpOL_Goods_NDSKind)
                                     AND ObjectFloat.DescId = zc_ObjectFloat_NDSKind_NDS()  
                                   )
       , tmpMakerName AS (SELECT tmpMakerNameAll.GoodsMainId
                               , tmpMakerNameAll.MakerName
                          FROM tmpMakerNameAll
                          WHERE tmpMakerNameAll.ORD = 1)
       , tmpJuridicalAll AS (SELECT Object_Goods_Juridical.GoodsMainId
                                  , Object_Goods_Juridical.JuridicalID
                                  , Object_Goods_Juridical.Code
                                  , Object_Goods_Juridical.Name
                                  , ROW_NUMBER()OVER(PARTITION BY Object_Goods_Juridical.GoodsMainId, Object_Goods_Juridical.JuridicalID ORDER BY Object_Goods_Juridical.ID DESC) as ORD
                             FROM  Object_Goods_Juridical
                             WHERE COALESCE( Object_Goods_Juridical.Code, '') <> ''
                             )
       , tmpJuridical AS (SELECT tmpJuridicalAll.GoodsMainId
                               , tmpJuridicalAll.Code
                               , tmpJuridicalAll.Name
                               , tmpJuridicalAll.JuridicalID
                          FROM tmpJuridicalAll
                          WHERE tmpJuridicalAll.ORD = 1)
        -- Штрих-коды производителя
       , tmpGoodsBarCode AS (SELECT Object_Goods_BarCode.GoodsMainId
                                  , string_agg(replace(replace(replace(COALESCE(Object_Goods_BarCode.BarCode, ''), '"', ''),'&','&amp;'),'''',''), ',' ORDER BY Object_Goods_BarCode.GoodsMainId, Object_Goods_BarCode.Id desc) AS BarCode
                             FROM Object_Goods_BarCode
                             GROUP BY Object_Goods_BarCode.GoodsMainId
                             )               

        -- Результат
        SELECT tmpData.ContainerId                           :: Integer   AS ContainerId
             , tmpGoodsRetail.Id                                          AS Id
             , tmpGoods.ObjectCode                           ::Integer    AS GoodsCode
             , tmpGoods.Name                                              AS GoodsName
             , Object_GoodsGroup.ValueData                                AS GoodsGroupName
             , Object_NDSKind_Income.ValueData                            AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData                          AS NDS
             , COALESCE (tmpGoodsSP.isSP, False)                          AS isSP
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

             , CASE WHEN inIsPartion = TRUE THEN tmpData.ExpirationDate ELSE SelectMinPrice_AllGoods.MinExpirationDate END AS MinExpirationDate

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

             , tmpMakerName.MakerName::TVarChar
             , tmpGoodsBarCode.BarCode::TVarChar
             , tmpGoods.MorionCode
             , tmpJuridicalBadm.Code
             , tmpJuridicalOptima.Code
             , Object_Accommodation.ValueData AS AccommodationName
             , tmpGoods.CodeUKTZED
             , Object_FormDispensing.ValueData AS FormDispensingName
             , tmpData.Measure
             , tmpData.PartionGoods
             , COALESCE (tmpGoodsIncome.GoodsId, 0) = 0 AND inisNotIncome = TRUE AS isNoGoodsIncome
             , CASE WHEN COALESCE (tmpGoodsIncome.GoodsId, 0) = 0 AND inisNotIncome = TRUE
                    THEN zc_Color_Yelow()
                    ELSE zc_Color_White() END :: Integer AS Color_calc
             , COALESCE (ObjectBoolean_ForRealize.ValueData, FALSE):: Boolean    AS isForRealize                

        FROM tmpData
             LEFT JOIN Object_Goods_Retail AS tmpGoodsRetail ON tmpGoodsRetail.Id = tmpData.GoodsId
             LEFT JOIN Object_Goods_Main AS tmpGoods ON tmpGoods.Id = tmpGoodsRetail.GoodsMainId
             LEFT JOIN Object_Goods_SP AS tmpGoodsSP ON tmpGoodsSP.Id = tmpGoodsRetail.GoodsMainId
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoods.GoodsGroupId AND Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = tmpGoods.ConditionsKeepId
             LEFT OUTER JOIN tmpOL_Goods_NDSKind AS ObjectLink_Goods_NDSKind
                                                 ON ObjectLink_Goods_NDSKind.ObjectId = tmpData.GoodsId
                                                AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()

            LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
            LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = COALESCE (tmpData.NDSKindId_Income, ObjectLink_Goods_NDSKind.ChildObjectId)

            LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
            LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

            LEFT JOIN tmpMovement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
            LEFT JOIN tmpMovement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

            LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
            LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId

            LEFT JOIN tmpObjectFloat_NDSKind_NDS AS ObjectFloat_NDSKind_NDS
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
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = SelectMinPrice_AllGoods_onDate.ContractId AND Object_Contract.DescId = zc_Object_Contract()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_ForRealize
                                    ON ObjectBoolean_ForRealize.ObjectId = tmpData.ContractId_Income
                                   AND ObjectBoolean_ForRealize.DescId = zc_ObjectBoolean_Contract_ForRealize()

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = tmpData.GoodsId

            LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = tmpGoods.Id

            LEFT JOIN tmpMakerName ON tmpMakerName.GoodsMainId = tmpGoods.Id
            
            LEFT JOIN tmpJuridical AS tmpJuridicalBadm ON tmpJuridicalBadm.GoodsMainId = tmpGoods.Id
                                                      AND tmpJuridicalBadm.JuridicalID = 59610 

            LEFT JOIN tmpJuridical AS tmpJuridicalOptima ON tmpJuridicalOptima.GoodsMainId = tmpGoods.Id
                                                        AND tmpJuridicalOptima.JuridicalID = 59611  
                                                        
            -- Размещение товара
            LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                   ON Accommodation.UnitId = inUnitId
                                                  AND Accommodation.GoodsId = tmpData.GoodsId
                                                  AND Accommodation.isErased = False

            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId
                                                        
            LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = tmpGoods.FormDispensingId
            
            LEFT JOIN tmpGoodsIncome ON tmpGoodsIncome.GoodsId = tmpData.GoodsId            
         ;

     -- raise notice 'Value 20: %', CLOCK_TIMESTAMP();

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 21.06.18                                                                     *
 09.06.18                                                                     *
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
--select * from gpSelect_GoodsOnUnitRemains(inUnitId := 183289 , inRemainsDate := ('17.01.2022')::TDateTime , inIsPartion := 'False' , inisPartionPrice := 'False' , inisJuridical := 'False' , inisVendorminPrices := 'False' ,  inSession := '3');


select * from gpSelect_GoodsOnUnitRemains(inUnitId := 18712512 , inRemainsDate := ('31.01.2024')::TDateTime , inIsPartion := 'False' , inisPartionPrice := 'False' , inisJuridical := 'False' , inisVendorminPrices := 'False' , inisNotIncome := 'False' ,  inSession := '3');
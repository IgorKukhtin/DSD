 -- Function: gpReport_GoodsRemainsLight()

DROP FUNCTION IF EXISTS gpReport_GoodsRemainsLight (Integer, Integer, TDateTime, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsRemainsLight (Integer, Integer, Integer, TDateTime, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsRemainsLight(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inRemainsDate      TDateTime,  -- Дата остатка
    IN inIsPartion        Boolean,    --
    IN inisPartionPrice   Boolean,    --
    IN inisJuridical      Boolean,    --
    IN inisUnitList       Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer
             , Id Integer, GoodsCode Integer
             , BarCode TVarChar
             , GoodsName TVarChar, GoodsGroupName TVarChar
             , NDSKindName TVarChar, NDS TFloat
             , isSP Boolean
             , ConditionsKeepName TVarChar
             , Amount TFloat, Price TFloat, PriceWithVAT TFloat, PriceWithOutVAT TFloat
             
             , Summa TFloat, SummaWithVAT TFloat, SummaWithOutVAT TFloat
             , PartionDescName TVarChar, PartionInvNumber TVarChar, PartionOperDate TDateTime
             , PartionPriceDescName TVarChar, PartionPriceInvNumber TVarChar, PartionPriceOperDate TDateTime

             , UnitName TVarChar, OurJuridicalName TVarChar
             , JuridicalCode  Integer, JuridicalName  TVarChar
             , IsClose Boolean, UpdateDate TDateTime
             , isTop boolean, isFirst boolean , isSecond boolean
             , isPromo boolean, isResolution_224 boolean
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
    INSERT INTO tmpUnit (UnitId)
                SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0 
                  AND inisUnitList = FALSE
               UNION 
                SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                               OR (inRetailId = 0 AND inUnitId = 0))
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                  AND inisUnitList = FALSE
               UNION
                SELECT ObjectBoolean_Report.ObjectId          AS UnitId
                FROM ObjectBoolean AS ObjectBoolean_Report
                WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                  AND ObjectBoolean_Report.ValueData = TRUE
                  AND inisUnitList = TRUE;
            
    INSERT INTO tmpContainerCount(ContainerId, GoodsId, Amount)
                                SELECT Container.Id                AS ContainerId
                                     , Container.ObjectID          AS GoodsId
                                     , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                FROM Container
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = Container.Id
                                                                   AND MIContainer.OperDate >= inRemainsDate
                                WHERE Container.DescId = zc_Container_count()
                                --  AND Container.WhereObjectId = inUnitId
                                GROUP BY Container.Id  
                                     , Container.Amount 
                                     , Container.ObjectId
                                HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0;

      --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE tmpContainerCount;

    -- Результат
    RETURN QUERY
        WITH   /*           , tmpData_all AS (SELECT tmpContainerCount.ContainerId
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
                             */
           tmpData_1 AS (SELECT tmpContainerCount.ContainerId
                              , tmpContainerCount.Amount
                              , tmpContainerCount.GoodsId
                              , Object_PartionMovementItem.ObjectCode :: Integer
                              
                         FROM tmpContainerCount
                             -- партия
                             LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                 ON CLI_MI.ContainerId = tmpContainerCount.ContainerId
                                                                AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                         )
         , tmpMIFLoat_MI AS (SELECT MovementItemFloat.*
                             FROM MovementItemFloat
                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpData_1.ObjectCode FROM tmpData_1)
                               AND MovementItemFloat.DescId = zc_MIFloat_MovementItemId()
                             )
         , tmpData_2 AS (SELECT tmpData_1.ContainerId
                              , tmpData_1.Amount
                              , tmpData_1.GoodsId
                              , MI_Income.MovementId                      AS MovementId
                              , MI_Income.Id                              AS MI_Id
                              , MIFloat_MovementItem.ValueData :: Integer AS MI_Id_find
                         FROM tmpData_1
                             -- элемент прихода
                             LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_1.ObjectCode
                                                          
                             -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                             LEFT JOIN tmpMIFLoat_MI AS MIFloat_MovementItem
                                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                       -- AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                         )
         , tmpData_all AS (SELECT tmpData_2.ContainerId
                                , tmpData_2.Amount
                                , tmpData_2.GoodsId
                                , tmpData_2.MovementId        AS MovementId_Income
                                , MI_Income_find.MovementId   AS MovementId_find
                                , COALESCE (MI_Income_find.MovementId, tmpData_2.MovementId)  :: Integer AS MovementId
                                , COALESCE (MI_Income_find.Id,         tmpData_2.MI_Id)       :: Integer AS MovementItemId
                         
                           FROM tmpData_2
                               -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                               LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = tmpData_2.MI_Id_find
                           )
         , tmpMIFloat AS ( SELECT MIFloat_JuridicalPrice.*
                           FROM MovementItemFloat AS MIFloat_JuridicalPrice
                           WHERE MIFloat_JuridicalPrice.MovementItemId IN (SELECT DISTINCT tmpData_all.MovementItemId FROM tmpData_all)
                             AND MIFloat_JuridicalPrice.DescId IN (zc_MIFloat_JuridicalPrice(), zc_MIFloat_PriceWithVAT(), zc_MIFloat_PriceWithOutVAT())
                          )

         , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                            , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END AS MovementId_find
                            --, MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income
                            , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END  AS JuridicalId_Income
                            , CASE WHEN inIsPartion = TRUE THEN MovementLinkObject_NDSKind_Income.ObjectId ELSE Null END                    AS NDSKindId_Income
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
                            INNER JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                          ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                         AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_Juridical()
                                                         AND (MovementLinkObject_From_Income.ObjectId  = inJuridicalId OR inJuridicalId = 0)
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
          -- Штрих-коды производителя
         , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId                                                  AS GoodsMainId
                                    , STRING_AGG (Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc) AS BarCode
                                    --, Object_Goods_BarCode.ValueData        AS BarCode
                               FROM ObjectLink AS ObjectLink_Main_BarCode
                                    JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                    ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                   AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                    JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                    ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                   AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                    LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                               WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                 AND ObjectLink_Main_BarCode.ChildObjectId > 0
                                 AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                               GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                              )
          , tmpGoodsList AS (SELECT DISTINCT tmpData.GoodsId
                                    FROM tmpData)

           -- Товары соц-проект (документ)
          , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                           FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= inRemainsDate, inEndDate:= inRemainsDate, inUnitId := inUnitId) AS tmp
                           )
                 
          , tmpGoodsMain AS (SELECT tmp.GoodsId
                              , ObjectLink_Main.ChildObjectId                      AS GoodsMainId 
                              , COALESCE (tmpGoodsSP.isSP, False)      :: Boolean  AS isSP
                              , COALESCE (tmpGoodsBarCode.BarCode, '') :: TVarChar AS BarCode
                         FROM tmpGoodsList AS tmp
        
                              -- получается GoodsMainId
                              LEFT JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
        
                              LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
                             /*LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SP 
                                     ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                    AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()*/
                              
                              LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
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
                       )
     , tmpObjectBoolean AS (SELECT ObjectBoolean.*
                            FROM ObjectBoolean
                            WHERE ObjectBoolean.ObjectId IN (SELECT tmpGoodsList.GoodsId FROM tmpGoodsList)
                             AND ObjectBoolean.DescId IN (zc_ObjectBoolean_Goods_Close(), zc_ObjectBoolean_Goods_TOP(), zc_ObjectBoolean_Goods_First(), zc_ObjectBoolean_Goods_Second())
                           )
     , tmpObjectDate AS (SELECT ObjectDate.*
                            FROM ObjectDate
                            WHERE ObjectDate.ObjectId IN (SELECT tmpGoodsList.GoodsId FROM tmpGoodsList)
                             AND ObjectDate.DescId = zc_ObjectDate_Protocol_Update()  
                           )
      , tmpGoods AS (SELECT Object_Goods.Id                                                  AS Id
                          , Object_Goods.ObjectCode                             :: Integer   AS GoodsCode
                          , Object_Goods.ValueData                                           AS GoodsName
                          , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean AS isClose
                          , COALESCE(ObjectDate_Update.ValueData, Null)          ::TDateTime AS UpdateDate   
                          
                          , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean AS isTOP
                          , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean AS isFirst
                          , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean AS isSecond

                          , ObjectLink_Goods_NDSKind.ChildObjectId                           AS NDSKindId
                          , ObjectLink_Goods_GoodsGroup.ChildObjectId                        AS GoodsGroupId
                          , ObjectLink_Goods_ConditionsKeep.ChildObjectId                    AS ConditionsKeepId

                     FROM tmpGoodsList AS tmp
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId AND Object_Goods.DescId = zc_Object_Goods()
--and 1=0
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmp.GoodsId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
--and 1=0
                         -- условия хранения
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmp.GoodsId
                               AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
-- and 1=0       
                         LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                    ON ObjectLink_Goods_NDSKind.ObjectId = tmp.GoodsId
                                                   AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
--and 1=0
                         LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Goods_Close
                                                 ON ObjectBoolean_Goods_Close.ObjectId = Object_Goods.Id
                                                AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  
--and 1=0
                         LEFT JOIN tmpObjectDate AS ObjectDate_Update
                                              ON ObjectDate_Update.ObjectId = Object_Goods.Id
                                             AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()  
         --    and 1=0
                         LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Goods_TOP
                                                 ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                                AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP() 
--and 1=0 
                         LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Goods_First
                                                 ON ObjectBoolean_Goods_First.ObjectId = Object_Goods.Id
                                                AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
--and 1=0
                         LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Goods_Second
                                                 ON ObjectBoolean_Goods_Second.ObjectId = Object_Goods.Id
                                                AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second() 
--and 1=0
                     )

         , tmpMovement AS (SELECT Movement.*
                           FROM Movement
                           WHERE Movement.Id IN (SELECT DISTINCT tmpData.MovementId_Income FROM tmpData
                                                UNION 
                                                 SELECT DISTINCT tmpData.MovementId_find FROM tmpData)
                           )
       /*  , tmpMovementDesc AS (SELECT MovementDesc.*
                               FROM MovementDesc
                               WHERE MovementDesc.Id IN (SELECT DISTINCT tmpMovement.DescId FROM tmpMovement)
                               )*/
         , tmpObjectList AS (SELECT DISTINCT tmpGoods.GoodsGroupId AS Id
                             FROM tmpGoods
                            UNION 
                             SELECT DISTINCT tmpGoods.ConditionsKeepId AS Id
                             FROM tmpGoods
                            UNION 
                             SELECT DISTINCT tmpData.OurJuridicalId_Income AS Id
                             FROM tmpData
                            UNION 
                             SELECT DISTINCT tmpData.ToId_Income AS Id
                             FROM tmpData
                            UNION 
                             SELECT DISTINCT tmpData.NDSKindId_Income AS Id
                             FROM tmpData
                            UNION 
                             SELECT DISTINCT tmpData.JuridicalId_Income AS Id
                             FROM tmpData
                            UNION 
                             SELECT DISTINCT tmpGoods.NDSKindId AS Id
                             FROM tmpGoods
                             )
      
         , tmpObject AS (SELECT Object.*
                         FROM Object
                         WHERE Object.Id IN (SELECT DISTINCT tmpObjectList.Id FROM tmpObjectList)
                        )

        -- Результат
        SELECT tmpData.ContainerId                           :: Integer   AS ContainerId
             , Object_Goods.Id                                            AS Id
             , Object_Goods.GoodsCode                        :: Integer   AS GoodsCode
             , COALESCE (tmpGoodsMain.BarCode, '')           :: TVarChar  AS BarCode
             , Object_Goods.GoodsName                                     AS GoodsName
             , Object_GoodsGroup.ValueData                                AS GoodsGroupName
             , Object_NDSKind_Income.ValueData                            AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData                          AS NDS
             , tmpGoodsMain.isSP                             :: Boolean   AS isSP
             , COALESCE(Object_ConditionsKeep.ValueData, '') :: TVarChar  AS ConditionsKeepName
             
             , tmpData.Amount :: TFloat AS Amount
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT
           
             , tmpData.Summa                                 :: TFloat    AS Summa
             , tmpData.SummaWithVAT                          :: TFloat    AS SummaWithVAT
             , tmpData.SummaWithOutVAT                       :: TFloat    AS SummaWithOutVAT

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
             
             , COALESCE(Object_Goods.isClose, False)  :: Boolean AS isClose
             , COALESCE(Object_Goods.UpdateDate, Null)          ::TDateTime AS UpdateDate   
             
             , COALESCE(Object_Goods.isTOP, false)    :: Boolean AS isTOP
             , COALESCE(Object_Goods.isFirst, False)  :: Boolean AS isFirst
             , COALESCE(Object_Goods.isSecond, False) :: Boolean AS isSecond
             
             , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
             , COALESCE(ObjectBoolean_Goods_Resolution_224.ValueData, False) :: Boolean AS isResolution_224

        FROM tmpData
             LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = tmpData.GoodsId


             LEFT JOIN tmpGoods AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

             LEFT JOIN tmpObject AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods.GoodsGroupId

             LEFT JOIN tmpObject AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods.ConditionsKeepId

             LEFT JOIN tmpObject AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income

             LEFT JOIN tmpObject AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = COALESCE (tmpData.NDSKindId_Income, Object_Goods.NDSKindId)

             LEFT JOIN tmpObject AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income

             LEFT JOIN tmpObject AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

             LEFT JOIN tmpMovement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income

             LEFT JOIN tmpMovement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

             LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId

             LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId
            
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (tmpData.NDSKindId_Income, Object_Goods.NDSKindId)
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                 
             LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = tmpData.GoodsId

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Resolution_224
                                     ON ObjectBoolean_Goods_Resolution_224.ObjectId = tmpGoodsMain.GoodsMainId
                                    AND ObjectBoolean_Goods_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224() 
         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 11.02.19         * признак Товары соц-проект берем и документа
 31.05.18         *
 29.05.18                                                                     *
 07.01.18         *
 12.05.17         *
*/

-- тест
--
-- select * from gpReport_GoodsRemainsLight(inUnitId := 183292 , inRetailId := 0 , inJuridicalId := 0 , inRemainsDate := ('31.05.2018')::TDateTime , inIsPartion := 'False' , inisPartionPrice := 'False' , inisJuridical := 'True' , inisUnitList := 'False' ,  inSession := '3');

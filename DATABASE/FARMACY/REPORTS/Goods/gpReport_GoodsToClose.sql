-- Function: gpReport_GoodsToClose

DROP FUNCTION IF EXISTS gpReport_GoodsToClose (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsToClose(
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (GoodsId        Integer
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , Remains        TFloat
             , Amount         TFloat
             , ExpirationDate TDateTime
             , isClose        Boolean
             , isSelect       Boolean
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

-- raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    -- Все контейнера
    CREATE TEMP TABLE tmpContainerAll ON COMMIT DROP AS
    SELECT Container.Id
         , Container.ObjectId
         , Container.Amount
         , COALESCE (MI_Income_find.Id,MI_Income.Id) AS MI_IncomeId
    FROM Container

         LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                       ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                      AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
         LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
         -- элемент прихода
         LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
         -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
         LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                     ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                    AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
         -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                              -- AND 1=0
    WHERE Container.DescId        = zc_Container_Count()
      AND Container.Amount        <> 0
      AND Container.WhereObjectId IN (SELECT tmp.Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp)
    ;
                       
    ANALYSE tmpContainerAll;
    
    -- Все сроковые контейнкра со сроком
    CREATE TEMP TABLE tmpContainerPD ON COMMIT DROP AS
    SELECT Container.ParentId
         , sum(Container.Amount)::TFloat                       AS Amount
         , min(COALESCE (ObjectDate_ExpirationDate.ValueData, 
                         zc_DateEnd()))::TDateTime              AS ExpirationDate
    FROM Container
  
         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.ID
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                              ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                             
    WHERE Container.DescId        = zc_Container_CountPartionDate()
      AND Container.Amount        <> 0
      AND Container.WhereObjectId IN (SELECT tmp.Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp)
    GROUP BY Container.ParentId;
                       
    ANALYSE tmpContainerPD;
    
    -- Остатки со сроком приходов
    CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
    SELECT Container.ObjectId
         , sum(Container.Amount)::TFloat                        AS Amount
         , sum(tmpContainerPD.Amount)::TFloat                   AS AmountPD
         , min(COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()))::TDateTime              AS ExpirationDate
         , min(COALESCE (tmpContainerPD.ExpirationDate, zc_DateEnd()))::TDateTime                AS ExpirationDatePD
    FROM tmpContainerAll AS Container
    
         LEFT OUTER JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.MI_IncomeId

         LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                          ON MIDate_ExpirationDate.MovementItemId = Container.MI_IncomeId
                                         AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

    GROUP BY Container.ObjectId;
    
    CREATE TEMP TABLE tmpMIContainer ON COMMIT DROP AS
    SELECT MovementItemContainer.ObjectId_Analyzer        AS ObjectId
         , sum(- MovementItemContainer.Amount)::TFloat    AS Amount
    FROM MovementItemContainer
    WHERE MovementItemContainer.DescId         = zc_MIContainer_Count()
      AND MovementItemContainer.MovementDescId = zc_Movement_Check()
      AND MovementItemContainer.Amount         <> 0
      AND MovementItemContainer.WhereObjectId_Analyzer IN (SELECT tmp.Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp)
      AND MovementItemContainer.OperDate >= CURRENT_DATE - INTERVAL '30 DAY'
    GROUP BY MovementItemContainer.ObjectId_Analyzer;
                       
    ANALYSE tmpMIContainer;    
    
    RETURN QUERY
    SELECT Object_Goods_Retail.id
         , Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name

         , tmpContainer.Amount
         , tmpMIContainer.Amount
         
         , COALESCE (CASE WHEN tmpContainer.Amount > COALESCE(tmpContainer.AmountPD, 0) AND tmpContainer.ExpirationDate < tmpContainer.ExpirationDatePD
                          THEN tmpContainer.ExpirationDate END, 
                     tmpContainer.ExpirationDatePD)::TDateTime              AS ExpirationDate
         
         , Object_Goods_Main.isClose
         
         , False AS isSelect
         
    FROM tmpContainer
    
         INNER JOIN tmpMIContainer ON tmpMIContainer.ObjectId = tmpContainer.ObjectId

         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpContainer.ObjectId
         INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
         
    WHERE tmpContainer.Amount < COALESCE(tmpMIContainer.Amount * 2, 0)
      AND Object_Goods_Main.isClose = False
       OR tmpContainer.Amount >= COALESCE(tmpMIContainer.Amount * 2, 0)
      AND Object_Goods_Main.isClose = True

    ORDER BY Object_Goods_Main.ObjectCode
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_Data (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.09.23                                                       *
*/

-- тест
--

SELECT * FROM gpReport_GoodsToClose ('3')
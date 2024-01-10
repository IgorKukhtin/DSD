-- Function: gpSelect_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loss(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat 
             , Remains_Amount TFloat, AmountCheck TFloat
             , PriceIn TFloat, SummIn TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDateEnd TDateTime;
  DECLARE vbCat_5 TFloat;
  DECLARE vbisCat_5 boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
    vbUserId:= lpGetUserBySession (inSession);
     
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    --Определили подразделение для розничной цены и дату для остатка
    SELECT 
           MovementLinkObject_Unit.ObjectId
         , Movement_Loss.OperDate 
         , MovementLinkObject_ArticleLoss.ObjectId = 23653195
    INTO 
         vbUnitId
       , vbOperDate
       , vbisCat_5
    FROM Movement AS Movement_Loss
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement_Loss.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                     ON MovementLinkObject_ArticleLoss.MovementId = Movement_Loss.Id
                                    AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
    WHERE Movement_Loss.Id = inMovementId;
    
    vbOperDateEnd :=  DATE_TRUNC('day',vbOperDate) + INTERVAL '1 DAY';

    SELECT COALESCE(ObjectFloat_CashSettings_Cat_5.ValueData, 0)                                 AS Cat_5
    INTO vbCat_5
    FROM Object AS Object_CashSettings

         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Cat_5
                               ON ObjectFloat_CashSettings_Cat_5.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Cat_5.DescId = zc_ObjectFloat_CashSettings_Cat_5()

    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;    
        
    raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    
    IF inShowAll THEN
    -- Результат
        RETURN QUERY
        WITH 
        tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId                 AS Id
                          , Object_Goods.ObjectCode                          AS GoodsCodeInt
                          , Object_Goods.ValueData                           AS GoodsName
                          , Object_Goods.isErased                            AS isErased
                      FROM ObjectLink AS ObjectLink_Goods_Object
                           LEFT JOIN Object AS Object_Goods 
                                            ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
               
                      WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                        AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                     )


      , tmpListContainer AS (SELECT Container.*
                             FROM tmpGoods
                                  INNER JOIN Container ON Container.ObjectId = tmpGoods.Id
                                                      AND Container.DescID = zc_Container_Count()
                                                      AND Container.WhereObjectId = vbUnitId
                                                      AND Container.Amount <> 0
                            )
      --
      , tmpCLI_MI AS (SELECT CLI_MI.*
                      FROM ContainerlinkObject AS CLI_MI 
                      WHERE CLI_MI.ContainerId  IN (SELECT DISTINCT tmpListContainer.Id FROM tmpListContainer)    
                        AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()                                                          
                      )
      , tmpPartionMI AS (SELECT tmpCLI_MI.ContainerId
                              , Object_PartionMovementItem.ObjectCode ::integer
                         FROM tmpCLI_MI
                              LEFT JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = tmpCLI_MI.ObjectId 
                         )
      , tmpMIFloat AS (SELECT tmpPartionMI.ContainerId
                            , MIFloat_Income_Price.Valuedata
                       FROM tmpPartionMI
                            LEFT JOIN MovementitemFloat AS MIFloat_Income_Price
                                                        ON MIFloat_Income_Price.MovementItemId = tmpPartionMI.ObjectCode
                                                       AND MIFloat_Income_Price.DescId = zc_MIFloat_PriceWithVAT() 
                       )
      --
      , tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                 , MovementItemContainer.Amount 
                            FROM MovementItemContainer 
                            WHERE MovementItemContainer.ContainerId IN (SELECT DISTINCT tmpListContainer.Id FROM tmpListContainer)
                              AND MovementItemContainer.Operdate >= vbOperDateEnd
                           )
                                
      , REMAINS AS ( --остатки на дату документа
                    SELECT T0.ObjectId
                         , SUM(T0.Amount)  ::TFloat AS Amount
                         , SUM(T0.Summ)    ::TFloat AS Summ
                         , CASE WHEN SUM(T0.Amount) <> 0 THEN SUM(T0.Summ) / SUM(T0.Amount) END  AS Price
                    FROM (SELECT Container.Id 
                               , Container.ObjectId --Товар
                               , (Container.Amount - SUM (COALESCE(MovementItemContainer.amount, 0 )) ) ::TFloat AS Amount  --Тек. остаток - Движение после даты переучета
                               , (Container.Amount * COALESCE(MIFloat_Income_Price.ValueData,0) - SUM (COALESCE(MovementItemContainer.amount, 0 ) * COALESCE(MIFloat_Income_Price.ValueData, 0) ) )::TFloat AS Summ  --Тек. остаток - Движение после даты переучета
                          FROM tmpListContainer AS Container
                               LEFT JOIN tmpMIFloat AS MIFloat_Income_Price ON MIFloat_Income_Price.ContainerId = Container.Id
                               LEFT JOIN tmpMIContainer AS MovementItemContainer ON  MovementItemContainer.ContainerId = Container.Id
                          GROUP BY Container.Id 
                                 , Container.ObjectId
                                 , Container.Amount
                                 , MIFloat_Income_Price.ValueData
                          HAVING Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0) <> 0
                          ) AS T0
                    GROUP BY ObjectId
                    HAVING SUM(T0.Amount) <> 0
                   )
                   
      , CurrPRICE AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                            , CASE WHEN vbisCat_5 = TRUE
                                   THEN COALESCE (ObjectHistoryFloat_Price.ValueData * (100 - vbCat_5) / 100, 0)
                                   ELSE COALESCE (ObjectHistoryFloat_Price.ValueData, 0) END :: TFloat  AS Price
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectLink AS Price_Goods
                                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                            -- получаем значения цены и НТЗ из истории значений на начало дня
                            LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                    ON ObjectHistory_Price.ObjectId = Price_Goods.ObjectId
                                                   AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                   AND vbOperDate >= ObjectHistory_Price.StartDate AND vbOperDate < ObjectHistory_Price.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                       WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                     )
      , MIContainer AS (SELECT MovementItemContainer.MovementItemId
                             , CASE WHEN SUM(-MovementItemContainer.Amount) <> 0 
                                    THEN SUM(-MovementItemContainer.Amount * MIFloat_Income_Price.ValueData) / SUM(-MovementItemContainer.Amount)
                               END::TFloat AS Price
                        FROM MovementItemContainer 
                            LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                ON CLI_MI.containerid = MovementItemContainer.ContainerId
                                                               AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                            -- элемент прихода
                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                            LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                              ON MIFloat_Income_Price.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) 
                                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_PriceWithVAT()
                        WHERE MovementItemContainer.MovementId = inMovementId
                          AND MovementItemContainer.DescId = zc_MIContainer_Count()
                        GROUP BY MovementItemContainer.MovementItemId
                        )

      , tmpCheck AS (SELECT MI_Check.ObjectId               AS GoodsId
                          , SUM (MI_Check.Amount) ::TFloat  AS Amount
                     FROM Movement AS Movement_Check
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN MovementItem AS MI_Check
                                                    ON MI_Check.MovementId = Movement_Check.Id
                                                   AND MI_Check.DescId = zc_MI_Master()
                                                   AND MI_Check.isErased = FALSE
                     WHERE /*Movement_Check.OperDate >= vbOperDate AND Movement_Check.OperDate < vbOperDateEnd
                       AND */Movement_Check.DescId = zc_Movement_Check()
                       AND Movement_Check.StatusId = zc_Enum_Status_UnComplete()
                     GROUP BY MI_Check.ObjectId 
                     HAVING SUM (MI_Check.Amount) <> 0 
                    )
      , tmpMI AS (SELECT MovementItem.Id
                       , MovementItem.ObjectId
                       , MovementItem.Amount
                       , MovementItem.IsErased
                       , MIFloat_Price.ValueData  AS Price
                       , NULLIF(MIFloat_PriceIn.ValueData, 0)  AS PriceIn
                  FROM MovementItem
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()          
                       LEFT JOIN MovementItemFloat AS MIFloat_PriceIn
                                                   ON MIFloat_PriceIn.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PriceIn.DescId = zc_MIFloat_PriceIn()          
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                  )

            -- результат
            SELECT COALESCE(MovementItem.Id,0)           AS Id
                 , tmpGoods.Id                           AS GoodsId
                 , tmpGoods.GoodsCodeInt                 AS GoodsCode
                 , tmpGoods.GoodsName                    AS GoodsName
                 , MovementItem.Amount                   AS Amount
                 , COALESCE(MovementItem.Price, CurrPRICE.Price)                           AS Price
                 , (MovementItem.Amount * 
                          COALESCE(MovementItem.Price, CurrPRICE.Price))::TFloat      AS Summ
                 , REMAINS.Amount                                                          AS Remains_Amount 
                 , tmpCheck.Amount::TFloat                                                 AS AmountCheck
                 , COALESCE(MovementItem.PriceIn, MIContainer.Price, 0)::TFloat                                  AS PriceIn
                 , (MovementItem.Amount*COALESCE(MovementItem.PriceIn, MIContainer.Price, 0))::TFloat            AS SummIn
                 , COALESCE(MovementItem.IsErased,FALSE) AS isErased
            FROM tmpGoods
                LEFT JOIN tmpMI AS MovementItem 
                                ON tmpGoods.Id = MovementItem.ObjectId 
                LEFT OUTER JOIN CurrPRICE ON CurrPRICE.GoodsId = tmpGoods.Id
                LEFT OUTER JOIN REMAINS ON REMAINS.ObjectId = tmpGoods.Id 
                LEFT OUTER JOIN MIContainer ON MIContainer.MovementItemId = MovementItem.Id
                LEFT JOIN tmpCheck ON tmpCheck.GoodsId = tmpGoods.Id
            WHERE (tmpGoods.isErased = FALSE OR MovementItem.Id IS NOT NULL);
     ELSE

       -- Результат
       RETURN QUERY
        WITH
        tmpMI AS (SELECT MovementItem.Id
                       , MovementItem.ObjectId
                       , MovementItem.Amount
                       , MovementItem.IsErased
                       , MIFloat_Price.ValueData  AS Price
                       , NULLIF(MIFloat_PriceIn.ValueData, 0)  AS PriceIn
                  FROM MovementItem
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()          
                       LEFT JOIN MovementItemFloat AS MIFloat_PriceIn
                                                   ON MIFloat_PriceIn.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PriceIn.DescId = zc_MIFloat_PriceIn()          
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                  )
      -- для остатков    
      , tmpListContainer AS (SELECT Container.*
                             FROM tmpMI
                                  INNER JOIN Container ON Container.ObjectId = tmpMI.ObjectId
                                                      AND Container.DescID = zc_Container_Count()
                                                      AND Container.WhereObjectId = vbUnitId
                                                      AND Container.Amount <> 0
                            )
                       
      , tmpCLI_MI AS (SELECT CLI_MI.*
                      FROM ContainerlinkObject AS CLI_MI 
                      WHERE CLI_MI.ContainerId  IN (SELECT DISTINCT tmpListContainer.Id FROM tmpListContainer)    
                        AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()                                                          
                      )
      , tmpPartionMI AS (SELECT tmpCLI_MI.ContainerId
                              , Object_PartionMovementItem.ObjectCode ::integer
                         FROM tmpCLI_MI
                              LEFT JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = tmpCLI_MI.ObjectId 
                         )
      , tmpMIFloat AS (SELECT tmpPartionMI.ContainerId
                            , MIFloat_Income_Price.Valuedata
                       FROM tmpPartionMI
                            LEFT JOIN MovementitemFloat AS MIFloat_Income_Price
                                                        ON MIFloat_Income_Price.MovementItemId = tmpPartionMI.ObjectCode
                                                       AND MIFloat_Income_Price.DescId = zc_MIFloat_PriceWithVAT() 
                       )
--
                       
      , tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                 , MovementItemContainer.Amount 
                            FROM MovementItemContainer 
                            WHERE MovementItemContainer.ContainerId IN (SELECT DISTINCT tmpListContainer.Id FROM tmpListContainer)
                              AND MovementItemContainer.Operdate >= vbOperDateEnd
                           )
                                
      , REMAINS AS ( --остатки на дату документа
                    SELECT T0.ObjectId
                         , SUM(T0.Amount)  ::TFloat AS Amount
                         , SUM(T0.Summ)    ::TFloat AS Summ
                         , CASE WHEN SUM(T0.Amount) <> 0
                               THEN SUM(T0.Summ) / SUM(T0.Amount)
                           END                      AS Price
                    FROM (SELECT Container.Id 
                               , Container.ObjectId --Товар
                               , (Container.Amount - SUM (COALESCE(MovementItemContainer.amount, 0 )) ) ::TFloat AS Amount  --Тек. остаток - Движение после даты переучета
                               , (Container.Amount * COALESCE(MIFloat_Income_Price.ValueData,0) - SUM (COALESCE(MovementItemContainer.amount, 0 ) * COALESCE(MIFloat_Income_Price.ValueData, 0) ) )::TFloat AS Summ  --Тек. остаток - Движение после даты переучета
                          FROM tmpListContainer AS Container
                               LEFT JOIN tmpMIFloat AS MIFloat_Income_Price ON MIFloat_Income_Price.ContainerId = Container.Id
                               LEFT JOIN tmpMIContainer AS MovementItemContainer ON  MovementItemContainer.ContainerId = Container.Id
                          GROUP BY Container.Id 
                                 , Container.ObjectId
                                 , Container.Amount
                                 , MIFloat_Income_Price.ValueData
                          HAVING Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0) <> 0
                          ) AS T0
                    GROUP BY ObjectId
                    HAVING SUM(T0.Amount) <> 0
                   )

      , CurrPRICE AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                            , CASE WHEN vbisCat_5 = TRUE
                                   THEN COALESCE (ObjectHistoryFloat_Price.ValueData * (100 - vbCat_5) / 100, 0)
                                   ELSE COALESCE (ObjectHistoryFloat_Price.ValueData, 0) END :: TFloat  AS Price
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN (SELECT DISTINCT tmpMI.ObjectId AS GoodsId FROM tmpMI) tmpGoods ON 1 = 1
                            INNER JOIN ObjectLink AS Price_Goods
                                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                 AND Price_Goods.ChildObjectId = tmpGoods.GoodsId

                            -- получаем значения цены и НТЗ из истории значений на начало дня
                            LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                    ON ObjectHistory_Price.ObjectId = Price_Goods.ObjectId
                                                   AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                   AND vbOperDate >= ObjectHistory_Price.StartDate AND vbOperDate < ObjectHistory_Price.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                       WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                      )

      , MIContainer AS (SELECT MovementItemContainer.MovementItemId
                             , CASE WHEN SUM(-MovementItemContainer.Amount) <> 0 
                                    THEN SUM(-MovementItemContainer.Amount * MIFloat_Income_Price.ValueData) / SUM(-MovementItemContainer.Amount)
                               END::TFloat AS Price
                        FROM MovementItemContainer 
                            LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                ON CLI_MI.containerid = MovementItemContainer.ContainerId
                                                               AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                            -- элемент прихода
                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                            LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                              ON MIFloat_Income_Price.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) 
                                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_PriceWithVAT()
                        WHERE MovementItemContainer.MovementId = inMovementId
                          AND MovementItemContainer.DescId = zc_MIContainer_Count()
                        GROUP BY MovementItemContainer.MovementItemId
                        )

      , tmpCheck AS (SELECT MI_Check.ObjectId               AS GoodsId
                          , SUM (MI_Check.Amount) ::TFloat  AS Amount
                     FROM Movement AS Movement_Check
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                       AND MovementLinkObject_Unit.ObjectId = vbUnitId
                          INNER JOIN MovementItem AS MI_Check
                                                  ON MI_Check.MovementId = Movement_Check.Id
                                                 AND MI_Check.DescId = zc_MI_Master()
                                                 AND MI_Check.isErased = FALSE
                     WHERE /*Movement_Check.OperDate >= vbOperDate AND Movement_Check.OperDate < vbOperDateEnd
                       AND */Movement_Check.DescId = zc_Movement_Check()
                       AND Movement_Check.StatusId = zc_Enum_Status_UnComplete()
                     GROUP BY MI_Check.ObjectId 
                     HAVING SUM (MI_Check.Amount) <> 0 
                     )

        SELECT MovementItem.Id                                                         AS Id
             , Object_Goods.Id                                                         AS GoodsId
             , Object_Goods.ObjectCode                                                 AS GoodsCode
             , Object_Goods.ValueData                                                  AS GoodsName
             , MovementItem.Amount                                                     AS Amount
             , COALESCE(MovementItem.Price, CurrPRICE.Price)                       ::TFloat AS Price
             , (MovementItem.Amount*COALESCE(MovementItem.Price, CurrPRICE.Price)) ::TFloat AS Summ
             , REMAINS.Amount                                                      ::TFloat AS Remains_Amount
             , tmpCheck.Amount                                                     ::TFloat AS AmountCheck
             , COALESCE(MovementItem.PriceIn, MIContainer.Price, REMAINS.Price)                           ::TFloat AS PriceIn
             , (MovementItem.Amount*COALESCE(MovementItem.PriceIn, MIContainer.Price, REMAINS.Price))     ::TFloat AS SummIn
             , COALESCE(MovementItem.IsErased, FALSE)                                       AS isErased
        FROM tmpMI AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
            LEFT OUTER JOIN CurrPRICE ON CurrPRICE.GoodsId = Object_Goods.Id
            LEFT OUTER JOIN REMAINS ON MovementItem.ObjectId = REMAINS.ObjectId
            LEFT OUTER JOIN MIContainer ON MIContainer.MovementItemId = MovementItem.Id
            LEFT JOIN tmpCheck ON tmpCheck.GoodsId = Object_Goods.Id
;
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.02.20                                                                     *  
 12.09.18         * убрала огр. периода при выборе непров. чеков
 04.12.17         *
 12.06.17         * убрали Object_Price_View
 27.10.16         * 
 31.03.15         * add GoodsGroupNameFull, MeasureName
 17.10.14         * add св-ва PartionGoods
 08.10.14                                        * add Object_InfoMoney_View
 01.09.14                                                       * + PartionGoodsDate
 26.05.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- select * from gpSelect_MovementItem_Loss(inMovementId := 16461309 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');


select * from gpSelect_MovementItem_Loss(inMovementId := 34111475 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
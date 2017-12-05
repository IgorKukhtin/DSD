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
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
    vbUserId:= lpGetUserBySession (inSession);
     
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    --Определили подразделение для розничной цены и дату для остатка
    SELECT 
        MovementLinkObject_Unit.ObjectId
       ,Movement_Loss.OperDate 
    INTO 
        vbUnitId
       ,vbOperDate
    FROM Movement AS Movement_Loss
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement_Loss.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement_Loss.Id = inMovementId;
    
    vbOperDateEnd :=  DATE_TRUNC('day',vbOperDate) + INTERVAL '1 DAY';
    
    
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

      , REMAINS AS ( --остатки на дату документа
                    SELECT 
                        T0.ObjectId
                       ,SUM(T0.Amount)::TFloat AS Amount
                       ,SUM(T0.Summ)::TFloat AS Summ
                       ,CASE WHEN SUM(T0.Amount) <> 0
                            THEN SUM(T0.Summ) / SUM(T0.Amount)
                        END AS Price
                    FROM(
                            SELECT 
                                Container.Id 
                               ,Container.ObjectId --Товар
                               ,(Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0))::TFloat AS Amount  --Тек. остаток - Движение после даты переучета
                               ,(Container.Amount * COALESCE(MIFloat_Income_Price.ValueData,0) - COALESCE(SUM(MovementItemContainer.amount * COALESCE(MIFloat_Income_Price.ValueData,0)),0.0))::TFloat AS Summ  --Тек. остаток - Движение после даты переучета
                            FROM Container
                                INNER JOIN tmpGoods ON tmpGoods.Id = Container.ObjectId
                                LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                     AND 
                                                                     (  MovementItemContainer.Operdate >= vbOperDateEnd
                                                                       -- date_trunc('day', MovementItemContainer.Operdate) > vbOperDate
                                                                        --OR
                                                                      --  MovementItemContainer.MovementId = inMovementId
                                                                     )
                                LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                                    ON CLI_MI.containerid = Container.Id
                                                                   AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                  ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                 AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                            WHERE Container.DescID = zc_Container_Count()
                              AND Container.WhereObjectId = vbUnitId
                            GROUP BY Container.Id 
                                   , Container.ObjectId
                                   , Container.Amount
                                   , MIFloat_Income_Price.ValueData
                            HAVING Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0) <> 0
                        ) AS T0
                    GROUP By ObjectId
                    HAVING SUM(T0.Amount) <> 0
                    )

      , CurrPRICE AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                           , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                      FROM ObjectLink AS ObjectLink_Price_Unit
                         LEFT JOIN ObjectLink AS Price_Goods
                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                         LEFT JOIN ObjectFloat AS Price_Value
                                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                               AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
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
                             LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                   ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                  AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                        WHERE MovementItemContainer.MovementId = inMovementId
                          AND MovementItemContainer.DescId = zc_MIContainer_Count()
                        GROUP BY MovementItemContainer.MovementItemId
                       )

      , tmpCheck AS (SELECT MI_Check.ObjectId                    AS GoodsId
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
                     WHERE Movement_Check.OperDate >= vbOperDate AND Movement_Check.OperDate < vbOperDateEnd
                       AND Movement_Check.DescId = zc_Movement_Check()
                       AND Movement_Check.StatusId = zc_Enum_Status_UnComplete()
                     GROUP BY MI_Check.ObjectId 
                     HAVING SUM (MI_Check.Amount) <> 0 
                    )

            -- результат
            SELECT COALESCE(MovementItem.Id,0)           AS Id
                 , tmpGoods.Id                           AS GoodsId
                 , tmpGoods.GoodsCodeInt                 AS GoodsCode
                 , tmpGoods.GoodsName                    AS GoodsName
                 , MovementItem.Amount                   AS Amount
                 , CurrPRICE.Price                       AS Price
                 , (MovementItem.Amount*CurrPRICE.Price)::TFloat                           AS Summ
                 , REMAINS.Amount                                                          AS Remains_Amount 
                 , tmpCheck.Amount::TFloat                                                 AS AmountCheck
                 , COALESCE(MIContainer.Price,REMAINS.Price)::TFloat                       AS PriceIn
                 , (MovementItem.Amount*COALESCE(MIContainer.Price,REMAINS.Price))::TFloat AS SummIn
                 , COALESCE(MovementItem.IsErased,FALSE) AS isErased
            FROM tmpGoods
                LEFT JOIN MovementItem ON tmpGoods.Id = MovementItem.ObjectId 
                                       AND MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId = zc_MI_Master()
                                       AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
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
                  FROM MovementItem
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
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
                            LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                                  ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                                 AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                        WHERE MovementItemContainer.MovementId = inMovementId
                          AND MovementItemContainer.DescId = zc_MIContainer_Count()
                        GROUP BY MovementItemContainer.MovementItemId
                        )

      , tmpListContainer AS (SELECT Container.*
                             FROM tmpMI
                                  INNER JOIN Container ON Container.ObjectId = tmpMI.ObjectId
                                                      AND Container.DescID = zc_Container_Count()
                                                      AND Container.WhereObjectId = vbUnitId
                                                      AND Container.Amount <> 0
                            )
      , tmpMIFloat AS (SELECT tmpListContainer.Id            AS Containerid
                            , MIFloat_Income_Price.ValueData
                       FROM tmpListContainer
                            LEFT JOIN containerlinkobject AS CLI_MI 
                                                          ON CLI_MI.containerid = tmpListContainer.Id
                                                         AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                                                      
                            LEFT JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId 
                            LEFT JOIN MovementitemFloat AS MIFloat_Income_Price
                                                              ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 
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
                               LEFT JOIN tmpMIFloat AS MIFloat_Income_Price ON MIFloat_Income_Price.Containerid = Container.Id
                               LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                    AND 
                                                                    (--date_trunc('day', MovementItemContainer.Operdate) > vbOperDate
                                                                       MovementItemContainer.Operdate >= vbOperDateEnd
                                                                       --OR
                                                                      -- MovementItemContainer.MovementId = inMovementId
                                                                    )
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
                           , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                      FROM tmpMI
                         INNER JOIN ObjectLink AS Price_Goods
                                               ON Price_Goods.ChildObjectId = tmpMI.ObjectId
                                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                         INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                               ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                                              AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                              AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                         LEFT JOIN ObjectFloat AS Price_Value
                                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
             
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
                     WHERE Movement_Check.OperDate >= vbOperDate AND Movement_Check.OperDate < vbOperDateEnd
                       AND Movement_Check.DescId = zc_Movement_Check()
                       AND Movement_Check.StatusId = zc_Enum_Status_UnComplete()
                     GROUP BY MI_Check.ObjectId 
                     HAVING SUM (MI_Check.Amount) <> 0 
                     )

        SELECT MovementItem.Id                                                         AS Id
             , Object_Goods.Id                                                         AS GoodsId
             , Object_Goods.ObjectCode                                                 AS GoodsCode
             , Object_Goods.ValueData                                                  AS GoodsName
             , MovementItem.Amount                                                     AS Amount
             , CurrPRICE.Price                                                         AS Price
             , (MovementItem.Amount*CurrPRICE.Price)                          ::TFloat AS Summ
             , REMAINS.Amount                                                 ::TFloat AS Remains_Amount
             , tmpCheck.Amount                                                ::TFloat AS AmountCheck
             , COALESCE(MIContainer.Price,REMAINS.Price)                      ::TFloat AS PriceIn
             , (MovementItem.Amount*COALESCE(MIContainer.Price,REMAINS.Price))::TFloat AS SummIn
             , COALESCE(MovementItem.IsErased, FALSE)                                  AS isErased
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
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
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')

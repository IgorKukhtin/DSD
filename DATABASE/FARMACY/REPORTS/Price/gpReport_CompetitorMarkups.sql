-- Function: gpReport_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpReport_CompetitorMarkups (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CompetitorMarkups(
    IN inOperDate    TDateTime , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbMovementId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbInvNumber TVarChar;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE curCompetitor refcursor;
    DECLARE vbQueryText Text;
    DECLARE vbId Integer;
    DECLARE vbCompetitorId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    
    WITH
      tmpMovement AS (SELECT Movement.Id                              AS ID
                           , Movement.InvNumber                       AS InvNumber
                           , Movement.OperDate                        AS OperDate
                           , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                      FROM Movement
                      WHERE Movement.OperDate <= inOperDate
                        AND Movement.DescId = zc_Movement_CompetitorMarkups()
                        --AND Movement.StatusId = zc_Enum_Status_Complete()
                      )
    
    SELECT Movement.Id, Movement.InvNumber, Movement.OperDate 
    INTO vbMovementId, vbInvNumber, vbOperDate 
    FROM tmpMovement AS Movement 
    WHERE Movement.Ord = 1;

    -- Перечень конкурентов
    CREATE TEMP TABLE _tmpCompetitor ON COMMIT DROP AS (
      WITH
      tmpCompetitor AS (SELECT DISTINCT MovementItem.ObjectId     AS CompetitorId
                        FROM MovementItem 
                        WHERE MovementItem.MovementId = vbMovementId
                          AND MovementItem.DescId     = zc_MI_Child()
                          AND MovementItem.isErased  = false)
                          
      SELECT ROW_NUMBER() OVER(ORDER BY Object_Competitor.ValueData) as ID
           , tmpCompetitor.CompetitorId
           , Object_Competitor.ObjectCode          AS CompetitorCode
           , Object_Competitor.ValueData           AS CompetitorName
      FROM tmpCompetitor
      
           INNER JOIN Object AS Object_Competitor
                             ON Object_Competitor.Id = tmpCompetitor.CompetitorId
      );


        CREATE TEMP TABLE _tmpGoods ON COMMIT DROP AS (
            WITH tmpPriceSubgroups AS (select * from gpSelect_MovementItem_PriceSubgroups(inMovementId := vbMovementId , inIsErased := 'False' ,  inSession := inSession)),
                 tmpMarginCategoryItem AS (SELECT DISTINCT
                                                  Object_MarginCategoryItem_View.MarginPercent,
                                                  Object_MarginCategoryItem_View.MinPrice,
                                                  Object_MarginCategoryItem_View.MarginCategoryId,
                                                  ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
                                           FROM Object_MarginCategoryItem_View
                                                INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                                              AND Object_MarginCategoryItem.isErased = FALSE
                                           WHERE Object_MarginCategoryItem_View.MarginCategoryId = 4194130 
                                        ),
                 tmpMarginCondition AS (SELECT D1.MarginCategoryId,
                                               D1.MarginPercent,
                                               D1.MinPrice * (100 + D1.MarginPercent) / 100 AS MinPrice,
                                               COALESCE(D2.MinPrice, 1000000) * (100 + D1.MarginPercent) / 100 AS MaxPrice
                                        FROM tmpMarginCategoryItem AS D1
                                             LEFT OUTER JOIN tmpMarginCategoryItem AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
                                        ),
                 tmpMovementItem AS (SELECT MovementItem.Id
                                          , MovementItem.ObjectId
                                          , MovementItem.isErased 
                                     FROM  MovementItem
                                     WHERE MovementItem.MovementId = vbMovementId
                                       AND MovementItem.DescId = zc_MI_Master()
                                       AND MovementItem.isErased = FALSE
                                     ),
                 tmpContainer AS (SELECT Container.Id
                                       , Container.ObjectId 
                                       , Container.WhereObjectId 
                                       , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS Remains
                                  FROM Container
                                  
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container.Id
                                                                      AND MIContainer.OperDate    >= vbOperDate
                                                                      
                                  WHERE Container.ObjectId in (SELECT DISTINCT tmpMovementItem.ObjectId FROM tmpMovementItem)
                                    AND Container.DescId        = zc_Container_Count()
                                  GROUP BY Container.Id
                                         , Container.ObjectId
                                         , Container.WhereObjectId 
                                         , Container.Amount
                                  HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                 ),
                 tmpRemains AS (SELECT Container.ObjectId 
                                     , Container.WhereObjectId 
                                FROM  tmpContainer AS Container
                                GROUP BY Container.ObjectId
                                       , Container.WhereObjectId 
                                HAVING SUM(Container.Remains) > 0
                                ),
                 tmpPrice AS (SELECT Container.ObjectId 
                                   , MIN(COALESCE (ObjectHistoryFloat_Price.ValueData, 0))  AS PriceMin
                                   , MAX(COALESCE (ObjectHistoryFloat_Price.ValueData, 0))  AS PriceMax
                              FROM tmpRemains AS Container
                              
                                   INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                         ON ObjectLink_Price_Goods.ChildObjectId = Container.ObjectId 
                                                        AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                         ON ObjectLink_Price_Unit.ChildObjectId = Container.WhereObjectId 
                                                        AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                        AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                        
                                   -- получаем значения цены и НТЗ из истории значений на начало дня                                                          
                                   LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                           ON ObjectHistory_Price.ObjectId = ObjectLink_Price_Goods.ObjectId 
                                                          AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                          AND vbOperDate >= ObjectHistory_Price.StartDate AND vbOperDate < ObjectHistory_Price.EndDate
                                   LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                                ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                               AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                              GROUP BY Container.ObjectId 
                              )  
                                                
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS GoodsID
                 
                 , Object_Goods_Main.ObjectCode       AS GoodsCode
                 , Object_Goods_Main.Name             AS GoodsName
                 
                 , Object_Groups.ValueData            AS GroupsName
                 , tmpPriceSubgroups.PriceMax         AS SubGroupsPriceMax
                 , tmpPriceSubgroups.Name             AS SubGroupsName 

                 , MIFloat_Price.ValueData            AS Price
                 
                 , tmpPrice.PriceMin                  AS PriceUnitMin
                 , tmpPrice.PriceMax                  AS PriceUnitMax
                 
                 , MarginConditionMin.MarginPercent   AS MarginPercentMin
                 , ROUND(tmpPrice.PriceMin * 100 / (100 + MarginConditionMin.MarginPercent), 2)::TFloat AS JuridicalPriceMin
                 
                 , MarginConditionMax.MarginPercent   AS MarginPercentMax
                 , ROUND(tmpPrice.PriceMax * 100 / (100 + MarginConditionMax.MarginPercent), 2)::TFloat AS JuridicalPriceMax

                 , MovementItem.isErased              AS isErased
                 
                 , 0::Integer                         AS TypeId0
                 , 0::TFloat                          AS Value0
            FROM  tmpMovementItem AS MovementItem

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                  LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                  
                  LEFT JOIN Object AS Object_Groups ON Object_Groups.Id = Object_Goods_Main.GoodsGroupId
                  
                  LEFT JOIN tmpPrice ON tmpPrice.ObjectId = MovementItem.ObjectId
                  
                  LEFT JOIN tmpPriceSubgroups ON tmpPriceSubgroups.PriceMin <= MIFloat_Price.ValueData
                                             AND tmpPriceSubgroups.PriceMax > MIFloat_Price.ValueData
                                                                    
                  LEFT JOIN tmpMarginCondition AS MarginConditionMin
                                               ON MarginConditionMin.MinPrice <= tmpPrice.PriceMin
                                              AND MarginConditionMin.MaxPrice > tmpPrice.PriceMin
              
                  LEFT JOIN tmpMarginCondition AS MarginConditionMax
                                               ON MarginConditionMax.MinPrice <= tmpPrice.PriceMax
                                              AND MarginConditionMax.MaxPrice > tmpPrice.PriceMax
            );
     
      -- Заполняем цены по конкурентам

    OPEN curCompetitor FOR SELECT tmpCompetitor.Id
                                , tmpCompetitor.CompetitorId
                           FROM _tmpCompetitor AS tmpCompetitor
                           ORDER BY tmpCompetitor.Id;
       
    LOOP
        FETCH curCompetitor INTO vbID, vbCompetitorId;
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE _tmpGoods ADD COLUMN Id' || COALESCE (vbID, 0)::Text || ' Integer ' ||
                                          ' , ADD COLUMN TypeId' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT ' || vbCompetitorId::Text ||
                                          ' , ADD COLUMN Prece' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN MarginPercentDeltaMin' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN PreceNull' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN MarginPercentDeltaMax' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0' ||
                                          ' , ADD COLUMN ColorMin' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT ' || zc_Color_White()::Text ||
                                          ' , ADD COLUMN ColorMax' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT ' || zc_Color_White()::Text;
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE _tmpGoods set ID' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Id, 0)' ||
          ' , Prece' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Price, 0)' ||
          ' , MarginPercentDeltaMin' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMin * 100 - 100 - _tmpGoods.MarginPercentMin, 0)' ||
          ' , MarginPercentDeltaMax' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMax * 100 - 100 - _tmpGoods.MarginPercentMax, 0)' ||
          ' , ColorMin' || COALESCE (vbID, 0)::Text || ' = CASE WHEN COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMin * 100 - 100 - _tmpGoods.MarginPercentMin, 0) > 0
                                                                THEN zfCalc_Color (173, 255, 47)
                                                                WHEN COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMin * 100 - 100 - _tmpGoods.MarginPercentMin, 0) < 0
                                                                THEN zc_Color_Yelow()
                                                                ELSE zc_Color_White() END
                                                                  ' ||
          ' , ColorMax' || COALESCE (vbID, 0)::Text || ' = CASE WHEN COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMax * 100 - 100 - _tmpGoods.MarginPercentMax, 0) > 0
                                                                THEN zfCalc_Color (173, 255, 47)
                                                                WHEN COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMax * 100 - 100 - _tmpGoods.MarginPercentMax, 0) < 0
                                                                THEN zc_Color_Yelow()
                                                                ELSE zc_Color_White() END' ||
          ' FROM (SELECT MovementItem.Id 
                       , MovementItem.ParentId 
                       , MovementItem.Amount    AS Price 
                  FROM MovementItem 
                  WHERE MovementItem.MovementId = '|| vbMovementId::Text ||'
                    AND MovementItem.ObjectId = '|| vbCompetitorId::Text ||'
                    AND MovementItem.DescId     = zc_MI_Child()
                    AND MovementItem.isErased  = false) AS T1
           WHERE _tmpGoods.Id = T1.ParentId';
        EXECUTE vbQueryText;

    END LOOP;
    CLOSE curCompetitor;        
     
    OPEN Cursor1 FOR
       SELECT tmpCompetitor.Id
            , tmpCompetitor.CompetitorId
            , tmpCompetitor.CompetitorCode
            , tmpCompetitor.CompetitorName
            , 'Цена'::TVarChar AS PriceName
            , ' '::TVarChar AS PriceNilName
            , 'Разн. нац.'::TVarChar AS MarginPercentDeltaMinName
            , 'Разн. нац.'::TVarChar AS MarginPercentDeltaMaxName
            
       FROM _tmpCompetitor AS tmpCompetitor
       ORDER BY tmpCompetitor.Id;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
       SELECT *            
       FROM _tmpGoods AS tmpGoods
       ORDER BY tmpGoods.SubGroupsPriceMax, tmpGoods.GoodsName;

    RETURN NEXT Cursor2;

     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.05.22                                                        *
*/
-- 
select * from gpReport_CompetitorMarkups(inOperDate := CURRENT_DATE, inSession := '3');
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
    DECLARE vbMovementPrevId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbInvNumber TVarChar;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
    DECLARE Cursor4 refcursor;
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
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      )
    
    SELECT Movement.Id, Movement.InvNumber, Movement.OperDate 
    INTO vbMovementId, vbInvNumber, vbOperDate 
    FROM tmpMovement AS Movement 
    WHERE Movement.Ord = 1;

    WITH
      tmpMovement AS (SELECT Movement.Id                              AS ID
                           , Movement.InvNumber                       AS InvNumber
                           , Movement.OperDate                        AS OperDate
                           , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                      FROM Movement
                      WHERE Movement.OperDate <= inOperDate
                        AND Movement.DescId = zc_Movement_CompetitorMarkups()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.Id <> vbMovementId
                      )
    
    SELECT Movement.Id
    INTO vbMovementPrevId
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
                                               D1.MinPrice                     AS MinPrice,
                                               COALESCE(D2.MinPrice, 1000000)  AS MaxPrice
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
                              ),  
                 tmpLastPriceList AS (SELECT * 
                                      FROM LastPriceList_View
                                      WHERE LastPriceList_View.ContractId IN (183257, 183378, 183358)
                                        AND AreaId = 5803492
                                      ),
                 tmpLastPriceListItem AS (SELECT Object_Goods.Id  AS GoodsId
                                               , MIN(MIFloat_Price.ValueData * (100 + ObjectFloat_NDSKind_NDS.ValueData) / 100)::TFloat  AS Price 
                                          FROM tmpLastPriceList
                                           
                                               INNER JOIN MovementItem AS PriceList 
                                                                       ON PriceList.MovementId = tmpLastPriceList.MovementId
                                                                      AND PriceList.DescId     = zc_MI_Master()
                                                                      AND PriceList.isErased = False 
                                               INNER JOIN Object_Goods_Main AS Object_Goods_Main
                                                                            ON Object_Goods_Main.Id = PriceList.ObjectId
                                               INNER JOIN Object_Goods_Retail AS Object_Goods
                                                                              ON Object_Goods.GoodsMainId = PriceList.ObjectId
                                                                             AND Object_Goods.RetailId = 4
                                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                           ON MIFloat_Price.MovementItemId =  PriceList.Id
                                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                          ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                                                         AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                               LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                                     ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                                                    AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                          WHERE COALESCE(MIFloat_Price.ValueData, 0) > 0
                                            AND COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) > CURRENT_DATE + INTERVAL '200 DAY'  
                                          GROUP BY Object_Goods.Id
                                          ),
                 tmpLastPriceList3 AS (SELECT *
                                       FROM LastPriceList_View
                                       WHERE LastPriceList_View.ContractId IN (183257, 183378, 183358)
                                         AND AreaId in (5803492, 5959067)
                                       ),
                 tmpLastPriceListItem3 AS (SELECT Object_Goods.Id  AS GoodsId
                                                , MIN(MIFloat_Price.ValueData * (100 + ObjectFloat_NDSKind_NDS.ValueData) / 100)::TFloat  AS Price
                                           FROM tmpLastPriceList3 AS tmpLastPriceList

                                                INNER JOIN MovementItem AS PriceList
                                                                        ON PriceList.MovementId = tmpLastPriceList.MovementId
                                                                       AND PriceList.DescId     = zc_MI_Master()
                                                                       AND PriceList.isErased = False
                                                INNER JOIN Object_Goods_Main AS Object_Goods_Main
                                                                             ON Object_Goods_Main.Id = PriceList.ObjectId
                                                INNER JOIN Object_Goods_Retail AS Object_Goods
                                                                               ON Object_Goods.GoodsMainId = PriceList.ObjectId
                                                                              AND Object_Goods.RetailId = 4
                                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                            ON MIFloat_Price.MovementItemId =  PriceList.Id
                                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                           ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                                                          AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                           WHERE COALESCE(MIFloat_Price.ValueData, 0) > 0
                                             AND COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) > CURRENT_DATE + INTERVAL '200 DAY'
                                           GROUP BY Object_Goods.Id
                                           ),
                 tmpMovementItemPrev AS (SELECT MovementItem.Id
                                              , MovementItem.ObjectId
                                              , MovementItem.isErased 
                                         FROM  MovementItem
                                         WHERE MovementItem.MovementId = vbMovementPrevId
                                           AND MovementItem.DescId = zc_MI_Master()
                                           AND MovementItem.isErased = FALSE
                                         )
                                                
            SELECT MovementItem.Id                    AS Id
                 , tmpMovementItemPrev.Id             AS PrevId
                 , MovementItem.ObjectId              AS GoodsID
                 
                 , Object_Goods_Main.ObjectCode       AS GoodsCode
                 , Object_Goods_Main.Name             AS GoodsName
                 
                 , Object_Groups.ValueData            AS GroupsName
                 , tmpPriceSubgroups.PriceMax         AS SubGroupsPriceMax
                 , tmpPriceSubgroups.Name             AS SubGroupsName 

                 , MIFloat_Price.ValueData            AS Price
                 
                 , tmpPrice.PriceMin                  AS PriceUnitMin
                 , tmpPrice.PriceMax                  AS PriceUnitMax
                 
                 , CASE WHEN COALESCE (tmpPrice.PriceMax, 0) > 0
                        THEN (1.0 - tmpPrice.PriceMin / tmpPrice.PriceMax) * 100
                        ELSE 0 END::TFloat            AS DPriceUnit
                 , CASE WHEN CASE WHEN COALESCE (tmpPrice.PriceMax, 0) > 0
                                  THEN (1.0 - tmpPrice.PriceMin / tmpPrice.PriceMax) * 100
                                  ELSE 0 END > 3
                        THEN zc_Color_Yelow()
                        ELSE zc_Color_White() END     AS ColorDPriceUnit
                                  
                 , MarginCondition.MarginPercent      AS MarginPercent

                 , ROUND(tmpPrice.PriceMin * 100 / (100 + MarginCondition.MarginPercent), 2)::TFloat AS JuridicalPriceMin
                 
                 , ROUND(tmpPrice.PriceMax * 100 / (100 + MarginCondition.MarginPercent), 2)::TFloat AS JuridicalPriceMax
                 
                 , COALESCE(tmpLastPriceListItem.Price, tmpLastPriceListItem3.Price)::TFloat         AS JuridicalPrice
                 
                 , MovementItem.isErased              AS isErased
                 
                 , 0::Integer                         AS TypeId0
                 , 0::TFloat                          AS Value0
                                  
            FROM  tmpMovementItem AS MovementItem
            
                  LEFT JOIN tmpMovementItemPrev ON tmpMovementItemPrev.ObjectId = MovementItem.ObjectId

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                  LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                  
                  LEFT JOIN Object AS Object_Groups ON Object_Groups.Id = Object_Goods_Main.GoodsGroupId
                  
                  LEFT JOIN tmpPrice ON tmpPrice.ObjectId = MovementItem.ObjectId
                  
                  LEFT JOIN tmpPriceSubgroups ON tmpPriceSubgroups.PriceMin <= MIFloat_Price.ValueData
                                             AND tmpPriceSubgroups.PriceMax > MIFloat_Price.ValueData
                                                                    
                  LEFT JOIN tmpMarginCondition AS MarginCondition
                                               ON MarginCondition.MinPrice <= MIFloat_Price.ValueData
                                              AND MarginCondition.MaxPrice > MIFloat_Price.ValueData

                  LEFT JOIN tmpLastPriceListItem ON tmpLastPriceListItem.GoodsId = MovementItem.ObjectId
                  LEFT JOIN tmpLastPriceListItem3 ON tmpLastPriceListItem3.GoodsId = MovementItem.ObjectId
            );
            
    -- Данные по диапазонам
    CREATE TEMP TABLE _tmpSubGroups ON COMMIT DROP AS
    SELECT _tmpGoods.SubGroupsName
         , _tmpGoods.SubGroupsPriceMax
         , _tmpGoods.MarginPercent  AS MarginPercent
    FROM _tmpGoods
    GROUP BY _tmpGoods.SubGroupsPriceMax, _tmpGoods.SubGroupsName, _tmpGoods.MarginPercent;

     
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
                                          ' , ADD COLUMN Price' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN MarginPercentDeltaMin' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN MarginPercent' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN MarginPercentPrev' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN DPrice' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN MarginPercentSGR' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0'||
                                          ' , ADD COLUMN MarginPercentDeltaMax' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0' ||
                                          ' , ADD COLUMN PrevId' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT 0' ||
                                          ' , ADD COLUMN ColorMin' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT ' || zc_Color_White()::Text ||
                                          ' , ADD COLUMN ColorMax' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT ' || zc_Color_White()::Text;
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE _tmpGoods set ID' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Id, 0)' ||
          ' , Price' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Price, 0)' ||
          ' , MarginPercentDeltaMin' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMin * 100 - 100 - _tmpGoods.MarginPercent, 0)' ||
          ' , MarginPercent' || COALESCE (vbID, 0)::Text || ' = CASE WHEN COALESCE (_tmpGoods.JuridicalPrice, 0) > 0 THEN COALESCE (T1.Price  / _tmpGoods.JuridicalPrice * 100 - 100, 0) ELSE 0 END' ||
          ' , MarginPercentDeltaMax' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMax * 100 - 100 - _tmpGoods.MarginPercent, 0)' ||
          ' , ColorMin' || COALESCE (vbID, 0)::Text || ' = CASE WHEN COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMin * 100 - 100 - _tmpGoods.MarginPercent, 0) > 0
                                                                THEN zfCalc_Color (173, 255, 47)
                                                                WHEN COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMin * 100 - 100 - _tmpGoods.MarginPercent, 0) < 0
                                                                THEN zc_Color_Yelow()
                                                                ELSE zc_Color_White() END
                                                                  ' ||
          ' , ColorMax' || COALESCE (vbID, 0)::Text || ' = CASE WHEN COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMax * 100 - 100 - _tmpGoods.MarginPercent, 0) > 0
                                                                THEN zfCalc_Color (173, 255, 47)
                                                                WHEN COALESCE (T1.Price  / _tmpGoods.JuridicalPriceMax * 100 - 100 - _tmpGoods.MarginPercent, 0) < 0
                                                                THEN zc_Color_Yelow()
                                                                ELSE zc_Color_White() END' ||
          ' , DPrice' || COALESCE (vbID, 0)::Text || ' = CASE WHEN COALESCE (_tmpGoods.Price, 0) <> 0
                                                              THEN COALESCE (T1.Price  / _tmpGoods.PriceUnitMin * 100 - 100, 0) ELSE 0 END' ||
          ' FROM (SELECT MovementItem.Id 
                       , MovementItem.ParentId 
                       , MovementItem.Amount        AS Price 
                  FROM MovementItem 
                  WHERE MovementItem.MovementId = '|| vbMovementId::Text ||'
                    AND MovementItem.ObjectId = '|| vbCompetitorId::Text ||'
                    AND MovementItem.DescId     = zc_MI_Child()
                    AND MovementItem.isErased  = false) AS T1
           WHERE _tmpGoods.Id = T1.ParentId';
        EXECUTE vbQueryText;
        
        IF COALESCE (vbMovementPrevId, 0) > 0
        THEN
          vbQueryText := 'UPDATE _tmpGoods set MarginPercentPrev' || COALESCE (vbID, 0)::Text || ' = CASE WHEN COALESCE (_tmpGoods.JuridicalPrice, 0) > 0 THEN COALESCE (T1.Price  / _tmpGoods.JuridicalPrice * 100 - 100, 0) ELSE 0 END' ||
                                             ' , PrevId' || COALESCE (vbID, 0)::Text || ' = T1.Id'||
            ' FROM (SELECT MovementItem.Id 
                         , MovementItem.ParentId 
                         , MovementItem.Amount        AS Price 
                    FROM MovementItem 
                    WHERE MovementItem.MovementId = '|| vbMovementPrevId::Text ||'
                      AND MovementItem.ObjectId = '|| vbCompetitorId::Text ||'
                      AND MovementItem.DescId     = zc_MI_Child()
                      AND MovementItem.isErased  = false) AS T1
             WHERE _tmpGoods.PrevId = T1.ParentId';
          EXECUTE vbQueryText;        
        END IF;
            
        
        vbQueryText := 'UPDATE _tmpGoods set MarginPercentSGR' || COALESCE (vbID, 0)::Text || ' = T1.MarginPercent
                        FROM (SELECT _tmpGoods.SubGroupsName
                                   , (SUM(_tmpGoods.MarginPercent' || COALESCE (vbID, 0)::Text || ')/ COUNT(*)) :: TFloat AS MarginPercent
                              FROM _tmpGoods
                              WHERE COALESCE (_tmpGoods.JuridicalPrice, 0) > 0
                              GROUP BY _tmpGoods.SubGroupsName) AS T1 
                        WHERE _tmpGoods.SubGroupsName =  T1.SubGroupsName';
        EXECUTE vbQueryText;

        vbQueryText := 'ALTER TABLE _tmpSubGroups ADD COLUMN Id' || COALESCE (vbID, 0)::Text || ' Integer ' ||
                                              ' , ADD COLUMN MarginPercentSGR' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0' ||
                                              ' , ADD COLUMN MarginPercentSGRPrev' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0' ||
                                              ' , ADD COLUMN DMarginPercent' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0' ||
                                              ' , ADD COLUMN DMarginPercentCode' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT 0';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE _tmpSubGroups set MarginPercentSGR' || COALESCE (vbID, 0)::Text || ' = T1.MarginPercent
                        FROM (SELECT _tmpGoods.SubGroupsName
                                   , (SUM(_tmpGoods.MarginPercent' || COALESCE (vbID, 0)::Text || ')/ COUNT(*)) :: TFloat AS MarginPercent
                              FROM _tmpGoods
                              WHERE COALESCE (_tmpGoods.JuridicalPrice, 0) > 0
                              GROUP BY _tmpGoods.SubGroupsName) AS T1 
                        WHERE _tmpSubGroups.SubGroupsName =  T1.SubGroupsName';
        EXECUTE vbQueryText;
        
        IF COALESCE (vbMovementPrevId, 0) > 0
        THEN
          vbQueryText := 'UPDATE _tmpSubGroups set MarginPercentSGRPrev' || COALESCE (vbID, 0)::Text || ' = T1.MarginPercentPrev
                                                 , DMarginPercent' || COALESCE (vbID, 0)::Text || ' = ROUND(MarginPercentSGR' || COALESCE (vbID, 0)::Text || ' - T1.MarginPercentPrev, 2)
                                                 , DMarginPercentCode' || COALESCE (vbID, 0)::Text || ' = CASE WHEN ROUND(MarginPercentSGR' || COALESCE (vbID, 0)::Text || ' - T1.MarginPercentPrev, 2)::TFloat > 0
                                                                                                               THEN 1
                                                                                                               WHEN ROUND(MarginPercentSGR' || COALESCE (vbID, 0)::Text || ' - T1.MarginPercentPrev, 2)::TFloat < 0
                                                                                                               THEN 2
                                                                                                               WHEN ROUND(MarginPercentSGR' || COALESCE (vbID, 0)::Text || ' - T1.MarginPercentPrev, 2)::TFloat = 0 AND T1.MarginPercentPrev > 0
                                                                                                               THEN 3
                                                                                                               ELSE 0 
                                                                                                               END
                          FROM (SELECT _tmpGoods.SubGroupsName
                                     , (SUM(_tmpGoods.MarginPercentPrev' || COALESCE (vbID, 0)::Text || ')/ COUNT(*)) :: TFloat AS MarginPercentPrev
                                FROM _tmpGoods
                                WHERE /*COALESCE (_tmpGoods.PrevId' || COALESCE (vbID, 0)::Text || ', 0) <> 0
                                  AND */ COALESCE (_tmpGoods.JuridicalPrice, 0) > 0
                                GROUP BY _tmpGoods.SubGroupsName) AS T1 
                          WHERE _tmpSubGroups.SubGroupsName =  T1.SubGroupsName';
          EXECUTE vbQueryText;
        END IF;
        
    END LOOP;
    CLOSE curCompetitor;      
    
   /*raise notice 'Value 05: % %', 
    (SELECT SUM(_tmpGoods.MarginPercent3)
     FROM _tmpGoods),            
    (SELECT SUM(_tmpGoods.MarginPercentPrev3)
     FROM _tmpGoods
     WHERE COALESCE (_tmpGoods.PrevId3, 0) <> 0);*/
     
    OPEN Cursor1 FOR
       SELECT tmpCompetitor.Id
            , tmpCompetitor.CompetitorId
            , tmpCompetitor.CompetitorCode
            , tmpCompetitor.CompetitorName
            , 'Цена'::TVarChar AS PriceName
            , 'Разн цены'::TVarChar AS DPriceName
            , 'Разн. нац.'::TVarChar AS MarginPercentDeltaMinName
            , 'Разн. нац.'::TVarChar AS MarginPercentDeltaMaxName
            , '% нац.'::TVarChar AS MarginPercentName
            , 'Ср. % нац.'::TVarChar AS MarginPercentSGRName
            
       FROM _tmpCompetitor AS tmpCompetitor
       ORDER BY tmpCompetitor.Id;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
       SELECT *            
       FROM _tmpGoods AS tmpGoods
       ORDER BY tmpGoods.SubGroupsPriceMax, tmpGoods.GoodsName;

    RETURN NEXT Cursor2;
    
     
    OPEN Cursor3 FOR
       SELECT tmpCompetitor.Id
            , tmpCompetitor.CompetitorId
            , tmpCompetitor.CompetitorCode
            , tmpCompetitor.CompetitorName::TVarChar    AS CompetitorName
            , '(ср. наценка)'::TVarChar                 AS MarginPercentSGRName
            , ' '::TVarChar                             AS DMarginPercentCodeName
            , 'Разн. с пред. периодом'::TVarChar        AS DMarginPercent
             
       FROM _tmpCompetitor AS tmpCompetitor
       ORDER BY tmpCompetitor.Id;

    RETURN NEXT Cursor3;    
    
    OPEN Cursor4 FOR
       SELECT *            
       FROM _tmpSubGroups AS tmpSubGroups
       ORDER BY tmpSubGroups.SubGroupsPriceMax;

    RETURN NEXT Cursor4;
    
        
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
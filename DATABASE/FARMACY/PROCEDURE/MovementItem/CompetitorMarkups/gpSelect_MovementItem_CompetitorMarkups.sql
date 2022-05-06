-- Function: gpSelect_MovementItem_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_CompetitorMarkups (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CompetitorMarkups(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE curCompetitor refcursor;
    DECLARE vbQueryText Text;
    DECLARE vbId Integer;
    DECLARE vbCompetitorId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    
    
    SELECT Movement.OperDate INTO vbOperDate FROM Movement WHERE Movement.ID = inMovementId;

    -- Перечень конкурентов
    CREATE TEMP TABLE _tmpCompetitor ON COMMIT DROP AS (
      WITH
      tmpCompetitor AS (SELECT DISTINCT MovementItem.ObjectId     AS CompetitorId
                        FROM MovementItem 
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Child()
                          AND (MovementItem.isErased  = false OR inIsErased = TRUE))
                          
      SELECT ROW_NUMBER() OVER(ORDER BY Object_Competitor.ValueData) as ID
           , tmpCompetitor.CompetitorId
           , Object_Competitor.ObjectCode          AS CompetitorCode
           , Object_Competitor.ValueData           AS CompetitorName
      FROM tmpCompetitor
      
           INNER JOIN Object AS Object_Competitor
                             ON Object_Competitor.Id = tmpCompetitor.CompetitorId
      );


    -- Результат
    IF inShowAll THEN
        -- Результат такой
        CREATE TEMP TABLE _tmpGoods ON COMMIT DROP AS (
            WITH tmpPriceSubgroups AS (select * from gpSelect_MovementItem_PriceSubgroups(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := inSession)),
                 tmpPrice AS (SELECT AnalysisContainerItem.GoodsId
                                   , (SUM(AnalysisContainerItem.AmountCheckSum) / SUM(AnalysisContainerItem.AmountCheck))::TFloat   AS Price
                              FROM AnalysisContainerItem
                              WHERE AnalysisContainerItem.OperDate > vbOperDate - INTERVAL '11 DAY'
                                AND AnalysisContainerItem.OperDate <= vbOperDate
                              GROUP BY AnalysisContainerItem.GoodsId
                              HAVING SUM(AnalysisContainerItem.AmountCheck) > 0)

            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS GoodsID

                 , Object_Goods_Main.ObjectCode       AS GoodsCode
                 , Object_Goods_Main.Name             AS GoodsName

                 , Object_Groups.ValueData            AS GroupsName
                 , tmpPriceSubgroups.PriceMax         AS PriceMax
                 , tmpPriceSubgroups.Name             AS SubGroupsName 
                 
                 , MIFloat_Price.ValueData            AS Price

                 , MovementItem.isErased              AS isErased

                 , 0::Integer                         AS TypeId0
                 , 0::TFloat                          AS Value0
            FROM  MovementItem

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                  LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                  
                  LEFT JOIN Object AS Object_Groups ON Object_Groups.Id = Object_Goods_Main.GoodsGroupId
                                                  
                  LEFT JOIN tmpPriceSubgroups ON tmpPriceSubgroups.PriceMin <= MIFloat_Price.ValueData
                                             AND tmpPriceSubgroups.PriceMax > MIFloat_Price.ValueData

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
            UNION ALL
            SELECT 0                                  AS Id
                 , Object_Goods_Retail.Id             AS GoodsID 

                 , Object_Goods_Main.ObjectCode       AS GoodsCode
                 , Object_Goods_Main.Name             AS GoodsName

                 , Object_Groups.ValueData            AS GroupsName
                 , tmpPriceSubgroups.PriceMax         AS PriceMax
                 , tmpPriceSubgroups.Name             AS SubGroupsName 

                 , tmpPrice.Price                     AS Price

                 , False                              AS isErased

                 , 0::Integer                         AS TypeId0
                 , 0::TFloat                          AS Value0
            FROM Object_Goods_Retail AS Object_Goods_Retail
                         
                 INNER JOIN Object_Goods_Main AS Object_Goods_Main 
                                              ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                 LEFT JOIN Object AS Object_Groups ON Object_Groups.Id = Object_Goods_Main.GoodsGroupId
                 
                 LEFT JOIN tmpPrice ON tmpPrice.GoodsId = Object_Goods_Retail.Id 

                 LEFT JOIN tmpPriceSubgroups ON tmpPriceSubgroups.PriceMin <= tmpPrice.Price
                                            AND tmpPriceSubgroups.PriceMax > tmpPrice.Price

            WHERE Object_Goods_Retail.RetailId = 4
              AND Object_Goods_Retail.isErased = False
              AND COALESCE (tmpPrice.Price, 0) > 0
              AND Object_Goods_Retail.Id NOT IN (SELECT MovementItem.ObjectId 
                                                 FROM MovementItem
                                                 WHERE MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master())
	    );
    ELSE
        -- Результат другой

        CREATE TEMP TABLE _tmpGoods ON COMMIT DROP AS (
            WITH tmpPriceSubgroups AS (select * from gpSelect_MovementItem_PriceSubgroups(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := inSession))
          
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS GoodsID
                 
                 , Object_Goods_Main.ObjectCode       AS GoodsCode
                 , Object_Goods_Main.Name             AS GoodsName
                 
                 , Object_Groups.ValueData            AS GroupsName
                 , tmpPriceSubgroups.PriceMax         AS PriceMax
                 , tmpPriceSubgroups.Name             AS SubGroupsName 

                 , MIFloat_Price.ValueData            AS Price

                 , MovementItem.isErased              AS isErased
                 
                 , 0::Integer                         AS TypeId0
                 , 0::TFloat                          AS Value0
            FROM  MovementItem

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                  LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                  
                  LEFT JOIN Object AS Object_Groups ON Object_Groups.Id = Object_Goods_Main.GoodsGroupId
                  
                  LEFT JOIN tmpPriceSubgroups ON tmpPriceSubgroups.PriceMin <= MIFloat_Price.ValueData
                                             AND tmpPriceSubgroups.PriceMax > MIFloat_Price.ValueData
                                                                    
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
              
            );

     END IF;
     
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
                                          ' , ADD COLUMN Value' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE _tmpGoods set ID' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Id, 0)' ||
          ' , Value' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Price, 0)' ||
          ' FROM (SELECT MovementItem.Id 
                       , MovementItem.ParentId 
                       , MovementItem.Amount    AS Price 
                  FROM MovementItem 
                  WHERE MovementItem.MovementId = '|| inMovementId::Text ||'
                    AND MovementItem.ObjectId = '|| vbCompetitorId::Text ||'
                    AND MovementItem.DescId     = zc_MI_Child()
                    AND (MovementItem.isErased  = false OR '|| inIsErased::Text ||' = TRUE)) AS T1
           WHERE _tmpGoods.Id = T1.ParentId';
        EXECUTE vbQueryText;

    END LOOP;
    CLOSE curCompetitor;        
     
     
    OPEN Cursor1 FOR
       SELECT tmpCompetitor.Id
            , tmpCompetitor.CompetitorId
            , tmpCompetitor.CompetitorCode
            , tmpCompetitor.CompetitorName
            
       FROM _tmpCompetitor AS tmpCompetitor
       ORDER BY tmpCompetitor.Id;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
       SELECT *            
       FROM _tmpGoods AS tmpGoods
       ORDER BY tmpGoods.PriceMax, tmpGoods.GoodsName;

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
select * from gpSelect_MovementItem_CompetitorMarkups(inMovementId := 24892120 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
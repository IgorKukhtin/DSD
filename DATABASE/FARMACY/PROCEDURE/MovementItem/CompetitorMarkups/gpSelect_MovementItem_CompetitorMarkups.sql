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
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- Перечень конкурентов
    CREATE TEMP TABLE _tmpCompetitor ON COMMIT DROP AS (
      WITH
      tmpCompetitor AS (SELECT DISTINCT MovementItem.ObjectId     AS CompetitorId
                        FROM MovementItem 
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Child()
                          AND (MovementItem.isErased   = TRUE OR inIsErased = TRUE))
                          
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
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS GoodsID

                 , Object_Goods_Main.ObjectCode       AS GoodsCode
                 , Object_Goods_Main.Name             AS GoodsName

                 , Object_Groups.ValueData            AS GroupsName

                 , MovementItem.isErased              AS isErased

                 , 0::Integer                         AS TypeId0
                 , 0::TFloat                          AS Value0
            FROM  MovementItem

                  LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                  
                  LEFT JOIN Object AS Object_Groups ON Object_Groups.Id = Object_Goods_Main.GoodsGroupId
                                                  
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
            UNION ALL
            SELECT 0                                  AS Id
                 , Object_Goods_Retail.Id             AS GoodsID 

                 , Object_Goods_Main.ObjectCode       AS GoodsCode
                 , Object_Goods_Main.Name             AS GoodsName

                 , Object_Groups.ValueData            AS GroupsName

                 , False                              AS isErased

                 , 0::Integer                         AS TypeId0
                 , 0::TFloat                          AS Value0
            FROM Object_Goods_Retail AS Object_Goods_Retail
                         
                 INNER JOIN Object_Goods_Main AS Object_Goods_Main 
                                              ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                 LEFT JOIN Object AS Object_Groups ON Object_Groups.Id = Object_Goods_Main.GoodsGroupId

            WHERE Object_Goods_Retail.RetailId = 4
              AND Object_Goods_Retail.isErased = False
              AND Object_Goods_Retail.Id NOT IN (SELECT MovementItem.ObjectId 
                                                 FROM MovementItem
                                                 WHERE MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master())
	    );
    ELSE
        -- Результат другой

        CREATE TEMP TABLE _tmpGoods ON COMMIT DROP AS (
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS GoodsID
                 
                 , Object_Goods_Main.ObjectCode       AS GoodsCode
                 , Object_Goods_Main.Name             AS GoodsName
                 
                 , Object_Groups.ValueData            AS GroupsName

                 , MovementItem.isErased              AS isErased
                 
                 , 0::Integer                         AS TypeId0
                 , 0::TFloat                          AS Value0
            FROM  MovementItem


                  LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                  
                  LEFT JOIN Object AS Object_Groups ON Object_Groups.Id = Object_Goods_Main.GoodsGroupId
                  
                                                  
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
              
            );

     END IF;
     
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
       ORDER BY tmpGoods.GoodsName;

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
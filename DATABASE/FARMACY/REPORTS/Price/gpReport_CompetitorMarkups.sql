-- Function: gpReport_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpReport_CompetitorMarkups (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CompetitorMarkups(
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
                      WHERE Movement.OperDate <= CURRENT_DATE
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
            WITH tmpPriceSubgroups AS (select * from gpSelect_MovementItem_PriceSubgroups(inMovementId := vbMovementId , inIsErased := 'False' ,  inSession := inSession))
          
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
                                                                    
            WHERE MovementItem.MovementId = vbMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND MovementItem.isErased = FALSE
              
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
                                          ' , ADD COLUMN Value' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE _tmpGoods set ID' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Id, 0)' ||
          ' , Value' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Price, 0)' ||
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
select * from gpReport_CompetitorMarkups(inSession := '3');
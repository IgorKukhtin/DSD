-- Function: gpSelect_MovementItem_Layout()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Layout (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Layout(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
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
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Layout());
    vbUserId:= lpGetUserBySession (inSession);
     
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    --Определили подразделение для розничной цены и дату для остатка
    SELECT 
        MovementLinkObject_Unit.ObjectId
       ,Movement_Layout.OperDate 
    INTO 
        vbUnitId
       ,vbOperDate
    FROM Movement AS Movement_Layout
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement_Layout.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement_Layout.Id = inMovementId;
    
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

            -- результат
            SELECT COALESCE(MovementItem.Id,0)           AS Id
                 , tmpGoods.Id                           AS GoodsId
                 , tmpGoods.GoodsCodeInt                 AS GoodsCode
                 , tmpGoods.GoodsName                    AS GoodsName
                 , COALESCE (MovementItem.Amount, 0)      :: TFloat  AS Amount
                 , COALESCE (MovementItem.IsErased,FALSE) :: Boolean AS isErased
            FROM tmpGoods
                LEFT JOIN MovementItem ON tmpGoods.Id = MovementItem.ObjectId 
                                      AND MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Master()
                                      AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
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
                  FROM MovementItem
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()          
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                  )

        SELECT MovementItem.Id                                   AS Id
             , Object_Goods.Id                                   AS GoodsId
             , Object_Goods.ObjectCode                           AS GoodsCode
             , Object_Goods.ValueData                            AS GoodsName
             , COALESCE (MovementItem.Amount, 0)       ::TFloat  AS Amount
             , COALESCE (MovementItem.IsErased, FALSE) ::Boolean AS isErased
        FROM tmpMI AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
        ;
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.20         *  
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Layout (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- select * from gpSelect_MovementItem_Layout(inMovementId := 16461309 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
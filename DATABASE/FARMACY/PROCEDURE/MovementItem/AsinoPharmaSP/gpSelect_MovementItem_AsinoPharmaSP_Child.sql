 -- Function: gpSelect_MovementItem_AsinoPharmaSP_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_AsinoPharmaSP_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_AsinoPharmaSP_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , ParentId      Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , Amount        TFloat
             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);

    
      RETURN QUERY
        SELECT MovementItem.Id                                       AS Id
             , MovementItem.ParentId                                 AS ParentId
             , MovementItem.ObjectId                                 AS GoodsId
             , Object_Goods.ObjectCode                               AS GoodsCode
             , Object_Goods.Name                                     AS GoodsName
             , MovementItem.Amount                                   AS Amount
             , MovementItem.isErased                                 AS isErased

        FROM MovementItem
        
             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                                          
        WHERE MovementItem.DescId = zc_MI_Child()
          AND MovementItem.MovementId = inMovementId
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.23                                                       *
*/

--ТЕСТ
-- 

select * from gpSelect_MovementItem_AsinoPharmaSP_Child(inMovementId := 27423073 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
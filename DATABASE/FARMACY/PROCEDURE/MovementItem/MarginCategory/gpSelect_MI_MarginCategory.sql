-- Function: gpSelect_MI_MarginCategory()

DROP FUNCTION IF EXISTS gpSelect_MI_MarginCategory (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_MarginCategory(
    IN inMovementId          Integer,
    IN inisErased            Boolean      , --
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
  DECLARE vbUnitId Integer;
BEGIN

    --определяем подразделение и дату документа, ИД строки
    SELECT MLO_Unit.ObjectId
       INTO vbUnitId
    FROM MovementLinkObject AS MLO_Unit
    WHERE MLO_Unit.MovementId = inMovementId
      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit();
    
    OPEN Cursor1 FOR
    WITH 
    --строки мастера
    tmpMI_Master AS (SELECT MovementItem.*
                     FROM (SELECT FALSE AS isErased ) AS tmpIsErased
                          JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = tmpIsErased.isErased
                    )
  -- остатки
  , tmpRemains AS (SELECT tmpMI_Master.ObjectId AS GoodsId
                        , SUM (COALESCE (Container.Amount, 0)) AS Amount_Remains
                   FROM tmpMI_Master
                        LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                           AND Container.ObjectId = tmpMI_Master.ObjectId
                                           AND Container.WhereObjectId = vbUnitId
                                           AND Container.Amount <> 0
                   GROUP BY tmpMI_Master.ObjectId
                   HAVING SUM (COALESCE (Container.Amount, 0)) <> 0
                  )
  -- данные из прайса
  , tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                      , MCS_Value.ValueData                     AS MCSValue
                      , Price_Goods.ChildObjectId               AS GoodsId
                      , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose
                      , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
                      , COALESCE(Price_Top.ValueData,False)     AS isTop
                 FROM ObjectLink AS ObjectLink_Price_Unit
                      LEFT JOIN ObjectLink AS Price_Goods
                                           ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                          AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       
                      INNER JOIN tmpMI_Master ON tmpMI_Master.ObjectId = Price_Goods.ChildObjectId  -- goodsId
                      LEFT JOIN ObjectFloat AS MCS_Value
                                            ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                      LEFT JOIN ObjectBoolean AS MCS_isClose
                                              ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                      LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                              ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                      LEFT JOIN ObjectBoolean AS Price_Top
                                              ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                 WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
              )
  -- товары СП, дальше связь по главному товару
  , tmpOB_SP AS (SELECT *
                 FROM ObjectBoolean AS ObjectBoolean_Goods_SP 
                 WHERE ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                   AND COALESCE (ObjectBoolean_Goods_SP.ValueData, False) = TRUE
                )
    
       -- результат
       SELECT MovementItem.Id		   ::Integer   AS Id
            , Object_Goods.Id              ::Integer   AS GoodsId
            , Object_Goods.GoodsCodeInt    ::Integer   AS GoodsCode
            , Object_Goods.GoodsName       ::TVarChar  AS GoodsName
            , Object_Goods.GoodsGroupName  ::TVarChar  AS GoodsGroupName
 
            , COALESCE (Object_Goods.isClose, False)     ::Boolean AS isClose
            , COALESCE (Object_Goods.isTOP, False)       ::Boolean AS isTOP
            , COALESCE (Object_Goods.isFirst, False)     ::Boolean AS isFirst
            , COALESCE (Object_Goods.isSecond, False)    ::Boolean AS isSecond

            , COALESCE (tmpPrice.MCSValue, 0)            ::TFloat  AS MCSValue
            , COALESCE (tmpPrice.MCSIsClose, False)      ::Boolean AS MCSIsClose
            , COALESCE (tmpPrice.MCSNotRecalc, False)    ::Boolean AS MCSNotRecalc
            , COALESCE (ObjectBoolean_Goods_SP.ValueData, False)  :: Boolean  AS isSP
   
            , MovementItem.Amount                       ::TFloat       AS Amount
            , COALESCE (MIFloat_Amount.ValueData, 0)    ::TFloat       AS AmountAnalys
            , COALESCE (MIFloat_AmountMin.ValueData, 0) ::TFloat       AS AmountMin
            , COALESCE (MIFloat_AmountMax.ValueData, 0) ::TFloat       AS AmountMax
            , COALESCE (MIFloat_NumberMin.ValueData, 0) ::TFloat       AS NumberMin
            , COALESCE (MIFloat_NumberMax.ValueData, 0) ::TFloat       AS NumberMax
            , COALESCE (tmpRemains.Amount_Remains, 0)   ::TFloat       AS Remains
            
            , CASE WHEN COALESCE (MIFloat_AmountMin.ValueData, 0) <> 0 THEN (MIFloat_Amount.ValueData - MIFloat_AmountMin.ValueData) *100 / MIFloat_AmountMin.ValueData ELSE 0 END        ::TFloat AS PersentMin
            , CASE WHEN COALESCE (MIFloat_AmountMax.ValueData, 0) <> 0 THEN (-1) * (MIFloat_Amount.ValueData - MIFloat_AmountMax.ValueData) *100 / MIFloat_AmountMax.ValueData ELSE 0 END ::TFloat AS PersentMax

            , COALESCE (MIString_Comment.ValueData, '') ::TVarChar     AS Comment
            
            , MovementItem.isErased                        :: Boolean  AS isErased
            
       FROM tmpMI_Master AS MovementItem
            LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                        ON MIFloat_Amount.MovementItemId = MovementItem.Id
                                       AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
                                       
            LEFT JOIN MovementItemFloat AS MIFloat_AmountMin
                                        ON MIFloat_AmountMin.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountMin.DescId = zc_MIFloat_AmountMin()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountMax
                                        ON MIFloat_AmountMax.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountMax.DescId = zc_MIFloat_AmountMax()
            LEFT JOIN MovementItemFloat AS MIFloat_NumberMin
                                        ON MIFloat_NumberMin.MovementItemId = MovementItem.Id
                                       AND MIFloat_NumberMin.DescId = zc_MIFloat_NumberMin()
            LEFT JOIN MovementItemFloat AS MIFloat_NumberMax
                                        ON MIFloat_NumberMax.MovementItemId = MovementItem.Id
                                       AND MIFloat_NumberMax.DescId = zc_MIFloat_NumberMax()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                                        
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
            
            -- получаем GoodsMainId
            LEFT JOIN ObjectLink AS ObjectLink_Child 
                                 ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_Main 
                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            LEFT JOIN tmpOB_SP AS ObjectBoolean_Goods_SP 
                               ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId
           ;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR

       SELECT MovementItem.Id	                AS Id
            , MovementItem.ParentId	        AS ParentId
            , Object_MarginCategory.Id          AS MarginCategoryId
            , Object_MarginCategory.ValueData   AS MarginCategoryName
            
            , MovementItem.Amount               AS Amount
            , MIString_Comment.ValueData        AS Comment
           
            , MovementItem.isErased             AS isErased
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = MovementItem.ObjectId
             LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                         ON MIFloat_Amount.MovementItemId = MovementItem.Id
                                        AND MIFloat_Amount.DescId = zc_MIFloat_Amount()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()
            ;
    RETURN NEXT Cursor2;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.11.17         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_MarginCategory (inMovementId:= 3959786 , inisErased:= FALSE, inSession:= '3'); FETCH ALL "<unnamed portal 29>";

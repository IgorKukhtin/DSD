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

  DECLARE vbUnitId       Integer;
  DECLARE vbPeriodCount  Integer;
  DECLARE vbDayCount     TFloat;
  DECLARE vbStartSale    TDateTime;
  DECLARE vbEndSale      TDateTime;
BEGIN

    --определяем подразделение
    SELECT MLO_Unit.ObjectId                 AS UnitId
         , MovementDate_StartSale.ValueData  AS StartSale
         , MovementDate_EndSale.ValueData    AS EndSale
         , MovementFloat_DayCount.ValueData  AS DayCount
       INTO vbUnitId, vbStartSale, vbEndSale, vbDayCount
    FROM Movement
         LEFT JOIN MovementLinkObject AS MLO_Unit
                                      ON MLO_Unit.MovementId = Movement.Id
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
         LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
         LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                 ON MovementFloat_DayCount.MovementId = Movement.Id
                                AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()
    WHERE Movement.Id = inMovementId;
   
    --получаем количество периодов
    vbPeriodCount := (ROUND( (date_part('DAY', vbEndSale - vbStartSale) / vbDayCount ) ::TFloat, 0)) :: Integer;

    -- вытягиваем строки чайлд, там категория наценки и %, чтоб по ним определить для мастера % наценки
    CREATE TEMP TABLE _tmpMI_Child (Id Integer, MarginCategoryItemId Integer, MarginCategoryName TVarChar, Amount TFloat, MinPrice TFloat, AmountDiff TFloat, PercentNew TFloat, isErased Boolean, ORD Integer) ON COMMIT DROP;
    
    INSERT INTO _tmpMI_Child (Id, MarginCategoryItemId, MarginCategoryName, Amount, MinPrice, AmountDiff, PercentNew, isErased, ORD)
    
           SELECT MovementItem.Id	            AS Id
                , MovementItem.ObjectId             AS MarginCategoryItemId
                , Object_MarginCategory.ValueData   AS MarginCategoryName
                , MovementItem.Amount               AS Amount
                , ObjectFloat_MinPrice.ValueData    AS MinPrice
                , MIFloat_Amount.ValueData          AS AmountDiff
                , MovementItem.Amount + COALESCE (MIFloat_Amount.ValueData, 0)  ::TFloat AS PercentNew
                , MovementItem.isErased             AS isErased
                , ROW_NUMBER() OVER (ORDER BY ObjectFloat_MinPrice.ValueData) as ORD
           FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Child()
                                 AND MovementItem.isErased   = tmpIsErased.isErased

                LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                            ON MIFloat_Amount.MovementItemId = MovementItem.Id
                                           AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
                                        
                LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                      ON ObjectFloat_MinPrice.ObjectId = MovementItem.ObjectId
                                     AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
    
                LEFT JOIN ObjectLink AS ObjectLink_MarginCategoryItem_MarginCategory
                                     ON ObjectLink_MarginCategoryItem_MarginCategory.ObjectId = MovementItem.ObjectId
                                    AND ObjectLink_MarginCategoryItem_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory()
                LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId;
    
    OPEN Cursor1 FOR
    WITH
    --строки мастера
    tmpMI_Master AS (SELECT MovementItem.*
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = tmpIsErased.isErased
                    )

  -- данные из прайса
  , tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                      , MCS_Value.ValueData                     AS MCSValue
                      , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
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
                      LEFT JOIN ObjectFloat AS Price_PercentMarkup
                                            ON Price_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                 WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
              )
    -- Товары соц-проект (документ)
  , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                   FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbStartSale, inEndDate:= vbEndSale, inUnitId := vbUnitId) AS tmp
                   )
              
  -- товары СП, дальше связь по главному товару
  /*, tmpOB_SP AS (SELECT *
                 FROM ObjectBoolean AS ObjectBoolean_Goods_SP 
                 WHERE ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                   AND COALESCE (ObjectBoolean_Goods_SP.ValueData, False) = TRUE
                )*/
    
  , MarginCondition AS (SELECT D1.MarginCategoryItemId
                             , D1.Amount AS MarginPercent
                             , D1.PercentNew
                             , D1.MinPrice
                             , COALESCE(D2.MinPrice, 1000000) AS MaxPrice 
                        FROM _tmpMI_Child AS D1
                            LEFT OUTER JOIN _tmpMI_Child AS D2 ON D1.ORD = D2.ORD-1
                        WHERE D1.IsErased = FALSE
                       )
       -- результат
       SELECT MovementItem.Id		   ::Integer   AS Id
            , Object_Goods.Id              ::Integer   AS GoodsId
            , Object_Goods.GoodsCodeInt    ::Integer   AS GoodsCode
            , Object_Goods.GoodsName       ::TVarChar  AS GoodsName
            , Object_Goods.GoodsGroupName  ::TVarChar  AS GoodsGroupName
            , Object_Retail.ValueData      ::TVarChar  AS RetailName
 
            , COALESCE (Object_Goods.isClose, False)      ::Boolean AS isClose
            , COALESCE (Object_Goods.isTOP, False)        ::Boolean AS isTOP
            , COALESCE (Object_Goods.isFirst, False)      ::Boolean AS isFirst
            , COALESCE (Object_Goods.isSecond, False)     ::Boolean AS isSecond

            , COALESCE (tmpPrice.MCSValue, 0)             ::TFloat  AS MCSValue
            , COALESCE (MarginCondition.MarginPercent, 0) ::TFloat  AS MarginPercent
            , COALESCE (MarginCondition.PercentNew, 0)    ::TFloat  AS MarginPercentNew
            , COALESCE (tmpPrice.MCSIsClose, False)       ::Boolean AS MCSIsClose
            , COALESCE (tmpPrice.MCSNotRecalc, False)     ::Boolean AS MCSNotRecalc
            , COALESCE (tmpGoodsSP.isSP, False)           ::Boolean AS isSP
   
            , MovementItem.Amount                         ::TFloat       AS Amount
            , COALESCE (MIFloat_Amount.ValueData, 0)      ::TFloat       AS AmountAnalys
            , CASE WHEN COALESCE (vbPeriodCount, 0) <> 0 THEN MovementItem.Amount / vbPeriodCount ELSE MovementItem.Amount END  ::TFloat  AS AmountMid
            , COALESCE (MIFloat_AmountMin.ValueData, 0)   ::TFloat       AS AmountMin
            , COALESCE (MIFloat_AmountMax.ValueData, 0)   ::TFloat       AS AmountMax
            , COALESCE (MIFloat_NumberMin.ValueData, 0)   ::TFloat       AS NumberMin
            , COALESCE (MIFloat_NumberMax.ValueData, 0)   ::TFloat       AS NumberMax
            , COALESCE (MIFloat_Remains.ValueData, 0)     ::TFloat       AS Remains
            , COALESCE (MIFloat_Price.ValueData, 0)       ::TFloat       AS Price
            , COALESCE (MIFloat_PriceMax.ValueData, 0)    ::TFloat       AS PriceMax
            
            , CASE WHEN COALESCE (MIFloat_AmountMin.ValueData, 0) <> 0 THEN (MIFloat_Amount.ValueData - MIFloat_AmountMin.ValueData) *100 / MIFloat_AmountMin.ValueData ELSE 0 END        ::TFloat AS PersentMin
            , CASE WHEN COALESCE (MIFloat_AmountMax.ValueData, 0) <> 0 THEN (-1) * (MIFloat_Amount.ValueData - MIFloat_AmountMax.ValueData) *100 / MIFloat_AmountMax.ValueData ELSE 0 END ::TFloat AS PersentMax

            , COALESCE (MIString_Comment.ValueData, '') ::TVarChar     AS Comment
            
            , COALESCE (MIBoolean_Checked.ValueData, FALSE) ::Boolean  AS isChecked
            , COALESCE (MIBoolean_Report.ValueData, FALSE)  ::Boolean  AS isReport
            
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

            LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                        ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                       AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceMax
                                        ON MIFloat_PriceMax.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceMax.DescId = zc_MIFloat_PriceMax()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                          ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Report
                                          ON MIBoolean_Report.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Report.DescId = zc_MIBoolean_Report()

            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
            
            LEFT JOIN MarginCondition ON COALESCE (MIFloat_Price.ValueData, 0) >= MarginCondition.MinPrice AND COALESCE (MIFloat_Price.ValueData, 0) < MarginCondition.MaxPrice
            
            -- торг.сеть товара
            LEFT JOIN Object AS Object_Retail 
                             ON Object_Retail.Id = Object_Goods.ObjectId
                            AND Object_Retail.DescId = zc_Object_Retail()

            -- получаем GoodsMainId
            LEFT JOIN ObjectLink AS ObjectLink_Child 
                                 ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_Main 
                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

            LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
           ;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR

       SELECT MovementItem.Id	                AS Id
            , MovementItem.MarginCategoryItemId AS MarginCategoryItemId
            , MovementItem.MarginCategoryName   AS MarginCategoryName
            
            , MovementItem.Amount               AS Amount
            , MovementItem.MinPrice             AS MinPrice
            , MovementItem.AmountDiff           AS AmountDiff
            , MIString_Comment.ValueData        AS Comment
           
            , MovementItem.isErased             AS isErased
       FROM _tmpMI_Child AS MovementItem

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.19         * признак Товары соц-проект берем и документа
 19.11.17         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_MarginCategory (inMovementId:= 3959786 , inisErased:= FALSE, inSession:= '3'); FETCH ALL "<unnamed portal 29>";
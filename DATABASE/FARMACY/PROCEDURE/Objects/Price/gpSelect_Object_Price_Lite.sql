-- Function: gpSelect_Object_Price_Lite (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Price_Lite(Integer, Integer, Boolean,Boolean,TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_Price_Lite(
    IN inUnitId      Integer,       -- подразделение
    IN inGoodsId     Integer,       -- Товар
    IN inisShowAll   Boolean,       -- True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar
             , Goods_isTop Boolean, Goods_PercentMarkup TFloat
             , DateChange TDateTime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , isErased boolean
             , isClose boolean, isFirst boolean , isSecond boolean
             , isTop boolean, TOPDateChange TDateTime
             , PercentMarkup TFloat, PercentMarkupDateChange TDateTime
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
    vbStartDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbStartDate:= DATE_TRUNC ('DAY', CURRENT_DATE);

    IF inUnitId is null
    THEN
        inUnitId := 0;
    END IF;
    -- Результат
    IF COALESCE(inUnitId,0) = 0
    THEN
        RETURN QUERY
            SELECT 
                NULL::Integer                    AS Id
               ,NULL::TFloat                     AS Price
               ,NULL::TFloat                     AS MCSValue
               ,NULL::Integer                    AS GoodsId
               ,NULL::Integer                    AS GoodsCode
               ,NULL::TVarChar                   AS GoodsName
               ,NULL::TVarChar                   AS GoodsGroupName
               ,NULL::TVarChar                   AS NDSKindName
               ,NULL::Boolean                    AS Goods_isTop
               ,NULL::TFloat                     AS Goods_PercentMarkup
               ,NULL::TDateTime                  AS DateChange
               ,NULL::TDateTime                  AS MCSDateChange
               ,NULL::Boolean                    AS MCSIsClose
               ,NULL::TDateTime                  AS MCSIsCloseDateChange
               ,NULL::Boolean                    AS MCSNotRecalc
               ,NULL::TDateTime                  AS MCSNotRecalcDateChange
               ,NULL::Boolean                    AS Fix
               ,NULL::TDateTime                  AS FixDateChange

               ,NULL::Boolean                    AS isErased
               ,NULL::Boolean                    AS isClose 
               ,NULL::Boolean                    AS isFirst 
               ,NULL::Boolean                    AS isSecond 
               ,NULL::Boolean                    AS isTop 
               ,NULL::TDateTime                  AS TOPDateChange
               ,NULL::TFloat                     AS PercentMarkup 
               ,NULL::TDateTime                  AS PercentMarkupDateChange
               WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
            SELECT
                 Object_Price_View.Id                            AS Id
               , COALESCE (Object_Price_View.Price,0)            :: TFloat AS Price
               , COALESCE (Object_Price_View.MCSValue,0)         :: TFloat AS MCSValue
                             
               , Object_Goods_View.id                            AS GoodsId
               , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
               , Object_Goods_View.GoodsName                     AS GoodsName
               , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
               , Object_Goods_View.NDSKindName                   AS NDSKindName
               , Object_Goods_View.isTop                         AS Goods_isTop
               , Object_Goods_View.PercentMarkup                 AS Goods_PercentMarkup
               , Object_Price_View.DateChange                    AS DateChange
               , Object_Price_View.MCSDateChange                 AS MCSDateChange
               , COALESCE(Object_Price_View.MCSIsClose,False)    AS MCSIsClose
               , Object_Price_View.MCSIsCloseDateChange          AS MCSIsCloseDateChange
               , COALESCE(Object_Price_View.MCSNotRecalc,False)  AS MCSNotRecalc
               , Object_Price_View.MCSNotRecalcDateChange        AS MCSNotRecalcDateChange
               , COALESCE(Object_Price_View.Fix,False)           AS Fix
               , Object_Price_View.FixDateChange                 AS FixDateChange
                 
               , Object_Goods_View.isErased                      AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
  
               , Object_Price_View.isTop                   AS isTop
               , Object_Price_View.TopDateChange           AS TopDateChange

               , Object_Price_View.PercentMarkup           AS PercentMarkup
               , Object_Price_View.PercentMarkupDateChange AS PercentMarkupDateChange
               
              FROM Object_Goods_View
                INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object_Goods_View.Id 
                                     AND ObjectLink.ChildObjectId = vbObjectId
                LEFT OUTER JOIN Object_Price_View ON Object_Goods_View.id = object_price_view.goodsid
                                                 AND Object_Price_View.unitid = inUnitId

            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
            ORDER BY GoodsGroupName, GoodsName;
    ELSE
        RETURN QUERY
         
            SELECT
                 Object_Price_View.Id                      AS Id
               , COALESCE (Object_Price_View.Price,0)      :: TFloat    AS Price
               , COALESCE (Object_Price_View.MCSValue,0)   :: TFloat    AS MCSValue
                                        
               , Object_Goods_View.id                      AS GoodsId
               , Object_Goods_View.GoodsCodeInt            AS GoodsCode
               , Object_Goods_View.GoodsName               AS GoodsName
               , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
               , Object_Goods_View.NDSKindName             AS NDSKindName
               , Object_Goods_View.isTop                   AS Goods_isTop
               , Object_Goods_View.PercentMarkup           AS Goods_PercentMarkup
               , Object_Price_View.DateChange              AS DateChange
               , Object_Price_View.MCSDateChange           AS MCSDateChange
               , Object_Price_View.MCSIsClose              AS MCSIsClose
               , Object_Price_View.MCSIsCloseDateChange    AS MCSIsCloseDateChange
               , Object_Price_View.MCSNotRecalc            AS MCSNotRecalc
               , Object_Price_View.MCSNotRecalcDateChange  AS MCSNotRecalcDateChange
               , Object_Price_View.Fix                     AS Fix
               , Object_Price_View.FixDateChange           AS FixDateChange
                              
               , Object_Goods_View.isErased                AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
            
               , Object_Price_View.isTop                   AS isTop
               , Object_Price_View.TopDateChange           AS TopDateChange

               , Object_Price_View.PercentMarkup           AS PercentMarkup
               , Object_Price_View.PercentMarkupDateChange AS PercentMarkupDateChange

            FROM Object_Price_View
                LEFT OUTER JOIN Object_Goods_View ON Object_Goods_View.id = object_price_view.goodsid
       
            WHERE Object_Price_View.unitid = inUnitId
              AND (inisShowDel = True OR Object_Goods_View.isErased = False)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
            ORDER BY GoodsGroupName, GoodsName;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Price_Lite(Integer, Boolean,Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А. 
 12.09.16         *
*/

-- тест
--select * from gpSelect_Object_Price_Lite(inUnitId := 183292 , inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
--select * from gpSelect_Object_Price(inUnitId := 183292 , inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
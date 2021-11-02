-- Function: gpSelect_GoodsPrice_ForSite()

DROP FUNCTION IF EXISTS gpSelect_GoodsPrice_ForSite (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPrice_ForSite(
    IN inCategoryId       Integer     ,  -- Группа
    IN inSortType         Integer     ,  -- Тип сортировка
    IN inSortLang         TVarChar    ,  -- По названию
    IN inStart            Integer     ,  -- Смещение
    IN inLimit            Integer     ,  -- Количество строк
    IN inProductId        Integer     ,  -- Только указанный товар
    IN inSearch           TVarChar    ,  -- Фильтр для ILIKE
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                Integer    -- Id товара

             , Name              TVarChar   -- Название русское
             , NameUkr           TVarChar   -- Название украинское если (есть)

             , Price             TFloat     -- Интернет цена
             , Remains           TFloat     -- Остаток по сети
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
    
    inStart := COALESCE (inStart, 0);
    if COALESCE (inLimit, 0) <= 0
    THEN
      inLimit := 100000;
    END IF;

    -- Результат
    RETURN QUERY
       WITH 
            tmpPrice_Site AS (SELECT Object_PriceSite.Id                        AS Id
                                   , ROUND(Price_Value.ValueData,2)::TFloat     AS Price
                                   , Price_Goods.ChildObjectId                  AS GoodsId
                                   , Object_Goods_Main.Name                     AS Name
                                   , Object_Goods_Main.NameUkr                  AS NameUkr
                              FROM Object AS Object_PriceSite

                                   INNER JOIN ObjectLink AS Price_Goods
                                           ON Price_Goods.ObjectId = Object_PriceSite.Id
                                          AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()

                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = Object_PriceSite.Id
                                         AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()

                                   LEFT JOIN Object_Goods_Retail    ON Object_Goods_Retail.Id   = Price_Goods.ChildObjectId
                                   LEFT JOIN Object_Goods_Main      ON Object_Goods_Main.Id     = Object_Goods_Retail.GoodsMainId

                              WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                                AND (Object_Goods_Main.GoodsGroupId = inCategoryId OR COALESCE(inCategoryId, 0) = 0)
                                AND (Object_Goods_Retail.Id = inProductId OR COALESCE(inProductId, 0) = 0)
                                AND Price_Goods.ChildObjectId NOT IN (SELECT DISTINCT ObjectLink_BarCode_Goods.ChildObjectId  AS GoodsId
                                                                      FROM Object AS Object_BarCode
                                                                           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                                                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                                                           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                                                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                                                           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                                                                      WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                                                        AND Object_BarCode.isErased = False
                                                                        AND Object_Object.isErased = False)
                              )
          , tmpContainerAll AS (SELECT Container.ObjectId           AS GoodsId
                                     , SUM(Container.Amount)        AS Remains 
                                FROM Container
                                     INNER JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = Container.ObjectId
                                WHERE Container.DescId = zc_Container_Count()
                                GROUP BY Container.ObjectId  
                                HAVING SUM(Container.Amount) > 0
                                )
                              
                           

        SELECT Price_Site.GoodsId                                           AS Id

             , Price_Site.Name                                              AS Name
             , Price_Site.NameUkr                                           AS NameUkr

             , Price_Site.Price                                             AS Price
             , tmpContainerAll.Remains::TFloat                              AS Remains
             
        FROM tmpPrice_Site AS Price_Site         

             INNER JOIN tmpContainerAll ON tmpContainerAll.GoodsId = Price_Site.GoodsId
             
        WHERE COALESCE (inSearch, '') = '' OR 
              CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END ILIKE '%'||inSearch||'%'

        ORDER BY CASE WHEN inSortType = 0 THEN Price_Site.Price END
               , CASE WHEN inSortType = 1 THEN Price_Site.Price END DESC
               , CASE WHEN inSortType = 2 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END
               , CASE WHEN inSortType = 3 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END DESC
               , Price_Site.Name
        LIMIT inLimit OFFSET inStart                                                                                                                 
       ;       

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.10.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_GoodsPrice_ForSite (inCategoryId := 394964 , inSortType := 0, inSortLang := 'uk', inStart := 0, inLimit := 100, inProductId := 0, inSearch := 'Мило', inSession:= zfCalc_UserSite());
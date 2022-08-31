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
             
             , PriceUnitMin      TFloat     -- Минимальная цена подразделений
             , PriceUnitMax      TFloat     -- Максимальная цена подразделений
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
                                   , COALESCE(Object_Goods_Retail.Price, 0)     AS PriceTop 
                                   , Object_Goods_Retail.isTop                  AS isTop 
                                   , Object_Goods_Main.Id                       AS GoodsMainId
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
                                AND Object_Goods_Main.isPublished = True
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
          , tmpGoods AS (SELECT DISTINCT Price_Site.GoodsId
                        FROM tmpPrice_Site AS Price_Site         
                        WHERE COALESCE (inSearch, '') = '' OR 
                              CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END ILIKE '%'||inSearch||'%'
                        )
          , tmpContainerRemains AS (SELECT Container.ObjectId           AS GoodsId
                                         , SUM(Container.Amount)        AS Remains 
                                    FROM Container
                                         INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                                    WHERE Container.DescId = zc_Container_Count()
                                      AND Container.Amount <> 0
                                    GROUP BY Container.ObjectId  
                                    HAVING SUM(Container.Amount) > 0
                                    )
          , tmpData AS (SELECT Price_Site.GoodsId
                             , Price_Site.GoodsMainId

                             , Price_Site.Name                                              AS Name
                             , Price_Site.NameUkr                                           AS NameUkr

                             , Price_Site.Price                                             AS Price

                             , tmpContainerRemains.Remains::TFloat                          AS Remains
                              
                        FROM tmpGoods 
                        
                             LEFT JOIN tmpPrice_Site AS Price_Site ON Price_Site.GoodsId = tmpGoods.GoodsId      

                             LEFT JOIN tmpContainerRemains ON tmpContainerRemains.GoodsId = Price_Site.GoodsId
                                            
                        ORDER BY CASE WHEN COALESCE (tmpContainerRemains.Remains, 0) = 0 THEN 1 ELSE 0 END 
                               , CASE WHEN inSortType = 0 THEN Price_Site.Price END
                               , CASE WHEN inSortType = 1 THEN Price_Site.Price END DESC
                               , CASE WHEN inSortType = 2 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END
                               , CASE WHEN inSortType = 3 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END DESC
                               , Price_Site.Name
                        LIMIT inLimit OFFSET inStart      
                        )
          , tmpContainer AS (SELECT Container.WhereObjectId      AS UnitId
                                  , Container.ObjectId           AS GoodsId
                                  , SUM(Container.Amount)        AS Remains 
                             FROM Container
                                  --INNER JOIN tmpData ON tmpData.GoodsId = Container.ObjectId
                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.Amount <> 0
                               AND Container.ObjectId in (SELECT tmpData.GoodsId FROM tmpData)
                             GROUP BY Container.WhereObjectId
                                    , Container.ObjectId  
                             HAVING SUM(Container.Amount) > 0
                             )
          , tmpContainerAll AS (SELECT Price_Goods.ChildObjectId            AS GoodsId
                                     , MIN(CASE WHEN tmpPrice_Site.IsTop = TRUE
                                                 AND tmpPrice_Site.PriceTop > 0
                                                THEN ROUND (tmpPrice_Site.PriceTop, 2)
                                                ELSE ROUND (Price_Value.ValueData, 2) END)           AS PriceMin
                                     , MAX(CASE WHEN tmpPrice_Site.IsTop = TRUE
                                                 AND tmpPrice_Site.PriceTop > 0
                                                THEN ROUND (tmpPrice_Site.PriceTop, 2)
                                                ELSE ROUND (Price_Value.ValueData, 2) END)           AS PriceMax
                                FROM ObjectLink AS Price_Goods
                                
                                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                           ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                          AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                         
                                     INNER JOIN tmpContainer ON tmpContainer.UnitId = ObjectLink_Price_Unit.ChildObjectId
                                                            AND tmpContainer.GoodsId = Price_Goods.ChildObjectId

                                     LEFT JOIN ObjectFloat AS Price_Value
                                                           ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                          AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                                     -- Фикс цена для всей Сети
                                     LEFT JOIN tmpPrice_Site  ON tmpPrice_Site.Id = Price_Goods.ChildObjectId

                                WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                  AND Price_Goods.ChildObjectId in (SELECT tmpData.GoodsId FROM tmpData)               
                                GROUP BY Price_Goods.ChildObjectId 
                                )
          , tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                                                                -- № п/п - на всякий случай
                                , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                           FROM Movement
                                INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                        ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                       AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                       AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE
 
                                INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                        ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                       AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                       AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                                INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                              ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                             AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
 
                                LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
 
 
                           WHERE Movement.DescId = zc_Movement_GoodsSP()
                             AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                          )
          , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                      , Object_Object.Id                                          AS GoodsDiscountId
                                      , Object_Object.ValueData                                   AS GoodsDiscountName
                                      , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                      /*, MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                                      , MAX(ObjectFloat_DiscountProcent.ValueData)::TFloat        AS DiscountProcent*/ 
                                 FROM Object AS Object_BarCode
                                      INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                            ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                           AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                      INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                           ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                          AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                      LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                              ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id
                                                             AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()

                                      /*LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                            ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                           AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                            ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                           AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()*/
                                                                   
                                 WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                   AND Object_BarCode.isErased = False
                                 GROUP BY Object_Goods_Retail.GoodsMainId
                                        , Object_Object.Id
                                        , Object_Object.ValueData
                                        , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False))
                                
                           

        SELECT Price_Site.GoodsId                                           AS Id

             , Price_Site.Name                                              AS Name
             , Price_Site.NameUkr                                           AS NameUkr

             , zfCalc_PriceCash(Price_Site.Price, 
                                CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)                 AS Price
             , zfCalc_PriceCash(tmpContainerAll.PriceMin, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)                    AS PriceMin
             , zfCalc_PriceCash(tmpContainerAll.PriceMax, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)                    AS PriceMax

             , Price_Site.Remains                                           AS Remains
             
        FROM tmpData AS Price_Site         

             LEFT JOIN tmpContainerAll ON tmpContainerAll.GoodsId = Price_Site.GoodsId
                          
             -- Соц Проект
             LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Price_Site.GoodsMainId
                                 AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай

             LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Price_Site.GoodsMainId
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
-- select *, null as img_url from gpSelect_GoodsPrice_ForSite(394759, 1, 'uk', 0, 8, 0, '', zfCalc_UserSite())


select *, null as img_url from gpSelect_GoodsPrice_ForSite(0, 1, 'uk', 0, 8, 0, 'Но-шпа', zfCalc_UserSite())
-- Function: gpSelect_GoodsPrice_ForSite()

DROP FUNCTION IF EXISTS gpSelect_GoodsPrice_ForSite (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPrice_ForSite(
    IN inCategoryId       Integer     ,  -- Группа
    IN inSortType         Integer     ,  -- Тип сортировка
    IN inSortLang         TVarChar    ,  -- По названию
    IN inStart            Integer     ,  -- Смещение
    IN inLimit            Integer     ,  -- Количество строк
    IN inProductId        Integer     ,  -- Только указанный товар
    IN inSearch           TVarChar    ,  -- Фильтр для ILIKE
    IN inUnitId           Integer     ,  -- Подразделение
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
          , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                        )
          , tmpContainerAll AS (SELECT Container.ObjectId           AS GoodsId
                                     , SUM(Container.Amount)        AS Remains 
                                FROM Container
                                     INNER JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = Container.ObjectId
                                WHERE Container.DescId = zc_Container_Count()
                                  AND (Container.WhereObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                                GROUP BY Container.ObjectId  
                                HAVING SUM(Container.Amount) > 0
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

             , zfCalc_PriceCash(CASE WHEN COALESCE (inUnitId, 0) <> 0 AND COALESCE (tmpContainerAll.Remains, 0) = 0
                                THEN Null
                                WHEN COALESCE (inUnitId, 0) <> 0
                                THEN tmpObject_Price.Price
                                ELSE Price_Site.Price END, 
                                CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) ::TFloat     AS Price
             , tmpContainerAll.Remains::TFloat                              AS Remains
             
        FROM tmpPrice_Site AS Price_Site         

             LEFT JOIN tmpContainerAll ON tmpContainerAll.GoodsId = Price_Site.GoodsId
             
             LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Price_Site.GoodsId
             
             -- Соц Проект
             LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Price_Site.GoodsMainId
                                 AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай

             LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Price_Site.GoodsMainId

        WHERE COALESCE (inSearch, '') = '' OR 
              CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END ILIKE '%'||inSearch||'%'

        ORDER BY CASE WHEN COALESCE (tmpContainerAll.Remains, 0) = 0 THEN 1 ELSE 0 END 
               , CASE WHEN inSortType = 0 THEN Price_Site.Price END
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
 
SELECT * FROM gpSelect_GoodsPrice_ForSite (inCategoryId := 394964 , inSortType := 0, inSortLang := 'uk', inStart := 0, inLimit := 100, inProductId := 0, inSearch := 'Мило', inUnitId := 472116, inSession:= zfCalc_UserSite());



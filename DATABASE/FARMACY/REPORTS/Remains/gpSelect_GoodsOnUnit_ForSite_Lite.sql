-- Function: gpSelect_GoodsOnUnit_ForSite_Lite()
/*
тогда подведу итог
1) сохранение заказа - проц я дал, по ним вопросов нет ?
2) сделаю новую проц по аналогии с gpSelect_GoodsOnUnit_ForSite - вернет только остатки , без расч. цены - будет быстрее
3) сделаю нов проц которая вернет все заказы, по которым есть подтверждение, но нет признака "отправлено смс"
4) сделаю нов проц которая у заказа ставит признак "отправлено смс"
*/
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite_Lite (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite_Lite(
    IN inUnitId_list      TVarChar ,  -- Список Подразделений, через зпт
    IN inGoodsId_list     TVarChar ,  -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                Integer
             , Article           Integer
             , Id_Site           Integer
             , Name_Site         TBlob
             , Name              TVarChar
             , ObjectId          Integer   -- Торговая сеть (информативно)
             , ObjectName        TVarChar  -- Торговая сеть (информативно)
             , UnitId            Integer   -- Аптека (информативно)
             , UnitName          TVarChar  -- Аптека (информативно)
             , Remains           TFloat    -- Остаток (с учетом резерва)
             , RemainsAll        TFloat    -- Остаток (без учета резерва)
             , AmountDeferred    TFloat    -- резерв
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   -- DECLARE inUnitId Integer;

   DECLARE vbIndex Integer;
   -- DECLARE vbMarginCategoryId Integer;
   DECLARE vbMarginCategoryId_site Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoodsMinPrice_List'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpGoodsMinPrice_List;
    END IF;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnitMinPrice_List'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpUnitMinPrice_List;
    END IF;

    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpUnitMinPrice_List (UnitId) SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;
    -- !!!Временно!!!
    -- inUnitId:= (SELECT tmpList.UnitId FROM _tmpUnitMinPrice_List LIMIT 1);

    -- парсим товары
    vbIndex := 1;
    WHILE SPLIT_PART (inGoodsId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
           SELECT tmp.GoodsId
                , ObjectLink_Child_ALL.ChildObjectId AS GoodsId_retail
           FROM (SELECT SPLIT_PART (inGoodsId_list, ',', vbIndex) :: Integer AS GoodsId
                ) AS tmp
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_ALL ON ObjectLink_Main_ALL.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                AND ObjectLink_Main_ALL.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_ALL ON ObjectLink_Child_ALL.ObjectId = ObjectLink_Main_ALL.ObjectId
                                                                                 AND ObjectLink_Child_ALL.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                    INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Goods_Object.ChildObjectId
                                                                      AND Object_Retail.DescId = zc_Object_Retail()
          ;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;
    

    -- !!!Оптимизация!!!
    ANALYZE _tmpUnitMinPrice_List;

    -- если нет товаров
    IF NOT EXISTS (SELECT 1 FROM _tmpGoodsMinPrice_List WHERE GoodsId <> 0)
    THEN
         -- все остатки
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
           -- SELECT DISTINCT Container.ObjectId -- здесь товар "сети"
           -- !!!временно захардкодил, будет всегда товар НеБолей!!!!
           SELECT DISTINCT
                  ObjectLink_Child_NB.ChildObjectId AS ObjectID -- здесь товар "сети"
                , Container.ObjectId
           FROM _tmpUnitMinPrice_List
                INNER JOIN Container ON Container.WhereObjectId = _tmpUnitMinPrice_List.UnitId
                                    AND Container.DescId = zc_Container_Count()
                                    AND Container.Amount <> 0
                                    -- !!!временно захардкодил, будет всегда товар НеБолей!!!!
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = Container.ObjectId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                               AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                                                                AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
          ;
    END IF;


    -- !!!Оптимизация!!!
    ANALYZE _tmpGoodsMinPrice_List;

    -- еще оптимизируем - _tmpContainerCount
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCount'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpContainerCount (UnitId Integer, GoodsId Integer, GoodsId_retail Integer, Amount TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCount;
    END IF;
    --
    INSERT INTO _tmpContainerCount (UnitId, GoodsId, GoodsId_retail, Amount)
                WITH tmpContainer AS 
               (SELECT Container.WhereObjectId                AS UnitId
                     , _tmpGoodsMinPrice_List.GoodsId         AS GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail  AS GoodsId_retail
                     , SUM (Container.Amount)                 AS Amount
                FROM _tmpGoodsMinPrice_List
                     INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                         AND Container.DescId   = zc_Container_Count()
                                         AND Container.Amount   <> 0
                                         AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)


                GROUP BY Container.WhereObjectId
                       , _tmpGoodsMinPrice_List.GoodsId
                       , _tmpGoodsMinPrice_List.GoodsId_retail
                HAVING SUM (Container.Amount) > 0
               )
                -- результат
                SELECT tmpContainer.UnitId
                     , tmpContainer.GoodsId
                     , tmpContainer.GoodsId_retail
                     , tmpContainer.Amount
                FROM tmpContainer
                     -- INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = tmpContainer.UnitId
               ;

    -- !!!добавили, если нет остатка!!!
    -- INSERT INTO _tmpContainerCount (UnitId, GoodsId, GoodsId_retail, Amount)
    --    SELECT 0, tmp.GoodsId, tmp.GoodsId, 0 
    --    FROM _tmpGoodsMinPrice_List AS tmp 
    --         LEFT JOIN _tmpContainerCount ON _tmpContainerCount.GoodsId = tmp.GoodsId WHERE _tmpContainerCount.GoodsId IS NULL;

    -- !!!Оптимизация!!!
    ANALYZE _tmpContainerCount;

    -- еще оптимизируем - _tmpList
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpList'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpList (UnitId Integer, GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpList;
    END IF;
    --
    INSERT INTO _tmpList (UnitId, GoodsId, GoodsId_retail)
                -- SELECT DISTINCT _tmpContainerCount.UnitId, _tmpContainerCount.GoodsId, _tmpContainerCount.GoodsId_retail FROM _tmpContainerCount;
                SELECT DISTINCT 
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , ObjectLink_Child_R.ChildObjectId AS GoodsId_retail
                FROM _tmpGoodsMinPrice_List
                     LEFT JOIN _tmpUnitMinPrice_List ON 1=1
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                          ON ObjectLink_Unit_Juridical.ObjectId = _tmpUnitMinPrice_List.UnitId
                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                                        AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = _tmpGoodsMinPrice_List.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                              AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                               AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_R.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                ;


    -- Результат
    RETURN QUERY
       WITH tmpMI_Deferred AS
               (SELECT tmpList.UnitId
                     , MovementItem.ObjectId     AS GoodsId
                     , SUM (MovementItem.Amount) AS Amount
                FROM _tmpUnitMinPrice_List AS tmpList
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.ObjectId = tmpList.UnitId
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                     INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                ON MovementBoolean_Deferred.MovementId = MovementLinkObject_Unit.MovementId
                                               AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                               AND MovementBoolean_Deferred.ValueData = TRUE
                     INNER JOIN Movement ON Movement.Id       = MovementLinkObject_Unit.MovementId
                                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                        AND Movement.DescId   = zc_Movement_Check()
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased   = FALSE
                     -- INNER JOIN _tmpGoodsMinPrice_List ON _tmpGoodsMinPrice_List.GoodsId = MovementItem.ObjectId
                GROUP BY tmpList.UnitId
                       , MovementItem.ObjectId
               )

        SELECT Object_Goods.Id                             AS Id
             , Object_Goods.ObjectCode                     AS Article
             , ObjectFloat_Goods_Site.ValueData :: Integer AS Id_Site
             , ObjectBlob_Site.ValueData                   AS Name_Site
             , Object_Goods.ValueData                      AS Name

             , ObjectLink_Goods_Object.ChildObjectId                   AS ObjectId
             , Object.ValueData                                        AS ObjectName
             , Object_Unit.Id                                          AS UnitId
             , Object_Unit.ValueData                                   AS UnitName

             , (tmpList2.Amount /*ContainerCount.Amount*/ - COALESCE (tmpMI_Deferred.Amount, 0)) :: TFloat AS Remains
             , tmpList2.Amount /*ContainerCount.Amount*/                                         :: TFloat AS RemainsAll
             , tmpMI_Deferred.Amount                                                             :: TFloat AS AmountDeferred

        FROM _tmpList AS tmpList -- _tmpContainerCount AS tmpList -- _tmpList AS tmpList -- _tmpGoodsMinPrice_List
             -- LEFT JOIN _tmpUnitMinPrice_List ON 1=1

             LEFT JOIN tmpMI_Deferred ON tmpMI_Deferred.GoodsId = tmpList.GoodsId_retail
                                     AND tmpMI_Deferred.UnitId  = tmpList.UnitId

             LEFT JOIN _tmpContainerCount AS tmpList2
                                          ON tmpList2.GoodsId = tmpList.GoodsId
                                         AND tmpList2.UnitId  = tmpList.UnitId

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpList.UnitId AND Object_Unit.DescId = zc_Object_Unit()
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpList.GoodsId
                            
             /*LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                    ON ObjectString_Goods_Maker.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()*/

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                  ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
             LEFT JOIN Object ON Object.Id = ObjectLink_Goods_Object.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                   ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()

             LEFT JOIN ObjectBlob AS ObjectBlob_Site
                                   ON ObjectBlob_Site.ObjectId = Object_Goods.Id
                                  AND ObjectBlob_Site.DescId = zc_objectBlob_Goods_Site()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnit_ForSite_Lite (TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.08.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite_Lite (inUnitId_list:= '183292', inGoodsId_list:= '951', inSession:= zfCalc_UserSite()) ORDER BY 1;
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite_Lite (inUnitId_list:= '377613,183292', inGoodsId_list:= '331,951,16876,40618', inSession:= zfCalc_UserSite()) ORDER BY 1;
-- SELECT p.id, p.id_site, p.name, p.name_site, p.article, p.article, p.unitid, p.juridicalid, p.juridicalname, p.contractid, p.contractname, p.expirationdate, p.manufacturer, p.remains, p.price_unit, p.price_mino, p.price_mino, p.price_min, p.price_mind FROM gpSelect_GoodsOnUnit_ForSite_Lite('183292,183288,377605,375627,394426,472116,494882,1529734,1781716,377606,377595,183290,183289,183294,377613,377574,377594,377610,183293,375626,183291', '508,517,520,526,523,511,544,538,553,559,562,565,571,547,1642,1654,1714,1867,1933,2059,2095,2230,2257,2275,2323,2341,2344,2320,2509,2515', zfCalc_UserSite()) AS p ORDER BY p.price_unit

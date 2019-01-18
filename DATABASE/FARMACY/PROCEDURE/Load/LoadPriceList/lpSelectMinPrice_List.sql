-- Function: lpSelectMinPrice_List()

DROP FUNCTION IF EXISTS lpSelectMinPrice_List (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_List(
    IN inUnitId      Integer      , -- Аптека
    IN inObjectId    Integer      , -- Торговая сеть
    IN inUserId      Integer        -- пользователь
)

RETURNS TABLE (
    GoodsId            Integer,
    GoodsCode          Integer,
    GoodsName          TVarChar,
    PartionGoodsDate   TDateTime,
    Partner_GoodsId    Integer,
    Partner_GoodsCode  TVarChar,
    Partner_GoodsName  TVarChar,
    MakerName          TVarChar,
    ContractId         Integer,
    AreaId             Integer,
    JuridicalId        Integer,
    JuridicalName      TVarChar,
    Price              TFloat, 
    SuperFinalPrice    TFloat,
    isTop              Boolean,
    isOneJuridical     Boolean
   )
AS
$BODY$
  -- DECLARE vbMainJuridicalId Integer;
BEGIN

    -- Нашли у Аптеки "Главное юр лицо"
    -- SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;

     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
     THEN
         -- таблица
         CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer) ON COMMIT DROP;
         IF inUnitId = -1
         THEN
             INSERT INTO _tmpGoodsMinPrice_List (GoodsId)
               select 21157 union all select 12940 union all select 16876 union all select 351328 union all select 15661 union all select 358 union all select 40180 union all select 337 union all select 343 union all select 349 union all select 352 union all select 355 union all select 331 union all select 328 union all select 46564 union all select 17533 union all select 361 union all select 37468 union all select 334 union all select 346 union all select 340 union all select 25420 union all select 351331 union all select 36076 union all select 21169 union all select 382 union all select 376 union all select 379 union all select 385 union all select 391;
         ELSE
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId)
           -- SELECT DISTINCT Container.ObjectId -- здесь товар "сети"
            -- !!!временно захардкодил, будет всегда товар НеБолей!!!
           SELECT DISTINCT ObjectLink_Child_NB.ChildObjectId AS GoodsID -- здесь товар "сети"
           FROM Container
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = container.ObjectID
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
           WHERE Container.DescId = zc_Container_Count()
             AND Container.WhereObjectId = inUnitId
             AND Container.Amount <> 0;
         END IF;
     END IF;

    -- !!!Оптимизация!!!
    ANALYZE _tmpGoodsMinPrice_List;

    -- Результат
    RETURN QUERY
    WITH
    -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
    PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (inUserId::TVarChar))
  , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (inUserId::TVarChar))
    -- Установки для юр. лиц (для поставщика определяется договор и т.п) !!!для всех MainJuridicalId!!!
  , JuridicalSettings_all AS (SELECT tmp.JuridicalId, tmp.ContractId
                                   , tmp.isPriceClose, tmp.isSite
                                   , tmp.JuridicalSettingsId
                              FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId) AS tmp
                              WHERE tmp.isSite = TRUE -- мне нужно: я отметил какие участвуют в аукционе цены для показа на сайте, чтобы цены только этих договоров и участвовали
                              -- WHERE tmp.MainJuridicalId = vbMainJuridicalId
                             )
  /*, JuridicalSettings_close AS (SELECT DISTINCT tmp.JuridicalId, tmp.ContractId
                                FROM JuridicalSettings_all AS tmp
                                WHERE tmp.isPriceClose = TRUE
                               )*/
  , JuridicalSettings_new AS (SELECT tmp.JuridicalId, tmp.ContractId
                                   , ROW_NUMBER() OVER (PARTITION BY tmp.JuridicalId ORDER BY tmp.JuridicalId, CASE WHEN tmp.isSite = TRUE THEN 0 ELSE 1 END, tmp.ContractId) AS Ord
                                   , tmp.JuridicalSettingsId
                              FROM JuridicalSettings_all AS tmp
                              -- уже здесь ограничения
                              -- WHERE tmp.isPriceClose = FALSE -- ублал, т.к. tmp.isSite = TRUE
                             )
    -- Маркетинговый контракт
  , GoodsPromo AS (SELECT 0 AS JuridicalId
                        , 0 AS GoodsId        -- здесь товар "сети"
                        , 0 AS ChangePercent
                   /*SELECT tmp.JuridicalId
                        , tmp.GoodsId        -- здесь товар "сети"
                        , tmp.ChangePercent
                   FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp*/
                  )

    -- Выбираем в первую очередь тот что для сайта
  , JuridicalSettings AS (SELECT tmp.JuridicalId, tmp.ContractId
                               , tmp.JuridicalSettingsId
                          FROM JuridicalSettings_new AS tmp
                          -- !!!если Временно откл. - тогда будет для всех договоров!!!
                          WHERE tmp.Ord = 1
                         )
  , JuridicalSettings_list AS (SELECT DISTINCT JuridicalSettings.JuridicalId, JuridicalSettings.ContractId, JuridicalSettings.JuridicalSettingsId FROM JuridicalSettings)
      -- элементы установок юр.лиц (границы цен для бонуса)
  , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                      , tmp.Bonus
                                      , tmp.PriceLimit_min
                                      , tmp.PriceLimit
                                 FROM JuridicalSettings_list AS JuridicalSettings
                                      INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inUserId::TVarChar) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                 )
    -- Список товаров + коды ...
  , GoodsList_all AS
       (SELECT _tmpGoodsMinPrice_List.GoodsId               AS GoodsId      -- здесь товар "сети"
             , ObjectLink_LinkGoods_Main.ChildObjectId      AS GoodsId_main -- здесь "общий" товар
             , ObjectLink_LinkGoods_Child_jur.ChildObjectId AS GoodsId_jur  -- здесь товар "поставщика"
             , ObjectLink_Goods_Object_jur.ChildObjectId    AS ObjectId     -- здесь что попало - и юр.лица(поставщики) и сети и т.д.
        FROM _tmpGoodsMinPrice_List
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child
                                  ON ObjectLink_LinkGoods_Child.ChildObjectId = _tmpGoodsMinPrice_List.GoodsId
                                 AND ObjectLink_LinkGoods_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main
                                  ON ObjectLink_LinkGoods_Main.ObjectId = ObjectLink_LinkGoods_Child.ObjectId
                                 AND ObjectLink_LinkGoods_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()

            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main_jur
                                  ON ObjectLink_LinkGoods_Main_jur.ChildObjectId = ObjectLink_LinkGoods_Main.ChildObjectId
                                 AND ObjectLink_LinkGoods_Main_jur.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child_jur
                                  ON ObjectLink_LinkGoods_Child_jur.ObjectId = ObjectLink_LinkGoods_Main_jur.ObjectId
                                 AND ObjectLink_LinkGoods_Child_jur.DescId = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_Goods_Object_jur
                                  ON ObjectLink_Goods_Object_jur.ObjectId = ObjectLink_LinkGoods_Child_jur.ChildObjectId
                                 AND ObjectLink_Goods_Object_jur.DescId = zc_ObjectLink_Goods_Object()
       )
    -- Список товаров + коды ...
  , GoodsList AS
       (SELECT GoodsList_all.*
        FROM GoodsList_all
             INNER JOIN Object ON Object.Id = GoodsList_all.ObjectId
                              AND Object.DescId = zc_Object_Juridical()
       )
    -- Список цены + ТОП
  , GoodsPrice AS
       (SELECT GoodsList.GoodsId, ObjectBoolean_Top.ValueData AS isTOP
        FROM GoodsList
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                   ON ObjectLink_Price_Goods.ChildObjectId = GoodsList.GoodsId
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                   ON ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                  AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
             INNER JOIN ObjectBoolean AS ObjectBoolean_Top
                                      ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                     AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                     AND ObjectBoolean_Top.ValueData = TRUE
       )
    -- Список Последних цен (поставщика) !!!по документам!!! (т.е. последний документ а не последняя найденная цена)
  , Movement_PriceList_all AS
       (-- выбираются все !!!из списка "ObjectId"!!!
        SELECT Movement.OperDate
             , Movement.Id                                        AS MovementId
             , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
             , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
             , COALESCE (MovementLinkObject_Area.ObjectId, zc_Area_Basis()) AS AreaId
             , JuridicalSettings_list.JuridicalSettingsId
        FROM (SELECT DISTINCT ObjectId FROM GoodsList) AS tmp
             INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                           ON MovementLinkObject_Juridical.ObjectId = tmp.ObjectId
                                          AND MovementLinkObject_Juridical.DescId   = zc_MovementLinkObject_Juridical()
             INNER JOIN Movement ON Movement.Id     = MovementLinkObject_Juridical.MovementId
                                AND Movement.DescId = zc_Movement_PriceList()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                          ON MovementLinkObject_Area.MovementId = Movement.Id
                                         AND MovementLinkObject_Area.DescId     = zc_MovementLinkObject_Area()
             INNER JOIN JuridicalSettings_list ON JuridicalSettings_list.JuridicalId = MovementLinkObject_Juridical.ObjectId
                                              AND JuridicalSettings_list.ContractId  = MovementLinkObject_Contract.ObjectId
        WHERE Movement.DescId   = zc_Movement_PriceList()
          AND Movement.StatusId <> zc_Enum_Status_Erased()
       )
    -- Список Последних цен (поставщика) !!!по документам!!! (т.е. последний документ а не последняя найденная цена)
  , Movement_PriceList AS
             (-- выбираются с "макс" датой
              SELECT *
              FROM
                  (-- выбираются все !!!из списка "ObjectId"!!!
                   SELECT --  № п/п
                          ROW_NUMBER() OVER (PARTITION BY Movement_PriceList_all.AreaId, Movement_PriceList_all.JuridicalId, Movement_PriceList_all.ContractId ORDER BY Movement_PriceList_all.OperDate DESC) AS Ord
                        , Movement_PriceList_all.OperDate
                        , Movement_PriceList_all.MovementId
                        , Movement_PriceList_all.JuridicalId
                        , Movement_PriceList_all.ContractId
                        , Movement_PriceList_all.AreaId
                        , Movement_PriceList_all.JuridicalSettingsId
                   FROM Movement_PriceList_all
                  ) AS tmp
              WHERE tmp.Ord = 1 -- т.е. для договора и юр лица будет 1 документ
             ) /*AS tmp*/
        -- !!!INNER!!!
        /*INNER JOIN JuridicalSettings_list AS JuridicalSettings ON JuridicalSettings.JuridicalId = tmp.JuridicalId
                                         AND JuridicalSettings.ContractId  = tmp.ContractId*/
        /*LEFT JOIN JuridicalSettings_close ON JuridicalSettings_close.JuridicalId = tmp.JuridicalId
                                         AND JuridicalSettings_close.ContractId  = tmp.ContractId */

        /*WHERE COALESCE (JuridicalSettings.ContractId, tmp.ContractId) = tmp.ContractId -- т.е. если есть юр лицо в JuridicalSettings, тогда Movement с !!!таким же!!! ContractId, иначе - !!!ВСЕ!! Movement
          AND JuridicalSettings_close.JuridicalId IS NULL -- !!!т.е. НЕ закрыт!!!
        */
       /*)*/
    -- Последние цены (поставщика) по "нужным" товарам из GoodsList
  , MI_PriceList AS
       (SELECT Movement_PriceList.MovementId
             , Movement_PriceList.JuridicalId
             , Movement_PriceList.ContractId
             , Movement_PriceList.AreaId
             , tmpJuridicalSettingsItem.Bonus
             , tmpJuridicalSettingsItem.PriceLimit
             , MovementItem.Id         AS MovementItemId
             , MovementItem.Amount     AS Price
             , GoodsList.GoodsId      -- здесь товар "сети"
             , GoodsList.GoodsId_main -- здесь "общий" товар
             , GoodsList.GoodsId_jur  -- здесь товар "поставщика"
             , GoodsList.ObjectId     -- здесь по идее тоже самое что и в Movement_PriceList.JuridicalId
        FROM Movement_PriceList
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_PriceList.MovementId
             INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                              AND MILinkObject_Goods.ObjectId      IN (SELECT GoodsList.GoodsId_jur FROM GoodsList) -- товар "поставщика"
             LEFT JOIN GoodsList ON GoodsList.GoodsId_jur = MILinkObject_Goods.ObjectId -- товар "поставщика"
             
             LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = Movement_PriceList.JuridicalSettingsId
                                               AND MovementItem.Amount >= tmpJuridicalSettingsItem.PriceLimit_min
                                               AND MovementItem.Amount <= tmpJuridicalSettingsItem.PriceLimit
       )

    -- почти финальный список
  , FinalList AS
       (SELECT 
        ddd.GoodsId
      , ddd.GoodsCode
      , ddd.GoodsName  
      , ddd.Price
      , ddd.PartionGoodsDate
      , ddd.Partner_GoodsId
      , ddd.Partner_GoodsCode
      , ddd.Partner_GoodsName
      , ddd.MakerName
      , ddd.ContractId
      , ddd.AreaId
      , ddd.JuridicalId
      , ddd.JuridicalName 
      , ddd.Deferment
      , ddd.PriceListMovementItemId
    
      , CASE -- если Дней отсрочки по договору = 0 + ТОП-позиция учитывает % из ... (что б уравновесить ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                  THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
             -- если Дней отсрочки по договору = 0 + НЕ ТОП-позиция = учитывает % из Установки для ценовых групп (что б уравновесить ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                  THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
             -- иначе НЕ учитывает
             ELSE FinalPrice

        END :: TFloat AS SuperFinalPrice
/* */     
      , ddd.isTOP

    FROM (SELECT DISTINCT 
            -- товар "сети"
            MI_PriceList.GoodsId               AS GoodsId
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName  

            -- просто цена поставщика
          , MI_PriceList.Price
            -- минимальная цена поставщика - для товара "сети"
          , MIN (MI_PriceList.Price) OVER (PARTITION BY MI_PriceList.GoodsId) AS MinPrice
          , MI_PriceList.MovementItemId        AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

          , CASE -- если Цена поставщика >= PriceLimit (до какой цены учитывать бонус при расчете миним. цены)
                 WHEN COALESCE (MI_PriceList.PriceLimit, 0) <= MI_PriceList.Price
                    THEN MI_PriceList.Price
                         -- учитывается % бонуса из Маркетинговый контракт
                       * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                 
                 ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                      (MI_PriceList.Price * (100 - COALESCE (MI_PriceList.Bonus, 0)) / 100)
                      -- И учитывается % бонуса из Маркетинговый контракт
                    * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
            END :: TFloat AS FinalPrice

          , MI_PriceList.GoodsId_jur           AS Partner_GoodsId
          , ObjectString_Goods_Code.ValueData  AS Partner_GoodsCode
          , Object_Goods_jur_mi.ValueData      AS Partner_GoodsName
          , ObjectString_Goods_Maker.ValueData AS MakerName
          , MI_PriceList.ContractId            AS ContractId
          , MI_PriceList.AreaId                AS AreaId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (GoodsPrice.isTOP, COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) AS isTOP
        
        FROM -- Последние цены (поставщика) по "нужным" товарам из GoodsList
             MI_PriceList
             -- Срок партии товара (или Срок годности?) в Прайс-лист (поставщика)
             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId =  MI_PriceList.MovementItemId
                                       AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            -- товар "поставщика", И он есть в прайсах
            LEFT JOIN Object AS Object_Goods_jur_mi ON Object_Goods_jur_mi.Id = MI_PriceList.GoodsId_jur
            LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                   ON ObjectString_Goods_Maker.ObjectId = Object_Goods_jur_mi.Id
                                  AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   
            LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                   ON ObjectString_Goods_Code.ObjectId = Object_Goods_jur_mi.Id
                                  AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()
            -- товар "сети"
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PriceList.GoodsId
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                   AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods.Id
            -- Поставщик
            INNER JOIN Object AS Juridical ON Juridical.Id = MI_PriceList.JuridicalId -- ???тоже самое что и ObjectId???

            -- Дней отсрочки по договору
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                  ON ObjectFloat_Deferment.ObjectId = MI_PriceList.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
            -- % бонуса из Маркетинговый контракт
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MI_PriceList.GoodsId
                                AND GoodsPromo.JuridicalId = MI_PriceList.JuridicalId
       ) AS ddd
       -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту)
       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
   )

    -- отсортировали по цене + Дней отсрочки и получили первого
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId, FinalList.AreaId ORDER BY FinalList.SuperFinalPrice ASC, FinalList.Deferment DESC, FinalList.PriceListMovementItemId ASC) AS Ord
                           FROM FinalList
                          ) AS T0
                     WHERE T0.Ord = 1
                    )
    -- сколько поставщиков у товара
  , tmpCountJuridical AS (SELECT FinalList.GoodsId, FinalList.AreaId, COUNT (DISTINCT FinalList.JuridicalId) AS CountJuridical
                          FROM FinalList
                          GROUP BY FinalList.GoodsId, FinalList.AreaId
                         )
    -- Результат
    SELECT
        MinPriceList.GoodsId,
        MinPriceList.GoodsCode,
        MinPriceList.GoodsName,
        MinPriceList.PartionGoodsDate,
        MinPriceList.Partner_GoodsId,
        MinPriceList.Partner_GoodsCode,
        MinPriceList.Partner_GoodsName,
        MinPriceList.MakerName,
        MinPriceList.ContractId,
        MinPriceList.AreaId,
        MinPriceList.JuridicalId,
        MinPriceList.JuridicalName,
        MinPriceList.Price,
        MinPriceList.SuperFinalPrice,
        MinPriceList.isTop,
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END ::Boolean AS isOneJuridical
    FROM MinPriceList
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId
                                    AND tmpCountJuridical.AreaId  = MinPriceList.AreaId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_List (Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 14.01.19         * tmpJuridicalSettingsItem - теперь значения Бонус берем из Итемов
 15.04.16                                        *
*/

/*
SELECT 1, GoodsId            ,    GoodsCode          ,    GoodsName          ,    PartionGoodsDate   ,    Partner_GoodsId    ,      Partner_GoodsCode  ,    Partner_GoodsName  
  ,    MakerName          ,    ContractId         ,    JuridicalId        ,    JuridicalName, Price              ,    SuperFinalPrice, isTop,    isOneJuridical
from lpSelectMinPrice_AllGoods (183292, 4, 3) as a
where GoodsId = 376
union all
 select 2, * from lpSelectMinPrice_List (183292, 4, 3) as b where GoodsId = 376
*/
-- тест
-- SELECT * FROM lpSelectMinPrice_AllGoods (183292, 4, 3) as a join lpSelectMinPrice_List (183292, 4, 3)  as b on b.GoodsId = a.GoodsId WHERE a.Price <> b.Price
-- SELECT * FROM lpSelectMinPrice_List (183292, 4, 3) WHERE GoodsCode = 4797

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
    JuridicalId        Integer,
    JuridicalName      TVarChar,
    Price              TFloat, 
    SuperFinalPrice    TFloat,
    isTop              Boolean,
    isOneJuridical     Boolean
)

AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
BEGIN

    -- Нашли у Аптеки "Главное юр лицо"
    SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;

     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
     THEN
         -- таблица
         CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer) ON COMMIT DROP;
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId)
           SELECT DISTINCT Container.ObjectId -- здесь товар "сети"
           FROM Container
           WHERE Container.DescId = zc_Container_Count()
             AND Container.WhereObjectId = inUnitId
             AND Container.Amount <> 0;
     END IF;
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpunitminprice_list')
     THEN
        -- таблица
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer) ON COMMIT DROP;
     END IF;

    -- !!!Оптимизация!!!
    ANALYZE _tmpGoodsMinPrice_List;
    ANALYZE _tmpUnitMinPrice_List;

    -- Результат
    RETURN QUERY
    WITH
    -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
    PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inUserId::TVarChar)
                     )
    -- Установки для юр. лиц (для поставщика определяется договор и т.п)
  , JuridicalSettings_all AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus, tmp.isPriceClose, tmp.isSite
                              FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId) AS tmp
                              WHERE tmp.MainJuridicalId = vbMainJuridicalId
                             )
  , JuridicalSettings_close AS (SELECT DISTINCT tmp.JuridicalId, tmp.ContractId
                                FROM JuridicalSettings_all AS tmp
                                WHERE tmp.isPriceClose = TRUE
                               )
  , JuridicalSettings_new AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus
                                   , ROW_NUMBER() OVER (PARTITION BY tmp.JuridicalId ORDER BY tmp.JuridicalId, CASE WHEN tmp.isSite = TRUE THEN 0 ELSE 1 END, tmp.ContractId) AS Ord
                              FROM JuridicalSettings_all AS tmp
                              -- уже здесь ограничения
                              WHERE tmp.isPriceClose    = FALSE
                             )
    -- Выбираем в первую очередь тот что для сайта
  , JuridicalSettings AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus
                          FROM JuridicalSettings_new AS tmp
                          -- !!!Временно откл.!!!
                          WHERE tmp.Ord = 1
                         )
    -- Список товаров + коды ...
  , GoodsList AS
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
    -- Список Последних цен (поставщика) !!!по документам!!! (т.е. последний документ а не последняя найденная цена)
  , Movement_PriceList AS
       (-- выбираются с "нужным" договором из JuridicalSettings
        SELECT tmp.MovementId
             , tmp.JuridicalId
             , tmp.ContractId
             , COALESCE (JuridicalSettings.PriceLimit, 0) AS PriceLimit
             , COALESCE (JuridicalSettings.Bonus, 0)      AS Bonus
        FROM
       (-- выбираются с "макс" датой
        SELECT *
        FROM
       (-- выбираются все !!!из списка "ObjectId"!!!
        SELECT MAX (Movement.OperDate) OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId, COALESCE (MovementLinkObject_Contract.ObjectId, 0)) AS Max_Date
             , Movement.OperDate
             , Movement.Id                                        AS MovementId
             , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
             , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
        FROM (SELECT DISTINCT ObjectId FROM GoodsList) AS tmp
             INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                           ON MovementLinkObject_Juridical.ObjectId = tmp.ObjectId
                                          AND MovementLinkObject_Juridical.DescId   = zc_MovementLinkObject_Juridical()
             INNER JOIN Movement ON Movement.Id     = MovementLinkObject_Juridical.MovementId
                                AND Movement.DescId = zc_Movement_PriceList()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        WHERE Movement.DescId = zc_Movement_PriceList()
       ) AS tmp
        WHERE tmp.Max_Date = tmp.OperDate -- т.е. для договора и юр лица будет 1 документ
       ) AS tmp
        -- !!!INNER!!!
        LEFT JOIN (SELECT DISTINCT JuridicalSettings.JuridicalId, JuridicalSettings.ContractId, JuridicalSettings.PriceLimit, JuridicalSettings.Bonus
                   FROM JuridicalSettings
                  ) AS JuridicalSettings ON JuridicalSettings.JuridicalId = tmp.JuridicalId
        LEFT JOIN JuridicalSettings_close ON JuridicalSettings_close.JuridicalId = tmp.JuridicalId
                                         AND JuridicalSettings_close.ContractId  = tmp.ContractId 

        WHERE COALESCE (JuridicalSettings.ContractId, tmp.ContractId) = tmp.ContractId -- т.е. если есть юр лицо в JuridicalSettings, тогда Movement с !!!таким же!!! ContractId, иначе - !!!ВСЕ!! Movement
          AND JuridicalSettings_close.JuridicalId IS NULL -- !!!т.е. НЕ закрыт!!!
       )
    -- Последние цены (поставщика) по "нужным" товарам из GoodsList
  , MI_PriceList AS
       (SELECT Movement_PriceList.MovementId
             , Movement_PriceList.JuridicalId
             , Movement_PriceList.ContractId
             , Movement_PriceList.PriceLimit
             , Movement_PriceList.Bonus
             , MovementItem.Id     AS MovementItemId
             , MovementItem.Amount AS Price
             , GoodsList.GoodsId      -- здесь товар "сети"
             , GoodsList.GoodsId_main -- здесь "общий" товар
             , GoodsList.GoodsId_jur  -- здесь товар "поставщика"
             , GoodsList.ObjectId     -- здесь по идее тоже самое что и в Movement_PriceList.JuridicalId
        FROM Movement_PriceList
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_PriceList.MovementId
             INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
             INNER JOIN GoodsList ON GoodsList.GoodsId_jur = MILinkObject_Goods.ObjectId -- товар "поставщика"
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
      , ddd.JuridicalId
      , ddd.JuridicalName 
      , ddd.Deferment
      , ddd.PriceListMovementItemId

      , CASE -- если Дней отсрочки по договору = 0 или ТОП-позиция
             WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                  THEN FinalPrice
             -- иначе учитывает % из Установки для ценовых групп (что б уравновесить ... )
             ELSE FinalPrice * (100 - PriceSettings.Percent) / 100

        END :: TFloat AS SuperFinalPrice

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

          , CASE -- если ТОП-позиция или Цена поставщика >= PriceLimit (до какой цены учитывать бонус при расчете миним. цены)
                 WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE OR COALESCE (MI_PriceList.PriceLimit, 0) <= MI_PriceList.Price
                    THEN MI_PriceList.Price
                 -- иначе учитывается бонус
                 ELSE (MI_PriceList.Price * (100 - COALESCE (MI_PriceList.Bonus, 0)) / 100) :: TFloat 
            END AS FinalPrice

          , MI_PriceList.GoodsId_jur           AS Partner_GoodsId
          , ObjectString_Goods_Code.ValueData  AS Partner_GoodsCode
          , Object_Goods_jur_mi.ValueData      AS Partner_GoodsName
          , ObjectString_Goods_Maker.ValueData AS MakerName
          , MI_PriceList.ContractId            AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)      AS isTOP
        
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
            -- Поставщик
            INNER JOIN Object AS Juridical ON Juridical.Id = MI_PriceList.JuridicalId -- ???тоже самое что и ObjectId???

            -- Дней отсрочки по договору
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                  ON ObjectFloat_Deferment.ObjectId = MI_PriceList.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
       ) AS ddd
       -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту)
       LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice
   )

    -- отсортировали по цене и получили первого
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId ORDER BY FinalList.SuperFinalPrice, FinalList.PriceListMovementItemId) AS Ord
                           FROM FinalList
                          ) AS T0
                     WHERE T0.Ord = 1
                    )
    -- сколько поставщиков у товара
  , tmpCountJuridical AS (SELECT FinalList.GoodsId, COUNT (DISTINCT FinalList.JuridicalId) AS CountJuridical
                          FROM FinalList
                          GROUP BY FinalList.GoodsId
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
        MinPriceList.JuridicalId,
        MinPriceList.JuridicalName,
        MinPriceList.Price,
        MinPriceList.SuperFinalPrice,
        MinPriceList.isTop,
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END ::Boolean AS isOneJuridical
    FROM MinPriceList
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_List (Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
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

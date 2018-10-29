-- Function: lpSelectMinPrice_List_ForSite()

DROP FUNCTION IF EXISTS lpSelectMinPrice_List_ForSite ();

CREATE OR REPLACE FUNCTION lpSelectMinPrice_List_ForSite()

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
             AND Container.Amount <> 0;
     END IF;

    -- !!!Оптимизация!!!
    ANALYZE _tmpGoodsMinPrice_List;

    -- Результат
    RETURN QUERY
    WITH
      GoodsList_all AS
       (SELECT Distinct _tmpGoodsMinPrice_List.GoodsId  AS GoodsId
        FROM _tmpGoodsMinPrice_List
       )

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
        MinPriceList.isOneJuridical
    FROM GoodsList_all
         INNER JOIN MinPrice_ForSite AS MinPriceList
                                     ON GoodsList_all.GoodsId = MinPriceList.GoodsId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_List_ForSite () OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий O.В.
 23.10.18        *
*/

-- SELECT * FROM lpSelectMinPrice_List_ForSite () WHERE GoodsCode = 4797
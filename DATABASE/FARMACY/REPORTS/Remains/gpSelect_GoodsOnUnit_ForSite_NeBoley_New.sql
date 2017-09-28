-- Function: gpSelect_GoodsOnUnit_ForSite_NeBoley

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite_NeBoley (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite_NeBoley (
    IN inSession TVarChar -- сессия пользователя
)
RETURNS TABLE (GoodsId          Integer   -- идентификатор товара нашей сети
             , GoodsCode        Integer   -- код товара нашей сети
             , GoodsNameForSite TBlob     -- наименование товара для сайта
             , Price            TFloat    -- минимальная цена среди поставщиков и аптек
             , GoodsURL         TBlob     -- URL товара
              )
AS $BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

WITH tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                 FROM Object AS Object_Unit
                      JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                      ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                     AND ObjectLink_Juridical_Retail.ChildObjectId = 4 -- торговая сеть "Не болей" 
                      JOIN ObjectBoolean AS ObjectBoolean_isLeaf
                                         ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                        AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf() 
                                        AND ObjectBoolean_isLeaf.ValueData = TRUE
                 WHERE Object_Unit.DescId = zc_Object_Unit()
                )
   , tmpUnitPrice AS (SELECT tmpUnit.UnitId
                           , ObjectLink_Price_Goods.ChildObjectId AS GoodsId
                           , ObjectFloat_Price_Value.ValueData    AS Price
                      FROM tmpUnit
                           JOIN ObjectLink AS ObjectLink_Price_Unit
                                           ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                          AND ObjectLink_Price_Unit.ChildObjectId = tmpUnit.UnitId
                           JOIN ObjectLink AS ObjectLink_Price_Goods
                                           ON ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                          AND ObjectLink_Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                           JOIN ObjectLink AS ObjectLink_Goods_Object
                                           ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                          AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
                           JOIN ObjectFloat AS ObjectFloat_Price_Value
                                            ON ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                           AND ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                     )
   , tmpRemains AS (SELECT Container.ObjectId               AS GoodsId
                         , MIN (tmpUnitPrice.Price)::TFloat AS Price
                    FROM Container
                         JOIN tmpUnitPrice ON tmpUnitPrice.UnitId = Container.WhereObjectId
                                          AND tmpUnitPrice.GoodsId = Container.ObjectId 
                    WHERE Container.DescId = zc_Container_Count()
                      AND Container.Amount <> 0
                    GROUP BY Container.ObjectId
                   )
   , tmpMovementPriceListLast AS (SELECT Movement_PriceList.Id AS MovementId
                                       , ROW_NUMBER() OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId ORDER BY Movement_PriceList.OperDate DESC) AS RowNum
                                  FROM Movement AS Movement_PriceList
                                       JOIN MovementLinkObject AS MovementLinkObject_Juridical 
                                                               ON MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                              AND MovementLinkObject_Juridical.MovementId = Movement_PriceList.Id 
                                       JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical
                                                       ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()
                                                      AND ObjectLink_JuridicalSettings_Juridical.ChildObjectId = MovementLinkObject_Juridical.ObjectId
                                       JOIN ObjectLink AS ObjectLink_JuridicalSettings_Retail
                                                       ON ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                                                      AND ObjectLink_JuridicalSettings_Retail.ObjectId = ObjectLink_JuridicalSettings_Juridical.ObjectId
                                                      AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = 4 
                                       JOIN ObjectBoolean AS ObjectBoolean_JuridicalSettings_Site
                                                          ON ObjectBoolean_JuridicalSettings_Site.DescId = zc_ObjectBoolean_JuridicalSettings_Site()
                                                         AND ObjectBoolean_JuridicalSettings_Site.ObjectId = ObjectLink_JuridicalSettings_Juridical.ObjectId
                                                         AND ObjectBoolean_JuridicalSettings_Site.ValueData = TRUE
                                  WHERE Movement_PriceList.DescId = zc_Movement_PriceList()
                                    AND Movement_PriceList.StatusId <> zc_Enum_Status_Erased()
                                 )
   , tmpMovementPriceList AS (SELECT MovementId FROM tmpMovementPriceListLast WHERE RowNum = 1)
   , tmpPriceList AS (SELECT ObjectLink_Goods_Object.ObjectId  AS GoodsId
                           , MIN (MI_PriceList.Amount)::TFloat AS Price
                      FROM tmpMovementPriceList
                           JOIN MovementItem AS MI_PriceList
                                             ON MI_PriceList.DescId = zc_MI_Master()
                                            AND MI_PriceList.MovementId = tmpMovementPriceList.MovementId  
                           JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                       ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                      AND MILinkObject_Goods.MovementItemId = MI_PriceList.Id
                           JOIN ObjectLink AS ObjectLink_LinkGoods_Goods_Jur
                                           ON ObjectLink_LinkGoods_Goods_Jur.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          AND ObjectLink_LinkGoods_Goods_Jur.ChildObjectId = MILinkObject_Goods.ObjectId
                           JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain_Jur
                                           ON ObjectLink_LinkGoods_GoodsMain_Jur.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                          AND ObjectLink_LinkGoods_GoodsMain_Jur.ObjectId = ObjectLink_LinkGoods_Goods_Jur.ObjectId
                           JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                           ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                          AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_LinkGoods_GoodsMain_Jur.ChildObjectId
                           JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                           ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          AND ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                           JOIN ObjectLink AS ObjectLink_Goods_Object
                                           ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                          AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
                      GROUP BY ObjectLink_Goods_Object.ObjectId
                     )
   , tmpAll AS (SELECT tmpRemains.GoodsId
                     , tmpRemains.Price
                FROM tmpRemains
                UNION
                SELECT tmpPriceList.GoodsId
                     , tmpPriceList.Price
                FROM tmpPriceList
               )
SELECT tmpAll.GoodsId
     , MIN (tmpAll.Price)::TFloat AS Price
FROM tmpAll
GROUP BY tmpAll.GoodsId

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 30.08.17                                                        *
*/

-- тест
-- SELECT DISTINCT * FROM gpSelect_GoodsOnUnit_ForSite_NeBoley (inSession:= zfCalc_UserSite());

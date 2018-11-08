-- Function: gpSelect_MovementItem_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_UnnamedEnterprises (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_UnnamedEnterprises(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsNameUkr TVarChar
             , NDSKindId Integer, NDSKindCode Integer, NDSKindName TVarChar
             , Amount TFloat, AmountRemains TFloat, AmountOrder TFloat
             , Price TFloat, Summ TFloat, SummOrder TFloat
             , CodeUKTZED TVarChar, ExchangeId Integer, ExchangeCode Integer, ExchangeName TVarChar
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbObjectId Integer;
    DECLARE vbMarginCategoryId_site Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_UnnamedEnterprises());
    vbUserId:= lpGetUserBySession (inSession);
    vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');

    -- определяется подразделение
    SELECT MovementLinkObject_Unit.ObjectId
    INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_Unit
    WHERE MovementLinkObject_Unit.MovementId = inMovementId
      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

    -- Результат
    IF inShowAll THEN

      -- поиск категории для сайта
      vbMarginCategoryId_site:= (SELECT ObjectBoolean.ObjectId
                                 FROM ObjectBoolean
                                 WHERE ObjectBoolean.ValueData = TRUE
                                   AND ObjectBoolean.DescId = zc_ObjectBoolean_MarginCategory_Site()
                                 LIMIT 1
                                );

      IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
      THEN
          -- таблица
          CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
      ELSE
          DELETE FROM _tmpGoodsMinPrice_List;
      END IF;

      INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
      SELECT DISTINCT LinkGoodsObject.GoodsId
                   ,  LoadPriceListItem.GoodsId
                            FROM LoadPriceList

                               INNER JOIN LoadPriceListItem ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                               LEFT JOIN (SELECT DISTINCT JuridicalId, ContractId, isPriceClose
                                         FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId)) AS JuridicalSettings
                                                                                                    ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                                                                                                   AND JuridicalSettings.ContractId = LoadPriceList.ContractId

                               LEFT JOIN Object_Goods_Main_View AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId

                               LEFT JOIN Object_LinkGoods_View AS LinkGoodsObject ON LinkGoodsObject.GoodsMainId = Object_Goods.Id
                                                              AND LinkGoodsObject.ObjectId = vbObjectId

                            WHERE COALESCE(JuridicalSettings.isPriceClose, FALSE) <> TRUE
                              AND (LoadPriceList.AreaId = 0 OR LoadPriceList.AreaId =
                                  COALESCE ((SELECT OL_Unit_Area.ChildObjectId FROM ObjectLink AS OL_Unit_Area
                                             WHERE OL_Unit_Area.ObjectId = vbUnitId
                                               AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()), zc_Area_Basis()));


      -- еще оптимизируем -tmpMinPrice_List
      IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMinPrice_List'))
      THEN
          -- таблица
          CREATE TEMP TABLE tmpMinPrice_List (GoodsId            Integer,
                                              Price              TFloat
                                             ) ON COMMIT DROP;
      ELSE
          DELETE FROM tmpMinPrice_List;
      END IF;

      INSERT INTO tmpMinPrice_List (GoodsId, Price)
      SELECT tmp.GoodsId, tmp.Price
      FROM lpSelectMinPrice_List (inUnitId  := 0          -- !!!т.к. не зависит от UnitId, хотя ...!!!
                                , inObjectId:= vbObjectId
                                , inUserId  := vbUserId
                                 ) AS tmp
      WHERE tmp.AreaId = zc_Area_Basis();

        -- Результат такой
        RETURN QUERY
            WITH
               tmpRemains AS(SELECT Container.ObjectId                  AS GoodsId
                                   , SUM(Container.Amount)::TFloat       AS Amount
                              FROM Container
                              WHERE Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.Amount <> 0
                              GROUP BY Container.ObjectId
                              HAVING SUM(Container.Amount)<>0
                              )
             , MovementItem_UnnamedEnterprises AS (SELECT
                                          MovementItem.Id                    AS Id
                                        , MovementItem.ObjectId              AS GoodsId
                                        , MovementItem.Amount                AS Amount
                                        , MIFloat_Price.ValueData            AS Price
                                        , MIFloat_Summ.ValueData             AS Summ
                                           , MIFloat_AmountOrder.ValueData      AS AmountOrder
                                           , MIFloat_SummOrder.ValueData        AS SummOrder
                                           , MovementItem.isErased              AS isErased
                                      FROM  MovementItem
                                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                     
                                          LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                                      ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                                                     
                                          LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                                                      ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()

                                          LEFT JOIN MovementItemFloat AS MIFloat_SummOrder
                                                                      ON MIFloat_SummOrder.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_SummOrder.DescId = zc_MIFloat_SummOrder()
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId = zc_MI_Master()
                                       AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                    )
             , MarginCategory_Unit AS (SELECT tmp.UnitId
                                            , tmp.MarginCategoryId
                                       FROM (SELECT tmpList.UnitId
                                                  , ObjectLink_MarginCategory.ChildObjectId AS MarginCategoryId
                                                  , ROW_NUMBER() OVER (PARTITION BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId
                                                    ORDER BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId) AS Ord
                                             FROM (select vbUnitId as UnitId) AS tmpList
                                                 INNER JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                                                                       ON ObjectLink_MarginCategoryLink_Unit.ChildObjectId = tmpList.UnitId
                                                                      AND ObjectLink_MarginCategoryLink_Unit.DescId        = zc_ObjectLink_MarginCategoryLink_Unit()
                                                 LEFT JOIN ObjectLink AS ObjectLink_MarginCategory
                                                                      ON ObjectLink_MarginCategory.ObjectId = ObjectLink_MarginCategoryLink_Unit.ObjectId
                                                                     AND ObjectLink_MarginCategory.DescId   = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                                                 LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                                                       ON ObjectFloat_Percent.ObjectId = ObjectLink_MarginCategory.ChildObjectId
                                                                      AND ObjectFloat_Percent.DescId   = zc_ObjectFloat_MarginCategory_Percent()
                                             WHERE COALESCE (ObjectFloat_Percent.ValueData, 0) = 0 -- !!!вот так криво!!!
                                             ) AS tmp
                                       WHERE tmp.Ord = 1 -- !!!только одна категория!!!
                                       )
             , MarginCategory_all AS (SELECT DISTINCT
                                         tmp.UnitId
                                       , tmp.MarginCategoryId
                                       , ObjectFloat_MarginPercent.ValueData AS MarginPercent
                                       , ObjectFloat_MinPrice.ValueData      AS MinPrice
                                       , ROW_NUMBER() OVER (PARTITION BY tmp.UnitId, tmp.MarginCategoryId
                                         ORDER BY tmp.UnitId, tmp.MarginCategoryId, ObjectFloat_MinPrice.ValueData) AS ORD
                                      FROM (SELECT MarginCategory_Unit.UnitId, MarginCategory_Unit.MarginCategoryId FROM MarginCategory_Unit
                                      UNION ALL
                                      SELECT 0 AS UnitId, vbMarginCategoryId_site AS MarginCategoryId) AS tmp
                                        INNER JOIN ObjectLink AS ObjectLink_MarginCategoryItem_MarginCategory
                                                              ON ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId = tmp.MarginCategoryId
                                                             AND ObjectLink_MarginCategoryItem_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory()
                                        INNER JOIN Object ON Object.Id = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                                         AND Object.isErased = FALSE
                                        LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                              ON ObjectFloat_MinPrice.ObjectId =ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                                             AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                                        LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                                              ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                                             AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()

                                      )
             , MarginCategory_site AS (SELECT DISTINCT
                                              MarginCategory_all.MarginPercent
                                            , MarginCategory_all.MinPrice
                                            , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice
                                       FROM MarginCategory_all
                                             LEFT JOIN MarginCategory_all AS MarginCategory_all_next
                                                                          ON MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                         AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                                       WHERE MarginCategory_all.MarginCategoryId = vbMarginCategoryId_site
                                       )

            SELECT COALESCE(MovementItem_UnnamedEnterprises.Id,0)       AS Id
                 , Object_Goods.Id                                      AS GoodsId
                 , Object_Goods.ObjectCode                              AS GoodsCode
                 , Object_Goods.ValueData                               AS GoodsName
                 , ObjectString_Goods_NameUkr.ValueData                 AS GoodsNameUkr

                 , ObjectLink_Goods_NDSKind.ChildObjectId               AS NDSKindId
                 , Object_NDSKind.ObjectCode                            AS NDSKindCode
                 , Object_NDSKind.ValueData                             AS NDSKindName

                 , MovementItem_UnnamedEnterprises.Amount               AS Amount
                 , tmpRemains.Amount::TFloat                            AS AmountRemains
                 , MovementItem_UnnamedEnterprises.AmountOrder::TFloat  AS AmountOrder
                 , COALESCE(MovementItem_UnnamedEnterprises.Price,
                   ROUND (tmpPrice.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) *
                   (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 1) :: TFloat)    AS Price
                 , MovementItem_UnnamedEnterprises.Summ                 AS Summ
                 , MovementItem_UnnamedEnterprises.SummOrder            AS SummOrder

                 , ObjectString_Goods_CodeUKTZED.ValueData              AS CodeUKTZED

                 , Object_Exchange.Id                                   AS ExchangeId
                 , Object_Exchange.ObjectCode                           AS ExchangeCode
                 , Object_Exchange.ValueData                            AS ExchangeName

                 , COALESCE(MovementItem_UnnamedEnterprises.IsErased,FALSE)           AS isErased
            FROM _tmpGoodsMinPrice_List as tmpGoods

                FULL OUTER JOIN MovementItem_UnnamedEnterprises ON tmpGoods.GoodsId = MovementItem_UnnamedEnterprises.GoodsId

                LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                      ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                       ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

                LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                       ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                     ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()
                LEFT JOIN Object AS Object_Exchange ON Object_Exchange.Id = ObjectLink_Goods_Exchange.ChildObjectId

                LEFT JOIN tmpMinPrice_List AS tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId

                LEFT JOIN MarginCategory_site ON tmpPrice.Price >= MarginCategory_site.MinPrice AND tmpPrice.Price < MarginCategory_site.MaxPrice
            WHERE Object_Goods.isErased = FALSE
               OR MovementItem_UnnamedEnterprises.id is not null;
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                tmpRemains AS (SELECT Container.ObjectId                  AS GoodsId
                                    , SUM(Container.Amount)::TFloat       AS Amount
                               FROM Container
                               WHERE Container.DescId = zc_Container_Count()
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.Amount <> 0
                               GROUP BY Container.ObjectId
                               HAVING SUM(Container.Amount)<>0
                              )
              , MovementItem_UnnamedEnterprises AS (SELECT MovementItem.Id                    AS Id
                                           , MovementItem.ObjectId              AS GoodsId
                                           , MovementItem.Amount                AS Amount
                                           , MIFloat_Price.ValueData            AS Price
                                           , MIFloat_Summ.ValueData             AS Summ
                                           , MIFloat_AmountOrder.ValueData      AS AmountOrder
                                           , MIFloat_SummOrder.ValueData        AS SummOrder
                                           , MovementItem.isErased              AS isErased
                                      FROM  MovementItem
                                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                     
                                          LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                                      ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                                                     
                                          LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                                                      ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()

                                          LEFT JOIN MovementItemFloat AS MIFloat_SummOrder
                                                                      ON MIFloat_SummOrder.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_SummOrder.DescId = zc_MIFloat_SummOrder()

                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId = zc_MI_Master()
                                        AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                      )

            SELECT
                   MovementItem_UnnamedEnterprises.Id          AS Id
                 , Object_Goods.Id                                      AS GoodsId
                 , Object_Goods.ObjectCode                              AS GoodsCode
                 , Object_Goods.ValueData                               AS GoodsName
                 , ObjectString_Goods_NameUkr.ValueData                 AS GoodsNameUkr

                 , ObjectLink_Goods_NDSKind.ChildObjectId               AS NDSKindId
                 , Object_NDSKind.ObjectCode                            AS NDSKindCode
                 , Object_NDSKind.ValueData                             AS NDSKindName

                 , MovementItem_UnnamedEnterprises.Amount               AS Amount
                 , tmpRemains.Amount::TFloat                            AS AmountRemains
                 , MovementItem_UnnamedEnterprises.AmountOrder::TFloat  AS AmountOrder
                 , MovementItem_UnnamedEnterprises.Price                AS Price
                 , MovementItem_UnnamedEnterprises.Summ                 AS Summ
                 , MovementItem_UnnamedEnterprises.SummOrder            AS SummOrder

                 , ObjectString_Goods_CodeUKTZED.ValueData              AS CodeUKTZED

                 , Object_Exchange.Id                                   AS ExchangeId
                 , Object_Exchange.ObjectCode                           AS ExchangeCode
                 , Object_Exchange.ValueData                            AS ExchangeName

                 , MovementItem_UnnamedEnterprises.IsErased    AS isErased
            FROM MovementItem_UnnamedEnterprises

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem_UnnamedEnterprises.GoodsId

                LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_UnnamedEnterprises.GoodsId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                       ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

                LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                       ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                     ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()
                LEFT JOIN Object AS Object_Exchange ON Object_Exchange.Id = ObjectLink_Goods_Exchange.ChildObjectId;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 30.09.18         *
*/
-- select * from gpSelect_MovementItem_UnnamedEnterprises(inMovementId := 10582538  , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
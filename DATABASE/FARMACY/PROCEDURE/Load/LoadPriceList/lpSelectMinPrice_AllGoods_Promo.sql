-- Function: lpSelectMinPrice_AllGoods()

DROP FUNCTION IF EXISTS lpSelectMinPrice_AllGoods_Promo (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_AllGoods_Promo(
    IN inUnitId      Integer      , -- ������
    IN inObjectId    Integer      , -- �������� ����
    IN inUserId      Integer        -- ������ ������������
)

RETURNS TABLE (
    GoodsId            Integer,
    GoodsId_retail     Integer,
    GoodsCode          Integer,
    GoodsName          TVarChar,
    Remains            TFloat,
    MaxPriceIncome     TFloat,
    MidPriceSale       TFloat,
    MinExpirationDate  TDateTime,
    PartionGoodsDate   TDateTime,
    Price              TFloat,
    SuperFinalPrice    TFloat,
    isTop              Boolean,
    isTOP_Price        Boolean,
    isOneJuridical     Boolean,
    PercentMarkup      TFloat,
    PromoNumber        TVarChar,
    JuridicalList      TBlob
)

AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
  DECLARE vbCostCredit TFloat;
BEGIN

    -- !!!�������� �������� � ���������� ��������!!!
    inObjectId:= ABS (inObjectId);

    -- ����� � ������ "������� �� ����"
    SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;

     -- �������� �������� ��������� % ��������� �������
     vbCostCredit := COALESCE ((SELECT COALESCE (ObjectFloat_SiteDiscount.ValueData, 0)          :: TFloat    AS SiteDiscount
                                FROM Object AS Object_GlobalConst
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_SiteDiscount
                                                              ON ObjectBoolean_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                                             AND ObjectBoolean_SiteDiscount.DescId = zc_ObjectBoolean_GlobalConst_SiteDiscount()
                                                             AND ObjectBoolean_SiteDiscount.ValueData = TRUE
                                     INNER JOIN ObjectFloat AS ObjectFloat_SiteDiscount
                                                           ON ObjectFloat_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                                          AND ObjectFloat_SiteDiscount.DescId = zc_ObjectFloat_GlobalConst_SiteDiscount()
                                                          AND COALESCE (ObjectFloat_SiteDiscount.ValueData, 0) <> 0
                                WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
                                  AND Object_GlobalConst.Id =zc_Enum_GlobalConst_CostCredit()
                                )
                                , 0)  :: TFloat;

    -- !!!�����������!!!
    ANALYZE ObjectLink;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remains'))
    THEN
      DROP TABLE _tmpMinPrice_Remains;
    END IF;

    -- ������� - �����������
    CREATE TEMP TABLE _tmpMinPrice_Remains ON COMMIT DROP AS
       (WITH
       tmp AS
           (SELECT Container.ObjectId
             , Container.Id
             , Container.Amount
        FROM
            Container
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId = inUnitId
          AND Container.Amount <> 0
            )
     ,  tmpContainer AS
       (SELECT Container.ObjectId AS ObjectId_retail -- ����� ����� "����"
             , Container.Amount
             , Object_PartionMovementItem.ObjectCode ::Integer AS MI_Partion
        FROM tmp AS Container
            LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                ON CLO_PartionMovementItem.ContainerId = Container.Id
                                               AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem
                                   ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
        )
     , tmpMI_Float AS (SELECT *
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpContainer.MI_Partion FROM tmpContainer)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_PriceSale(), zc_MIFloat_Price())
                       )
     , tmpRemains AS
       (SELECT
            Container.ObjectId_retail -- ����� ����� "����"
          , SUM (Container.Amount)       AS Amount
          , MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()))  AS MinExpirationDate -- ���� ��������
          , SUM (Container.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0)) / SUM (Container.Amount) AS MidPriceSale -- !!! ������� ���� ����. � ���!!!
          , MAX (COALESCE (MIFloat_Income_Price.ValueData, 0)) AS MaxPriceIncome
        FROM tmpContainer AS Container
             LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                              ON MIDate_ExpirationDate.MovementItemId = Container.MI_Partion
                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
             -- ���� ����. � ���
             LEFT JOIN tmpMI_Float AS MIFloat_PriceSale
                                         ON MIFloat_PriceSale.MovementItemId = Container.MI_Partion
                                        AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

             LEFT OUTER JOIN tmpMI_Float AS MIFloat_Income_Price
                                               ON MIFloat_Income_Price.MovementItemId = Container.MI_Partion
                                              AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
        GROUP BY Container.ObjectId_retail
        HAVING SUM (Container.Amount) > 0
       )

        --
        SELECT
            ObjectLink_Child_NB.ChildObjectId         AS ObjectID           -- !!!�������� �����������, ����� ������ ����� �������!!!
          , tmpRemains.ObjectId_retail                                      -- ����� ����� "����"
          , tmpRemains.Amount ::TFloat                AS Amount
          , tmpRemains.MinExpirationDate :: TDateTime AS MinExpirationDate  -- ���� ��������
          , tmpRemains.MidPriceSale       -- !!! ������� ���� ����. � ���!!!
          , tmpRemains.MaxPriceIncome     -- !!! ������������ ���� �������
        FROM tmpRemains
                                    -- !!!�������� �����������, ����� ������ ����� �������!!!!
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmpRemains.ObjectId_retail
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
       );

    ANALYZE _tmpMinPrice_Remains;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remainslist'))
    THEN
      DROP TABLE _tmpMinPrice_RemainsList;
    END IF;

 --RAISE EXCEPTION '<%>', (select count(*) from _tmpMinPrice_Remains);

    -- ������� + ���� ...
    CREATE TEMP TABLE _tmpMinPrice_RemainsList ON COMMIT DROP AS
       (SELECT
            _tmpMinPrice_Remains.ObjectId,                  -- ����� ����� "����"
            _tmpMinPrice_Remains.ObjectId_retail,           -- ����� ����� "����"
            Object_LinkGoods_View.GoodsMainId, -- ����� "�����" �����
            PriceList_GoodsLink.GoodsId,       -- ����� ����� "����������"
            _tmpMinPrice_Remains.Amount,
            _tmpMinPrice_Remains.MinExpirationDate,
            _tmpMinPrice_Remains.MidPriceSale,
            _tmpMinPrice_Remains.MaxPriceIncome
        FROM _tmpMinPrice_Remains
            INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = _tmpMinPrice_Remains.objectid -- ����� ������ ���� � �����
            LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- ����� ������ � ������ � ������� �������
                                            ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
       );

    ANALYZE _tmpMinPrice_RemainsList;
--RAISE notice '<%>', (select count(*) from _tmpMinPrice_RemainsList);
-- RAISE EXCEPTION '<%>      <%>', (select count(*) from Remains), (select count(*) from _tmpMinPrice_RemainsList);

--RAISE EXCEPTION '<%>', (select count(*) from _tmpMinPrice_RemainsList);

    -- ���������
    RETURN QUERY
    WITH
    -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����) !!!������ ���� ������������ ObjectId!!!
    PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (inUserId::TVarChar))
  , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (inUserId::TVarChar))

    -- ��������� ��� ��. ��� (��� ���������� ������������ ������� � �.�)
  , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId)
                         )
    -- �������� ��������� ��.��� (������� ��� ��� ������)
  , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                      , tmp.Bonus
                                      , tmp.PriceLimit_min
                                      , tmp.PriceLimit
                                 FROM JuridicalSettings
                                      INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inUserId::TVarChar) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                 WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                 )

    -- ������������� ��������
  , GoodsPromoAll AS (SELECT tmp.JuridicalId
                           , tmp.GoodsId        -- ����� ����� "����"
                           , Object_Maker.ValueData                                       AS PromoNumber
                      FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp
                           LEFT JOIN Object AS Object_Maker ON Object_Maker.ID = tmp.MakerID 
                      WHERE COALESCE(tmp.JuridicalId, 0) <> 0
                     )
  , GoodsPromo AS (SELECT GoodsPromoAll.JuridicalId
                        , GoodsPromoAll.GoodsId        -- ����� ����� "����"
                        , GoodsPromoAll.PromoNumber                                                  AS PromoNumber
                        , CASE WHEN GoodsPromoAll.JuridicalId = 59612 THEN 1.75 ELSE 0 END :: TFloat AS ChangePercent
                   FROM GoodsPromoAll
                   UNION ALL
                   SELECT tmp.JuridicalId
                        , _tmpMinPrice_Remains.ObjectId
                        , NULL::TVarChar                                                   AS PromoNumber
                        , CASE WHEN tmp.JuridicalId = 59612 THEN 1.75 ELSE 0 END :: TFloat AS ChangePercent
                   FROM _tmpMinPrice_Remains
                        LEFT JOIN (SELECT DISTINCT LastPriceList_find_View.JuridicalId FROM LastPriceList_find_View) AS tmp ON 1 = 1
                   WHERE _tmpMinPrice_Remains.ObjectId NOT IN (SELECT GoodsPromoAll.GoodsId FROM GoodsPromoAll)
                   )
    -- ������ ���� + ��� + % �������
  , GoodsPrice AS
       (SELECT _tmpMinPrice_RemainsList.GoodsId
             , COALESCE (ObjectBoolean_Top.ValueData, FALSE) AS isTOP
             , COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
        FROM _tmpMinPrice_RemainsList
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                   -- ON ObjectLink_Price_Goods.ChildObjectId = _tmpMinPrice_RemainsList.GoodsId
                                   ON ObjectLink_Price_Goods.ChildObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                   ON ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                  AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                     ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                     -- ON ObjectBoolean_Top.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                    AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
             LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                   ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Goods.ObjectId
                                   -- ON ObjectFloat_PercentMarkup.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                  AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
        WHERE ObjectBoolean_Top.ValueData = TRUE OR ObjectFloat_PercentMarkup.ValueData <> 0
       )

  , tmpJuridicalArea AS (SELECT DISTINCT
                                tmp.UnitId                   AS UnitId
                              , tmp.JuridicalId              AS JuridicalId
                              , tmp.AreaId_Juridical         AS AreaId
                              , tmp.AreaName_Juridical       AS AreaName
                         FROM lpSelect_Object_JuridicalArea_byUnit (inUnitId, 0) AS tmp
                         )
  , tmpPrice_RemainsPrice as (SELECT
            _tmpMinPrice_RemainsList.ObjectId
          , _tmpMinPrice_RemainsList.ObjectId_retail
          , _tmpMinPrice_RemainsList.Amount                   AS Remains
          , _tmpMinPrice_RemainsList.MinExpirationDate        AS MinExpirationDate
          , _tmpMinPrice_RemainsList.MidPriceSale             AS MidPriceSale
          , _tmpMinPrice_RemainsList.MaxPriceIncome           AS MaxPriceIncome
            -- ������ ���� ����������
          , PriceList.Amount                    AS Price

          , PriceList.Id                        AS PriceListMovementItemId
          , PriceList.MovementId                AS PriceListMovementId

          , MILinkObject_Goods.ObjectId         AS Partner_GoodsId
          , LastPriceList_find_View.ContractId  AS ContractId
          , LastPriceList_find_View.JuridicalId AS JuridicalId

          , tmpJuridicalArea.AreaId             AS AreaId
          , tmpJuridicalArea.AreaName           AS AreaName

          , ROW_NUMBER()OVER(PARTITION BY PriceList.ObjectId, PriceList.MovementId ORDER BY PriceList.Amount DESC) as ORD

        FROM -- ������� + ���� ...
             _tmpMinPrice_RemainsList

             -- ������ � �����-����� (����������)
             JOIN MovementItemLinkObject AS MILinkObject_Goods
                                         ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                        AND MILinkObject_Goods.ObjectId = _tmpMinPrice_RemainsList.GoodsId  -- ����� "����������"

             -- �����-���� (����������) - MovementItem
            JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
             -- �����-���� (����������) - Movement
            JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

            JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = LastPriceList_find_View.JuridicalId
                                 AND tmpJuridicalArea.AreaId      = LastPriceList_find_View.AreaId
       )

  , tmpMinPrice_RemainsPrice as (SELECT
            tmpPrice_RemainsPrice.ObjectId                 AS GoodsId
          , tmpPrice_RemainsPrice.ObjectId_retail          AS GoodsId_retail
          , Goods.GoodsCodeInt                             AS GoodsCode
          , Goods.GoodsName                                AS GoodsName
          , tmpPrice_RemainsPrice.Remains                  AS Remains
          , tmpPrice_RemainsPrice.MinExpirationDate        AS MinExpirationDate
          , tmpPrice_RemainsPrice.MidPriceSale             AS MidPriceSale
          , tmpPrice_RemainsPrice.MaxPriceIncome           AS MaxPriceIncome
          , tmpPrice_RemainsPrice.PriceListMovementId      AS PriceListMovementId
          , tmpPrice_RemainsPrice.Price                    AS Price
          , MIDate_PartionGoods.ValueData                  AS PartionGoodsDate

          , CASE -- ���� ���� ���������� �� �������� � ������� ����������
                 WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                  THEN tmpPrice_RemainsPrice.Price
                       -- ����������� % ������ �� ������������� ��������
                     * (COALESCE (100 - GoodsPromo.ChangePercent, 100) / 100)

                 ELSE -- ����� ����������� ����� - ��� ���-������� ��� �� ���-�������
                    (tmpPrice_RemainsPrice.Price * (100 - COALESCE (tmpJuridicalSettingsItem.Bonus, 0)) / 100)
                     -- � ����������� % ������ �� ������������� ��������
                  * (COALESCE (100 - GoodsPromo.ChangePercent, 100) / 100)
            END :: TFloat AS FinalPrice

          , tmpPrice_RemainsPrice.Partner_GoodsId        AS Partner_GoodsId
          , Object_JuridicalGoods.GoodsCode              AS Partner_GoodsCode
          , Object_JuridicalGoods.GoodsName              AS Partner_GoodsName
          , Object_JuridicalGoods.MakerName              AS MakerName
          , tmpPrice_RemainsPrice.ContractId             AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , JuridicalSettings.isPriceClose     AS JuridicalIsPriceClose
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE) /*Goods.isTOP*/) AS isTOP
          , COALESCE (GoodsPrice.isTOP, FALSE) AS isTOP_Price
          , COALESCE (GoodsPrice.PercentMarkup, 0) AS PercentMarkup

          , tmpPrice_RemainsPrice.AreaId            AS AreaId
          , tmpPrice_RemainsPrice.AreaName          AS AreaName
          , GoodsPromo.PromoNumber                  AS PromoNumber


        FROM -- ������� + ���� ...
             tmpPrice_RemainsPrice

             -- ������������� ��������
             JOIN GoodsPromo ON GoodsPromo.GoodsId     = tmpPrice_RemainsPrice.ObjectId
                            AND GoodsPromo.JuridicalId = tmpPrice_RemainsPrice.JuridicalId

             -- ���� ������ ������ (��� ���� ��������?) � �����-���� (����������)
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  tmpPrice_RemainsPrice.PriceListMovementItemId
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

             -- ��������� ��� ��. ��� (��� ���������� ������������ ������� � �.�)
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = tmpPrice_RemainsPrice.JuridicalId
                                       AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId
                                       AND JuridicalSettings.ContractId      = tmpPrice_RemainsPrice.ContractId
            LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                              AND tmpPrice_RemainsPrice.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                              AND tmpPrice_RemainsPrice.Price <= tmpJuridicalSettingsItem.PriceLimit

            -- ����� "����������", ���� �� ���� � ������� !!!� �� ����!!!
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = tmpPrice_RemainsPrice.Partner_GoodsId
            -- ����� "����"
            LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = tmpPrice_RemainsPrice.ObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = tmpPrice_RemainsPrice.ObjectId_retail
                                   AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpPrice_RemainsPrice.ObjectId

            -- ���������
            INNER JOIN Object AS Juridical ON Juridical.Id = tmpPrice_RemainsPrice.JuridicalId

            -- ���� �������� �� ��������
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                  ON ObjectFloat_Deferment.ObjectId = tmpPrice_RemainsPrice.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

        WHERE tmpPrice_RemainsPrice.ORD = 1
          AND (COALESCE (Object_JuridicalGoods.MinimumLot, 0) = 0
               OR Object_JuridicalGoods.IsPromo                  = FALSE
              )

       )

   -- ������ �� % ��������� ������� �� �����������
  , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := inObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inUserId :: TVarChar) AS tmp)

    -- ����� ��������� ������
  , MinPriceList AS
       (SELECT
            tmpMinPrice_RemainsPrice.GoodsId
          , tmpMinPrice_RemainsPrice.GoodsId_retail
          , tmpMinPrice_RemainsPrice.GoodsCode
          , tmpMinPrice_RemainsPrice.GoodsName
          , tmpMinPrice_RemainsPrice.Remains
          , tmpMinPrice_RemainsPrice.MinExpirationDate
          , tmpMinPrice_RemainsPrice.MidPriceSale
          , tmpMinPrice_RemainsPrice.MaxPriceIncome
            -- ������ ������� ���� ����������
          , SUM(tmpMinPrice_RemainsPrice.Price) / COUNT(*)        AS Price
            -- ����������� ���� ���������� - ��� ������ "����"
          , MIN(tmpMinPrice_RemainsPrice.Price)                   AS MinPrice
          , MIN(tmpMinPrice_RemainsPrice.PartionGoodsDate)        AS PartionGoodsDate

          , SUM(tmpMinPrice_RemainsPrice.FinalPrice) / COUNT(*)   AS FinalPrice

          , tmpMinPrice_RemainsPrice.isTOP
          , tmpMinPrice_RemainsPrice.isTOP_Price
          , tmpMinPrice_RemainsPrice.PercentMarkup
          , tmpMinPrice_RemainsPrice.PromoNumber
          , string_agg(zfConvert_FloatToString(tmpMinPrice_RemainsPrice.Price)||' - '||tmpMinPrice_RemainsPrice.JuridicalName, CHR(13))::TBlob AS JuridicalList

        FROM tmpMinPrice_RemainsPrice
        WHERE  COALESCE (tmpMinPrice_RemainsPrice.JuridicalIsPriceClose, FALSE) <> TRUE
        GROUP BY tmpMinPrice_RemainsPrice.GoodsId
                 , tmpMinPrice_RemainsPrice.GoodsId_retail
                 , tmpMinPrice_RemainsPrice.GoodsCode
                 , tmpMinPrice_RemainsPrice.GoodsName
                 , tmpMinPrice_RemainsPrice.Remains
                 , tmpMinPrice_RemainsPrice.MinExpirationDate
                 , tmpMinPrice_RemainsPrice.MidPriceSale
                 , tmpMinPrice_RemainsPrice.MaxPriceIncome
                 , tmpMinPrice_RemainsPrice.isTOP
                 , tmpMinPrice_RemainsPrice.isTOP_Price
                 , tmpMinPrice_RemainsPrice.PercentMarkup
                 , tmpMinPrice_RemainsPrice.PromoNumber
       )
    -- ������� ����������� � ������
  , tmpCountJuridical AS (SELECT tmpMinPrice_RemainsPrice.GoodsId, COUNT (DISTINCT tmpMinPrice_RemainsPrice.JuridicalId) AS CountJuridical
                          FROM tmpMinPrice_RemainsPrice
                          GROUP BY tmpMinPrice_RemainsPrice.GoodsId
                         )
    -- ���������
    SELECT
        MinPriceList.GoodsId,
        MinPriceList.GoodsId_retail,
        MinPriceList.GoodsCode,
        MinPriceList.GoodsName,
        MinPriceList.Remains,
        MinPriceList.MaxPriceIncome ::TFloat,
        MinPriceList.MidPriceSale ::TFloat,
        MinPriceList.MinExpirationDate,
        MinPriceList.PartionGoodsDate :: TDateTime,
        MinPriceList.Price::TFloat,
        MinPriceList.FinalPrice::TFloat   AS SuperFinalPrice,
        MinPriceList.isTop :: Boolean AS isTop,
        MinPriceList.isTOP_Price :: Boolean AS isTOP_Price,
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END :: Boolean AS isOneJuridical,
        MinPriceList.PercentMarkup :: TFloat AS PercentMarkup,
        MinPriceList.PromoNumber,
        MinPriceList.JuridicalList
    FROM MinPriceList
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId
    ORDER BY MinPriceList.GoodsId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_AllGoods (Integer, Integer, Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
 31.10.19                                                                                      * isTopNo_Unit ������ ��� TOP ����
 07.02.19         * ���� isBonusClose = true ������ �� ���������
 14.01.19         * tmpJuridicalSettingsItem - ������ �������� ����� ����� �� ������
 11.10.17         * add area
 16.02.16         * add isOneJuridical
 03.12.15                                                                          *
 14.04.18                                                                                       *
*/

-- ����
-- SELECT * FROM lpSelectMinPrice_AllGoods (3031072, 3031066, 3) WHERE GoodsCode = 1069 -- !!!��������!!!
-- SELECT * FROM lpSelectMinPrice_AllGoods (2144918, 2140932, 3) WHERE GoodsCode = 4797 -- !!!��������!!!
-- SELECT * FROM lpSelectMinPrice_AllGoods (1781716 , 4, 3) WHERE GoodsCode = 8969 -- "������_"
-- SELECT * FROM lpSelectMinPrice_AllGoods (183292, 4, 3) WHERE GoodsCode = 8969 -- "������_1 ��_������_6"
-- SELECT * FROM lpSelectMinPrice_AllGoods (183292, 4, 3)

--
SELECT * FROM lpSelectMinPrice_AllGoods_Promo (183292, 4, 3)
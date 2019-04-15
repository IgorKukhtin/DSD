-- Function: gpSelect_AllGoodsPrice()

-- DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, Integer, TFloat, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, Integer, TFloat, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, Integer, TFloat, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AllGoodsPrice(
    -- IN inGoodsCode     Integer    -- ����� �������
    IN inUnitId        Integer     -- �������������
  , IN inUnitId_to     Integer     -- ������������� (� ������� ���� ��������� ���)
  , IN inMinPercent    TFloat      -- ����������� % ��� �������������, � ������� ��������� ���������� �� �����������
  , IN inVAT20         Boolean     -- ������������� ������ � 20% ���
  , IN inTaxTo         TFloat      -- ����������� % ��� �������������, � ������� ��������� ���������� �� �����������
  , IN inPriceMaxTo    TFloat      -- ����������� % ��� �������������, � ������� ��������� ���������� �� �����������
  , IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (
    Id                  Integer,    -- �� ������  !!!������ ����, �� ��� ��� � ������ ��������!!!
    Id_retail           Integer,    -- �� ������  !!!������ ��, �� ��� ��� � ����� ��������!!!
    Code                Integer,    -- ��� ������
    GoodsName           TVarChar,   -- ������������ ������
    LastPrice           TFloat,     -- ������� ����
    LastPrice_to        TFloat,     -- ������� ���� - inUnitId_to
    RemainsCount        TFloat,     -- �������
    RemainsCount_to     TFloat,     -- ������� - ������������� (� ������� ���� ��������� ���)
    NDS                 TFloat,     -- ������ ���
    NewPrice            TFloat,     -- ����� ����
    NewPrice_to         TFloat,     -- ����� ����
    PriceFix_Goods      TFloat  ,   -- ������������� ���� ����
    MinMarginPercent    TFloat,     -- ����������� % ����������
    PriceDiff           TFloat,     -- % ����������
    PriceDiff_to        TFloat,     -- % ���������� - inUnitId_to
    ExpirationDate      TDateTime,  -- ���� ��������
    JuridicalId         Integer,    -- ��������� Id
    JuridicalName       TVarChar,   -- ���������
    Juridical_Price     TFloat,     -- ���� � ����������
    MarginPercent       TFloat,     -- % ������� �� �����
    Juridical_GoodsName TVarChar,   -- ������������ � ����������
    ProducerName        TVarChar,   -- �������������
    ContractId          Integer,    -- ������� ��
    ContractName        TVarChar,   -- �������
    AreaId              Integer,    -- ������� ��
    AreaName            TVarChar,   -- ������
    Juridical_Percent   TFloat,     -- % ������������� ������� ����������
    Contract_Percent    TFloat,     -- % ������������� ������� ��������
    SumReprice          TFloat,     -- ����� ����������
    MidPriceSale        TFloat,     -- ������� ���� �������
    MidPriceDiff        TFloat,     -- ���������� �� ������� ���� �������
    MinExpirationDate   TDateTime,  -- ����������� ���� �������� ��������� �� �����
    MinExpirationDate_to TDateTime, -- ����������� ���� �������� ��������� �� �����  - ������������� (� ������� ���� ��������� ���)
    isOneJuridical      Boolean ,   -- ���� ��������� (��/���)
    isPriceFix          Boolean ,   -- ������������� ���� �����
    isIncome            Boolean ,   -- ������ �������
    IsTop               Boolean ,   -- ��� �����
    IsTop_Goods         Boolean ,   -- ��� ����
    IsPromo             Boolean ,   -- �����
    Reprice             Boolean     --
    )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbMarginCategoryId Integer;
  DECLARE vbMarginPercent_ExpirationDate TFloat;
  DECLARE vbInterval_ExpirationDate Interval;
BEGIN
    vbUserId := inSession;
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

    -- % ������� ��� ����� �������� < 6 ���.
    vbMarginPercent_ExpirationDate:= (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_Retail_MarginPercent() AND ObjectFloat.ObjectId = vbObjectId);
    -- 
    -- vbInterval_ExpirationDate:= zc_Interval_ExpirationDate();
    vbInterval_ExpirationDate:= '6 MONTH' :: Interval;

    --
    SELECT
        COALESCE(Object_Unit_View.MarginCategoryId,0)
    INTO
        vbMarginCategoryId
    FROM
        Object_Unit_View
    WHERE
        Object_Unit_View.Id = inUnitId;

  RETURN QUERY
    WITH DD
    AS
    (
        SELECT DISTINCT
            Object_MarginCategoryItem_View.MarginPercent,
            Object_MarginCategoryItem_View.MinPrice,
            Object_MarginCategoryItem_View.MarginCategoryId,
            ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
        FROM Object_MarginCategoryItem_View
             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                           AND Object_MarginCategoryItem.isErased = FALSE
    ),
    MarginCondition
    AS
    (
        SELECT
            D1.MarginCategoryId,
            D1.MarginPercent,
            D1.MinPrice,
            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
        FROM DD AS D1
            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
    )
  , ObjectLink_Child_NB
    AS
        (SELECT
            ObjectLink_Child.ChildObjectId,
            ObjectLink_Child_NB.ChildObjectId as ChildObjectIdNB
         FROM ObjectLink AS ObjectLink_Child
            INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                 AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                 AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                 AND ObjectLink_Goods_Object.ChildObjectId = 4
         WHERE ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods())
  , RemainsTo AS
       (SELECT
            -- !!!�������� �����������, ����� ������ ����� �������!!!
            ObjectLink_Child_NB.ChildObjectIdNB AS GoodsId         -- ����� �����
          , Container.ObjectId                  AS GoodsId_retail  -- ����� ����� "����"
          , MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- ���� ��������
          , SUM (Container.Amount)  :: TFloat   AS Amount
        FROM Container
            INNER JOIN ObjectLink_Child_NB AS ObjectLink_Child_NB
                                        ON ObjectLink_Child_NB.ChildObjectId = Container.ObjectID
            LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                ON CLO_PartionMovementItem.ContainerId = Container.Id
                                               AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN Object AS Object_PartionMovementItem
                                   ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
            LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                              ON MIDate_ExpirationDate.MovementItemId = Object_PartionMovementItem.ObjectCode
                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId = inUnitId_to
          AND Container.Amount <> 0
        GROUP BY ObjectLink_Child_NB.ChildObjectIdNB
               , Container.ObjectId
        HAVING SUM (Container.Amount) > 0
       )

    -- ������ ���-������ (��������)
  , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                   FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
                -- WHERE 1=0
                  )

  , tmpGoodsView AS (SELECT Object_Goods_View.*
                          , COALESCE (tmpGoodsSP.isSP, False)   ::Boolean AS isSP
                     FROM Object_Goods_View
                         -- �������� GoodsMainId
                         LEFT JOIN  ObjectLink AS ObjectLink_Child
                                               ON ObjectLink_Child.ChildObjectId = Object_Goods_View.Id
                                              AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                         LEFT JOIN ObjectLink AS ObjectLink_Main
                                              ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                             AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                         LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId

                         /*LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP
                                                  ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId
                                                 AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()*/

                     WHERE Object_Goods_View.ObjectId = vbObjectId
                     )

  , tmpPrice_View AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                           , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                           , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                           , Price_Goods.ChildObjectId               AS GoodsId
                           , ObjectLink_Main.ChildObjectId           AS GoodsMainId
                           , COALESCE(Price_Fix.ValueData,False)     AS Fix
                           , COALESCE(Price_Top.ValueData,False)     AS isTop
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                  ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectBoolean AS Price_Fix
                                  ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                           LEFT JOIN ObjectBoolean AS Price_Top
                                  ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()

                           -- �������� GoodsMainId
                           LEFT JOIN  ObjectLink AS ObjectLink_Child
                                                 ON ObjectLink_Child.ChildObjectId = Price_Goods.ChildObjectId
                                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                           LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId IN (inUnitId_to, inUnitId)
                      )

  , ResultSet AS
    (
        SELECT
            SelectMinPrice_AllGoods.GoodsId AS Id,
            SelectMinPrice_AllGoods.GoodsId_retail AS Id_retail,
            SelectMinPrice_AllGoods.GoodsCode AS Code,
            SelectMinPrice_AllGoods.GoodsName AS GoodsName,
            Object_Price.Price                AS LastPrice,
            Object_Price_to.Price             AS LastPrice_to,
            ROUND (Object_Price_to.Price * (1 + CASE WHEN Object_Price_to.Price >= inPriceMaxTo AND inPriceMaxTo > 0 THEN 0 ELSE inTaxTo END / 100), 1) :: TFloat AS NewPrice_to,
            Object_Price.Fix                  AS isPriceFix,
            SelectMinPrice_AllGoods.Remains   AS RemainsCount,
            RemainsTo.Amount                  AS RemainsCount_to,
            Object_Goods.NDS                  AS NDS
          , CASE WHEN SelectMinPrice_AllGoods.isTop = TRUE
                      THEN COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), COALESCE (Object_Goods.PercentMarkup, 0)) /*- COALESCE(ObjectFloat_Juridical_Percent.ValueData, 0)*/

                 ELSE CASE -- % ������� ��� ����� �������� < 6 ���.
                           WHEN vbMarginPercent_ExpirationDate > 0
                            AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                            AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                            AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                            AND COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                THEN vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                           -- % ������� ��� ����� �������� < 6 ���.
                           WHEN vbMarginPercent_ExpirationDate > 0
                            AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                            AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                            AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                THEN vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)

                           WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                THEN COALESCE (MarginCondition.MarginPercent,0) + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)

                           ELSE COALESCE (MarginCondition.MarginPercent,0) + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)
                      END
            END::TFloat AS MarginPercent
          , (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)::TFloat AS Juridical_Price
          , zfCalc_SalePrice((SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)               -- ���� � ���
                            , CASE -- % ������� ��� ����� �������� < 6 ���.
                                   WHEN vbMarginPercent_ExpirationDate > 0
                                    AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                    AND COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                        THEN vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                                   -- % ������� ��� ����� �������� < 6 ���.
                                   WHEN vbMarginPercent_ExpirationDate > 0
                                    AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                        THEN vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)

                                   WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                       THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) -- % ������� � ���������
                                   ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0) -- % ������� � ���������
                              END
                            , SelectMinPrice_AllGoods.isTop                                               -- ��� �������
                            , COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) -- % ������� � ������
                            , 0 /*ObjectFloat_Juridical_Percent.ValueData*/                                         -- % ������������� � �� ���� ��� ����
                            , CASE WHEN Object_Price.Fix = TRUE THEN Object_Price.Price ELSE Object_Goods.Price END -- ���� � ������ (����� �������������)
                             ) ::TFloat AS NewPrice
          , SelectMinPrice_AllGoods.PartionGoodsDate         AS ExpirationDate,
            SelectMinPrice_AllGoods.JuridicalId              AS JuridicalId,
            SelectMinPrice_AllGoods.JuridicalName            AS JuridicalName,
            SelectMinPrice_AllGoods.Partner_GoodsName        AS Partner_GoodsName,
            SelectMinPrice_AllGoods.MakerName                AS ProducerName,
            Object_Contract.Id                               AS ContractId,
            Object_Contract.ValueData                        AS ContractName,
            Object_Area.Id                                   AS AreaId,
            Object_Area.ValueData                            AS AreaName,
            SelectMinPrice_AllGoods.MinExpirationDate        AS MinExpirationDate,
            RemainsTo.MinExpirationDate                      AS MinExpirationDate_to,
            SelectMinPrice_AllGoods.MidPriceSale             AS MidPriceSale,
            Object_Goods.NDSKindId,
            SelectMinPrice_AllGoods.isOneJuridical,
            CASE WHEN Select_Income_AllGoods.IncomeCount > 0 THEN TRUE ELSE FALSE END :: Boolean AS isIncome,
            SelectMinPrice_AllGoods.isTop AS isTop_calc,
            Object_Price.IsTop    AS IsTop,
            Object_Goods.IsTop    AS IsTop_Goods,
            Coalesce(ObjectBoolean_Goods_IsPromo.ValueData, False) :: Boolean   AS IsPromo,
            Object_Goods.Price    AS PriceFix_Goods
        FROM
            lpSelectMinPrice_AllGoods(inUnitId   := inUnitId
                                    , inObjectId := -1 * vbObjectId -- !!!�� ������ "-" ��� �� �� ��������� ������. ��������!!!
                                    , inUserId   := vbUserId
                                    ) AS SelectMinPrice_AllGoods
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = SelectMinPrice_AllGoods.ContractId
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = SelectMinPrice_AllGoods.AreaId

            LEFT OUTER JOIN RemainsTo ON RemainsTo.GoodsId = SelectMinPrice_AllGoods.GoodsId


            LEFT OUTER JOIN tmpPrice_View AS Object_Price
                                          ON Object_Price.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail
                                         AND Object_Price.UnitId = inUnitId

            LEFT OUTER JOIN tmpPrice_View AS Object_Price_to
                                          ON Object_Price_to.GoodsMainId = Object_Price.GoodsMainId --SelectMinPrice_AllGoods.GoodsId_retail
                                         AND Object_Price_to.UnitId = CASE WHEN inUnitId_to = 0 THEN NULL ELSE inUnitId_to END

            LEFT OUTER JOIN tmpGoodsView AS Object_Goods
                                         -- !!!����� �� ����!!!
                                         ON Object_Goods.Id = SelectMinPrice_AllGoods.GoodsId_retail -- SelectMinPrice_AllGoods.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                  ON ObjectFloat_Juridical_Percent.ObjectId = SelectMinPrice_AllGoods.JuridicalId
                                 AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

            LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                  ON ObjectFloat_Contract_Percent.ObjectId = SelectMinPrice_AllGoods.ContractId
                                 AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_unit
                                                     ON Object_MarginCategoryLink_unit.UnitId      = inUnitId
                                                    AND Object_MarginCategoryLink_unit.JuridicalId = SelectMinPrice_AllGoods.JuridicalId
                                                    AND Object_MarginCategoryLink_unit.isErased    = FALSE
            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                     ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                    AND Object_MarginCategoryLink_all.JuridicalId = SelectMinPrice_AllGoods.JuridicalId
                                                    AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                    AND Object_MarginCategoryLink_unit.JuridicalId IS NULL

            LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink_unit.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                      AND (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

            LEFT JOIN lpSelect_Income_AllGoods(inUnitId := inUnitId,
                                               inUserId := vbUserId) AS Select_Income_AllGoods
                                                                     ON Select_Income_AllGoods.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                    ON ObjectBoolean_Goods_IsPromo.ObjectId = SelectMinPrice_AllGoods.Partner_GoodsId
                                   AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()

        WHERE Object_Goods.isSp = FALSE
    )

    SELECT
        ResultSet.Id_retail AS Id,
        ResultSet.Id        AS Id_retail,
        ResultSet.Code,
        ResultSet.GoodsName,
        ResultSet.LastPrice,
        ResultSet.LastPrice_to,
        ResultSet.RemainsCount,
        ResultSet.RemainsCount_to,
        ResultSet.NDS,
        ResultSet.NewPrice,
        ResultSet.NewPrice_to,
        ResultSet.PriceFix_Goods,
        COALESCE(MarginCondition.MarginPercent,inMinPercent)::TFloat AS MinMarginPercent,
        CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                   ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
              END AS NUMERIC (16, 1)) :: TFloat AS PriceDiff,
        CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                   ELSE (ResultSet.NewPrice_to / ResultSet.LastPrice) * 100 - 100

              END AS NUMERIC (16, 1)) :: TFloat AS PriceDiff_to,

        ResultSet.ExpirationDate         AS ExpirationDate,
        ResultSet.JuridicalId            AS JuridicalId,
        ResultSet.JuridicalName          AS JuridicalName,
        ResultSet.Juridical_Price        AS Juridical_Price,
        ResultSet.MarginPercent          AS MarginPercent,
        ResultSet.Partner_GoodsName      AS Juridical_GoodsName,
        ResultSet.ProducerName           AS ProducerName,
        ResultSet.ContractId,
        ResultSet.ContractName,
        ResultSet.AreaId,
        ResultSet.AreaName,
        ObjectFloat_Juridical_Percent.ValueData  ::TFloat AS Juridical_Percent,
        ObjectFloat_Contract_Percent.ValueData   ::TFloat AS Contract_Percent,

        ROUND ((CASE WHEN inUnitId_to <> 0 THEN CASE WHEN ResultSet.NewPrice_to > 0 THEN (ResultSet.NewPrice_to - ResultSet.LastPrice) ELSE 0 END ELSE (ResultSet.NewPrice - ResultSet.LastPrice) END
               * ResultSet.RemainsCount
               )
           , 2) :: TFloat AS SumReprice,
        ResultSet.MidPriceSale,
        CAST (CASE WHEN COALESCE(ResultSet.MidPriceSale,0) = 0 THEN 0 ELSE ((ResultSet.NewPrice / ResultSet.MidPriceSale) * 100 - 100) END AS NUMERIC (16, 1)) :: TFloat AS MidPriceDiff,
        ResultSet.MinExpirationDate,
        ResultSet.MinExpirationDate_to,
        ResultSet.isOneJuridical,
        ResultSet.isPriceFix,
        ResultSet.isIncome,
        ResultSet.IsTop,
        -- CASE WHEN ResultSet.isTop_calc = TRUE THEN ResultSet.isTop_calc ELSE ResultSet.IsTop END :: Boolean AS IsTop,
        ResultSet.IsTop_Goods,
        ResultSet.IsPromo,
        CASE WHEN COALESCE (ResultSet.IsTop_Goods, FALSE) = FALSE
                        AND ResultSet.MinExpirationDate > zc_DateStart()
                        AND ResultSet.MinExpirationDate <= CURRENT_DATE
                  THEN FALSE
             WHEN COALESCE (ResultSet.IsTop_Goods, FALSE) = FALSE
                        AND ResultSet.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                        AND ResultSet.MinExpirationDate > zc_DateStart()
                        AND COALESCE (vbMarginPercent_ExpirationDate, 0) = 0
                  THEN FALSE
             WHEN COALESCE (inUnitId_to, 0) = 0 AND (ResultSet.isPriceFix = TRUE OR ResultSet.PriceFix_Goods <> 0)
                  THEN TRUE
-- ������ �� ������������� ����� ������� ������ �� ����� �������
--             WHEN -- COALESCE (inUnitId_to, 0) = 0 AND (ResultSet.isIncome = TRUE /*OR ResultSet.isTop_calc = TRUE*/ OR ResultSet.isPriceFix = TRUE OR ResultSet.PriceFix_Goods <> 0)
--                  COALESCE (inUnitId_to, 0) = 0 AND ResultSet.isIncome = TRUE
--                  THEN FALSE
             WHEN COALESCE (inUnitId_to, 0) = 0
                  THEN TRUE

             WHEN inUnitId_to <> 0 AND (ResultSet.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                                    OR  ResultSet.MinExpirationDate_to <= (CURRENT_DATE + vbInterval_ExpirationDate)
                                    /*OR  ResultSet.isIncome = TRUE */)
                  THEN FALSE

             WHEN inUnitId_to <> 0
              AND ResultSet.NewPrice_to > 0
              AND 0 <> CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                                  ELSE (ResultSet.NewPrice_to / ResultSet.LastPrice) * 100 - 100
                             END AS NUMERIC (16, 1))
                  THEN TRUE

             ELSE FALSE
        END  AS Reprice
    FROM
        ResultSet
        LEFT OUTER JOIN MarginCondition ON MarginCondition.MarginCategoryId = vbMarginCategoryId
                                       AND ResultSet.LastPrice >= MarginCondition.MinPrice
                                       AND ResultSet.LastPrice < MarginCondition.MaxPrice

        LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                              ON ObjectFloat_Juridical_Percent.ObjectId = ResultSet.JuridicalId
                             AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
        LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                              ON ObjectFloat_Contract_Percent.ObjectId = ResultSet.ContractId
                             AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

    WHERE
       ((inUnitId_to > 0 AND ResultSet.NewPrice_to > 0 AND 0 <> CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                                                                            ELSE (ResultSet.NewPrice_to / ResultSet.LastPrice) * 100 - 100
                                                                       END AS NUMERIC (16, 1))
        )
     -- OR inSession = '3'
     OR (COALESCE(ResultSet.NewPrice,0) > 0
         AND (COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Medical()
              OR (inVAT20 = TRUE
                  AND COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Common()
                 )
             )
         AND (ResultSet.ExpirationDate IS NULL
           OR ResultSet.ExpirationDate = '1899-12-30'::TDateTime
           OR ResultSet.ExpirationDate <= zc_DateStart()
           OR ResultSet.ExpirationDate > (CURRENT_DATE + vbInterval_ExpirationDate)
           OR (vbMarginPercent_ExpirationDate > 0
           AND ResultSet.ExpirationDate > CURRENT_DATE
              )
             )
         AND (COALESCE(ResultSet.LastPrice,0) = 0
           OR ABS (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                        ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
                   END
                  ) >= COALESCE (MarginCondition.MarginPercent, inMinPercent)
             )
       ))
   AND (inUnitId_to = 0 or ResultSet.isPriceFix = FALSE)
   AND ResultSet.RemainsCount > 0
   AND (ResultSet.RemainsCount_to > 0 OR COALESCE (inUnitId_to, 0) = 0)
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
 11.02.19         * ������� ������ ���-������ ����� � ���������
 03.05.18                                                                                      *
 17.04.18                                                                                      *
 01.11.17                                        * add inTaxTo
 17.10.17         * add Area
 18.06.16                                        *
 11.05.16         *
 16.02.16         * add isOneJuridical
 19.11.15                                                                      *
 01.07.15                                                                      *
 30.06.15                        *

*/

-- ����
-- SELECT * FROM gpSelect_AllGoodsPrice (183292, 0, 30, True, 0, 0, '3')  -- ������_1 ��_������_6

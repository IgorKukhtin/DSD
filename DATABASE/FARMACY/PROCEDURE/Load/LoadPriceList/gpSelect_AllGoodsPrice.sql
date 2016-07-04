-- Function: gpSelect_AllGoodsPrice()

DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AllGoodsPrice(
    --IN inGoodsCode     Integer    -- ����� �������
    IN inUnitId        Integer     -- �������������
  , IN inUnitId_to     Integer     -- ������������� (� ������� ���� ��������� ���)
  , IN inMinPercent    TFloat      -- ����������� % ��� �������������, � ������� ��������� ���������� �� �����������
  , IN inVAT20         Boolean     -- ������������� ������ � 20% ���
  , IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (
    Id                  Integer,    --�� ������  !!!������ ����, �� ��� ��� � ������ ��������!!!
    Id_retail           Integer,    --�� ������  !!!������ ��, �� ��� ��� � ����� ��������!!!
    Code                Integer,    --��� ������
    GoodsName           TVarChar,   --������������ ������
    LastPrice           TFloat,     --������� ����
    LastPrice_to        TFloat,     --������� ���� - inUnitId_to
    RemainsCount        TFloat,     -- �������
    RemainsCount_to     TFloat,     -- ������� - ������������� (� ������� ���� ��������� ���)
    NDS                 TFloat,     --������ ���
    NewPrice            TFloat,     --����� ����
    MinMarginPercent    TFloat,     --����������� % ����������
    PriceDiff           TFloat,     --% ����������
    PriceDiff_to        TFloat,     --% ���������� - inUnitId_to
    ExpirationDate      TDateTime,  --���� ��������
    JuridicalId         Integer,    --��������� Id
    JuridicalName       TVarChar,   --���������
    Juridical_Price     TFloat,     --���� � ����������
    MarginPercent       TFloat,     --% ������� �� �����
    Juridical_GoodsName TVarChar,   --������������ � ����������
    ProducerName        TVarChar,   --�������������
    ContractName        TVarChar,   -- �������
    SumReprice          TFloat,     --����� ����������
    MidPriceSale        TFloat,     --������� ���� �������
    MidPriceDiff        TFloat,     --���������� �� ������� ���� �������
    MinExpirationDate   TDateTime,  --����������� ���� �������� ��������� �� �����
    MinExpirationDate_to TDateTime, --����������� ���� �������� ��������� �� �����  - ������������� (� ������� ���� ��������� ���)
    isOneJuridical      Boolean ,   -- ���� ��������� (��/���)
    isPriceFix          Boolean ,   -- ������������� ����
    isIncome            Boolean ,   -- ������ �������
    IsTop               Boolean ,   -- ���
    IsPromo             Boolean ,   -- �����
    Reprice             Boolean     -- 
    )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbMarginCategoryId Integer;
BEGIN
    vbUserId := inSession;
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

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
        FROM 
            Object_MarginCategoryItem_View
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
  , RemainsTo AS
       (SELECT
            -- !!!�������� �����������, ����� ������ ����� �������!!!
            ObjectLink_Child_NB.ChildObjectId AS GoodsId         -- ����� �����
          , Container.ObjectId                AS GoodsId_retail  -- ����� ����� "����"
          , MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- ���� ��������
          , SUM (Container.Amount)  :: TFloat AS Amount
        FROM Container
            LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                ON CLO_PartionMovementItem.ContainerId = Container.Id
                                               AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN Object AS Object_PartionMovementItem 
                                   ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
            LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                              ON MIDate_ExpirationDate.MovementItemId = Object_PartionMovementItem.ObjectCode
                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                    -- !!!�������� �����������, ����� ������ ����� �������!!!!
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = Container.ObjectID
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
          AND Container.WhereObjectId = inUnitId_to
          AND Container.Amount <> 0
        GROUP BY ObjectLink_Child_NB.ChildObjectId
               , Container.ObjectId
        HAVING SUM (Container.Amount) > 0
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
            Object_Price.Fix                  AS isPriceFix,
            SelectMinPrice_AllGoods.Remains   AS RemainsCount,
            RemainsTo.Amount                  AS RemainsCount_to,
            Object_Goods.NDS                  AS NDS
          , CASE WHEN SelectMinPrice_AllGoods.isTop = TRUE
                      THEN  COALESCE(Object_Goods.PercentMarkup, 0) /*- COALESCE(ObjectFloat_Percent.valuedata, 0)*/
                 ELSE COALESCE(MarginCondition.MarginPercent,0) + COALESCE(ObjectFloat_Percent.valuedata, 0)
            END::TFloat AS MarginPercent
          , (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)::TFloat AS Juridical_Price
          , zfCalc_SalePrice((SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)              -- ���� � ���
                            , MarginCondition.MarginPercent + COALESCE(ObjectFloat_Percent.valuedata, 0) -- % ������� � ���������
                            , SelectMinPrice_AllGoods.isTop                                              -- ��� �������
                            , Object_Goods.PercentMarkup                                                 -- % ������� � ������
                            , 0 /*ObjectFloat_Percent.valuedata*/                                        -- % ������������� � �� ���� ��� ����
                            , Object_Goods.Price                                                         -- ���� � ������ (�������������)
                             ) ::TFloat AS NewPrice
          , SelectMinPrice_AllGoods.PartionGoodsDate         AS ExpirationDate,
            SelectMinPrice_AllGoods.JuridicalId              AS JuridicalId,
            SelectMinPrice_AllGoods.JuridicalName            AS JuridicalName,
            SelectMinPrice_AllGoods.Partner_GoodsName        AS Partner_GoodsName,
            SelectMinPrice_AllGoods.MakerName                AS ProducerName,
            Object_Contract.ValueData                        AS ContractName,
            SelectMinPrice_AllGoods.MinExpirationDate        AS MinExpirationDate,
            RemainsTo.MinExpirationDate                      AS MinExpirationDate_to,
            SelectMinPrice_AllGoods.MidPriceSale             AS MidPriceSale,
            Object_Goods.NDSKindId,
            SelectMinPrice_AllGoods.isOneJuridical,
            CASE WHEN Select_Income_AllGoods.IncomeCount > 0 THEN TRUE ELSE FALSE END :: Boolean AS isIncome,
            SelectMinPrice_AllGoods.isTop, -- Object_Goods.IsTop,
            Coalesce(ObjectBoolean_Goods_IsPromo.ValueData, False) :: Boolean   AS IsPromo

        FROM
            lpSelectMinPrice_AllGoods(inUnitId   := inUnitId
                                    , inObjectId := -1 * vbObjectId -- !!!�� ������ "-" ��� �� �� ��������� ������. ��������!!!
                                    , inUserId   := vbUserId
                                    ) AS SelectMinPrice_AllGoods
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = SelectMinPrice_AllGoods.ContractId


            LEFT OUTER JOIN RemainsTo ON RemainsTo.GoodsId = SelectMinPrice_AllGoods.GoodsId

            LEFT OUTER JOIN Object_Price_View AS Object_Price_to
                                              ON Object_Price_to.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail
                                             AND Object_Price_to.UnitId = CASE WHEN inUnitId_to = 0 THEN NULL ELSE inUnitId_to END
            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON Object_Price.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail
                                             AND Object_Price.UnitId = inUnitId
            LEFT OUTER JOIN Object_Goods_View AS Object_Goods
                                              ON Object_Goods.ObjectId = vbObjectId
                                                 -- !!!����� �� ����!!!
                                             AND Object_Goods.Id = SelectMinPrice_AllGoods.GoodsId_retail -- SelectMinPrice_AllGoods.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                  ON ObjectFloat_Percent.ObjectId = SelectMinPrice_AllGoods.JuridicalId
                                 AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_unit
                                                     ON Object_MarginCategoryLink_unit.UnitId = inUnitId
                                                    AND Object_MarginCategoryLink_unit.JuridicalId = SelectMinPrice_AllGoods.JuridicalId
            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                     ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                    AND Object_MarginCategoryLink_all.JuridicalId = SelectMinPrice_AllGoods.JuridicalId
                                                    AND Object_MarginCategoryLink_unit.JuridicalId IS NULL

            LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink_unit.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                      AND (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

            LEFT JOIN lpSelect_Income_AllGoods(inUnitId := inUnitId,
                                               inUserId := vbUserId) AS Select_Income_AllGoods 
                                                                     ON Select_Income_AllGoods.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                    ON ObjectBoolean_Goods_IsPromo.ObjectId = SelectMinPrice_AllGoods.Partner_GoodsId
                                   AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()                                                                     
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
        COALESCE(MarginCondition.MarginPercent,inMinPercent)::TFloat AS MinMarginPercent,
        CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                   ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
              END AS NUMERIC (16, 1)) :: TFloat AS PriceDiff,
        CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                   ELSE (ResultSet.LastPrice_to / ResultSet.LastPrice) * 100 - 100
              END AS NUMERIC (16, 1)) :: TFloat AS PriceDiff_to,

        ResultSet.ExpirationDate         AS ExpirationDate,
        ResultSet.JuridicalId            AS JuridicalId,
        ResultSet.JuridicalName          AS JuridicalName,
        ResultSet.Juridical_Price        AS Juridical_Price,
        ResultSet.MarginPercent          AS MarginPercent,
        ResultSet.Partner_GoodsName      AS Juridical_GoodsName,
        ResultSet.ProducerName           AS ProducerName,
        ResultSet.ContractName,
        ROUND ((CASE WHEN inUnitId_to <> 0 THEN CASE WHEN ResultSet.LastPrice_to > 0 THEN (ResultSet.LastPrice_to - ResultSet.LastPrice) ELSE 0 END ELSE (ResultSet.NewPrice - ResultSet.LastPrice) END
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
        ResultSet.IsPromo,
        CASE WHEN COALESCE (inUnitId_to, 0) = 0 AND (ResultSet.isIncome = TRUE OR ResultSet.IsTop = TRUE OR ResultSet.isPriceFix = TRUE)
                  THEN FALSE
             WHEN COALESCE (inUnitId_to, 0) = 0
                  THEN TRUE
             WHEN inUnitId_to <> 0 AND ResultSet.LastPrice_to > 0 AND 0 <> CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                                                                                      ELSE (ResultSet.LastPrice_to / ResultSet.LastPrice) * 100 - 100
                                                                                 END AS NUMERIC (16, 1))
                  THEN TRUE
             ELSE FALSE
        END  AS Reprice
    FROM 
        ResultSet
        LEFT OUTER JOIN MarginCondition ON MarginCondition.MarginCategoryId = vbMarginCategoryId
                                       AND ResultSet.LastPrice >= MarginCondition.MinPrice 
                                       AND ResultSet.LastPrice < MarginCondition.MaxPrice

    WHERE
       ((inUnitId_to > 0 AND ResultSet.LastPrice_to > 0 AND 0 <> CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                                                                            ELSE (ResultSet.LastPrice_to / ResultSet.LastPrice) * 100 - 100
                                                                       END AS NUMERIC (16, 1))
        )
     OR (
        COALESCE(ResultSet.NewPrice,0) > 0
        AND
        (
            COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Medical()
            OR
            (
                inVAT20 = TRUE
                AND
                COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Common()
            )
        )
        AND
        (
            ResultSet.ExpirationDate IS NULL
            OR
            ResultSet.ExpirationDate = '1899-12-30'::TDateTime
            OR
            ResultSet.ExpirationDate > (CURRENT_DATE + Interval '6 month')
        )
        AND
        (
            COALESCE(ResultSet.LastPrice,0) = 0
            OR
            ABS(CASE 
                  WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                  ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
                END) >= COALESCE (MarginCondition.MarginPercent, inMinPercent)
        )
        ))

        AND ResultSet.RemainsCount > 0 AND (ResultSet.RemainsCount_to > 0 OR COALESCE (inUnitId_to, 0) = 0)

        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_AllGoodsPrice (Integer,  Integer,  TFloat, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 18.06.16                                        *
 11.05.16         *
 16.02.16         * add isOneJuridical
 19.11.15                                                                      *
 01.07.15                                                                      *
 30.06.15                        *

*/

-- ����
-- SELECT * FROM gpSelect_AllGoodsPrice (183292, 0, 30, True, '3')  -- ������_1 ��_������_6

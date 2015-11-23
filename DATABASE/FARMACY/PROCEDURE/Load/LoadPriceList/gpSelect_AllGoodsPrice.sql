DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AllGoodsPrice(
    --IN inGoodsCode     Integer    -- ����� �������
    IN inUnitId        Integer     -- �������������
  , IN inMinPercent    TFloat      -- ����������� % ��� �������������, � ������� ��������� ���������� �� �����������
  , IN inVAT20         Boolean     -- ������������� ������ � 20% ���
  , IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (
    Id             Integer,    --�� ������
    Code           Integer,    --��� ������
    GoodsName      TVarChar,   --������������ ������
    LastPrice      TFloat,     --������� ����
    RemainsCount   TFloat,     --�������
    NDS            TFloat,     --������ ���
    ExpirationDate TDateTime,  --���� ��������
    NewPrice       TFloat,     --����� ����
    MarginPercent  TFloat,     --����������� % ����������
    PriceDiff      TFloat      --% ����������
    )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbMarginCategoryId Integer;
BEGIN
    vbUserId := inSession;
    vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

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
    ), 
    DDD 
    AS 
    (
        SELECT 
            DD.Id,
            DD.NewPrice,
            DD.ExpirationDate
        FROM(
                SELECT
                    ObjectGoodsView.Id         AS Id,
                    LoadPriceListItem.ExpirationDate,
                    zfCalc_SalePrice((LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100), -- ���� � ���
                                      MarginCondition.MarginPercent + COALESCE(ObjectFloat_Percent.valuedata, 0), -- % �������
                                      ObjectGoodsView.isTop, -- ��� �������
                                      ObjectGoodsView.PercentMarkup, -- % ������� � ������
                                      ObjectFloat_Percent.valuedata,
                                      ObjectGoodsView.Price)::TFloat AS NewPrice
                FROM 
                    LoadPriceListItem 
                    JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                    LEFT JOIN(
                                SELECT DISTINCT 
                                JuridicalId, 
                                ContractId, 
                                isPriceClose
                            FROM 
                                lpSelect_Object_JuridicalSettingsRetail(vbObjectId)) AS JuridicalSettings
                                                                                     ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId 
                                                                                    AND JuridicalSettings.ContractId = LoadPriceList.ContractId 
                    LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                          ON ObjectFloat_Percent.ObjectId = LoadPriceList.JuridicalId
                                         AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                    LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                             ON (Object_MarginCategoryLink.UnitId = inUnitId)    
                                                            AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

                    LEFT JOIN Object_Goods_Main_View AS Object_Goods 
                                                     ON Object_Goods.Id = LoadPriceListItem.GoodsId
                    LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = Object_MarginCategoryLink.MarginCategoryId
                                             AND (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
                    LEFT JOIN Object AS Object_Juridical 
                                     ON Object_Juridical.Id = LoadPriceList.JuridicalId
                    LEFT JOIN Object AS Object_Contract 
                                     ON Object_Contract.Id = LoadPriceList.ContractId
                    LEFT JOIN Object_Goods_View AS PartnerGoods 
                                                ON PartnerGoods.ObjectId = LoadPriceList.JuridicalId 
                                               AND PartnerGoods.GoodsCode = LoadPriceListItem.GoodsCode
                    LEFT JOIN Object_LinkGoods_View AS LinkGoods 
                                                    ON LinkGoods.GoodsMainId = Object_Goods.Id 
                                                   AND LinkGoods.GoodsId = PartnerGoods.Id
                    LEFT JOIN Object_LinkGoods_View AS LinkGoodsObject 
                                                    ON LinkGoodsObject.GoodsMainId = Object_Goods.Id 
                                                   AND LinkGoodsObject.ObjectId = vbObjectId
                    LEFT JOIN Object_Goods_View AS ObjectGoodsView 
                                                ON ObjectGoodsView.Id = LinkGoodsObject.GoodsId
                WHERE 
                    COALESCE(JuridicalSettings.isPriceClose, FALSE) <> TRUE
            ) AS DD
        WHERE DD.NewPrice > 0.01
    ),
    PriceResult AS 
    (
        Select 
            DDDD.Id
           ,DDDD.ExpirationDate
           ,DDDD.NewPrice
        From(
                SELECT 
                    *, 
                    row_number()over(partition by DDD.Id Order By DDD.NewPrice) as ord 
                FROM DDD
            ) as DDDD
        Where 
            DDDD.ord = 1
    ),
    ResultSet AS 
    (
        SELECT
            Object_Goods.Id               AS Id,
            Object_Goods.GoodsCodeInt     AS Code,
            Object_Goods.GoodsName        AS GoodsName,
            Object_Price.Price            AS LastPrice,
            SUM(Container.Amount)::TFloat AS RemainsCount,
            Object_Goods.NDS              AS NDS,
            Object_Goods.NDSKindId        AS NDSKindId,
            PriceResult.ExpirationDate    AS ExpirationDate,
            PriceResult.NewPrice          AS NewPrice
        FROM
            Object_Goods_View AS Object_Goods
            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON Object_Price.GoodsId = Object_Goods.ID
                                             AND Object_Price.UnitId = inUnitId
            LEFT OUTER JOIN Container ON Container.ObjectId = Object_Goods.Id
                                     AND Container.DescId = zc_Container_Count()
                                     AND Container.WhereObjectId = inUnitId
                                     AND Container.Amount <> 0
            LEFT OUTER JOIN PriceResult ON PriceResult.Id = Object_Goods.Id
        WHERE
            Object_Goods.ObjectId = vbObjectId
        GROUP BY
            Object_Goods.Id,
            Object_Goods.GoodsCodeInt,
            Object_Goods.GoodsName,
            Object_Price.Price,
            Object_Goods.NDS,
            Object_Goods.NDSKindId,
            PriceResult.ExpirationDate,
            PriceResult.NewPrice
    )

    SELECT
        ResultSet.Id,
        ResultSet.Code,
        ResultSet.GoodsName,
        ResultSet.LastPrice,
        ResultSet.RemainsCount,
        ResultSet.NDS,
        ResultSet.ExpirationDate,
        ResultSet.NewPrice,
        COALESCE(MarginCondition.MarginPercent,inMinPercent)::TFloat AS MarginPercent,
        CASE 
            WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
            ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
        END::TFloat AS PriceDiff
    FROM
        ResultSet
        LEFT OUTER JOIN MarginCondition ON MarginCondition.MarginCategoryId = vbMarginCategoryId
                                       AND ResultSet.LastPrice >= MarginCondition.MinPrice 
                                       AND ResultSet.LastPrice < MarginCondition.MaxPrice
    WHERE
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
                END) >= COALESCE(MarginCondition.MarginPercent,inMinPercent)
        )
        AND
        COALESCE(ResultSet.RemainsCount,0) > 0
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_AllGoodsPrice (Integer,  TFloat, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 19.11.15                                                                      *
 01.07.15                                                                      *
 30.06.15                        *
 
*/

-- ����
-- SELECT * FROM gpSelect_AllGoodsPrice (183293, inSession:= '2')
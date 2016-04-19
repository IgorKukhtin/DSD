-- Function: lpSelectMinPrice_AllGoods()

DROP FUNCTION IF EXISTS lpSelectMinPrice_AllGoods (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_AllGoods(
    IN inUnitId      Integer      , -- ������
    IN inObjectId    Integer      , -- �������� ����
    IN inUserId      Integer        -- ������ ������������
)

RETURNS TABLE (
    GoodsId            Integer,
    GoodsCode          Integer,
    GoodsName          TVarChar,
    Remains            TFloat,
    MidPriceSale       TFloat,
    MinExpirationDate  TDateTime,
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

    -- ����� � ������ "������� �� ����"
    SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;


    -- ���������
    RETURN QUERY
    WITH
    -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����) !!!������ ���� ������������ ObjectId!!!
    PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inUserId::TVarChar)
                     )
    -- ��������� ��� ��. ��� (��� ���������� ������������ ������� � �.�)
  , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId)
                         )
    -- �������
  , Remains AS
       (SELECT
            Container.ObjectId, -- ����� ����� "����"
            SUM(Container.Amount)::TFloat                      AS Amount,
            MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate, -- ���� ��������
            SUM( Container.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0)) / SUM(Container.Amount)      AS MidPriceSale -- !!! ������� ���� ����. � ���!!!
        FROM 
            Container
            LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                ON CLO_PartionMovementItem.ContainerId = Container.Id
                                               AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem 
                                   ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
            LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                              ON MIDate_ExpirationDate.MovementItemId = Object_PartionMovementItem.ObjectCode
                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
            -- ���� ����. � ���
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = Object_PartionMovementItem.ObjectCode
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale() 
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId = inUnitId
          AND Container.Amount <> 0
        GROUP BY Container.ObjectId
        HAVING SUM (Container.Amount) > 0
       )
    -- ������� + ���� ...
  , GoodsList AS
       (SELECT 
            Remains.ObjectId,                  -- ����� ����� "����"
            Object_LinkGoods_View.GoodsMainId, -- ����� "�����" �����
            PriceList_GoodsLink.GoodsId,       -- ����� ����� "����������"
            Remains.Amount,
            Remains.MinExpirationDate,
            Remains.MidPriceSale
        FROM 
            Remains
            INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = Remains.objectid -- ����� ������ ���� � �����
            LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- ����� ������ � ������ � ������� �������
                                            ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
       )
    -- ����� ��������� ������
  , FinalList AS
       (SELECT 
        ddd.GoodsId
      , ddd.GoodsCode
      , ddd.GoodsName  
      , ddd.Remains
      , ddd.MinExpirationDate
      , ddd.MidPriceSale
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

      , CASE -- ���� ���� �������� �� �������� = 0 ��� ���-�������
             WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                  THEN FinalPrice
             -- ����� ��������� % �� ��������� ��� ������� ����� (��� � ������������ ... )
             ELSE FinalPrice * (100 - PriceSettings.Percent) / 100

        END :: TFloat AS SuperFinalPrice

      , ddd.isTOP

    FROM (SELECT DISTINCT 
            GoodsList.ObjectId                 AS GoodsId
          , Goods.GoodsCodeInt                 AS GoodsCode
          , Goods.GoodsName                    AS GoodsName  
          , GoodsList.Amount                   AS Remains
          , GoodsList.MinExpirationDate        AS MinExpirationDate
          , GoodsList.MidPriceSale             AS MidPriceSale
            -- ������ ���� ����������
          , PriceList.Amount                   AS Price
            -- ����������� ���� ���������� - ��� ������ "����"
          , MIN (PriceList.Amount) OVER (PARTITION BY GoodsList.ObjectId) AS MinPrice
          , PriceList.Id                       AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

          , CASE -- ���� ���-������� ��� ���� ���������� >= PriceLimit (�� ����� ���� ��������� ����� ��� ������� �����. ����)
                 WHEN Goods.isTOP = TRUE OR COALESCE (JuridicalSettings.PriceLimit, 0) <= PriceList.Amount
                    THEN PriceList.Amount
                 -- ����� ����������� �����
                 ELSE (PriceList.Amount * (100 - COALESCE (JuridicalSettings.Bonus, 0)) / 100) :: TFloat 
            END AS FinalPrice

          , MILinkObject_Goods.ObjectId        AS Partner_GoodsId
          , Object_JuridicalGoods.GoodsCode    AS Partner_GoodsCode
          , Object_JuridicalGoods.GoodsName    AS Partner_GoodsName
          , Object_JuridicalGoods.MakerName    AS MakerName
          , LastPriceList_View.ContractId      AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , Goods.isTOP
        
        FROM -- ������� + ���� ...
             GoodsList 
             -- ������ � �����-����� (����������)
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                              ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                             AND MILinkObject_Goods.ObjectId = GoodsList.GoodsId  -- ����� "����������"
             -- �����-���� (����������) - MovementItem
            JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
             -- �����-���� (����������) - Movement
            JOIN LastPriceList_View ON LastPriceList_View.MovementId = PriceList.MovementId

             -- ���� ������ ������ (��� ���� ��������?) � �����-���� (����������)
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

             -- ��������� ��� ��. ��� (��� ���������� ������������ ������� � �.�)
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = LastPriceList_View.JuridicalId 
                                       AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId
                                       AND JuridicalSettings.ContractId      = LastPriceList_View.ContractId 
            -- ����� "����������", ���� �� ���� � ������� !!!� �� ����!!!
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
            -- ����� "����"
            LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = GoodsList.ObjectId
       
            -- ���������
            INNER JOIN Object AS Juridical ON Juridical.Id = LastPriceList_View.JuridicalId

            -- ���� �������� �� ��������
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                  ON ObjectFloat_Deferment.ObjectId = LastPriceList_View.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
       
             
        WHERE  COALESCE (JuridicalSettings.isPriceClose, FALSE) <> TRUE 

       ) AS ddd
       -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����)
       LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice
   )
    -- ������������� �� ���� � �������� �������
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId ORDER BY FinalList.SuperFinalPrice, FinalList.PriceListMovementItemId) AS Ord
                           FROM FinalList
                          ) AS T0
                     WHERE T0.Ord = 1
                    )
    -- ������� ����������� � ������
  , tmpCountJuridical AS (SELECT FinalList.GoodsId, COUNT (DISTINCT FinalList.JuridicalId) AS CountJuridical
                          FROM FinalList
                          GROUP BY FinalList.GoodsId
                         )
    -- ���������
    SELECT
        MinPriceList.GoodsId,
        MinPriceList.GoodsCode,
        MinPriceList.GoodsName,
        MinPriceList.Remains,
        MinPriceList.MidPriceSale ::TFloat,
        MinPriceList.MinExpirationDate,
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
ALTER FUNCTION lpSelectMinPrice_AllGoods (Integer, Integer, Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 16.02.16         * add isOneJuridical
 03.12.15                                                                          * 
*/

-- ����
-- SELECT * FROM lpSelectMinPrice_AllGoods (183292, 4, 3) WHERE GoodsCode = 4797

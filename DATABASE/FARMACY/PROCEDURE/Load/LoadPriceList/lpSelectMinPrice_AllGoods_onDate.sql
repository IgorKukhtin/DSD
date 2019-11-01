-- Function: lpSelectMinPrice_AllGoods_onDate()

DROP FUNCTION IF EXISTS lpSelectMinPrice_AllGoods_onDate (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_AllGoods_onDate(
    IN inOperdate    TDateTime    , -- �� ����
    IN inUnitId      Integer      , -- ������
    IN inObjectId    Integer      , -- �������� ����
    IN inUserId      Integer        -- ������ ������������
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
    isOneJuridical     Boolean,
    PercentMarkup      TFloat
)
AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
  DECLARE vbCostCredit TFloat;
BEGIN

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

    -- ����� � ������ "������� �� ����"
    SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;

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
  , GoodsPromo AS (SELECT tmp.JuridicalId
                        , tmp.GoodsId        -- ����� ����� "����"
                        , tmp.ChangePercent
                   FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp
                  )
  
 -- ������ ��������� ��� (����������) !!!�� ����������!!! (�.�. ��������� �������� � �� ��������� ��������� ����)
  , Movement_PriceList AS
       (-- ���������� � "������" ��������� �� JuridicalSettings
        SELECT tmp.MovementId
             , tmp.JuridicalId
             , tmp.ContractId
             , JuridicalSettings.JuridicalSettingsId
             --, COALESCE (JuridicalSettings.PriceLimit, 0) AS PriceLimit
             --, COALESCE (JuridicalSettings.Bonus, 0)      AS Bonus
        FROM
            (-- ���������� � "����" �����
             SELECT *
             FROM
                 (-- ���������� ��� !!!�� ������ "ObjectId"!!!
                  SELECT MAX (Movement.OperDate) OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId, COALESCE (MovementLinkObject_Contract.ObjectId, 0)) AS Max_Date
                       , Movement.OperDate
                       , Movement.Id                                        AS MovementId
                       , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
                       , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                  FROM MovementLinkObject AS MovementLinkObject_Juridical
          --                                ON MovementLinkObject_Juridical.ObjectId = tmp.ObjectId
                       INNER JOIN Movement ON Movement.Id     = MovementLinkObject_Juridical.MovementId
                                          AND Movement.DescId = zc_Movement_PriceList()
                                          AND Movement.OperDate <= inOperDate
                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                    ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                   AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                  WHERE MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical() 
                    AND Movement.DescId = zc_Movement_PriceList()
                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                 ) AS tmp
             WHERE tmp.Max_Date = tmp.OperDate -- �.�. ��� �������� � �� ���� ����� 1 ��������
            ) AS tmp
        -- !!!INNER!!!
        INNER JOIN (SELECT DISTINCT JuridicalSettings.JuridicalId, JuridicalSettings.ContractId , JuridicalSettings.JuridicalSettingsId
                    FROM JuridicalSettings
                   ) AS JuridicalSettings ON JuridicalSettings.JuridicalId = tmp.JuridicalId
                                         AND JuridicalSettings.ContractId  = tmp.ContractId
       )
    -- ��������� ���� (����������) �� "������" ������� �� GoodsList
  , MI_PriceList AS
       (SELECT Movement_PriceList.MovementId
             , Movement_PriceList.JuridicalId
             , Movement_PriceList.ContractId
             , MovementItem.Id     AS MovementItemId
             , MovementItem.Amount AS Price
            -- , GoodsList.GoodsId      -- ����� ����� "����"
            -- , GoodsList.GoodsId_main -- ����� "�����" �����
            -- , GoodsList.GoodsId_jur  -- ����� ����� "����������"
             , MILinkObject_Goods.ObjectId  AS GoodsId_jur -- ����� "����������"
            -- , GoodsList.ObjectId     -- ����� �� ���� ���� ����� ��� � � Movement_PriceList.JuridicalId
        FROM Movement_PriceList
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_PriceList.MovementId
             INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
             
            -- INNER JOIN GoodsList ON GoodsList.GoodsId_jur = MILinkObject_Goods.ObjectId -- ����� "����������"
       )

    -- ���� + ���� ...
  , GoodsList AS
       (SELECT PriceList_GoodsLink.GoodsId     AS ObjectId      -- ����� ����� "����"
             , Object_LinkGoods_View.GoodsMainId                -- ����� "�����" �����
             , Object_LinkGoods_View.GoodsId                    -- ����� ����� "����������"
             , MI_PriceList.MovementId
             , MI_PriceList.JuridicalId
             , MI_PriceList.ContractId
             , MI_PriceList.MovementItemId
             , MI_PriceList.Price
        FROM 
            MI_PriceList
            INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MI_PriceList.GoodsId_jur -- ����� ������ ���������� � �������
            LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- ����� ������ � ������ � ������� �������
                                            ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                            AND PriceList_GoodsLink.ObjectId = inObjectId
       )

    -- ������ ���� + ��� + % �������
  , GoodsPrice AS
       (SELECT GoodsList.GoodsId, COALESCE (ObjectBoolean_Top.ValueData, FALSE) AS isTOP, COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
        FROM GoodsList
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                   ON ObjectLink_Price_Goods.ChildObjectId = GoodsList.GoodsId
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                   ON ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                  AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                      ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                     AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
             LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                   ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
        WHERE ObjectBoolean_Top.ValueData = TRUE OR ObjectFloat_PercentMarkup.ValueData <> 0
       )

  -- ������ �� % ��������� ������� �� �����������
  , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := inObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inUserId :: TVarChar) AS tmp)

   -- ����� ��������� ������
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
/*      
      , CASE -- ���� ���� �������� �� �������� = 0
             WHEN 1=0 AND ddd.Deferment = 0
                  THEN FinalPrice
             -- ���� ���-�������
             WHEN 1=0 AND ddd.isTOP = TRUE
                  THEN FinalPrice * (100 - COALESCE (PriceSettingsTOP.Percent, 0)) / 100
             -- ����� ��������� % �� ��������� ��� ������� ����� (��� � ������������ ... )
             ELSE FinalPrice * (100 - PriceSettings.Percent) / 100

        END :: TFloat AS SuperFinalPrice
*/
 /*   -- �� 07,04,19
      , CASE --- ���� ���� �������� �� �������� = 0 + ���-������� ��������� % �� ... (��� � ������������ ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                  THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
             -- ���� ���� �������� �� �������� = 0 + �� ���-������� = ��������� % �� ��������� ��� ������� ����� (��� � ������������ ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                  THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
             -- ����� �� ���������
             ELSE FinalPrice

        END :: TFloat AS SuperFinalPrice
*/
        -- � 07,04,2019
      , (FinalPrice - FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit)) / 100) :: TFloat AS SuperFinalPrice
      , ddd.isTOP
      , ddd.PercentMarkup

    FROM (SELECT DISTINCT 
            GoodsList.ObjectId                 AS GoodsId
          , Goods.GoodsCodeInt                 AS GoodsCode
          , Goods.GoodsName                    AS GoodsName  

            -- ������ ���� ����������
          , PriceList.Amount                   AS Price
            -- ����������� ���� ���������� - ��� ������ "����"
          , MIN (PriceList.Amount) OVER (PARTITION BY GoodsList.ObjectId) AS MinPrice
          , PriceList.Id                       AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

          , CASE WHEN 1=0
                      THEN PriceList.Amount
                 -- ���� ���� ���������� �� �������� � ������� ����������        -- ���� ���� ���������� >= PriceLimit (�� ����� ���� ��������� ����� ��� ������� �����. ����)
                 WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                      THEN PriceList.Amount
                           -- ����������� % ������ �� ������������� ��������
                         * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                 
                 ELSE -- ����� ����������� ����� - ��� ���-������� ��� �� ���-�������
                      (PriceList.Amount * (100 - COALESCE (tmpJuridicalSettingsItem.Bonus, 0)) / 100)
                       -- � ����������� % ������ �� ������������� ��������
                    * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
            END :: TFloat AS FinalPrice

          , MILinkObject_Goods.ObjectId        AS Partner_GoodsId
          , Object_JuridicalGoods.GoodsCode    AS Partner_GoodsCode
          , Object_JuridicalGoods.GoodsName    AS Partner_GoodsName
          , Object_JuridicalGoods.MakerName    AS MakerName
          , LastPriceList_find_View.ContractId      AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), Goods.isTOP) AS isTOP
          , COALESCE (GoodsPrice.PercentMarkup, 0) AS PercentMarkup
        
        FROM -- ������� + ���� ...
             GoodsList 
             -- ������ � �����-����� (����������)
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                              ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                             AND MILinkObject_Goods.ObjectId = GoodsList.GoodsId  -- ����� "����������"
             -- �����-���� (����������) - MovementItem
            JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
             -- �����-���� (����������) - Movement
            JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

             -- ���� ������ ������ (��� ���� ��������?) � �����-���� (����������)
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

             -- ��������� ��� ��. ��� (��� ���������� ������������ ������� � �.�)
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = LastPriceList_find_View.JuridicalId 
                                       AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId
                                       AND JuridicalSettings.ContractId      = LastPriceList_find_View.ContractId 
            -- ��������� � ����������  ��������� ��.���. 
            LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                              AND PriceList.Amount >= tmpJuridicalSettingsItem.PriceLimit_min
                                              AND PriceList.Amount <= tmpJuridicalSettingsItem.PriceLimit

            -- ����� "����������", ���� �� ���� � ������� !!!� �� ����!!!
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
            -- ����� "����"
            LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = GoodsList.ObjectId
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = GoodsList.ObjectId
       
            -- ���������
            INNER JOIN Object AS Juridical ON Juridical.Id = LastPriceList_find_View.JuridicalId

            -- ���� �������� �� ��������
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                  ON ObjectFloat_Deferment.ObjectId = LastPriceList_find_View.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
       
            -- % ������ �� ������������� ��������
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = GoodsList.ObjectId
                                AND GoodsPromo.JuridicalId = LastPriceList_find_View.JuridicalId

        WHERE  COALESCE (JuridicalSettings.isPriceClose, FALSE) <> TRUE 

       ) AS ddd
       -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����)
       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
       LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice    AND tmpCostCredit.PriceLimit
   )
    -- ������������� �� ���� + ���� �������� � �������� �������
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId ORDER BY FinalList.SuperFinalPrice ASC, FinalList.Deferment DESC, FinalList.PriceListMovementItemId ASC) AS Ord
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
        MinPriceList.isTop :: Boolean AS isTop,
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END ::Boolean AS isOneJuridical,
        MinPriceList.PercentMarkup :: TFloat AS PercentMarkup
    FROM MinPriceList
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 07.02.19         * ���� isBonusClose = true ������ �� ���������
 14.01.19         * tmpJuridicalSettingsItem - ������ �������� ����� ����� �� ������
 04.05.16         * 
*/

-- ����
-- SELECT * FROM lpSelectMinPrice_AllGoods_onDate ('30.06.2016' ::TDateTime , 183292 , 4, 3) WHERE GoodsCode = 4797 --  unit 183292

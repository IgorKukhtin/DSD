-- Function: lpSelect_GoodsMinPrice_onDate()

DROP FUNCTION IF EXISTS lpSelect_GoodsMinPrice_onDate (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_GoodsMinPrice_onDate(
    IN inOperdate    TDateTime    , -- �� ����
    IN inUnitId      Integer      , -- ������
    IN inObjectId    Integer      , -- �������� ����
    IN inUserId      Integer        -- ������ ������������
)
RETURNS TABLE (
    GoodsId            Integer,
    ContractId         Integer,
    JuridicalId        Integer,
    JuridicalName      TVarChar,
    Price              TFloat
)
AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
  DECLARE vbAreaId   Integer;
BEGIN

    -- ��������� ������ ������������
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inUserId::TVarChar));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inUserId::TVarChar));
    END IF;

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
    -- ������������� ��������
  , GoodsPromo AS (SELECT tmp.JuridicalId
                        , tmp.GoodsId        -- ����� ����� "����"
                        , tmp.ChangePercent
                   FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp
                  )

 -- ������ ��������� ��� (����������) !!!�� ����������!!! (�.�. ��������� �������� � �� ��������� ��������� ����)
  , tmp1 AS (-- ���������� ��� !!!�� ������ "ObjectId"!!!
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
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                    ON MovementLinkObject_Area.MovementId = Movement.Id
                                                   AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
             --������������ ���� ��� ���� � LoadPriceList
             INNER JOIN LoadPriceList ON LoadPriceList.JuridicalId          = MovementLinkObject_Juridical.ObjectId
                                     AND LoadPriceList.ContractId           = COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                     AND (LoadPriceList.AreaId = 0 OR COALESCE (LoadPriceList.AreaId, 0) = vbAreaId OR COALESCE(vbAreaId, 0) = 0 OR COALESCE (LoadPriceList.AreaId, 0) = zc_Area_Basis() )
                                     
                  WHERE MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                    AND Movement.DescId = zc_Movement_PriceList()
                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                    AND (   (COALESCE (MovementLinkObject_Area.ObjectId, 0) = vbAreaId AND COALESCE (vbAreaId,0)<>0)
                         OR (COALESCE (vbAreaId,0)=0 AND COALESCE (MovementLinkObject_Area.ObjectId, 0) = zc_Area_basis())
                         OR COALESCE (MovementLinkObject_Area.ObjectId, 0) =0
                         ) 
                 )
  , tmp2 AS (-- ���������� � "����" �����
             SELECT *
             FROM tmp1 AS tmp
             WHERE tmp.Max_Date = tmp.OperDate -- �.�. ��� �������� � �� ���� ����� 1 ��������
            )
  , tmpJuridicalSettings AS (SELECT DISTINCT JuridicalSettings.JuridicalId, JuridicalSettings.ContractId, JuridicalSettings.PriceLimit, JuridicalSettings.Bonus
                             FROM JuridicalSettings
                             )
  , Movement_PriceList AS
       (-- ���������� � "������" ��������� �� JuridicalSettings
        SELECT tmp.MovementId
             , tmp.JuridicalId
             , tmp.ContractId
             , COALESCE (JuridicalSettings.PriceLimit, 0) AS PriceLimit
             , COALESCE (JuridicalSettings.Bonus, 0)      AS Bonus
        FROM tmp2 AS tmp
        -- !!!INNER!!!
        INNER JOIN tmpJuridicalSettings AS JuridicalSettings
                                        ON JuridicalSettings.JuridicalId = tmp.JuridicalId
                                       AND JuridicalSettings.ContractId  = tmp.ContractId
       )
    -- ��������� ���� (����������) �� "������" ������� �� GoodsList
  , MI_PriceList AS
       (SELECT Movement_PriceList.MovementId
             , Movement_PriceList.JuridicalId
             , Movement_PriceList.ContractId
             , Movement_PriceList.PriceLimit
             , Movement_PriceList.Bonus
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
             , MI_PriceList.PriceLimit
             , MI_PriceList.Bonus
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
       (SELECT GoodsList.GoodsId
             , COALESCE (ObjectBoolean_Top.ValueData, FALSE)     AS isTOP
             , COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
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

  , ddd AS (SELECT DISTINCT
                   GoodsList.ObjectId                 AS GoodsId

                   -- ������ ���� ����������
                 , GoodsList.Price                   AS Price
                   -- ����������� ���� ���������� - ��� ������ "����"
                 , MIN (GoodsList.Price) OVER (PARTITION BY GoodsList.ObjectId) AS MinPrice
                 , GoodsList.MovementItemId                       AS PriceListMovementItemId
                 , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

                 , CASE WHEN 1=0
                             THEN GoodsList.Price
                        -- ���� ���� ���������� >= PriceLimit (�� ����� ���� ��������� ����� ��� ������� �����. ����)
                        WHEN COALESCE (JuridicalSettings.PriceLimit, 0) <= GoodsList.Price
                             THEN GoodsList.Price
                                  -- ����������� % ������ �� ������������� ��������
                                * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                        ELSE -- ����� ����������� ����� - ��� ���-������� ��� �� ���-�������
                             (GoodsList.Price * (100 - COALESCE (JuridicalSettings.Bonus, 0)) / 100)
                              -- � ����������� % ������ �� ������������� ��������
                           * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                   END :: TFloat AS FinalPrice

                 , LastPriceList_View.ContractId      AS ContractId
                 , Juridical.Id                       AS JuridicalId
                 , Juridical.ValueData                AS JuridicalName
                 , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
                 , COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), Goods.isTOP) AS isTOP
                 , COALESCE (GoodsPrice.PercentMarkup, 0) AS PercentMarkup

                        FROM -- ������� + ���� ...
                    (SELECT DISTINCT * FROM GoodsList) AS GoodsList
                    -- ������ � �����-����� (����������)
            /*        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                     ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                    AND MILinkObject_Goods.ObjectId = GoodsList.GoodsId  -- ����� "����������"
                   
                    -- �����-���� (����������) - MovementItem
                  JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                   
*/                    -- �����-���� (����������) - Movement
                 inner JOIN LastPriceList_find_View AS LastPriceList_View ON LastPriceList_View.MovementId = GoodsList.MovementId

                    -- ���� ������ ������ (��� ���� ��������?) � �����-���� (����������)
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = GoodsList.MovementItemId
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                    -- ��������� ��� ��. ��� (��� ���������� ������������ ������� � �.�)
                   LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = LastPriceList_View.JuridicalId
                                              AND JuridicalSettings.MainJuridicalId = Null---vbMainJuridicalId
                                              AND JuridicalSettings.ContractId      = LastPriceList_View.ContractId
                   -- ����� "����������", ���� �� ���� � ������� !!!� �� ����!!!
                   --LEFT JOIN tmpObject_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = GoodsList.GoodsId
                   -- ����� "����"
                   LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = GoodsList.ObjectId
                   LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = GoodsList.ObjectId

                   -- ���������
                   INNER JOIN Object AS Juridical ON Juridical.Id = LastPriceList_View.JuridicalId

                   -- ���� �������� �� ��������
                  LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                         ON ObjectFloat_Deferment.ObjectId = LastPriceList_View.ContractId
                                        AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

                   -- % ������ �� ������������� ��������
                   LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = GoodsList.ObjectId
                                       AND GoodsPromo.JuridicalId = LastPriceList_View.JuridicalId

       
    WHERE  COALESCE (JuridicalSettings.isPriceClose, FALSE) <> TRUE
            )

    -- ����� ��������� ������
  , FinalList AS
       (SELECT
        ddd.GoodsId

      , ddd.Price
      , ddd.ContractId
      , ddd.JuridicalId
      , ddd.JuridicalName
      , ddd.Deferment
      , ddd.PriceListMovementItemId

      , CASE --- ���� ���� �������� �� �������� = 0 + ���-������� ��������� % �� ... (��� � ������������ ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                  THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
             -- ���� ���� �������� �� �������� = 0 + �� ���-������� = ��������� % �� ��������� ��� ������� ����� (��� � ������������ ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                  THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
             -- ����� �� ���������
             ELSE FinalPrice

        END :: TFloat AS SuperFinalPrice

      , ddd.isTOP
      , ddd.PercentMarkup

    FROM ddd
       -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����)
       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
   )

    -- ������������� �� ���� + ���� �������� � �������� �������
  , MinPriceList AS (SELECT *
                     FROM (SELECT
                                  FinalList.GoodsId
                                , FinalList.Price
                                , FinalList.ContractId
                                , FinalList.JuridicalId
                                , FinalList.JuridicalName
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId ORDER BY FinalList.SuperFinalPrice ASC, FinalList.Deferment DESC, FinalList.PriceListMovementItemId ASC) AS Ord
                           FROM FinalList
                          ) AS T0
                     WHERE T0.Ord = 1
                    )

    -- ���������
    SELECT
        MinPriceList.GoodsId,
        MinPriceList.ContractId,
        MinPriceList.JuridicalId,
        MinPriceList.JuridicalName,
        MinPriceList.Price
    FROM MinPriceList;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 08.06.18         *
*/

-- ����
-- SELECT * FROM lpSelect_GoodsMinPrice_onDate (inOperDate := ('07.6.2018')::TDateTime, inUnitId   := 183288, inObjectId := 4, inUserId   := 3)


-- ����
-- 
/*
SELECT * FROM lpSelect_GoodsMinPrice_onDate (inOperDate := ('08.11.2019')::TDateTime, inUnitId   := 0, inObjectId := 4, inUserId   := 3)
where goodsid IN (766,
769,
772,
775,
799,
811
)
*/
--SELECT * FROM object where id = 183378   1111;1684;"�������� ��� 0,2� N50 (���)"

/*


766;2046;"�������� 25�� (������)"
769;1376;"�������� ��� 50�� N50"
772;2252;"��������� 0,06% 1�� N10 (�����)"
775;2253;"�������� ��� 10�� N100 "
799;1410;"����������� ��� 0,5� N10 (���)"
811;1420;"���������� 30% 1�� N10 (�������)"

*/
--select * from gpSelect_MI_OrderInternalPromo(inMovementId := 15738104 , inIsErased := 'False' ,  inSession := '3');

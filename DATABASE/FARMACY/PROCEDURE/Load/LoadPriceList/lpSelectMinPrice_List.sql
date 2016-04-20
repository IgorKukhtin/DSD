-- Function: lpSelectMinPrice_List()

DROP FUNCTION IF EXISTS lpSelectMinPrice_List (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_List(
    IN inUnitId      Integer      , -- ������
    IN inObjectId    Integer      , -- �������� ����
    IN inUserId      Integer        -- ������������
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
    isOneJuridical     Boolean
)

AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
BEGIN

    -- ����� � ������ "������� �� ����"
    SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;

     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
     THEN
         -- �������
         CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer) ON COMMIT DROP;
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId)
           SELECT DISTINCT Container.ObjectId -- ����� ����� "����"
           FROM Container
           WHERE Container.DescId = zc_Container_Count()
             AND Container.WhereObjectId = inUnitId
             AND Container.Amount <> 0;
     END IF;
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpunitminprice_list')
     THEN
        -- �������
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer) ON COMMIT DROP;
     END IF;

    -- !!!�����������!!!
    ANALYZE _tmpGoodsMinPrice_List;
    ANALYZE _tmpUnitMinPrice_List;

    -- ���������
    RETURN QUERY
    WITH
    -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����) !!!������ ���� ������������ ObjectId!!!
    PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inUserId::TVarChar)
                     )
    -- ��������� ��� ��. ��� (��� ���������� ������������ ������� � �.�)
  , JuridicalSettings_all AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus, tmp.isPriceClose, tmp.isSite
                              FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId) AS tmp
                              WHERE tmp.MainJuridicalId = vbMainJuridicalId
                             )
  , JuridicalSettings_close AS (SELECT DISTINCT tmp.JuridicalId, tmp.ContractId
                                FROM JuridicalSettings_all AS tmp
                                WHERE tmp.isPriceClose = TRUE
                               )
  , JuridicalSettings_new AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus
                                   , ROW_NUMBER() OVER (PARTITION BY tmp.JuridicalId ORDER BY tmp.JuridicalId, CASE WHEN tmp.isSite = TRUE THEN 0 ELSE 1 END, tmp.ContractId) AS Ord
                              FROM JuridicalSettings_all AS tmp
                              -- ��� ����� �����������
                              WHERE tmp.isPriceClose    = FALSE
                             )
    -- �������� � ������ ������� ��� ��� ��� �����
  , JuridicalSettings AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus
                          FROM JuridicalSettings_new AS tmp
                          -- !!!�������� ����.!!!
                          WHERE tmp.Ord = 1
                         )
    -- ������ ������� + ���� ...
  , GoodsList AS
       (SELECT _tmpGoodsMinPrice_List.GoodsId               AS GoodsId      -- ����� ����� "����"
             , ObjectLink_LinkGoods_Main.ChildObjectId      AS GoodsId_main -- ����� "�����" �����
             , ObjectLink_LinkGoods_Child_jur.ChildObjectId AS GoodsId_jur  -- ����� ����� "����������"
             , ObjectLink_Goods_Object_jur.ChildObjectId    AS ObjectId     -- ����� ��� ������ - � ��.����(����������) � ���� � �.�.
        FROM _tmpGoodsMinPrice_List
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child
                                  ON ObjectLink_LinkGoods_Child.ChildObjectId = _tmpGoodsMinPrice_List.GoodsId
                                 AND ObjectLink_LinkGoods_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main
                                  ON ObjectLink_LinkGoods_Main.ObjectId = ObjectLink_LinkGoods_Child.ObjectId
                                 AND ObjectLink_LinkGoods_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()

            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main_jur
                                  ON ObjectLink_LinkGoods_Main_jur.ChildObjectId = ObjectLink_LinkGoods_Main.ChildObjectId
                                 AND ObjectLink_LinkGoods_Main_jur.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child_jur
                                  ON ObjectLink_LinkGoods_Child_jur.ObjectId = ObjectLink_LinkGoods_Main_jur.ObjectId
                                 AND ObjectLink_LinkGoods_Child_jur.DescId = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_Goods_Object_jur
                                  ON ObjectLink_Goods_Object_jur.ObjectId = ObjectLink_LinkGoods_Child_jur.ChildObjectId
                                 AND ObjectLink_Goods_Object_jur.DescId = zc_ObjectLink_Goods_Object()
       )
    -- ������ ��������� ��� (����������) !!!�� ����������!!! (�.�. ��������� �������� � �� ��������� ��������� ����)
  , Movement_PriceList AS
       (-- ���������� � "������" ��������� �� JuridicalSettings
        SELECT tmp.MovementId
             , tmp.JuridicalId
             , tmp.ContractId
             , COALESCE (JuridicalSettings.PriceLimit, 0) AS PriceLimit
             , COALESCE (JuridicalSettings.Bonus, 0)      AS Bonus
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
        FROM (SELECT DISTINCT ObjectId FROM GoodsList) AS tmp
             INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                           ON MovementLinkObject_Juridical.ObjectId = tmp.ObjectId
                                          AND MovementLinkObject_Juridical.DescId   = zc_MovementLinkObject_Juridical()
             INNER JOIN Movement ON Movement.Id     = MovementLinkObject_Juridical.MovementId
                                AND Movement.DescId = zc_Movement_PriceList()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        WHERE Movement.DescId = zc_Movement_PriceList()
       ) AS tmp
        WHERE tmp.Max_Date = tmp.OperDate -- �.�. ��� �������� � �� ���� ����� 1 ��������
       ) AS tmp
        -- !!!INNER!!!
        LEFT JOIN (SELECT DISTINCT JuridicalSettings.JuridicalId, JuridicalSettings.ContractId, JuridicalSettings.PriceLimit, JuridicalSettings.Bonus
                   FROM JuridicalSettings
                  ) AS JuridicalSettings ON JuridicalSettings.JuridicalId = tmp.JuridicalId
        LEFT JOIN JuridicalSettings_close ON JuridicalSettings_close.JuridicalId = tmp.JuridicalId
                                         AND JuridicalSettings_close.ContractId  = tmp.ContractId 

        WHERE COALESCE (JuridicalSettings.ContractId, tmp.ContractId) = tmp.ContractId -- �.�. ���� ���� �� ���� � JuridicalSettings, ����� Movement � !!!����� ��!!! ContractId, ����� - !!!���!! Movement
          AND JuridicalSettings_close.JuridicalId IS NULL -- !!!�.�. �� ������!!!
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
             , GoodsList.GoodsId      -- ����� ����� "����"
             , GoodsList.GoodsId_main -- ����� "�����" �����
             , GoodsList.GoodsId_jur  -- ����� ����� "����������"
             , GoodsList.ObjectId     -- ����� �� ���� ���� ����� ��� � � Movement_PriceList.JuridicalId
        FROM Movement_PriceList
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_PriceList.MovementId
             INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
             INNER JOIN GoodsList ON GoodsList.GoodsId_jur = MILinkObject_Goods.ObjectId -- ����� "����������"
       )

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

      , CASE -- ���� ���� �������� �� �������� = 0 ��� ���-�������
             WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                  THEN FinalPrice
             -- ����� ��������� % �� ��������� ��� ������� ����� (��� � ������������ ... )
             ELSE FinalPrice * (100 - PriceSettings.Percent) / 100

        END :: TFloat AS SuperFinalPrice

      , ddd.isTOP

    FROM (SELECT DISTINCT 
            -- ����� "����"
            MI_PriceList.GoodsId               AS GoodsId
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName  

            -- ������ ���� ����������
          , MI_PriceList.Price
            -- ����������� ���� ���������� - ��� ������ "����"
          , MIN (MI_PriceList.Price) OVER (PARTITION BY MI_PriceList.GoodsId) AS MinPrice
          , MI_PriceList.MovementItemId        AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

          , CASE -- ���� ���-������� ��� ���� ���������� >= PriceLimit (�� ����� ���� ��������� ����� ��� ������� �����. ����)
                 WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE OR COALESCE (MI_PriceList.PriceLimit, 0) <= MI_PriceList.Price
                    THEN MI_PriceList.Price
                 -- ����� ����������� �����
                 ELSE (MI_PriceList.Price * (100 - COALESCE (MI_PriceList.Bonus, 0)) / 100) :: TFloat 
            END AS FinalPrice

          , MI_PriceList.GoodsId_jur           AS Partner_GoodsId
          , ObjectString_Goods_Code.ValueData  AS Partner_GoodsCode
          , Object_Goods_jur_mi.ValueData      AS Partner_GoodsName
          , ObjectString_Goods_Maker.ValueData AS MakerName
          , MI_PriceList.ContractId            AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)      AS isTOP
        
        FROM -- ��������� ���� (����������) �� "������" ������� �� GoodsList
             MI_PriceList
             -- ���� ������ ������ (��� ���� ��������?) � �����-���� (����������)
             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId =  MI_PriceList.MovementItemId
                                       AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            -- ����� "����������", � �� ���� � �������
            LEFT JOIN Object AS Object_Goods_jur_mi ON Object_Goods_jur_mi.Id = MI_PriceList.GoodsId_jur
            LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                   ON ObjectString_Goods_Maker.ObjectId = Object_Goods_jur_mi.Id
                                  AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   
            LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                   ON ObjectString_Goods_Code.ObjectId = Object_Goods_jur_mi.Id
                                  AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()
            -- ����� "����"
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PriceList.GoodsId
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                   AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
            -- ���������
            INNER JOIN Object AS Juridical ON Juridical.Id = MI_PriceList.JuridicalId -- ???���� ����� ��� � ObjectId???

            -- ���� �������� �� ��������
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                  ON ObjectFloat_Deferment.ObjectId = MI_PriceList.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
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
ALTER FUNCTION lpSelectMinPrice_List (Integer, Integer, Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 15.04.16                                        *
*/

/*
SELECT 1, GoodsId            ,    GoodsCode          ,    GoodsName          ,    PartionGoodsDate   ,    Partner_GoodsId    ,      Partner_GoodsCode  ,    Partner_GoodsName  
  ,    MakerName          ,    ContractId         ,    JuridicalId        ,    JuridicalName, Price              ,    SuperFinalPrice, isTop,    isOneJuridical
from lpSelectMinPrice_AllGoods (183292, 4, 3) as a
where GoodsId = 376
union all
 select 2, * from lpSelectMinPrice_List (183292, 4, 3) as b where GoodsId = 376
*/
-- ����
-- SELECT * FROM lpSelectMinPrice_AllGoods (183292, 4, 3) as a join lpSelectMinPrice_List (183292, 4, 3)  as b on b.GoodsId = a.GoodsId WHERE a.Price <> b.Price
-- SELECT * FROM lpSelectMinPrice_List (183292, 4, 3) WHERE GoodsCode = 4797

-- Function: gpGet_PricePartionDate_Cash()

DROP FUNCTION IF EXISTS gpGet_PricePartionDate_Cash (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PricePartionDate_Cash (
    IN inUnitId             Integer,    -- �������������
    IN inGoodsId            Integer,    -- �����
    IN inPartionDateKindId  Integer   , -- 
   OUT outPricePartionDate  TFloat,     --      
    IN inSession            TVarChar    -- ������ ������������
)

RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbAreaId   Integer;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbDividePartionDate   boolean;
   DECLARE vbDiscountExternal    boolean;
   DECLARE vbDivisionParties     Boolean;
BEGIN
-- if inSession = '3' then return; end if;


    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    -- ���� ������������
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');
    -- ��������� ������ ������������
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inSession));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inSession));
    END IF;


    -- �������� ��� ���������� �� ������
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();


    IF EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
              WHERE ObjectBoolean_DividePartionDate.ObjectId = inUnitId
                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate())
    THEN

      SELECT COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)
      INTO vbDividePartionDate
      FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
      WHERE ObjectBoolean_DividePartionDate.ObjectId = inUnitId
        AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate();

    ELSE
      vbDividePartionDate := False;
    END IF;

    IF  zfGet_Unit_DiscountExternal (13216391, inUnitId, vbUserId) = 13216391
    THEN
      vbDiscountExternal := True;
    ELSE
      vbDiscountExternal := False;
    END IF;

    vbDivisionParties := vbRetailId = 4;

    WITH
         tmpObject_Goods AS (SELECT Object_Goods_Retail.id  AS GoodsId
                                  , Object_Goods_Retail.GoodsMainId 
                                  , Object_Goods_Main.NDSKindId
                                  , Object_Goods_Retail.Price
                                  , Object_Goods_Retail.isTop
                                  , COALESCE (Object_Goods_Retail.PercentMarkup, 0)   AS PercentMarkup
                                  , COALESCE (Object_Goods_Retail.Price, 0)           AS Price_retail
                             FROM Object_Goods_Retail
                                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                             WHERE Object_Goods_Retail.RetailId = vbRetailId
                               AND Object_Goods_Retail.ID = inGoodsId)              
       , tmpContainerAll AS (SELECT Container.DescId
                                  , Container.Id
                                  , Container.ParentId
                                  , Container.ObjectId
                                  , Container.Amount
                                  , ContainerLinkObject.ObjectId                                      AS PartionGoodsId
                                  , ContainerLinkObject_DivisionParties.ObjectId                      AS DivisionPartiesId
                             FROM Container

                                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                                ON ContainerLinkObject_DivisionParties.Containerid = COALESCE(Container.ParentId, Container.Id)
                                                               AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()

                             WHERE Container.DescId = zc_Container_CountPartionDate()
                               AND Container.ObjectId = inGoodsId
                               AND Container.WhereObjectId = inUnitId
                             ORDER BY Container.Id
                            )

       , tmpContainerPD AS (SELECT Container.Id
                                 , Container.ParentId
                                 , Container.ObjectId
                                 , Container.Amount
                                 , Container.DivisionPartiesId                                   AS DivisionPartiesId
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                 , COALESCE (ObjectFloat_PartionGoods_ValueMin.ValueData, 0)     AS PercentMin
                                 , COALESCE (ObjectFloat_PartionGoods_ValueLess.ValueData, 0)    AS PercentLess
                                 , COALESCE (ObjectFloat_PartionGoods_Value.ValueData, 0)        AS Percent
                                 , COALESCE (ObjectFloat_PartionGoods_PriceWithVAT.ValueData, 0) AS PriceWithVAT
                                 , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 ��� (��������� ��� �������)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- ����������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- ������ 1 ������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- ������ 1 ������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- ������ 6 ������
                                        ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- ����������� � ���������
                            FROM tmpContainerAll AS Container
                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = Container.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                                                       ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueLess
                                                       ON ObjectFloat_PartionGoods_ValueLess.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_ValueLess.DescId = zc_ObjectFloat_PartionGoods_ValueLess()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                                                       ON ObjectFloat_PartionGoods_Value.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                                                       ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()
                             )

       , tmpCashGoodsPriceWithVAT AS (WITH
                                 DD AS (SELECT DISTINCT Object_MarginCategoryItem_View.MarginPercent,
                                                        Object_MarginCategoryItem_View.MinPrice,
                                                        Object_MarginCategoryItem_View.MarginCategoryId,
                                                        ROW_NUMBER() OVER (PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId
                                                                           ORDER BY Object_MarginCategoryItem_View.MinPrice) AS ORD
                                        FROM Object_MarginCategoryItem_View
                                             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id       = Object_MarginCategoryItem_View.Id
                                                                                           AND Object_MarginCategoryItem.isErased = FALSE
                                       )
                  , MarginCondition AS (SELECT
                                            D1.MarginCategoryId,
                                            D1.MarginPercent,
                                            D1.MinPrice,
                                            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
                                        FROM DD AS D1
                                            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
                                       )

                  , JuridicalSettings AS (SELECT DISTINCT JuridicalId, ContractId, isPriceCloseOrder
                                        FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS JuridicalSettings
                                             LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = JuridicalSettings.MainJuridicalId
                                        WHERE COALESCE (Object_ContractSettings.isErased, FALSE) = FALSE
                                         AND JuridicalSettings.MainJuridicalId <> 5603474
                                       )
                  , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                        , ObjectFloat_NDSKind_NDS.ValueData
                                  FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                  )
                     -- !!!������ �� ������ tmpGoods_PD!!!
                   , tmpGoodsPartner AS (SELECT Object_Goods.GoodsId                              AS GoodsId_retail -- ����� ����
                                              , Object_Goods.GoodsMainId                          AS GoodsId_main   -- ����� �������
                                              , Object_Goods_Juridical.Id                         AS GoodsId_jur    -- ����� ����������
                                              , Object_Goods_Juridical.Code                       AS GoodsCode_jur  -- ����� ����������
                                              , Object_Goods_Juridical.JuridicalId                AS JuridicalId    -- ���������
                                              , Object_Goods.isTop                                AS isTOP          -- ��� � ���. ����
                                              , COALESCE (Object_Goods.PercentMarkup, 0)          AS PercentMarkup  -- % ���. � ���. ����
                                              , COALESCE (Object_Goods.Price, 0)                  AS Price_retail   -- ������������� ���� � ���. ����
                                              , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)   AS NDS            -- NDS � ���. �������
                                         FROM tmpObject_Goods AS Object_Goods

                                              LEFT JOIN Object_Goods_Juridical AS Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods.GoodsMainId

                                              LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId
                                                                --   AND ObjectFloat_NDSKind_NDS.DescId   = zc_ObjectFloat_NDSKind_NDS()
                                        )

                   , _GoodsPriceAll AS (SELECT tmpGoodsPartner.GoodsId_retail         AS GoodsId, -- ����� ����
                                               zfCalc_SalePrice ((LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS) / 100),                         -- ���� � ���
                                                                 CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                                                          THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                                                                      ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)
                                                                 END,                                                                             -- % ������� � ���������
                                                                 COALESCE (tmpGoodsPartner.isTOP, FALSE),                                         -- ��� �������
                                                                 COALESCE (tmpGoodsPartner.PercentMarkup, 0),                                     -- % ������� � ������
                                                                 0.0, --ObjectFloat_Juridical_Percent.ValueData,                                  -- % ������������� � �� ���� ��� ����
                                                                 tmpGoodsPartner.Price_retail                                                            -- ���� � ������ (�������������)
                                                               )         :: TFloat AS Price,
                                               LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS)/100 AS PriceWithVAT

                                        FROM LoadPriceListItem

                                             INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                                             LEFT JOIN JuridicalSettings
                                                     ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                                                    AND JuridicalSettings.ContractId  = LoadPriceList.ContractId

                                             -- !!!���������� ������ ���� �������!!!
                                             INNER JOIN tmpGoodsPartner ON tmpGoodsPartner.JuridicalId   = LoadPriceList.JuridicalId
                                                                       AND tmpGoodsPartner.GoodsId_main  = LoadPriceListItem.GoodsId
                                                                       AND tmpGoodsPartner.GoodsCode_jur = LoadPriceListItem.GoodsCode

                                             LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                                                   ON ObjectFloat_Juridical_Percent.ObjectId = LoadPriceList.JuridicalId
                                                                  AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                                             LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                                                   ON ObjectFloat_Contract_Percent.ObjectId = LoadPriceList.ContractId
                                                                  AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

                                             LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                                                      ON Object_MarginCategoryLink.UnitId = inUnitId
                                                                                     AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

                                             LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                                                      ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                                                     AND Object_MarginCategoryLink_all.JuridicalId = LoadPriceList.JuridicalId
                                                                                     AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                                                     AND Object_MarginCategoryLink.JuridicalId IS NULL

                                             LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                                                  -- AND (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
                                                                     AND (LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

                                        WHERE COALESCE(JuridicalSettings.isPriceCloseOrder, TRUE)  = FALSE
                                          AND (LoadPriceList.AreaId = 0 OR COALESCE (LoadPriceList.AreaId, 0) = vbAreaId OR COALESCE(vbAreaId, 0) = 0
                                            OR COALESCE (LoadPriceList.AreaId, 0) = zc_Area_Basis()
                                              )
                                       )
                              , GoodsPriceAll AS (SELECT
                                                       ROW_NUMBER() OVER (PARTITION BY _GoodsPriceAll.GoodsId ORDER BY _GoodsPriceAll.Price)::Integer AS Ord,
                                                       _GoodsPriceAll.GoodsId           AS GoodsId,
                                                       _GoodsPriceAll.PriceWithVAT      AS PriceWithVAT
                                                  FROM _GoodsPriceAll
                                                 )
                            -- ��������� - ����-����
                            SELECT GoodsPriceAll.GoodsId      AS Id,
                                   GoodsPriceAll.PriceWithVAT AS PriceWithVAT
                            FROM GoodsPriceAll
                            WHERE Ord = 1
                           )
       , tmpPDPriceWithVAT AS (SELECT ROW_NUMBER()OVER(PARTITION BY Container.ObjectId, Container.PartionDateKindId ORDER BY Container.Id DESC) as ORD
                                    , Container.ObjectId
                                    , Container.PartionDateKindId
                                    , CASE WHEN Container.PriceWithVAT <= 15
                                           THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                           ELSE Container.PriceWithVAT END       AS PriceWithVAT
                                    , CASE WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_Good(), zc_Enum_PartionDateKind_0())
                                           THEN 0
                                           WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_6())
                                           THEN Container.Percent
                                           WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_Cat_5())
                                           THEN Container.PercentLess
                                           WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_1())
                                           THEN Container.PercentMin
                                           ELSE Null END::TFloat                  AS PartionDateDiscount
                               FROM tmpContainerPD AS Container
                                    LEFT JOIN tmpCashGoodsPriceWithVAT ON tmpCashGoodsPriceWithVAT.ID = Container.ObjectId
                               WHERE Container.PartionDateKindId = inPartionDateKindId
                               )

       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           -- ���� ���� ��� ���� ����
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                          AND Price_Goods.ChildObjectId           = inGoodsId
                        )
       , tmpPriceWithVAT AS (SELECT tmpPDPriceWithVAT.PriceWithVAT::TFloat    AS PriceWithVAT
                                  , tmpPDPriceWithVAT.PartionDateDiscount 
                             FROM tmpPDPriceWithVAT 
                             WHERE tmpPDPriceWithVAT.ObjectId = inGoodsId
                               AND tmpPDPriceWithVAT.PartionDateKindId = inPartionDateKindId
                               AND tmpPDPriceWithVAT.Ord = 1)
       , tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                               , MI_IntenalSP.ObjectId         AS IntenalSPId
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_PaymentSP.ValueData   AS PaymentSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIString_IdSP.ValueData       AS IdSP
                               , COALESCE (MIString_ProgramIdSP.ValueData, '')::TVarChar AS ProgramIdSP
                               , MIString_DosageIdSP.ValueData AS DosageIdSP
                                                                -- � �/� - �� ������ ������
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE

                               LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                                ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                               AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                               -- ��������  ���� �� ��������, ���
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                           ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
                               -- ����� ������������ �� �������� (���. ������) - (15)
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                           ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                               -- ���� ������� �� ��������, ��� (���. ������) - 16)
                               LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                           ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()

                               -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                           ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                               -- ID ���������� ������
                               LEFT JOIN MovementItemString AS MIString_IdSP
                                                            ON MIString_IdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_IdSP.DescId = zc_MIString_IdSP()
                               LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                                            ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()
                               -- DosageID ���������� ������
                               LEFT JOIN MovementItemString AS MIString_DosageIdSP
                                                            ON MIString_DosageIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_DosageIdSP.DescId = zc_MIString_DosageIdSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )

                 , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                             , Object_Object.Id                                          AS GoodsDiscountId
                                             , Object_Object.ValueData                                   AS GoodsDiscountName
                                             , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                             , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                                          FROM Object AS Object_BarCode
                                              INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                    ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                                   AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                              INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                              LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                   ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                                  AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                              LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                              LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                                      ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id 
                                                                     AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()

                                              LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                                    ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                                   AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                          WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                            AND Object_BarCode.isErased = False
                                          GROUP BY Object_Goods_Retail.GoodsMainId
                                                 , Object_Object.Id
                                                 , Object_Object.ValueData
                                                 , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False))


    SELECT CASE WHEN tmpObject_Goods.isTop = TRUE
                 AND tmpObject_Goods.Price > 0
                THEN zfCalc_PriceCash(COALESCE(tmpObject_Goods.Price,0), 
                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) 
           ELSE
           CASE WHEN COALESCE(inPartionDateKindId, 0) <> 0  THEN
                    CASE WHEN zfCalc_PriceCash(COALESCE(tmpObject_Price.Price,0), 
                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) > tmpPriceWithVAT.PriceWithVAT
                         THEN ROUND(zfCalc_PriceCash(COALESCE(tmpObject_Price.Price,0), 
                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) - (zfCalc_PriceCash(COALESCE(tmpObject_Price.Price,0), 
                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) - tmpPriceWithVAT.PriceWithVAT) *
                                    tmpPriceWithVAT.PartionDateDiscount / 100, 2)
                         ELSE zfCalc_PriceCash(COALESCE(tmpObject_Price.Price,0), 
                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                    END
                ELSE NULL
           END END                                          :: TFloat AS PricePartionDate
    INTO outPricePartionDate
    FROM tmpPriceWithVAT
         LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = inGoodsId
         LEFT OUTER JOIN tmpObject_Goods ON tmpObject_Goods.GoodsId = inGoodsId
         LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = tmpObject_Goods.GoodsMainId
         -- ��� ������
         LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = tmpObject_Goods.GoodsMainId
                             AND tmpGoodsSP.Ord     = 1 -- � �/� - �� ������ ������
    ;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_CashSession (TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.08.21                                                       *
*/

--����
--
SELECT * FROM gpGet_PricePartionDate_Cash (inUnitId := 8156016 , inGoodsId := 12958235 , inPartionDateKindId := 14542625, inSession := '3');
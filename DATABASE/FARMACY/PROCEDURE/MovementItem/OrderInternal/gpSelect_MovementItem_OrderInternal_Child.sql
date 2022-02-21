-- Function: gpSelect_MovementItem_OrderInternal_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal_Child (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inIsLink      Boolean      , -- проверка привязки к поставщику
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                       Integer
             , MovementItemId            Integer
             , PriceListMovementItemId   Integer
             , Price                     TFloat
             , PartionGoodsDate          TDateTime
             , GoodsId                   Integer
             , GoodsCode                 TVarChar
             , GoodsName                 TVarChar
             , MainGoodsName             TVarChar
             , NDS_PriceList             TVarChar
             , JuridicalId               Integer
             , JuridicalName             TVarChar
             , MakerName                 TVarChar
             , ContractId                Integer
             , ContractName              TVarChar
             , AreaId                    Integer
             , AreaName                  TVarChar
             , isDefault                 Boolean
             , Deferment                 Integer
             , Bonus                     TFloat
             , Percent                   TFloat
             , SuperFinalPrice           TFloat
             , SuperFinalPrice_Deferment TFloat

             , PartionGoodsDateColor     Integer
             , MinimumLot                TFloat
             , Remains                   TFloat

             , Persent_Deferment         TFloat

             , isPromo                   Boolean
             , OperDatePromo             TDateTime
             , InvNumberPromo            TVarChar
             , ChangePercentPromo        TFLoat

             , ConditionsKeepName        TVarChar
             , AreaName_Goods            TVarChar

             , isSupplierFailures        Boolean

             , SupplierFailuresColor Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDateEnd TDateTime;
  DECLARE vbisDocument Boolean;
  DECLARE vbDate180 TDateTime;

  DECLARE vbMainJuridicalId Integer;

  DECLARE vbCURRENT_DOW Integer;

  DECLARE vbAreaId_find Integer;

  DECLARE vbAVGDateStart TDateTime; --Дата нач. расчета ср. цены
  DECLARE vbAVGDateEnd TDateTime;   --Дата окон. расчета ср. цены

  DECLARE vbCostCredit TFloat;

BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
    vbUserId := inSession;

-- if inSession <> '3'
-- then
--     RAISE EXCEPTION 'Повторите действие через 15 мин.';
-- end if;

     -- получаем значение константы
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

    vbCURRENT_DOW := CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0 THEN 7 ELSE EXTRACT (DOW FROM CURRENT_DATE) END ; -- день недели сегодня

    --
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    SELECT COALESCE(MB_Document.ValueData, FALSE) :: Boolean AS isDocument
         , Movement.StatusId
   INTO vbisDocument, vbStatusId
    FROM Movement
        LEFT JOIN MovementBoolean AS MB_Document
               ON MB_Document.MovementId = Movement.Id
              AND MB_Document.DescId = zc_MovementBoolean_Document()
    WHERE Movement.Id =inMovementId;

--
    SELECT MovementLinkObject.ObjectId
    INTO vbUnitId
    FROM MovementLinkObject
    WHERE MovementLinkObject.MovementId = inMovementId
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

    -- определим дату документа
    SELECT date_trunc('day', Movement.OperDate)
    INTO vbOperDate
    FROM Movement
    WHERE Movement.Id = inMovementId;

    vbOperDateEnd := vbOperDate + INTERVAL '1 DAY';
    vbDate180 := CURRENT_DATE + zc_Interval_ExpirationDate()+ zc_Interval_ExpirationDate();   -- нужен 1 год (функция =6 мес.)
    --vbDate180 := CURRENT_DATE + INTERVAL '180 DAY';


    vbAVGDateStart := vbOperDate - INTERVAL '30 day';
    vbAVGDateEnd   := vbOperDate;

    -- таблица Регион поставщика
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpJuridicalArea'))
    THEN
      DROP TABLE IF EXISTS tmpJuridicalArea;
    END IF;

    CREATE TEMP TABLE tmpJuridicalArea (UnitId Integer, JuridicalId Integer, AreaId Integer, AreaName TVarChar, isDefault Boolean) ON COMMIT DROP;
      INSERT INTO tmpJuridicalArea (UnitId, JuridicalId, AreaId, AreaName, isDefault)
                  SELECT DISTINCT
                         tmp.UnitId                   AS UnitId
                       , tmp.JuridicalId              AS JuridicalId
                       , tmp.AreaId_Juridical         AS AreaId
                       , tmp.AreaName_Juridical       AS AreaName
                       , tmp.isDefault_JuridicalArea  AS isDefault
                  FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId, 0) AS tmp;

    -- !!!Только для таких документов - 1-ая ВЕТКА (ВСЕГО = 3)!!!
    IF vbisDocument = TRUE AND vbStatusId = zc_Enum_Status_Complete()
    AND (inShowAll = FALSE OR inSession <> '3')
    THEN

     PERFORM lpCreateTempTable_OrderInternal_MI(inMovementId, vbObjectId, 0, vbUserId);

     SELECT ObjectLink_Unit_Juridical.ChildObjectId
         INTO vbMainJuridicalId
     FROM MovementLinkObject
          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject.ObjectId
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
     WHERE MovementLinkObject.MovementId = inMovementId
       AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

  --raise notice 'Value: %', 1;

     RETURN QUERY
     WITH
        PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (vbUserId::TVarChar))
      , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar))

      , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)

        -- элементы установок юр.лиц (границы цен для бонуса)
      , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                          , tmp.Bonus
                                          , tmp.PriceLimit_min
                                          , tmp.PriceLimit
                                     FROM JuridicalSettings
                                          INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inSession) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                     WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                     )
       -- Маркетинговый контракт
      , GoodsPromo AS (SELECT tmp.JuridicalId
                            , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- здесь товар "сети"
                            , tmp.MovementId
                            , tmp.ChangePercent
                            , COALESCE(MovementPromo.OperDate, NULL)  :: TDateTime   AS OperDatePromo
                            , COALESCE(MovementPromo.InvNumber, '') ::  TVarChar     AS InvNumberPromo -- ***
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp   --CURRENT_DATE
                                        INNER JOIN ObjectLink AS ObjectLink_Child
                                                              ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                             AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                        INNER JOIN  ObjectLink AS ObjectLink_Main
                                                               ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                              AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                        INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                              ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                             AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                        INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                              ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                             AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                        INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                              ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                             AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                        LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                      )

      , tmpMI_Child AS (SELECT MI_Child.ParentId
                             , MI_Child.Id
                             , MI_Child.ObjectId
                             , MI_Child.Amount
                             , Object_Juridical.Id                  AS JuridicalId
                             , Object_Juridical.ValueData           AS JuridicalName
                             , Object_Contract.Id                   AS ContractId
                             , Object_Contract.ValueData            AS ContractName
                             , Object_Area.Id                       AS AreaId
                             , Object_Area.ValueData                AS AreaName
                             , COALESCE(MIDate_PartionGoods.ValueData, NULL) ::TDateTime AS PartionGoodsDate
                             , MIFloat_Price.ValueData                       AS Price
                             , MIFloat_JuridicalPrice.ValueData    ::TFLoat  AS SuperFinalPrice
                             , MIFloat_DefermentPrice.ValueData    ::TFloat  AS SuperFinalPrice_Deferment
                        FROM MovementItem AS MI_Child
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                         ON MIFloat_MovementItemId.MovementItemId = MI_Child.Id
                                                        AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                             LEFT JOIN MovementItem AS PriceListMovementItem
                                                    ON PriceListMovementItem.Id = MIFloat_MovementItemId.ValueData::Integer

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                          ON MovementLinkObject_Juridical.MovementId = PriceListMovementItem.MovementId
                                                         AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                          ON MovementLinkObject_Contract.MovementId = PriceListMovementItem.MovementId
                                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                          ON MovementLinkObject_Area.MovementId = PriceListMovementItem.MovementId
                                                         AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
                             LEFT JOIN Object AS Object_Area ON Object_Area.Id = MovementLinkObject_Area.ObjectId

                             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                       AND MIDate_PartionGoods.MovementItemId =  MI_Child.Id
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId =  MI_Child.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                         ON MIFloat_JuridicalPrice.MovementItemId =  MI_Child.Id
                                                        AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                             LEFT JOIN MovementItemFloat AS MIFloat_DefermentPrice
                                                         ON MIFloat_DefermentPrice.MovementItemId = MI_Child.Id
                                                        AND MIFloat_DefermentPrice.DescId = zc_MIFloat_DefermentPrice()

                        WHERE MI_Child.MovementId = inMovementId
                          AND MI_Child.DescId     = zc_MI_Child()
                          AND (MI_Child.IsErased = inIsErased OR inIsErased = TRUE)
                        )
--
      , tmpMIString AS (SELECT MIString.*
                        FROM MovementItemString AS MIString
                        WHERE MIString.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                        )
      , tmpJuridical AS (SELECT MILinkObject_Juridical.MovementItemId
                              , Object_Juridical.Id                 AS JuridicalId
                              , Object_Juridical.ValueData          AS JuridicalName
                         FROM MovementItemLinkObject AS MILinkObject_Juridical
                              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId
                         WHERE MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()     ------and 1=0
                           AND MILinkObject_Juridical.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                        )
      --
      , tmpContract_ AS (SELECT MILinkObject_Contract.MovementItemId
                              , MILinkObject_Contract.ObjectId      AS ContractId
                        FROM MovementItemLinkObject AS MILinkObject_Contract
                        WHERE MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                          AND MILinkObject_Contract.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                        )
      , tmpOF_Deferment AS (SELECT ObjectFloat_Deferment.*
                            FROM ObjectFloat AS ObjectFloat_Deferment
                            WHERE ObjectFloat_Deferment.ObjectId IN (SELECT DISTINCT tmpContract_.ContractId FROM tmpContract_)
                              AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
                           )
      , tmpContract AS (SELECT tmpContract_.MovementItemId
                             , Object_Contract.Id                 AS ContractId
                             , Object_Contract.ValueData          AS ContractName
                             , ObjectFloat_Deferment.ValueData    AS Deferment
                        FROM tmpContract_
                             LEFT JOIN tmpOF_Deferment AS ObjectFloat_Deferment
                                                       ON ObjectFloat_Deferment.ObjectId = tmpContract_.ContractId
                                                      AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
                             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpContract_.ContractId
                        )
        ---
      , tmpOF_MinimumLot AS (SELECT ObjectFloat_Goods_MinimumLot.*
                             FROM ObjectFloat AS ObjectFloat_Goods_MinimumLot
                             WHERE ObjectFloat_Goods_MinimumLot.ObjectId IN (SELECT DISTINCT tmpMI_Child.ObjectId FROM tmpMI_Child)
                               AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                             )
      , tmpOL_ConditionsKeep AS (SELECT ObjectLink.*
                                 FROM ObjectLink
                                 WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpMI_Child.ObjectId FROM tmpMI_Child)
                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                 )
      , tmpGoods AS (SELECT tmpMI_Child.ObjectId                      AS GoodsId
                          , ObjectString_Goods_Code.ValueData         AS GoodsCode
                          , Object_Goods.ValueData                    AS GoodsName
                          , ObjectFloat_Goods_MinimumLot.ValueData    AS MinimumLot
                          , Object_ConditionsKeep.ValueData           AS ConditionsKeepName
                     FROM tmpMI_Child
                          -- условия хранения
                          LEFT JOIN tmpOL_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep
                                                         ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmpMI_Child.ObjectId
                                                        --AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                          LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

                          LEFT JOIN tmpOF_MinimumLot AS ObjectFloat_Goods_MinimumLot
                                                     ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI_Child.ObjectId
                                               --AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()

                          LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                                 ON ObjectString_Goods_Code.ObjectId = tmpMI_Child.ObjectId
                                                AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()

                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Child.ObjectId
                    )

      -- данные по % кредитных средств из справочника
      , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)

      -- НДС из прайс-листа поставщика (LoadPriceList )
      , tmpLoadPriceList_NDS AS (SELECT *
                                 FROM (SELECT LoadPriceListItem.CommonCode
                                            , LoadPriceListItem.GoodsName
                                            , LoadPriceListItem.GoodsNDS
                                            , LoadPriceListItem.GoodsId
                                            , PartnerGoods.Id AS PartnerGoodsId
                                            , LoadPriceList.JuridicalId
                                            , ROW_NUMBER() OVER (PARTITION BY LoadPriceList.JuridicalId, LoadPriceListItem.GoodsId ORDER BY LoadPriceList.OperDate DESC, LoadPriceListItem.Id DESC) AS ORD
                                       FROM _tmpOrderInternal_MI AS tmpMI

                                            INNER JOIN LoadPriceList ON LoadPriceList.JuridicalId = tmpMI.JuridicalId
                                                                    AND LoadPriceList.ContractId = tmpMI.ContractId

                                            INNER JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                                                                        AND COALESCE (LoadPriceListItem.GoodsNDS,'') <> ''

                                            INNER JOIN Object_Goods_Juridical AS PartnerGoods ON PartnerGoods.JuridicalId  = LoadPriceList.JuridicalId
                                                                                             AND PartnerGoods.Code = LoadPriceListItem.GoodsCode
                                                                                             AND PartnerGoods.Id = tmpMI.PartnerGoodsId

                                       ) AS tmp
                                 WHERE tmp.ORD = 1
                                 )

        SELECT tmpMI.Id
             , tmpMI.MovementItemId
             , MI_Child.Id                                               AS PriceListMovementItemId
             , MI_Child.Price
             , MI_Child.PartionGoodsDate
             , tmpMI.GoodsId
             , COALESCE(MIString_GoodsCode.ValueData, tmpGoods.GoodsCode) AS GoodsCode
             , COALESCE(MIString_GoodsName.ValueData, tmpGoods.GoodsName) AS GoodsName
             , Null :: TVarChar                                           AS MainGoodsName
             , CASE WHEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'0') <> '0' THEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'') ELSE '' END  :: TVarChar AS NDS_PriceList
             , COALESCE(MI_Child.JuridicalId, tmpMI.JuridicalId)
             , COALESCE(MI_Child.JuridicalName, tmpMI.JuridicalName)
             , tmpMI.MakerName
             , COALESCE(MI_Child.ContractId, tmpMI.ContractId)
             , COALESCE(MI_Child.ContractName, tmpMI.ContractName)
             , COALESCE(MI_Child.AreaId, tmpJuridicalArea.AreaId)        AS AreaId
             , COALESCE (MI_Child.AreaName, tmpJuridicalArea.AreaName, '')      :: TVarChar AS AreaName
             , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean  AS isDefault
             , COALESCE (tmpContract.Deferment, 0)::Integer              AS Deferment
             , COALESCE(JuridicalSettings.Bonus, 0)::TFloat              AS Bonus
             , CASE WHEN COALESCE (tmpContract.Deferment, 0) = 0
                         THEN 0
                    WHEN tmpMI.isTOP = TRUE
                         THEN COALESCE (PriceSettingsTOP.Percent, 0)
                    ELSE PriceSettings.Percent
               END :: TFloat AS Percent
             , MI_Child.SuperFinalPrice
             , MI_Child.SuperFinalPrice_Deferment


             , CASE WHEN MI_Child.PartionGoodsDate < vbDate180 THEN zc_Color_Red() --zc_Color_Blue() --456
                    ELSE 0
               END                                           AS PartionGoodsDateColor
             , tmpGoods.MinimumLot                 ::TFLoat  AS MinimumLot
             , MI_Child.Amount                     ::TFLoat  AS Remains

             , (tmpContract.Deferment * COALESCE (tmpCostCredit.Percent, vbCostCredit) ) ::TFloat  AS Persent_Deferment

             , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromo

             , COALESCE(GoodsPromo.OperDatePromo, NULL)   :: TDateTime  AS OperDatePromo
             , COALESCE(GoodsPromo.InvNumberPromo, '')    :: TVarChar   AS InvNumberPromo -- ***
             , COALESCE(GoodsPromo.ChangePercent, 0)      :: TFLoat     AS ChangePercentPromo
             , COALESCE(tmpGoods.ConditionsKeepName, '')  :: TVarChar   AS ConditionsKeepName

             , Object_Area.ValueData                         :: TVarChar AS AreaName_Goods
             
             , COALESCE (MIBoolean_SupplierFailures.ValueData, False)    AS isSupplierFailures

             , CASE
                    WHEN COALESCE (MIBoolean_SupplierFailures.ValueData, False) THEN zfCalc_Color (255, 165, 0) -- orange
                    ELSE zc_Color_White()
                END  AS SupplierFailuresColor

        FROM _tmpOrderInternal_MI AS tmpMI
             INNER JOIN tmpMI_Child AS MI_Child ON MI_Child.ParentId = tmpMI.MovementItemId
             LEFT JOIN tmpGoods                 ON tmpGoods.GoodsId  = MI_Child.ObjectId

             LEFT JOIN tmpJuridical                                        ON tmpJuridical.MovementItemId           = MI_Child.Id
             LEFT JOIN tmpContract                                         ON tmpContract.MovementItemId            = MI_Child.Id

             LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = tmpJuridical.JuridicalId --MovementItemLastPriceList_View.JuridicalId
                                        AND JuridicalSettings.ContractId  = tmpContract.ContractId     --MovementItemLastPriceList_View.ContractId
             LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                               AND MI_Child.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                               AND MI_Child.Price <= tmpJuridicalSettingsItem.PriceLimit

             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpJuridical.JuridicalId
                                 AND GoodsPromo.GoodsId     = tmpMI.GoodsId            --             ----and 1=0

             LEFT JOIN PriceSettings    ON MI_Child.Price BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice  -- ----and 1=0
             LEFT JOIN PriceSettingsTOP ON MI_Child.Price BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice  -- ----and 1=0

             --LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = GoodsPromo.MovementId
             LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = tmpJuridical.JuridicalId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

            LEFT JOIN tmpCostCredit ON MI_Child.Price BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit

            LEFT JOIN tmpLoadPriceList_NDS ON tmpLoadPriceList_NDS.PartnerGoodsId = tmpMI.PartnerGoodsId
                                          AND tmpLoadPriceList_NDS.JuridicalId = tmpMI.JuridicalId

            LEFT JOIN tmpMIString AS MIString_GoodsCode
                                         ON MIString_GoodsCode.MovementItemId = MI_Child.Id
                                        AND MIString_GoodsCode.DescId = zc_MIString_GoodsCode()
                                        AND vbStatusId = zc_Enum_Status_Complete()
            LEFT JOIN tmpMIString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = MI_Child.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
                                        AND vbStatusId = zc_Enum_Status_Complete()

            LEFT JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                          ON MIBoolean_SupplierFailures.MovementItemId = MI_Child.Id
                                         AND MIBoolean_SupplierFailures.DescId = zc_MIBoolean_SupplierFailures()

          ;


    -- !!!Только для ДРУГИХ документов + inShowAll = FALSE - 2-ая ВЕТКА (ВСЕГО = 3)!!!
    ELSEIF inShowAll = FALSE
    THEN

      --raise notice 'Value: %', 2;

--    PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);

     -- ПАРАМЕТРЫ
     SELECT ObjectLink_Unit_Juridical.ChildObjectId, MovementLinkObject.ObjectId, COALESCE (ObjectLink_Unit_Area.ChildObjectId, zc_Area_Basis())
            INTO vbMainJuridicalId, vbUnitId, vbAreaId_find
         FROM MovementLinkObject
              --INNER JOIN Object_Unit_View ON Object_Unit_View.Id = MovementLinkObject.ObjectId
              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

              LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                   ON ObjectLink_Unit_Area.ObjectId = MovementLinkObject.ObjectId
                                  AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
     WHERE MovementLinkObject.MovementId = inMovementId
       AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();


     -- таблица Регион поставщика
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpJuridicalArea'))
     THEN
         CREATE TEMP TABLE tmpJuridicalArea (UnitId Integer, JuridicalId Integer, AreaId Integer, AreaName TVarChar, isDefault Boolean) ON COMMIT DROP;
         INSERT INTO tmpJuridicalArea (UnitId, JuridicalId, AreaId, AreaName, isDefault)
            SELECT DISTINCT
                   tmp.UnitId                   AS UnitId
                 , tmp.JuridicalId              AS JuridicalId
                 , tmp.AreaId_Juridical         AS AreaId
                 , tmp.AreaName_Juridical       AS AreaName
                 , tmp.isDefault_JuridicalArea  AS isDefault
            FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId, 0) AS tmp;
     END IF;


     -- ДАННЫЕ
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMI'))
     THEN
       DROP TABLE IF EXISTS _tmpMI;
     END IF;

     CREATE TEMP TABLE _tmpMI (Id integer
                             , MovementItemId Integer
                             , PriceListMovementItemId Integer
                             , Price TFloat
                             , PartionGoodsDate TDateTime
                             , GoodsId Integer
                             , GoodsCode TVarChar
                             , GoodsName TVarChar
                             , MainGoodsName TVarChar
                             , JuridicalId Integer
                             , JuridicalName TVarChar
                             , MakerName TVarChar
                             , ContractId Integer
                             , ContractName TVarChar
                             , AreaId Integer
                             , AreaName TVarChar
                             , isDefault Boolean
                             , Deferment Integer
                             , Bonus TFloat
                             , Percent TFloat
                             , SuperFinalPrice TFloat
                             , SuperFinalPrice_Deferment TFloat) ON COMMIT DROP;


      -- Сохраниели данные
      INSERT INTO _tmpMI

           WITH -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
                PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (vbUserId::TVarChar))
              , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar))

              , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)

                -- элементы установок юр.лиц (границы цен для бонуса)
              , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                                  , tmp.Bonus
                                                  , tmp.PriceLimit_min
                                                  , tmp.PriceLimit
                                             FROM JuridicalSettings
                                                  INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inSession) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                             WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                             )

              , JuridicalArea AS (SELECT DISTINCT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                                  FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                       INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                AND Object_JuridicalArea.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                             ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                            AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                            AND ObjectLink_JuridicalArea_Area.ChildObjectId = vbAreaId_find
                                       -- Уникальный код поставщика ТОЛЬКО для Региона
                                       INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                                ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                  WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                 )

              , MovementItemOrder AS (SELECT MovementItem.*
                                           , ObjectLink_Main.ChildObjectId AS GoodsMainId, ObjectLink_LinkGoods_Goods.ChildObjectId AS GoodsId
                                      FROM MovementItem
                                       --  INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.ObjectId -- Связь товара сети с общим
                                       -- получаем GoodsMainId
                                           INNER JOIN  ObjectLink AS ObjectLink_Child
                                                                  ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                         --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                         --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                           -- товары сети по главному GoodsMainId
                                           LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                                ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                                               AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_Main.ChildObjectId --Object_LinkGoods_View.GoodsMainId

                                           LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                                ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                               AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                                                ON ObjectLink_Goods_Area.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Object.DescId   = zc_ObjectLink_Goods_Object()
                                           LEFT JOIN JuridicalArea ON JuridicalArea.JuridicalId = ObjectLink_Goods_Object.ChildObjectId

                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND (ObjectLink_Goods_Area.ChildObjectId = vbAreaId_find OR JuridicalArea.JuridicalId IS NULL)
                                  )
                -- Маркетинговый контракт
              , tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- здесь товар "сети"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUnitId  := vbUnitId
                                                                                       , inUserId  := vbUserId) AS tmp
                                      )
                -- Список цены + ТОП
              , GoodsPrice AS (SELECT MovementItemOrder.ObjectId AS GoodsId, ObjectBoolean_Top.ValueData AS isTOP
                               FROM MovementItemOrder
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                          ON ObjectLink_Price_Goods.ChildObjectId = MovementItemOrder.ObjectId
                                                         AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                          ON ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                                         AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                         AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Top
                                                             ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                            AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                            AND ObjectBoolean_Top.ValueData = TRUE
                              )

              , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceList.JuridicalId
                                          , LoadPriceList.ContractId
                                          , LoadPriceList.AreaId
                                     FROM LoadPriceList
                                     )

      -- данные по % кредитных средств из справочника
      , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)
      , tmpMovementItemLastPriceList_View AS (SELECT LastMovement.MovementId
                                                   , LastMovement.JuridicalId
                                                   , LastMovement.ContractId
                                                   , Max(MovementItem.Id)::Integer      AS MovementItemId
                                                   , COALESCE(MIFloat_Price.ValueData, MovementItem.Amount)::TFloat  AS Price
                                                   , MILinkObject_Goods.ObjectId        AS GoodsId
                                                   , ObjectString_GoodsCode.ValueData   AS GoodsCode
                                                   , Object_Goods.ValueData             AS GoodsName
                                                   , ObjectString_Goods_Maker.ValueData AS MakerName
                                                   , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
                                                   , LastMovement.AreaId                AS AreaId
                                              FROM
                                                  (
                                                      SELECT
                                                          PriceList.JuridicalId
                                                        , PriceList.ContractId
                                                        , PriceList.AreaId
                                                        , PriceList.MovementId
                                                      FROM
                                                          (
                                                              SELECT
                                                                  MAX (Movement.OperDate)
                                                                  OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId
                                                                                   , COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                                                                   , COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                                                       ) AS Max_Date
                                                                , Movement.OperDate                                  AS OperDate
                                                                , Movement.Id                                        AS MovementId
                                                                , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
                                                                , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                                                , COALESCE (MovementLinkObject_Area.ObjectId, 0)     AS AreaId
                                                              FROM
                                                                  Movement
                                                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                                               ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                                                              AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                                                               ON MovementLinkObject_Area.MovementId = Movement.Id
                                                                                              AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
                                                                  INNER JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementLinkObject_Juridical.ObjectId
                                                                                             AND tmpJuridicalArea.AreaId      = COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                                              WHERE
                                                                  Movement.DescId = zc_Movement_PriceList()
                                                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                          ) AS PriceList
                                                      WHERE PriceList.Max_Date = PriceList.OperDate
                                                  ) AS LastMovement
                                                  INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                                                                         AND MovementItem.DescId = zc_MI_Master()
                                                                         AND MovementItem.isErased = False
                                                  INNER JOIN MovementItemLinkObject AS MILinkObject_Goods -- товары в прайс-листе
                                                                                    ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                                                   AND MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                  INNER JOIN MovementItemOrder ON MovementItemOrder.GoodsId =  MILinkObject_Goods.ObjectId

                                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                              ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                                  LEFT OUTER JOIN Object AS Object_Goods
                                                                         ON Object_Goods.Id = MILinkObject_Goods.ObjectId
                                                  LEFT JOIN ObjectString AS ObjectString_GoodsCode
                                                                         ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
                                                                        AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
                                                  LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                                                         ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                                                                        AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()
                                                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                             ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                                            AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                              GROUP BY LastMovement.MovementId
                                                     , LastMovement.JuridicalId
                                                     , LastMovement.ContractId
                                                     , COALESCE(MIFloat_Price.ValueData, MovementItem.Amount)::TFloat
                                                     , MILinkObject_Goods.ObjectId
                                                     , ObjectString_GoodsCode.ValueData
                                                     , Object_Goods.ValueData
                                                     , ObjectString_Goods_Maker.ValueData
                                                     , MIDate_PartionGoods.ValueData
                                                     , LastMovement.AreaId

                                              )

       -- Результат
       SELECT row_number() OVER ()
            , ddd.Id AS MovementItemId
            , ddd.PriceListMovementItemId
            , ddd.Price
            , ddd.PartionGoodsDate
            , ddd.GoodsId
            , ddd.GoodsCode
            , ddd.GoodsName
            , ddd.MainGoodsName
            , ddd.JuridicalId
            , ddd.JuridicalName
            , ddd.MakerName
            , ddd.ContractId
            , ddd.ContractName
            , ddd.AreaId
            , ddd.AreaName
            , ddd.isDefault
            , ddd.Deferment
            , ddd.Bonus
/* * /
            , CASE WHEN ddd.Deferment = 0
                        THEN 0
                   WHEN ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   ELSE PriceSettings.Percent
              END :: TFloat AS Percent
            , CASE WHEN ddd.Deferment = 0
                        THEN FinalPrice
                   WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                        THEN FinalPrice * (100 - COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   ELSE FinalPrice * (100 - PriceSettings.Percent) / 100
              END :: TFloat AS SuperFinalPrice
/ */
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN COALESCE (PriceSettings.Percent, 0)
                   ELSE 0
              END :: TFloat AS Percent

            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
                   ELSE FinalPrice
              END :: TFloat AS SuperFinalPrice

            , (ddd.FinalPrice - ddd.FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit) ) / 100) :: TFloat AS SuperFinalPrice_Deferment
/**/
       FROM
             (SELECT DISTINCT MovementItemOrder.Id
                  , MovementItemLastPriceList_View.Price AS Price
                  , MovementItemLastPriceList_View.MovementItemId AS PriceListMovementItemId
                  , MovementItemLastPriceList_View.PartionGoodsDate
                  , MIN (MovementItemLastPriceList_View.Price) OVER (PARTITION BY MovementItemOrder.Id ORDER BY MovementItemLastPriceList_View.PartionGoodsDate DESC) AS MinPrice
                  , CASE
                      -- -- если Цена поставщика не попадает в ценовые промежутки (до какой цены учитывать бонус при расчете миним. цены)
                      WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                           THEN MovementItemLastPriceList_View.Price
                               -- И учитывается % бонуса из Маркетинговый контракт
                             * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                      ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                           (MovementItemLastPriceList_View.Price * (100 - COALESCE(tmpJuridicalSettingsItem.Bonus, 0)) / 100) :: TFloat
                            -- И учитывается % бонуса из Маркетинговый контракт
                          * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                    END AS FinalPrice
                  , CASE WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                              THEN 0
                         ELSE COALESCE(tmpJuridicalSettingsItem.Bonus, 0)
                    END :: TFloat AS Bonus

                  , MovementItemLastPriceList_View.GoodsId
                  , MovementItemLastPriceList_View.GoodsCode
                  , MovementItemLastPriceList_View.GoodsName
                  , MovementItemLastPriceList_View.MakerName
                  , MainGoods.valuedata                       AS MainGoodsName
                  , Juridical.ID                              AS JuridicalId
                  , Juridical.ValueData                       AS JuridicalName
                  , Contract.Id                               AS ContractId
                  , Contract.ValueData                        AS ContractName
                  , COALESCE (ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
                  , COALESCE (GoodsPrice.isTOP, COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) AS isTOP

                  , tmpJuridicalArea.AreaId
                  , tmpJuridicalArea.AreaName
                  , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean AS isDefault

               FROM MovementItemOrder
                    LEFT OUTER JOIN tmpMovementItemLastPriceList_View AS MovementItemLastPriceList_View
                                                                      ON MovementItemLastPriceList_View.GoodsId = MovementItemOrder.GoodsId

                    JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                         AND tmpJuridicalArea.AreaId      = MovementItemLastPriceList_View.AreaId

                    INNER JOIN tmpLoadPriceList ON tmpLoadPriceList.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND tmpLoadPriceList.ContractId  = MovementItemLastPriceList_View.ContractId
                                               AND (tmpLoadPriceList.AreaId = MovementItemLastPriceList_View.AreaId OR COALESCE (tmpLoadPriceList.AreaId, 0) = 0)


                    LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND JuridicalSettings.ContractId  = MovementItemLastPriceList_View.ContractId
                    LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                                      AND MovementItemLastPriceList_View.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                                      AND MovementItemLastPriceList_View.Price <= tmpJuridicalSettingsItem.PriceLimit

                    -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
                             --LEFT JOIN Object AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
                    --LEFT JOIN ObjectString AS ObjectString_GoodsCode ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
                    --                      AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
                    --LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                    --                           ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                    --                          AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

                    JOIN OBJECT AS Juridical ON Juridical.Id = MovementItemLastPriceList_View.JuridicalId

                    LEFT JOIN OBJECT AS Contract ON Contract.Id = MovementItemLastPriceList_View.ContractId

                    LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                          ON ObjectFloat_Deferment.ObjectId = Contract.Id
                                         AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

                    LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = MovementItemOrder.GoodsMainId

                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                            ON ObjectBoolean_Goods_TOP.ObjectId = MovementItemOrder.ObjectId
                                           AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
                    LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = MovementItemOrder.ObjectId

                    --   LEFT JOIN Object_Goods_View AS Goods  -- Элемент документа заявка
                    --     ON Goods.Id = MovementItemOrder.ObjectId

                    -- % бонуса из Маркетинговый контракт
                    LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                        AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId


               WHERE  COALESCE(JuridicalSettings.isPriceCloseOrder, FALSE) <> TRUE                                        --
       ) AS ddd

       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
       LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit
  ;

-- lpCreateTempTable_OrderInternal Конец процедуры

      --raise notice 'Value: % % % % %', 2, vbmainjuridicalid, vbareaid_find, vbUnitId, (SELECT Count(*) FROM _tmpMI);

     RETURN QUERY
     WITH
     -- Маркетинговый контракт
     GoodsPromo AS (SELECT tmp.JuridicalId
                         , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- здесь товар "сети"
                         , tmp.MovementId
                         , tmp.ChangePercent
                         , MovementPromo.OperDate                AS OperDatePromo
                         , MovementPromo.InvNumber               AS InvNumberPromo -- ***
                    FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp   --CURRENT_DATE
                                     INNER JOIN ObjectLink AS ObjectLink_Child
                                                           ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                          AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                     INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                              AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                     INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                    AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                     INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                     AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                     INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                           ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                          AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                     LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                   )
   , tmpObjectLink AS (SELECT ObjectLink.*
                       FROM ObjectLink
                       WHERE ObjectLink.DescId IN ( zc_ObjectLink_Goods_Area(), zc_ObjectLink_Goods_ConditionsKeep())
                         AND ObjectLink.ObjectId IN (SELECT DISTINCT _tmpMI.GoodsId FROM _tmpMI)
                        )
   , tmpObjectFloat AS (SELECT ObjectFloat.*
                        FROM ObjectFloat
                        WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                             AND ObjectFloat.ObjectId IN (SELECT DISTINCT _tmpMI.GoodsId FROM _tmpMI)
                        )
   , tmpMIFloat AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.DescId = zc_MIFloat_Remains()
                      AND MovementItemFloat.MovementItemId IN (SELECT DISTINCT _tmpMI.PriceListMovementItemId FROM _tmpMI)
                    )
   , tmpMovementItem AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.Id IN (SELECT DISTINCT _tmpMI.MovementItemId FROM _tmpMI)
                         )

   -- данные по % кредитных средств из справочника
   , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)

   -- НДС из прайс-листа поставщика (LoadPriceList )
   , tmpLoadPriceList_NDS AS (SELECT *
                              FROM (SELECT LoadPriceListItem.CommonCode
                                         , LoadPriceListItem.GoodsName
                                         , LoadPriceListItem.GoodsNDS
                                         , LoadPriceListItem.GoodsId
                                         , PartnerGoods.Id AS PartnerGoodsId
                                         , LoadPriceList.JuridicalId
                                         , ROW_NUMBER() OVER (PARTITION BY LoadPriceList.JuridicalId, LoadPriceListItem.GoodsId ORDER BY LoadPriceList.OperDate DESC, LoadPriceListItem.Id DESC) AS ORD
                                    FROM LoadPriceList
                                         LEFT JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id

                                         LEFT JOIN Object_Goods_Juridical AS PartnerGoods ON PartnerGoods.JuridicalId  = LoadPriceList.JuridicalId
                                                                                         AND PartnerGoods.Code = LoadPriceListItem.GoodsCode

                                    WHERE COALESCE (LoadPriceListItem.GoodsNDS,'') <> ''
                                    ) AS tmp
                              WHERE tmp.ORD = 1
                              )
   -- Отказы поставщиков
   , tmpSupplierFailures AS (SELECT DISTINCT
                                    ObjectLink_BankAccount_Goods.ChildObjectId          AS GoodsId
                                  , ObjectLink_BankAccount_Juridical.ChildObjectId      AS JuridicalId
                                  , ObjectLink_BankAccount_Contract.ChildObjectId       AS ContractId
                                  , ObjectLink_BankAccount_Area.ChildObjectId           AS AreaId
                             FROM Object AS Object_SupplierFailures

                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Goods
                                                       ON ObjectLink_BankAccount_Goods.ObjectId = Object_SupplierFailures.Id
                                                      AND ObjectLink_BankAccount_Goods.DescId = zc_ObjectLink_SupplierFailures_Goods()

                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Juridical
                                                       ON ObjectLink_BankAccount_Juridical.ObjectId = Object_SupplierFailures.Id
                                                      AND ObjectLink_BankAccount_Juridical.DescId = zc_ObjectLink_SupplierFailures_Juridical()

                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Contract
                                                       ON ObjectLink_BankAccount_Contract.ObjectId = Object_SupplierFailures.Id
                                                      AND ObjectLink_BankAccount_Contract.DescId = zc_ObjectLink_SupplierFailures_Contract()

                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Area
                                                       ON ObjectLink_BankAccount_Area.ObjectId = Object_SupplierFailures.Id
                                                      AND ObjectLink_BankAccount_Area.DescId = zc_ObjectLink_SupplierFailures_Area()

                             WHERE Object_SupplierFailures.DescId = zc_Object_SupplierFailures()
                               AND Object_SupplierFailures.isErased = FALSE
                               )


        ---
        SELECT _tmpMI.Id
             , _tmpMI.MovementItemId
             , _tmpMI.PriceListMovementItemId
             , _tmpMI.Price
             , _tmpMI.PartionGoodsDate
             , _tmpMI.GoodsId
             , _tmpMI.GoodsCode
             , _tmpMI.GoodsName
             , _tmpMI.MainGoodsName
             , CASE WHEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'0') <> '0' THEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'') ELSE '' END  :: TVarChar AS NDS_PriceList
             , _tmpMI.JuridicalId
             , _tmpMI.JuridicalName
             , _tmpMI.MakerName
             , _tmpMI.ContractId
             , _tmpMI.ContractName
             , _tmpMI.AreaId
             , _tmpMI.AreaName
             , _tmpMI.isDefault
             , _tmpMI.Deferment
             , _tmpMI.Bonus
             , _tmpMI.Percent
             , _tmpMI.SuperFinalPrice
             , _tmpMI.SuperFinalPrice_Deferment

             , CASE WHEN _tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Red() -- zc_Color_Blue() --456
                    ELSE 0
               END                                                          AS PartionGoodsDateColor
             , ObjectFloat_Goods_MinimumLot.ValueData                       AS MinimumLot
             , MIFloat_Remains.ValueData                                    AS Remains

             , (_tmpMI.Deferment * COALESCE (tmpCostCredit.Percent, vbCostCredit))             :: TFloat      AS Persent_Deferment

             , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
             , COALESCE(GoodsPromo.OperDatePromo, NULL)      :: TDateTime   AS OperDatePromo
             , COALESCE(GoodsPromo.InvNumberPromo, '')       :: TVarChar    AS InvNumberPromo -- ***
             , COALESCE(GoodsPromo.ChangePercent, 0)         :: TFLoat      AS ChangePercentPromo

             , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar     AS ConditionsKeepName
             , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods

             , COALESCE (SupplierFailures.GoodsId, 0) <> 0               AS isSupplierFailures

             , CASE
                    WHEN COALESCE (SupplierFailures.GoodsId, 0) <> 0 THEN zfCalc_Color (255, 165, 0) -- orange
                    ELSE zc_Color_White()
                END  AS SupplierFailuresColor

        FROM _tmpMI
             LEFT JOIN tmpObjectFloat AS ObjectFloat_Goods_MinimumLot
                                      ON ObjectFloat_Goods_MinimumLot.ObjectId = _tmpMI.GoodsId
                            --      AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
             LEFT JOIN tmpMIFloat AS MIFloat_Remains
                                  ON MIFloat_Remains.MovementItemId = _tmpMI.PriceListMovementItemId
                                 AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
             LEFT JOIN tmpMovementItem AS MovementItem ON MovementItem.Id = _tmpMI.MovementItemId
             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = _tmpMI.JuridicalId
                                 AND GoodsPromo.GoodsId = MovementItem.ObjectId
             -- условия хранения
             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_ConditionsKeep
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = _tmpMI.GoodsId
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

             LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = _tmpMI.JuridicalId
                                       AND tmpJuridicalArea.AreaId      = _tmpMI.AreaId

             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_Area
                                     ON ObjectLink_Goods_Area.ObjectId = _tmpMI.GoodsId
                                    AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
             LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

             LEFT JOIN tmpCostCredit ON _tmpMI.Price BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit

             LEFT JOIN tmpLoadPriceList_NDS ON tmpLoadPriceList_NDS.PartnerGoodsId = _tmpMI.GoodsId
                                           AND tmpLoadPriceList_NDS.JuridicalId = _tmpMI.JuridicalId

             LEFT JOIN tmpSupplierFailures AS SupplierFailures
                                           ON SupplierFailures.GoodsId = _tmpMI.GoodsId
                                          AND SupplierFailures.JuridicalId = _tmpMI.JuridicalId
                                          AND SupplierFailures.ContractId = _tmpMI.ContractId
                                          AND (SupplierFailures.AreaId = _tmpMI.AreaId OR
                                               COALESCE(SupplierFailures.AreaId, 0) = 0)
;



    -- !!!Только для ДРУГИХ документов + inShowAll = TRUE - 3-ья ВЕТКА (ВСЕГО = 3)!!!
    ELSEIF inShowAll = TRUE
    THEN

       --raise notice 'Value: %', 3;

--    PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);

     -- ПАРАМЕТРЫ
     SELECT ObjectLink_Unit_Juridical.ChildObjectId, MovementLinkObject.ObjectId, COALESCE (ObjectLink_Unit_Area.ChildObjectId, zc_Area_Basis())
            INTO vbMainJuridicalId, vbUnitId, vbAreaId_find
         FROM MovementLinkObject
              --INNER JOIN Object_Unit_View ON Object_Unit_View.Id = MovementLinkObject.ObjectId
              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

              LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                   ON ObjectLink_Unit_Area.ObjectId = MovementLinkObject.ObjectId
                                  AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
     WHERE MovementLinkObject.MovementId = inMovementId
       AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();


     -- таблица Регион поставщика
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpJuridicalArea'))
     THEN
         CREATE TEMP TABLE tmpJuridicalArea (UnitId Integer, JuridicalId Integer, AreaId Integer, AreaName TVarChar, isDefault Boolean) ON COMMIT DROP;
         INSERT INTO tmpJuridicalArea (UnitId, JuridicalId, AreaId, AreaName, isDefault)
            SELECT DISTINCT
                   tmp.UnitId                   AS UnitId
                 , tmp.JuridicalId              AS JuridicalId
                 , tmp.AreaId_Juridical         AS AreaId
                 , tmp.AreaName_Juridical       AS AreaName
                 , tmp.isDefault_JuridicalArea  AS isDefault
            FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId, 0) AS tmp;
     END IF;


     -- ДАННЫЕ
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMI'))
     THEN
       DROP TABLE IF EXISTS _tmpMI;
     END IF;

     CREATE TEMP TABLE _tmpMI (Id integer
                             , MovementItemId Integer
                             , PriceListMovementItemId Integer
                             , Price TFloat
                             , PartionGoodsDate TDateTime
                             , GoodsId Integer
                             , GoodsCode TVarChar
                             , GoodsName TVarChar
                             , MainGoodsName TVarChar
                             , JuridicalId Integer
                             , JuridicalName TVarChar
                             , MakerName TVarChar
                             , ContractId Integer
                             , ContractName TVarChar
                             , AreaId Integer
                             , AreaName TVarChar
                             , isDefault Boolean
                             , Deferment Integer
                             , Bonus TFloat
                             , Percent TFloat
                             , SuperFinalPrice TFloat
                             , SuperFinalPrice_Deferment TFloat) ON COMMIT DROP;


      -- Сохраниели данные
      INSERT INTO _tmpMI

           WITH -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
                PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (vbUserId::TVarChar))
              , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar))

              , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)

                -- элементы установок юр.лиц (границы цен для бонуса)
              , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                                  , tmp.Bonus
                                                  , tmp.PriceLimit_min
                                                  , tmp.PriceLimit
                                             FROM JuridicalSettings
                                                  INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inSession) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                             WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                             )

              , JuridicalArea AS (SELECT DISTINCT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                                  FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                       INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                AND Object_JuridicalArea.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                             ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                            AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                            AND ObjectLink_JuridicalArea_Area.ChildObjectId = vbAreaId_find
                                       -- Уникальный код поставщика ТОЛЬКО для Региона
                                       INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                                ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                  WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                 )

              , MovementItemOrder AS (SELECT MovementItem.*
                                           , ObjectLink_Main.ChildObjectId AS GoodsMainId, ObjectLink_LinkGoods_Goods.ChildObjectId AS GoodsId
                                      FROM MovementItem
                                       --  INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.ObjectId -- Связь товара сети с общим
                                       -- получаем GoodsMainId
                                           INNER JOIN  ObjectLink AS ObjectLink_Child
                                                                  ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                         --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                         --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                           -- товары сети по главному GoodsMainId
                                           LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                                ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                                               AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_Main.ChildObjectId --Object_LinkGoods_View.GoodsMainId

                                           LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                                ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                               AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                                                ON ObjectLink_Goods_Area.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Object.DescId   = zc_ObjectLink_Goods_Object()
                                           LEFT JOIN JuridicalArea ON JuridicalArea.JuridicalId = ObjectLink_Goods_Object.ChildObjectId

                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND (ObjectLink_Goods_Area.ChildObjectId = vbAreaId_find OR JuridicalArea.JuridicalId IS NULL)
                                  )
                -- Маркетинговый контракт
              , tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- здесь товар "сети"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUnitId  := vbUnitId
                                                                                       , inUserId  := vbUserId) AS tmp
                                      )
                -- Список цены + ТОП
              , GoodsPrice AS (SELECT MovementItemOrder.ObjectId AS GoodsId, ObjectBoolean_Top.ValueData AS isTOP
                               FROM MovementItemOrder
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                          ON ObjectLink_Price_Goods.ChildObjectId = MovementItemOrder.ObjectId
                                                         AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                          ON ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                                         AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                         AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Top
                                                             ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                            AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                            AND ObjectBoolean_Top.ValueData = TRUE
                              )

              , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceList.JuridicalId
                                          , LoadPriceList.ContractId
                                          , LoadPriceList.AreaId
                                     FROM LoadPriceList
                                     )

      -- данные по % кредитных средств из справочника
      , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)
      , tmpMovementItemLastPriceList_View AS (SELECT LastMovement.MovementId
                                                   , LastMovement.JuridicalId
                                                   , LastMovement.ContractId
                                                   , Max(MovementItem.Id)::Integer      AS MovementItemId
                                                   , COALESCE(MIFloat_Price.ValueData, MovementItem.Amount)::TFloat  AS Price
                                                   , MILinkObject_Goods.ObjectId        AS GoodsId
                                                   , ObjectString_GoodsCode.ValueData   AS GoodsCode
                                                   , Object_Goods.ValueData             AS GoodsName
                                                   , ObjectString_Goods_Maker.ValueData AS MakerName
                                                   , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
                                                   , LastMovement.AreaId                AS AreaId
                                              FROM
                                                  (
                                                      SELECT
                                                          PriceList.JuridicalId
                                                        , PriceList.ContractId
                                                        , PriceList.AreaId
                                                        , PriceList.MovementId
                                                      FROM
                                                          (
                                                              SELECT
                                                                  MAX (Movement.OperDate)
                                                                  OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId
                                                                                   , COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                                                                   , COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                                                       ) AS Max_Date
                                                                , Movement.OperDate                                  AS OperDate
                                                                , Movement.Id                                        AS MovementId
                                                                , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
                                                                , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                                                , COALESCE (MovementLinkObject_Area.ObjectId, 0)     AS AreaId
                                                              FROM
                                                                  Movement
                                                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                                               ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                                                              AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                                                               ON MovementLinkObject_Area.MovementId = Movement.Id
                                                                                              AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
                                                                  INNER JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementLinkObject_Juridical.ObjectId
                                                                                             AND tmpJuridicalArea.AreaId      = COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                                              WHERE
                                                                  Movement.DescId = zc_Movement_PriceList()
                                                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                          ) AS PriceList
                                                      WHERE PriceList.Max_Date = PriceList.OperDate
                                                  ) AS LastMovement
                                                  INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                                                                         AND MovementItem.DescId = zc_MI_Master()
                                                                         AND MovementItem.isErased = False
                                                  INNER JOIN MovementItemLinkObject AS MILinkObject_Goods -- товары в прайс-листе
                                                                                    ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                                                   AND MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                  INNER JOIN MovementItemOrder ON MovementItemOrder.GoodsId =  MILinkObject_Goods.ObjectId

                                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                              ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                                  LEFT OUTER JOIN Object AS Object_Goods
                                                                         ON Object_Goods.Id = MILinkObject_Goods.ObjectId
                                                  LEFT JOIN ObjectString AS ObjectString_GoodsCode
                                                                         ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
                                                                        AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
                                                  LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                                                         ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                                                                        AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()
                                                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                             ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                                            AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                              GROUP BY LastMovement.MovementId
                                                     , LastMovement.JuridicalId
                                                     , LastMovement.ContractId
                                                     , COALESCE(MIFloat_Price.ValueData, MovementItem.Amount)::TFloat
                                                     , MILinkObject_Goods.ObjectId
                                                     , ObjectString_GoodsCode.ValueData
                                                     , Object_Goods.ValueData
                                                     , ObjectString_Goods_Maker.ValueData
                                                     , MIDate_PartionGoods.ValueData
                                                     , LastMovement.AreaId

                                              )


       -- Результат
       SELECT row_number() OVER ()
            , ddd.Id AS MovementItemId
            , ddd.PriceListMovementItemId
            , ddd.Price
            , ddd.PartionGoodsDate
            , ddd.GoodsId
            , ddd.GoodsCode
            , ddd.GoodsName
            , ddd.MainGoodsName
            , ddd.JuridicalId
            , ddd.JuridicalName
            , ddd.MakerName
            , ddd.ContractId
            , ddd.ContractName
            , ddd.AreaId
            , ddd.AreaName
            , ddd.isDefault
            , ddd.Deferment
            , ddd.Bonus
/* * /
            , CASE WHEN ddd.Deferment = 0
                        THEN 0
                   WHEN ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   ELSE PriceSettings.Percent
              END :: TFloat AS Percent
            , CASE WHEN ddd.Deferment = 0
                        THEN FinalPrice
                   WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                        THEN FinalPrice * (100 - COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   ELSE FinalPrice * (100 - PriceSettings.Percent) / 100
              END :: TFloat AS SuperFinalPrice
/ */
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN COALESCE (PriceSettings.Percent, 0)
                   ELSE 0
              END :: TFloat AS Percent

            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
                   ELSE FinalPrice
              END :: TFloat AS SuperFinalPrice

            , (ddd.FinalPrice - ddd.FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit) ) / 100) :: TFloat AS SuperFinalPrice_Deferment
/**/
       FROM
             (SELECT DISTINCT MovementItemOrder.Id
                  , MovementItemLastPriceList_View.Price AS Price
                  , MovementItemLastPriceList_View.MovementItemId AS PriceListMovementItemId
                  , MovementItemLastPriceList_View.PartionGoodsDate
                  , MIN (MovementItemLastPriceList_View.Price) OVER (PARTITION BY MovementItemOrder.Id ORDER BY MovementItemLastPriceList_View.PartionGoodsDate DESC) AS MinPrice
                  , CASE
                      -- -- если Цена поставщика не попадает в ценовые промежутки (до какой цены учитывать бонус при расчете миним. цены)
                      WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                           THEN MovementItemLastPriceList_View.Price
                               -- И учитывается % бонуса из Маркетинговый контракт
                             * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                      ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                           (MovementItemLastPriceList_View.Price * (100 - COALESCE(tmpJuridicalSettingsItem.Bonus, 0)) / 100) :: TFloat
                            -- И учитывается % бонуса из Маркетинговый контракт
                          * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                    END AS FinalPrice
                  , CASE WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                              THEN 0
                         ELSE COALESCE(tmpJuridicalSettingsItem.Bonus, 0)
                    END :: TFloat AS Bonus

                  , MovementItemLastPriceList_View.GoodsId
                  , MovementItemLastPriceList_View.GoodsCode
                  , MovementItemLastPriceList_View.GoodsName
                  , MovementItemLastPriceList_View.MakerName
                  , MainGoods.valuedata                       AS MainGoodsName
                  , Juridical.ID                              AS JuridicalId
                  , Juridical.ValueData                       AS JuridicalName
                  , Contract.Id                               AS ContractId
                  , Contract.ValueData                        AS ContractName
                  , COALESCE (ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
                  , COALESCE (GoodsPrice.isTOP, COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) AS isTOP

                  , tmpJuridicalArea.AreaId
                  , tmpJuridicalArea.AreaName
                  , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean AS isDefault

               FROM MovementItemOrder
                    LEFT OUTER JOIN tmpMovementItemLastPriceList_View AS MovementItemLastPriceList_View
                                                                      ON MovementItemLastPriceList_View.GoodsId = MovementItemOrder.GoodsId

                    JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                         AND tmpJuridicalArea.AreaId      = MovementItemLastPriceList_View.AreaId

                    INNER JOIN tmpLoadPriceList ON tmpLoadPriceList.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND tmpLoadPriceList.ContractId  = MovementItemLastPriceList_View.ContractId
                                               AND (tmpLoadPriceList.AreaId = MovementItemLastPriceList_View.AreaId OR COALESCE (tmpLoadPriceList.AreaId, 0) = 0)


                    LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND JuridicalSettings.ContractId  = MovementItemLastPriceList_View.ContractId
                    LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                                      AND MovementItemLastPriceList_View.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                                      AND MovementItemLastPriceList_View.Price <= tmpJuridicalSettingsItem.PriceLimit

                    -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
                             --LEFT JOIN Object AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
                    --LEFT JOIN ObjectString AS ObjectString_GoodsCode ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
                    --                      AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
                    --LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                    --                           ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                    --                          AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

                    JOIN OBJECT AS Juridical ON Juridical.Id = MovementItemLastPriceList_View.JuridicalId

                    LEFT JOIN OBJECT AS Contract ON Contract.Id = MovementItemLastPriceList_View.ContractId

                    LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                          ON ObjectFloat_Deferment.ObjectId = Contract.Id
                                         AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

                    LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = MovementItemOrder.GoodsMainId

                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                            ON ObjectBoolean_Goods_TOP.ObjectId = MovementItemOrder.ObjectId
                                           AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
                    LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = MovementItemOrder.ObjectId

                    --   LEFT JOIN Object_Goods_View AS Goods  -- Элемент документа заявка
                    --     ON Goods.Id = MovementItemOrder.ObjectId

                    -- % бонуса из Маркетинговый контракт
                    LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                        AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId


               WHERE  COALESCE(JuridicalSettings.isPriceCloseOrder, FALSE) <> TRUE                                        --
       ) AS ddd

       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
       LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit
  ;

-- lpCreateTempTable_OrderInternal Конец процедуры

     RETURN QUERY
     WITH
     -- Маркетинговый контракт
     GoodsPromo AS (SELECT tmp.JuridicalId
                         , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- здесь товар "сети"
                         , tmp.MovementId
                         , tmp.ChangePercent
                         , MovementPromo.OperDate                AS OperDatePromo
                         , MovementPromo.InvNumber               AS InvNumberPromo -- ***
                    FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp   --CURRENT_DATE
                                     INNER JOIN ObjectLink AS ObjectLink_Child
                                                           ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                          AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                     INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                              AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                     INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                    AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                     INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                     AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                     INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                           ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                          AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                     LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                   )
   , tmpObjectLink AS (SELECT ObjectLink.*
                       FROM ObjectLink
                       WHERE ObjectLink.DescId IN ( zc_ObjectLink_Goods_Area(), zc_ObjectLink_Goods_ConditionsKeep())
                         AND ObjectLink.ObjectId IN (SELECT DISTINCT _tmpMI.GoodsId FROM _tmpMI)
                        )
   , tmpObjectFloat AS (SELECT ObjectFloat.*
                        FROM ObjectFloat
                        WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                             AND ObjectFloat.ObjectId IN (SELECT DISTINCT _tmpMI.GoodsId FROM _tmpMI)
                        )
   , tmpMIFloat AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.DescId = zc_MIFloat_Remains()
                      AND MovementItemFloat.MovementItemId IN (SELECT DISTINCT _tmpMI.PriceListMovementItemId FROM _tmpMI)
                    )
   , tmpMovementItem AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.Id IN (SELECT DISTINCT _tmpMI.MovementItemId FROM _tmpMI)
                         )

   -- данные по % кредитных средств из справочника
   , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)

   -- НДС из прайс-листа поставщика (LoadPriceList )
   , tmpLoadPriceList_NDS AS (SELECT *
                              FROM (SELECT LoadPriceListItem.CommonCode
                                         , LoadPriceListItem.GoodsName
                                         , LoadPriceListItem.GoodsNDS
                                         , LoadPriceListItem.GoodsId
                                         , PartnerGoods.Id AS PartnerGoodsId
                                         , LoadPriceList.JuridicalId
                                         , ROW_NUMBER() OVER (PARTITION BY LoadPriceList.JuridicalId, LoadPriceListItem.GoodsId ORDER BY LoadPriceList.OperDate DESC, LoadPriceListItem.Id DESC) AS ORD
                                    FROM LoadPriceList
                                         LEFT JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id

                                         LEFT JOIN Object_Goods_Juridical AS PartnerGoods ON PartnerGoods.JuridicalId  = LoadPriceList.JuridicalId
                                                                                         AND PartnerGoods.Code = LoadPriceListItem.GoodsCode

                                    WHERE COALESCE (LoadPriceListItem.GoodsNDS,'') <> ''
                                    ) AS tmp
                              WHERE tmp.ORD = 1
                              )
   -- Отказы поставщиков
   , tmpSupplierFailures AS (SELECT DISTINCT
                                    ObjectLink_BankAccount_Goods.ChildObjectId          AS GoodsId
                                  , ObjectLink_BankAccount_Juridical.ChildObjectId      AS JuridicalId
                                  , ObjectLink_BankAccount_Contract.ChildObjectId       AS ContractId
                                  , ObjectLink_BankAccount_Area.ChildObjectId           AS AreaId
                             FROM Object AS Object_SupplierFailures

                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Goods
                                                       ON ObjectLink_BankAccount_Goods.ObjectId = Object_SupplierFailures.Id
                                                      AND ObjectLink_BankAccount_Goods.DescId = zc_ObjectLink_SupplierFailures_Goods()

                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Juridical
                                                       ON ObjectLink_BankAccount_Juridical.ObjectId = Object_SupplierFailures.Id
                                                      AND ObjectLink_BankAccount_Juridical.DescId = zc_ObjectLink_SupplierFailures_Juridical()

                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Contract
                                                       ON ObjectLink_BankAccount_Contract.ObjectId = Object_SupplierFailures.Id
                                                      AND ObjectLink_BankAccount_Contract.DescId = zc_ObjectLink_SupplierFailures_Contract()

                                  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Area
                                                       ON ObjectLink_BankAccount_Area.ObjectId = Object_SupplierFailures.Id
                                                      AND ObjectLink_BankAccount_Area.DescId = zc_ObjectLink_SupplierFailures_Area()

                             WHERE Object_SupplierFailures.DescId = zc_Object_SupplierFailures()
                               AND Object_SupplierFailures.isErased = FALSE
                               )

        ---
        SELECT _tmpMI.Id
             , _tmpMI.MovementItemId
             , _tmpMI.PriceListMovementItemId
             , _tmpMI.Price
             , _tmpMI.PartionGoodsDate
             , _tmpMI.GoodsId
             , _tmpMI.GoodsCode
             , _tmpMI.GoodsName
             , _tmpMI.MainGoodsName
             , CASE WHEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'0') <> '0' THEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'') ELSE '' END  :: TVarChar AS NDS_PriceList
             , _tmpMI.JuridicalId
             , _tmpMI.JuridicalName
             , _tmpMI.MakerName
             , _tmpMI.ContractId
             , _tmpMI.ContractName
             , _tmpMI.AreaId
             , _tmpMI.AreaName
             , _tmpMI.isDefault
             , _tmpMI.Deferment
             , _tmpMI.Bonus
             , _tmpMI.Percent
             , _tmpMI.SuperFinalPrice
             , _tmpMI.SuperFinalPrice_Deferment

             , CASE WHEN _tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Red() -- zc_Color_Blue() --456
                    ELSE 0
               END                                                          AS PartionGoodsDateColor
             , ObjectFloat_Goods_MinimumLot.ValueData                       AS MinimumLot
             , MIFloat_Remains.ValueData                                    AS Remains

             , (_tmpMI.Deferment * COALESCE (tmpCostCredit.Percent, vbCostCredit))             :: TFloat      AS Persent_Deferment

             , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
             , COALESCE(GoodsPromo.OperDatePromo, NULL)      :: TDateTime   AS OperDatePromo
             , COALESCE(GoodsPromo.InvNumberPromo, '')       :: TVarChar    AS InvNumberPromo -- ***
             , COALESCE(GoodsPromo.ChangePercent, 0)         :: TFLoat      AS ChangePercentPromo

             , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar     AS ConditionsKeepName
             , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods

             , COALESCE (SupplierFailures.GoodsId, 0) <> 0               AS isSupplierFailures

             , CASE
                    WHEN COALESCE (SupplierFailures.GoodsId, 0) <> 0 THEN zfCalc_Color (255, 165, 0) -- orange
                    ELSE zc_Color_White()
                END  AS SupplierFailuresColor

        FROM _tmpMI
             LEFT JOIN tmpObjectFloat AS ObjectFloat_Goods_MinimumLot
                                      ON ObjectFloat_Goods_MinimumLot.ObjectId = _tmpMI.GoodsId
                            --      AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
             LEFT JOIN tmpMIFloat AS MIFloat_Remains
                                  ON MIFloat_Remains.MovementItemId = _tmpMI.PriceListMovementItemId
                                 AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
             LEFT JOIN tmpMovementItem AS MovementItem ON MovementItem.Id = _tmpMI.MovementItemId
             LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = _tmpMI.JuridicalId
                                 AND GoodsPromo.GoodsId = MovementItem.ObjectId
             -- условия хранения
             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_ConditionsKeep
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = _tmpMI.GoodsId
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

             LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = _tmpMI.JuridicalId
                                       AND tmpJuridicalArea.AreaId      = _tmpMI.AreaId

             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_Area
                                     ON ObjectLink_Goods_Area.ObjectId = _tmpMI.GoodsId
                                    AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
             LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

             LEFT JOIN tmpCostCredit ON _tmpMI.Price BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit

             LEFT JOIN tmpLoadPriceList_NDS ON tmpLoadPriceList_NDS.PartnerGoodsId = _tmpMI.GoodsId
                                           AND tmpLoadPriceList_NDS.JuridicalId = _tmpMI.JuridicalId

             LEFT JOIN tmpSupplierFailures AS SupplierFailures
                                           ON SupplierFailures.GoodsId = _tmpMI.GoodsId
                                          AND SupplierFailures.JuridicalId = _tmpMI.JuridicalId
                                          AND SupplierFailures.ContractId = _tmpMI.ContractId
                                          AND (SupplierFailures.AreaId = _tmpMI.AreaId OR
                                               COALESCE(SupplierFailures.AreaId, 0) = 0)
;


  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_OrderInternal_Child (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 20.09.19                                                                    * Разбил на две процедуры
 24.04.19         *
 16.04.18                                                                    * оптимизация
 11.02.19         * признак Товары соц-проект берем и документа
 07.02.19         * если isBonusClose = true бонусы не учитываем
 02.11.18         *
 19.10.18         * isPriceClose замена на isPriceCloseOrder
 31.08.18         * add Reserved
 09.04.18                                                                    * оптимизация
 02.10.17         * add area
 12.09.17         *
 04.08.17         *
 09.04.17         * оптимизация
 06.04.17         *
 12.11.16         *
 09.09.16         *
 31.08.16         *
 04.08.16         *
 28.04.16         *
 12.04.16         *
 23.03.16         *
 03.02.16         *
 23.03.15                         *
 05.02.15                         *
 12.11.14                         * add MinimumLot
 05.11.14                         * add MakerName
 22.10.14                         *
 13.10.14                         *
 15.07.14                                                       *
 15.07.14                                                       *
 03.07.14                                                       *
*/

/*
-- вот так хотели залить инфу, но сказали что не надо :)
with tmp1 as (
select distinct MovementItem.*
, coalesce (MIFloat_Price.ValueData, 0) AS Price
, coalesce (MIFloat_JuridicalPrice.ValueData, 0) AS JuridicalPrice
FROM Movement
        inner JOIN MovementBoolean AS MB_Document
               ON MB_Document.MovementId = Movement.Id
              AND MB_Document.DescId = zc_MovementBoolean_Document()
              AND MB_Document.ValueData = TRUE

                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = FALSE

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.DescId = zc_MIFloat_Price()
                                       AND MIFloat_Price.MovementItemId = MovementItem.Id
            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                        ON MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                       AND MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id

where Movement.DescId = zc_Movement_OrderInternal()
)
, tmp2 as (select distinct from tmp1)
*/

-- тест select * from gpSelect_MovementItem_OrderInternal_Child(inMovementId := 15668431 , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'FALSE' ,  inSession := '7564573');

--select * from gpSelect_MovementItem_OrderInternal_Child(inMovementId := 22066168  , inShowAll := 'True' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := '3');

select * from gpSelect_MovementItem_OrderInternal_Child(inMovementId := 26912498     , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := '3');
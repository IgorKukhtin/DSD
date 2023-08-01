-- Function: gpSelect_MovementItem_OrderInternal_Master()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal_Master (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal_Master(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inIsLink      Boolean      , -- �������� �������� � ����������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id                    Integer
             , GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName             TVarChar
             , RetailName            TVarChar
             , isTOP                 Boolean
             , isTOP_Price           Boolean

             , GoodsGroupId          Integer
             , NDSKindId             Integer
             , NDSKindName           TVarChar  -- 10
             , NDS                   TFloat
             , NDS_PriceList         TVarChar
             , isClose               Boolean
             , isFirst               Boolean
             , isSecond              Boolean
             , isSP                  Boolean
             , isResolution_224      Boolean

             , isMarketToday         Boolean
             , LastPriceDate         TDateTime

             , isTopColor            Integer
             , Multiplicity          TFloat
             , CalcAmount            TFloat  -- 20
             , Amount                TFloat
             , Summ                  TFloat
             , isErased              Boolean
             , Price                 TFloat
             , MinimumLot            TFloat
             , PartionGoodsDate      TDateTime
             , Comment               TVarChar
             , PartnerGoodsId        Integer
             , PartnerGoodsCode      TVarChar
             , PartnerGoodsName      TVarChar  -- 30
             , JuridicalId           Integer
             , JuridicalName         TVarChar
             , ContractId            Integer
             , ContractName          TVarChar
             , MakerName             TVarChar
             , SuperFinalPrice       TFloat
             , SuperFinalPrice_Deferment TFloat
             , PriceOptSP            TFloat
             , isPriceDiff           Boolean
             , isCalculated          Boolean  -- 40
             , PartionGoodsDateColor Integer
             , RemainsInUnit         TFloat
             , Reserved              TFloat
             , Remains_Diff          TFloat
             , MCS                   TFloat
             , MCS_GoodsCategory     TFloat
             , MCSIsClose            Boolean
             , MCSNotRecalc          Boolean
             , Income_Amount         TFloat
             , AmountSecond          TFloat  -- 50
             , AmountAll             TFloat
             , CalcAmountAll         TFloat
             , SummAll               TFloat
             , CheckAmount           TFloat
             , SendAmount            TFloat

             , AmountDeferred        TFloat
             , AmountSF              TFloat
             , ListDiffAmount        TFloat
             , SupplierFailuresAmount TFloat

             , AmountReal            TFloat
             , SendSUNAmount         TFloat
             , SendSUNAmount_save    TFloat
             , SendDefSUNAmount_save TFloat  -- 60
             , RemainsSUN            TFloat

             , CountPrice            TFloat

             , isOneJuridical        Boolean

             , isPromo               Boolean
             , isPromoAll            Boolean
             , OperDatePromo         TDateTime
             , InvNumberPromo        TVarChar

             , isZakazToday          Boolean
             , isDostavkaToday       Boolean
             , OperDate_Zakaz        TVarChar  -- 70
             , OperDate_Dostavka     TVarChar

             , ConditionsKeepName    TVarChar

             , OrderShedule_Color    Integer

             , AVGPrice              TFloat

             , AVGPriceWarning       TFloat

             , isDefault             Boolean

             , DiscountName          TVarChar
             , DiscountJuridical     TVarChar

             , AmountSUA             TFloat
             , FinalSUA              TFloat
             , FinalSUASend          TFloat

             , Layout                TFloat

             , isSupplierFailures    Boolean
             , SupplierFailuresColor Integer

             , isSPRegistry_1303     Boolean
             , PriceOOC1303          TFloat
             , DPriceOOC1303         TFloat
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
  DECLARE vbDate9 TDateTime;

  DECLARE vbMainJuridicalId Integer;

  DECLARE vbCURRENT_DOW Integer;

  DECLARE vbAreaId Integer;
  DECLARE vbAreaId_find Integer;

  DECLARE vbAVGDateStart TDateTime; --���� ���. ������� ��. ����
  DECLARE vbAVGDateEnd TDateTime;   --���� ����. ������� ��. ����

  DECLARE vbCostCredit TFloat;

  DECLARE Cursor1 refcursor;
BEGIN


     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
    vbUserId := inSession;

-- if inSession <> '3'
-- then
--     RAISE EXCEPTION '��������� �������� ����� 15 ���.';
-- end if;

     if COALESCE (inMovementId, 0) = 0
     then
         Return;
     end if;

--raise notice 'Value 01: %', CLOCK_TIMESTAMP();

     -- �������� �������� ���������
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

    vbCURRENT_DOW := CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0 THEN 7 ELSE EXTRACT (DOW FROM CURRENT_DATE) END ; -- ���� ������ �������

    --
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- ���������
    SELECT date_trunc('day', Movement.OperDate)
         , COALESCE(MB_Document.ValueData, FALSE) :: Boolean AS isDocument
         , Movement.StatusId
         , MLO_Unit.ObjectId
         , ObjectLink_Unit_Juridical.ChildObjectId
         , COALESCE (ObjectLink_Unit_Area.ChildObjectId, zc_Area_Basis())
         , COALESCE (ObjectLink_Unit_Area.ChildObjectId, zc_Area_Basis())
    INTO vbOperDate, vbisDocument, vbStatusId, vbUnitId, vbMainJuridicalId, vbAreaId_find, vbAreaId
    FROM Movement

        LEFT JOIN MovementBoolean AS MB_Document
               ON MB_Document.MovementId = Movement.Id
              AND MB_Document.DescId = zc_MovementBoolean_Document()

        LEFT JOIN MovementLinkObject AS MLO_Unit
               ON MLO_Unit.MovementId = Movement.Id
              AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
               ON ObjectLink_Unit_Juridical.ObjectId = MLO_Unit.ObjectId
              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
               ON ObjectLink_Unit_Area.ObjectId = MLO_Unit.ObjectId
              AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()

    WHERE Movement.Id = inMovementId;

    vbOperDateEnd := vbOperDate + INTERVAL '1 DAY';
    vbDate180 := CURRENT_DATE + zc_Interval_ExpirationDate()+ zc_Interval_ExpirationDate();   -- ����� 1 ��� (������� =6 ���.)
    --vbDate180 := CURRENT_DATE + INTERVAL '180 DAY';
    vbDate9 := CURRENT_DATE + INTERVAL '9 MONTH';


    vbAVGDateStart := vbOperDate - INTERVAL '30 day';
    vbAVGDateEnd   := vbOperDate;

    -- ������� ������ ����������
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

    ANALYSE tmpJuridicalArea;
    
    -- ������ ���� + ���
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('GoodsPrice'))
    THEN
      DROP TABLE IF EXISTS GoodsPrice;
    END IF;

    CREATE TEMP TABLE GoodsPrice ON COMMIT DROP AS (
                     SELECT Price_Goods.ChildObjectId           AS GoodsId
                          , COALESCE(Price_Top.ValueData,FALSE) AS isTop
                     FROM ObjectLink AS ObjectLink_Price_Unit
                          INNER JOIN ObjectBoolean     AS Price_Top
                                  ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                 AND Price_Top.ValueData = TRUE
                          LEFT JOIN ObjectLink       AS Price_Goods
                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                     WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                       AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                     );
    
    ANALYSE GoodsPrice;

    IF vbisDocument = False OR COALESCE(vbStatusId, 0) <> zc_Enum_Status_Complete() OR inShowAll = True
    THEN

--raise notice 'Value 02: %', CLOCK_TIMESTAMP();

      -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����) !!!������ ���� ������������ ObjectId!!!
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('PriceSettings'))
      THEN
        DROP TABLE IF EXISTS PriceSettings;
      END IF;

      CREATE TEMP TABLE PriceSettings ON COMMIT DROP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (vbUserId::TVarChar));

      ANALYSE PriceSettings;

      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('PriceSettingsTOP'))
      THEN
        DROP TABLE IF EXISTS PriceSettingsTOP;
      END IF;

      CREATE TEMP TABLE PriceSettingsTOP ON COMMIT DROP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (vbUserId::TVarChar));

      ANALYSE PriceSettingsTOP;

      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('JuridicalSettings'))
      THEN
        DROP TABLE IF EXISTS JuridicalSettings;
      END IF;

      CREATE TEMP TABLE JuridicalSettings ON COMMIT DROP AS
        (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId);

      ANALYSE JuridicalSettings;

      -- �������� ��������� ��.��� (������� ��� ��� ������)
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpJuridicalSettingsItem'))
      THEN
        DROP TABLE IF EXISTS tmpJuridicalSettingsItem;
      END IF;

      CREATE TEMP TABLE tmpJuridicalSettingsItem ON COMMIT DROP AS
                                  (SELECT tmp.JuridicalSettingsId
                                        , tmp.Bonus
                                        , tmp.PriceLimit_min
                                        , tmp.PriceLimit
                                   FROM JuridicalSettings
                                        INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inSession) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                   WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                   );

      ANALYSE tmpJuridicalSettingsItem;

      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('JuridicalArea'))
      THEN
        DROP TABLE IF EXISTS JuridicalArea;
      END IF;

      CREATE TEMP TABLE JuridicalArea ON COMMIT DROP AS
                      (SELECT DISTINCT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                        FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                             INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                      AND Object_JuridicalArea.isErased = FALSE
                             INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                   ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                  AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                  AND ObjectLink_JuridicalArea_Area.ChildObjectId = vbAreaId_find
                             -- ���������� ��� ���������� ������ ��� �������
                             INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                      ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                                     AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                     AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                        WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                       );

      ANALYSE JuridicalArea;


      -- ������ ����������� ���
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpSupplierFailuresAll'))
      THEN
        DROP TABLE IF EXISTS tmpSupplierFailuresAll;
      END IF;

      CREATE TEMP TABLE tmpSupplierFailuresAll ON COMMIT DROP AS
                                 (SELECT DISTINCT
                                         SupplierFailures.OperDate
                                       , SupplierFailures.DateFinal
                                       , SupplierFailures.GoodsId
                                       , SupplierFailures.JuridicalId
                                       , SupplierFailures.ContractId
                                  FROM lpSelect_PriceList_SupplierFailuresAll(vbUnitId, vbUserId) AS SupplierFailures
                                  );

      ANALYSE tmpSupplierFailuresAll;
      
      -- �������� ���������� ���� (��� � ����� ������� VIP)
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpReserve'))
      THEN
        DROP TABLE IF EXISTS tmpReserve;
      END IF;

      CREATE TEMP TABLE tmpReserve ON COMMIT DROP AS (
      WITH  tmpMovementChekID AS (SELECT
                                    Movement.Id
                             FROM Movement
                             WHERE Movement.DescId = zc_Movement_Check()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           )
     , tmpMovementChek AS (SELECT Movement.Id
                           FROM MovementBoolean AS MovementBoolean_Deferred
                                INNER JOIN tmpMovementChekID AS Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             AND MovementLinkObject_Unit.ObjectId = vbUnitId
                           WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                             AND MovementBoolean_Deferred.ValueData = TRUE
                          UNION
                           SELECT Movement.Id
                           FROM MovementString AS MovementString_CommentError
                                INNER JOIN tmpMovementChekID AS Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             AND MovementLinkObject_Unit.ObjectId = vbUnitId
                          WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                            AND MovementString_CommentError.ValueData <> ''
                          )
                          
                      SELECT MovementItem.ObjectId             AS GoodsId
                           , SUM (MovementItem.Amount)::TFloat AS Amount
                      FROM tmpMovementChek
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                                     ON MovementBoolean_NotMCS.MovementId = tmpMovementChek.Id
                                                    AND MovementBoolean_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                      WHERE COALESCE (MovementBoolean_NotMCS.ValueData, False) = False
                      GROUP BY MovementItem.ObjectId
                      );

      ANALYSE tmpReserve;

      -- ����� �������
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpDeferred'))
      THEN
        DROP TABLE IF EXISTS tmpDeferred;
      END IF;

      CREATE TEMP TABLE tmpDeferred ON COMMIT DROP AS (
      WITH  tmpDeferred_All AS (SELECT Movement_OrderExternal.Id
                                 , MI_OrderExternal.ObjectId                AS GoodsId
                                 , SUM (MI_OrderExternal.Amount) ::TFloat   AS Amount
                                 , SUM (CASE WHEN COALESCE (tmpSupplierFailuresAll.GoodsId, 0) <> 0 THEN MI_OrderExternal.Amount END) ::TFloat   AS AmountSF
                            FROM Movement AS Movement_OrderExternal
                                 INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                       ON MovementBoolean_Deferred.MovementId = Movement_OrderExternal.Id
                                                      AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                      AND MovementBoolean_Deferred.ValueData = TRUE
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                 INNER JOIN MovementItem AS MI_OrderExternal
                                                    ON MI_OrderExternal.MovementId = Movement_OrderExternal.Id
                                                   AND MI_OrderExternal.DescId = zc_MI_Master()
                                                   AND MI_OrderExternal.isErased = FALSE
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement_OrderExternal.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = Movement_OrderExternal.Id
                                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                  ON MILinkObject_Goods.MovementItemId = MI_OrderExternal.Id
                                                                 AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                 LEFT JOIN tmpSupplierFailuresAll ON tmpSupplierFailuresAll.OperDate <= Movement_OrderExternal.OperDate
                                                                 AND tmpSupplierFailuresAll.DateFinal > Movement_OrderExternal.OperDate
                                                                 AND tmpSupplierFailuresAll.GoodsId = MILinkObject_Goods.ObjectId
                                                                 AND tmpSupplierFailuresAll.JuridicalId = MovementLinkObject_From.ObjectId
                                                                 AND tmpSupplierFailuresAll.ContractId = MovementLinkObject_Contract.ObjectId
                            WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                              AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                            GROUP BY MI_OrderExternal.ObjectId, Movement_OrderExternal.Id
                            HAVING SUM (MI_OrderExternal.Amount) <> 0
                       )
                       
                        SELECT Movement_OrderExternal.GoodsId                 AS GoodsId
                             , SUM (Movement_OrderExternal.Amount) ::TFloat   AS AmountDeferred
                             , SUM (Movement_OrderExternal.AmountSF) ::TFloat AS AmountSF
                        FROM tmpDeferred_All AS Movement_OrderExternal
                            LEFT JOIN MovementLinkMovement AS MLM_Order
                                                           ON MLM_Order.MovementChildId = Movement_OrderExternal.Id     --MLM_Order.MovementId = Movement_Income.Id
                                                          AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                        WHERE MLM_Order.MovementId is NULL
                        GROUP BY Movement_OrderExternal.GoodsId
                        HAVING SUM (Movement_OrderExternal.Amount) <> 0
                       );
                       
      ANALYSE tmpDeferred;
      
      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpGoods_all'))
      THEN
        DROP TABLE IF EXISTS tmpGoods_all;
      END IF;

      CREATE TEMP TABLE tmpGoods_all ON COMMIT DROP AS (
      WITH tmpMI_Master AS (SELECT MovementItem.Id
                                 , MovementItem.ObjectId
                         FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                               JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = tmpIsErased.isErased
                        )
      , tmpGoods_PriceList AS (SELECT * FROM gpSelect_PriceList_AllGoods (vbObjectId, inSession))

                         SELECT ObjectLink_Goods_Object.ObjectId                       AS GoodsId
                              , Object_Goods.ObjectCode                                AS GoodsCode
                              , Object_Goods.ValueData                                 AS GoodsName
                              , ObjectLink_Goods_GoodsGroup.ChildObjectId              AS GoodsGroupId
                              , ObjectLink_Goods_NDSKind.ChildObjectId                 AS NDSKindId
                              , Object_NDSKind.ValueData                               AS NDSKindName
                              , ObjectFloat_NDSKind_NDS.ValueData                      AS NDS
                              -- , ObjectFloat_Goods_MinimumLot.ValueData                 AS Multiplicity
                              , COALESCE(ObjectBoolean_Goods_Close.ValueData, FALSE)   AS isClose
                              , COALESCE(ObjectBoolean_Goods_TOP.ValueData, FALSE)     AS Goods_isTOP
                              , COALESCE (GoodsPrice.isTop, FALSE)                     AS Price_isTOP
                              , COALESCE(ObjectBoolean_First.ValueData, FALSE)         AS isFirst
                              , COALESCE(ObjectBoolean_Second.ValueData, FALSE)        AS isSecond

                              , ObjectLink_Goods_Object.ObjectId                       AS GoodsId_MinLot

                         FROM ObjectLink AS ObjectLink_Goods_Object
                              INNER JOIN Object AS Object_Goods
                                                ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                                               AND Object_Goods.isErased = FALSE
                              LEFT JOIN tmpGoods_PriceList ON tmpGoods_PriceList.GoodsId = ObjectLink_Goods_Object.ObjectId

                              LEFT JOIN tmpMI_Master ON tmpMI_Master.ObjectId = ObjectLink_Goods_Object.ObjectId

                              LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods.Id

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                   ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                                  AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                              LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                              LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                    ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                                   AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                                      ON ObjectBoolean_Goods_Close.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                     AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                      ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                     AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                                      ON ObjectBoolean_First.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                     AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                                      ON ObjectBoolean_Second.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                     AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()

                              -- LEFT JOIN tmpOF_Goods_MinimumLot  AS ObjectFloat_Goods_MinimumLot
                              --                       ON ObjectFloat_Goods_MinimumLot.ObjectId = ObjectLink_Goods_Object.ObjectId
                                               --     AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                         WHERE (inShowAll = TRUE AND tmpGoods_PriceList.GoodsId is not NULL OR tmpMI_Master.Id is not NULL)
                           AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                           AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                        );
                        
      ANALYSE tmpGoods_all;
    
    END IF;

     -- ������ �����������
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpSupplierFailures'))
    THEN
      DROP TABLE IF EXISTS tmpSupplierFailures;
    END IF;

    CREATE TEMP TABLE tmpSupplierFailures ON COMMIT DROP AS
                                (SELECT DISTINCT
                                       SupplierFailures.GoodsId
                                     , SupplierFailures.JuridicalId
                                     , SupplierFailures.ContractId
                                 FROM lpSelect_PriceList_SupplierFailures(vbUnitId, vbUserId) AS SupplierFailures
                                 );

    ANALYSE tmpSupplierFailures;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpGoodsSPRegistry_1303'))
    THEN
      DROP TABLE IF EXISTS tmpGoodsSPRegistry_1303;
    END IF;

    CREATE TEMP TABLE tmpGoodsSPRegistry_1303 ON COMMIT DROP  AS
         (select * from gpSelect_GoodsSPRegistry_1303_All(inSession := inSession));

    ANALYSE tmpGoodsSPRegistry_1303;
    
    
    -- �������� ��������� ���
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpFinalSUAList'))
    THEN
      DROP TABLE IF EXISTS tmpFinalSUAList;
    END IF;

    CREATE TEMP TABLE tmpFinalSUAList ON COMMIT DROP AS (
    WITH tmpFinalSUA AS (SELECT Movement.id
                     FROM Movement
                          LEFT JOIN MovementDate AS MovementDate_Calculation
                                                 ON MovementDate_Calculation.MovementId = Movement.Id
                                                AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()
                          LEFT JOIN MovementDate AS MovementDate_DateOrder
                                                 ON MovementDate_DateOrder.MovementId = Movement.Id
                                                AND MovementDate_DateOrder.DescId = zc_MovementDate_Order()

                          LEFT JOIN MovementBoolean AS MovementBoolean_OnlyOrder
                                                    ON MovementBoolean_OnlyOrder.MovementId = Movement.Id
                                                   AND MovementBoolean_OnlyOrder.DescId = zc_MovementBoolean_OnlyOrder()

                     WHERE Movement.OperDate = vbOperDate - ((date_part('DOW', vbOperDate)::Integer - 1)::TVarChar||' DAY')::INTERVAL
                       AND Movement.DescId = zc_Movement_FinalSUA()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND (COALESCE (MovementBoolean_OnlyOrder.ValueData, FALSE) = TRUE OR MovementDate_Calculation.ValueData IS NOT NULL)
                       AND COALESCE(MovementDate_DateOrder.ValueData, MovementDate_Calculation.ValueData) = vbOperDate
                     )
    -- ������ ��������� ���
                        SELECT MovementItem.ObjectId                                              AS GoodsId
                             , SUM(MovementItem.Amount)                                            AS FinalSUA
                             , COALESCE (SUM(MIFloat_SendSUN.ValueData), 0)                        AS FinalSUASend

                        FROM tmpFinalSUA
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpFinalSUA.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE

                             INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                               ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                              AND MILinkObject_Unit.ObjectId = vbUnitId

                             LEFT JOIN MovementItemFloat AS MIFloat_SendSUN
                                                         ON MIFloat_SendSUN.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SendSUN.DescId = zc_MIFloat_SendSUN()
                        GROUP BY MovementItem.ObjectId);
                        
    ANALYSE tmpFinalSUAList;
                        
                        
    -- ��������
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpLayoutAll'))
    THEN
      DROP TABLE IF EXISTS tmpLayoutAll;
    END IF;

    CREATE TEMP TABLE tmpLayoutAll ON COMMIT DROP AS (
    WITH tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                           FROM Movement
                                LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                          ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                         AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                           WHERE Movement.DescId = zc_Movement_Layout()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                          )
  , tmpLayout AS (SELECT Movement.ID                        AS Id
                        , MovementItem.ObjectId              AS GoodsId
                        , MovementItem.Amount                AS Amount
                        , Movement.isPharmacyItem            AS isPharmacyItem
                   FROM tmpLayoutMovement AS Movement
                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId = zc_MI_Master()
                                               AND MovementItem.isErased = FALSE
                                               AND MovementItem.Amount > 0
                  )
  , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                           , MovementItem.ObjectId              AS UnitId
                      FROM tmpLayoutMovement AS Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Child()
                                                  AND MovementItem.isErased = FALSE
                                                  AND MovementItem.Amount > 0
                     )

  , tmpLayoutUnitCount AS (SELECT tmpLayoutUnit.ID                  AS Id
                                , count(*)                          AS CountUnit
                           FROM tmpLayoutUnit
                           GROUP BY tmpLayoutUnit.ID
                           )
                           
                     SELECT tmpLayout.GoodsId                  AS GoodsId
                          , MAX(tmpLayout.Amount)::TFloat      AS Amount
                     FROM tmpLayout

                          LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                  ON Unit_PharmacyItem.ObjectId  = vbUnitId
                                                 AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()

                          LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                 AND tmpLayoutUnit.UnitId = vbUnitId

                          LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id

                     WHERE (tmpLayoutUnit.UnitId = vbUnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                       AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                     GROUP BY tmpLayout.GoodsId
                     );
                     
  ANALYSE tmpLayoutAll;
    

--raise notice 'Value 09: %', CLOCK_TIMESTAMP();





    -- !!!������ ��� ����� ���������� - 1-�� ����� (����� = 3)!!!
    IF vbisDocument = TRUE AND vbStatusId = zc_Enum_Status_Complete()
      AND inShowAll = FALSE 
    THEN

     raise notice 'Value: %', 1;

     PERFORM lpCreateTempTable_OrderInternal_MI(inMovementId, vbObjectId, 0, vbUserId);

     RETURN QUERY
     WITH
        --������ ����������� ������ ������/��������
        tmpDateList AS (SELECT ''||tmpDayOfWeek.DayOfWeekName|| '-' || DATE_PART ('day', tmp.OperDate :: Date) ||'' AS OperDate
                           --''||tmp.OperDate :: Date || ' (' ||tmpDayOfWeek.DayOfWeekName ||')' AS OperDate
                             , tmpDayOfWeek.Number
                             , tmpDayOfWeek.DayOfWeekName
                        FROM (SELECT generate_series ( CURRENT_DATE,  CURRENT_DATE+interval '6 day', '1 day' :: INTERVAL) AS OperDate) AS tmp
                          LEFT JOIN zfCalc_DayOfWeekName(tmp.OperDate) AS tmpDayOfWeek ON 1=1
                        )
      , tmpOrderShedule AS (SELECT ObjectLink_OrderShedule_Contract.ChildObjectId          AS ContractId --
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1)) ::TFloat AS Value1
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2)) ::TFloat AS Value2
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3)) ::TFloat AS Value3
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4)) ::TFloat AS Value4
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5)) ::TFloat AS Value5
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6)) ::TFloat AS Value6
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7)) ::TFloat AS Value7
                            FROM Object AS Object_OrderShedule
                                 INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                                       ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                                                      AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                                                      AND ObjectLink_OrderShedule_Unit.ChildObjectId = vbUnitId
                                 LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                                      ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                                                     AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                            WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                              AND Object_OrderShedule.isErased = FALSE
                           )
      , tmpOrderSheduleList AS (SELECT tmp.*
                                FROM (
                                      select tmpOrderShedule.ContractId, CASE WHEN Value1 in (1,3) THEN 1 ELSE 0 END AS DoW, CASE WHEN Value1 in (2,3) THEN 1 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value2 in (1,3) THEN 2 ELSE 0 END AS DoW, CASE WHEN Value2 in (2,3) THEN 2 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value3 in (1,3) THEN 3 ELSE 0 END AS DoW, CASE WHEN Value3 in (2,3) THEN 3 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value4 in (1,3) THEN 4 ELSE 0 END AS DoW, CASE WHEN Value4 in (2,3) THEN 4 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value5 in (1,3) THEN 5 ELSE 0 END AS DoW, CASE WHEN Value5 in (2,3) THEN 5 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value6 in (1,3) THEN 6 ELSE 0 END AS DoW, CASE WHEN Value6 in (2,3) THEN 6 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value7 in (1,3) THEN 7 ELSE 0 END AS DoW, CASE WHEN Value7 in (2,3) THEN 7 ELSE 0 END AS DoW_D from tmpOrderShedule) AS tmp
                                WHERE tmp.DoW <> 0 OR tmp.DoW_D <> 0
                                )
      , tmpAfter AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                     FROM (
                           SELECT tmpOrderSheduleList.ContractId, min (DoW) AS DoW, 0 AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW > vbCURRENT_DOW
                             AND tmpOrderSheduleList.DoW > 0
                           GROUP BY tmpOrderSheduleList.ContractId
                         UNION
                           SELECT tmpOrderSheduleList.ContractId, 0 AS DoW, min (DoW_D) AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW_D > vbCURRENT_DOW
                             AND tmpOrderSheduleList.DoW_D > 0
                           GROUP BY tmpOrderSheduleList.ContractId) as tmp
                     GROUP BY tmp.ContractId
                     )
      , tmpBefore AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                      FROM (
                          SELECT tmpOrderSheduleList.ContractId,  min (tmpOrderSheduleList.DoW) AS DoW, 0 AS DoW_D
                          FROM tmpOrderSheduleList
                             LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                          WHERE tmpOrderSheduleList.DoW < vbCURRENT_DOW
                            AND tmpAfter.ContractId IS NULL
                            AND tmpOrderSheduleList.DoW<>0
                          GROUP BY tmpOrderSheduleList.ContractId
                      UNION
                          SELECT tmpOrderSheduleList.ContractId, 0 AS DoW,  min (tmpOrderSheduleList.DoW_D) AS DoW_D
                          FROM tmpOrderSheduleList
                             LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                          WHERE tmpOrderSheduleList.DoW_D < vbCURRENT_DOW
                            AND tmpAfter.ContractId IS NULL
                            AND tmpOrderSheduleList.DoW_D<>0
                          GROUP BY tmpOrderSheduleList.ContractId) as tmp
                      GROUP BY tmp.ContractId
                      )
      , OrderSheduleList AS ( SELECT tmp.ContractId
                                   , tmpDateList.OperDate         AS OperDate_Zakaz
                                   , tmpDateList_D.OperDate       AS OperDate_Dostavka
                              FROM (SELECT *
                                    FROM tmpAfter
                                 union all
                                    SELECT *
                                    FROM tmpBefore
                                   ) AS tmp
                               LEFT JOIN tmpDateList ON tmpDateList.Number = tmp.DoW
                               LEFT JOIN tmpDateList AS tmpDateList_D ON tmpDateList_D.Number = tmp.DoW_D
                         )
      , OrderSheduleListToday AS (SELECT *
                                  FROM tmpOrderSheduleList
                                  WHERE tmpOrderSheduleList.DoW = vbCURRENT_DOW  OR tmpOrderSheduleList.DoW_D = vbCURRENT_DOW
                                 )
--

        -- ������������� ��������
      , GoodsPromo AS (SELECT tmp.JuridicalId
                            , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- ����� ����� "����"
                            --, tmp.MovementId
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

      -- ������ �� ������. �������
      , tmpGoodsCategory AS (SELECT ObjectLink_Child_retail.ChildObjectId AS GoodsId
                                  , ObjectFloat_Value.ValueData                  AS Value
                             FROM Object AS Object_GoodsCategory
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                       ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                                      AND ObjectLink_GoodsCategory_Unit.ChildObjectId = vbUnitId
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                       ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                 INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                        ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                       AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                            -- ������� �� ����� ����
                            INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                  ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                 AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                            INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                  ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                 AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                 AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                             WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                               AND Object_GoodsCategory.isErased = FALSE
                             )

      , tmpMI_Child AS (SELECT MI_Child.ParentId AS MIMasterId
                             , MI_Child.Id       AS MIId
                        FROM MovementItem AS MI_Child
                        WHERE MI_Child.MovementId = inMovementId
                          AND MI_Child.DescId     = zc_MI_Child()
                          AND MI_Child.isErased   = FALSE
                        )

        -- ������ ���-������ (��������)
      , tmpGoodsSP AS (SELECT tmp.GoodsId
                            , TRUE AS isSP
                            , MIN(MIFloat_PriceOptSP.ValueData) AS PriceOptSP
                       FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbOperDate, inEndDate:= vbOperDate, inUnitId := vbUnitId) AS tmp
                                                LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                     ON MIFloat_PriceOptSP.MovementItemId = tmp.MovementItemId
                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                       GROUP BY tmp.GoodsId
                       )
      -- ���������� ��������� �������������
      , tmpDiscountJuridicalAll AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                         , ObjectLink_Juridical.ChildObjectId            AS JuridicalId
                                         , CASE WHEN ObjectLink_Juridical.ChildObjectId = 59611
                                                THEN '������'
                                                ELSE Object_Juridical.ValueData END      AS JuridicalName
                                    FROM Object AS Object_DiscountExternalSupplier
                                         LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                              ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                                             AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()

                                          LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                               ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                                              AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()
                                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

                                     WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier()
                                       AND Object_DiscountExternalSupplier.isErased = FALSE)
      , tmpDiscountJuridical AS (SELECT tmpDiscountJuridicalAlL.DiscountExternalId                   AS DiscountExternalId
                                      , STRING_AGG(tmpDiscountJuridicalAll.JuridicalName, ', ')      AS JuridicalName
                                 FROM tmpDiscountJuridicalAll
                                 GROUP BY tmpDiscountJuridicalAll.DiscountExternalId)
      -- ���������� ��������� �������������
      , tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                 , tmpDiscountJuridical.JuridicalName::TVarChar  AS JuridicalName
                            FROM Object AS Object_DiscountExternalTools
                                  LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                       ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                      AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                  LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                       ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                  LEFT JOIN tmpDiscountJuridical ON tmpDiscountJuridical.DiscountExternalId = ObjectLink_DiscountExternal.ChildObjectId
                             WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                               AND ObjectLink_Unit.ChildObjectId = vbUnitId
                               AND Object_DiscountExternalTools.isErased = False
                             )
      -- ������ ���������� ���������
      , tmpGoodsDiscount AS (SELECT
                                   Object_Goods_Retail.GoodsMainId

                                 , Object_Object.Id                AS ObjectId
                                 , Object_Object.ValueData         AS DiscountName
                                 , tmpUnitDiscount.JuridicalName   AS DiscountJuridical
                                 , tmpUnitDiscount.DiscountExternalId

                             FROM Object AS Object_BarCode
                                 LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                      ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                 LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = ObjectLink_BarCode_Goods.ChildObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                      ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                 LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId

                             WHERE Object_BarCode.DescId = zc_Object_BarCode()
                               AND Object_BarCode.isErased = False
                               AND Object_Object.isErased = False
                               AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
                      )
      , tmpGoodsDiscountJuridical AS (SELECT DISTINCT
                                             tmpGoodsDiscount.GoodsMainId
                                           , tmpDiscountJuridicalAll.JuridicalId

                                       FROM tmpGoodsDiscount

                                           INNER JOIN tmpDiscountJuridicalAll ON tmpDiscountJuridicalAll.DiscountExternalId = tmpGoodsDiscount.DiscountExternalId
                                      )

      , tmpGoodsMain AS (SELECT tmpMI.GoodsId
                              , COALESCE (tmpGoodsSP.isSP, False)           ::Boolean AS isSP
                              , COALESCE (ObjectBoolean_Resolution_224.ValueData, False)      ::Boolean AS isResolution_224
                              , CAST ( (COALESCE (tmpGoodsSP.PriceOptSP,0) * 1.1) AS NUMERIC (16,2))    :: TFloat   AS PriceOptSP
                              , CASE WHEN DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData) = vbOperDate THEN TRUE ELSE FALSE END  AS isMarketToday
                              , DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData)                   ::TDateTime  AS LastPriceDate
                              , COALESCE (ObjectFloat_CountPrice.ValueData,0) ::TFloat AS CountPrice
                              , tmpGoodsDiscount.DiscountName
                              , tmpGoodsDiscount.DiscountJuridical
                              , ObjectLink_Main.ChildObjectId                                           AS GoodsMainId
                         FROM  _tmpOrderInternal_MI AS tmpMI
                                -- �������� GoodsMainId
                                LEFT JOIN  ObjectLink AS ObjectLink_Child
                                                      ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId
                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                      ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                     AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                     ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()
                                LEFT JOIN ObjectFloat AS ObjectFloat_CountPrice
                                                      ON ObjectFloat_CountPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                     AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                        ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                       AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

                                LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId

                                LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = ObjectLink_Main.ChildObjectId
                         )

      , tmpMI AS (SELECT tmpMI.*
                       , Object_Goods.ObjectCode                          AS GoodsCode
                       , Object_Goods.ValueData                           AS GoodsName
                       , ObjectLink_Object.ChildObjectId                  AS RetailId
                       , ObjectFloat_Goods_MinimumLot.ValueData           AS Multiplicity  --MinimumLot
                       , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
                       , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
                       , Object_NDSKind.ValueData                         AS NDSKindName
                       , ObjectFloat_NDSKind_NDS.ValueData                AS NDS

                       , CEIL (tmpMI.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)) * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)  AS CalcAmount
                       , COALESCE(Object_ConditionsKeep.ValueData, '')      :: TVarChar AS ConditionsKeepName
                       , tmpGoodsMain.isSP
                       , tmpGoodsMain.isResolution_224
                       , tmpGoodsMain.PriceOptSP
                       , tmpGoodsMain.isMarketToday       -- CURRENT_DATE
                       , tmpGoodsMain.LastPriceDate
                       , tmpGoodsMain.CountPrice
                       , tmpGoodsMain.DiscountName
                       , tmpGoodsMain.DiscountJuridical
                       , tmpGoodsMain.GoodsMainId

                  FROM  _tmpOrderInternal_MI AS tmpMI

                        -- ������� ��������
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                             ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmpMI.GoodsId
                                            AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                        LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

                        -- �������� ����
                        LEFT JOIN  ObjectLink AS ObjectLink_Object
                                              ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
                                             AND ObjectLink_Object.DescId = zc_ObjectLink_Goods_Object()

                        -- �������� GoodsMainId
                        LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = tmpMI.GoodsId


                        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                             ON ObjectLink_Goods_NDSKind.ObjectId = tmpMI.GoodsId
                                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                             ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_MinimumLot
                                               ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI.GoodsId
                                              AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                              AND ObjectFloat_Goods_MinimumLot.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                  )

      -- ������� ��� MovementItemFloat
      , tmpMIF AS (SELECT *
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)

                   )

      , tmpMIF_Price AS (SELECT tmpMIF.*
                         FROM tmpMIF
                         WHERE tmpMIF.DescId = zc_MIFloat_PriceFrom() -- !!!�� ������!!!
                         )

      , tmpMIF_JuridicalPrice AS (SELECT tmpMIF.*
                                  FROM tmpMIF
                                  WHERE tmpMIF.DescId = zc_MIFloat_JuridicalPrice()
                                  )

      , tmpMIF_DefermentPrice AS (SELECT tmpMIF.*
                                  FROM tmpMIF
                                  WHERE tmpMIF.DescId = zc_MIFloat_DefermentPrice()
                                  )

      , tmpMIF_Summ  AS (SELECT tmpMIF.*
                         FROM tmpMIF
                         WHERE tmpMIF.DescId = zc_MIFloat_Summ()
                         )
      , tmpMIF_AmountSecond AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountSecond()
                                )
      , tmpMIF_AmountManual AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountManual()
                                )

      , tmpMIString_Comment AS (SELECT MIString_Comment.*
                                FROM MovementItemString AS MIString_Comment
                                WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                  AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                                )

      , tmpMIBoolean_Calculated AS (SELECT MIBoolean_Calculated.*
                                    FROM tmpMI
                                         INNER JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                ON MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                               AND MIBoolean_Calculated.MovementItemId = tmpMI.MovementItemId
                                   )
      -- �� ������� ����� 0 � ��� ���� � ������ ��������� � ������������� - �� �� � ������� ��� ������� � ��� ����� �������� ������ � ������� �����.
      -- ����� ������� ����� ���������� ������ ������ - �������, ������� � �������, �������, ���������� - ���������� �� ����� �������� ���� �����.
      -- �������� ������ ������� =0, ������ ������� = 0
      , tmpGoodsList AS (SELECT tmpMI.GoodsId                AS GoodsId
                              , COALESCE (tmpMI.Amount, 0)   AS Amount
                              , COALESCE (tmpMI.Remains, 0)  AS Remains
                              , COALESCE (tmpMI.Income, 0)   AS Income
                         FROM tmpMI
                         WHERE COALESCE (tmpMI.Amount, 0) > 0   --COALESCE (tmpMI.Remains, 0) = 0 AND COALESCE (tmpMI.Income, 0) = 0 AND
                        )
/*      , tmpLastOrder AS (SELECT Movement.Id
                              , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.Operdate DESC) AS Ord
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MLO_Unit
                                                            ON MLO_Unit.MovementId = Movement.Id
                                                           AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                           AND MLO_Unit.ObjectId   = vbUnitId
                         WHERE Movement.DescId = zc_Movement_OrderInternal()
                           AND Movement.Operdate >= vbOperDate - INTERVAL '30 DAY' AND Movement.Operdate < vbOperDate
                           AND 1=0
                        )
      -- ������ ����� / ���������
      , tmpOrderLast_2days AS (SELECT tmpGoodsList.GoodsId
                                    , COUNT (DISTINCT Movement.Id) AS Amount
                               FROM tmpLastOrder AS Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN tmpGoodsList ON tmpGoodsList.GoodsId = MovementItem.ObjectId
                                                           AND tmpGoodsList.Remains = 0
                                                           AND tmpGoodsList.Income = 0
                               WHERE Movement.Ord IN (1, 2)
                               GROUP BY tmpGoodsList.GoodsId
                               )
      -- ��������� �����  --�������, ������� ��� �������� � ������� ���������� �����, �� �� ������ �� ����� � ����� ����� � ��������� ���������� � ��� �� ���-�� ��� ������
      , tmpRepeat AS (SELECT tmpGoods.GoodsId
                          ,  CASE WHEN tmpGoods.Amount >= COALESCE (MovementItem.Amount, 0) THEN TRUE ELSE FALSE END isRepeat
                      FROM tmpLastOrder AS Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN (SELECT tmpGoodsList.GoodsId, tmpGoodsList.Amount
                                       FROM tmpGoodsList
                                       WHERE tmpGoodsList.Income = 0
                                       ) AS tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                      WHERE Movement.Ord = 1
                     )

      , tmpOrderLast_10 AS (SELECT tmpGoodsNotLink.GoodsId
                                 , COUNT (DISTINCT Movement.Id) AS Amount
                            FROM tmpLastOrder AS Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 INNER JOIN tmpGoodsNotLink ON tmpGoodsNotLink.GoodsId = MovementItem.ObjectId
                            WHERE Movement.Ord <= 10
                            GROUP BY tmpGoodsNotLink.GoodsId
                            )
*/
      -- ��� �������� �� ���������� � ��������� 10 ���������� �������
      -- ������ ��� �������� � ����������
      -- ������ ����� ������, �.�. ������������ �� ������
      , tmpGoodsNotLink AS (SELECT DISTINCT tmpGoodsList.GoodsId
                            FROM tmpGoodsList
                                 LEFT JOIN (SELECT DISTINCT tmpGoodsList.GoodsId
                                            FROM tmpGoodsList
                                               /*LEFT JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                                                                 ON LinkGoods_Partner_Main.GoodsId = tmpGoodsList.GoodsId  -- ����� ������ ���������� � �����

                                                 INNER JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- ����� ������ ���� � ������� �������
                                                                                  ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId*/

                                                 -- �������� GoodsMainId
                                                 INNER JOIN  ObjectLink AS ObjectLink_Child
                                                                        ON ObjectLink_Child.ChildObjectId = tmpGoodsList.GoodsId
                                                                       AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                 LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                                       ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                      AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                                 --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- ����� ������ � ������ � ������� �������
                                                 --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                                 -- ������ ���� �� �������� GoodsMainId
                                                 LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                                      ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                                                     AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_Main.ChildObjectId --Object_LinkGoods_View.GoodsMainId

                                                 LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                                      ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                                     AND ObjectLink_LinkGoods_Goods.DescId   = zc_ObjectLink_LinkGoods_Goods()

                                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                      ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                                     AND ObjectLink_Goods_Object.DescId  = zc_ObjectLink_Goods_Object()

                                                 INNER JOIN Object ON Object.id = ObjectLink_Goods_Object.ChildObjectId AND Object.Descid = zc_Object_Juridical()
                                            ) AS tmp ON tmp.GoodsId = tmpGoodsList.GoodsId
                            WHERE tmp.GoodsId IS NULL
                              AND inIsLink = TRUE
                            )

      , tmpOneJuridical AS (SELECT tmpMI.MIMasterId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                            FROM tmpMI_Child AS tmpMI
                            GROUP BY tmpMI.MIMasterId
                            )

      --������� ���� �� ������� �� �����
      /*, AVGOrder AS (SELECT MovementItem.ObjectId
                          , AVG(MIFloat_Price.ValueData) ::TFloat AS AVGPrice
                     FROM Movement
                          JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                           AND MovementItem.DescId = zc_MI_Master()
                                           AND MovementItem.isErased = FALSE
                                           AND MovementItem.Amount > 0
                          JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     WHERE Movement.DescId = zc_Movement_OrderInternal()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND Movement.Id <> inMovementId
                       AND Movement.OperDate >= vbAVGDateStart
                       AND Movement.OperDate <= vbAVGDateEnd
                     GROUP BY MovementItem.ObjectId
                    )*/
          , AVGIncome AS (SELECT MI_Income.ObjectId
                               , AVG(CASE WHEN MovementBoolean_PriceWithVAT.ValueData  = TRUE
                                          THEN (MIFloat_Price.ValueData * 100 / (100 + ObjectFloat_NDSKind_NDS.ValueData))
                                          ELSE MIFloat_Price.ValueData
                                     END)                               ::TFloat AS AVGIncomePrice
                          FROM Movement AS Movement_Income
                              JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                   ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Income.Id
                                                  AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                              JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                      ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                                     AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                              JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                               ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                              AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                              JOIN MovementItem AS MI_Income
                                                ON MI_Income.MovementId = Movement_Income.Id
                                               AND MI_Income.DescId = zc_MI_Master()
                                               AND MI_Income.isErased = FALSE
                                               AND MI_Income.Amount > 0
                              JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          WHERE Movement_Income.DescId = zc_Movement_Income()
                            AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                            AND Movement_Income.OperDate >= vbAVGDateStart
                            AND Movement_Income.OperDate <= vbAVGDateEnd
                          GROUP BY MI_Income.ObjectId
                         )


   -- ��� �� �����-����� ���������� (LoadPriceList )
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

   -- ����������� �� ��� ��������� �� ���� ���������
   , tmpSendSun AS (SELECT MI_Send.ObjectId                AS GoodsId
                         , SUM (MI_Send.Amount) ::TFloat   AS Amount
                     FROM Movement AS Movement_Send
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Send.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                       ON MovementBoolean_SUN.MovementId = Movement_Send.Id
                                                      AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                      AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementItem AS MI_Send
                                                    ON MI_Send.MovementId = Movement_Send.Id
                                                   AND MI_Send.DescId = zc_MI_Master()
                                                   AND MI_Send.isErased = FALSE

                            --INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = MI_Send.ObjectId
                     WHERE Movement_Send.OperDate = vbOperDate
                       AND Movement_Send.DescId = zc_Movement_Send()
                       AND Movement_Send.StatusId = zc_Enum_Status_Erased()
                     GROUP BY MI_Send.ObjectId
                     HAVING SUM (MI_Send.Amount) <> 0
                    )


       -- ��������� 1
       SELECT
             tmpMI.MovementItemId                                   AS Id
           , tmpMI.GoodsId                                          AS GoodsId
           , tmpMI.GoodsCode                                        AS GoodsCode
           , tmpMI.GoodsName                                        AS GoodsName
           , Object_Retail.ValueData                                AS RetailName
           , tmpMI.isTOP                                            AS isTOP
           , tmpMI.isUnitTOP                                        AS isTOP_Price

           , tmpMI.GoodsGroupId                                     AS GoodsGroupId
           , tmpMI.NDSKindId                                        AS NDSKindId
           , tmpMI.NDSKindName                                      AS NDSKindName
           , tmpMI.NDS                                              AS NDS

           , CASE WHEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'0') <> '0' THEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'') ELSE '' END  :: TVarChar             AS NDS_PriceList                      -- ��� �� ������ ����������

           , tmpMI.isClose
           , tmpMI.isFirst
           , tmpMI.isSecond
           , tmpMI.isSP
           , tmpMI.isResolution_224 :: Boolean

           , tmpMI.isMarketToday
           , tmpMI.LastPriceDate

           , CASE WHEN tmpMI.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                  WHEN tmpMI.isTOP = TRUE OR tmpMI.isUnitTOP = TRUE THEN 16440317         --12615935      ---16440317  - ������� ��� � ������� ELSE zc_Color_White()
                  ELSE zc_Color_White() --0
             END                                                    AS isTopColor
           , tmpMI.Multiplicity                                     AS Multiplicity
           , tmpMI.CalcAmount ::TFloat                              AS CalcAmount
           , tmpMI.Amount   ::TFloat                                AS Amount
           , COALESCE(MIFloat_Summ.ValueData, 0)  ::TFloat          AS Summ
           , COALESCE (tmpMI.isErased, FALSE)     ::Boolean         AS isErased
           , COALESCE (MIFloat_Price.ValueData,0) ::TFloat          AS Price              -- !!!�� ����� ���� ����� zc_MIFloat_PriceFrom!!!
           , tmpMI.MinimumLot
           , tmpMI.PartionGoodsDate
           , MIString_Comment.ValueData                             AS Comment
           , Object_PartnerGoods.Id                                 AS PartnerGoodsId
           , COALESCE(MIString_GoodsCode.ValueData, ObjectString_Goods_Code.ValueData)                      AS PartnerGoodsCode
           , COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData)                          AS PartnerGoodsName
           , tmpMI.JuridicalId
           , tmpMI.JuridicalName -- ***
           , tmpMI.ContractId
           , tmpMI.ContractName
           , tmpMI.MakerName                                        AS MakerName
           , COALESCE (MIFloat_JuridicalPrice.ValueData,0) ::TFloat AS SuperFinalPrice
           , COALESCE (MIFloat_DefermentPrice.ValueData,0) ::TFloat AS SuperFinalPrice_Deferment
           , tmpMI.PriceOptSP
           , CASE WHEN tmpMI.isSP = TRUE AND MIFloat_Price.ValueData > tmpMI.PriceOptSP THEN TRUE ELSE FALSE END isPriceDiff

           , COALESCE(MIBoolean_Calculated.ValueData , FALSE)       AS isCalculated--
           , CASE WHEN tmpMI.isSP = TRUE THEN 25088 --zc_Color_GreenL()   --����� ���.�������
                  WHEN tmpMI.PartionGoodsDate < CASE WHEN COALESCE (tmpLayoutAll.Amount, 0) > 0 THEN vbDate9 ELSE vbDate180 END THEN zc_Color_Red() --456
                  WHEN tmpMI.isTOP = TRUE OR tmpMI.isUnitTOP = TRUE  THEN zc_Color_Blue()--15993821 -- 16440317    -- ��� ��� ������� �����
                     ELSE 0
                END                                                 AS PartionGoodsDateColor
           , tmpMI.Remains ::TFloat                                 AS RemainsInUnit
           , tmpMI.Reserved
           , CASE WHEN (COALESCE (tmpMI.Remains,0) - COALESCE (tmpMI.Reserved,0)) < 0 THEN (COALESCE (tmpMI.Remains,0) - COALESCE (tmpMI.Reserved,0)) ELSE 0 END :: TFLoat AS Remains_Diff   --�� ������� � ������ �����. �����
           , tmpMI.MCS
           , tmpGoodsCategory.Value AS MCS_GoodsCategory

           , tmpMI.MCSIsClose
           , tmpMI.MCSNotRecalc
           , tmpMI.Income                                           AS Income_Amount
           , MIFloat_AmountSecond.ValueData                         AS AmountSecond

           , (tmpMI.Amount + COALESCE (MIFloat_AmountSecond.ValueData,0)) ::TFloat  AS AmountAll
           , NULLIF (COALESCE (-- ����������, ������������� �������
                               MIFloat_AmountManual.ValueData
                               -- ��������� ����� AllLot
                             , CEIL ((
                                      CASE WHEN (COALESCE (tmpMI.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >=
                                                (COALESCE (tmpMI.ListDiffAmount, 0) + COALESCE (tmpMI.SupplierFailuresAmount, 0) + COALESCE (tmpMI.AmountSUA, 0))
                                           THEN (COALESCE (tmpMI.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- ��������� + ���������� ��������������
                                           ELSE (COALESCE (tmpMI.ListDiffAmount, 0) + COALESCE (tmpMI.SupplierFailuresAmount, 0) + COALESCE (tmpMI.AmountSUA, 0))  -- ���-�� ������� + ���
                                      END
                                     ) / COALESCE (tmpMI.MinimumLot, 1)
                                    ) * COALESCE (tmpMI.MinimumLot, 1)
                              ), 0) :: TFloat AS CalcAmountAll

           , (COALESCE (MIFloat_Price.ValueData, 0)
                      * COALESCE (-- ����������, ������������� �������
                                  MIFloat_AmountManual.ValueData
                                  -- ��������� ����� AllLot
                                , CEIL ((
                                      CASE WHEN (COALESCE (tmpMI.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >=
                                                (COALESCE (tmpMI.ListDiffAmount, 0) + COALESCE (tmpMI.SupplierFailuresAmount, 0) + COALESCE (tmpMI.AmountSUA, 0))
                                           THEN (COALESCE (tmpMI.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- ��������� + ���������� ��������������
                                           ELSE (COALESCE (tmpMI.ListDiffAmount, 0) + COALESCE (tmpMI.SupplierFailuresAmount, 0) + COALESCE (tmpMI.AmountSUA, 0))  -- ���-�� ������� + ���
                                      END
                                     ) / COALESCE (tmpMI.MinimumLot, 1)
                                    ) * COALESCE (tmpMI.MinimumLot, 1)
                                 )
             )                                          ::TFloat    AS SummAll

           , tmpMI.CheckAmount                                      AS CheckAmount
           , tmpMI.SendAmount                                       AS SendAmount
           , tmpMI.AmountDeferred                                   AS AmountDeferred
           , tmpMI.AmountSF                                         AS AmountSF
           , tmpMI.ListDiffAmount                       ::TFloat    AS ListDiffAmount
           , tmpMI.SupplierFailuresAmount               ::TFloat    AS SupplierFailuresAmount

           , tmpMI.AmountReal                           ::TFloat    AS AmountReal
           , tmpSendSun.Amount                          ::TFLoat    AS SendSUNAmount
           , tmpMI.SendSUNAmount                        ::TFloat    AS SendSUNAmount_save
           , tmpMI.SendDefSUNAmount                     ::TFloat    AS SendDefSUNAmount_save
           , tmpMI.RemainsSUN                           ::TFloat    AS RemainsSUN

           , tmpMI.CountPrice                           ::TFloat    AS CountPrice
           , COALESCE (tmpOneJuridical.isOneJuridical, TRUE) :: Boolean AS isOneJuridical

           , CASE WHEN COALESCE (GoodsPromo.GoodsId ,0) = 0    THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
           , CASE WHEN COALESCE (GoodsPromoAll.GoodsId, 0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromoAll
           , COALESCE(GoodsPromo.OperDatePromo, NULL)  :: TDateTime   AS OperDatePromo
           , COALESCE(GoodsPromo.InvNumberPromo, '')   ::  TVarChar   AS InvNumberPromo -- ***

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN FALSE ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN FALSE ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz    ::TVarChar AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka ::TVarChar AS OperDate_Dostavka

           , tmpMI.ConditionsKeepName

           , CASE
                  --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- ���� ���� - ������� ������� 2 ��� �����;
                  --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- ���� ���� - ������� ������� 10 ������� ��� �������� � ������ ����������;
                   -- ���������� �� ����  ������ - ���������- ���� ����������, ������-������� - ����������
                  WHEN tmpMI.isClose = TRUE THEN zfCalc_Color (250, 128, 114)  
                  WHEN tmpMI.isSP = TRUE AND MIFloat_Price.ValueData > tmpMI.PriceOptSP THEN zfCalc_Color (188, 143, 143)  
                  WHEN COALESCE (tmpMI.JuridicalId, 0) <> 0 AND COALESCE (tmpMI.DiscountName, '') <> '' AND COALESCE (tmpGoodsDiscountJuridical.GoodsMainId, 0) = 0 THEN zfCalc_Color (0, 255, 255) -- orange
                  WHEN tmpMI.JuridicalName ILIKE '%�+%' AND tmpMI.JuridicalId = 410822
                    OR (tmpMI.JuridicalName ILIKE '%ANC%' OR tmpMI.JuridicalName ILIKE '%PL/%') AND tmpMI.JuridicalId = 59612
                    OR tmpMI.JuridicalName ILIKE '%����%' OR tmpMI.JuridicalName ILIKE '%��²%'
                    OR tmpMI.JuridicalName ILIKE '%���%' THEN zfCalc_Color (147, 112, 219)    --������� ���������� ������
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) > 0.10 THEN 12319924    --������ - ���������- ���� ����������
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  ----������ ������� -- ������-������� - ����������
                  WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- ������ ������
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color

           , AVGIncome.AVGIncomePrice    AS AVGPrice
/*           , CASE WHEN (ABS(AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) > 0.10
                     THEN TRUE
                  ELSE FALSE
             END AS AVGPriceWarning   */
           , CASE WHEN (AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0) > 0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) * 100
                  WHEN (AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0) < -0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) * 100
                  WHEN COALESCE (AVGIncome.AVGIncomePrice, 0) = 0 THEN 0.1--5000
                  ELSE 0
             END ::TFloat                AS AVGPriceWarning

           /*
           , CASE WHEN COALESCE (tmpOrderLast_2days.Amount, 0) > 1 THEN 16777134   -- ���� ���� - ������� ������� 2 ��� �����;
                  WHEN COALESCE (tmpOrderLast_10.Amount, 0) > 9 THEN 167472630     -- ���� ���� - ������� ������� 10 ������� ��� �������� � ������ ����������;
                  ELSE  zc_Color_White()
             END  AS Fond_Color

           , CASE WHEN COALESCE (tmpOrderLast_2days.Amount, 0) > 1 THEN TRUE ELSE FALSE END  AS isLast_2days
           , COALESCE (tmpRepeat.isRepeat, FALSE) AS isRepeat
           */

           -- , tmpJuridicalArea.AreaId                                      AS AreaId
           -- , COALESCE (tmpJuridicalArea.AreaName, '')      :: TVarChar    AS AreaName

           -- , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods

           , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean        AS isDefault

           , tmpMI.DiscountName
           , tmpMI.DiscountJuridical

           , tmpMI.AmountSUA                                                 AS AmountSUA
           , tmpFinalSUAList.FinalSUA::TFloat                                AS FinalSUA
           , tmpFinalSUAList.FinalSUASend::TFloat                            AS FinalSUASend

           , tmpLayoutAll.Amount::TFloat                                     AS Layout

           , COALESCE (SupplierFailures.GoodsId, 0) <> 0                     AS isSupplierFailures
           , CASE
                  WHEN COALESCE (SupplierFailures.GoodsId, 0) <> 0 THEN zfCalc_Color (255, 165, 0) -- orange
                  ELSE CASE
                            --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- ���� ���� - ������� ������� 2 ��� �����;
                            --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- ���� ���� - ������� ������� 10 ������� ��� �������� � ������ ����������;
                             -- ���������� �� ����  ������ - ���������- ���� ����������, ������-������� - ����������
                            WHEN tmpMI.JuridicalName ILIKE '%�+%' AND tmpMI.JuridicalId = 410822
                              OR (tmpMI.JuridicalName ILIKE '%ANC%' OR tmpMI.JuridicalName ILIKE '%PL/%') AND tmpMI.JuridicalId = 59612
                              OR tmpMI.JuridicalName ILIKE '%����%' OR tmpMI.JuridicalName ILIKE '%��²%'
                              OR tmpMI.GoodsName ILIKE '%���%'  THEN zfCalc_Color (147, 112, 219)     --������� ���������� ������
                            WHEN ((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) > 0.10 THEN 12319924    --������ - ���������- ���� ����������
                            WHEN ((AVGIncome.AVGIncomePrice - COALESCE (MIFloat_Price.ValueData,0)) / NULLIF(MIFloat_Price.ValueData,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  ----������ ������� -- ������-������� - ����������
                            WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- ������ ������
                            ELSE zc_Color_White()
                       END
              END  AS SupplierFailuresColor

           , COALESCE (tmpGoodsSPRegistry_1303.GoodsId, 0) <> 0                                                  AS isSPRegistry_1303
           , Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2)::TFloat                                          AS PriceOOC1303
           , CASE WHEN Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2) > 0 AND COALESCE (MIFloat_Price.ValueData,0) > 0
             THEN ((1.0 - COALESCE (MIFloat_Price.ValueData,0) / Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2)) * 100)
             ELSE 0 END::TFloat AS DPriceOOC1303

       FROM tmpMI        --_tmpOrderInternal_MI AS
            LEFT JOIN tmpOneJuridical ON tmpOneJuridical.MIMasterId = tmpMI.MovementItemId

            LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = tmpMI.PartnerGoodsId
            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId = tmpMI.GoodsId
            LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                   ON ObjectString_Goods_Code.ObjectId = Object_PartnerGoods.Id
                                  AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()

            LEFT JOIN MovementItemString AS MIString_GoodsCode
                                         ON MIString_GoodsCode.MovementItemId = tmpMI.MovementItemId
                                        AND MIString_GoodsCode.DescId = zc_MIString_GoodsCode()
            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = tmpMI.MovementItemId
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()

            -- ���������� �� �������� �� �������. ���. �� ����� �������������
            LEFT JOIN (SELECT DISTINCT GoodsPromo.GoodsId FROM GoodsPromo) AS GoodsPromoAll ON GoodsPromoAll.GoodsId = tmpMI.GoodsId

            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpMI.RetailId

            LEFT JOIN OrderSheduleList ON OrderSheduleList.ContractId = tmpMI.ContractId
            LEFT JOIN OrderSheduleListToday ON OrderSheduleListToday.ContractId = tmpMI.ContractId

            LEFT JOIN tmpMIBoolean_Calculated AS MIBoolean_Calculated ON MIBoolean_Calculated.MovementItemId = tmpMI.MovementItemId

            LEFT JOIN tmpMIF_Price          AS MIFloat_Price          ON MIFloat_Price.MovementItemId          = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_JuridicalPrice AS MIFloat_JuridicalPrice ON MIFloat_JuridicalPrice.MovementItemId = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_DefermentPrice AS MIFloat_DefermentPrice ON MIFloat_DefermentPrice.MovementItemId = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_Summ           AS MIFloat_Summ           ON MIFloat_Summ.MovementItemId           = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_AmountSecond   AS MIFloat_AmountSecond   ON MIFloat_AmountSecond.MovementItemId   = tmpMI.MovementItemId
            LEFT JOIN tmpMIF_AmountManual   AS MIFloat_AmountManual   ON MIFloat_AmountManual.MovementItemId   = tmpMI.MovementItemId

            LEFT JOIN tmpMIString_Comment AS MIString_Comment ON MIString_Comment.MovementItemId = tmpMI.MovementItemId

            --LEFT JOIN tmpOrderLast_2days ON tmpOrderLast_2days.GoodsId   = tmpMI.GoodsId
            --LEFT JOIN tmpOrderLast_10    ON tmpOrderLast_10.GoodsId      = tmpMI.GoodsId
            --LEFT JOIN tmpRepeat          ON tmpRepeat.GoodsId            = tmpMI.GoodsId

            LEFT JOIN tmpJuridicalArea   ON tmpJuridicalArea.JuridicalId = tmpMI.JuridicalId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

            LEFT JOIN AVGIncome ON AVGIncome.ObjectId = tmpMI.GoodsId
            LEFT JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpLoadPriceList_NDS ON tmpLoadPriceList_NDS.PartnerGoodsId = tmpMI.PartnerGoodsId
                                          AND tmpLoadPriceList_NDS.JuridicalId = tmpMI.JuridicalId

            LEFT JOIN tmpSendSun ON tmpSendSun.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpFinalSUAList ON tmpFinalSUAList.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpLayoutAll ON tmpLayoutAll.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpSupplierFailures AS SupplierFailures
                                          ON SupplierFailures.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpGoodsSPRegistry_1303 ON tmpGoodsSPRegistry_1303.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpGoodsDiscountJuridical ON tmpGoodsDiscountJuridical.GoodsMainId = tmpMI.GoodsMainId
                                               AND tmpGoodsDiscountJuridical.JuridicalId = tmpMI.JuridicalId
           ;


    -- !!!������ ��� ������ ���������� + inShowAll = FALSE - 2-�� ����� (����� = 3)!!!
    ELSEIF inShowAll = FALSE
    THEN


      raise notice 'Value: %', 2;

--    PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     -- ������
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMI'))
     THEN
       DROP TABLE IF EXISTS _tmpMI;
     END IF;

--raise notice 'Value 3: %', CLOCK_TIMESTAMP();

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


      -- ���������� ������
      INSERT INTO _tmpMI

           WITH -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����) !!!������ ���� ������������ ObjectId!!!
                MovementItemOrder AS (SELECT MovementItem.*
                                           , ObjectLink_Main.ChildObjectId AS GoodsMainId, ObjectLink_LinkGoods_Goods.ChildObjectId AS GoodsId
                                      FROM MovementItem
                                       --  INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.ObjectId -- ����� ������ ���� � �����
                                       -- �������� GoodsMainId
                                           INNER JOIN  ObjectLink AS ObjectLink_Child
                                                                  ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                         --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- ����� ������ � ������ � ������� �������
                                         --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                           -- ������ ���� �� �������� GoodsMainId
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
                -- ������������� ��������
              , tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- ����� ����� "����"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUnitId  := vbUnitId
                                                                                       , inUserId  := vbUserId) AS tmp
                                      )

              , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceList.JuridicalId
                                          , LoadPriceList.ContractId
                                          , LoadPriceList.AreaId
                                     FROM LoadPriceList
                                     )

      -- ������ �� % ��������� ������� �� �����������
      , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)

      -- ���. ���������� ��� ������ ����������
      , tmpJuridicalPriorities AS (SELECT tmp.JuridicalId
                                        , tmp.GoodsId AS GoodsMainId  --������� �����
                                        , tmp.Priorities
                                   FROM gpSelect_Object_JuridicalPriorities (inSession) AS tmp
                                   WHERE tmp.isErased = FALSE
                                     AND COALESCE (tmp.Priorities,0) <> 0
                                   )
      , tmpMovementItemLastPriceList_View AS (SELECT LastMovement.MovementId
                                                   , LastMovement.JuridicalId
                                                   , LastMovement.ContractId
                                                   , MovementItem.Id                    AS MovementItemId
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
                                                  INNER JOIN MovementItemLinkObject AS MILinkObject_Goods -- ������ � �����-�����
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
                                                  LEFT JOIN tmpSupplierFailures AS SupplierFailures
                                                                                ON SupplierFailures.GoodsId = MILinkObject_Goods.ObjectId
                                                                               AND SupplierFailures.JuridicalId = LastMovement.JuridicalId
                                                                               AND SupplierFailures.ContractId = LastMovement.ContractId
                                              WHERE COALESCE (SupplierFailures.GoodsId, 0) = 0
                                              )

       -- ���������
       SELECT row_number() OVER ()
            , DD.MovementItemId
            , DD.PriceListMovementItemId
            , DD.Price
            , DD.PartionGoodsDate
            , DD.GoodsId
            , DD.GoodsCode
            , DD.GoodsName
            , DD.MainGoodsName
            , DD.JuridicalId
            , DD.JuridicalName
            , DD.MakerName
            , DD.ContractId
            , DD.ContractName
            , DD.AreaId
            , DD.AreaName
            , DD.isDefault
            , DD.Deferment
            , DD.Bonus
            , DD.Percent         :: TFloat
            , DD.SuperFinalPrice :: TFloat

            -- �� ���� ���� ���������� ����� �������� ���������
            -- � 09,09,2020 ����� ��� ��������� JuridicalPriorities   -- % ���������� "-" ��������� ��������� "+" �����������, �.� ���� + ����� ��������� ����
            , (DD.SuperFinalPrice_Deferment * ( (-1) * COALESCE (tmpJuridicalPriorities.Priorities,0) / 100 + 1)) :: TFloat AS SuperFinalPrice_Deferment
       FROM (
            SELECT ddd.Id AS MovementItemId
                 , ddd.PriceListMovementItemId
                 , ddd.Price
                 , ddd.PartionGoodsDate
                 , ddd.GoodsId
                 , ddd.GoodsCode
                 , ddd.GoodsMainId
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

                 -- �� ���� ���� ���������� ����� �������� ���������
                 -- � 09,09,2020 ����� ��� ��������� JuridicalPriorities
                 , (ddd.FinalPrice - ddd.FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit) ) / 100) :: TFloat AS SuperFinalPrice_Deferment
     /**/
            FROM
                  (SELECT DISTINCT MovementItemOrder.Id
                       , MovementItemLastPriceList_View.Price AS Price
                       , MovementItemLastPriceList_View.MovementItemId AS PriceListMovementItemId
                       , MovementItemLastPriceList_View.PartionGoodsDate
                       , MIN (MovementItemLastPriceList_View.Price) OVER (PARTITION BY MovementItemOrder.Id ORDER BY MovementItemLastPriceList_View.PartionGoodsDate DESC) AS MinPrice
                       , CASE
                           -- -- ���� ���� ���������� �� �������� � ������� ���������� (�� ����� ���� ��������� ����� ��� ������� �����. ����)
                           WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                                THEN MovementItemLastPriceList_View.Price
                                    -- � ����������� % ������ �� ������������� ��������
                                  * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                           ELSE -- ����� ����������� ����� - ��� ���-������� ��� �� ���-�������
                                (MovementItemLastPriceList_View.Price * (100 - COALESCE(tmpJuridicalSettingsItem.Bonus, 0)) / 100) :: TFloat
                                 -- � ����������� % ������ �� ������������� ��������
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
                       , MovementItemOrder.GoodsMainId             AS GoodsMainId
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

                         -- ����� "����������", ���� �� ���� � ������� !!!� �� ����!!!
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

                         --   LEFT JOIN Object_Goods_View AS Goods  -- ������� ��������� ������
                         --     ON Goods.Id = MovementItemOrder.ObjectId

                         -- % ������ �� ������������� ��������
                         LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                             AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId


                    WHERE  COALESCE(JuridicalSettings.isPriceCloseOrder, FALSE) <> TRUE                                        --
            ) AS ddd

            LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
            LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
            LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit
            ) AS DD

            LEFT JOIN tmpJuridicalPriorities ON tmpJuridicalPriorities.GoodsMainId = DD.GoodsMainId
                                            AND tmpJuridicalPriorities.JuridicalId = DD.JuridicalId

  ;

     ANALYSE _tmpMI;

--raise notice 'Value 4: %', CLOCK_TIMESTAMP();

-- lpCreateTempTable_OrderInternal ����� ���������
----      raise notice 'Value: %', 21;

   --RAISE EXCEPTION '������.';
     RETURN QUERY
     WITH
     --������ ����������� ������ ������/��������
        tmpDateList AS (SELECT ''||tmpDayOfWeek.DayOfWeekName|| '-' || DATE_PART ('day', tmp.OperDate :: Date) ||'' AS OperDate
                             --''||tmp.OperDate :: Date || ' (' ||tmpDayOfWeek.DayOfWeekName ||')' AS OperDate
                             , tmpDayOfWeek.Number
                             , tmpDayOfWeek.DayOfWeekName
                        FROM (SELECT generate_series ( CURRENT_DATE,  CURRENT_DATE+interval '6 day', '1 day' :: INTERVAL) AS OperDate) AS tmp
                             LEFT JOIN zfCalc_DayOfWeekName(tmp.OperDate) AS tmpDayOfWeek ON 1=1
                        )
      , tmpOrderShedule AS (SELECT ObjectLink_OrderShedule_Contract.ChildObjectId          AS ContractId --
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1)) ::TFloat AS Value1
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2)) ::TFloat AS Value2
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3)) ::TFloat AS Value3
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4)) ::TFloat AS Value4
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5)) ::TFloat AS Value5
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6)) ::TFloat AS Value6
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7)) ::TFloat AS Value7
                                 , Object_OrderShedule.ValueData AS Value8
                            FROM Object AS Object_OrderShedule
                                 INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                                       ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                                                      AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                                                      AND ObjectLink_OrderShedule_Unit.ChildObjectId = vbUnitId
                                 LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                                      ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                                                     AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                            WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                              AND Object_OrderShedule.isErased = FALSE
                           )
      , tmpOrderSheduleList AS (SELECT tmp.*
                                FROM (
                                      select tmpOrderShedule.ContractId, CASE WHEN Value1 in (1,3) THEN 1 ELSE 0 END AS DoW, CASE WHEN Value1 in (2,3) THEN 1 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value2 in (1,3) THEN 2 ELSE 0 END AS DoW, CASE WHEN Value2 in (2,3) THEN 2 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value3 in (1,3) THEN 3 ELSE 0 END AS DoW, CASE WHEN Value3 in (2,3) THEN 3 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value4 in (1,3) THEN 4 ELSE 0 END AS DoW, CASE WHEN Value4 in (2,3) THEN 4 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value5 in (1,3) THEN 5 ELSE 0 END AS DoW, CASE WHEN Value5 in (2,3) THEN 5 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value6 in (1,3) THEN 6 ELSE 0 END AS DoW, CASE WHEN Value6 in (2,3) THEN 6 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value7 in (1,3) THEN 7 ELSE 0 END AS DoW, CASE WHEN Value7 in (2,3) THEN 7 ELSE 0 END AS DoW_D from tmpOrderShedule) AS tmp
                                WHERE tmp.DoW <> 0 OR tmp.DoW_D <> 0
                                )
      , tmpAfter AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                     FROM (
                           SELECT tmpOrderSheduleList.ContractId, min (DoW) AS DoW, 0 AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW > vbCURRENT_DOW
                             AND tmpOrderSheduleList.DoW > 0
                           GROUP BY tmpOrderSheduleList.ContractId
                           Union
                           SELECT tmpOrderSheduleList.ContractId, 0 AS DoW, min (DoW_D) AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW_D > vbCURRENT_DOW
                             AND tmpOrderSheduleList.DoW_D > 0
                           GROUP BY tmpOrderSheduleList.ContractId) as tmp
                     GROUP BY tmp.ContractId
                     )
      , tmpBefore AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                      FROM (
                           SELECT tmpOrderSheduleList.ContractId,  min (tmpOrderSheduleList.DoW) AS DoW, 0 AS DoW_D
                           FROM tmpOrderSheduleList
                                LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                           WHERE tmpOrderSheduleList.DoW < vbCURRENT_DOW
                             AND tmpAfter.ContractId IS NULL
                             AND tmpOrderSheduleList.DoW<>0
                           GROUP BY tmpOrderSheduleList.ContractId
                       UNION
                           SELECT tmpOrderSheduleList.ContractId, 0 AS DoW,  min (tmpOrderSheduleList.DoW_D) AS DoW_D
                           FROM tmpOrderSheduleList
                                LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                           WHERE tmpOrderSheduleList.DoW_D < vbCURRENT_DOW
                             AND tmpAfter.ContractId IS NULL
                             AND tmpOrderSheduleList.DoW_D<>0
                           GROUP BY tmpOrderSheduleList.ContractId
                           ) AS tmp
                      GROUP BY tmp.ContractId
                      )
      , OrderSheduleList AS ( SELECT tmp.ContractId
                                   , tmpDateList.OperDate         AS OperDate_Zakaz
                                   , tmpDateList_D.OperDate       AS OperDate_Dostavka
                              FROM (SELECT *
                                    FROM tmpAfter
                                 union all
                                    SELECT *
                                    FROM tmpBefore
                                   ) AS tmp
                                 LEFT JOIN tmpDateList ON tmpDateList.Number = tmp.DoW
                                 LEFT JOIN tmpDateList AS tmpDateList_D ON tmpDateList_D.Number = tmp.DoW_D
                            )
      , OrderSheduleListToday AS (SELECT *
                                  FROM tmpOrderSheduleList
                                  WHERE tmpOrderSheduleList.DoW = vbCURRENT_DOW  OR tmpOrderSheduleList.DoW_D = vbCURRENT_DOW
                                 )

        -- ������������� ��������
      , GoodsPromo AS (WITH tmpPromo AS (SELECT * FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp) -- CURRENT_DATE
                          , tmpList AS (SELECT ObjectLink_Child.ChildObjectId        AS GoodsId
                                             , ObjectLink_Child_retail.ChildObjectId AS GoodsId_retail -- ����� ����� "����"
                                        FROM ObjectLink AS ObjectLink_Child
                                              INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                                       AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                              INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                             AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                              INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                              AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                    ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_Child_retail.ChildObjectId
                                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                        WHERE ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          -- AND vbObjectId <> 3
                                       )
                       SELECT tmp.JuridicalId
                            , COALESCE (tmpList.GoodsId_retail, tmp.GoodsId) AS GoodsId -- ����� ����� "����"
                            , tmp.MovementId
                            , tmp.ChangePercent
                            , MovementPromo.OperDate                AS OperDatePromo
                            , MovementPromo.InvNumber               AS InvNumberPromo -- ***
                       FROM tmpPromo AS tmp   --CURRENT_DATE
                            INNER JOIN tmpList ON tmpList.GoodsId = tmp.GoodsId
                            LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                      )

      -- ������ �� ������. �������
      , tmpGoodsCategory AS (SELECT ObjectLink_Child_retail.ChildObjectId AS GoodsId
                                  , ObjectFloat_Value.ValueData                  AS Value
                             FROM Object AS Object_GoodsCategory
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                       ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                                      AND ObjectLink_GoodsCategory_Unit.ChildObjectId = vbUnitId
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                       ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                 INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                        ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                       AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                 -- ������� �� ����� ����
                                 INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                       ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                      AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                 INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                       ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                      AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                 INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                       ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                      AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                      AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                             WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                               AND Object_GoodsCategory.isErased = FALSE
                             )


      , tmpMI_All AS (SELECT MovementItem.*
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                         )
        -- 2.1
      , tmpOF_Goods_MinimumLot AS (SELECT *
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND ObjectFloat.ValueData <> 0
                                     AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpMI_All.ObjectId FROM tmpMI_All)
                       )
      , tmpMI_Master AS (SELECT tmpMI.*
                              , CEIL(tmpMI.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1))
                                * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1)                       AS CalcAmount
                              , ObjectFloat_Goods_MinimumLot.ValueData                                       AS MinimumLot
                              , COALESCE (GoodsPrice.isTOP, FALSE)                                           AS Price_isTOP
                         FROM tmpMI_All AS tmpMI
                               LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpMI.ObjectId
                               LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                                                                ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI.ObjectId
                                                              -- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                         )

        -- 2.2
      , tmpOF_MinimumLot_Goods AS (SELECT *
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND ObjectFloat.ValueData <> 0
                                     AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpGoods_all.GoodsId_MinLot FROM tmpGoods_all)
                       )

      , tmpGoods AS (SELECT tmpGoods_all.GoodsId
                          , tmpGoods_all.GoodsCode
                          , tmpGoods_all.GoodsName
                          , tmpGoods_all.GoodsGroupId
                          , tmpGoods_all.NDSKindId
                          , tmpGoods_all.NDSKindName
                          , tmpGoods_all.NDS
                          , ObjectFloat_Goods_MinimumLot.ValueData AS Multiplicity
                          , tmpGoods_all.isClose
                          , tmpGoods_all.Goods_isTOP
                          , tmpGoods_all.Price_isTOP
                          , tmpGoods_all.isFirst
                          , tmpGoods_all.isSecond

                     FROM tmpGoods_all
                          LEFT JOIN tmpOF_MinimumLot_Goods AS ObjectFloat_Goods_MinimumLot
                                                           ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpGoods_all.GoodsId_MinLot
                                           --     AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                    )

      , tmpMIF AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                     INNER JOIN (SELECT tmpMI_Master.Id FROM tmpMI_Master) AS test ON test.ID = MovementItemFloat.MovementItemId
--                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Master.Id FROM tmpMI_Master)
                   )
      , tmpMIF_Summ AS (SELECT tmpMIF.*
                        FROM tmpMIF
                        WHERE tmpMIF.DescId = zc_MIFloat_Summ()
                        )
      , tmpMIF_AmountSecond AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountSecond()
                                )
      , tmpMIF_AmountManual AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountManual()
                                )
      , tmpMIF_ListDiff AS (SELECT tmpMIF.*
                            FROM tmpMIF
                            WHERE tmpMIF.DescId = zc_MIFloat_ListDiff()
                           )
      , tmpMIF_SupplierFailures AS (SELECT tmpMIF.*
                                    FROM tmpMIF
                                    WHERE tmpMIF.DescId = zc_MIFloat_SupplierFailures()
                                   )
      , tmpMIF_AmountSUA AS (SELECT tmpMIF.*
                            FROM tmpMIF
                            WHERE tmpMIF.DescId = zc_MIFloat_AmountSUA()
                           )
        , tmpMIF_AmountReal AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountReal()
                               )
        , tmpMIF_SendSUN AS (SELECT tmpMIF.*
                             FROM tmpMIF
                             WHERE tmpMIF.DescId = zc_MIFloat_SendSUN()
                            )
        , tmpMIF_SendDefSUN AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_SendDefSUN()
                               )
        , tmpMIF_RemainsSUN AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_RemainsSUN()
                               )
      , tmpMILinkObject AS (SELECT MILinkObject.*
                            FROM MovementItemLinkObject AS MILinkObject
--                              INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MILinkObject.MovementItemId
                            WHERE MILinkObject.DescId IN ( zc_MILinkObject_Juridical()
                                                         , zc_MILinkObject_Contract()
                                                         , zc_MILinkObject_Goods())
                              AND MILinkObject.MovementItemId in (SELECT tmpMI_Master.Id from tmpMI_Master)
                            )

      , tmpMIString_Comment AS (SELECT MIString_Comment.*
                                FROM MovementItemString AS MIString_Comment
--                                  INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MIString_Comment.MovementItemId
                                WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                  AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                )

      , tmpMIBoolean_Calculated AS (SELECT MIBoolean_Calculated.*
                                    FROM MovementItemBoolean AS MIBoolean_Calculated
--                                      INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MIBoolean_Calculated.MovementItemId
                                    WHERE MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                      AND MIBoolean_Calculated.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                   )


      , tmpMinPrice AS (SELECT DISTINCT DDD.MovementItemId
                             , DDD.GoodsId
                             , DDD.GoodsCode
                             , DDD.GoodsName
                             , DDD.JuridicalId
                             , DDD.JuridicalName
                             , DDD.ContractId
                             , DDD.ContractName
                             , DDD.MakerName
                             , DDD.PartionGoodsDate
                             , DDD.SuperFinalPrice
                             , DDD.SuperFinalPrice_Deferment
                             , DDD.Price
                             , DDD.MinId
                        FROM (SELECT *, MIN(DDD.Id) OVER (PARTITION BY DDD.MovementItemId) AS MinId
                              FROM (SELECT *
                                         -- , MIN (SuperFinalPrice) OVER (PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                         --, ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId ORDER BY _tmpMI.SuperFinalPrice_Deferment ASC, _tmpMI.PartionGoodsDate DESC, _tmpMI.Deferment DESC) AS Ord
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId ORDER BY (CASE WHEN _tmpMI.PartionGoodsDate < vbDate180 THEN _tmpMI.SuperFinalPrice_Deferment + 100 ELSE _tmpMI.SuperFinalPrice_Deferment END) ASC, _tmpMI.PartionGoodsDate DESC, _tmpMI.Deferment DESC) AS Ord
                                    FROM _tmpMI
                                   ) AS DDD
                              -- WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice
                              WHERE DDD.Ord = 1
                             ) AS DDD
                        WHERE DDD.Id = DDD.MinId
                       )
        -- ���� �� ������ ������ , ��������  ���������� ������ � ���� ����� ��������
      , tmpMI_PriceList AS (SELECT *
                            FROM (SELECT _tmpMI.*
                                       , ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId, _tmpMI.JuridicalId, _tmpMI.GoodsId, _tmpMI.ContractId ORDER BY _tmpMI.Price ASC, _tmpMI.PartionGoodsDate DESC) AS Ord
                                  FROM _tmpMI
                                 ) AS DDD
                            WHERE DDD.Ord = 1
                            )

, tmpMI_all_MinLot AS (SELECT MovementItem.Id
                            , MovementItem.ObjectId                                            AS GoodsId
                            , MovementItem.Amount                                              AS Amount
                            , MovementItem.CalcAmount
                            , MIFloat_Summ.ValueData                                           AS Summ
                            , MovementItem.MinimumLot                                          AS Multiplicity
                            , MIString_Comment.ValueData                                       AS Comment
                            , COALESCE(PriceList.MakerName, MinPrice.MakerName)                AS MakerName
                            , MIBoolean_Calculated.ValueData                                   AS isCalculated
                            -- , ObjectFloat_Goods_MinimumLot.valuedata                           AS MinimumLot
                            , COALESCE(PriceList.Price, MinPrice.Price)                        AS Price
                            , COALESCE(PriceList.PartionGoodsDate, MinPrice.PartionGoodsDate)  AS PartionGoodsDate
                            , COALESCE(PriceList.GoodsId, MinPrice.GoodsId)                    AS PartnerGoodsId
                            , COALESCE(PriceList.GoodsCode, MinPrice.GoodsCode)                AS PartnerGoodsCode
                            , COALESCE(PriceList.GoodsName, MinPrice.GoodsName)                AS PartnerGoodsName
                            , COALESCE(PriceList.JuridicalId, MinPrice.JuridicalId)            AS JuridicalId
                            , COALESCE(PriceList.JuridicalName, MinPrice.JuridicalName)        AS JuridicalName
                            , COALESCE(PriceList.ContractId, MinPrice.ContractId)              AS ContractId
                            , COALESCE(PriceList.ContractName, MinPrice.ContractName)          AS ContractName
                            , COALESCE(PriceList.SuperFinalPrice, MinPrice.SuperFinalPrice)    AS SuperFinalPrice
                            , COALESCE(PriceList.SuperFinalPrice_Deferment, MinPrice.SuperFinalPrice_Deferment) AS SuperFinalPrice_Deferment
                            --, MovementItem.Goods_isTOP
                            , MovementItem.Price_isTOP
                            , MIFloat_AmountSecond.ValueData                                   AS AmountSecond
                            , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS AmountAll
                              -- ��������� ����� AllLot
                            /*, CEIL ((-- ���������
                                     MovementItem.Amount
                                     -- ���������� ��������������
                                   + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                     -- ���-�� �������
                                   + COALESCE (MIFloat_ListDiff.ValueData, 0)
                                    ) / COALESCE (MovementItem.MinimumLot, 1)
                                   ) * COALESCE(MovementItem.MinimumLot, 1)                    AS CalcAmountAll
                             */
                            , CEIL (( CASE WHEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >=
                                                (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_SupplierFailures.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))
                                          THEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- ��������� + ���������� ��������������
                                          ELSE (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_SupplierFailures.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))     -- ���-�� ������� + ���
                                     END
                                     ) / COALESCE (MovementItem.MinimumLot, 1)
                                   ) * COALESCE(MovementItem.MinimumLot, 1)                    AS CalcAmountAll

                            , MIFloat_AmountManual.ValueData                                   AS AmountManual
                            , MIFloat_ListDiff.ValueData                                       AS ListDiffAmount
                            , MIFloat_SupplierFailures.ValueData                               AS SupplierFailuresAmount
                            , MIFloat_AmountSUA.ValueData                                      AS AmountSUA

                            , MIFloat_AmountReal.ValueData :: TFloat  AS AmountReal
                            , MIFloat_SendSUN.ValueData    :: TFloat  AS SendSUNAmount
                            , MIFloat_SendDefSUN.ValueData :: TFloat  AS SendDefSUNAmount
                            , MIFloat_RemainsSUN.ValueData :: TFloat  AS RemainsSUN

                            , MovementItem.isErased
                            , COALESCE (PriceList.GoodsId, MinPrice.GoodsId)                   AS GoodsId_MinLot
                       FROM tmpMI_Master AS MovementItem

                            LEFT JOIN tmpMILinkObject AS MILinkObject_Juridical
                                                      ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()

                            LEFT JOIN tmpMILinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                            LEFT JOIN tmpMILinkObject AS MILinkObject_Goods
                                                      ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

                            LEFT JOIN tmpMIBoolean_Calculated AS MIBoolean_Calculated ON MIBoolean_Calculated.MovementItemId = MovementItem.Id

                            LEFT JOIN tmpMIString_Comment AS MIString_Comment ON MIString_Comment.MovementItemId = MovementItem.Id

                            LEFT JOIN tmpMI_PriceList AS PriceList ON COALESCE (PriceList.ContractId, 0) = COALESCE (MILinkObject_Contract.ObjectId, 0)
                                                     AND PriceList.JuridicalId = MILinkObject_Juridical.ObjectId
                                                     AND PriceList.GoodsId = MILinkObject_Goods.ObjectId
                                                     AND PriceList.MovementItemId = MovementItem.Id

                            LEFT JOIN tmpMinPrice AS MinPrice ON MinPrice.MovementItemId = MovementItem.Id

                            -- LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                            --                                  ON ObjectFloat_Goods_MinimumLot.ObjectId = COALESCE (PriceList.GoodsId, MinPrice.GoodsId)
                                                 --- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()

                            LEFT JOIN tmpMIF_Summ             AS MIFloat_Summ              ON MIFloat_Summ.MovementItemId             = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountSecond     AS MIFloat_AmountSecond      ON MIFloat_AmountSecond.MovementItemId     = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountManual     AS MIFloat_AmountManual      ON MIFloat_AmountManual.MovementItemId     = MovementItem.Id
                            LEFT JOIN tmpMIF_ListDiff         AS MIFloat_ListDiff          ON MIFloat_ListDiff.MovementItemId         = MovementItem.Id
                            LEFT JOIN tmpMIF_SupplierFailures AS MIFloat_SupplierFailures  ON MIFloat_SupplierFailures.MovementItemId = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountSUA        AS MIFloat_AmountSUA         ON MIFloat_AmountSUA.MovementItemId        = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountReal       AS MIFloat_AmountReal        ON MIFloat_AmountReal.MovementItemId       = MovementItem.Id
                            LEFT JOIN tmpMIF_SendSUN          AS MIFloat_SendSUN           ON MIFloat_SendSUN.MovementItemId          = MovementItem.Id
                            LEFT JOIN tmpMIF_SendDefSUN       AS MIFloat_SendDefSUN        ON MIFloat_SendDefSUN.MovementItemId       = MovementItem.Id
                            LEFT JOIN tmpMIF_RemainsSUN       AS MIFloat_RemainsSUN        ON MIFloat_RemainsSUN.MovementItemId       = MovementItem.Id
     --LIMIT 2
                       )

        -- 2.3
      , tmpOF_MinimumLot_mi AS (SELECT *
                                FROM ObjectFloat
                                WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                  AND ObjectFloat.ValueData <> 0
                                  AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpMI_all_MinLot.GoodsId_MinLot FROM tmpMI_all_MinLot)
                                )

      , tmpMI AS (SELECT tmpMI_all_MinLot.Id
                       , tmpMI_all_MinLot.GoodsId
                       , tmpMI_all_MinLot.Amount
                       , tmpMI_all_MinLot.CalcAmount
                       , tmpMI_all_MinLot.Summ
                       , tmpMI_all_MinLot.Multiplicity
                       , tmpMI_all_MinLot.Comment
                       , tmpMI_all_MinLot.MakerName
                       , tmpMI_all_MinLot.isCalculated
                       , ObjectFloat_Goods_MinimumLot.ValueData AS MinimumLot
                       , tmpMI_all_MinLot.Price
                       , tmpMI_all_MinLot.PartionGoodsDate
                       , tmpMI_all_MinLot.PartnerGoodsId
                       , tmpMI_all_MinLot.PartnerGoodsCode
                       , tmpMI_all_MinLot.PartnerGoodsName
                       , tmpMI_all_MinLot.JuridicalId
                       , tmpMI_all_MinLot.JuridicalName
                       , tmpMI_all_MinLot.ContractId
                       , tmpMI_all_MinLot.ContractName
                       , tmpMI_all_MinLot.SuperFinalPrice
                       , tmpMI_all_MinLot.SuperFinalPrice_Deferment
                       , tmpMI_all_MinLot.Price_isTOP
                       , tmpMI_all_MinLot.AmountSecond
                       , tmpMI_all_MinLot.AmountAll
                       , tmpMI_all_MinLot.CalcAmountAll
                       , tmpMI_all_MinLot.AmountManual
                       , tmpMI_all_MinLot.ListDiffAmount
                       , tmpMI_all_MinLot.SupplierFailuresAmount
                       , tmpMI_all_MinLot.AmountSUA
                       , tmpMI_all_MinLot.AmountReal
                       , tmpMI_all_MinLot.SendSUNAmount
                       , tmpMI_all_MinLot.SendDefSUNAmount
                       , tmpMI_all_MinLot.RemainsSUN
                       , tmpMI_all_MinLot.isErased
                  FROM tmpMI_all_MinLot

                       LEFT JOIN tmpOF_MinimumLot_mi AS ObjectFloat_Goods_MinimumLot
                                                     ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI_all_MinLot.GoodsId_MinLot
                  )

      , tmpPriceView AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                              , MCS_Value.ValueData                     AS MCSValue
                              , Price_Goods.ChildObjectId               AS GoodsId
                              , COALESCE(MCS_isClose.ValueData,FALSE)   AS MCSIsClose
                              , COALESCE(MCS_NotRecalc.ValueData,FALSE) AS MCSNotRecalc
                              , COALESCE(Price_Top.ValueData,FALSE)     AS isTop
                         FROM ObjectLink AS ObjectLink_Price_Unit
                              LEFT JOIN ObjectLink AS Price_Goods
                                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                              LEFT JOIN tmpMI_Master ON tmpMI_Master.ObjectId = Price_Goods.ChildObjectId  -- goodsId
                              LEFT JOIN ObjectFloat AS MCS_Value
                                                    ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                              LEFT JOIN ObjectBoolean AS MCS_isClose
                                                      ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                              LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                      ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                              LEFT JOIN ObjectBoolean AS Price_Top
                                                      ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                         WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                           AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                           AND (inShowAll = TRUE OR tmpMI_Master.Id is not NULL)
                      )

      , tmpGoodsId AS (SELECT COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)           AS GoodsId
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                    GROUP BY COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
                   )

      , tmpData AS (SELECT tmpMI.Id                                                AS Id
                         , COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)              AS GoodsId
                         , tmpGoods.GoodsCode                                      AS GoodsCode
                         , tmpGoods.GoodsName                                      AS GoodsName
                         , tmpGoods.Goods_isTOP                                    AS isTOP
                         , tmpGoods.GoodsGroupId                                   AS GoodsGroupId
                         , tmpGoods.NDSKindId                                      AS NDSKindId
                         , tmpGoods.NDSKindName                                    AS NDSKindName
                         , tmpGoods.NDS                                            AS NDS
                         , tmpGoods.isClose                                        AS isClose
                         , tmpGoods.isFirst                                        AS isFirst
                         , tmpGoods.isSecond                                       AS isSecond
                         --
                         , COALESCE (tmpMI.Multiplicity, tmpGoods.Multiplicity)    AS Multiplicity
                         , tmpMI.CalcAmount                                        AS CalcAmount
                         , NULLIF(tmpMI.Amount,0)                                  AS Amount
                         , tmpMI.Price * tmpMI.CalcAmount                          AS Summ
                         , COALESCE (tmpMI.isErased, FALSE)                        AS isErased
                         , tmpMI.Price
                         , tmpMI.MinimumLot
                         , tmpMI.PartionGoodsDate
                         , tmpMI.Comment
                         , tmpMI.PartnerGoodsId
                         , tmpMI.PartnerGoodsCode
                         , tmpMI.PartnerGoodsName
                         , tmpMI.JuridicalId
                         , tmpMI.JuridicalName                                     -- ***
                         , tmpMI.ContractId
                         , tmpMI.ContractName
                         , tmpMI.MakerName
                         , tmpMI.SuperFinalPrice
                         , tmpMI.SuperFinalPrice_Deferment
                         , COALESCE (tmpMI.isCalculated, FALSE)                             AS isCalculated
                         , tmpMI.AmountSecond                                               AS AmountSecond
                         , NULLIF (tmpMI.AmountAll, 0)                                      AS AmountAll
                         , NULLIF (COALESCE (tmpMI.AmountManual, tmpMI.CalcAmountAll), 0)   AS CalcAmountAll
                         , tmpMI.Price * COALESCE (tmpMI.AmountManual, tmpMI.CalcAmountAll) AS SummAll
                         , tmpMI.ListDiffAmount
                         , tmpMI.SupplierFailuresAmount
                         , tmpMI.AmountSUA
                         , tmpMI.AmountReal
                         , tmpMI.SendSUNAmount
                         , tmpMI.SendDefSUNAmount
                         , tmpMI.RemainsSUN
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                   )
      -- ������� �������
      , tmpRemains AS (SELECT Container.ObjectId
                            , SUM (Container.Amount) AS Amount
                       FROM Container

                            INNER JOIN tmpGoodsId AS tmp
                                                  ON tmp.GoodsId = Container.ObjectId
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount <> 0
                         AND Container.WhereObjectId = vbUnitId
--                         AND Container.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                       GROUP BY Container.ObjectId
                      )
      -- ������
      , tmpIncome AS (SELECT MovementItem_Income.ObjectId               AS Income_GoodsId
                           , SUM (MovementItem_Income.Amount) :: TFloat AS Income_Amount
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementItem AS MovementItem_Income
                                                   ON Movement_Income.Id = MovementItem_Income.MovementId
                                                  AND MovementItem_Income.DescId = zc_MI_Master()
                                                  AND MovementItem_Income.isErased = FALSE
                                                  AND MovementItem_Income.Amount > 0
--                                                  AND MovementItem_Income.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                           INNER JOIN tmpGoodsId AS tmp
                                                 ON tmp.GoodsId = MovementItem_Income.ObjectId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND MovementLinkObject_To.ObjectId = vbUnitId
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '31 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MovementItem_Income.ObjectId
                     )

        -- ������ ���-������ (��������)
      , tmpGoodsSP AS (SELECT tmp.GoodsId
                            , TRUE AS isSP
                            , MIN(MIFloat_PriceOptSP.ValueData) AS PriceOptSP
                       FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbOperDate, inEndDate:= vbOperDate, inUnitId := vbUnitId) AS tmp
                                                LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                     ON MIFloat_PriceOptSP.MovementItemId = tmp.MovementItemId
                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                       GROUP BY tmp.GoodsId
                       )

      -- ���������� ��������� �������������
      , tmpDiscountJuridicalAll AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                         , ObjectLink_Juridical.ChildObjectId            AS JuridicalId
                                         , CASE WHEN ObjectLink_Juridical.ChildObjectId = 59611
                                                THEN '������'
                                                ELSE Object_Juridical.ValueData END      AS JuridicalName
                                    FROM Object AS Object_DiscountExternalSupplier
                                         LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                              ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                                             AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()

                                          LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                               ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                                              AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()
                                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

                                     WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier()
                                       AND Object_DiscountExternalSupplier.isErased = FALSE)
      , tmpDiscountJuridical AS (SELECT tmpDiscountJuridicalAll.DiscountExternalId                   AS DiscountExternalId
                                      , STRING_AGG(tmpDiscountJuridicalAll.JuridicalName, ', ')      AS JuridicalName
                                 FROM tmpDiscountJuridicalAll
                                 GROUP BY tmpDiscountJuridicalAll.DiscountExternalId)
      -- ���������� ��������� �������������
      , tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                 , tmpDiscountJuridical.JuridicalName::TVarChar  AS JuridicalName
                            FROM Object AS Object_DiscountExternalTools
                                  LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                       ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                      AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                  LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                       ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                  LEFT JOIN tmpDiscountJuridical ON tmpDiscountJuridical.DiscountExternalId = ObjectLink_DiscountExternal.ChildObjectId
                             WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                               AND ObjectLink_Unit.ChildObjectId = vbUnitId
                               AND Object_DiscountExternalTools.isErased = False
                             )
      -- ������ ���������� ���������
      , tmpGoodsDiscount AS (SELECT
                                   Object_Goods_Retail.GoodsMainId

                                 , Object_Object.Id                AS ObjectId
                                 , Object_Object.ValueData         AS DiscountName
                                 , tmpUnitDiscount.JuridicalName   AS DiscountJuridical
                                 , tmpUnitDiscount.DiscountExternalId

                             FROM Object AS Object_BarCode
                                 LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                      ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                 LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = ObjectLink_BarCode_Goods.ChildObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                      ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                 LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId

                             WHERE Object_BarCode.DescId = zc_Object_BarCode()
                               AND Object_BarCode.isErased = False
                               AND Object_Object.isErased = False
                               AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
                      )
      , tmpGoodsDiscountJuridical AS (SELECT DISTINCT
                                             tmpGoodsDiscount.GoodsMainId
                                           , tmpDiscountJuridicalAll.JuridicalId

                                       FROM tmpGoodsDiscount

                                           INNER JOIN tmpDiscountJuridicalAll ON tmpDiscountJuridicalAll.DiscountExternalId = tmpGoodsDiscount.DiscountExternalId
                                      )
      , tmpGoodsMain AS (SELECT tmpMI.GoodsId                                                           AS GoodsId
                              , COALESCE (tmpGoodsSP.isSP, False)                             ::Boolean AS isSP
                              , COALESCE (ObjectBoolean_Resolution_224.ValueData, False)      ::Boolean AS isResolution_224
                              , CAST ( (COALESCE (tmpGoodsSP.PriceOptSP,0) * 1.1) AS NUMERIC (16,2)) :: TFloat   AS PriceOptSP
                              , CASE WHEN DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData) = vbOperDate THEN TRUE ELSE FALSE END  AS isMarketToday
                              , DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData)          ::TDateTime AS LastPriceDate
                              , COALESCE (ObjectFloat_CountPrice.ValueData,0)               ::TFloat    AS CountPrice
                              , tmpGoodsDiscount.DiscountName
                              , tmpGoodsDiscount.DiscountJuridical
                              , ObjectLink_Main.ChildObjectId                                           AS GoodsMainId
                         FROM tmpGoodsId AS tmpMI
                                -- �������� GoodsMainId
                                LEFT JOIN ObjectLink AS ObjectLink_Child
                                                     ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_Main
                                                     ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                LEFT JOIN ObjectFloat AS ObjectFloat_CountPrice
                                                     ON ObjectFloat_CountPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()

                                LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                     ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()

                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                        ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                       AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

                                LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId

                                LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = ObjectLink_Main.ChildObjectId
                         )

      -- ������� ��������
      , tmpGoodsConditionsKeepList AS (SELECT ObjectLink_Goods_ConditionsKeep.ObjectId              AS GoodsId
                                            , ObjectLink_Goods_ConditionsKeep.ChildObjectId         AS ChildObjectId
                                   FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                        INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = ObjectLink_Goods_ConditionsKeep.ObjectId
                                   WHERE ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
--                                     AND ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                                  )

      , tmpGoodsConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.GoodsId                   AS GoodsId
                                        , Object_ConditionsKeep.ValueData                           AS ConditionsKeepName
                                   FROM tmpGoodsConditionsKeepList AS ObjectLink_Goods_ConditionsKeep
--                                        INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = ObjectLink_Goods_ConditionsKeep.GoodsId
                                        INNER JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
--                                     AND ObjectLink_Goods_ConditionsKeep.GoodsId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                                  )

--
      , tmpCheck AS (SELECT MI_Check.ObjectId                       AS GoodsId
                          , -1 * SUM (MIContainer.Amount) ::TFloat  AS Amount
                     FROM Movement AS Movement_Check
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN MovementItem AS MI_Check
                                                    ON MI_Check.MovementId = Movement_Check.Id
                                                   AND MI_Check.DescId = zc_MI_Master()
                                                   AND MI_Check.isErased = FALSE
                            LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.MovementItemId = MI_Check.Id
                                                                 AND MIContainer.DescId = zc_MIContainer_Count()
                      WHERE Movement_Check.OperDate >= vbOperDate
                        AND Movement_Check.OperDate < vbOperDateEnd
                       AND Movement_Check.DescId = zc_Movement_Check()
                       AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                     GROUP BY MI_Check.ObjectId
                     HAVING SUM (MI_Check.Amount) <> 0
                     )

       -- ��������������� ������
      , tmpSend AS ( SELECT MI_Send.ObjectId                AS GoodsId
                          , SUM (MI_Send.Amount) ::TFloat   AS Amount
                     FROM Movement AS Movement_Send
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Send.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                      ON MovementBoolean_Deferred.MovementId = Movement_Send.Id
                                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                            -- ����������� - ����� ����� ��� �����������, �� ������ ����
                            /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                       ON MovementBoolean_isAuto.MovementId = Movement_Send.Id
                                                      AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                      AND MovementBoolean_isAuto.ValueData  = TRUE*/
                            INNER JOIN MovementItem AS MI_Send
                                                    ON MI_Send.MovementId = Movement_Send.Id
                                                   AND MI_Send.DescId = zc_MI_Master()
                                                   AND MI_Send.isErased = FALSE
--                                                   AND MI_Send.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                            INNER JOIN tmpGoodsId AS tmp
                                                  ON tmp.GoodsId = MI_Send.ObjectId
                     -- WHERE Movement_Send.OperDate >= vbOperDate - interval '30 DAY'
                     WHERE Movement_Send.OperDate BETWEEN CURRENT_DATE - INTERVAL '91 DAY' AND CURRENT_DATE + INTERVAL '30 DAY'  -- 27.01.2020  - 91 ����, �� ����� ���� 31 - �� ������� ���� �������
                       AND Movement_Send.OperDate < vbOperDateEnd
                       AND Movement_Send.DescId = zc_Movement_Send()
                       AND Movement_Send.StatusId = zc_Enum_Status_UnComplete()
                       --AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                     GROUP BY MI_Send.ObjectId
                     HAVING SUM (MI_Send.Amount) <> 0
                    )

      -- �� ������� ����� 0 � ��� ���� � ������ ��������� � ������������� - �� �� � ������� ��� ������� � ��� ����� �������� ������ � ������� �����.
      -- ����� ������� ����� ���������� ������ ������ - �������, ������� � �������, �������, ���������� - ���������� �� ����� �������� ���� �����.
      -- �������� ������
      , tmpGoodsList AS (SELECT tmpMI.GoodsId                      AS GoodsId
                              , COALESCE (tmpMI.Amount, 0)         AS Amount
                              , COALESCE (Remains.Amount, 0)       AS RemainsAmount
                              , COALESCE (Income.Income_Amount, 0) AS IncomeAmount
                         FROM tmpMI
                              LEFT JOIN tmpRemains AS Remains ON Remains.ObjectId      = tmpMI.GoodsId
                              LEFT JOIN tmpIncome  AS Income  ON Income.Income_GoodsId = tmpMI.GoodsId
                         WHERE COALESCE (tmpMI.Amount, 0) > 0
                        )
/*
      , tmpLastOrder AS (SELECT Movement.Id
                              , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.Operdate DESC) AS Ord
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MLO_Unit
                                                            ON MLO_Unit.MovementId = Movement.Id
                                                           AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                           AND MLO_Unit.ObjectId   = vbUnitId
                         WHERE Movement.DescId = zc_Movement_OrderInternal()
                           AND Movement.Operdate >= vbOperDate - INTERVAL '30 DAY' AND Movement.Operdate < vbOperDate
                           AND 1=0
                         )
      -- ������ ����� / ���������
      , tmpOrderLast_2days AS (SELECT tmpGoodsList.GoodsId
                                    , COUNT (DISTINCT Movement.Id) AS Amount
                               FROM tmpLastOrder AS Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN tmpGoodsList ON tmpGoodsList.GoodsId = MovementItem.ObjectId
                                                           AND tmpGoodsList.RemainsAmount = 0                  -- ������� = 0
                                                           AND tmpGoodsList.IncomeAmount = 0                    -- ������ ������� = 0
                               WHERE Movement.Ord IN (1, 2)
                               GROUP BY tmpGoodsList.GoodsId
                               )
      -- ��������� �����  --�������, ������� ��� �������� � ������� ���������� �����, �� �� ������ �� ����� � ����� ����� � ��������� ���������� � ��� �� ���-�� ��� ������
      , tmpRepeat AS (SELECT tmpGoods.GoodsId
                          ,  CASE WHEN tmpGoods.Amount >= COALESCE (MovementItem.Amount, 0) THEN TRUE ELSE FALSE END isRepeat
                      FROM tmpLastOrder AS Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN (SELECT tmpGoodsList.GoodsId, tmpGoodsList.Amount
                                       FROM tmpGoodsList
                                       WHERE COALESCE (tmpGoodsList.IncomeAmount, 0) = 0
                                         AND COALESCE (tmpGoodsList.Amount, 0) > 0
                                       ) AS tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                      WHERE Movement.Ord = 1
                     )
      , tmpOrderLast_10 AS (SELECT tmpGoodsNotLink.GoodsId
                                 , COUNT (DISTINCT Movement.Id) AS Amount
                            FROM tmpLastOrder AS Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 INNER JOIN tmpGoodsNotLink ON tmpGoodsNotLink.GoodsId = MovementItem.ObjectId
                            WHERE Movement.Ord <= 10
                            GROUP BY tmpGoodsNotLink.GoodsId
                            )
*/

      -- ��� �������� �� ���������� � ��������� 10 ���������� �������
      -- ������ ��� �������� � ����������
      -- ������ ����� ������, �.�. ������������ �� ������
/*      , tmpGoodsNotLink AS (SELECT DISTINCT tmpGoodsList.GoodsId
                            FROM tmpGoodsList
                                 LEFT JOIN (SELECT DISTINCT tmpGoodsList.GoodsId
                                            FROM tmpGoodsList
                                                 /*LEFT JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                                                                   ON LinkGoods_Partner_Main.GoodsId = tmpGoodsList.GoodsId  -- ����� ������ ���������� � �����

                                                 INNER JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- ����� ������ ���� � ������� �������
                                                                                  ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId
                                                 INNER JOIN Object on Object.id = LinkGoods_Main_Retail.ObjectId and Object.Descid = zc_Object_Juridical()
                                                 */
                                                 -- �������� GoodsMainId
                                                 INNER JOIN  ObjectLink AS ObjectLink_Child
                                                                        ON ObjectLink_Child.ChildObjectId = tmpGoodsList.GoodsId
                                                                       AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                 LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                                       ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                      AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                                 --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- ����� ������ � ������ � ������� �������
                                                 --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                                 -- ������ ���� �� �������� GoodsMainId
                                                 LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                                      ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                                                     AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_Main.ChildObjectId --Object_LinkGoods_View.GoodsMainId

                                                 LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                                      ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                                     AND ObjectLink_LinkGoods_Goods.DescId   = zc_ObjectLink_LinkGoods_Goods()

                                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                      ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                                     AND ObjectLink_Goods_Object.DescId  = zc_ObjectLink_Goods_Object()

                                                 INNER JOIN Object ON Object.id = ObjectLink_Goods_Object.ChildObjectId AND Object.Descid = zc_Object_Juridical()
                                              ) AS tmp ON tmp.GoodsId = tmpGoodsList.GoodsId
                            WHERE tmp.GoodsId IS NULL
                              AND inIsLink = TRUE
                            )
*/
      , SelectMinPrice_AllGoods AS (SELECT _tmpMI.MovementItemId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                                    FROM _tmpMI
                                    GROUP BY _tmpMI.MovementItemId

                                   )

      , tmpObjectLink_Area AS (SELECT ObjectLink.*
                               FROM ObjectLink
                                 INNER JOIN (SELECT DISTINCT tmpMI.PartnerGoodsId FROM tmpMI) AS tmp
                                                                                      ON tmp.PartnerGoodsId = ObjectLink.ObjectId
                               WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Area()
--                                    AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.PartnerGoodsId FROM tmpData)
                               )

      , tmpObjectLink_Object AS (SELECT ObjectLink.*
                                 FROM ObjectLink
                                   INNER JOIN (SELECT DISTINCT tmpMI.Id FROM tmpMI) AS tmp
                                                                                   ON tmp.Id = ObjectLink.ObjectId
                                 WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Object()
--                                      AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.Id FROM tmpData)
                                 )


   --������� ���� �� �������� �� �����
   , AVGIncome AS (SELECT MI_Income.ObjectId
                        , AVG(CASE WHEN MovementBoolean_PriceWithVAT.ValueData  = TRUE
                                   THEN (MIFloat_Price.ValueData * 100 / (100 + ObjectFloat_NDSKind_NDS.ValueData))
                                   ELSE MIFloat_Price.ValueData
                              END)                               ::TFloat AS AVGIncomePrice
                   FROM Movement AS Movement_Income
                       JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                            ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Income.Id
                                           AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                       JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                               ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                              AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                       JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                       JOIN MovementItem AS MI_Income
                                         ON MI_Income.MovementId = Movement_Income.Id
                                        AND MI_Income.DescId = zc_MI_Master()
                                        AND MI_Income.isErased = FALSE
                                        AND MI_Income.Amount > 0
                       JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MI_Income.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   WHERE Movement_Income.DescId = zc_Movement_Income()
                     AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                     AND Movement_Income.OperDate >= vbAVGDateStart
                     AND Movement_Income.OperDate <= vbAVGDateEnd
                   GROUP BY MI_Income.ObjectId
                  )

   -- ��� �� �����-����� ���������� (LoadPriceList )
   , tmpLoadPriceList_NDS AS (SELECT *
                              FROM (SELECT LoadPriceListItem.CommonCode
                                         , LoadPriceListItem.GoodsName
                                         , LoadPriceListItem.GoodsNDS
                                         , LoadPriceListItem.GoodsId
                                         , PartnerGoods.Id AS PartnerGoodsId
                                         , LoadPriceList.JuridicalId
                                         , ROW_NUMBER() OVER (PARTITION BY LoadPriceList.JuridicalId, PartnerGoods.Id ORDER BY LoadPriceList.OperDate DESC, LoadPriceListItem.Id DESC) AS ORD
                                    FROM tmpData AS tmpMI

                                         INNER JOIN LoadPriceList ON LoadPriceList.JuridicalId = tmpMI.JuridicalId

                                         INNER JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                                                                     AND COALESCE (LoadPriceListItem.GoodsNDS,'') <> ''

                                         INNER JOIN Object_Goods_Juridical AS PartnerGoods ON PartnerGoods.JuridicalId  = LoadPriceList.JuridicalId
                                                                                          AND PartnerGoods.Code = LoadPriceListItem.GoodsCode
                                                                                          AND PartnerGoods.Id = tmpMI.PartnerGoodsId

                                    ) AS tmp
                              WHERE tmp.ORD = 1
                              )

   -- ����������� �� ��� ��������� �� ���� ���������
   , tmpSendSun AS (SELECT MI_Send.ObjectId                AS GoodsId
                         , SUM (MI_Send.Amount) ::TFloat   AS Amount
                     FROM Movement AS Movement_Send
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Send.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                       ON MovementBoolean_SUN.MovementId = Movement_Send.Id
                                                      AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                      AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementItem AS MI_Send
                                                    ON MI_Send.MovementId = Movement_Send.Id
                                                   AND MI_Send.DescId = zc_MI_Master()
                                                   AND MI_Send.isErased = FALSE

                            --INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = MI_Send.ObjectId
                     WHERE Movement_Send.OperDate = vbOperDate
                       AND Movement_Send.DescId = zc_Movement_Send()
                       AND Movement_Send.StatusId = zc_Enum_Status_Erased()
                     GROUP BY MI_Send.ObjectId
                     HAVING SUM (MI_Send.Amount) <> 0
                    )

       -- ��������� 1
       SELECT
             tmpMI.Id                                       AS Id
           , tmpMI.GoodsId                                  AS GoodsId
           , tmpMI.GoodsCode                                AS GoodsCode
           , tmpMI.GoodsName                                AS GoodsName
           , Object_Retail.ValueData                        AS RetailName
           , tmpMI.isTOP                                    AS isTOP
           , COALESCE (Object_Price_View.isTOP, FALSE)      AS isTOP_Price

           , tmpMI.GoodsGroupId                             AS GoodsGroupId
           , tmpMI.NDSKindId                                AS NDSKindId
           , tmpMI.NDSKindName                              AS NDSKindName
           , tmpMI.NDS                                      AS NDS
           , CASE WHEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'0') <> '0' THEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'') ELSE '' END  :: TVarChar     AS NDS_PriceList                      -- ��� �� ������ ����������
           , tmpMI.isClose                                  AS isClose
           , tmpMI.isFirst                                  AS isFirst
           , tmpMI.isSecond                                 AS isSecond
           , COALESCE (tmpGoodsMain.isSP,FALSE) :: Boolean  AS isSP
           , COALESCE (tmpGoodsMain.isResolution_224, FALSE) ::Boolean AS isResolution_224

           , CASE WHEN DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate) = vbOperDate THEN TRUE ELSE FALSE END AS isMarketToday    --CURRENT_DATE
           , DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate)                   ::TDateTime  AS LastPriceDate

           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                  WHEN tmpMI.isTOP = TRUE
                    OR COALESCE (Object_Price_View.isTOP, FALSE) = TRUE
                   THEN 16440317         --12615935                                                      --16440317  - ������� ��� � ������� ELSE zc_Color_White()
                  ELSE zc_Color_White() --0
             END                                            AS isTopColor
           , tmpMI.Multiplicity                             AS Multiplicity
           , tmpMI.CalcAmount ::TFloat                      AS CalcAmount
           , tmpMI.Amount ::TFloat                          AS Amount
           , tmpMI.Summ   ::TFloat                          AS Summ
           , tmpMI.isErased                                 AS isErased
           , tmpMI.Price                                    AS Price
           , tmpMI.MinimumLot                               AS MinimumLot
           , tmpMI.PartionGoodsDate                         AS PartionGoodsDate
           , tmpMI.Comment                                  AS Comment
           , tmpMI.PartnerGoodsId                           AS PartnerGoodsId
           , tmpMI.PartnerGoodsCode ::TVarChar              AS PartnerGoodsCode
           , tmpMI.PartnerGoodsName                         AS PartnerGoodsName
           , tmpMI.JuridicalId                              AS JuridicalId
           , tmpMI.JuridicalName                            AS JuridicalName      -- ***
           , tmpMI.ContractId                               AS ContractId
           , tmpMI.ContractName                             AS ContractName
           , tmpMI.MakerName                                AS MakerName
           , tmpMI.SuperFinalPrice                          AS SuperFinalPrice
           , tmpMI.SuperFinalPrice_Deferment                AS SuperFinalPrice_Deferment
           , COALESCE (tmpGoodsMain.PriceOptSP,0)        ::TFloat     AS PriceOptSP
           , CASE WHEN tmpGoodsMain.isSP = TRUE AND (tmpMI.Price > (COALESCE (tmpGoodsMain.PriceOptSP,0))) THEN TRUE ELSE FALSE END isPriceDiff
           , COALESCE(tmpMI.isCalculated, FALSE)                      AS isCalculated
           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()   --����� ���.�������
                  WHEN tmpMI.PartionGoodsDate < CASE WHEN COALESCE (tmpLayoutAll.Amount, 0) > 0 THEN vbDate9 ELSE vbDate180 END THEN zc_Color_Red() --456
                  WHEN (tmpMI.isTOP = TRUE OR COALESCE (Object_Price_View.isTOP, FALSE)= TRUE) THEN zc_Color_Blue()--15993821 -- 16440317    -- ��� ��� ������� �����
                     ELSE 0
                END AS PartionGoodsDateColor
           , Remains.Amount  ::TFloat                                        AS RemainsInUnit
           , COALESCE (tmpReserve.Amount, 0)                       :: TFloat AS Reserved           -- ���-�� � ���������� �����
           , CASE WHEN (COALESCE (Remains.Amount,0) - COALESCE (tmpReserve.Amount, 0)) < 0 THEN (COALESCE (Remains.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) ELSE 0 END :: TFLoat AS Remains_Diff  --�� ������� � ������ �����. �����
           , Object_Price_View.MCSValue                                      AS MCS
           , tmpGoodsCategory.Value                                          AS MCS_GoodsCategory
           , COALESCE (Object_Price_View.MCSIsClose, FALSE)                  AS MCSIsClose
           , COALESCE (Object_Price_View.MCSNotRecalc, FALSE)                AS MCSNotRecalc
           , Income.Income_Amount                                            AS Income_Amount
           , tmpMI.AmountSecond                                              AS AmountSecond
           , tmpMI.AmountAll ::TFloat                                        AS AmountAll
           , tmpMI.CalcAmountAll ::TFloat                                    AS CalcAmountAll
           , tmpMI.SummAll ::TFloat                                          AS SummAll
           , tmpCheck.Amount                                    ::TFloat     AS CheckAmount
           , tmpSend.Amount                                     ::TFloat     AS SendAmount

           , tmpDeferred.AmountDeferred                                      AS AmountDeferred
           , tmpDeferred.AmountSF                                            AS AmountSF
           , tmpMI.ListDiffAmount                               ::TFloat     AS ListDiffAmount
           , tmpMI.SupplierFailuresAmount                       ::TFloat     AS SupplierFailuresAmount

           , tmpMI.AmountReal                           ::TFloat    AS AmountReal
           , tmpSendSun.Amount                          ::TFLoat    AS SendSUNAmount
           , tmpMI.SendSUNAmount                        ::TFloat    AS SendSUNAmount_save
           , tmpMI.SendDefSUNAmount                     ::TFloat    AS SendDefSUNAmount_save
           , tmpMI.RemainsSUN                           ::TFloat    AS RemainsSUN

           , COALESCE (tmpGoodsMain.CountPrice,0)               ::TFloat     AS CountPrice

           , COALESCE (SelectMinPrice_AllGoods.isOneJuridical, TRUE) :: Boolean AS isOneJuridical

           , CASE WHEN COALESCE (GoodsPromo.GoodsId, 0) = 0    THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
           , CASE WHEN COALESCE (GoodsPromoAll.GoodsId, 0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromoAll
           , COALESCE(GoodsPromo.OperDatePromo, NULL)           :: TDateTime AS OperDatePromo
           , COALESCE(GoodsPromo.InvNumberPromo, '')            :: TVarChar  AS InvNumberPromo -- ***

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN FALSE ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN FALSE ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz                    ::TVarChar   AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka                 ::TVarChar   AS OperDate_Dostavka

           , COALESCE(tmpGoodsConditionsKeep.ConditionsKeepName, '') ::TVarChar  AS ConditionsKeepName

           , CASE
                  --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- ���� ���� - ������� ������� 2 ��� �����;
                  --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- ���� ���� - ������� ������� 10 ������� ��� �������� � ������ ����������;
                  WHEN tmpMI.isClose = TRUE THEN zfCalc_Color (250, 128, 114)  
                  WHEN tmpGoodsMain.isSP = TRUE AND (tmpMI.Price > (COALESCE (tmpGoodsMain.PriceOptSP,0))) THEN zfCalc_Color (188, 143, 143)  
                  WHEN COALESCE (tmpMI.JuridicalId, 0) <> 0 AND COALESCE (tmpGoodsMain.DiscountName, '') <> '' AND COALESCE (tmpGoodsDiscountJuridical.GoodsMainId, 0) = 0 THEN zfCalc_Color (0, 255, 255) -- orange
                  WHEN tmpMI.JuridicalName ILIKE '%�+%' AND tmpMI.JuridicalId = 410822
                    OR (tmpMI.JuridicalName ILIKE '%ANC%' OR tmpMI.JuridicalName ILIKE '%PL/%') AND tmpMI.JuridicalId = 59612
                    OR tmpMI.JuridicalName ILIKE '%����%' OR tmpMI.JuridicalName ILIKE '%��²%'
                    OR tmpMI.GoodsName ILIKE '%���%'  THEN zfCalc_Color (147, 112, 219)     --������� ���������� ������
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN 12319924    --������ - ���������- ���� ����������
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  --������ ������� -- ������-������� - ����������
                  WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- ������ ������
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color

           , AVGIncome.AVGIncomePrice    AS AVGPrice

           , CASE WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) * 100
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < -0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) * 100
                  WHEN COALESCE (AVGIncome.AVGIncomePrice, 0) = 0 THEN 0.1--5000
                  ELSE 0
             END ::TFloat                AS AVGPriceWarning

           -- , tmpJuridicalArea.AreaId                                      AS AreaId
           -- , COALESCE (tmpJuridicalArea.AreaName, '')      :: TVarChar    AS AreaName
           -- , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods

           , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean     AS isDefault

           , tmpGoodsMain.DiscountName
           , tmpGoodsMain.DiscountJuridical

           , tmpMI.AmountSUA                                              AS AmountSUA
           , tmpFinalSUAList.FinalSUA::TFloat                             AS FinalSUA
           , tmpFinalSUAList.FinalSUASend::TFloat                         AS FinalSUASend

           , tmpLayoutAll.Amount::TFloat                                  AS Layout

           , COALESCE (SupplierFailures.GoodsId, 0) <> 0                  AS isSupplierFailures
           , CASE
                  WHEN COALESCE (SupplierFailures.GoodsId, 0) <> 0 THEN zfCalc_Color (255, 165, 0) -- orange
                  ELSE CASE
                            --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- ���� ���� - ������� ������� 2 ��� �����;
                            --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- ���� ���� - ������� ������� 10 ������� ��� �������� � ������ ����������;
                            WHEN tmpMI.JuridicalName ILIKE '%�+%' AND tmpMI.JuridicalId = 410822
                              OR (tmpMI.JuridicalName ILIKE '%ANC%' OR tmpMI.JuridicalName ILIKE '%PL/%') AND tmpMI.JuridicalId = 59612
                              OR tmpMI.JuridicalName ILIKE '%����%' OR tmpMI.JuridicalName ILIKE '%��²%'
                              OR tmpMI.GoodsName ILIKE '%���%'  THEN zfCalc_Color (147, 112, 219)     --������� ���������� ������
                            WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN 12319924    --������ - ���������- ���� ����������
                            WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  --������ ������� -- ������-������� - ����������
                            WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- ������ ������
                            ELSE zc_Color_White()
                       END
              END  AS SupplierFailuresColor

           , COALESCE (tmpGoodsSPRegistry_1303.GoodsId, 0) <> 0                                                  AS isSPRegistry_1303
           , Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2)::TFloat                                          AS PriceOOC1303
           , CASE WHEN Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2) > 0 AND tmpMI.Price  > 0
             THEN ((1.0 - tmpMI.Price / Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2)) * 100)
             ELSE 0 END::TFloat AS DPriceOOC1303

       FROM tmpData AS tmpMI
            LEFT JOIN tmpPriceView AS Object_Price_View ON tmpMI.GoodsId                    = Object_Price_View.GoodsId
            LEFT JOIN tmpRemains   AS Remains           ON Remains.ObjectId                 = tmpMI.GoodsId
            LEFT JOIN tmpIncome    AS Income            ON Income.Income_GoodsId            = tmpMI.GoodsId
            LEFT JOIN tmpGoodsConditionsKeep            ON tmpGoodsConditionsKeep.GoodsId   = tmpMI.GoodsId
            LEFT JOIN tmpGoodsMain                      ON tmpGoodsMain.GoodsId             = tmpMI.GoodsId
            LEFT JOIN OrderSheduleList                  ON OrderSheduleList.ContractId      = tmpMI.ContractId
            LEFT JOIN OrderSheduleListToday             ON OrderSheduleListToday.ContractId = tmpMI.ContractId
            LEFT JOIN tmpCheck                          ON tmpCheck.GoodsId                 = tmpMI.GoodsId
            LEFT JOIN tmpSend                           ON tmpSend.GoodsId                  = tmpMI.GoodsId
            LEFT JOIN tmpSendSun                        ON tmpSendSun.GoodsId               = tmpMI.GoodsId
            LEFT JOIN tmpDeferred                       ON tmpDeferred.GoodsId              = tmpMI.GoodsId
            LEFT JOIN tmpReserve                        ON tmpReserve.GoodsId               = tmpMI.GoodsId
            LEFT JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.MovementItemId = tmpMI.Id

            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId     = tmpMI.GoodsId
            -- ���������� �� �������� �� �������. ���. �� ����� �������������
            LEFT JOIN (SELECT DISTINCT GoodsPromo.GoodsId FROM GoodsPromo) AS GoodsPromoAll ON GoodsPromoAll.GoodsId = tmpMI.GoodsId


            --LEFT JOIN tmpOrderLast_2days ON tmpOrderLast_2days.GoodsId = tmpMI.GoodsId
            --LEFT JOIN tmpOrderLast_10    ON tmpOrderLast_10.GoodsId    = tmpMI.GoodsId
            --LEFT JOIN tmpRepeat          ON tmpRepeat.GoodsId          = tmpMI.GoodsId
            LEFT JOIN tmpJuridicalArea   ON tmpJuridicalArea.JuridicalId = tmpMI.JuridicalId


            -- �������� ����
            LEFT JOIN tmpObjectLink_Object AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
                                 AND ObjectLink_Object.DescId = zc_ObjectLink_Goods_Object()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId
            --������� ����
            LEFT JOIN AVGIncome ON AVGIncome.ObjectId = tmpMI.GoodsId
            LEFT JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpLoadPriceList_NDS ON tmpLoadPriceList_NDS.PartnerGoodsId = tmpMI.PartnerGoodsId
                                          AND tmpLoadPriceList_NDS.JuridicalId = tmpMI.JuridicalId

            LEFT JOIN tmpFinalSUAList ON tmpFinalSUAList.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpLayoutAll ON tmpLayoutAll.GoodsId = tmpMI.GoodsId

/*            LEFT JOIN tmpObjectLink_Area AS ObjectLink_Goods_Area
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId    */

            LEFT JOIN tmpSupplierFailures AS SupplierFailures
                                          ON SupplierFailures.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpGoodsSPRegistry_1303 ON tmpGoodsSPRegistry_1303.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpGoodsDiscountJuridical ON tmpGoodsDiscountJuridical.GoodsMainId = tmpGoodsMain.GoodsMainId
                                               AND tmpGoodsDiscountJuridical.JuridicalId = tmpMI.JuridicalId
           ;

--raise notice 'Value 5: %', CLOCK_TIMESTAMP();


    -- !!!������ ��� ������ ���������� + inShowAll = TRUE - 3-�� ����� (����� = 3)!!!
    ELSEIF inShowAll = TRUE
    THEN


     raise notice 'Value: %', 3;

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

--    PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, 0, vbUserId);

     -- ������
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


      -- ���������� ������
      INSERT INTO _tmpMI

           WITH -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����) !!!������ ���� ������������ ObjectId!!!

                MovementItemOrder AS (SELECT MovementItem.*
                                           , ObjectLink_Main.ChildObjectId AS GoodsMainId, ObjectLink_LinkGoods_Goods.ChildObjectId AS GoodsId
                                      FROM MovementItem
                                       --  INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.ObjectId -- ����� ������ ���� � �����
                                       -- �������� GoodsMainId
                                           INNER JOIN  ObjectLink AS ObjectLink_Child
                                                                  ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                         --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- ����� ������ � ������ � ������� �������
                                         --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                           -- ������ ���� �� �������� GoodsMainId
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
                -- ������������� ��������
              , tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- ����� ����� "����"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUnitId  := vbUnitId
                                                                                       , inUserId  := vbUserId) AS tmp
                                      )

              , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceList.JuridicalId
                                          , LoadPriceList.ContractId
                                          , LoadPriceList.AreaId
                                     FROM LoadPriceList
                                     )

      -- ������ �� % ��������� ������� �� �����������
      , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := vbObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inSession) AS tmp)

      -- ���. ���������� ��� ������ ����������
      , tmpJuridicalPriorities AS (SELECT tmp.JuridicalId
                                        , tmp.GoodsId AS GoodsMainId  --������� �����
                                        , tmp.Priorities
                                   FROM gpSelect_Object_JuridicalPriorities (inSession) AS tmp
                                   WHERE tmp.isErased = FALSE
                                     AND COALESCE (tmp.Priorities,0) <> 0
                                     AND FALSE
                                   )
      , tmpMovementItemLastPriceList_View AS (SELECT LastMovement.MovementId
                                                   , LastMovement.JuridicalId
                                                   , LastMovement.ContractId
                                                   , MovementItem.Id                    AS MovementItemId
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
                                                  INNER JOIN MovementItemLinkObject AS MILinkObject_Goods -- ������ � �����-�����
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

                                                  LEFT JOIN tmpSupplierFailures AS SupplierFailures
                                                                                ON SupplierFailures.GoodsId = MILinkObject_Goods.ObjectId
                                                                               AND SupplierFailures.JuridicalId = LastMovement.JuridicalId
                                                                               AND SupplierFailures.ContractId = LastMovement.ContractId
                                              WHERE COALESCE (SupplierFailures.GoodsId, 0) = 0
                                              )

       -- ���������
       SELECT row_number() OVER ()
            , DD.MovementItemId
            , DD.PriceListMovementItemId
            , DD.Price
            , DD.PartionGoodsDate
            , DD.GoodsId
            , DD.GoodsCode
            , DD.GoodsName
            , DD.MainGoodsName
            , DD.JuridicalId
            , DD.JuridicalName
            , DD.MakerName
            , DD.ContractId
            , DD.ContractName
            , DD.AreaId
            , DD.AreaName
            , DD.isDefault
            , DD.Deferment
            , DD.Bonus
            , DD.Percent         :: TFloat
            , DD.SuperFinalPrice :: TFloat

            -- �� ���� ���� ���������� ����� �������� ���������
            -- � 09,09,2020 ����� ��� ��������� JuridicalPriorities   -- % ���������� "-" ��������� ��������� "+" �����������, �.� ���� + ����� ��������� ����
            , (DD.SuperFinalPrice_Deferment * ( (-1) * COALESCE (tmpJuridicalPriorities.Priorities,0) / 100 + 1)) :: TFloat AS SuperFinalPrice_Deferment

       FROM (
             SELECT ddd.Id AS MovementItemId
                  , ddd.PriceListMovementItemId
                  , ddd.Price
                  , ddd.PartionGoodsDate
                  , ddd.GoodsId
                  , ddd.GoodsCode
                  , ddd.GoodsName
                  , ddd.GoodsMainId
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
                            -- -- ���� ���� ���������� �� �������� � ������� ���������� (�� ����� ���� ��������� ����� ��� ������� �����. ����)
                            WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                                 THEN MovementItemLastPriceList_View.Price
                                     -- � ����������� % ������ �� ������������� ��������
                                   * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                            ELSE -- ����� ����������� ����� - ��� ���-������� ��� �� ���-�������
                                 (MovementItemLastPriceList_View.Price * (100 - COALESCE(tmpJuridicalSettingsItem.Bonus, 0)) / 100) :: TFloat
                                  -- � ����������� % ������ �� ������������� ��������
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
                        , MovementItemOrder.GoodsMainId             AS GoodsMainId
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

                          -- ����� "����������", ���� �� ���� � ������� !!!� �� ����!!!
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

                          --   LEFT JOIN Object_Goods_View AS Goods  -- ������� ��������� ������
                          --     ON Goods.Id = MovementItemOrder.ObjectId

                          -- % ������ �� ������������� ��������
                          LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                              AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId


                     WHERE  COALESCE(JuridicalSettings.isPriceCloseOrder, FALSE) <> TRUE                                        --
             ) AS ddd

             LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
             LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
             LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice  AND tmpCostCredit.PriceLimit
            ) AS DD

            LEFT JOIN tmpJuridicalPriorities ON tmpJuridicalPriorities.GoodsMainId = DD.GoodsMainId
                                            AND tmpJuridicalPriorities.JuridicalId = DD.JuridicalId
     ;

	 ANALYSE _tmpMI;

--raise notice 'Value 2: %', CLOCK_TIMESTAMP();


-- lpCreateTempTable_OrderInternal ����� ���������

   --RAISE EXCEPTION '������.';
     RETURN QUERY
     WITH
     --������ ����������� ������ ������/��������
        tmpDateList AS (SELECT ''||tmpDayOfWeek.DayOfWeekName|| '-' || DATE_PART ('day', tmp.OperDate :: Date) ||'' AS OperDate
                             --''||tmp.OperDate :: Date || ' (' ||tmpDayOfWeek.DayOfWeekName ||')' AS OperDate
                             , tmpDayOfWeek.Number
                             , tmpDayOfWeek.DayOfWeekName
                        FROM (SELECT generate_series ( CURRENT_DATE,  CURRENT_DATE+interval '6 day', '1 day' :: INTERVAL) AS OperDate) AS tmp
                             LEFT JOIN zfCalc_DayOfWeekName(tmp.OperDate) AS tmpDayOfWeek ON 1=1
                        )
      , tmpOrderShedule AS (SELECT ObjectLink_OrderShedule_Contract.ChildObjectId          AS ContractId --
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1)) ::TFloat AS Value1
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2)) ::TFloat AS Value2
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3)) ::TFloat AS Value3
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4)) ::TFloat AS Value4
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5)) ::TFloat AS Value5
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6)) ::TFloat AS Value6
                                 , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7)) ::TFloat AS Value7
                                 , Object_OrderShedule.ValueData AS Value8
                            FROM Object AS Object_OrderShedule
                                 INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                                       ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                                                      AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                                                      AND ObjectLink_OrderShedule_Unit.ChildObjectId = vbUnitId
                                 LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                                      ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                                                     AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                            WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                              AND Object_OrderShedule.isErased = FALSE
                           )
      , tmpOrderSheduleList AS (SELECT tmp.*
                                FROM (
                                      select tmpOrderShedule.ContractId, CASE WHEN Value1 in (1,3) THEN 1 ELSE 0 END AS DoW, CASE WHEN Value1 in (2,3) THEN 1 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value2 in (1,3) THEN 2 ELSE 0 END AS DoW, CASE WHEN Value2 in (2,3) THEN 2 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value3 in (1,3) THEN 3 ELSE 0 END AS DoW, CASE WHEN Value3 in (2,3) THEN 3 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value4 in (1,3) THEN 4 ELSE 0 END AS DoW, CASE WHEN Value4 in (2,3) THEN 4 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value5 in (1,3) THEN 5 ELSE 0 END AS DoW, CASE WHEN Value5 in (2,3) THEN 5 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value6 in (1,3) THEN 6 ELSE 0 END AS DoW, CASE WHEN Value6 in (2,3) THEN 6 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.ContractId, CASE WHEN Value7 in (1,3) THEN 7 ELSE 0 END AS DoW, CASE WHEN Value7 in (2,3) THEN 7 ELSE 0 END AS DoW_D from tmpOrderShedule) AS tmp
                                WHERE tmp.DoW <> 0 OR tmp.DoW_D <> 0
                                )
      , tmpAfter AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                     FROM (
                           SELECT tmpOrderSheduleList.ContractId, min (DoW) AS DoW, 0 AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW > vbCURRENT_DOW
                             AND tmpOrderSheduleList.DoW > 0
                           GROUP BY tmpOrderSheduleList.ContractId
                           Union
                           SELECT tmpOrderSheduleList.ContractId, 0 AS DoW, min (DoW_D) AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW_D > vbCURRENT_DOW
                             AND tmpOrderSheduleList.DoW_D > 0
                           GROUP BY tmpOrderSheduleList.ContractId) as tmp
                     GROUP BY tmp.ContractId
                     )
      , tmpBefore AS (SELECT tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                      FROM (
                           SELECT tmpOrderSheduleList.ContractId,  min (tmpOrderSheduleList.DoW) AS DoW, 0 AS DoW_D
                           FROM tmpOrderSheduleList
                                LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                           WHERE tmpOrderSheduleList.DoW < vbCURRENT_DOW
                             AND tmpAfter.ContractId IS NULL
                             AND tmpOrderSheduleList.DoW<>0
                           GROUP BY tmpOrderSheduleList.ContractId
                       UNION
                           SELECT tmpOrderSheduleList.ContractId, 0 AS DoW,  min (tmpOrderSheduleList.DoW_D) AS DoW_D
                           FROM tmpOrderSheduleList
                                LEFT JOIN tmpAfter ON tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                           WHERE tmpOrderSheduleList.DoW_D < vbCURRENT_DOW
                             AND tmpAfter.ContractId IS NULL
                             AND tmpOrderSheduleList.DoW_D<>0
                           GROUP BY tmpOrderSheduleList.ContractId
                           ) AS tmp
                      GROUP BY tmp.ContractId
                      )
      , OrderSheduleList AS ( SELECT tmp.ContractId
                                   , tmpDateList.OperDate         AS OperDate_Zakaz
                                   , tmpDateList_D.OperDate       AS OperDate_Dostavka
                              FROM (SELECT *
                                    FROM tmpAfter
                                 union all
                                    SELECT *
                                    FROM tmpBefore
                                   ) AS tmp
                                 LEFT JOIN tmpDateList ON tmpDateList.Number = tmp.DoW
                                 LEFT JOIN tmpDateList AS tmpDateList_D ON tmpDateList_D.Number = tmp.DoW_D
                            )
      , OrderSheduleListToday AS (SELECT *
                                  FROM tmpOrderSheduleList
                                  WHERE tmpOrderSheduleList.DoW = vbCURRENT_DOW  OR tmpOrderSheduleList.DoW_D = vbCURRENT_DOW
                                 )

        -- ������������� ��������
      , GoodsPromo AS (WITH tmpPromo AS (SELECT * FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= vbOperDate) AS tmp) -- CURRENT_DATE
                          , tmpList AS (SELECT ObjectLink_Child.ChildObjectId        AS GoodsId
                                             , ObjectLink_Child_retail.ChildObjectId AS GoodsId_retail -- ����� ����� "����"
                                        FROM ObjectLink AS ObjectLink_Child
                                              INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                                       AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                              INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                             AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                              INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                              AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                    ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_Child_retail.ChildObjectId
                                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                        WHERE ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          -- AND vbObjectId <> 3
                                       )
                       SELECT tmp.JuridicalId
                            , COALESCE (tmpList.GoodsId_retail, tmp.GoodsId) AS GoodsId -- ����� ����� "����"
                            , tmp.MovementId
                            , tmp.ChangePercent
                            , MovementPromo.OperDate                AS OperDatePromo
                            , MovementPromo.InvNumber               AS InvNumberPromo -- ***
                       FROM tmpPromo AS tmp   --CURRENT_DATE
                            INNER JOIN tmpList ON tmpList.GoodsId = tmp.GoodsId
                            LEFT JOIN Movement AS MovementPromo ON MovementPromo.Id = tmp.MovementId
                      )

      -- ������ �� ������. �������
      , tmpGoodsCategory AS (SELECT ObjectLink_Child_retail.ChildObjectId AS GoodsId
                                  , ObjectFloat_Value.ValueData                  AS Value
                             FROM Object AS Object_GoodsCategory
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                       ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                                      AND ObjectLink_GoodsCategory_Unit.ChildObjectId = vbUnitId
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                       ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                 INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                        ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                       AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                 -- ������� �� ����� ����
                                 INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                       ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                      AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                 INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                       ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                      AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                 INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                       ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                      AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                      AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                             WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                               AND Object_GoodsCategory.isErased = FALSE
                             )


      , tmpMI_All AS (SELECT MovementItem.*
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                         )
        -- 2.1
      , tmpOF_Goods_MinimumLot AS (SELECT *
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND ObjectFloat.ValueData <> 0
                                     AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpMI_All.ObjectId FROM tmpMI_All)
                       )
      , tmpMI_Master AS (SELECT tmpMI.*
                              , CEIL(tmpMI.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1))
                                * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData , 1)                       AS CalcAmount
                              , ObjectFloat_Goods_MinimumLot.ValueData                                       AS MinimumLot
                              , COALESCE (GoodsPrice.isTOP, FALSE)                                           AS Price_isTOP
                         FROM tmpMI_All AS tmpMI
                               LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpMI.ObjectId
                               LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                                                                ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI.ObjectId
                                                              -- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                         )

        -- 2.2
      , tmpOF_MinimumLot_Goods AS (SELECT *
                                   FROM ObjectFloat
                                   WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                     AND ObjectFloat.ValueData <> 0
                                     AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpGoods_all.GoodsId_MinLot FROM tmpGoods_all)
                       )

      , tmpGoods AS (SELECT tmpGoods_all.GoodsId
                          , tmpGoods_all.GoodsCode
                          , tmpGoods_all.GoodsName
                          , tmpGoods_all.GoodsGroupId
                          , tmpGoods_all.NDSKindId
                          , tmpGoods_all.NDSKindName
                          , tmpGoods_all.NDS
                          , ObjectFloat_Goods_MinimumLot.ValueData AS Multiplicity
                          , tmpGoods_all.isClose
                          , tmpGoods_all.Goods_isTOP
                          , tmpGoods_all.Price_isTOP
                          , tmpGoods_all.isFirst
                          , tmpGoods_all.isSecond

                     FROM tmpGoods_all
                          LEFT JOIN tmpOF_MinimumLot_Goods AS ObjectFloat_Goods_MinimumLot
                                                           ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpGoods_all.GoodsId_MinLot
                                           --     AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                    )

      , tmpMIF AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                     INNER JOIN (SELECT tmpMI_Master.Id FROM tmpMI_Master) AS test ON test.ID = MovementItemFloat.MovementItemId
--                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Master.Id FROM tmpMI_Master)
                   )
      , tmpMIF_Summ AS (SELECT tmpMIF.*
                        FROM tmpMIF
                        WHERE tmpMIF.DescId = zc_MIFloat_Summ()
                        )
      , tmpMIF_AmountSecond AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountSecond()
                                )
      , tmpMIF_AmountManual AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountManual()
                                )
      , tmpMIF_ListDiff AS (SELECT tmpMIF.*
                            FROM tmpMIF
                            WHERE tmpMIF.DescId = zc_MIFloat_ListDiff()
                           )
      , tmpMIF_SupplierFailures AS (SELECT tmpMIF.*
                                    FROM tmpMIF
                                    WHERE tmpMIF.DescId = zc_MIFloat_SupplierFailures()
                                   )
      , tmpMIF_AmountSUA AS (SELECT tmpMIF.*
                             FROM tmpMIF
                             WHERE tmpMIF.DescId = zc_MIFloat_AmountSUA()
                            )
      , tmpMILinkObject AS (SELECT MILinkObject.*
                            FROM MovementItemLinkObject AS MILinkObject
--                              INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MILinkObject.MovementItemId
                            WHERE MILinkObject.DescId IN ( zc_MILinkObject_Juridical()
                                                         , zc_MILinkObject_Contract()
                                                         , zc_MILinkObject_Goods())
                              AND MILinkObject.MovementItemId in (SELECT tmpMI_Master.Id from tmpMI_Master)
                            )

      , tmpMIString_Comment AS (SELECT MIString_Comment.*
                                FROM MovementItemString AS MIString_Comment
--                                  INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MIString_Comment.MovementItemId
                                WHERE MIString_Comment.DescId = zc_MIString_Comment()
                                  AND MIString_Comment.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                )

      , tmpMIBoolean_Calculated AS (SELECT MIBoolean_Calculated.*
                                    FROM MovementItemBoolean AS MIBoolean_Calculated
--                                      INNER JOIN  (SELECT tmpMI_Master.Id from tmpMI_Master) AS test ON test.ID = MIBoolean_Calculated.MovementItemId
                                    WHERE MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                      AND MIBoolean_Calculated.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                   )

      , tmpMinPrice AS (SELECT DISTINCT DDD.MovementItemId
                             , DDD.GoodsId
                             , DDD.GoodsCode
                             , DDD.GoodsName
                             , DDD.JuridicalId
                             , DDD.JuridicalName
                             , DDD.ContractId
                             , DDD.ContractName
                             , DDD.MakerName
                             , DDD.PartionGoodsDate
                             , DDD.SuperFinalPrice
                             , DDD.SuperFinalPrice_Deferment
                             , DDD.Price
                             , DDD.MinId
                        FROM (SELECT *, MIN(DDD.Id) OVER (PARTITION BY DDD.MovementItemId) AS MinId
                              FROM (SELECT *
                                         -- , MIN (SuperFinalPrice) OVER (PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                         --, ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId ORDER BY _tmpMI.SuperFinalPrice_Deferment ASC, _tmpMI.PartionGoodsDate DESC, _tmpMI.Deferment DESC) AS Ord
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId ORDER BY (CASE WHEN _tmpMI.PartionGoodsDate < vbDate180 THEN _tmpMI.SuperFinalPrice_Deferment + 100 ELSE _tmpMI.SuperFinalPrice_Deferment END) ASC, _tmpMI.PartionGoodsDate DESC, _tmpMI.Deferment DESC) AS Ord
                                    FROM _tmpMI
                                   ) AS DDD
                              -- WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice
                              WHERE DDD.Ord = 1
                             ) AS DDD
                        WHERE DDD.Id = DDD.MinId
                       )
        -- ���� �� ������ ������ , ��������  ���������� ������ � ���� ����� ��������
      , tmpMI_PriceList AS (SELECT *
                            FROM (SELECT _tmpMI.*
                                       , ROW_NUMBER() OVER (PARTITION BY _tmpMI.MovementItemId, _tmpMI.JuridicalId, _tmpMI.GoodsId, _tmpMI.ContractId ORDER BY _tmpMI.Price ASC, _tmpMI.PartionGoodsDate DESC) AS Ord
                                  FROM _tmpMI
                                 ) AS DDD
                            WHERE DDD.Ord = 1
                            )

, tmpMI_all_MinLot AS (SELECT MovementItem.Id
                            , MovementItem.ObjectId                                            AS GoodsId
                            , MovementItem.Amount                                              AS Amount
                            , MovementItem.CalcAmount
                            , MIFloat_Summ.ValueData                                           AS Summ
                            , MovementItem.MinimumLot                                          AS Multiplicity
                            , MIString_Comment.ValueData                                       AS Comment
                            , COALESCE(PriceList.MakerName, MinPrice.MakerName)                AS MakerName
                            , MIBoolean_Calculated.ValueData                                   AS isCalculated
                            -- , ObjectFloat_Goods_MinimumLot.valuedata                           AS MinimumLot
                            , COALESCE(PriceList.Price, MinPrice.Price)                        AS Price
                            , COALESCE(PriceList.PartionGoodsDate, MinPrice.PartionGoodsDate)  AS PartionGoodsDate
                            , COALESCE(PriceList.GoodsId, MinPrice.GoodsId)                    AS PartnerGoodsId
                            , COALESCE(PriceList.GoodsCode, MinPrice.GoodsCode)                AS PartnerGoodsCode
                            , COALESCE(PriceList.GoodsName, MinPrice.GoodsName)                AS PartnerGoodsName
                            , COALESCE(PriceList.JuridicalId, MinPrice.JuridicalId)            AS JuridicalId
                            , COALESCE(PriceList.JuridicalName, MinPrice.JuridicalName)        AS JuridicalName
                            , COALESCE(PriceList.ContractId, MinPrice.ContractId)              AS ContractId
                            , COALESCE(PriceList.ContractName, MinPrice.ContractName)          AS ContractName
                            , COALESCE(PriceList.SuperFinalPrice, MinPrice.SuperFinalPrice)    AS SuperFinalPrice
                            , COALESCE(PriceList.SuperFinalPrice_Deferment, MinPrice.SuperFinalPrice_Deferment) AS SuperFinalPrice_Deferment
                            --, MovementItem.Goods_isTOP
                            , MovementItem.Price_isTOP
                            , MIFloat_AmountSecond.ValueData                                   AS AmountSecond
                            , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS AmountAll
                              -- ��������� ����� AllLot
/*                            , CEIL ((-- ���������
                                     MovementItem.Amount
                                     -- ���������� ��������������
                                   + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                     -- ���-�� �������
                                   + COALESCE (MIFloat_ListDiff.ValueData, 0)
                                    ) / COALESCE (MovementItem.MinimumLot, 1)
                                   ) * COALESCE (MovementItem.MinimumLot, 1)                   AS CalcAmountAll
*/
--27.01.2020 ���� ������ ���� � ������ �������� �� ����� � ������� �� "���� + ����" � "������" - ��������� ����� ���� ������� �������� � ��������� �����
                            , CEIL ((                                -- ��������� + ���������� ��������������                        -- ���-�� �������
                                     CASE WHEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >=
                                               (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_SupplierFailures.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))
                                          THEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- ��������� + ���������� ��������������
                                          ELSE (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_SupplierFailures.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))     -- ���-�� ������� + ���
                                     END
                                    ) / COALESCE (MovementItem.MinimumLot, 1)
                                   ) * COALESCE (MovementItem.MinimumLot, 1)                   AS CalcAmountAll

                            , MIFloat_AmountManual.ValueData                                   AS AmountManual
                            , MIFloat_ListDiff.ValueData                                       AS ListDiffAmount
                            , MIFloat_SupplierFailures.ValueData                               AS SupplierFailuresAmount
                            , MIFloat_AmountSUA.ValueData                                      AS AmountSUA
                            , MovementItem.isErased
                            , COALESCE (PriceList.GoodsId, MinPrice.GoodsId)                   AS GoodsId_MinLot
                       FROM tmpMI_Master AS MovementItem

                            LEFT JOIN tmpMILinkObject AS MILinkObject_Juridical
                                                      ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()

                            LEFT JOIN tmpMILinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                            LEFT JOIN tmpMILinkObject AS MILinkObject_Goods
                                                      ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

                            LEFT JOIN tmpMIBoolean_Calculated AS MIBoolean_Calculated ON MIBoolean_Calculated.MovementItemId = MovementItem.Id

                            LEFT JOIN tmpMIString_Comment AS MIString_Comment ON MIString_Comment.MovementItemId = MovementItem.Id

                            LEFT JOIN tmpMI_PriceList AS PriceList ON COALESCE (PriceList.ContractId, 0) = COALESCE (MILinkObject_Contract.ObjectId, 0)
                                                     AND PriceList.JuridicalId = MILinkObject_Juridical.ObjectId
                                                     AND PriceList.GoodsId = MILinkObject_Goods.ObjectId
                                                     AND PriceList.MovementItemId = MovementItem.Id

                            LEFT JOIN tmpMinPrice AS MinPrice ON MinPrice.MovementItemId = MovementItem.Id

                            -- LEFT JOIN tmpOF_Goods_MinimumLot AS ObjectFloat_Goods_MinimumLot
                            --                                  ON ObjectFloat_Goods_MinimumLot.ObjectId = COALESCE (PriceList.GoodsId, MinPrice.GoodsId)
                                                 --- AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()

                            LEFT JOIN tmpMIF_Summ             AS MIFloat_Summ             ON MIFloat_Summ.MovementItemId             = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountSecond     AS MIFloat_AmountSecond     ON MIFloat_AmountSecond.MovementItemId     = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountManual     AS MIFloat_AmountManual     ON MIFloat_AmountManual.MovementItemId     = MovementItem.Id
                            LEFT JOIN tmpMIF_ListDiff         AS MIFloat_ListDiff         ON MIFloat_ListDiff.MovementItemId         = MovementItem.Id
                            LEFT JOIN tmpMIF_SupplierFailures AS MIFloat_SupplierFailures ON MIFloat_SupplierFailures.MovementItemId = MovementItem.Id
                            LEFT JOIN tmpMIF_AmountSUA        AS MIFloat_AmountSUA        ON MIFloat_AmountSUA.MovementItemId        = MovementItem.Id
     --LIMIT 2
                       )

        -- 2.3
      , tmpOF_MinimumLot_mi AS (SELECT *
                                FROM ObjectFloat
                                WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                  AND ObjectFloat.ValueData <> 0
                                  AND ObjectFloat.ObjectId  IN (SELECT DISTINCT tmpMI_all_MinLot.GoodsId_MinLot FROM tmpMI_all_MinLot)
                                )

      , tmpMI AS (SELECT tmpMI_all_MinLot.Id
                       , tmpMI_all_MinLot.GoodsId
                       , tmpMI_all_MinLot.Amount
                       , tmpMI_all_MinLot.CalcAmount
                       , tmpMI_all_MinLot.Summ
                       , tmpMI_all_MinLot.Multiplicity
                       , tmpMI_all_MinLot.Comment
                       , tmpMI_all_MinLot.MakerName
                       , tmpMI_all_MinLot.isCalculated
                       , ObjectFloat_Goods_MinimumLot.ValueData AS MinimumLot
                       , tmpMI_all_MinLot.Price
                       , tmpMI_all_MinLot.PartionGoodsDate
                       , tmpMI_all_MinLot.PartnerGoodsId
                       , tmpMI_all_MinLot.PartnerGoodsCode
                       , tmpMI_all_MinLot.PartnerGoodsName
                       , tmpMI_all_MinLot.JuridicalId
                       , tmpMI_all_MinLot.JuridicalName
                       , tmpMI_all_MinLot.ContractId
                       , tmpMI_all_MinLot.ContractName
                       , tmpMI_all_MinLot.SuperFinalPrice
                       , tmpMI_all_MinLot.SuperFinalPrice_Deferment
                       , tmpMI_all_MinLot.Price_isTOP
                       , tmpMI_all_MinLot.AmountSecond
                       , tmpMI_all_MinLot.AmountAll
                       , tmpMI_all_MinLot.CalcAmountAll
                       , tmpMI_all_MinLot.AmountManual
                       , tmpMI_all_MinLot.ListDiffAmount
                       , tmpMI_all_MinLot.SupplierFailuresAmount
                       , tmpMI_all_MinLot.AmountSUA
                       , tmpMI_all_MinLot.isErased
                  FROM tmpMI_all_MinLot

                       LEFT JOIN tmpOF_MinimumLot_mi AS ObjectFloat_Goods_MinimumLot
                                                     ON ObjectFloat_Goods_MinimumLot.ObjectId = tmpMI_all_MinLot.GoodsId_MinLot
                  )

      , tmpPriceView AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                              , MCS_Value.ValueData                     AS MCSValue
                              , Price_Goods.ChildObjectId               AS GoodsId
                              , COALESCE(MCS_isClose.ValueData,FALSE)   AS MCSIsClose
                              , COALESCE(MCS_NotRecalc.ValueData,FALSE) AS MCSNotRecalc
                              , COALESCE(Price_Top.ValueData,FALSE)     AS isTop
                         FROM ObjectLink AS ObjectLink_Price_Unit
                              LEFT JOIN ObjectLink AS Price_Goods
                                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                              LEFT JOIN tmpMI_Master ON tmpMI_Master.ObjectId = Price_Goods.ChildObjectId  -- goodsId
                              LEFT JOIN ObjectFloat AS MCS_Value
                                                    ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                              LEFT JOIN ObjectBoolean AS MCS_isClose
                                                      ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                              LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                      ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                              LEFT JOIN ObjectBoolean AS Price_Top
                                                      ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                         WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                           AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                           AND (inShowAll = TRUE OR tmpMI_Master.Id is not NULL)
                      )

      , tmpGoodsId AS (SELECT COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)           AS GoodsId
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                    GROUP BY COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
                   )

      , tmpData AS (SELECT tmpMI.Id                                                AS Id
                         , COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)              AS GoodsId
                         , tmpGoods.GoodsCode                                      AS GoodsCode
                         , tmpGoods.GoodsName                                      AS GoodsName
                         , tmpGoods.Goods_isTOP                                    AS isTOP
                         , tmpGoods.GoodsGroupId                                   AS GoodsGroupId
                         , tmpGoods.NDSKindId                                      AS NDSKindId
                         , tmpGoods.NDSKindName                                    AS NDSKindName
                         , tmpGoods.NDS                                            AS NDS
                         , tmpGoods.isClose                                        AS isClose
                         , tmpGoods.isFirst                                        AS isFirst
                         , tmpGoods.isSecond                                       AS isSecond
                         --
                         , COALESCE (tmpMI.Multiplicity, tmpGoods.Multiplicity)    AS Multiplicity
                         , tmpMI.CalcAmount                                        AS CalcAmount
                         , NULLIF(tmpMI.Amount,0)                                  AS Amount
                         , tmpMI.Price * tmpMI.CalcAmount                          AS Summ
                         , COALESCE (tmpMI.isErased, FALSE)                        AS isErased
                         , tmpMI.Price
                         , tmpMI.MinimumLot
                         , tmpMI.PartionGoodsDate
                         , tmpMI.Comment
                         , tmpMI.PartnerGoodsId
                         , tmpMI.PartnerGoodsCode
                         , tmpMI.PartnerGoodsName
                         , tmpMI.JuridicalId
                         , tmpMI.JuridicalName                                     -- ***
                         , tmpMI.ContractId
                         , tmpMI.ContractName
                         , tmpMI.MakerName
                         , tmpMI.SuperFinalPrice
                         , tmpMI.SuperFinalPrice_Deferment
                         , COALESCE (tmpMI.isCalculated, FALSE)                             AS isCalculated
                         , tmpMI.AmountSecond                                               AS AmountSecond
                         , NULLIF (tmpMI.AmountAll, 0)                                      AS AmountAll
                         , NULLIF (COALESCE (tmpMI.AmountManual, tmpMI.CalcAmountAll), 0)   AS CalcAmountAll
                         , tmpMI.Price * COALESCE (tmpMI.AmountManual, tmpMI.CalcAmountAll) AS SummAll
                         , tmpMI.ListDiffAmount
                         , tmpMI.SupplierFailuresAmount
                         , tmpMI.AmountSUA
                    FROM tmpGoods
                         FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                   )
      -- ������� �������
      , tmpRemains AS (SELECT Container.ObjectId
                            , SUM (Container.Amount) AS Amount
                       FROM Container

                            INNER JOIN tmpGoodsId AS tmp
                                                  ON tmp.GoodsId = Container.ObjectId
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount<>0
                         AND Container.WhereObjectId = vbUnitId
--                         AND Container.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                       GROUP BY Container.ObjectId
                      )
      -- ������
      , tmpIncome AS (SELECT MovementItem_Income.ObjectId               AS Income_GoodsId
                           , SUM (MovementItem_Income.Amount) :: TFloat AS Income_Amount
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementItem AS MovementItem_Income
                                                   ON Movement_Income.Id = MovementItem_Income.MovementId
                                                  AND MovementItem_Income.DescId = zc_MI_Master()
                                                  AND MovementItem_Income.isErased = FALSE
                                                  AND MovementItem_Income.Amount > 0
--                                                  AND MovementItem_Income.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                           INNER JOIN tmpGoodsId AS tmp
                                                 ON tmp.GoodsId = MovementItem_Income.ObjectId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND MovementLinkObject_To.ObjectId = vbUnitId
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '31 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MovementItem_Income.ObjectId
                     )

        -- ������ ���-������ (��������)
      , tmpGoodsSP AS (SELECT tmp.GoodsId
                            , TRUE AS isSP
                            , MIN(MIFloat_PriceOptSP.ValueData) AS PriceOptSP
                       FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbOperDate, inEndDate:= vbOperDate, inUnitId := vbUnitId) AS tmp
                                                LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                     ON MIFloat_PriceOptSP.MovementItemId = tmp.MovementItemId
                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                       GROUP BY tmp.GoodsId
                       )

      -- ���������� ��������� �������������
      , tmpDiscountJuridicalAll AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                         , ObjectLink_Juridical.ChildObjectId            AS JuridicalId
                                         , CASE WHEN ObjectLink_Juridical.ChildObjectId = 59611
                                                THEN '������'
                                                ELSE Object_Juridical.ValueData END      AS JuridicalName
                                    FROM Object AS Object_DiscountExternalSupplier
                                         LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                              ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                                             AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()

                                          LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                               ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                                              AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()
                                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

                                     WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier()
                                       AND Object_DiscountExternalSupplier.isErased = FALSE)
      , tmpDiscountJuridical AS (SELECT tmpDiscountJuridicalAll.DiscountExternalId                   AS DiscountExternalId
                                      , STRING_AGG(tmpDiscountJuridicalAll.JuridicalName, ', ')      AS JuridicalName
                                 FROM tmpDiscountJuridicalAll
                                 GROUP BY tmpDiscountJuridicalAll.DiscountExternalId)
      -- ���������� ��������� �������������
      , tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                 , tmpDiscountJuridical.JuridicalName::TVarChar  AS JuridicalName
                            FROM Object AS Object_DiscountExternalTools
                                  LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                       ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                      AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                  LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                       ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                  LEFT JOIN tmpDiscountJuridical ON tmpDiscountJuridical.DiscountExternalId = ObjectLink_DiscountExternal.ChildObjectId
                             WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                               AND ObjectLink_Unit.ChildObjectId = vbUnitId
                               AND Object_DiscountExternalTools.isErased = False
                             )
      -- ������ ���������� ���������
      , tmpGoodsDiscount AS (SELECT
                                   Object_Goods_Retail.GoodsMainId

                                 , Object_Object.Id                AS ObjectId
                                 , Object_Object.ValueData         AS DiscountName
                                 , tmpUnitDiscount.JuridicalName   AS DiscountJuridical
                                 , tmpUnitDiscount.DiscountExternalId

                             FROM Object AS Object_BarCode
                                 LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                      ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                 LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = ObjectLink_BarCode_Goods.ChildObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                      ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                 LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId

                             WHERE Object_BarCode.DescId = zc_Object_BarCode()
                               AND Object_BarCode.isErased = False
                               AND Object_Object.isErased = False
                               AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
                      )
      , tmpGoodsDiscountJuridical AS (SELECT DISTINCT
                                             tmpGoodsDiscount.GoodsMainId
                                           , tmpDiscountJuridicalAll.JuridicalId

                                       FROM tmpGoodsDiscount

                                           INNER JOIN tmpDiscountJuridicalAll ON tmpDiscountJuridicalAll.DiscountExternalId = tmpGoodsDiscount.DiscountExternalId
                                      )
      , tmpGoodsMain AS (SELECT tmpMI.GoodsId                                                           AS GoodsId
                              , COALESCE (tmpGoodsSP.isSP, False)                             ::Boolean AS isSP
                              , COALESCE (ObjectBoolean_Resolution_224.ValueData, False)      ::Boolean AS isResolution_224
                              , CAST ( (COALESCE (tmpGoodsSP.PriceOptSP,0) * 1.1) AS NUMERIC (16,2)) :: TFloat   AS PriceOptSP
                              , CASE WHEN DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData) = vbOperDate THEN TRUE ELSE FALSE END  AS isMarketToday
                              , DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData)          ::TDateTime AS LastPriceDate
                              , COALESCE (ObjectFloat_CountPrice.ValueData,0)               ::TFloat    AS CountPrice
                              , tmpGoodsDiscount.DiscountName
                              , tmpGoodsDiscount.DiscountJuridical
                              , ObjectLink_Main.ChildObjectId                                           AS GoodsMainId
                         FROM tmpGoodsId AS tmpMI
                                -- �������� GoodsMainId
                                LEFT JOIN ObjectLink AS ObjectLink_Child
                                                     ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_Main
                                                     ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                LEFT JOIN ObjectFloat AS ObjectFloat_CountPrice
                                                     ON ObjectFloat_CountPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()

                                LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                     ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()

                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                        ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                       AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

                                LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId

                                LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = ObjectLink_Main.ChildObjectId
                         )

      -- ������� ��������
      , tmpGoodsConditionsKeepList AS (SELECT ObjectLink_Goods_ConditionsKeep.ObjectId              AS GoodsId
                                            , ObjectLink_Goods_ConditionsKeep.ChildObjectId         AS ChildObjectId
                                   FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                        INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = ObjectLink_Goods_ConditionsKeep.ObjectId
                                   WHERE ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
--                                     AND ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                                  )

      , tmpGoodsConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.GoodsId                   AS GoodsId
                                        , Object_ConditionsKeep.ValueData                           AS ConditionsKeepName
                                   FROM tmpGoodsConditionsKeepList AS ObjectLink_Goods_ConditionsKeep
--                                        INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = ObjectLink_Goods_ConditionsKeep.GoodsId
                                        INNER JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
--                                     AND ObjectLink_Goods_ConditionsKeep.GoodsId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                                  )

--
      , tmpCheck AS (SELECT MI_Check.ObjectId                       AS GoodsId
                          , -1 * SUM (MIContainer.Amount) ::TFloat  AS Amount
                     FROM Movement AS Movement_Check
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN MovementItem AS MI_Check
                                                    ON MI_Check.MovementId = Movement_Check.Id
                                                   AND MI_Check.DescId = zc_MI_Master()
                                                   AND MI_Check.isErased = FALSE
                            LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.MovementItemId = MI_Check.Id
                                                                 AND MIContainer.DescId = zc_MIContainer_Count()
                      WHERE Movement_Check.OperDate >= vbOperDate
                        AND Movement_Check.OperDate < vbOperDateEnd
                       AND Movement_Check.DescId = zc_Movement_Check()
                       AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                     GROUP BY MI_Check.ObjectId
                     HAVING SUM (MI_Check.Amount) <> 0
                     )

       -- ��������������� ������
      , tmpSend AS ( SELECT MI_Send.ObjectId                AS GoodsId
                          , SUM (MI_Send.Amount) ::TFloat   AS Amount
                     FROM Movement AS Movement_Send
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Send.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                      ON MovementBoolean_Deferred.MovementId = Movement_Send.Id
                                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                            -- ����������� - ����� ����� ��� �����������, �� ������ ����
                            /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                       ON MovementBoolean_isAuto.MovementId = Movement_Send.Id
                                                      AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                      AND MovementBoolean_isAuto.ValueData  = TRUE*/
                            INNER JOIN MovementItem AS MI_Send
                                                    ON MI_Send.MovementId = Movement_Send.Id
                                                   AND MI_Send.DescId = zc_MI_Master()
                                                   AND MI_Send.isErased = FALSE
--                                                   AND MI_Send.ObjectId in (SELECT tmpMI.GoodsId FROM tmpGoodsId AS tmpMI)
                            INNER JOIN tmpGoodsId AS tmp
                                                  ON tmp.GoodsId = MI_Send.ObjectId
                     -- WHERE Movement_Send.OperDate >= vbOperDate - interval '30 DAY'
                     WHERE Movement_Send.OperDate BETWEEN CURRENT_DATE - INTERVAL '91 DAY' AND CURRENT_DATE + INTERVAL '30 DAY'  -- 27.01.2020  - 91 ����, �� ����� ���� 31 - �� ������� ���� �������
                       AND Movement_Send.OperDate < vbOperDateEnd
                       AND Movement_Send.DescId = zc_Movement_Send()
                       AND Movement_Send.StatusId = zc_Enum_Status_UnComplete()
                       --AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                     GROUP BY MI_Send.ObjectId
                     HAVING SUM (MI_Send.Amount) <> 0
                    )

      -- �� ������� ����� 0 � ��� ���� � ������ ��������� � ������������� - �� �� � ������� ��� ������� � ��� ����� �������� ������ � ������� �����.
      -- ����� ������� ����� ���������� ������ ������ - �������, ������� � �������, �������, ���������� - ���������� �� ����� �������� ���� �����.
      -- �������� ������
      , tmpGoodsList AS (SELECT tmpMI.GoodsId                      AS GoodsId
                              , COALESCE (tmpMI.Amount, 0)         AS Amount
                              , COALESCE (Remains.Amount, 0)       AS RemainsAmount
                              , COALESCE (Income.Income_Amount, 0) AS IncomeAmount
                         FROM tmpMI
                              LEFT JOIN tmpRemains AS Remains ON Remains.ObjectId      = tmpMI.GoodsId
                              LEFT JOIN tmpIncome  AS Income  ON Income.Income_GoodsId = tmpMI.GoodsId
                         WHERE COALESCE (tmpMI.Amount, 0) > 0
                        )

      , SelectMinPrice_AllGoods AS (SELECT _tmpMI.MovementItemId, CASE WHEN COUNT (*) > 1 THEN FALSE ELSE TRUE END AS isOneJuridical
                                    FROM _tmpMI
                                    GROUP BY _tmpMI.MovementItemId

                                   )

      , tmpObjectLink_Area AS (SELECT ObjectLink.*
                               FROM ObjectLink
                                 INNER JOIN (SELECT DISTINCT tmpMI.PartnerGoodsId FROM tmpMI) AS tmp
                                                                                      ON tmp.PartnerGoodsId = ObjectLink.ObjectId
                               WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Area()
--                                    AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.PartnerGoodsId FROM tmpData)
                               )

      , tmpObjectLink_Object AS (SELECT ObjectLink.*
                                 FROM ObjectLink
                                   INNER JOIN (SELECT DISTINCT tmpMI.Id FROM tmpMI) AS tmp
                                                                                   ON tmp.Id = ObjectLink.ObjectId
                                 WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Object()
--                                      AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.Id FROM tmpData)
                                 )

   --������� ���� �� �������� �� �����
   , AVGIncome AS (SELECT MI_Income.ObjectId
                        , AVG(CASE WHEN MovementBoolean_PriceWithVAT.ValueData  = TRUE
                                   THEN (MIFloat_Price.ValueData * 100 / (100 + ObjectFloat_NDSKind_NDS.ValueData))
                                   ELSE MIFloat_Price.ValueData
                              END)                               ::TFloat AS AVGIncomePrice
                   FROM Movement AS Movement_Income
                       JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                            ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Income.Id
                                           AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                       JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                               ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                              AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                       JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                       JOIN MovementItem AS MI_Income
                                         ON MI_Income.MovementId = Movement_Income.Id
                                        AND MI_Income.DescId = zc_MI_Master()
                                        AND MI_Income.isErased = FALSE
                                        AND MI_Income.Amount > 0
                       JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MI_Income.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   WHERE Movement_Income.DescId = zc_Movement_Income()
                     AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                     AND Movement_Income.OperDate >= vbAVGDateStart
                     AND Movement_Income.OperDate <= vbAVGDateEnd
                   GROUP BY MI_Income.ObjectId
                  )

   -- ��� �� �����-����� ���������� (LoadPriceList )
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
   -- ����������� �� ��� ��������� �� ���� ���������
   , tmpSendSun AS (SELECT MI_Send.ObjectId                AS GoodsId
                         , SUM (MI_Send.Amount) ::TFloat   AS Amount
                     FROM Movement AS Movement_Send
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Send.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                       ON MovementBoolean_SUN.MovementId = Movement_Send.Id
                                                      AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                      AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementItem AS MI_Send
                                                    ON MI_Send.MovementId = Movement_Send.Id
                                                   AND MI_Send.DescId = zc_MI_Master()
                                                   AND MI_Send.isErased = FALSE

                            INNER JOIN tmpGoodsId AS tmp ON tmp.GoodsId = MI_Send.ObjectId
                     WHERE Movement_Send.OperDate = vbOperDate
                       AND Movement_Send.DescId = zc_Movement_Send()
                       AND Movement_Send.StatusId = zc_Enum_Status_Erased()
                     GROUP BY MI_Send.ObjectId
                     HAVING SUM (MI_Send.Amount) <> 0
                    )

       -- ��������� 1
       SELECT
             tmpMI.Id                                       AS Id
           , tmpMI.GoodsId                                  AS GoodsId
           , tmpMI.GoodsCode                                AS GoodsCode
           , tmpMI.GoodsName                                AS GoodsName
           , Object_Retail.ValueData                        AS RetailName
           , tmpMI.isTOP                                    AS isTOP
           , COALESCE (Object_Price_View.isTOP, FALSE)      AS isTOP_Price

           , tmpMI.GoodsGroupId                             AS GoodsGroupId
           , tmpMI.NDSKindId                                AS NDSKindId
           , tmpMI.NDSKindName                              AS NDSKindName
           , tmpMI.NDS                                      AS NDS
           , CASE WHEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'0') <> '0' THEN COALESCE (tmpLoadPriceList_NDS.GoodsNDS,'') ELSE '' END   :: TVarChar    AS NDS_PriceList
           , tmpMI.isClose                                  AS isClose
           , tmpMI.isFirst                                  AS isFirst
           , tmpMI.isSecond                                 AS isSecond
           , COALESCE (tmpGoodsMain.isSP,FALSE) :: Boolean  AS isSP
           , COALESCE (tmpGoodsMain.isResolution_224,FALSE) :: Boolean  AS isResolution_224

           , CASE WHEN DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate) = vbOperDate THEN TRUE ELSE FALSE END AS isMarketToday    --CURRENT_DATE
           , DATE_TRUNC ('DAY', tmpGoodsMain.LastPriceDate)                   ::TDateTime  AS LastPriceDate

           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                  WHEN tmpMI.isTOP = TRUE
                    OR COALESCE (Object_Price_View.isTOP, FALSE) = TRUE
                   THEN 16440317         --12615935                                                      --16440317  - ������� ��� � ������� ELSE zc_Color_White()
                  ELSE zc_Color_White() --0
             END                                            AS isTopColor
           , tmpMI.Multiplicity                             AS Multiplicity
           , tmpMI.CalcAmount  ::TFloat                     AS CalcAmount
           , tmpMI.Amount  ::TFloat                         AS Amount
           , tmpMI.Summ  ::TFloat                           AS Summ
           , tmpMI.isErased                                 AS isErased
           , tmpMI.Price                                    AS Price
           , tmpMI.MinimumLot                               AS MinimumLot
           , tmpMI.PartionGoodsDate                         AS PartionGoodsDate
           , tmpMI.Comment                                  AS Comment
           , tmpMI.PartnerGoodsId                           AS PartnerGoodsId
           , tmpMI.PartnerGoodsCode  ::TVarChar             AS PartnerGoodsCode
           , tmpMI.PartnerGoodsName                         AS PartnerGoodsName
           , tmpMI.JuridicalId                              AS JuridicalId
           , tmpMI.JuridicalName                            AS JuridicalName      -- ***
           , tmpMI.ContractId                               AS ContractId
           , tmpMI.ContractName                             AS ContractName
           , tmpMI.MakerName                                AS MakerName
           , tmpMI.SuperFinalPrice                          AS SuperFinalPrice
           , tmpMI.SuperFinalPrice_Deferment                AS SuperFinalPrice_Deferment
           , COALESCE (tmpGoodsMain.PriceOptSP,0)        ::TFloat     AS PriceOptSP
           , CASE WHEN tmpGoodsMain.isSP = TRUE AND (tmpMI.Price > (COALESCE (tmpGoodsMain.PriceOptSP,0))) THEN TRUE ELSE FALSE END isPriceDiff
           , COALESCE(tmpMI.isCalculated, FALSE)                      AS isCalculated
           , CASE WHEN tmpGoodsMain.isSP = TRUE THEN 25088 --zc_Color_GreenL()   --����� ���.�������
                  WHEN tmpMI.PartionGoodsDate < CASE WHEN COALESCE (tmpLayoutAll.Amount, 0) > 0 THEN vbDate9 ELSE vbDate180 END THEN zc_Color_Red() --456
                  WHEN (tmpMI.isTOP = TRUE OR COALESCE (Object_Price_View.isTOP, FALSE)= TRUE) THEN zc_Color_Blue()--15993821 -- 16440317    -- ��� ��� ������� �����
                     ELSE 0
                END AS PartionGoodsDateColor
           , Remains.Amount  ::TFloat                                        AS RemainsInUnit
             -- ���-�� � ���������� �����
           , COALESCE (tmpReserve.Amount, 0)                       :: TFloat AS Reserved
           , CASE WHEN (COALESCE (Remains.Amount,0) - COALESCE (tmpReserve.Amount, 0)) < 0 THEN (COALESCE (Remains.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) ELSE 0 END :: TFLoat AS Remains_Diff  --�� ������� � ������ �����. �����
           , Object_Price_View.MCSValue                                      AS MCS
           , tmpGoodsCategory.Value                                          AS MCS_GoodsCategory
           , COALESCE (Object_Price_View.MCSIsClose, FALSE)                  AS MCSIsClose
           , COALESCE (Object_Price_View.MCSNotRecalc, FALSE)                AS MCSNotRecalc
           , Income.Income_Amount                                            AS Income_Amount
           , tmpMI.AmountSecond                                              AS AmountSecond
           , tmpMI.AmountAll ::TFloat                                        AS AmountAll
           , tmpMI.CalcAmountAll  ::TFloat                                   AS CalcAmountAll
           , tmpMI.SummAll ::TFloat                                          AS SummAll
           , tmpCheck.Amount                                    ::TFloat     AS CheckAmount
           , tmpSend.Amount                                     ::TFloat     AS SendAmount

           , tmpDeferred.AmountDeferred                                      AS AmountDeferred
           , tmpDeferred.AmountSF                                            AS AmountSF
           , tmpMI.ListDiffAmount                               ::TFloat     AS ListDiffAmount
           , tmpMI.SupplierFailuresAmount                       ::TFloat     AS SupplierFailuresAmount

           , 0                                                  ::TFloat    AS AmountReal
           , tmpSendSun.Amount                                  ::TFloat    AS SendSUNAmount
           , 0                                                  ::TFloat    AS SendSUNAmount_save
           , 0                                                  ::TFloat    AS SendDefSUNAmount_save
           , 0                                                  ::TFloat    AS RemainsSUN

           , COALESCE (tmpGoodsMain.CountPrice,0)               ::TFloat     AS CountPrice

           , COALESCE (SelectMinPrice_AllGoods.isOneJuridical, TRUE) :: Boolean AS isOneJuridical

           , CASE WHEN COALESCE (GoodsPromo.GoodsId, 0) = 0    THEN FALSE ELSE TRUE END  ::Boolean AS isPromo
           , CASE WHEN COALESCE (GoodsPromoAll.GoodsId, 0) = 0 THEN FALSE ELSE TRUE END  ::Boolean AS isPromoAll
           , COALESCE(GoodsPromo.OperDatePromo, NULL)           :: TDateTime AS OperDatePromo
           , COALESCE(GoodsPromo.InvNumberPromo, '')            :: TVarChar  AS InvNumberPromo -- ***

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN FALSE ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN FALSE ELSE TRUE END AS isDostavkaToday
           , OrderSheduleList.OperDate_Zakaz                    ::TVarChar   AS OperDate_Zakaz
           , OrderSheduleList.OperDate_Dostavka                 ::TVarChar   AS OperDate_Dostavka

           , COALESCE(tmpGoodsConditionsKeep.ConditionsKeepName, '') ::TVarChar  AS ConditionsKeepName

           , CASE
                  --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- ���� ���� - ������� ������� 2 ��� �����;
                  --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- ���� ���� - ������� ������� 10 ������� ��� �������� � ������ ����������;
                  WHEN tmpMI.isClose = TRUE THEN zfCalc_Color (250, 128, 114)  
                  WHEN tmpGoodsMain.isSP = TRUE AND (tmpMI.Price > (COALESCE (tmpGoodsMain.PriceOptSP,0))) THEN zfCalc_Color (188, 143, 143)  
                  WHEN COALESCE (tmpMI.JuridicalId, 0) <> 0 AND COALESCE (tmpGoodsMain.DiscountName, '') <> '' AND COALESCE (tmpGoodsDiscountJuridical.GoodsMainId, 0) = 0 THEN zfCalc_Color (0, 255, 255) -- orange
                  WHEN tmpMI.JuridicalName ILIKE '%�+%' AND tmpMI.JuridicalId = 410822
                    OR (tmpMI.JuridicalName ILIKE '%ANC%' OR tmpMI.JuridicalName ILIKE '%PL/%') AND tmpMI.JuridicalId = 59612
                    OR tmpMI.JuridicalName ILIKE '%����%' OR tmpMI.JuridicalName ILIKE '%��²%'
                    OR tmpMI.GoodsName ILIKE '%���%' THEN zfCalc_Color (147, 112, 219)     --������� ���������� ������
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN 12319924    --������ - ���������- ���� ����������
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  --������ ������� -- ������-������� - ����������
                  WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- ������ ������
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color

           , AVGIncome.AVGIncomePrice    AS AVGPrice

           , CASE WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) * 100
                  WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < -0.10 THEN (-1)*((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) * 100
                  WHEN COALESCE (AVGIncome.AVGIncomePrice, 0) = 0 THEN 0.1--5000
                  ELSE 0
             END ::TFloat                                                 AS AVGPriceWarning

           -- , tmpJuridicalArea.AreaId                                      AS AreaId
           -- , COALESCE (tmpJuridicalArea.AreaName, '')      :: TVarChar    AS AreaName
           -- , Object_Area.ValueData                         :: TVarChar    AS AreaName_Goods

           , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean     AS isDefault

           , tmpGoodsMain.DiscountName
           , tmpGoodsMain.DiscountJuridical

           , tmpMI.AmountSUA                                              AS AmountSUA
           , tmpFinalSUAList.FinalSUA::TFloat                             AS FinalSUA
           , tmpFinalSUAList.FinalSUASend::TFloat                         AS FinalSUASend

           , tmpLayoutAll.Amount::TFloat                                  AS Layout

           , COALESCE (SupplierFailures.GoodsId, 0) <> 0                  AS isSupplierFailures
           , CASE
                  WHEN COALESCE (SupplierFailures.GoodsId, 0) <> 0 THEN zfCalc_Color (255, 165, 0) -- orange
                  ELSE CASE
                        --WHEN COALESCE (tmpOrderLast_2days.Amount, 0)  > 1 THEN 16777134      -- ���� ���� - ������� ������� 2 ��� �����;
                        --WHEN COALESCE (tmpOrderLast_10.Amount, 0)     > 9 THEN 167472630     -- ���� ���� - ������� ������� 10 ������� ��� �������� � ������ ����������;
                        WHEN tmpMI.JuridicalName ILIKE '%�+%' AND tmpMI.JuridicalId = 410822
                          OR (tmpMI.JuridicalName ILIKE '%ANC%' OR tmpMI.JuridicalName ILIKE '%PL/%') AND tmpMI.JuridicalId = 59612
                          OR tmpMI.JuridicalName ILIKE '%����%' OR tmpMI.JuridicalName ILIKE '%��²%'
                          OR tmpMI.GoodsName ILIKE '%���%' THEN zfCalc_Color (147, 112, 219)     --������� ���������� ������
                        WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) > 0.10 THEN 12319924    --������ - ���������- ���� ����������
                        WHEN ((AVGIncome.AVGIncomePrice - COALESCE (tmpMI.Price,0)) / NULLIF(tmpMI.Price,0)) < - 0.10 THEN 14211071 --11315967--15781886 --16296444  --������ ������� -- ������-������� - ����������
                        WHEN COALESCE(OrderSheduleListToday.DOW,  0) <> 0 THEN 12910591      -- ������ ������
                        ELSE zc_Color_White()
                   END
              END  AS SupplierFailuresColor

           , COALESCE (tmpGoodsSPRegistry_1303.GoodsId, 0) <> 0                                                  AS isSPRegistry_1303
           , Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2)::TFloat                                          AS PriceOOC1303
           , CASE WHEN Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2) > 0 AND tmpMI.Price  > 0
             THEN ((1.0 - tmpMI.Price / Round(tmpGoodsSPRegistry_1303.PriceOptSP * 1.1, 2)) * 100)
             ELSE 0 END::TFloat AS DPriceOOC1303

       FROM tmpData AS tmpMI
            LEFT JOIN tmpPriceView AS Object_Price_View ON tmpMI.GoodsId                    = Object_Price_View.GoodsId
            LEFT JOIN tmpRemains   AS Remains           ON Remains.ObjectId                 = tmpMI.GoodsId
            LEFT JOIN tmpIncome    AS Income            ON Income.Income_GoodsId            = tmpMI.GoodsId
            LEFT JOIN tmpGoodsConditionsKeep            ON tmpGoodsConditionsKeep.GoodsId   = tmpMI.GoodsId
            LEFT JOIN tmpGoodsMain                      ON tmpGoodsMain.GoodsId             = tmpMI.GoodsId
            LEFT JOIN OrderSheduleList                  ON OrderSheduleList.ContractId      = tmpMI.ContractId
            LEFT JOIN OrderSheduleListToday             ON OrderSheduleListToday.ContractId = tmpMI.ContractId
            LEFT JOIN tmpCheck                          ON tmpCheck.GoodsId                 = tmpMI.GoodsId
            LEFT JOIN tmpSend                           ON tmpSend.GoodsId                  = tmpMI.GoodsId
            LEFT JOIN tmpSendSun                        ON tmpSendSun.GoodsId               = tmpMI.GoodsId
            LEFT JOIN tmpDeferred                       ON tmpDeferred.GoodsId              = tmpMI.GoodsId
            LEFT JOIN tmpReserve                        ON tmpReserve.GoodsId               = tmpMI.GoodsId
            LEFT JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.MovementItemId     = tmpMI.Id

            LEFT JOIN GoodsPromo ON GoodsPromo.JuridicalId = tmpMI.JuridicalId
                                AND GoodsPromo.GoodsId     = tmpMI.GoodsId
            -- ���������� �� �������� �� �������. ���. �� ����� �������������
            LEFT JOIN (SELECT DISTINCT GoodsPromo.GoodsId FROM GoodsPromo) AS GoodsPromoAll ON GoodsPromoAll.GoodsId = tmpMI.GoodsId


            --LEFT JOIN tmpOrderLast_2days ON tmpOrderLast_2days.GoodsId = tmpMI.GoodsId
            --LEFT JOIN tmpOrderLast_10    ON tmpOrderLast_10.GoodsId    = tmpMI.GoodsId
            --LEFT JOIN tmpRepeat          ON tmpRepeat.GoodsId          = tmpMI.GoodsId
            LEFT JOIN tmpJuridicalArea   ON tmpJuridicalArea.JuridicalId = tmpMI.JuridicalId

            -- �������� ����
            LEFT JOIN tmpObjectLink_Object AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
                                 AND ObjectLink_Object.DescId = zc_ObjectLink_Goods_Object()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId
            --������� ����
            LEFT JOIN AVGIncome ON AVGIncome.ObjectId = tmpMI.GoodsId
            LEFT JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpLoadPriceList_NDS ON tmpLoadPriceList_NDS.PartnerGoodsId = tmpMI.PartnerGoodsId
                                          AND tmpLoadPriceList_NDS.JuridicalId = tmpMI.JuridicalId

            LEFT JOIN tmpFinalSUAList ON tmpFinalSUAList.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpLayoutAll ON tmpLayoutAll.GoodsId = tmpMI.GoodsId


/*            LEFT JOIN tmpObjectLink_Area AS ObjectLink_Goods_Area
                                 ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId    */

            LEFT JOIN tmpSupplierFailures AS SupplierFailures
                                          ON SupplierFailures.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpGoodsSPRegistry_1303 ON tmpGoodsSPRegistry_1303.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpGoodsDiscountJuridical ON tmpGoodsDiscountJuridical.GoodsMainId = tmpGoodsMain.GoodsMainId
                                               AND tmpGoodsDiscountJuridical.JuridicalId = tmpMI.JuridicalId
        ;
           
--raise notice 'Value 4: %', CLOCK_TIMESTAMP();

  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_OrderInternal_Master (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 26.01.21                                                                    * ���������� ���������
 12.05.20         *
 20.09.19                                                                    * ������ �� ��� ���������
 24.04.19         *
 16.04.18                                                                    * �����������
 11.02.19         * ������� ������ ���-������ ����� � ���������
 07.02.19         * ���� isBonusClose = true ������ �� ���������
 02.11.18         *
 19.10.18         * isPriceClose ������ �� isPriceCloseOrder
 10.09.18         * add Remains_Diff --�� ������� � ������ �����. �����
 31.08.18         * add Reserved
 09.04.18                                                                    * �����������
 02.10.17         * add area
 12.09.17         *
 04.08.17         *
 09.04.17         * �����������
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


-- ���� select * from gpSelect_MovementItem_OrderInternal_Master(inMovementId := 18820132 , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'FALSE' ,  inSession := '7564573');

-- select * from gpSelect_MovementItem_OrderInternal_Master(inMovementId := 22029712   , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := '3');

-- select * from gpSelect_MovementItem_OrderInternal_Master(inMovementId := 22630094  , inShowAll := 'True' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := '3');

--select * from gpSelect_MovementItem_OrderInternal_Master(inMovementId := 26893369    , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := '3') order by GoodsId;


select * from gpSelect_MovementItem_OrderInternal_Master(inMovementId := 30645729 , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := '3');
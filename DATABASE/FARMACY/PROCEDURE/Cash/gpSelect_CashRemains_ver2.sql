-- Function: gpSelect_CashRemains_ver2()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_ver2(
    IN inCashSessionId TVarChar,   -- ������ ��������� �����
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId_main Integer, GoodsGroupName TVarChar, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, PriceSP TFloat, PriceSaleSP TFloat, DiffSP1 TFloat, DiffSP2 TFloat, Reserved TFloat, MCSValue TFloat,
               AlternativeGroupId Integer, NDS TFloat,
               isFirst boolean, isSecond boolean, Color_calc Integer,
               isPromo boolean,
               isSP boolean,
               IntenalSPName TVarChar,
               MinExpirationDate TDateTime,
               PartionDateKindId  Integer,
               PartionDateKindName  TVarChar,
               Color_ExpirationDate Integer,
               ConditionsKeepName TVarChar,
               AmountIncome TFloat, PriceSaleIncome TFloat,
               MorionCode Integer, BarCode TVarChar,
               MCSValueOld TFloat,
               StartDateMCSAuto TDateTime, EndDateMCSAuto TDateTime,
               isMCSAuto Boolean, isMCSNotRecalcOld Boolean,
               AccommodationId Integer, AccommodationName TVarChar,
               PriceChange TFloat, FixPercent TFloat, FixDiscount TFloat, Multiplicity TFloat,
               DoesNotShare boolean, GoodsAnalogId Integer, GoodsAnalogName TVarChar, 
               GoodsAnalog TVarChar, GoodsAnalogATC TVarChar, GoodsActiveSubstance TVarChar,
               CountSP TFloat, IdSP TVarChar, DosageIdSP TVarChar, PriceRetSP TFloat, PaymentSP TFloat,
               AmountMonth TFloat, PricePartionDate TFloat,
               PartionDateDiscount TFloat,
               NotSold boolean, NotSold60 boolean,
               DeferredSend TFloat,
               RemainsSUN TFloat

             , PartionDateKindId_check   Integer
             , Price_check               TFloat
             , PriceWithVAT_check        TFloat
             , PartionDateDiscount_check TFloat
             , NotTransferTime boolean
             , NDSKindId Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;

   DECLARE vbOperDate_StartBegin TDateTime;
   DECLARE vb1 TVarChar;
   DECLARE vb2 TVarChar;

   DECLARE vbDay_6  Integer;
   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbDividePartionDate   boolean;

   DECLARE vbAreaId   Integer;
BEGIN
-- if inSession = '3' then return; end if;

    -- !!!�������� - ������� ��������!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    -- ��� �����
    -- IF inSession = '3' then vbUnitId:= 1781716; END IF;

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
    -- ���� + 6 �������
    SELECT CURRENT_DATE + tmp.Date_6, tmp.Day_6
           INTO vbDate_6, vbDay_6
    FROM (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                            , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                       FROM Object  AS Object_PartionDateKind
                            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                  ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                 AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                       WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                      )
          SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL AS Date_6
               , tmp.Value AS Day_6
          FROM tmp
         ) AS tmp;
    -- ���� + 1 �����
    vbDate_1:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- ���� + 0 �������
    vbDate_0:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );


    IF EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
              WHERE ObjectBoolean_DividePartionDate.ObjectId = vbUnitId
                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate())
    THEN

      SELECT COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)
      INTO vbDividePartionDate
      FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
      WHERE ObjectBoolean_DividePartionDate.ObjectId = vbUnitId
        AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate();

    ELSE
      vbDividePartionDate := False;
    END IF;

    -- �������� ����� ������ ��������� ����� / �������� ���� ���������� ���������
    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );

    -- �������� ���������� SnapShot ������
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;

    -- ������
    --������ �������
    INSERT INTO CashSessionSnapShot(CashSessionId,ObjectId,NDSKindId,PartionDateKindId,Price,Remains,MCSValue,Reserved,DeferredSend,MinExpirationDate,AccommodationId,PartionDateDiscount,PriceWithVAT
    )
    SELECT inCashSessionId                                                  AS CashSession
          , CashRemains.GoodsId
          , CashRemains.NDSKindId
          , CashRemains.PartionDateKindId
          , CashRemains.Price
          , CashRemains.Remains
          , CashRemains.MCSValue
          , CashRemains.Reserved
          , CashRemains.DeferredSend
          , CashRemains.MinExpirationDate
          , CashRemains.AccommodationId
          , CashRemains.PartionDateDiscount
          , CashRemains.PriceWithVAT
    FROM gpSelect_CashRemains_CashSession(inSession) AS CashRemains;

    RETURN QUERY
      WITH -- ������ ���-������
           tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                               , MI_IntenalSP.ObjectId         AS IntenalSPId
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_PaymentSP.ValueData   AS PaymentSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIString_IdSP.ValueData       AS IdSP
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
                               -- DosageID ���������� ������
                               LEFT JOIN MovementItemString AS MIString_DosageIdSP
                                                            ON MIString_DosageIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_DosageIdSP.DescId = zc_MIString_DosageIdSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )
         , GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- ����� ����� "����"
                         --   , tmp.ChangePercent
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
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
                       )
                -- ����� � ���� - ������������� ������� �������
                , tmpIncome AS (SELECT MI_Income.ObjectId                      AS GoodsId
                                     , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome
                                     , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale
                                FROM Movement AS Movement_Income
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = vbUnitId

                                     LEFT JOIN MovementItem AS MI_Income
                                                            ON MI_Income.MovementId = Movement_Income.Id
                                                           AND MI_Income.isErased   = False

                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                 ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                                 WHERE Movement_Income.DescId = zc_Movement_Income()
                                   AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                                   -- AND date_trunc('day', Movement_Income.OperDate) = CURRENT_DATE
	                                 GROUP BY MI_Income.ObjectId
                                        , MovementLinkObject_To.ObjectId
                              )
           -- ���� �������
         , tmpGoodsMorion AS (SELECT ObjectLink_Main_Morion.ChildObjectId  AS GoodsMainId
                                   , MAX (Object_Goods_Morion.ObjectCode)  AS MorionCode
                              FROM ObjectLink AS ObjectLink_Main_Morion
                                   JOIN ObjectLink AS ObjectLink_Child_Morion
                                                   ON ObjectLink_Child_Morion.ObjectId = ObjectLink_Main_Morion.ObjectId
                                                  AND ObjectLink_Child_Morion.DescId = zc_ObjectLink_LinkGoods_Goods()
                                   JOIN ObjectLink AS ObjectLink_Goods_Object_Morion
                                                   ON ObjectLink_Goods_Object_Morion.ObjectId = ObjectLink_Child_Morion.ChildObjectId
                                                  AND ObjectLink_Goods_Object_Morion.DescId = zc_ObjectLink_Goods_Object()
                                                  AND ObjectLink_Goods_Object_Morion.ChildObjectId = zc_Enum_GlobalConst_Marion()
                                   LEFT JOIN Object AS Object_Goods_Morion ON Object_Goods_Morion.Id = ObjectLink_Goods_Object_Morion.ObjectId
                              WHERE ObjectLink_Main_Morion.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                AND ObjectLink_Main_Morion.ChildObjectId > 0
                              GROUP BY ObjectLink_Main_Morion.ChildObjectId
                             )
           -- �����-���� �������������
         , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
                                    , string_agg(Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc)           AS BarCode
                               FROM ObjectLink AS ObjectLink_Main_BarCode
                                    JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                    ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                   AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                    JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                    ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                   AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                    LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                               WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                 AND ObjectLink_Main_BarCode.ChildObjectId > 0
                                 AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                               GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                              )
              -- ������ �� ������
              , tmpObject_Price AS (SELECT ObjectLink_Price_Unit.ObjectId                                AS Id
                                         , Price_Goods.ChildObjectId                                     AS GoodsId
                                         , COALESCE(Price_MCSValueOld.ValueData,0)          ::TFloat     AS MCSValueOld
                                         , MCS_StartDateMCSAuto.ValueData                                AS StartDateMCSAuto
                                         , MCS_EndDateMCSAuto.ValueData                                  AS EndDateMCSAuto
                                         , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
                                         , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
                                    FROM ObjectLink AS ObjectLink_Price_Unit
                                         INNER JOIN ObjectLink AS Price_Goods
                                                               ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                         LEFT JOIN ObjectFloat AS Price_MCSValueOld
                                                               ON Price_MCSValueOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                              AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
                                         LEFT JOIN ObjectDate AS MCS_StartDateMCSAuto
                                                              ON MCS_StartDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                             AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                                         LEFT JOIN ObjectDate AS MCS_EndDateMCSAuto
                                                              ON MCS_EndDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                             AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
                                         LEFT JOIN ObjectBoolean AS Price_MCSAuto
                                                                 ON Price_MCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                                         LEFT JOIN ObjectBoolean AS Price_MCSNotRecalcOld
                                                                 ON Price_MCSNotRecalcOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
                                    WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                      AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                    )
                -- MCS - Auto
              , tmpMCSAuto AS (SELECT DISTINCT
                                      CashSessionSnapShot.ObjectId
                                    , tmpObject_Price.MCSValueOld
                                    , tmpObject_Price.StartDateMCSAuto
                                    , tmpObject_Price.EndDateMCSAuto
                                    , tmpObject_Price.isMCSAuto
                                    , tmpObject_Price.isMCSNotRecalcOld
                               FROM CashSessionSnapShot
                                    INNER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = CashSessionSnapShot.ObjectId
                               WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
                              )
                -- ���� �� �������
              , tmpPriceChange AS (SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId                             AS GoodsId
                                        , COALESCE (PriceChange_Value_Unit.ValueData, PriceChange_Value_Retail.ValueData) AS PriceChange
                                        , COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData)::TFloat           AS FixPercent
                                        , COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData)::TFloat           AS FixDiscount
                                        , COALESCE (PriceChange_Multiplicity_Unit.ValueData, PriceChange_Multiplicity_Retail.ValueData) ::TFloat AS Multiplicity
                                   FROM Object AS Object_PriceChange
                                        -- ������ �� �������
                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Unit
                                                             ON ObjectLink_PriceChange_Unit.ObjectId = Object_PriceChange.Id
                                                            AND ObjectLink_PriceChange_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                                                            AND ObjectLink_PriceChange_Unit.ChildObjectId = vbUnitId
                                        -- ���� �� ������� �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_Value_Unit
                                                              ON PriceChange_Value_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_Value_Unit.DescId = zc_ObjectFloat_PriceChange_Value()
                                                             AND COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0
                                        -- ������� ������ �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Unit
                                                              ON PriceChange_FixPercent_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_FixPercent_Unit.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                                             AND COALESCE (PriceChange_FixPercent_Unit.ValueData, 0) <> 0
                                        -- ����� ������ �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Unit
                                                              ON PriceChange_FixDiscount_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_FixDiscount_Unit.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                                             AND COALESCE (PriceChange_FixDiscount_Unit.ValueData, 0) <> 0
                                        -- ��������� �������
                                        LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Unit
                                                              ON PriceChange_Multiplicity_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_Multiplicity_Unit.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                                             AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, 0) <> 0
                                        -- ������ �� ����
                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                                             ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                                            AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                                            AND ObjectLink_PriceChange_Retail.ChildObjectId = vbRetailId
                                        -- ���� �� ������� �� ����
                                        LEFT JOIN ObjectFloat AS PriceChange_Value_Retail
                                                              ON PriceChange_Value_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                             AND PriceChange_Value_Retail.DescId = zc_ObjectFloat_PriceChange_Value()
                                                             AND COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0
                                        -- ������� ������ �� ����.
                                        LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Retail
                                                              ON PriceChange_FixPercent_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                             AND PriceChange_FixPercent_Retail.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                                             AND COALESCE (PriceChange_FixPercent_Retail.ValueData, 0) <> 0
                                        -- ����� ������ �� ����.
                                        LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Retail
                                                              ON PriceChange_FixDiscount_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                             AND PriceChange_FixDiscount_Retail.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                                             AND COALESCE (PriceChange_FixDiscount_Retail.ValueData, 0) <> 0
                                        -- ��������� ������� �� ����.
                                        LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Retail
                                                              ON PriceChange_Multiplicity_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                             AND PriceChange_Multiplicity_Retail.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                                             AND COALESCE (PriceChange_Multiplicity_Retail.ValueData, 0) <> 0

                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                             ON ObjectLink_PriceChange_Goods.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                            AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()

                                   WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                                     AND Object_PriceChange.isErased = FALSE
                                     AND (COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0 OR COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0 OR
                                         COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData, 0) <> 0 OR
                                         COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData, 0) <> 0) -- �������� ������ ���� <> 0
                                  )
              , tmpPartionDateKind AS (SELECT Object_PartionDateKind.Id           AS Id
                                            , Object_PartionDateKind.ObjectCode   AS Code
                                            , Object_PartionDateKind.ValueData    AS Name
                                            , COALESCE (ObjectFloatDay.ValueData / 30, 0) :: TFLoat AS AmountMonth
                                       FROM Object AS Object_PartionDateKind
                                            LEFT JOIN ObjectFloat AS ObjectFloatDay
                                                                  ON ObjectFloatDay.ObjectId = Object_PartionDateKind.Id
                                                                 AND ObjectFloatDay.DescId = zc_ObjectFloat_PartionDateKind_Day()
                                       WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind()
                                      )
               , tmpContainerAll AS (SELECT Container.ID
                                          , Container.ObjectId       AS GoodsID
                                          , Container.Amount
                                     FROM Container
                                     WHERE Container.DescId = zc_Container_Count()
                                       AND Container.WhereObjectId = vbUnitId
                                       AND Container.Amount > 0
                                     )
               , tmpContainerIn AS (SELECT Container.ID
                                         , Container.GoodsID
                                         , Container.Amount
                                         , Container.Amount - COALESCE(SUM(MovementItemContainer.Amount), 0) AS AmountIn
                                         , SUM(CASE WHEN MovementItemContainer.MovementDescId = zc_Movement_Check() THEN 1 ELSE 0 END) AS Check
                                    FROM tmpContainerAll as Container
                                         LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerID = Container.ID
                                                                         AND MovementItemContainer.OperDate >= CURRENT_DATE - ('100 DAY')::INTERVAL
                                    GROUP BY Container.ID, Container.GoodsID, Container.Amount
                                    )
               , tmpContainer AS (SELECT Container.GoodsID        AS GoodsID
                                       , SUM(Container.Amount)    AS Amount
                                       , SUM(Container.AmountIn)  AS AmountIn
                                       , SUM(Container.Check)     AS Check
                                  FROM tmpContainerIn as Container
                                  GROUP BY Container.GoodsID
                                 )
               , tmpMovementItemCheck AS (SELECT MovementItemContainer.ObjectId_Analyzer          AS GoodsID
                                               , COUNT(1)                                         AS Check
                                          FROM MovementItemContainer
                                          WHERE MovementItemContainer.MovementDescId = zc_Movement_Check()
                                            AND MovementItemContainer.WhereObjectId_Analyzer = vbUnitId
                                            AND MovementItemContainer.OperDate >= CURRENT_DATE - ('100 DAY')::INTERVAL
                                          GROUP BY MovementItemContainer.ObjectId_Analyzer)
               , tmpNotSold AS (SELECT Container.GoodsID
                                FROM tmpContainer AS Container
                                     LEFT OUTER JOIN tmpMovementItemCheck ON tmpMovementItemCheck.GoodsID = Container.GoodsID
                                WHERE Container.Amount > 0 AND Container.AmountIn > 0
                                  AND (Container.Check + COALESCE(tmpMovementItemCheck.Check, 0)) = 0
                                )
                 -- ��� ����������� �� ���
                ,tmpSendAll AS (SELECT DISTINCT Movement.Id AS MovementId
                                FROM Movement

                                     INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = Movement.Id
                                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()


                                WHERE Movement.DescId = zc_Movement_Send()
                                  AND COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                )
                   -- ����������� �� ��� �������� ����������
                 , tmpRenainsSUNCount AS (SELECT Container.Id
                                               , Container.ObjectId
                                               , SUM(Container.Amount) AS Amount
                                          FROM tmpSendAll AS Movement

                                               INNER JOIN MovementItem ON MovementItem.MovementId =  Movement.MovementId
                                                                      AND MovementItem.DescId = zc_MI_Child()

                                               INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.MovementId
                                                                               AND MovementItemContainer.MovementItemId = MovementItem.Id
                                                                               AND MovementItemContainer.DescId = zc_Container_Count()
                                                                               AND MovementItemContainer.isActive = TRUE

                                               INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                                   AND Container.WhereObjectId = vbUnitId

                                          WHERE Container.Amount <> 0
                                          GROUP BY Container.Id, Container.ObjectId
                                          )
                   -- ����������� �� ��� ������ �����
                 , tmpRenainsSUNAll AS (SELECT Container.Id                                       AS ID
                                          , Container.ObjectId                                 AS GoodsID
                                          , Container.Amount                                   AS Amount
                                          , ContainerPD.Id                                     AS PDID
                                          , ContainerPD.Amount                                 AS AmountPD
                                          , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                      COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                       THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 ��� (��������� ��� �������)
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- ����������
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- ������ 1 ������
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- ������ 6 ������
                                                 ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- ����������� � ���������
                                     FROM tmpRenainsSUNCount AS Container

                                          LEFT JOIN Container AS ContainerPD
                                                              ON ContainerPD.ParentId = Container.Id
                                                             AND ContainerPD.DescId = zc_Container_CountPartionDate()

                                          LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = ContainerPD.Id
                                                                       AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                          LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                               ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                              AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                                  ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                                 AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                      )
                   -- ����������� �� ��� �������
                 , tmpRenainsSUN AS (SELECT Container.GoodsID                                   AS GoodsID
                                          , COALESCE(Container.PartionDateKindId, 0)            AS PartionDateKindId
                                          , SUM(COALESCE(Container.AmountPD, Container.Amount)) AS Amount
                                     FROM tmpRenainsSUNAll AS Container

                                     GROUP BY Container.GoodsID, COALESCE(Container.PartionDateKindId, 0)
                                      )
                   -- ��� ������� �� ��������� 60 ����
                 , tmpIlliquidUnit AS (SELECT * FROM lpReport_IlliquidReductionPlanUser(inUserID := vbUserId))

                 , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                       , ObjectFloat_NDSKind_NDS.ValueData
                                 FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                 WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                )

        -- ���������
        SELECT
            Goods.Id,
            ObjectLink_Main.ChildObjectId AS GoodsId_main,
            Object_GoodsGroup.ValueData   AS GoodsGroupName,
            Goods.ValueData,
            Goods.ObjectCode,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.Price,

            --
            -- ���� �� ������� ��� ��
            --
            CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- �� 0, �.�. ���� ������� = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- �� 0, �.�. ���� ������ ��� ���� ����������

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� �������

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- ����� ������ ���� ������� "��������� � �������"

            END :: TFloat AS PriceSP,


            --
            -- ���� ��� ������ ��� ��
            --
            CASE WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� ����������

                 /*WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� ���������� + ���� ������� "��������� � �������"

                 ELSE COALESCE (tmpGoodsSP.PriceSP, 0)           -- ����� ������ ���� ����������
                    + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- ���� ���� ������� "��������� � �������"
*/
                 ELSE

            CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- �� 0, �.�. ���� ������� = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- �� 0, �.�. ���� ������ ��� ���� ����������

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� �������

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- ����� ������ ���� ������� "��������� � �������"

            END
          + COALESCE (tmpGoodsSP.PriceSP, 0)

            END :: TFloat AS PriceSaleSP,

            -- �������� ��� ��������1
           (CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN 0 ELSE
            COALESCE (CashSessionSnapShot.Price, 0)
          - CASE WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� ����������

                 ELSE
            CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- �� 0, �.�. ���� ������� = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- �� 0, �.�. ���� ������ ��� ���� ����������

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� �������

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- ����� ������ ���� ������� "��������� � �������"

            END
          + COALESCE (tmpGoodsSP.PriceSP, 0)


            END
            END
            -- COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
            ) :: TFloat AS DiffSP1,

            -- �������� ��� ��������2
           (CASE WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� ����������

                 ELSE

            CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- �� 0, �.�. ���� ������� = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- �� 0, �.�. ���� ������ ��� ���� ����������

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� �������

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- ����� ������ ���� ������� "��������� � �������"

            END
          + COALESCE (tmpGoodsSP.PriceSP, 0)

            END

          - CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- �� 0, �.�. ���� ������� = 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- �� 0, �.�. ���� ������ ��� ���� ����������

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- �� ����� ����, �.�. ��� ������ ��� ���� �������

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"
                      THEN 0

                 WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "��������� � �������" � ���� ������� �������� �� ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
                           ) -- ������� � ����� ���������� � "��������� � �������"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- ����� ������ ���� ������� "��������� � �������"

            END
           ) :: TFloat AS DiffSP2,

            NULLIF (CashSessionSnapShot.Reserved, 0) :: TFloat AS Reserved,
            CashSessionSnapShot.MCSValue,
            Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId,
            ObjectFloat_NDSKind_NDS.ValueData AS NDS,
            COALESCE(ObjectBoolean_First.ValueData, False)          AS isFirst,
            COALESCE(ObjectBoolean_Second.ValueData, False)         AS isSecond,
            CASE WHEN COALESCE(ObjectBoolean_Second.ValueData, False) = TRUE THEN 16440317 WHEN COALESCE(ObjectBoolean_First.ValueData, False) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc,
            CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo,
            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END :: Boolean  AS isSP,
            Object_IntenalSP.ValueData AS IntenalSPName,
            CashSessionSnapShot.MinExpirationDate,
            NULLIF (CashSessionSnapShot.PartionDateKindId, 0)  AS PartionDateKindId,
            Object_PartionDateKind.Name                        AS PartionDateKindName,
            CASE WHEN vbDividePartionDate = False
              THEN
                CASE WHEN CashSessionSnapShot.MinExpirationDate < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Red() ELSE zc_Color_Black() END
              ELSE
                CASE CashSessionSnapShot.PartionDateKindId WHEN zc_Enum_PartionDateKind_0() THEN zc_Color_Red()
                                                           WHEN zc_Enum_PartionDateKind_1() THEN 36095
                                                           WHEN zc_Enum_PartionDateKind_6() THEN zc_Color_Blue()
                                                           WHEN zc_Enum_PartionDateKind_Cat_5() THEN 32768
                                                           ELSE zc_Color_Black() END END::Integer                     AS Color_ExpirationDate,
            COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName,

            COALESCE(tmpIncome.AmountIncome,0)            :: TFloat   AS AmountIncome,
            CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE(tmpIncome.SummSale,0) / COALESCE(tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome,
            COALESCE (tmpGoodsMorion.MorionCode, 0) :: Integer  AS MorionCode,
            COALESCE (tmpGoodsBarCode.BarCode, '')  :: TVarChar AS BarCode

          , tmpMCSAuto.MCSValueOld
          , tmpMCSAuto.StartDateMCSAuto
          , tmpMCSAuto.EndDateMCSAuto
          , tmpMCSAuto.isMCSAuto
          , tmpMCSAuto.isMCSNotRecalcOld
          , CashSessionSnapShot.AccommodationId
          , Object_Accommodation.ValueData AS AccommodationName
          , tmpPriceChange.PriceChange
          , tmpPriceChange.FixPercent
          , tmpPriceChange.FixDiscount
          , tmpPriceChange.Multiplicity
          , COALESCE (ObjectBoolean_DoesNotShare.ValueData, FALSE) AS DoesNotShare
          , NULL::Integer                                          AS GoodsAnalogId
          , NULL::TVarChar                                         AS GoodsAnalogName
          , ObjectString_Goods_Analog.ValueData                    AS GoodsAnalog
          , ObjectString_Goods_AnalogATC.ValueData                 AS GoodsAnalogATC
          , ObjectString_Goods_ActiveSubstance.ValueData           AS GoodsActiveSubstance
          , tmpGoodsSP.CountSP                                     AS CountSP
          , tmpGoodsSP.IdSP                                        AS IdSP
          , tmpGoodsSP.DosageIdSP                                  AS DosageIdSP
          , tmpGoodsSP.PriceRetSP                                  AS PriceRetSP
          , tmpGoodsSP.PaymentSP                                   AS PaymentSP
          , CASE CashSessionSnapShot.PartionDateKindId
            WHEN zc_Enum_PartionDateKind_Good() THEN vbDay_6 / 30.0 + 1.0
            WHEN zc_Enum_PartionDateKind_Cat_5() THEN vbDay_6 / 30.0 - 1.0
            ELSE Object_PartionDateKind.AmountMonth END::TFloat AS AmountMonth
          , CASE CashSessionSnapShot.PartionDateKindId
                 WHEN zc_Enum_PartionDateKind_0() THEN ROUND(CashSessionSnapShot.Price * (100.0 - CashSessionSnapShot.PartionDateDiscount) / 100, 2)
                 WHEN zc_Enum_PartionDateKind_1() THEN ROUND(CashSessionSnapShot.Price * (100.0 - CashSessionSnapShot.PartionDateDiscount) / 100, 2)
                 WHEN zc_Enum_PartionDateKind_6() THEN
                     CASE WHEN CashSessionSnapShot.Price > CashSessionSnapShot.PriceWithVAT
                          THEN ROUND(CashSessionSnapShot.Price - (CashSessionSnapShot.Price - CashSessionSnapShot.PriceWithVAT) *
                                     CashSessionSnapShot.PartionDateDiscount / 100, 2)
                          ELSE CashSessionSnapShot.Price
                     END
                 WHEN zc_Enum_PartionDateKind_Cat_5() THEN
                     CASE WHEN CashSessionSnapShot.Price > CashSessionSnapShot.PriceWithVAT
                          THEN ROUND(CashSessionSnapShot.Price - (CashSessionSnapShot.Price - CashSessionSnapShot.PriceWithVAT) *
                                     CashSessionSnapShot.PartionDateDiscount / 100, 2)
                          ELSE CashSessionSnapShot.Price
                     END
                 ELSE NULL
            END                                          :: TFloat AS PricePartionDate
          , CashSessionSnapShot.PartionDateDiscount                AS PartionDateDiscount
          , COALESCE(tmpNotSold.GoodsID, 0) <> 0                   AS NotSold
          , COALESCE(tmpIlliquidUnit.GoodsID, 0) <> 0              AS NotSold60
          , CashSessionSnapShot.DeferredSend::TFloat               AS DeferredSend
          , tmpRenainsSUN.Amount::TFloat                           AS RemainsSUN


          , CashSessionSnapShot.PartionDateKindId   AS PartionDateKindId_check
          , CashSessionSnapShot.Price               AS Price_check
          , CashSessionSnapShot.PriceWithVAT        AS PriceWithVAT_check
          , CashSessionSnapShot.PartionDateDiscount AS PartionDateDiscount_check

          , COALESCE (ObjectBoolean_Goods_NotTransferTime.ValueData, False)      AS NotTransferTime
          , COALESCE(CashSessionSnapShot.NDSKindId, ObjectLink_Goods_NDSKind.ChildObjectId) AS NDSKindId

         FROM
            CashSessionSnapShot
            INNER JOIN Object AS Goods ON Goods.Id = CashSessionSnapShot.ObjectId
            LEFT JOIN tmpMCSAuto ON tmpMCSAuto.ObjectId = CashSessionSnapShot.ObjectId
            LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                       ON Link_Goods_AlternativeGroup.ObjectId = Goods.Id
                                      AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                       ON ObjectLink_Goods_NDSKind.ObjectId = Goods.Id
                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
            LEFT OUTER JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                       ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE(CashSessionSnapShot.NDSKindId, ObjectLink_Goods_NDSKind.ChildObjectId)

            LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                    ON ObjectBoolean_First.ObjectId = Goods.Id
                                   AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                    ON ObjectBoolean_Second.ObjectId = Goods.Id
                                   AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Goods.Id
            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = Goods.Id

            -- ���������� GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Goods.Id
                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            -- ��� ������
            LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
                                AND tmpGoodsSP.Ord     = 1 -- � �/� - �� ������ ������
            LEFT JOIN  Object AS Object_IntenalSP ON Object_IntenalSP.Id = tmpGoodsSP.IntenalSPId

            -- ������� ��������
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Goods.Id
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
            --
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
            -- �����-��� �������������
            LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
            -- ��� �������
            LEFT JOIN tmpGoodsMorion ON tmpGoodsMorion.GoodsMainId = ObjectLink_Main.ChildObjectId
            -- ���������� ������
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = CashSessionSnapShot.AccommodationId
            -- ���� �� �������
            LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = Goods.Id
            -- �� ������ ���������� �� ������
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DoesNotShare
                                    ON ObjectBoolean_DoesNotShare.ObjectId = Goods.Id
                                   AND ObjectBoolean_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()

           -- ������� ������
           LEFT JOIN ObjectString AS ObjectString_Goods_Analog
                                  ON ObjectString_Goods_Analog.ObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectString_Goods_Analog.DescId = zc_ObjectString_Goods_Analog()
           LEFT JOIN ObjectString AS ObjectString_Goods_AnalogATC
                                  ON ObjectString_Goods_AnalogATC.ObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectString_Goods_AnalogATC.DescId = zc_ObjectString_Goods_AnalogATC()
           LEFT JOIN ObjectString AS ObjectString_Goods_ActiveSubstance
                                  ON ObjectString_Goods_ActiveSubstance.ObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectString_Goods_ActiveSubstance.DescId = zc_ObjectString_Goods_ActiveSubstance()

           -- ��� ����/�� ����
           LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = NULLIF (CashSessionSnapShot.PartionDateKindId, 0)

           -- ��� ������� �� ��������� 100 ����
           LEFT JOIN tmpNotSold ON tmpNotSold.GoodsID = Goods.Id

           -- ��� ������� �� ��������� 60 ����
           LEFT JOIN tmpIlliquidUnit ON tmpIlliquidUnit.GoodsID = Goods.Id

           -- ������� ������ �� ���
           LEFT JOIN tmpRenainsSUN ON tmpRenainsSUN.GoodsID = CashSessionSnapShot.ObjectId
                                  AND tmpRenainsSUN.PartionDateKindId = CashSessionSnapShot.PartionDateKindId

           -- �� ��������� � �����
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_NotTransferTime
                                   ON ObjectBoolean_Goods_NotTransferTime.ObjectId = CashSessionSnapShot.ObjectId
                                  AND ObjectBoolean_Goods_NotTransferTime.DescId = zc_ObjectBoolean_Goods_NotTransferTime()


        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
        ORDER BY
            Goods.Id;

    vb1:= (SELECT COUNT (*) FROM CashSessionSnapShot WHERE CashSessionSnapShot.CashSessionId = inCashSessionId) :: TVarChar;
    vb2:= ((CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: INTERVAL) :: TVarChar;

    -- !!!�������� - ������� ��������!!!
    INSERT INTO Log_Reprice (InsertDate, StartDate, EndDate, MovementId, UserId, TextValue)
      VALUES (CURRENT_TIMESTAMP, vbOperDate_StartBegin, CLOCK_TIMESTAMP(), vbUnitId, vbUserId
            , vb2
    || ' '   || REPEAT ('0', 8 - LENGTH (vb1)) || vb1 || '-1'
    || ' '   || lfGet_Object_ValueData_sh (vbUnitId)
    || ' + ' || lfGet_Object_ValueData_sh (vbUserId)
    || ','   || vbUnitId              :: TVarChar
    || ','   || CHR (39) || inCashSessionId || CHR (39)
             );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_ver2 (TVarChar, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.  �������� �.�.  ������ �.�.
 19.02.20                                                                                                    *
 04.12.19                                                                                                    * FixDiscount
 23.09.19                                                                                                    * NotTransferTime
 15.07.19                                                                                                    *
 28.05.19                                                                                                    * PartionDateKindId
 13.05.19                                                                                                    *
 24.04.19                                                                                                    * Helsi
 04.04.19                                                                                                    * GoodsAnalog
 06.03.19                                                                                                    * DoesNotShare
 11.02.19                                                                                                    *
 30.10.18                                                                                                    *
 01.10.18         * tmpPriceChange - ���� ������ �������������
 21.06.17         *
 09.06.17         *
 24.05.17                                                                                      * MorionCode
 23.05.17                                                                                      * BarCode
 25.01.16         *
 24.01.17         * add ConditionsKeepName
 06.09.16         *
 12.04.16         *
 02.11.15                                                                       *NDS
 10.09.15                                                                       *CashSessionSnapShot
 22.08.15                                                                       *���������� ��� � ���������
 19.08.15                                                                       *CurrentMovement
 05.05.15                        *

*/

-- ����
-- SELECT * FROM gpSelect_CashRemains_ver2 ('{85E257DE-0563-4B9E-BE1C-4D5C123FB33A}-', '10411288')
-- SELECT * FROM gpSelect_CashRemains_ver2 ('{85E257DE-0563-4B9E-BE1C-4D5C123FB33A}-', '3998773') WHERE GoodsCode = 1240
-- SELECT * FROM gpSelect_CashRemains_ver2 ('{0B05C610-B172-4F81-99B8-25BF5385ADD6}', '3') -- where notsold = True
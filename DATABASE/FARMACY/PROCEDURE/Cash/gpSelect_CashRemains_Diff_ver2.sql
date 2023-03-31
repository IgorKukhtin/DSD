-- Function: gpSelect_CashRemains_Diff_ver2()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_Diff_ver2 (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Diff_ver2 (
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    Id Integer,
    GoodsCode Integer,
    GoodsName TVarChar,
    Price TFloat,
    Remains TFloat,
    MCSValue TFloat,
    Reserved TFloat,
    MinExpirationDate TDateTime,
    PartionDateKindId  Integer,  PartionDateKindName  TVarChar,
    NewRow Boolean,
    AccommodationId Integer,
    AccommodationName TVarChar,
    AmountMonth TFloat,
    PricePartionDate TFloat,
    Color_calc Integer,
    DeferredSend TFloat,
    RemainsSun TFloat,
    NDS TFloat,
    NDSKindId Integer,
    DiscountExternalID  Integer, DiscountExternalName  TVarChar,
    GoodsDiscountID  Integer, GoodsDiscountName  TVarChar,
    UKTZED TVarChar,
    GoodsPairSunId Integer,
    DivisionPartiesId  Integer,  DivisionPartiesName  TVarChar, isBanFiscalSale Boolean,
    isGoodsForProject boolean,
    GoodsPairSunMainId Integer,
    GoodsDiscountMaxPrice TFloat, 
    isGoodsPairSun Boolean, 
    GoodsPairSunAmount TFloat,
    GoodsDiscountProcentSite TFloat,
    DeferredTR TFloat,
    MorionCode Integer,
    PromoBonusPrice TFloat,
    PriceView TFloat,
    isAsinoMain Boolean, 
    isAsinoPresent Boolean
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbOperDate_StartBegin TDateTime;
-- DECLARE vb1 TVarChar;
-- DECLARE vb2 TVarChar;

   DECLARE vbDay_6  Integer;
   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbDividePartionDate Boolean;

   DECLARE vbPriceSamples TFloat;
   DECLARE vbSamples21 TFloat;
   DECLARE vbSamples22 TFloat;
   DECLARE vbSamples3 TFloat;

   DECLARE vbAreaId   Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbLanguage TVarChar;
BEGIN
-- if inSession = '3' then return; end if;


    -- !!!Протокол - отладка Скорости!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


/*    IF COALESCE((SELECT count(*) as CountProc
                 FROM pg_stat_activity
                 WHERE state = 'active'
                   AND query ilike '%gpSelect_CashRemains_Diff_ver2%'), 0) > 7
    THEN
      Return;
    END IF; */

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');
    
    -- проверяем регион пользователя
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inSession));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inSession));
    END IF;

    -- значения для разделения по срокам
    SELECT Day_6, Date_6, Date_3, Date_1, Date_0
    INTO vbDay_6, vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();
   
    SELECT COALESCE(ObjectFloat_CashSettings_PriceSamples.ValueData, 0)                          AS PriceSamples
         , COALESCE(ObjectFloat_CashSettings_Samples21.ValueData, 0)                             AS Samples21
         , COALESCE(ObjectFloat_CashSettings_Samples22.ValueData, 0)                             AS Samples22
         , COALESCE(ObjectFloat_CashSettings_Samples3.ValueData, 0)                              AS Samples3
    INTO vbPriceSamples, vbSamples21, vbSamples22, vbSamples3
    FROM Object AS Object_CashSettings

         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceSamples
                               ON ObjectFloat_CashSettings_PriceSamples.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_PriceSamples.DescId = zc_ObjectFloat_CashSettings_PriceSamples()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples21
                               ON ObjectFloat_CashSettings_Samples21.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples21.DescId = zc_ObjectFloat_CashSettings_Samples21()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples22
                               ON ObjectFloat_CashSettings_Samples22.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples22.DescId = zc_ObjectFloat_CashSettings_Samples22()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples3
                               ON ObjectFloat_CashSettings_Samples3.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples3.DescId = zc_ObjectFloat_CashSettings_Samples3()

    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;    
    
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

    SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
    INTO vbLanguage
    FROM Object AS Object_User
                 
         LEFT JOIN ObjectString AS ObjectString_Language
                ON ObjectString_Language.ObjectId = Object_User.Id
               AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
    WHERE Object_User.Id = vbUserId;    

    -- Обновили дату последнего обращения по сессии
    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );

    -- определяем разницу в остатках реальных и сессионных
    CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , Price     TFloat
                           , NDSKindId Integer
                           , Remains   TFloat
                           , MinExpirationDate TDateTime
                           , DiscountExternalID  Integer
                           , PartionDateKindId  Integer
                           , DivisionPartiesId  Integer
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , DeferredSend TFloat
                           , DeferredTR TFloat
                           , NewRow    Boolean
                           , AccommodationId Integer
                           , PartionDateDiscount TFloat
                           , PriceWithVAT TFloat) ON COMMIT DROP;

    --raise notice 'Value 0: %', CURRENT_TIMESTAMP;


    CREATE TEMP TABLE GoodsRemains ON COMMIT DROP AS 
	                     ( SELECT CashRemains.GoodsId                     AS ObjectId
                                , CashRemains.NDSKindId
                                , CashRemains.DiscountExternalID
                                , CashRemains.PartionDateKindId
                                , CashRemains.DivisionPartiesId
                                , CashRemains.Price
                                , CashRemains.Remains
                                , CashRemains.MCSValue
                                , CashRemains.Reserved
                                , CashRemains.DeferredSend
                                , CashRemains.DeferredTR
                                , CashRemains.MinExpirationDate
                                , CashRemains.AccommodationId
                                , CashRemains.PartionDateDiscount
                                , CashRemains.PriceWithVAT
                          FROM gpSelect_CashRemains_CashSession(inSession) AS CashRemains
                         );
						 
	ANALYSE GoodsRemains;

    --raise notice 'Value 1: %', CURRENT_TIMESTAMP;

                 -- состояние в сессии
    CREATE TEMP TABLE SESSIONDATA ON COMMIT DROP AS 
	                    (SELECT CashSessionSnapShot.ObjectId
                              , CashSessionSnapShot.NDSKindId
                              , CashSessionSnapShot.Price
                              , CashSessionSnapShot.Remains
                              , CashSessionSnapShot.MCSValue
                              , CashSessionSnapShot.Reserved
                              , CashSessionSnapShot.DeferredSend
                              , CashSessionSnapShot.DeferredTR
                              , CashSessionSnapShot.MinExpirationDate
                              , CashSessionSnapShot.DiscountExternalID
                              , CashSessionSnapShot.PartionDateKindId
                              , CashSessionSnapShot.DivisionPartiesId
                              , CashSessionSnapShot.AccommodationId
                              , CashSessionSnapShot.PartionDateDiscount
                              , CashSessionSnapShot.PriceWithVAT
                         FROM CashSessionSnapShot
                         WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
                        );
						
	ANALYSE SESSIONDATA;

    --raise notice 'Value 2: %', CURRENT_TIMESTAMP;
	
    CREATE TEMP TABLE tmpAsinoPharmaSP ON COMMIT DROP AS 
    SELECT * FROM gpSelect_AsinoPharmaSPAllGoods_Cash(inSession := '3');

    ANALYZE tmpAsinoPharmaSP;

    -- Данные
    WITH
         tmpDiff AS (SELECT GoodsRemains.ObjectId                                             AS ObjectId
                           , GoodsRemains.Price                                               AS Price
                           , GoodsRemains.NDSKindId                                           AS NDSKindId
                           , GoodsRemains.MCSValue                                            AS MCSValue
                           , GoodsRemains.Remains                                             AS Remains
                           , GoodsRemains.Reserved                                            AS Reserved
                           , GoodsRemains.DeferredSend                                        AS DeferredSend
                           , GoodsRemains.DeferredTR                                          AS DeferredTR
                           , CASE WHEN SESSIONDATA.ObjectId IS NULL
                                       THEN TRUE
                                   ELSE FALSE
                             END                                                              AS NewRow
                           , GoodsRemains.AccommodationId                                     AS AccommodationID
                           , GoodsRemains.MinExpirationDate                                   AS MinExpirationDate
                           , GoodsRemains.DiscountExternalID                                  AS DiscountExternalID
                           , GoodsRemains.PartionDateKindId                                   AS PartionDateKindId
                           , GoodsRemains.DivisionPartiesId                                   AS DivisionPartiesId
                           , GoodsRemains.PartionDateDiscount                                 AS PartionDateDiscount
                           , GoodsRemains.PriceWithVAT                                        AS PriceWithVAT
                      FROM GoodsRemains
                           LEFT JOIN SESSIONDATA ON SESSIONDATA.ObjectId  = GoodsRemains.ObjectId
                                                 AND COALESCE (SESSIONDATA.NDSKindId,0) = COALESCE (GoodsRemains.NDSKindId, 0)
                                                 AND COALESCE (SESSIONDATA.DiscountExternalID,0) = COALESCE (GoodsRemains.DiscountExternalID, 0)
                                                 AND COALESCE (SESSIONDATA.PartionDateKindId,0) = COALESCE (GoodsRemains.PartionDateKindId, 0)
                                                 AND COALESCE (SESSIONDATA.DivisionPartiesId,0) = COALESCE (GoodsRemains.DivisionPartiesId, 0)
                      WHERE COALESCE (GoodsRemains.Price, 0) <> COALESCE (SESSIONDATA.Price, 0)
                         OR COALESCE (GoodsRemains.NDSKindId, 0) <> COALESCE (SESSIONDATA.NDSKindId, 0)
                         OR COALESCE (GoodsRemains.DiscountExternalID, 0) <> COALESCE (SESSIONDATA.DiscountExternalID, 0)
                         OR COALESCE (GoodsRemains.MCSValue, 0) <> COALESCE (SESSIONDATA.MCSValue, 0)
                         OR COALESCE (GoodsRemains.Remains, 0) <> COALESCE (SESSIONDATA.Remains, 0)
                         OR COALESCE (GoodsRemains.Reserved, 0) <> COALESCE (SESSIONDATA.Reserved, 0)
                         OR COALESCE (GoodsRemains.AccommodationID,0) <> COALESCE (SESSIONDATA.AccommodationId, 0)
                         OR COALESCE (GoodsRemains.MinExpirationDate, zc_DateEnd()) <> COALESCE (SESSIONDATA.MinExpirationDate, zc_DateEnd())
                         OR COALESCE (GoodsRemains.PartionDateKindId,0) <> COALESCE (SESSIONDATA.PartionDateKindId, 0)
                         OR COALESCE (GoodsRemains.DivisionPartiesId,0) <> COALESCE (SESSIONDATA.DivisionPartiesId, 0)
                         OR COALESCE (GoodsRemains.PartionDateDiscount,0) <> COALESCE (SESSIONDATA.PartionDateDiscount, 0)
                         OR COALESCE (GoodsRemains.PriceWithVAT,0) <> COALESCE (SESSIONDATA.PriceWithVAT, 0)
                         OR COALESCE (GoodsRemains.DeferredSend,0) <> COALESCE (SESSIONDATA.DeferredSend, 0)
                         OR COALESCE (GoodsRemains.DeferredTR,0) <> COALESCE (SESSIONDATA.DeferredTR, 0)
                      UNION ALL
                      SELECT SESSIONDATA.ObjectId                                                AS ObjectId
                           , SESSIONDATA.Price                                                   AS Price
                           , SESSIONDATA.NDSKindId                                               AS NDSKindId
                           , SESSIONDATA.MCSValue                                                AS MCSValue
                           , 0                                                                   AS Remains
                           , NULL                                                                AS Reserved
                           , NULL                                                                AS DeferredSend
                           , NULL                                                                AS DeferredTR
                           , FALSE                                                               AS NewRow
                           , SESSIONDATA.AccommodationId                                         AS AccommodationID
                           , SESSIONDATA.MinExpirationDate                                       AS MinExpirationDate
                           , SESSIONDATA.DiscountExternalID                                      AS DiscountExternalID
                           , SESSIONDATA.PartionDateKindId                                       AS PartionDateKindId
                           , SESSIONDATA.DivisionPartiesId                                       AS DivisionPartiesId
                           , SESSIONDATA.PartionDateDiscount                                     AS PartionDateDiscount
                           , SESSIONDATA.PriceWithVAT                                            AS PriceWithVAT
                      FROM SESSIONDATA
                           LEFT JOIN GoodsRemains ON GoodsRemains.ObjectId = SESSIONDATA.ObjectId
                                                 AND COALESCE (GoodsRemains.PartionDateKindId, 0) = COALESCE (SESSIONDATA.PartionDateKindId, 0)
                                                 AND COALESCE (GoodsRemains.NDSKindId, 0) = COALESCE (SESSIONDATA.NDSKindId, 0)
                                                 AND COALESCE (GoodsRemains.DivisionPartiesId, 0) = COALESCE (SESSIONDATA.DivisionPartiesId, 0)
                                                 AND COALESCE (GoodsRemains.DiscountExternalID, 0) = COALESCE (SESSIONDATA.DiscountExternalID, 0)
                      WHERE COALESCE(GoodsRemains.ObjectId, 0) = 0
                        AND (COALESCE(SESSIONDATA.Remains, 0) <> 0
                             OR
                             COALESCE(SESSIONDATA.Reserved, 0) <> 0
                             OR
                             COALESCE(SESSIONDATA.DeferredSend, 0) <> 0
                             OR
                             COALESCE(SESSIONDATA.DeferredTR, 0) <> 0)
                     )

    -- РЕЗУЛЬТАТ - заливаем разницу
    INSERT INTO _DIFF (ObjectId, Price, NDSKindId, Remains, MinExpirationDate, DiscountExternalID, PartionDateKindId, DivisionPartiesId,
                       MCSValue, Reserved, DeferredSend, DeferredTR, NewRow, AccommodationId, PartionDateDiscount, PriceWithVAT)
       -- РЕЗУЛЬТАТ
       SELECT tmpDiff.ObjectId
            , tmpDiff.Price
            , tmpDiff.NDSKindId
            , tmpDiff.Remains
            , tmpDiff.MinExpirationDate
            , NULLIF (tmpDiff.DiscountExternalID, 0)  AS DiscountExternalID
            , NULLIF (tmpDiff.PartionDateKindId, 0)   AS PartionDateKindId
            , NULLIF (tmpDiff.DivisionPartiesId, 0)   AS DivisionPartiesId
            , tmpDiff.MCSValue
            , tmpDiff.Reserved
            , tmpDiff.DeferredSend
            , tmpDiff.DeferredTR
            , tmpDiff.NewRow
            , tmpDiff.AccommodationID
            , tmpDiff.PartionDateDiscount
            , tmpDiff.PriceWithVAT
       FROM tmpDiff;
	   
	ANALYSE _DIFF;

    --Обновляем данные в сессии
    UPDATE CashSessionSnapShot SET
        Price               = _DIFF.Price
      , Remains             = _DIFF.Remains
      , MCSValue            = _DIFF.MCSValue
      , Reserved            = _DIFF.Reserved
      , DeferredSend        = _DIFF.DeferredSend
      , DeferredTR          = _DIFF.DeferredTR
      , AccommodationId     = _DIFF.AccommodationId
      , MinExpirationDate   = _DIFF.MinExpirationDate
      , DiscountExternalID  = COALESCE (_DIFF.DiscountExternalID, 0)
      , PartionDateKindId   = COALESCE (_DIFF.PartionDateKindId, 0)
      , DivisionPartiesId   = COALESCE (_DIFF.DivisionPartiesId, 0)
      , PartionDateDiscount = _DIFF.PartionDateDiscount
      , PriceWithVAT        = _DIFF.PriceWithVAT
    FROM
        _DIFF
    WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
      AND CashSessionSnapShot.ObjectId = _DIFF.ObjectId
      AND  COALESCE(CashSessionSnapShot.NDSKindId, 0) =  COALESCE(_DIFF.NDSKindId, 0)
      AND COALESCE(CashSessionSnapShot.DiscountExternalID, 0) = COALESCE(_DIFF.DiscountExternalID, 0)
      AND COALESCE(CashSessionSnapShot.PartionDateKindId, 0) = COALESCE(_DIFF.PartionDateKindId, 0)
      AND COALESCE(CashSessionSnapShot.DivisionPartiesId, 0) = COALESCE(_DIFF.DivisionPartiesId, 0)
    ;
    
    --доливаем те, что появились
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,NDSKindId,DiscountExternalID,PartionDateKindId,DivisionPartiesId,Price,Remains,MCSValue,Reserved,
                                    DeferredSend,DeferredTR,MinExpirationDate, AccommodationId,PartionDateDiscount,PriceWithVAT)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
       ,_DIFF.NDSKindId
       ,COALESCE (_DIFF.DiscountExternalID, 0)
       ,COALESCE (_DIFF.PartionDateKindId, 0)
       ,COALESCE (_DIFF.DivisionPartiesId, 0)
       ,_DIFF.Price
       ,_DIFF.Remains
       ,_DIFF.MCSValue
       ,_DIFF.Reserved
       ,_DIFF.DeferredSend
       ,_DIFF.DeferredTR
       ,_DIFF.MinExpirationDate
       ,_DIFF.AccommodationId
       ,_DIFF.PartionDateDiscount
       ,_DIFF.PriceWithVAT
    FROM
        _DIFF
    WHERE
        _DIFF.NewRow = TRUE;

    -- Цена со скидкой
    CREATE TEMP TABLE tmpPriceChange ON COMMIT DROP AS 
    SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId                                                    AS GoodsId
                  , COALESCE (PriceChange_Value_Unit.ValueData, PriceChange_Value_Retail.ValueData)                        AS PriceChange
                  , COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData)::TFloat      AS FixPercent
                  , COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData)::TFloat    AS FixDiscount
                  , COALESCE (PriceChange_Multiplicity_Unit.ValueData, PriceChange_Multiplicity_Retail.ValueData) ::TFloat AS Multiplicity
                  , COALESCE (PriceChange_FixEndDate_Unit.ValueData, PriceChange_FixEndDate_Retail.ValueData)              AS FixEndDate
                  , COALESCE (ObjectLink_PriceChange_PartionDateKind_Unit.ChildObjectId, ObjectLink_PriceChange_PartionDateKind_Retail.ChildObjectId) AS PartionDateKindId
             FROM Object AS Object_PriceChange
                  -- скидка по подразд
                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Unit
                                       ON ObjectLink_PriceChange_Unit.ObjectId = Object_PriceChange.Id
                                      AND ObjectLink_PriceChange_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                                      AND ObjectLink_PriceChange_Unit.ChildObjectId = vbUnitId
                  -- цена со скидкой по подразд.
                  LEFT JOIN ObjectFloat AS PriceChange_Value_Unit
                                        ON PriceChange_Value_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                       AND PriceChange_Value_Unit.DescId = zc_ObjectFloat_PriceChange_Value()
                                       AND COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0
                  -- процент скидки по подразд.
                  LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Unit
                                        ON PriceChange_FixPercent_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                       AND PriceChange_FixPercent_Unit.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                       AND COALESCE (PriceChange_FixPercent_Unit.ValueData, 0) <> 0
                  -- сумма скидки по подразд.
                  LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Unit
                                        ON PriceChange_FixDiscount_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                       AND PriceChange_FixDiscount_Unit.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                       AND COALESCE (PriceChange_FixDiscount_Unit.ValueData, 0) <> 0
                  -- Кратность отпуска
                  LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Unit
                                        ON PriceChange_Multiplicity_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                       AND PriceChange_Multiplicity_Unit.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                       AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, 0) <> 0
                  -- Дата окончания действия скидки
                  LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Unit
                                       ON PriceChange_FixEndDate_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                      AND PriceChange_FixEndDate_Unit.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                                                            
                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Unit
                                        ON ObjectLink_PriceChange_PartionDateKind_Unit.ObjectId  = ObjectLink_PriceChange_Unit.ObjectId
                                       AND ObjectLink_PriceChange_PartionDateKind_Unit.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()
                                                            

                  -- скидка по сети
                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                       ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                      AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                      AND ObjectLink_PriceChange_Retail.ChildObjectId = vbObjectId
                  -- цена со скидкой по сети
                  LEFT JOIN ObjectFloat AS PriceChange_Value_Retail
                                        ON PriceChange_Value_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND PriceChange_Value_Retail.DescId = zc_ObjectFloat_PriceChange_Value()
                                       AND COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0
                  -- процент скидки по сети.
                  LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Retail
                                        ON PriceChange_FixPercent_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND PriceChange_FixPercent_Retail.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                       AND COALESCE (PriceChange_FixPercent_Retail.ValueData, 0) <> 0
                  -- сумма скидки по сети.
                  LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Retail
                                        ON PriceChange_FixDiscount_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND PriceChange_FixDiscount_Retail.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                       AND COALESCE (PriceChange_FixDiscount_Retail.ValueData, 0) <> 0
                  -- Кратность отпуска по сети.
                  LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Retail
                                        ON PriceChange_Multiplicity_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND PriceChange_Multiplicity_Retail.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                       AND COALESCE (PriceChange_Multiplicity_Retail.ValueData, 0) <> 0
                  -- Дата окончания действия скидки по сети.
                  LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Retail
                                       ON PriceChange_FixEndDate_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                      AND PriceChange_FixEndDate_Retail.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Retail
                                        ON ObjectLink_PriceChange_PartionDateKind_Retail.ObjectId  = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND ObjectLink_PriceChange_PartionDateKind_Retail.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()

                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                       ON ObjectLink_PriceChange_Goods.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                      AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()

             WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
               AND Object_PriceChange.isErased = FALSE
               AND (COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0 OR COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0 OR
                   COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData, 0) <> 0 OR
                   COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData, 0) <> 0) -- выбираем только цены <> 0
             ;

    ANALYZE tmpPriceChange;

    CREATE TEMP TABLE tmpGoodsSP ON COMMIT DROP AS 
      WITH  -- Товары соц-проект
           tmpMedicalProgramSPUnit AS (SELECT  ObjectLink_MedicalProgramSP.ChildObjectId         AS MedicalProgramSPId
                                       FROM Object AS Object_MedicalProgramSPLink
                                            INNER JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                                                  ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                                            INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                  ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                                                 AND ObjectLink_Unit.ChildObjectId = vbUnitId 
                                        WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
                                          AND Object_MedicalProgramSPLink.isErased = False)
                          SELECT MovementItem.ObjectId         AS GoodsId
                               , MLO_MedicalProgramSP.ObjectId AS MedicalProgramSPID
                               , COALESCE(MovementFloat_PercentPayment.ValueData, 0)::TFloat  AS PercentPayment
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIFloat_CountSPMin.ValueData  AS CountSPMin
                                                                -- № п/п - на всякий случай
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId 
                                                    ORDER BY Movement.OperDate DESC, MIFloat_CountSPMin.ValueData DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                               INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                             ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                            AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                               LEFT JOIN tmpMedicalProgramSPUnit ON tmpMedicalProgramSPUnit.MedicalProgramSPId = MLO_MedicalProgramSP.ObjectId

                               LEFT JOIN MovementFloat AS MovementFloat_PercentPayment
                                                       ON MovementFloat_PercentPayment.MovementId = Movement.Id
                                                      AND MovementFloat_PercentPayment.DescId = zc_MovementFloat_PercentPayment()

                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                               
                               -- Роздрібна  ціна за упаковку, грн
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                           ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
                               -- Розмір відшкодування за упаковку (Соц. проект) - (15)
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                           ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()

                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                           ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSPMin
                                                           ON MIFloat_CountSPMin.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSPMin.DescId = zc_MIFloat_CountSPMin()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                            AND (COALESCE (tmpMedicalProgramSPUnit.MedicalProgramSPId, 0) <> 0 OR vbUserId = 3);

    ANALYZE tmpGoodsSP;

    CREATE TEMP TABLE tmpMIPromoBonus ON COMMIT DROP AS 
     SELECT MI.GoodsId               AS GoodsId
          , MI.MarginPercent         AS MarginPercent
          , MI.PromoBonus            AS PromoBonus
     FROM gpSelect_PromoBonus_MarginPercent(vbUnitId, inSession) AS MI;

    ANALYZE tmpMIPromoBonus;

    --Возвращаем разницу в клиента
    RETURN QUERY
           WITH tmpPartionDateKind AS (SELECT Object_PartionDateKind.Id           AS Id
                                            , Object_PartionDateKind.ObjectCode   AS Code
                                            , Object_PartionDateKind.ValueData    AS Name
                                            , COALESCE (ObjectFloatDay.ValueData / 30, 0) :: TFLoat AS AmountMonth
                                       FROM Object AS Object_PartionDateKind
                                            LEFT JOIN ObjectFloat AS ObjectFloatDay
                                                                  ON ObjectFloatDay.ObjectId = Object_PartionDateKind.Id
                                                                 AND ObjectFloatDay.DescId = zc_ObjectFloat_PartionDateKind_Day()
                                       WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind()
                                      )

                 , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                       , ObjectFloat_NDSKind_NDS.ValueData
                                 FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                 WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                )
                 , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                             , Object_Object.Id                                          AS GoodsDiscountId
                                             , Object_Object.ValueData                                   AS GoodsDiscountName
                                             , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                             , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                                             , MAX(ObjectFloat_DiscountProcent.ValueData)::TFloat        AS DiscountProcent 
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
                                              LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                                    ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                                   AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()

                                          WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                            AND Object_BarCode.isErased = False
                                          GROUP BY Object_Goods_Retail.GoodsMainId
                                                 , Object_Object.Id
                                                 , Object_Object.ValueData
                                                 , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False))
                 , tmpGoodsUKTZED AS (SELECT Object_Goods_Juridical.GoodsMainId
                                           , REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')::TVarChar AS UKTZED
                                           , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Juridical.GoodsMainId
                                                          ORDER BY COALESCE(Object_Goods_Juridical.AreaId, 0), Object_Goods_Juridical.JuridicalId) AS Ord
                                      FROM Object_Goods_Juridical
                                      WHERE COALESCE (Object_Goods_Juridical.UKTZED, '') <> ''
                                        AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) <= 10
                                        AND Object_Goods_Juridical.GoodsMainId <> 0
                                      )
                 , tmpGoodsPairSunMain AS (SELECT Object_Goods_Retail.GoodsPairSunId                          AS ID
                                                , Min(Object_Goods_Retail.Id)::Integer                        AS MainID
                                           FROM Object_Goods_Retail
                                           WHERE COALESCE (Object_Goods_Retail.GoodsPairSunId, 0) <> 0
                                             AND Object_Goods_Retail.RetailId = 4
                                           GROUP BY Object_Goods_Retail.GoodsPairSunId)
                 , tmpGoodsPairSun AS (SELECT Object_Goods_Retail.Id
                                            , Object_Goods_Retail.GoodsPairSunId
                                            , COALESCE(Object_Goods_Retail.PairSunAmount, 1)::TFloat AS GoodsPairSunAmount
                                       FROM Object_Goods_Retail
                                       WHERE COALESCE (Object_Goods_Retail.GoodsPairSunId, 0) <> 0
                                         AND Object_Goods_Retail.RetailId = 4)

        SELECT
            _DIFF.ObjectId,
            Object_Goods_Main.ObjectCode,
            CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods_Main.NameUkr, '') <> ''
                 THEN Object_Goods_Main.NameUkr
                 ELSE Object_Goods_Main.Name END AS Name,
            zfCalc_PriceCash(_DIFF.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) AS Price,
            _DIFF.Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.MinExpirationDate,
            NULLIF (_DIFF.PartionDateKindId, 0),
            Object_PartionDateKind.Name                              AS PartionDateKindName,
            _DIFF.NewRow,
            _DIFF.AccommodationId,
            Object_Accommodation.ValueData                           AS AccommodationName,
            CASE _DIFF.PartionDateKindId
                 WHEN zc_Enum_PartionDateKind_Good() THEN vbDay_6 / 30.0 + 1.0
                 WHEN zc_Enum_PartionDateKind_Cat_5() THEN vbDay_6 / 30.0 - 1.0
                 ELSE Object_PartionDateKind.AmountMonth END::TFloat AS AmountMonth,
            CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                  AND ObjectFloat_Goods_Price.ValueData > 0
                 THEN zfCalc_PriceCash(_DIFF.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) 
            ELSE
            CASE WHEN zfCalc_PriceCash(_DIFF.Price, 
                         CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) > _DIFF.PriceWithVAT
                         AND _DIFF.PriceWithVAT <= vbPriceSamples 
                         AND vbPriceSamples > 0
                         AND _DIFF.PriceWithVAT > 0
                         AND _DIFF.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_6())
                      THEN ROUND(zfCalc_PriceCash(_DIFF.Price *
                                 CASE WHEN _DIFF.PartionDateKindId = zc_Enum_PartionDateKind_6() THEN 100.0 - vbSamples21
                                      WHEN _DIFF.PartionDateKindId = zc_Enum_PartionDateKind_3() THEN 100.0 - vbSamples22
                                      WHEN _DIFF.PartionDateKindId = zc_Enum_PartionDateKind_1() THEN 100.0 - vbSamples3
                                      ELSE 100 END  / 100, 
                                 CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END), 2)
                 WHEN COALESCE(_DIFF.PartionDateKindId, 0) <> 0 AND COALESCE(_DIFF.PartionDateDiscount, 0) <> 0 THEN
                     CASE WHEN zfCalc_PriceCash(_DIFF.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) > _DIFF.PriceWithVAT
                          THEN ROUND(zfCalc_PriceCash(_DIFF.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) - (zfCalc_PriceCash(_DIFF.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) - _DIFF.PriceWithVAT) *
                                     _DIFF.PartionDateDiscount / 100, 2)
                          ELSE zfCalc_PriceCash(_DIFF.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                     END
                 ELSE NULL
            END END                                          :: TFloat AS PricePartionDate,
            CASE WHEN COALESCE (Object_Goods_Retail.isFirst, FALSE) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc,
            _DIFF.DeferredSend,
            RemainsSUN TFloat,
            ObjectFloat_NDSKind_NDS.ValueData AS NDS,
            COALESCE(_DIFF.NDSKindId, Object_Goods_Main.NDSKindId)            AS NDSKindId,
            NULLIF (_DIFF.DiscountExternalID, 0)                              AS DiscountExternalId,
            Object_DiscountExternal.ValueData                                 AS DiscountExternalName,
            tmpGoodsDiscount.GoodsDiscountId                                  AS GoodsDiscountID,
            tmpGoodsDiscount.GoodsDiscountName                                AS GoodsDiscountName,
            tmpGoodsUKTZED.UKTZED                                             AS UKTZED,
            Object_Goods_PairSun_Main.MainID                                  AS GoodsPairSunId,
            NULLIF (_DIFF.DivisionPartiesId, 0),
            CASE WHEN Object_DivisionParties.ObjectCode = 1 
                  AND (COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = FALSE OR
                       Object_Goods_Main.isExceptionUKTZED OR
                       COALESCE (ObjectBoolean_GoodsUKTZEDRRO.ValueData, FALSE) = True)
                 THEN 'Разделение парий по УКТВЭД'
                 ELSE Object_DivisionParties.ValueData END::TVarChar       AS DivisionPartiesName,
            COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) 
              AND NOT Object_Goods_Main.isExceptionUKTZED                     AS isBanFiscalSale,
            COALESCE(tmpGoodsDiscount.isGoodsForProject, FALSE)               AS isGoodsForProject,
            CASE WHEN COALESCE(Object_Goods_PairSun.GoodsPairSunAmount, 0) > 1 AND vbObjectId <> 4
                 THEN NULL
                 ELSE Object_Goods_PairSun.GoodsPairSunID END::INTEGER        AS GoodsPairSunMainId,
            tmpGoodsDiscount.MaxPrice                                         AS GoodsDiscountMaxPrice,
            COALESCE(Object_Goods_PairSun_Main.MainID, 0) <> 0                AS isGoodsPairSun,
            CASE WHEN COALESCE(Object_Goods_PairSun.GoodsPairSunAmount, 0) > 1 AND vbObjectId <> 4 
                 THEN NULL
                 ELSE Object_Goods_PairSun.GoodsPairSunAmount END::TFloat     AS GoodsPairSunAmount,
            tmpGoodsDiscount.DiscountProcent                                  AS GoodsDiscountProcentSite,
            _DIFF.DeferredTR,
            Object_Goods_Main.MorionCode,
            zfCalc_PriceCash(CASE WHEN COALESCE(NULLIF (_DIFF.PartionDateKindId, 0), zc_Enum_PartionDateKind_Good()) = zc_Enum_PartionDateKind_Good()
                                   AND Object_Goods_Retail.IsTop = False 
                                   AND (COALESCE(tmpPriceChange.PriceChange, 0) = 0 AND
                                        COALESCE(tmpPriceChange.FixPercent, 0) = 0 AND
                                        COALESCE(tmpPriceChange.FixDiscount, 0) = 0 OR
                                        COALESCE(tmpPriceChange.Multiplicity, 0) > 1)
                                  THEN Round(_DIFF.Price * 100.0 / (100.0 + tmpMIPromoBonus.MarginPercent) * 
                                       (100.0 - tmpMIPromoBonus.PromoBonus + tmpMIPromoBonus.MarginPercent) / 100, 2) END , 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)  AS PromoBonusPrice,
            zfCalc_PriceCash(COALESCE(
                             CASE WHEN COALESCE(NULLIF (_DIFF.PartionDateKindId, 0), zc_Enum_PartionDateKind_Good()) = zc_Enum_PartionDateKind_Good()
                                   AND Object_Goods_Retail.IsTop = False 
                                   AND (COALESCE(tmpPriceChange.PriceChange, 0) = 0 AND
                                        COALESCE(tmpPriceChange.FixPercent, 0) = 0 AND
                                        COALESCE(tmpPriceChange.FixDiscount, 0) = 0 OR
                                        COALESCE(tmpPriceChange.Multiplicity, 0) > 1)
                                  THEN Round(_DIFF.Price * 100.0 / (100.0 + tmpMIPromoBonus.MarginPercent) * 
                                       (100.0 - tmpMIPromoBonus.PromoBonus + tmpMIPromoBonus.MarginPercent) / 100, 2) END,
                             _DIFF.Price) , 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)  AS PriceView,
            COALESCE (tmpAsinoPharmaSP.IsAsinoMain , FALSE)                       AS IsAsinoMain,
            COALESCE (tmpAsinoPharmaSP.IsAsinoPresent , FALSE)                    AS IsAsinoPresent
        FROM _DIFF

            -- Тип срок/не срок
            LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = NULLIF (_DIFF.PartionDateKindId, 0)

            -- Товар для проекта (дисконтные карты)
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = NULLIF (_DIFF.DiscountExternalId, 0)

            -- Разделение партий в кассе для продажи
            LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = NULLIF (_DIFF.DivisionPartiesId, 0)
            LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                    ON ObjectBoolean_BanFiscalSale.ObjectId = Object_DivisionParties.Id
                                    AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()
 
            -- получается GoodsMainId
            LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = _DIFF.ObjectId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
            LEFT JOIN tmpGoodsPairSun AS Object_Goods_PairSun
                                      ON Object_Goods_PairSun.Id = Object_Goods_Retail.Id
            LEFT JOIN tmpGoodsPairSunMain AS Object_Goods_PairSun_Main
                                          ON Object_Goods_PairSun_Main.Id = Object_Goods_Retail.Id
            LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Main.Id

            -- Соц Проект
            LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Main.Id
                                AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай

            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = _DIFF.AccommodationId

            LEFT OUTER JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                       ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE(_DIFF.NDSKindId, Object_Goods_Main.NDSKindId)
            -- Коды UKTZED
            LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                    AND tmpGoodsUKTZED.Ord = 1
            -- Фикс цена для всей Сети
            LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                   ON ObjectFloat_Goods_Price.ObjectId = _DIFF.ObjectId
                                  AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = _DIFF.ObjectId
                                   AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsUKTZEDRRO
                                    ON ObjectBoolean_GoodsUKTZEDRRO.ObjectId = vbUnitId
                                   AND ObjectBoolean_GoodsUKTZEDRRO.DescId = zc_ObjectBoolean_Unit_GoodsUKTZEDRRO()

            LEFT JOIN tmpMIPromoBonus ON tmpMIPromoBonus.GoodsId = _DIFF.ObjectId

            -- Цена со скидкой
            LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = _DIFF.ObjectId
                                    AND (COALESCE(tmpPriceChange.PartionDateKindId, 0) = 0 
                                      OR COALESCE(tmpPriceChange.PartionDateKindId, 0) = _DIFF.PartionDateKindId)
                                      
            LEFT JOIN tmpAsinoPharmaSP ON tmpAsinoPharmaSP.GoodsId = _DIFF.ObjectId

        ORDER BY _DIFF.ObjectId
            ;

    -- !!!Протокол - отладка Скорости!!!
/*    PERFORM lpInsert_ResourseProtocol (inOperDate     := vbOperDate_StartBegin
                                     , inTime2        := NULL :: INTERVAL
                                     , inTime3        := NULL :: INTERVAL
                                     , inTime4        := NULL :: INTERVAL
                                     , inProcName     := 'gpSelect_CashRemains_Diff_ver2'
                                     , inProtocolData := lfGet_Object_ValueData_sh (vbUnitId) || ' ,' || CHR (39) || inCashSessionId || CHR (39) || ', '   || CHR (39) || inSession || CHR (39)
                                     , inUserId       := vbUserId
                                      );
*/
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Diff_ver2 (TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 14.08.20                                                                                      * DivisionPartiesID
 19.06.20                                                                                      * DiscountExternalID
 15.07.19                                                                                      *
 28.05.19                                                                                      * PartionDateKindId
 16.03.16         *
 12.09.15                                                                       *CashSessionSnapShot
*/

-- тест SELECT * FROM  gpDelete_CashSession ('{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}', '3');
-- тест SELECT * FROM gpSelect_CashRemains_ver2 ('{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}', '3')

-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{0B05C610-B172-4F81-99B8-25BF5385ADD6}' , '3')
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{85E257DE-0563-4B9E-BE1C-4D5C123FB33A}-', '10411288')
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{85E257DE-0563-4B9E-BE1C-4D5C123FB33A}-', '3998773') WHERE GoodsCode = 1240
--
SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}', '3')
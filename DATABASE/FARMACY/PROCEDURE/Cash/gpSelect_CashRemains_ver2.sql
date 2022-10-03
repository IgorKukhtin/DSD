-- Function: gpSelect_CashRemains_ver2()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_ver2(
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId_main Integer, GoodsGroupName TVarChar, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, PriceSP TFloat, PriceSaleSP TFloat, DiffSP1 TFloat, DiffSP2 TFloat, Reserved TFloat, MCSValue TFloat,
               AlternativeGroupId Integer, NDS TFloat,
               isFirst boolean, isSecond boolean, Color_calc Integer,
               isPromo boolean, isPromoForSale boolean, RelatedProductId Integer,
               isSP boolean,
               IntenalSPName TVarChar,
               MinExpirationDate TDateTime,
               DiscountExternalID  Integer, DiscountExternalName  TVarChar,
               PartionDateKindId  Integer, PartionDateKindName  TVarChar,
               DivisionPartiesId  Integer, DivisionPartiesName  TVarChar, isBanFiscalSale Boolean,
               Color_ExpirationDate Integer,
               ConditionsKeepName TVarChar,
               AmountIncome TFloat, PriceSaleIncome TFloat,
               MorionCode Integer, BarCode TVarChar,
               MCSValueOld TFloat,
               StartDateMCSAuto TDateTime, EndDateMCSAuto TDateTime,
               isMCSAuto Boolean, isMCSNotRecalcOld Boolean,
               AccommodationId Integer, AccommodationName TVarChar,
               PriceChange TFloat, FixPercent TFloat, FixDiscount TFloat, Multiplicity TFloat, FixEndDate TDateTime,
               DoesNotShare boolean, GoodsAnalogId Integer, GoodsAnalogName TVarChar,
               GoodsAnalog TVarChar, GoodsAnalogATC TVarChar, GoodsActiveSubstance TVarChar,
               MedicalProgramSPID Integer, PercentPayment TFloat, CountSP TFloat, CountSPMin TFloat, 
               IdSP TVarChar, ProgramIdSP TVarChar, DosageIdSP TVarChar, PriceRetSP TFloat, PaymentSP TFloat,
               AmountMonth TFloat, PricePartionDate TFloat,
               PartionDateDiscount TFloat,
               NotSold boolean, NotSold60 boolean,
               DeferredSend TFloat, DeferredTR TFloat,
               RemainsSUN TFloat,
               GoodsDiscountID  Integer, GoodsDiscountName  TVarChar, isGoodsForProject boolean, GoodsDiscountMaxPrice TFloat, GoodsDiscountProcentSite TFloat,
               UKTZED TVarChar,
               GoodsPairSunId Integer, isGoodsPairSun boolean, GoodsPairSunMainId Integer, GoodsPairSunAmount TFloat, 
               AmountSendIn TFloat,
               NotTransferTime boolean,
               NDSKindId Integer,
               isPresent boolean,
               isOnlySP boolean,
               DistributionPromoID Integer,
               Color_IPE Integer, 
               MultiplicitySale TFloat,
               isMultiplicityError boolean,
               isStaticCode boolean,
               isVIPforSales boolean,
               
               PriceSaleOOC1303 TFloat, 
               PriceSale1303 TFloat,
               BrandSPName TVarChar

               /*PartionDateKindId_check   Integer,
               Price_check               TFloat,
               PriceWithVAT_check        TFloat,
               PartionDateDiscount_check TFloat*/
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
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbDividePartionDate   boolean;
   DECLARE vbPromoForSale TVarChar;
   DECLARE vbPartnerMedicalId  Integer;

   DECLARE vbPriceSamples TFloat;
   DECLARE vbSamples21 TFloat;
   DECLARE vbSamples22 TFloat;
   DECLARE vbSamples3 TFloat;

   DECLARE vbAreaId   Integer;
   DECLARE vbLanguage TVarChar;
BEGIN
-- if inSession = '3' then return; end if;

    -- !!!Протокол - отладка Скорости!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    -- для Теста
    -- IF inSession = '3' then vbUnitId:= 1781716; END IF;

    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');
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
    
    SELECT 
        ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
      , COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)  :: Boolean   AS DividePartionDate
      , ','||COALESCE(ObjectString_PromoForSale.ValueData, '')||','               AS PromoForSale
      , COALESCE (ObjectLink_Unit_PartnerMedical.ChildObjectId, 0)::Integer       AS PartnerMedicalId
    INTO  vbRetailId, vbDividePartionDate, vbPromoForSale, vbPartnerMedicalId
    FROM Object AS Object_Unit

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        LEFT JOIN ObjectString AS ObjectString_PromoForSale
                               ON ObjectString_PromoForSale.ObjectId = Object_Unit.Id 
                              AND ObjectString_PromoForSale.DescId = zc_ObjectString_Unit_PromoForSale()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
        LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical
                             ON ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()

    WHERE Object_Unit.Id = vbUnitId;
    
    SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
    INTO vbLanguage
    FROM Object AS Object_User
                 
         LEFT JOIN ObjectString AS ObjectString_Language
                ON ObjectString_Language.ObjectId = Object_User.Id
               AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
    WHERE Object_User.Id = vbUserId;    
    
        
    -- Объявили новую сессию кассового места / обновили дату последнего обращения
    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );

    -- Очистили содержимое SnapShot сессии
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;

    -- Данные
    --залили снапшот
    INSERT INTO CashSessionSnapShot(CashSessionId,ObjectId,NDSKindId,DiscountExternalID,PartionDateKindId,DivisionPartiesID,Price,Remains,MCSValue,Reserved,DeferredSend,DeferredTR,MinExpirationDate,AccommodationId,PartionDateDiscount,PriceWithVAT
    )
    SELECT inCashSessionId                                                  AS CashSession
          , CashRemains.GoodsId
          , CashRemains.NDSKindId
          , CashRemains.DiscountExternalID
          , CashRemains.PartionDateKindId
          , CashRemains.DivisionPartiesID
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
    FROM gpSelect_CashRemains_CashSession(inSession) AS CashRemains;

    RETURN QUERY
      WITH -- Товары соц-проект
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
         , tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                               , MLO_MedicalProgramSP.ObjectId AS MedicalProgramSPID
                               , COALESCE(MovementFloat_PercentPayment.ValueData, 0)::TFloat  AS PercentPayment
                               , MI_IntenalSP.ObjectId         AS IntenalSPId
                               , MI_BrandSP.ObjectId           AS BrandSPId
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_PaymentSP.ValueData   AS PaymentSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIFloat_CountSPMin.ValueData  AS CountSPMin
                               , MIString_IdSP.ValueData       AS IdSP
                               , COALESCE (MIString_ProgramIdSP.ValueData, '')::TVarChar AS ProgramIdSP
                               , MIString_DosageIdSP.ValueData AS DosageIdSP
                                                                -- № п/п - на всякий случай
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

                               LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                                ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                               AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                               LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                                                ON MI_BrandSP.MovementItemId = MovementItem.Id
                                                               AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
                                                               
                               -- Роздрібна  ціна за упаковку, грн
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                           ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
                               -- Розмір відшкодування за упаковку (Соц. проект) - (15)
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                           ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                               -- Сума доплати за упаковку, грн (Соц. проект) - 16)
                               LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                           ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()

                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                           ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSPMin
                                                           ON MIFloat_CountSPMin.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSPMin.DescId = zc_MIFloat_CountSPMin()
                               -- ID лікарського засобу
                               LEFT JOIN MovementItemString AS MIString_IdSP
                                                            ON MIString_IdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_IdSP.DescId = zc_MIString_IdSP()
                               LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                                            ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()
                               -- DosageID лікарського засобу
                               LEFT JOIN MovementItemString AS MIString_DosageIdSP
                                                            ON MIString_DosageIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_DosageIdSP.DescId = zc_MIString_DosageIdSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                            AND (COALESCE (tmpMedicalProgramSPUnit.MedicalProgramSPId, 0) <> 0 OR vbUserId = 3)
                         )
         , GoodsPromo AS (SELECT Object_Goods_Retail.GoodsMainId                                                    AS GoodsId        -- здесь товар "главный товар"
                               , SUM(CASE WHEN vbPromoForSale ILIKE ','||tmp.InvNumber||',' THEN 1 ELSE 0 END) > 0  AS isPromoForSale
                               , max(tmp.RelatedProductId)                                                          AS RelatedProductId
                          FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp
                               LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmp.GoodsId
                          GROUP BY Object_Goods_Retail.GoodsMainId
                          )
                -- товар в пути - непроведенные приходы сегодня
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
           -- Коды Мориона
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
           -- Штрих-коды производителя
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
              -- данные из прайса
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
                -- Цена со скидкой
              , tmpPriceChange AS (SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId                                                    AS GoodsId
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
                                                            AND ObjectLink_PriceChange_Retail.ChildObjectId = vbRetailId
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
                 -- Все перемещения по СУН
                ,tmpSendAll AS (SELECT DISTINCT Movement.Id AS MovementId
                                FROM Movement

                                     INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = Movement.Id
                                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()


                                WHERE Movement.DescId = zc_Movement_Send()
                                  AND COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                )
                   -- Перемещения по СУН основные контейнера
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
                   -- Перемещения по СУН полный набор
                 , tmpRenainsSUNAll AS (SELECT Container.Id                                       AS ID
                                          , Container.ObjectId                                 AS GoodsID
                                          , Container.Amount                                   AS Amount
                                          , ContainerPD.Id                                     AS PDID
                                          , ContainerPD.Amount                                 AS AmountPD
                                          , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                      COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                       THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_1()      -- Меньше 3 месяца
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                                 ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
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
                   -- Перемещения по СУН остатки
                 , tmpRenainsSUN AS (SELECT Container.GoodsID                                   AS GoodsID
                                          , COALESCE(Container.PartionDateKindId, 0)            AS PartionDateKindId
                                          , SUM(COALESCE(Container.AmountPD, Container.Amount)) AS Amount
                                     FROM tmpRenainsSUNAll AS Container

                                     GROUP BY Container.GoodsID, COALESCE(Container.PartionDateKindId, 0)
                                      )
                      -- Отложенные перемещения
                 , tmpMovementID AS (SELECT Movement.Id
                                     FROM Movement
                                     WHERE Movement.DescId = zc_Movement_Send()
                                      AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    )
                 , tmpMovementSend AS (SELECT Movement.Id
                                       FROM tmpMovementID AS Movement

                                            INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                       ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                      AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                                      AND MovementBoolean_Deferred.ValueData = TRUE

                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId = vbUnitId
                                       )
                 , tmpDeferredSendIn AS (SELECT Container.ObjectId                  AS GoodsId
                                              , SUM(- MovementItemContainer.Amount) AS Amount
                                         FROM tmpMovementSend AS Movement

                                              INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                              AND MovementItemContainer.DescId = zc_Container_Count()

                                              INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                                         GROUP BY Container.ObjectId
                                       )

                   -- Без Продажи за последнии 60 дней
                 , tmpIlliquidUnit AS (SELECT * FROM lpReport_IlliquidReductionPlanUser(inUserID := vbUserId))

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
                 , tmpDistributionPromo AS (SELECT MI_DistributionPromoMaster.ObjectId    AS GoodsGroupId
                                                 , MAX(Movement.Id)::Integer              AS DistributionPromoID
                                            FROM Movement

                                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                                               ON MovementLinkObject_Retail.MovementId = Movement.Id
                                                                              AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                                                              AND MovementLinkObject_Retail.ObjectId = vbObjectId

                                                 LEFT JOIN MovementDate AS MovementDate_StartPromo
                                                                        ON MovementDate_StartPromo.MovementId = Movement.Id
                                                                       AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                 LEFT JOIN MovementDate AS MovementDate_EndPromo
                                                                        ON MovementDate_EndPromo.MovementId = Movement.Id
                                                                       AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                                                 LEFT JOIN MovementItem AS MI_DistributionPromo
                                                                        ON MI_DistributionPromo.MovementId = Movement.Id
                                                                       AND MI_DistributionPromo.DescId = zc_MI_Child()
                                                                       AND MI_DistributionPromo.isErased = FALSE
                                                                       AND MI_DistributionPromo.Amount = 1
                                                                       AND MI_DistributionPromo.ObjectId = vbUnitId
                                                                                                          
                                                 LEFT JOIN MovementItem AS MI_DistributionPromoMaster
                                                                        ON MI_DistributionPromoMaster.MovementId = Movement.Id
                                                                       AND MI_DistributionPromoMaster.DescId = zc_MI_Master()
                                                                       AND MI_DistributionPromoMaster.isErased = FALSE
                                                                       AND MI_DistributionPromoMaster.Amount = 1

                                            WHERE Movement.DescId = zc_Movement_DistributionPromo()
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                                              AND MovementDate_StartPromo.ValueData <= CURRENT_DATE + INTERVAL '1 DAY'
                                              AND MovementDate_EndPromo.ValueData >= CURRENT_DATE - INTERVAL '1 DAY'
                                              AND (COALESCE(MI_DistributionPromo.ObjectId, 0) = vbUnitId OR 
                                                   NOT EXISTS(SELECT 1 FROM MovementItem
                                                              WHERE MovementItem.MovementId = Movement.Id
                                                                AND MovementItem.DescId = zc_MI_Child()
                                                                AND MovementItem.Amount = 1
                                                                AND MovementItem.isErased = FALSE))
                                                   
                                            GROUP BY MI_DistributionPromoMaster.ObjectId)
                 , tmpGoodsDivisionLock AS (SELECT ObjectLink_GoodsDivisionLock_Goods.ChildObjectId  AS GoodsId
                                                 , ObjectBoolean_GoodsDivisionLock_Lock.ValueData    AS isLock
                                            FROM ObjectLink AS ObjectLink_GoodsDivisionLock_Unit
                                                 INNER JOIN ObjectLink AS ObjectLink_GoodsDivisionLock_Goods
                                                                       ON ObjectLink_GoodsDivisionLock_Goods.ObjectId = ObjectLink_GoodsDivisionLock_Unit.ObjectId
                                                                      AND ObjectLink_GoodsDivisionLock_Goods.DescId = zc_ObjectLink_GoodsDivisionLock_Goods()
                                                 INNER JOIN ObjectBoolean AS ObjectBoolean_GoodsDivisionLock_Lock
                                                                          ON ObjectBoolean_GoodsDivisionLock_Lock.ObjectId  = ObjectLink_GoodsDivisionLock_Unit.ObjectId
                                                                         AND ObjectBoolean_GoodsDivisionLock_Lock.DescId    = zc_ObjectBoolean_GoodsDivisionLock_Lock()
                                                                         AND ObjectBoolean_GoodsDivisionLock_Lock.ValueData = True
                                            WHERE ObjectLink_GoodsDivisionLock_Unit.DescId        = zc_ObjectLink_GoodsDivisionLock_Unit()
                                              AND ObjectLink_GoodsDivisionLock_Unit.ChildObjectId = vbUnitId
                                            )
                 , tmpGoodsAutoVIPforSalesCash AS (SELECT  T1.GoodsId FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) AS T1)
                 
                 , tmpGoodsSP_1303 AS (SELECT * 
                                       FROM gpSelect_GoodsSPRegistry_1303_Unit (inUnitId := vbUnitId, inGoodsId := 0, inisCalc := COALESCE (vbPartnerMedicalId, 0) > 0, inSession := inSession)
                                       )

 

        -- Результат
        SELECT
            CashSessionSnapShot.ObjectId,
            Object_Goods_Main.Id          AS GoodsId_main,
            Object_GoodsGroup.ValueData   AS GoodsGroupName,
            CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods_Main.NameUkr, '') <> ''
                 THEN Object_Goods_Main.NameUkr
                 ELSE Object_Goods_Main.Name END AS Name,
            Object_Goods_Main.ObjectCode,
            CashSessionSnapShot.Remains,
            zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) AS Price,

            --
            -- Цена со скидкой для СП
            --
            CASE WHEN COALESCE (tmpGoodsSP.PercentPayment, 0) > 0
                 THEN ROUND (CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceRetSP, 0)
                                  THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                  ELSE COALESCE (tmpGoodsSP.PriceRetSP, 0) END * tmpGoodsSP.PercentPayment / 100, 2) -- Фиксированный % доплаты
                                       
                 WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END :: TFloat AS PriceSP,


            --
            -- Цена без скидки для СП
            --
            CASE WHEN COALESCE (tmpGoodsSP.PercentPayment, 0) > 0
                 THEN CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                     CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                     COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceRetSP, 0)
                           THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                     CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                     COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ELSE COALESCE (tmpGoodsSP.PriceRetSP, 0) END -- Фиксированный % доплаты
            ELSE
              CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                               CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                               COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0)
                        THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                               CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                               COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) -- по нашей цене, т.к. она меньше чем цена возмещения
                   ELSE

              CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                        THEN 0 -- по 0, т.к. цена доплаты = 0

                   WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                               CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                               COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0)
                        THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                   WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                               CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                               COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                     AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                           - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                           - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                               CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                               COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                             ) -- разница с ценой возмещения и "округлили в большую"
                        THEN 0

                   WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                               CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                               COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                        THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                           - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                           - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                               CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                               COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                             ) -- разница с ценой возмещения и "округлили в большую"

                   ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

              END
            + COALESCE (tmpGoodsSP.PriceSP, 0)

            END END :: TFloat AS PriceSaleSP,

            -- временно для проверки1
           (CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN 0 ELSE
            COALESCE (zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0), 0)
          - CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) -- по нашей цене, т.к. она меньше чем цена возмещения

                 ELSE
            CASE WHEN COALESCE (tmpGoodsSP.PercentPayment, 0) > 0
                 THEN ROUND (CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceRetSP, 0)
                                  THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                  ELSE COALESCE (tmpGoodsSP.PriceRetSP, 0) END * tmpGoodsSP.PercentPayment / 100, 2) -- Фиксированный % доплаты
                                       
                 WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END
          + COALESCE (tmpGoodsSP.PriceSP, 0)


            END
            END
            -- COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - CashSessionSnapShot.Price
            ) :: TFloat AS DiffSP1,

            -- временно для проверки2
           (CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) -- по нашей цене, т.к. она меньше чем цена возмещения

                 ELSE

            CASE WHEN COALESCE (tmpGoodsSP.PercentPayment, 0) > 0
                 THEN ROUND (CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceRetSP, 0)
                                  THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                  ELSE COALESCE (tmpGoodsSP.PriceRetSP, 0) END * tmpGoodsSP.PercentPayment / 100, 2) -- Фиксированный % доплаты
                                       
                 WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END
          + COALESCE (tmpGoodsSP.PriceSP, 0)

            END

          - CASE WHEN COALESCE (tmpGoodsSP.PercentPayment, 0) > 0
                 THEN ROUND (CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceRetSP, 0)
                                  THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                                            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                            COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                  ELSE COALESCE (tmpGoodsSP.PriceRetSP, 0) END * tmpGoodsSP.PercentPayment / 100, 2) -- Фиксированный % доплаты
                                       
                 WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END
           ) :: TFloat AS DiffSP2,

            NULLIF (CashSessionSnapShot.Reserved, 0) :: TFloat AS Reserved,
            CashSessionSnapShot.MCSValue,
            Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId,
            ObjectFloat_NDSKind_NDS.ValueData AS NDS,
            COALESCE(Object_Goods_Retail.isFirst, False)          AS isFirst,
            COALESCE(Object_Goods_Retail.isSecond, False)         AS isSecond,
            CASE WHEN COALESCE(Object_Goods_Retail.isSecond, False) = TRUE THEN 16440317 WHEN COALESCE(Object_Goods_Retail.isFirst, False) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc,
            CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END    AS isPromo,
            COALESCE(GoodsPromo.isPromoForSale, FALSE)                                AS isPromoForSale,
            COALESCE(GoodsPromo.RelatedProductId, ObjectFloat_RelatedProduct.ValueData)::Integer  AS RelatedProductId,
            CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END :: Boolean  AS isSP,
            Object_IntenalSP.ValueData AS IntenalSPName,
            CashSessionSnapShot.MinExpirationDate,
            NULLIF (CashSessionSnapShot.DiscountExternalID, 0) AS DiscountExternalID,
            Object_DiscountExternal.ValueData                  AS DiscountExternalName,
            NULLIF (CashSessionSnapShot.PartionDateKindId, 0)  AS PartionDateKindId,
            Object_PartionDateKind.Name                        AS PartionDateKindName,
            NULLIF (CashSessionSnapShot.DivisionPartiesId, 0)  AS DivisionPartiesId,
            CASE WHEN Object_DivisionParties.ObjectCode = 1 
                  AND (COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = FALSE OR
                       Object_Goods_Main.isExceptionUKTZED OR
                       COALESCE (ObjectBoolean_GoodsUKTZEDRRO.ValueData, FALSE) = True)
                 THEN 'Разделение парий по УКТВЭД'
                 ELSE Object_DivisionParties.ValueData END::TVarChar       AS DivisionPartiesName,
            COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False)
              AND NOT Object_Goods_Main.isExceptionUKTZED      AS isBanFiscalSale,
            CASE WHEN vbDividePartionDate = False
              THEN
                CASE WHEN CashSessionSnapShot.MinExpirationDate < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Red() ELSE zc_Color_Black() END
              ELSE
                CASE CashSessionSnapShot.PartionDateKindId WHEN zc_Enum_PartionDateKind_0() THEN zc_Color_Red()
                                                           WHEN zc_Enum_PartionDateKind_1() THEN 36095
                                                           WHEN zc_Enum_PartionDateKind_3() THEN 14822282
                                                           WHEN zc_Enum_PartionDateKind_6() THEN zc_Color_Blue()
                                                           WHEN zc_Enum_PartionDateKind_Cat_5() THEN 32768
                                                           ELSE zc_Color_Black() END END::Integer                     AS Color_ExpirationDate,
            COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName,

            COALESCE(tmpIncome.AmountIncome,0)            :: TFloat   AS AmountIncome,
            CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE(tmpIncome.SummSale,0) / COALESCE(tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome
          , COALESCE (Object_Goods_Main.MorionCode, 0) :: Integer  AS MorionCode
          , COALESCE (tmpGoodsBarCode.BarCode, '')  :: TVarChar AS BarCode
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
          , tmpPriceChange.FixEndDate
          , COALESCE (tmpGoodsDivisionLock.isLock, FALSE)          AS DoesNotShare
          , NULL::Integer                                          AS GoodsAnalogId
          , NULL::TVarChar                                         AS GoodsAnalogName
          , Object_Goods_Main.Analog                               AS GoodsAnalog
          , Object_Goods_Main.AnalogATC                            AS GoodsAnalogATC
          , Object_Goods_Main.ActiveSubstance                      AS GoodsActiveSubstance
          , tmpGoodsSP.MedicalProgramSPID                          AS MedicalProgramSPID
          , tmpGoodsSP.PercentPayment                              AS PercentPayment
          , tmpGoodsSP.CountSP::TFloat                             AS CountSP
          , tmpGoodsSP.CountSPMin::TFloat                          AS CountSPMin
          , tmpGoodsSP.IdSP::TVarChar                              AS IdSP
          , tmpGoodsSP.ProgramIdSP::TVarChar                       AS ProgramIdSP
          , tmpGoodsSP.DosageIdSP::TVarChar                        AS DosageIdSP
          , tmpGoodsSP.PriceRetSP::TFloat                          AS PriceRetSP
          , tmpGoodsSP.PaymentSP::TFloat                           AS PaymentSP
          , CASE CashSessionSnapShot.PartionDateKindId
            WHEN zc_Enum_PartionDateKind_Good() THEN vbDay_6 / 30.0 + 1.0
            WHEN zc_Enum_PartionDateKind_Cat_5() THEN vbDay_6 / 30.0 - 1.0
            ELSE Object_PartionDateKind.AmountMonth END::TFloat AS AmountMonth
          , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                  AND ObjectFloat_Goods_Price.ValueData > 0
                   OR COALESCE(tmpPriceChange.PartionDateKindId, 0) <> 0
                 THEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
            ELSE
            CASE WHEN COALESCE(CashSessionSnapShot.PartionDateKindId, 0) <> 0 AND COALESCE(CashSessionSnapShot.PartionDateDiscount, 0) <> 0 THEN
                 CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                         CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) > CashSessionSnapShot.PriceWithVAT
                         AND CashSessionSnapShot.PriceWithVAT <= vbPriceSamples 
                         AND vbPriceSamples > 0
                         AND CashSessionSnapShot.PriceWithVAT > 0
                         AND CashSessionSnapShot.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_6())
                      THEN ROUND(zfCalc_PriceCash(CashSessionSnapShot.Price *
                                 CASE WHEN CashSessionSnapShot.PartionDateKindId = zc_Enum_PartionDateKind_6() THEN 100.0 - vbSamples21
                                      WHEN CashSessionSnapShot.PartionDateKindId = zc_Enum_PartionDateKind_3() THEN 100.0 - vbSamples22
                                      WHEN CashSessionSnapShot.PartionDateKindId = zc_Enum_PartionDateKind_1() THEN 100.0 - vbSamples3
                                      ELSE 100 END  / 100, 
                                 CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END), 2)
                      WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, 
                         CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) > CashSessionSnapShot.PriceWithVAT
                         AND CashSessionSnapShot.PriceWithVAT > 0
                      THEN ROUND(zfCalc_PriceCash(CashSessionSnapShot.Price, 
                         CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) - (zfCalc_PriceCash(CashSessionSnapShot.Price, 
                         CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) - CashSessionSnapShot.PriceWithVAT) *
                                 CashSessionSnapShot.PartionDateDiscount / 100, 2)
                      ELSE zfCalc_PriceCash(CashSessionSnapShot.Price, 
                         CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                 END
                 ELSE NULL
            END END                                      :: TFloat AS PricePartionDate
          , CashSessionSnapShot.PartionDateDiscount                AS PartionDateDiscount
          , COALESCE(tmpNotSold.GoodsID, 0) <> 0                   AS NotSold
          , COALESCE(tmpIlliquidUnit.GoodsID, 0) <> 0              AS NotSold60
          , CashSessionSnapShot.DeferredSend::TFloat               AS DeferredSend
          , CashSessionSnapShot.DeferredTR::TFloat                 AS DeferredTR
          , tmpRenainsSUN.Amount::TFloat                           AS RemainsSUN
          , tmpGoodsDiscount.GoodsDiscountId                       AS GoodsDiscountID
          , tmpGoodsDiscount.GoodsDiscountName                     AS GoodsDiscountName
          , COALESCE(tmpGoodsDiscount.isGoodsForProject, FALSE)    AS isGoodsForProject
          , tmpGoodsDiscount.MaxPrice                              AS GoodsDiscountMaxPrice
          , tmpGoodsDiscount.DiscountProcent                       AS GoodsDiscountProcentSite
          , tmpGoodsUKTZED.UKTZED                                  AS UKTZED
          , Object_Goods_PairSun_Main.MainID                       AS GoodsPairSunId
          , COALESCE(Object_Goods_PairSun_Main.MainID, 0) <> 0     AS isGoodsPairSun
          , CASE WHEN COALESCE(Object_Goods_PairSun.GoodsPairSunAmount, 0) > 1 AND vbObjectId <> 4 
                 THEN NULL
                 ELSE Object_Goods_PairSun.GoodsPairSunID END::INTEGER     AS GoodsPairSunMainId
          , CASE WHEN COALESCE(Object_Goods_PairSun.GoodsPairSunAmount, 0) > 1 AND vbObjectId <> 4 
                 THEN NULL
                 ELSE Object_Goods_PairSun.GoodsPairSunAmount END::TFloat  AS GoodsPairSunAmount

          , tmpDeferredSendIn.Amount :: TFloat                     AS AmountSendIn
          , COALESCE (Object_Goods_Main.isNotTransferTime, False)  AS NotTransferTime
          , COALESCE(CashSessionSnapShot.NDSKindId, Object_Goods_Main.NDSKindId) AS NDSKindId
          , Object_Goods_Main.isPresent                                          AS isPresent
          , Object_Goods_Main.isOnlySP                                           AS isOnlySP
          , tmpDistributionPromo.DistributionPromoID                             AS DistributionPromoID
          , 0                                                      AS Color_IPE
          , Object_Goods_Main.Multiplicity                         AS MultiplicitySale
          , Object_Goods_Main.isMultiplicityError                  AS isMultiplicityError
          , (COALESCE(Object_Goods_Retail.SummaWages, 0) <> 0 or 
             COALESCE(Object_Goods_Retail.PercentWages, 0) <> 0)::Boolean                     AS isStaticCode
          , COALESCE (tmpGoodsAutoVIPforSalesCash.GoodsId, 0) > 0                             AS isVIPforSales
          
          , tmpGoodsSP_1303.PriceSale                              AS PriceSaleOOC1303
          , tmpGoodsSP_1303.PriceSaleIncome                        AS PriceSale1303

          , Object_BrandSP.ValueData                               AS BrandSPName

          /*, CashSessionSnapShot.PartionDateKindId   AS PartionDateKindId_check
          , zfCalc_PriceCash(CashSessionSnapShot.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)               AS Price_check
          , CashSessionSnapShot.PriceWithVAT        AS PriceWithVAT_check
          , CashSessionSnapShot.PartionDateDiscount AS PartionDateDiscount_check*/
          
         FROM
            CashSessionSnapShot

            -- получается GoodsMainId
            LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = CashSessionSnapShot.ObjectId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
            
            LEFT JOIN tmpGoodsPairSun AS Object_Goods_PairSun
                                      ON Object_Goods_PairSun.Id = Object_Goods_Retail.Id
            LEFT JOIN tmpGoodsPairSunMain AS Object_Goods_PairSun_Main
                                         ON Object_Goods_PairSun_Main.Id = Object_Goods_Retail.Id
                                      
            LEFT JOIN tmpDistributionPromo ON tmpDistributionPromo.GoodsGroupId =  Object_Goods_Main.GoodsGroupId
            
            LEFT JOIN tmpGoodsDivisionLock ON tmpGoodsDivisionLock.GoodsId =  CashSessionSnapShot.ObjectId

            LEFT JOIN tmpMCSAuto ON tmpMCSAuto.ObjectId = CashSessionSnapShot.ObjectId
            LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                       ON Link_Goods_AlternativeGroup.ObjectId = CashSessionSnapShot.ObjectId
                                      AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
            LEFT OUTER JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                       ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE(CashSessionSnapShot.NDSKindId, Object_Goods_Main.NDSKindId)

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_Main.Id
            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = CashSessionSnapShot.ObjectId

            -- Соц Проект
            LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Main.Id
                                AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай

            -- условия хранения
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Main.ConditionsKeepId
            LEFT JOIN ObjectFloat AS ObjectFloat_RelatedProduct
                                  ON ObjectFloat_RelatedProduct.ObjectId = Object_ConditionsKeep.Id
                                 AND ObjectFloat_RelatedProduct.DescId = zc_ObjectFloat_ConditionsKeep_RelatedProduct()            
            --
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId
            -- штрих-код производителя
            LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Main.Id
            -- код Мориона
            LEFT JOIN tmpGoodsMorion ON tmpGoodsMorion.GoodsMainId = Object_Goods_Main.Id
            -- Размещение товара
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = CashSessionSnapShot.AccommodationId

            LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Main.Id
            -- Цена со скидкой
            LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = CashSessionSnapShot.ObjectId
                                    AND (COALESCE(tmpPriceChange.PartionDateKindId, 0) = 0 
                                      OR COALESCE(tmpPriceChange.PartionDateKindId, 0) = CashSessionSnapShot.PartionDateKindId)

           -- Тип срок/не срок
           LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = NULLIF (CashSessionSnapShot.PartionDateKindId, 0)

           -- Товар для проекта (дисконтные карты)
           LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = NULLIF (CashSessionSnapShot.DiscountExternalId, 0)

           -- Разделение партий в кассе для продажи
           LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = NULLIF (CashSessionSnapShot.DivisionPartiesId, 0)
           LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                   ON ObjectBoolean_BanFiscalSale.ObjectId = Object_DivisionParties.Id
                                  AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()

           -- Без Продажи за последнии 100 дней
           LEFT JOIN tmpNotSold ON tmpNotSold.GoodsID = CashSessionSnapShot.ObjectId

           -- Без Продажи за последнии 60 дней
           LEFT JOIN tmpIlliquidUnit ON tmpIlliquidUnit.GoodsID = CashSessionSnapShot.ObjectId

           -- Остаток товара по СУН
           LEFT JOIN tmpRenainsSUN ON tmpRenainsSUN.GoodsID = CashSessionSnapShot.ObjectId
                                  AND tmpRenainsSUN.PartionDateKindId = CashSessionSnapShot.PartionDateKindId


           -- Коды UKTZED
           LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                   AND tmpGoodsUKTZED.Ord = 1

           LEFT JOIN tmpDeferredSendIn ON tmpDeferredSendIn.GoodsId = CashSessionSnapShot.ObjectId

           -- Фикс цена для всей Сети
           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                  ON ObjectFloat_Goods_Price.ObjectId =  CashSessionSnapShot.ObjectId
                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                   ON ObjectBoolean_Goods_TOP.ObjectId =  CashSessionSnapShot.ObjectId
                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsUKTZEDRRO
                                   ON ObjectBoolean_GoodsUKTZEDRRO.ObjectId = vbUnitId
                                  AND ObjectBoolean_GoodsUKTZEDRRO.DescId = zc_ObjectBoolean_Unit_GoodsUKTZEDRRO()
                                  
           LEFT JOIN tmpGoodsAutoVIPforSalesCash ON tmpGoodsAutoVIPforSalesCash.GoodsId = CashSessionSnapShot.ObjectId
           
           LEFT JOIN tmpGoodsSP_1303 ON tmpGoodsSP_1303.GoodsId = CashSessionSnapShot.ObjectId
                                   
           LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                            ON MI_IntenalSP.MovementItemId = tmpGoodsSP_1303.MovementItemId
                                           AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP_1303()
           LEFT JOIN  Object AS Object_IntenalSP ON Object_IntenalSP.Id = COALESCE(NULLIF(tmpGoodsSP.IntenalSPId, 0), MI_IntenalSP.ObjectId)

           LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                            ON MI_BrandSP.MovementItemId = tmpGoodsSP_1303.MovementItemId
                                           AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
           LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = COALESCE(NULLIF(tmpGoodsSP.BrandSPId, 0), MI_BrandSP.ObjectId )
           
        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
        ORDER BY
            CashSessionSnapShot.ObjectId;

/*    vb1:= (SELECT COUNT (*) FROM CashSessionSnapShot WHERE CashSessionSnapShot.CashSessionId = inCashSessionId) :: TVarChar;
    vb2:= ((CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: INTERVAL) :: TVarChar;

    -- !!!Протокол - отладка Скорости!!!
    INSERT INTO Log_Reprice (InsertDate, StartDate, EndDate, MovementId, UserId, TextValue)
      VALUES (CURRENT_TIMESTAMP, vbOperDate_StartBegin, CLOCK_TIMESTAMP(), vbUnitId, vbUserId
            , vb2
    || ' '   || REPEAT ('0', 8 - LENGTH (vb1)) || vb1 || '-1'
    || ' '   || lfGet_Object_ValueData_sh (vbUnitId)
    || ' + ' || lfGet_Object_ValueData_sh (vbUserId)
    || ','   || vbUnitId              :: TVarChar
    || ','   || CHR (39) || inCashSessionId || CHR (39)
             );*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_ver2 (TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.  Ярошенко Р.Ф.  Шаблий О.В.
 18.05.21                                                                                                    * GoodsDivisionLock
 14.08.20                                                                                                    * DivisionPartiesID
 19.06.20                                                                                                    * DiscountExternalID
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
 01.10.18         * tmpPriceChange - учет скидки подразделения
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
 22.08.15                                                                       *разделение вип и отложеных
 19.08.15                                                                       *CurrentMovement
 05.05.15                        *

*/

-- тест
-- тест SELECT * FROM  gpDelete_CashSession ('{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}', '3');
--
SELECT * FROM gpSelect_CashRemains_ver2 ('{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}', '3')
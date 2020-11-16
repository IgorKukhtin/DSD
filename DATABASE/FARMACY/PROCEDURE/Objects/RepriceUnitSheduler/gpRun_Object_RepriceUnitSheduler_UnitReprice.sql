-- Function: gpRun_Object_RepriceUnitSheduler_UnitReprice()

DROP FUNCTION IF EXISTS gpRun_Object_RepriceUnitSheduler_UnitReprice(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Object_RepriceUnitSheduler_UnitReprice(
    IN inID          Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUnitID Integer;
   DECLARE vbPercentDifference Integer;
   DECLARE vbVAT20 Boolean;
   DECLARE vbPercentRepriceMax TFloat;
   DECLARE vbPercentRepriceMin TFloat;
   DECLARE vbEqualRepriceMax TFloat;
   DECLARE vbEqualRepriceMin TFloat;
   DECLARE vbGUID TVarChar;
   DECLARE text_var1 Text;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

--  raise notice 'Object: %', inID;

  BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpallgoodsprice'))
    THEN
      CREATE TEMP TABLE tmpAllGoodsPrice (
        id integer,
        id_retail integer,
        code integer,
        goodsname public.tvarchar,
        lastprice public.tfloat,
        lastprice_to public.tfloat,
        remainscount public.tfloat,
        remainscount_to public.tfloat,
        nds public.tfloat,
        newprice public.tfloat,
        newprice_to public.tfloat,
        pricefix_goods public.tfloat,
        minmarginpercent public.tfloat,
        pricediff public.tfloat,
        pricediff_to public.tfloat,
        expirationdate public.tdatetime,
        juridicalid integer,
        juridicalname public.tvarchar,
        juridical_price public.tfloat,
        marginpercent public.tfloat,
        juridical_goodsname public.tvarchar,
        producername public.tvarchar,
        contractid integer,
        contractname public.tvarchar,
        areaid integer,
        areaname public.tvarchar,
        juridical_percent public.tfloat,
        contract_percent public.tfloat,
        sumreprice public.tfloat,
        midpricesale public.tfloat,
        midpricediff public.tfloat,
        minexpirationdate public.tdatetime,
        minexpirationdate_to public.tdatetime,
        isonejuridical boolean,
        ispricefix boolean,
        isincome boolean,
        istop boolean,
        istop_goods boolean,
        ispromo boolean,
        isResolution_224 Boolean,
        isUseReprice Boolean,
        reprice boolean,
        isSP boolean
      ) ON COMMIT DROP;
    END IF;

    SELECT
               ObjectLink_Unit.ChildObjectId                    AS UnitId
             , ObjectFloat_PercentDifference.ValueData::Integer AS PercentDifference
             , ObjectBoolean_VAT20.ValueData                    AS VAT20
             , ObjectFloat_PercentRepriceMax.ValueData          AS PercentRepriceMax
             , ObjectFloat_PercentRepriceMin.ValueData          AS PercentRepriceMin
             , ObjectFloat_EqualRepriceMax.ValueData            AS EqualRepriceMax
             , ObjectFloat_EqualRepriceMin.ValueData            AS EqualRepriceMin
    INTO
               vbUnitID
             , vbPercentDifference
             , vbVAT20
             , vbPercentRepriceMax
             , vbPercentRepriceMin
             , vbEqualRepriceMax
             , vbEqualRepriceMin
    FROM Object AS Object_RepriceUnitSheduler
             INNER JOIN ObjectLink AS ObjectLink_Unit
                                   ON ObjectLink_Unit.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_RepriceUnitSheduler_Unit()

             LEFT JOIN ObjectFloat AS ObjectFloat_PercentDifference
                                   ON ObjectFloat_PercentDifference.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectFloat_PercentDifference.DescId = zc_ObjectFloat_RepriceUnitSheduler_PercentDifference()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_VAT20
                                     ON ObjectBoolean_VAT20.ObjectId = Object_RepriceUnitSheduler.Id
                                    AND ObjectBoolean_VAT20.DescId = zc_ObjectBoolean_RepriceUnitSheduler_VAT20()

             LEFT JOIN ObjectFloat AS ObjectFloat_PercentRepriceMax
                                   ON ObjectFloat_PercentRepriceMax.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectFloat_PercentRepriceMax.DescId = zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax()

             LEFT JOIN ObjectFloat AS ObjectFloat_PercentRepriceMin
                                   ON ObjectFloat_PercentRepriceMin.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectFloat_PercentRepriceMin.DescId = zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin()

             LEFT JOIN ObjectFloat AS ObjectFloat_EqualRepriceMax
                                   ON ObjectFloat_EqualRepriceMax.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectFloat_EqualRepriceMax.DescId = zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax()

             LEFT JOIN ObjectFloat AS ObjectFloat_EqualRepriceMin
                                   ON ObjectFloat_EqualRepriceMin.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectFloat_EqualRepriceMin.DescId = zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin()

    WHERE Object_RepriceUnitSheduler.Id = inID;

    -- генерируем новый GUID код
    vbGUID := (SELECT zfCalc_GUID());

  --  raise notice 'Unit: %', vbUnitID;

    DELETE FROM tmpAllGoodsPrice;

    WITH -- Товары соц-проект
           tmpGoodsSP AS (SELECT DISTINCT Object_Goods_Retail.Id         AS GoodsId
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

                               LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )
    INSERT INTO tmpAllGoodsPrice (id,
                                  id_retail,
                                  code,
                                  goodsname,
                                  lastprice,
                                  lastprice_to,
                                  remainscount,
                                  remainscount_to,
                                  nds,
                                  newprice,
                                  newprice_to,
                                  pricefix_goods,
                                  minmarginpercent,
                                  pricediff,
                                  pricediff_to,
                                  expirationdate,
                                  juridicalid,
                                  juridicalname,
                                  juridical_price,
                                  marginpercent,
                                  juridical_goodsname,
                                  producername,
                                  contractid,
                                  contractname,
                                  areaid,
                                  areaname,
                                  juridical_percent,
                                  contract_percent,
                                  sumreprice,
                                  midpricesale,
                                  midpricediff,
                                  minexpirationdate,
                                  minexpirationdate_to,
                                  isonejuridical,
                                  ispricefix,
                                  isincome,
                                  istop,
                                  istop_goods,
                                  ispromo,
                                  isResolution_224,
                                  isUseReprice,
                                  reprice,
                                  isSP
                                 )
    SELECT id,
           id_retail,
           code,
           goodsname,
           lastprice,
           lastprice_to,
           remainscount,
           remainscount_to,
           nds,
           newprice,
           newprice_to,
           pricefix_goods,
           minmarginpercent,
           pricediff,
           pricediff_to,
           expirationdate,
           juridicalid,
           juridicalname,
           juridical_price,
           marginpercent,
           juridical_goodsname,
           producername,
           contractid,
           contractname,
           areaid,
           areaname,
           juridical_percent,
           contract_percent,
           sumreprice,
           midpricesale,
           midpricediff,
           minexpirationdate,
           minexpirationdate_to,
           isonejuridical,
           ispricefix,
           isincome,
           istop,
           istop_goods,
           ispromo,
           isResolution_224,
           isUseReprice,
           reprice,
           COALESCE (tmpGoodsSP.GoodsId, 0) <> 0
    FROM gpSelect_AllGoodsPrice(inUnitId := vbUnitID, inUnitId_to := 0, inMinPercent := vbPercentDifference,
      inVAT20 := vbVAT20, inTaxTo := 0, inPriceMaxTo := 0,  inSession := inSession)
         LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = gpSelect_AllGoodsPrice.ID;

    -- сохранили свойство <Дата начала переоценки>
    PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_RepriceUnitSheduler_DataStartLast(), inID, clock_timestamp());

    PERFORM gpInsertUpdate_MovementItem_Reprice(
      ioID := 0 ,
      inGoodsId := tmpAllGoodsPrice.Id,
      inUnitId := vbUnitID,
      inUnitId_Forwarding := 0 ,
      inTax := 0 ,
      inJuridicalId := COALESCE (tmpAllGoodsPrice.JuridicalId, 0),
      inContractId := COALESCE (tmpAllGoodsPrice.ContractId, 0),
      inExpirationDate := tmpAllGoodsPrice.ExpirationDate,
      inMinExpirationDate := tmpAllGoodsPrice.MinExpirationDate,
      inAmount := COALESCE (tmpAllGoodsPrice.RemainsCount, 0),
      inPriceOld := COALESCE (tmpAllGoodsPrice.LastPrice, 0),
      inPriceNew := COALESCE (tmpAllGoodsPrice.NewPrice, 0),
      inJuridical_Price := COALESCE (tmpAllGoodsPrice.Juridical_Price, 0),
      inJuridical_Percent := COALESCE (tmpAllGoodsPrice.Juridical_Percent, 0),
      inContract_Percent := COALESCE (tmpAllGoodsPrice.Contract_Percent, 0),
      inGUID := vbGUID,
      inSession := inSession)
    FROM tmpAllGoodsPrice
    WHERE Reprice = True
      AND (PriceDiff <= vbPercentRepriceMax
      AND PriceDiff >= - vbPercentRepriceMin
       OR IsTop_Goods = TRUE
      AND isSP = FALSE
      AND isResolution_224 = FALSE)
      AND isUseReprice = TRUE;
      
    PERFORM gpInsertUpdate_MovementItem_Reprice_Clipped(
      ioID := 0 ,
      inGoodsId := tmpAllGoodsPrice.Id,
      inUnitId := vbUnitID,
      inUnitId_Forwarding := 0 ,
      inTax := 0 ,
      inJuridicalId := COALESCE (tmpAllGoodsPrice.JuridicalId, 0),
      inContractId := COALESCE (tmpAllGoodsPrice.ContractId, 0),
      inExpirationDate := tmpAllGoodsPrice.ExpirationDate,
      inMinExpirationDate := tmpAllGoodsPrice.MinExpirationDate,
      inAmount := COALESCE (tmpAllGoodsPrice.RemainsCount, 0),
      inPriceOld := COALESCE (tmpAllGoodsPrice.LastPrice, 0),
      inPriceNew := COALESCE (tmpAllGoodsPrice.NewPrice, 0),
      inJuridical_Price := COALESCE (tmpAllGoodsPrice.Juridical_Price, 0),
      inJuridical_Percent := COALESCE (tmpAllGoodsPrice.Juridical_Percent, 0),
      inContract_Percent := COALESCE (tmpAllGoodsPrice.Contract_Percent, 0),
      inGUID := vbGUID,
      inSession := inSession)
    FROM tmpAllGoodsPrice
    WHERE Reprice = True
      AND (PriceDiff > vbPercentRepriceMax
       OR PriceDiff < - vbPercentRepriceMin)
      AND NOT (IsTop_Goods = TRUE AND isSP = FALSE AND isResolution_224 = FALSE)
       OR Reprice = False AND isResolution_224 = True
       OR Reprice = True AND isUseReprice = FALSE;

/*
raise notice 'All: % % %', (select Count(*) from tmpAllGoodsPrice where Reprice = True)
                         , (select Count(*) from tmpAllGoodsPrice where Reprice = True
      AND (PriceDiff <= vbPercentRepriceMax
      AND PriceDiff >= - vbPercentRepriceMin
       OR IsTop_Goods = TRUE
      AND isSP = FALSE
      AND isResolution_224 = FALSE)
      AND isUseReprice = TRUE)
                         , (select Count(*) from tmpAllGoodsPrice where Reprice = True
      AND (PriceDiff > vbPercentRepriceMax
       OR PriceDiff < - vbPercentRepriceMin)
      AND NOT (IsTop_Goods = TRUE AND isSP = FALSE AND isResolution_224 = FALSE)
       OR Reprice = False AND isResolution_224 = True
       OR Reprice = True AND isUseReprice = FALSE);   */   


  EXCEPTION
     WHEN others THEN
       GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     text_var1 = text_var1||' '||vbUnitID::Text;
     PERFORM lpLog_Run_Schedule_Function('gpRun_Object_RepriceUnitSheduler_UnitReprice ', True, text_var1::TVarChar, inSession::Integer);
  END;

--  raise notice 'All: %', (select Count(*) from tmpAllGoodsPrice);
--  raise notice 'All: %', (select Count(*) from tmpAllGoodsPrice where Reprice = True);
--  raise notice 'All: %', (select Count(*) from tmpAllGoodsPrice where Reprice = True
--                            AND PriceDiff <= vbPercentRepriceMax
--                            AND PriceDiff >= - vbPercentRepriceMin );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpRun_Object_RepriceUnitSheduler_UnitReprice(Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 22.10.18        *
*/

-- тест
-- SELECT * FROM Log_Run_Schedule_Function
-- select * from gpSelect_Object_RepriceUnitSheduler( inSession := '3');
-- SELECT * FROM gpRun_Object_RepriceUnitSheduler_UnitReprice (9079633 , '3')
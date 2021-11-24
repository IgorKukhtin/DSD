-- Function: gpRun_Object_RepriceSheduler_RepriceSite()

DROP FUNCTION IF EXISTS gpRun_Object_RepriceSheduler_RepriceSite(TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Object_RepriceSheduler_RepriceSite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$   
   DECLARE vbGUID TVarChar;
   DECLARE text_var1 Text;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

  --raise notice 'Object: %', inId;
  
  BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpAllGoodsPriceSite'))
    THEN
      CREATE TEMP TABLE tmpAllGoodsPriceSite (
        id integer,
        id_retail integer,
        code integer,
        goodsname public.tvarchar,
        lastprice public.tfloat,
        remainscount public.tfloat,
        nds public.tfloat,
        newprice public.tfloat,
        pricefix_goods public.tfloat,
        minmarginpercent public.tfloat,
        pricediff public.tfloat,
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
        isonejuridical boolean,
        ispricefix boolean,
        istop_goods boolean,
        ispromo boolean,
        isResolution_224 Boolean,
        isUseReprice Boolean,
        reprice boolean,
        isPromoBonus Boolean,
        AddPercentRepriceMin TFloat, 
        JuridicalPromoOneId       Integer,
        ContractPromoOneId        Integer,
        Juridical_PricePromoOne   TFloat,
        ExpirationDateOne         TDateTime, 
        Juridical_PercentPromoOne TFloat,
        Contract_PercentPromoOne  TFloat,
        JuridicalPromoTwoId       Integer,
        ContractPromoTwoId        Integer,
        Juridical_PricePromoTwo   TFloat,
        ExpirationDateTwo         TDateTime,
        Juridical_PercentPromoTwo TFloat,
        Contract_PercentPromoTwo  TFloat,
        NewPricePromo        TFloat,
        PriceDiffPromo       TFloat,
        RepricePromo         Boolean ,
        AddPercentRepricePromoMin TFloat,
        
        idRepriceOne         Boolean ,
        idReprice            Boolean                
      ) ON COMMIT DROP;
    END IF;

    DELETE FROM tmpAllGoodsPriceSite;

    -- генерируем новый GUID код
    vbGUID := (SELECT zfCalc_GUID());


    INSERT INTO tmpAllGoodsPriceSite (id,
                                  id_retail,
                                  code,
                                  goodsname,
                                  lastprice,
                                  remainscount,
                                  nds,
                                  newprice,
                                  pricefix_goods,
                                  minmarginpercent,
                                  pricediff,
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
                                  isonejuridical,
                                  ispricefix,
                                  istop_goods,
                                  ispromo,
                                  isResolution_224,
                                  isUseReprice,
                                  reprice,
                                  isPromoBonus,
                                  AddPercentRepriceMin,
                                  JuridicalPromoOneId,
                                  ContractPromoOneId,
                                  Juridical_PricePromoOne,
                                  ExpirationDateOne,
                                  Juridical_PercentPromoOne,
                                  Contract_PercentPromoOne,
                                  JuridicalPromoTwoId,
                                  ContractPromoTwoId,
                                  Juridical_PricePromoTwo,
                                  ExpirationDateTwo,
                                  Juridical_PercentPromoTwo,
                                  Contract_PercentPromoTwo,                                  
                                  NewPricePromo,
                                  PriceDiffPromo,
                                  RepricePromo,
                                  AddPercentRepricePromoMin,
                                  idRepriceOne,
                                  idReprice 
                                 )
    SELECT id,
           id_retail,
           code,
           goodsname,
           lastprice,
           remainscount,
           nds,
           newprice,
           pricefix_goods,
           minmarginpercent,
           pricediff,
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
           isonejuridical,
           ispricefix,
           istop_goods,
           ispromo,
           isResolution_224,
           isUseReprice,
           reprice,
           isPromoBonus,
           AddPercentRepriceMin,
           JuridicalPromoOneId,
           ContractPromoOneId,
           Juridical_PricePromoOne,
           ExpirationDateOne,
           Juridical_PercentPromoOne,
           Contract_PercentPromoOne,
           JuridicalPromoTwoId,
           ContractPromoTwoId,
           Juridical_PricePromoTwo,
           ExpirationDateTwo,
           Juridical_PercentPromoTwo,
           Contract_PercentPromoTwo,           
           NewPricePromo,
           PriceDiffPromo,
           RepricePromo,
           AddPercentRepricePromoMin,
           (isPromoBonus = FALSE OR COALESCE(NewPricePromo, 0) = 0),
           CASE WHEN (isPromoBonus = FALSE OR COALESCE(NewPricePromo, 0) = 0)
                THEN ABS(COALESCE(PriceDiff, 0)) <= 10 AND Reprice
                ELSE ABS(COALESCE(PriceDiffPromo, 0)) <= 10 AND RepricePromo END
    FROM gpSelect_AllGoodsPrice_Site(inSession := inSession)
    WHERE CASE WHEN (isPromoBonus = FALSE OR COALESCE(NewPricePromo, 0) = 0) THEN NewPrice ELSE NewPricePromo END <> COALESCE(LastPrice, 0)
    ;

    PERFORM gpInsertUpdate_MovementItem_RepriceSite(
      ioID := 0 ,
      inGoodsId := tmpAllGoodsPrice.Id,
      inJuridicalId := COALESCE (tmpAllGoodsPrice.JuridicalId, 0),
      inContractId := COALESCE (tmpAllGoodsPrice.ContractId, 0),
      inExpirationDate := tmpAllGoodsPrice.ExpirationDate,
      inMinExpirationDate := tmpAllGoodsPrice.MinExpirationDate,
      inAmount := COALESCE (tmpAllGoodsPrice.RemainsCount, 0),
      inPriceOld := COALESCE (tmpAllGoodsPrice.LastPrice, 0),
      inPriceNew := COALESCE (tmpAllGoodsPrice.NewPrice, 0),
      inJuridical_Price := COALESCE (tmpAllGoodsPrice.Juridical_Price, 0),
      inisJuridicalTwo := False,
      inJuridicalTwoId := 0,
      inContractTwoId := 0,
      inJuridical_PriceTwo := 0,
      inExpirationDateTwo := Null,
      inisPromoBonus  := COALESCE (tmpAllGoodsPrice.isPromoBonus, False),
      inGUID := vbGUID,
      inSession := inSession)
    FROM tmpAllGoodsPriceSite AS tmpAllGoodsPrice
    WHERE idRepriceOne = True AND idReprice = TRUE;
      
    PERFORM gpInsertUpdate_MovementItem_RepriceSite(
      ioID := 0 ,
      inGoodsId := tmpAllGoodsPrice.Id,
      inJuridicalId := COALESCE (tmpAllGoodsPrice.JuridicalPromoOneId, 0),
      inContractId := COALESCE (tmpAllGoodsPrice.ContractPromoOneId, 0),
      inExpirationDate := tmpAllGoodsPrice.ExpirationDateOne,
      inMinExpirationDate := tmpAllGoodsPrice.MinExpirationDate,
      inAmount := COALESCE (tmpAllGoodsPrice.RemainsCount, 0),
      inPriceOld := COALESCE (tmpAllGoodsPrice.LastPrice, 0),
      inPriceNew := COALESCE (tmpAllGoodsPrice.NewPricePromo, 0),
      inJuridical_Price := COALESCE (tmpAllGoodsPrice.Juridical_PricePromoOne, 0),
      inisJuridicalTwo := TRUE,
      inJuridicalTwoId := COALESCE (tmpAllGoodsPrice.JuridicalPromoTwoId, 0),
      inContractTwoId := COALESCE (tmpAllGoodsPrice.ContractPromoTwoId, 0),
      inJuridical_PriceTwo := COALESCE (tmpAllGoodsPrice.Juridical_PricePromoTwo, 0),
      inExpirationDateTwo := tmpAllGoodsPrice.ExpirationDateTwo,
      inisPromoBonus  := COALESCE (tmpAllGoodsPrice.isPromoBonus, False),
      inGUID := vbGUID,
      inSession := inSession)
    FROM tmpAllGoodsPriceSite AS tmpAllGoodsPrice
    WHERE idRepriceOne = False AND idReprice = TRUE;
      

    PERFORM gpInsertUpdate_MovementItem_RepriceSite_Clipped(
      ioID := 0 ,
      inGoodsId := tmpAllGoodsPrice.Id,
      inJuridicalId := COALESCE (tmpAllGoodsPrice.JuridicalId, 0),
      inContractId := COALESCE (tmpAllGoodsPrice.ContractId, 0),
      inExpirationDate := tmpAllGoodsPrice.ExpirationDate,
      inMinExpirationDate := tmpAllGoodsPrice.MinExpirationDate,
      inAmount := COALESCE (tmpAllGoodsPrice.RemainsCount, 0),
      inPriceOld := COALESCE (tmpAllGoodsPrice.LastPrice, 0),
      inPriceNew := COALESCE (tmpAllGoodsPrice.NewPrice, 0),
      inJuridical_Price := COALESCE (tmpAllGoodsPrice.Juridical_Price, 0),
      inisJuridicalTwo := False,
      inJuridicalTwoId := 0,
      inContractTwoId := 0,
      inJuridical_PriceTwo := 0,
      inExpirationDateTwo := Null,
      inisPromoBonus  := COALESCE (tmpAllGoodsPrice.isPromoBonus, False),
      inGUID := vbGUID,
      inSession := inSession)
    FROM tmpAllGoodsPriceSite AS tmpAllGoodsPrice
    WHERE idRepriceOne = True AND idReprice = False;
    
    PERFORM gpInsertUpdate_MovementItem_RepriceSite_Clipped(
      ioID := 0 ,
      inGoodsId := tmpAllGoodsPrice.Id,
      inJuridicalId := COALESCE (tmpAllGoodsPrice.JuridicalPromoOneId, 0),
      inContractId := COALESCE (tmpAllGoodsPrice.ContractPromoOneId, 0),
      inExpirationDate := tmpAllGoodsPrice.ExpirationDateOne,
      inMinExpirationDate := tmpAllGoodsPrice.MinExpirationDate,
      inAmount := COALESCE (tmpAllGoodsPrice.RemainsCount, 0),
      inPriceOld := COALESCE (tmpAllGoodsPrice.LastPrice, 0),
      inPriceNew := COALESCE (tmpAllGoodsPrice.NewPricePromo, 0),
      inJuridical_Price := COALESCE (tmpAllGoodsPrice.Juridical_PricePromoOne, 0),
      inisJuridicalTwo := TRUE,
      inJuridicalTwoId := COALESCE (tmpAllGoodsPrice.JuridicalPromoTwoId, 0),
      inContractTwoId := COALESCE (tmpAllGoodsPrice.ContractPromoTwoId, 0),
      inJuridical_PriceTwo := COALESCE (tmpAllGoodsPrice.Juridical_PricePromoTwo, 0),
      inExpirationDateTwo := tmpAllGoodsPrice.ExpirationDateTwo,
      inisPromoBonus  := COALESCE (tmpAllGoodsPrice.isPromoBonus, False),
      inGUID := vbGUID,
      inSession := inSession)
    FROM tmpAllGoodsPriceSite AS tmpAllGoodsPrice
    WHERE idRepriceOne = False AND idReprice = False;
    
    


  EXCEPTION
     WHEN others THEN
       GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     text_var1 = text_var1::Text;
     PERFORM lpLog_Run_Schedule_Function('gpRun_Object_RepriceUnitSheduler_UnitReprice ', True, text_var1::TVarChar, inSession::Integer);
  END;



/*    RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%> <%> <%>'
                                                     , (select Count(*) from tmpAllGoodsPriceSite)
                                                     , (select Count(*) from tmpAllGoodsPriceSite WHERE idRepriceOne = True AND idReprice = TRUE)
                                                     , (select Count(*) from tmpAllGoodsPriceSite WHERE idRepriceOne = False AND idReprice = TRUE)
                                                     , (select Count(*) from tmpAllGoodsPriceSite WHERE idRepriceOne = True AND idReprice = False)
                                                     , (select Count(*) from tmpAllGoodsPriceSite WHERE idRepriceOne = False AND idReprice = False)
                                                     , (select Count(*) from Object AS Object_PriceSite WHERE Object_PriceSite.DescId = zc_Object_PriceSite());  

*/

/*  raise notice 'All: % % % % %', (select Count(*) from tmpAllGoodsPrice where Reprice = True or RepricePromo = True)
                      
   , (select Count(*) from tmpAllGoodsPrice where idRepriceMain = True)
   , (select Count(*) from tmpAllGoodsPrice where idRepriceMain = False AND idRepriceSecond = True)
                        
    , (select Count(*) from tmpAllGoodsPrice where Reprice = True
      AND idRepriceMain = False AND idRepriceSecond = False
       OR Reprice = FALSE AND idRepriceMain = False AND idRepriceSecond = False AND isResolution_224 = True)

    , (select Count(*) from tmpAllGoodsPrice where idRepriceMain = False AND idRepriceSecond = False AND isResolution_224 = True);      
*/       
       
--  RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inID, inSession;  

--  raise notice 'All: %', (select Count(*) from tmpAllGoodsPrice);
--  raise notice 'All: %', (select Count(*) from tmpAllGoodsPrice where Reprice = True);
--  raise notice 'All: %', (select Count(*) from tmpAllGoodsPrice where Reprice = True
--                            AND PriceDiff <= vbPercentRepriceMax
--                            AND PriceDiff >= - vbPercentRepriceMin );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpRun_Object_RepriceSheduler_RepriceSite(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.11.21                                                       *
 10.06.21                                                       *
*/

-- тест
-- 
--SELECT * FROM gpRun_Object_RepriceSheduler_RepriceSite ('3')
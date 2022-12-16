-- Function: gpUpdate_MI_CalculationSaleSP()

DROP FUNCTION IF EXISTS gpUpdate_MI_CalculationSaleSP(Integer, Integer, Integer, TFloat, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_CalculationSaleSP(
    IN inJuridicalId       Integer   , -- Юр. лицо
    IN inPartnerMedicalId  Integer   , -- Мед. учереждение
    IN inNDSKind           Integer   , -- НДС
    IN inPercentSP         TFloat    , -- % скидки
    IN inDataJsonList      Text      , -- json Данные    
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
      /*TABLE (MovementItemId           Integer,
               UnitId                   Integer,
               SummOriginal             TFloat,
               SummSale                 TFloat,
               PriceOOC                 TFloat,
               ChangePercent            TFloat,
               Amount			        TFloat,
               SumCompSale		        TFloat,
               SumCompOOC		        TFloat,
               PriceSP		            TFloat
              )*/
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSum TFloat;
   DECLARE vbDSum TFloat;
   DECLARE vbItem Integer;
   DECLARE vbCount Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF COALESCE (inJuridicalId, 0) = 0 OR COALESCE (inPartnerMedicalId, 0) = 0 OR
     COALESCE (inNDSKind, 0) = 0 OR COALESCE (inPercentSP, 0) = 0
  THEN
    RAISE EXCEPTION 'Перераспределение сумм надо запускать по одному подразделению.';
  END IF;

  IF inDataJsonList = '[]'
  THEN
    RAISE EXCEPTION 'Данные с базы не загружены.';
  END IF;

 -- из JSON в таблицу
  CREATE TEMP TABLE tblDataJSON
  (
     MovementItemId           Integer,
     UnitId                   Integer,
     SummOriginal             TFloat,
     SummSale                 TFloat,
     PriceOOC                 TFloat,
     ChangePercent            TFloat,
     Amount			          TFloat
  ) ON COMMIT DROP;

  INSERT INTO tblDataJSON
  SELECT *
  FROM json_populate_recordset(null::tblDataJSON, replace(replace(replace(inDataJsonList, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    
  /*IF EXISTS (SELECT 1 FROM tblDataJSON WHERE COALESCE (tblDataJSON.UnitId, 0) <> inUnitId)
  THEN
    RAISE EXCEPTION 'В данных обнаружены разные подразделения.';
  END IF;*/
  
  ANALYSE tblDataJSON;
  
  ALTER TABLE tblDataJSON ADD SumCompSale TFloat;
  ALTER TABLE tblDataJSON ADD SumCompOOC TFloat;
  ALTER TABLE tblDataJSON ADD PriceSP TFloat;
  
  UPDATE tblDataJSON SET SumCompSale = CAST ((tblDataJSON.SummOriginal - COALESCE(tblDataJSON.SummSale, 0)) AS NUMERIC (16,2))  :: TFloat
                       , SumCompOOC  = ROUND(tblDataJSON.PriceOOC * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2);

  ANALYSE tblDataJSON;

  vbSum := (SELECT SUM(tblDataJSON.SumCompSale) FROM tblDataJSON);

  IF (SELECT SUM(tblDataJSON.SumCompSale) - SUM(tblDataJSON.SumCompOOC) FROM tblDataJSON) > 0
  THEN
    RAISE EXCEPTION 'Недостаточно суммы реализации для пересчета сумм.';
  END IF;

  UPDATE tblDataJSON SET PriceSP = CASE WHEN tblDataJSON.SumCompSale >= tblDataJSON.SumCompOOC AND COALESCE (tblDataJSON.SumCompOOC, 0) > 0 
                                        THEN tblDataJSON.PriceOOC
                                        ELSE CAST ((CASE WHEN tblDataJSON.Amount <> 0 
                                                         THEN (tblDataJSON.SummOriginal/tblDataJSON.Amount - COALESCE(tblDataJSON.SummSale, 0)/tblDataJSON.Amount) 
                                                         ELSE 0 END)  AS NUMERIC (16,2) ) :: TFloat
                                        END;
    
  vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  --raise notice 'Value 02: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  
  vbItem := 1;
  WHILE vbItem < 40
  LOOP

    vbCount := (SELECT COUNT(*) FROM tblDataJSON WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP);

    IF vbSum < (SELECT SUM(ROUND(CASE WHEN tblDataJSON.PriceOOC < ROUND(tblDataJSON.PriceSP * (1.0 + vbDSum / vbSum), 2) 
                                      THEN tblDataJSON.PriceOOC 
                                      ELSE ROUND(tblDataJSON.PriceSP * (1.0 + vbDSum / vbSum), 2) END * 
                                      tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON)
    THEN
      EXIT;
    END IF;
     
    UPDATE tblDataJSON SET PriceSP = CASE WHEN tblDataJSON.PriceOOC < ROUND(tblDataJSON.PriceSP * (1.0 + vbDSum / vbSum), 2) 
                                          THEN tblDataJSON.PriceOOC 
                                          ELSE ROUND(tblDataJSON.PriceSP * (1.0 + vbDSum / vbSum), 2) END
    WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP;

    ANALYSE tblDataJSON;

    IF vbDSum = (vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON))
    THEN
      EXIT;
    END IF;

    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 03: % - % % %', vbItem, vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);

    vbItem := vbItem + 1;
  END LOOP;  

  vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  --raise notice 'Value 04: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  
  IF vbDSum > 0 AND 
     ((SELECT SUM(ROUND((tblDataJSON.PriceSP + CASE WHEN tblDataJSON.PriceOOC > tblDataJSON.PriceSP THEN 0.01 ELSE 0 END) * 
       tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON)) <= vbSum
  THEN
    UPDATE tblDataJSON SET PriceSP = tblDataJSON.PriceSP + 0.01
    WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP;
  
    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 05: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  END IF;

  IF vbDSum > 0 AND 
     ((SELECT SUM(ROUND((tblDataJSON.PriceSP + CASE WHEN tblDataJSON.PriceOOC > tblDataJSON.PriceSP AND tblDataJSON.Amount <= 1 THEN 0.01 ELSE 0.0 END) * 
       tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)::TFloat) FROM tblDataJSON)) <= vbSum
  THEN
    UPDATE tblDataJSON SET PriceSP = tblDataJSON.PriceSP + 0.01
    WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP 
      AND tblDataJSON.Amount <= 1;
  
    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 06: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  END IF;
  
  IF vbDSum > 0
  THEN

    UPDATE tblDataJSON SET PriceSP = tblDataJSON.PriceSP + 0.01
    WHERE tblDataJSON.MovementItemId IN
          (WITH tmp AS (SELECT tblDataJSON.MovementItemId
                             , ROW_NUMBER() OVER (ORDER BY tblDataJSON.MovementItemId) AS Ord
                        FROM tblDataJSON
                        WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP
                          AND tblDataJSON.Amount = 1)
           SELECT tmp.MovementItemId
           FROM tmp
           WHERE tmp.ord <= vbDSum * 100);  

    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 07: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  END IF;

  IF vbDSum > 0
  THEN

    UPDATE tblDataJSON SET PriceSP = tblDataJSON.PriceSP + 0.01
    WHERE tblDataJSON.MovementItemId IN
          (WITH tmp AS (SELECT tblDataJSON.MovementItemId
                             , ROW_NUMBER() OVER (ORDER BY tblDataJSON.MovementItemId) AS Ord
                        FROM tblDataJSON
                        WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP
                          AND tblDataJSON.Amount = 1)
           SELECT tmp.MovementItemId
           FROM tmp
           WHERE tmp.ord <= vbDSum * 100);  

    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 08: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  END IF;

  IF vbDSum > 0
  THEN
    UPDATE tblDataJSON SET PriceSP = tblDataJSON.PriceSP + vbDSum
    WHERE tblDataJSON.MovementItemId =
          (SELECT tblDataJSON.MovementItemId
           FROM tblDataJSON
           WHERE tblDataJSON.PriceOOC - tblDataJSON.PriceSP >= vbDSum
             AND tblDataJSON.Amount = 1
           LIMIT 1);

    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 09: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  END IF;
  
  /*raise notice 'Value 10: % % % %'
               , vbDSum
               , vbSum
               , (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON)
               , (SELECT COUNT(*) FROM tblDataJSON WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP);*/
  
  IF vbDSum <> 0
  THEN
    RAISE EXCEPTION 'Невышло рапределить.';
  END IF;
    
  PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_UsePriceOOC(), DataJSON.MovementItemId, TRUE)
        , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSP(), DataJSON.MovementItemId, DataJSON.PriceSP)
  FROM tblDataJSON AS DataJSON;
                                          
  -- Результат
/*  RETURN QUERY
  SELECT DataJSON.MovementItemId
       , DataJSON.UnitId
       , DataJSON.SummOriginal
       , DataJSON.SummSale
       , DataJSON.PriceOOC
       , DataJSON.ChangePercent
       , DataJSON.Amount
       , DataJSON.SumCompSale
       , DataJSON.SumCompOOC
       , DataJSON.PriceSP
  FROM tblDataJSON AS DataJSON
  ;*/
  
    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
    END IF;

  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 10.04.22                                                                    *
*/

-- тест 


select * from gpUpdate_MI_CalculationSaleSP(inJuridicalId := 1311462 , inPartnerMedicalId := 3751525 , inNDSKind := 9 , inPercentSP := 100 , inDataJsonList := '[{"movementitemid":512356992,"unitid":10779386,"summoriginal":434,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":2},{"movementitemid":512928767,"unitid":10779386,"summoriginal":214.5,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":1},{"movementitemid":511832412,"unitid":10779386,"summoriginal":195,"summsale":null,"priceooc":304.13,"changepercent":100,"amount":1},{"movementitemid":512310420,"unitid":10779386,"summoriginal":305.7,"summsale":null,"priceooc":338.54,"changepercent":100,"amount":1},{"movementitemid":511817668,"unitid":10779386,"summoriginal":154.15,"summsale":null,"priceooc":338.54,"changepercent":100,"amount":0.5},{"movementitemid":512627577,"unitid":10779386,"summoriginal":940.8,"summsale":null,"priceooc":1392.18,"changepercent":100,"amount":1},{"movementitemid":511097531,"unitid":10779386,"summoriginal":145,"summsale":null,"priceooc":118.65,"changepercent":100,"amount":1},{"movementitemid":511727343,"unitid":10779386,"summoriginal":331,"summsale":null,"priceooc":165.2,"changepercent":100,"amount":2},{"movementitemid":511779515,"unitid":10779386,"summoriginal":116.51,"summsale":null,"priceooc":319.47,"changepercent":100,"amount":0.375},{"movementitemid":512595704,"unitid":10779386,"summoriginal":299,"summsale":null,"priceooc":156.4,"changepercent":100,"amount":2},{"movementitemid":512837053,"unitid":10779386,"summoriginal":274.5,"summsale":null,"priceooc":136.07,"changepercent":100,"amount":2.5},{"movementitemid":512906149,"unitid":10779386,"summoriginal":294,"summsale":null,"priceooc":159.93,"changepercent":100,"amount":2},{"movementitemid":511832316,"unitid":10779386,"summoriginal":116.5,"summsale":null,"priceooc":152.77,"changepercent":100,"amount":1},{"movementitemid":511832380,"unitid":10779386,"summoriginal":132.6,"summsale":null,"priceooc":474.27,"changepercent":100,"amount":0.3},{"movementitemid":511097337,"unitid":10779386,"summoriginal":164.8,"summsale":null,"priceooc":172.47,"changepercent":100,"amount":1},{"movementitemid":511094237,"unitid":10779386,"summoriginal":358.5,"summsale":null,"priceooc":430.23,"changepercent":100,"amount":1}]' ,  inSession := '3');



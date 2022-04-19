-- Function: gpUpdate_MI_CalculationSaleSP()

DROP FUNCTION IF EXISTS gpUpdate_MI_CalculationSaleSP(Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_CalculationSaleSP(
    IN inUnitId          Integer   , -- Подразделение
    IN inDataJsonList    Text      , -- json Данные    
    IN inSession         TVarChar    -- сессия пользователя
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

  IF COALESCE (inUnitId, 0) = 0
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
    
  IF EXISTS (SELECT 1 FROM tblDataJSON WHERE COALESCE (tblDataJSON.UnitId, 0) <> inUnitId)
  THEN
    RAISE EXCEPTION 'В данных обнаружены разные подразделения.';
  END IF;
  
  
  ALTER TABLE tblDataJSON ADD SumCompSale TFloat;
  ALTER TABLE tblDataJSON ADD SumCompOOC TFloat;
  ALTER TABLE tblDataJSON ADD PriceSP TFloat;
  
  UPDATE tblDataJSON SET SumCompSale = CAST ((tblDataJSON.SummOriginal - COALESCE(tblDataJSON.SummSale, 0)) AS NUMERIC (16,2))  :: TFloat
                       , SumCompOOC  = ROUND(tblDataJSON.PriceOOC * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2);

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
                                          
/*  -- Результат
  RETURN QUERY
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
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 10.04.22                                                                    *
*/

-- тест 


select * from gpUpdate_MI_CalculationSaleSP(inUnitId := 377605 , inDataJsonList := '[{"movementitemid":506913770,"unitid":377605,"summoriginal":192.12,"summsale":null,"priceooc":155.94,"changepercent":100,"amount":1.2},{"movementitemid":506665686,"unitid":377605,"summoriginal":342.8,"summsale":null,"priceooc":172.67,"changepercent":100,"amount":2},{"movementitemid":506913030,"unitid":377605,"summoriginal":342.8,"summsale":null,"priceooc":172.67,"changepercent":100,"amount":2}]' ,  inSession := '3');




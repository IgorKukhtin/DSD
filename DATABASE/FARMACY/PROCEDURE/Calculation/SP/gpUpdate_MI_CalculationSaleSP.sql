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
  --raise notice 'Value 01: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  
  vbItem := 1;
  WHILE vbItem < 40
  LOOP

    vbCount := (SELECT COUNT(*) FROM tblDataJSON WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP);
     
    UPDATE tblDataJSON SET PriceSP = CASE WHEN tblDataJSON.PriceOOC < ROUND(tblDataJSON.PriceSP * (1.0 + vbDSum / vbSum), 2) 
                                          THEN tblDataJSON.PriceOOC 
                                          ELSE ROUND(tblDataJSON.PriceSP * (1.0 + vbDSum / vbSum), 2) END
    WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP;
    
    IF vbDSum = (vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON))
    THEN
      EXIT;
    END IF;

    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 01: % - % % %', vbItem, vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);

    vbItem := vbItem + 1;
  END LOOP;  

  vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  raise notice 'Value 01: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  
  IF vbDSum > 0 AND 
     ((SELECT SUM(ROUND((tblDataJSON.PriceSP + CASE WHEN tblDataJSON.PriceOOC > tblDataJSON.PriceSP THEN 0.01 ELSE 0 END) * 
       tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON)) <= vbSum
  THEN
    UPDATE tblDataJSON SET PriceSP = tblDataJSON.PriceSP + 0.01
    WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP;
  
    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 01: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
  END IF;

  IF vbDSum > 0 AND 
     ((SELECT SUM(ROUND((tblDataJSON.PriceSP + CASE WHEN tblDataJSON.PriceOOC > tblDataJSON.PriceSP THEN 0.01 ELSE 0 END) * 
       tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON WHERE tblDataJSON.Amount <= 1)) <= vbSum
  THEN
    UPDATE tblDataJSON SET PriceSP = tblDataJSON.PriceSP + 0.01
    WHERE tblDataJSON.PriceOOC > tblDataJSON.PriceSP 
      AND tblDataJSON.Amount <= 1;
  
    vbDSum := vbSum - (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
    --raise notice 'Value 01: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
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
    --raise notice 'Value 04: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
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
    --raise notice 'Value 05: % % %', vbDSum, vbSum, (SELECT SUM(ROUND(tblDataJSON.PriceSP * tblDataJSON.Amount * tblDataJSON.ChangePercent / 100.0, 2)) FROM tblDataJSON);
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
  
/*  raise notice 'Value 10: % % % %'
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

-- select * from gpUpdate_MI_CalculationSaleSP(inUnitId := 377605 , inDataJsonList := '[{"movementitemid":506046751,"unitid":377605,"summoriginal":586.3,"summsale":null,"priceooc":601.4,"changepercent":100,"amount":1},{"movementitemid":505600959,"unitid":377605,"summoriginal":675.4,"summsale":null,"priceooc":303.89,"changepercent":100,"amount":2},{"movementitemid":505363687,"unitid":377605,"summoriginal":390.4,"summsale":null,"priceooc":401.42,"changepercent":100,"amount":1},{"movementitemid":504568216,"unitid":377605,"summoriginal":140,"summsale":null,"priceooc":127.66,"changepercent":100,"amount":1},{"movementitemid":505800050,"unitid":377605,"summoriginal":164.2,"summsale":null,"priceooc":184.66,"changepercent":100,"amount":1},{"movementitemid":505122522,"unitid":377605,"summoriginal":247,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":1},{"movementitemid":505376525,"unitid":377605,"summoriginal":234,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":1},{"movementitemid":505169004,"unitid":377605,"summoriginal":247,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":1},{"movementitemid":505392158,"unitid":377605,"summoriginal":468,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":2},{"movementitemid":505393379,"unitid":377605,"summoriginal":644.9,"summsale":null,"priceooc":841.56,"changepercent":100,"amount":1},{"movementitemid":504984347,"unitid":377605,"summoriginal":1567,"summsale":null,"priceooc":1417.33,"changepercent":100,"amount":1},{"movementitemid":505963954,"unitid":377605,"summoriginal":200.27,"summsale":null,"priceooc":586.59,"changepercent":100,"amount":0.334},{"movementitemid":505600601,"unitid":377605,"summoriginal":607.18,"summsale":null,"priceooc":492.79,"changepercent":100,"amount":1.333},{"movementitemid":505600533,"unitid":377605,"summoriginal":263.4,"summsale":null,"priceooc":291.31,"changepercent":100,"amount":1},{"movementitemid":505734047,"unitid":377605,"summoriginal":595.2,"summsale":null,"priceooc":539.33,"changepercent":100,"amount":1},{"movementitemid":505379088,"unitid":377605,"summoriginal":1124,"summsale":null,"priceooc":1042.23,"changepercent":100,"amount":1},{"movementitemid":505341961,"unitid":377605,"summoriginal":124.5,"summsale":null,"priceooc":240.52,"changepercent":100,"amount":1},{"movementitemid":505963554,"unitid":377605,"summoriginal":166.1,"summsale":null,"priceooc":212.37,"changepercent":100,"amount":1},{"movementitemid":505389795,"unitid":377605,"summoriginal":574.9,"summsale":null,"priceooc":589.67,"changepercent":100,"amount":1},{"movementitemid":505516044,"unitid":377605,"summoriginal":522.9,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.9},{"movementitemid":505587997,"unitid":377605,"summoriginal":522.9,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.9},{"movementitemid":505182782,"unitid":377605,"summoriginal":1045.8,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":1.8},{"movementitemid":505183646,"unitid":377605,"summoriginal":1568.7,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":2.7},{"movementitemid":505363661,"unitid":377605,"summoriginal":522.9,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.9},{"movementitemid":505559049,"unitid":377605,"summoriginal":522.9,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.9},{"movementitemid":505395549,"unitid":377605,"summoriginal":348.6,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.6},{"movementitemid":505185556,"unitid":377605,"summoriginal":626.7,"summsale":null,"priceooc":647.35,"changepercent":100,"amount":1},{"movementitemid":504593225,"unitid":377605,"summoriginal":655.5,"summsale":null,"priceooc":647.35,"changepercent":100,"amount":1},{"movementitemid":505186771,"unitid":377605,"summoriginal":2339.2,"summsale":null,"priceooc":683.54,"changepercent":100,"amount":4},{"movementitemid":504978761,"unitid":377605,"summoriginal":424.2,"summsale":null,"priceooc":257.04,"changepercent":100,"amount":2},{"movementitemid":505604058,"unitid":377605,"summoriginal":233.3,"summsale":null,"priceooc":322.38,"changepercent":100,"amount":1},{"movementitemid":505356374,"unitid":377605,"summoriginal":214.1,"summsale":null,"priceooc":210.07,"changepercent":100,"amount":1},{"movementitemid":505781244,"unitid":377605,"summoriginal":272.9,"summsale":null,"priceooc":310.73,"changepercent":100,"amount":1},{"movementitemid":504591572,"unitid":377605,"summoriginal":627,"summsale":null,"priceooc":310.73,"changepercent":100,"amount":2},{"movementitemid":505963622,"unitid":377605,"summoriginal":197.6,"summsale":null,"priceooc":171.33,"changepercent":100,"amount":1},{"movementitemid":505516054,"unitid":377605,"summoriginal":975.3,"summsale":null,"priceooc":936.78,"changepercent":100,"amount":1},{"movementitemid":505590212,"unitid":377605,"summoriginal":975.3,"summsale":null,"priceooc":936.78,"changepercent":100,"amount":1},{"movementitemid":505809618,"unitid":377605,"summoriginal":3284.4,"summsale":null,"priceooc":582.62,"changepercent":100,"amount":6},{"movementitemid":505182685,"unitid":377605,"summoriginal":3281.4,"summsale":null,"priceooc":582.62,"changepercent":100,"amount":6},{"movementitemid":506046789,"unitid":377605,"summoriginal":819.6,"summsale":null,"priceooc":260.48,"changepercent":100,"amount":3},{"movementitemid":505363645,"unitid":377605,"summoriginal":819.6,"summsale":null,"priceooc":260.48,"changepercent":100,"amount":3},{"movementitemid":505613436,"unitid":377605,"summoriginal":4729.2,"summsale":null,"priceooc":747.6,"changepercent":100,"amount":6},{"movementitemid":504982978,"unitid":377605,"summoriginal":204.58,"summsale":null,"priceooc":603.89,"changepercent":100,"amount":0.334},{"movementitemid":505811096,"unitid":377605,"summoriginal":1217.7,"summsale":null,"priceooc":338.77,"changepercent":100,"amount":3},{"movementitemid":505390534,"unitid":377605,"summoriginal":644.9,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":1},{"movementitemid":504505749,"unitid":377605,"summoriginal":683.7,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":1},{"movementitemid":505604083,"unitid":377605,"summoriginal":644.9,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":1},{"movementitemid":505609789,"unitid":377605,"summoriginal":3989.4,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":6},{"movementitemid":505355657,"unitid":377605,"summoriginal":1289.8,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":2},{"movementitemid":505181462,"unitid":377605,"summoriginal":681.8,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":1},{"movementitemid":504733904,"unitid":377605,"summoriginal":1363.6,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":2},{"movementitemid":505341846,"unitid":377605,"summoriginal":1619,"summsale":null,"priceooc":1585.19,"changepercent":100,"amount":1},{"movementitemid":505811536,"unitid":377605,"summoriginal":2386.8,"summsale":null,"priceooc":875.8,"changepercent":100,"amount":3},{"movementitemid":505734052,"unitid":377605,"summoriginal":795.6,"summsale":null,"priceooc":875.8,"changepercent":100,"amount":1},{"movementitemid":505557067,"unitid":377605,"summoriginal":2386.8,"summsale":null,"priceooc":875.8,"changepercent":100,"amount":3},{"movementitemid":505964958,"unitid":377605,"summoriginal":21.6,"summsale":null,"priceooc":23.3,"changepercent":100,"amount":1},{"movementitemid":504791501,"unitid":377605,"summoriginal":512,"summsale":null,"priceooc":265.31,"changepercent":100,"amount":2},{"movementitemid":505963769,"unitid":377605,"summoriginal":149,"summsale":null,"priceooc":168.51,"changepercent":100,"amount":1},{"movementitemid":505799931,"unitid":377605,"summoriginal":95,"summsale":null,"priceooc":214.53,"changepercent":100,"amount":0.5},{"movementitemid":505575840,"unitid":377605,"summoriginal":95,"summsale":null,"priceooc":214.53,"changepercent":100,"amount":0.5},{"movementitemid":505981832,"unitid":377605,"summoriginal":95,"summsale":null,"priceooc":214.53,"changepercent":100,"amount":0.5},{"movementitemid":505376845,"unitid":377605,"summoriginal":95,"summsale":null,"priceooc":214.53,"changepercent":100,"amount":0.5},{"movementitemid":505965642,"unitid":377605,"summoriginal":107.95,"summsale":null,"priceooc":236.62,"changepercent":100,"amount":0.5}]' ,  inSession := '3');

--select * from gpUpdate_MI_CalculationSaleSP(inUnitId := 377605 , inDataJsonList := '[{"movementitemid":506046751,"unitid":377605,"summoriginal":586.3,"summsale":null,"priceooc":601.4,"changepercent":100,"amount":1},{"movementitemid":505600959,"unitid":377605,"summoriginal":675.4,"summsale":null,"priceooc":303.89,"changepercent":100,"amount":2},{"movementitemid":505363687,"unitid":377605,"summoriginal":390.4,"summsale":null,"priceooc":401.42,"changepercent":100,"amount":1},{"movementitemid":504568216,"unitid":377605,"summoriginal":140,"summsale":null,"priceooc":127.66,"changepercent":100,"amount":1},{"movementitemid":505800050,"unitid":377605,"summoriginal":164.2,"summsale":null,"priceooc":184.66,"changepercent":100,"amount":1},{"movementitemid":505122522,"unitid":377605,"summoriginal":247,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":1},{"movementitemid":506253544,"unitid":377605,"summoriginal":234.2,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":1},{"movementitemid":505392158,"unitid":377605,"summoriginal":468,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":2},{"movementitemid":505376525,"unitid":377605,"summoriginal":234,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":1},{"movementitemid":505169004,"unitid":377605,"summoriginal":247,"summsale":null,"priceooc":225.24,"changepercent":100,"amount":1},{"movementitemid":505393379,"unitid":377605,"summoriginal":644.9,"summsale":null,"priceooc":841.56,"changepercent":100,"amount":1},{"movementitemid":504984347,"unitid":377605,"summoriginal":1567,"summsale":null,"priceooc":1417.33,"changepercent":100,"amount":1},{"movementitemid":505963954,"unitid":377605,"summoriginal":200.27,"summsale":null,"priceooc":586.59,"changepercent":100,"amount":0.334},{"movementitemid":505600601,"unitid":377605,"summoriginal":607.18,"summsale":null,"priceooc":492.79,"changepercent":100,"amount":1.333},{"movementitemid":505600533,"unitid":377605,"summoriginal":263.4,"summsale":null,"priceooc":291.31,"changepercent":100,"amount":1},{"movementitemid":505734047,"unitid":377605,"summoriginal":595.2,"summsale":null,"priceooc":539.33,"changepercent":100,"amount":1},{"movementitemid":505379088,"unitid":377605,"summoriginal":1124,"summsale":null,"priceooc":1042.23,"changepercent":100,"amount":1},{"movementitemid":505341961,"unitid":377605,"summoriginal":124.5,"summsale":null,"priceooc":240.52,"changepercent":100,"amount":1},{"movementitemid":505963554,"unitid":377605,"summoriginal":166.1,"summsale":null,"priceooc":212.37,"changepercent":100,"amount":1},{"movementitemid":505389795,"unitid":377605,"summoriginal":574.9,"summsale":null,"priceooc":589.67,"changepercent":100,"amount":1},{"movementitemid":505559049,"unitid":377605,"summoriginal":522.9,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.9},{"movementitemid":505182782,"unitid":377605,"summoriginal":1045.8,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":1.8},{"movementitemid":505183646,"unitid":377605,"summoriginal":1568.7,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":2.7},{"movementitemid":505587997,"unitid":377605,"summoriginal":522.9,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.9},{"movementitemid":505516044,"unitid":377605,"summoriginal":522.9,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.9},{"movementitemid":505363661,"unitid":377605,"summoriginal":522.9,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.9},{"movementitemid":505395549,"unitid":377605,"summoriginal":348.6,"summsale":null,"priceooc":597.39,"changepercent":100,"amount":0.6},{"movementitemid":505185556,"unitid":377605,"summoriginal":626.7,"summsale":null,"priceooc":647.35,"changepercent":100,"amount":1},{"movementitemid":504593225,"unitid":377605,"summoriginal":655.5,"summsale":null,"priceooc":647.35,"changepercent":100,"amount":1},{"movementitemid":505186771,"unitid":377605,"summoriginal":2339.2,"summsale":null,"priceooc":683.54,"changepercent":100,"amount":4},{"movementitemid":504978761,"unitid":377605,"summoriginal":424.2,"summsale":null,"priceooc":257.04,"changepercent":100,"amount":2},{"movementitemid":505604058,"unitid":377605,"summoriginal":233.3,"summsale":null,"priceooc":322.38,"changepercent":100,"amount":1},{"movementitemid":505356374,"unitid":377605,"summoriginal":214.1,"summsale":null,"priceooc":210.07,"changepercent":100,"amount":1},{"movementitemid":504591572,"unitid":377605,"summoriginal":627,"summsale":null,"priceooc":310.73,"changepercent":100,"amount":2},{"movementitemid":505781244,"unitid":377605,"summoriginal":272.9,"summsale":null,"priceooc":310.73,"changepercent":100,"amount":1},{"movementitemid":505963622,"unitid":377605,"summoriginal":197.6,"summsale":null,"priceooc":171.33,"changepercent":100,"amount":1},{"movementitemid":505516054,"unitid":377605,"summoriginal":975.3,"summsale":null,"priceooc":936.78,"changepercent":100,"amount":1},{"movementitemid":505590212,"unitid":377605,"summoriginal":975.3,"summsale":null,"priceooc":936.78,"changepercent":100,"amount":1},{"movementitemid":505809618,"unitid":377605,"summoriginal":3284.4,"summsale":null,"priceooc":582.62,"changepercent":100,"amount":6},{"movementitemid":505182685,"unitid":377605,"summoriginal":3281.4,"summsale":null,"priceooc":582.62,"changepercent":100,"amount":6},{"movementitemid":506046789,"unitid":377605,"summoriginal":819.6,"summsale":null,"priceooc":260.48,"changepercent":100,"amount":3},{"movementitemid":505363645,"unitid":377605,"summoriginal":819.6,"summsale":null,"priceooc":260.48,"changepercent":100,"amount":3},{"movementitemid":505613436,"unitid":377605,"summoriginal":4729.2,"summsale":null,"priceooc":747.6,"changepercent":100,"amount":6},{"movementitemid":504982978,"unitid":377605,"summoriginal":204.58,"summsale":null,"priceooc":603.89,"changepercent":100,"amount":0.334},{"movementitemid":505811096,"unitid":377605,"summoriginal":1217.7,"summsale":null,"priceooc":338.77,"changepercent":100,"amount":3},{"movementitemid":505390534,"unitid":377605,"summoriginal":644.9,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":1},{"movementitemid":505355657,"unitid":377605,"summoriginal":1289.8,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":2},{"movementitemid":504505749,"unitid":377605,"summoriginal":683.7,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":1},{"movementitemid":505604083,"unitid":377605,"summoriginal":644.9,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":1},{"movementitemid":505609789,"unitid":377605,"summoriginal":3989.4,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":6},{"movementitemid":505181462,"unitid":377605,"summoriginal":681.8,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":1},{"movementitemid":504733904,"unitid":377605,"summoriginal":1363.6,"summsale":null,"priceooc":694.99,"changepercent":100,"amount":2},{"movementitemid":505341846,"unitid":377605,"summoriginal":1619,"summsale":null,"priceooc":1585.19,"changepercent":100,"amount":1},{"movementitemid":505811536,"unitid":377605,"summoriginal":2386.8,"summsale":null,"priceooc":875.8,"changepercent":100,"amount":3},{"movementitemid":505557067,"unitid":377605,"summoriginal":2386.8,"summsale":null,"priceooc":875.8,"changepercent":100,"amount":3},{"movementitemid":505734052,"unitid":377605,"summoriginal":795.6,"summsale":null,"priceooc":875.8,"changepercent":100,"amount":1},{"movementitemid":505964958,"unitid":377605,"summoriginal":21.6,"summsale":null,"priceooc":23.3,"changepercent":100,"amount":1},{"movementitemid":506252481,"unitid":377605,"summoriginal":107.2,"summsale":null,"priceooc":null,"changepercent":100,"amount":1},{"movementitemid":504791501,"unitid":377605,"summoriginal":512,"summsale":null,"priceooc":265.31,"changepercent":100,"amount":2},{"movementitemid":505963769,"unitid":377605,"summoriginal":149,"summsale":null,"priceooc":168.51,"changepercent":100,"amount":1},{"movementitemid":505799931,"unitid":377605,"summoriginal":95,"summsale":null,"priceooc":214.53,"changepercent":100,"amount":0.5},{"movementitemid":505575840,"unitid":377605,"summoriginal":95,"summsale":null,"priceooc":214.53,"changepercent":100,"amount":0.5},{"movementitemid":505981832,"unitid":377605,"summoriginal":95,"summsale":null,"priceooc":214.53,"changepercent":100,"amount":0.5},{"movementitemid":505376845,"unitid":377605,"summoriginal":95,"summsale":null,"priceooc":214.53,"changepercent":100,"amount":0.5},{"movementitemid":506234511,"unitid":377605,"summoriginal":107.95,"summsale":null,"priceooc":236.62,"changepercent":100,"amount":0.5},{"movementitemid":505965642,"unitid":377605,"summoriginal":107.95,"summsale":null,"priceooc":236.62,"changepercent":100,"amount":0.5}]' ,  inSession := '3');


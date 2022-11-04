-- Function: zfCalc_MarketingPlan_Scale

--DROP FUNCTION IF EXISTS zfCalc_MarketingPlan_Scale (Integer, TDateTime, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_MarketingPlan_Scale (Integer, TDateTime, Integer, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_MarketingPlan_Scale (
       IN inScaleCalcMarketingPlanID Integer,
       IN inOperDate TDateTime,
       IN inUniitID Integer,
       IN inTotalExecutionLine TFloat,
       IN inAmountTheFineTab TFloat,
       IN inBonusAmountTab TFloat
       )
RETURNS TFloat
AS
$BODY$
  DECLARE vbTotal TFloat;
  DECLARE vbisAP Boolean;
  DECLARE vbUnitCategoryCode Integer;
BEGIN

  vbTotal := 0;

  IF  date_trunc('month', inOperDate) >= '01.11.2022'
  THEN
  
    SELECT Object_Unit.ValueData ILIKE '¿ÔÚ. ÔÛÌÍÚ %'
         , Object_UnitCategory.ObjectCode 
    INTO vbisAP, vbUnitCategoryCode
    FROM Object AS Object_Unit
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                              ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id 
                             AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
         LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId
    WHERE Object_Unit.Id        = inUniitID
      AND Object_Unit.DescId    = zc_Object_Unit();
      
    IF vbUnitCategoryCode = 2 -- A
    THEN
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 55 THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 85 THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                      ELSE inBonusAmountTab END;      
    ELSEIF vbUnitCategoryCode = 3 -- B
    THEN
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 35 THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 50 THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 80 THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                      ELSE inBonusAmountTab END;          
    ELSEIF vbUnitCategoryCode = 5 -- C
    THEN
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 42 THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 75 THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                      ELSE inBonusAmountTab END;              
    ELSEIF vbUnitCategoryCode = 8 -- D
    THEN
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 25 THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 37 THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 60 THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                      ELSE inBonusAmountTab END;              
    END IF;
    
    IF vbTotal < 0 AND vbisAP = TRUE THEN vbTotal := 0; END IF;
                                       
  ELSEIF  date_trunc('month', inOperDate) >= '01.04.2022' and date_trunc('month', inOperDate) <= '01.05.2022'
  THEN
    vbTotal := inBonusAmountTab;
  ELSE
    IF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_AB()
    THEN
      IF inOperDate < '01.08.2021'
      THEN
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 60 THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 90 THEN inBonusAmountTab - inAmountTheFineTab
                        ELSE inBonusAmountTab  END;  
      ELSE
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 60 THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 90 THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                        ELSE inBonusAmountTab  END;  
      END IF;
    ELSEIF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_CC1()
    THEN
      IF inOperDate < '01.06.2021'
      THEN
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 50 THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 80 THEN inBonusAmountTab - inAmountTheFineTab
                        ELSE inBonusAmountTab  END;      
      ELSEIF inOperDate < '01.08.2021'
      THEN
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 50 THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 80 THEN inBonusAmountTab - inAmountTheFineTab
                        ELSE inBonusAmountTab  END;          
      ELSE
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 50 THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 80 THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                        ELSE inBonusAmountTab  END;          
      END IF;
    ELSEIF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_D()
    THEN
      IF inOperDate < '01.06.2021'
      THEN
        vbTotal := 0;     
      ELSEIF inOperDate < '01.08.2021'
      THEN
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 70 THEN inBonusAmountTab - inAmountTheFineTab
                        ELSE inBonusAmountTab  END;          
      ELSE
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 70 THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                        ELSE inBonusAmountTab  END;          
      END IF;
    ELSE
      vbTotal := 0;
    END IF;  

    IF (inOperDate >= '01.06.2021' AND inOperDate < '01.08.2021') AND vbTotal < 0
    THEN
      vbTotal := vbTotal / 2;   
    END IF;
  END IF;

  RETURN vbTotal;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MarketingPlan_Scale (Integer, TDateTime, Integer, TFloat, TFloat, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ÿ‡·ÎËÈ Œ.¬.
 02.06.21                                                       *
*/

-- ÚÂÒÚ 
SELECT * FROM zfCalc_MarketingPlan_Scale (zc_Enum_ScaleCalcMarketingPlan_CC1(), '01.11.2022', 10779386, 36.96, 607.45, 99.44)	
-- Function: zfCalc_MarketingPlan_Scale

DROP FUNCTION IF EXISTS zfCalc_MarketingPlan_Scale (Integer, TDateTime, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_MarketingPlan_Scale (
       IN inScaleCalcMarketingPlanID Integer,
       IN inOperDate TDateTime,
       IN inTotalExecutionLine TFloat,
       IN inAmountTheFineTab TFloat,
       IN inBonusAmountTab TFloat
       )
RETURNS TFloat
AS
$BODY$
  DECLARE vbTotal TFloat;
BEGIN

  vbTotal := 0;

  IF  date_trunc('month', inOperDate) >= '01.04.2022' and date_trunc('month', inOperDate) <= '01.05.2022'
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
ALTER FUNCTION zfCalc_MarketingPlan_Scale (Integer, TDateTime, TFloat, TFloat, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Øàáëèé Î.Â.
 02.06.21                                                       *
*/

-- òåñò 
SELECT * FROM zfCalc_MarketingPlan_Scale (zc_Enum_ScaleCalcMarketingPlan_CC1(), '01.06.2022', 51.11, 313.11, 78.51)	
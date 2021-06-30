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

  IF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_AB()
  THEN
    vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                    WHEN ROUND(inTotalExecutionLine, 2) < 60 THEN - inAmountTheFineTab / 3  
                    WHEN ROUND(inTotalExecutionLine, 2) < 90 THEN inBonusAmountTab - inAmountTheFineTab
                    ELSE inBonusAmountTab  END;  
  ELSEIF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_CC1()
  THEN
    IF inOperDate < '01.06.2021'
    THEN
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 50 THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 80 THEN inBonusAmountTab - inAmountTheFineTab
                      ELSE inBonusAmountTab  END;      
    ELSE
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 50 THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 80 THEN inBonusAmountTab - inAmountTheFineTab
                      ELSE inBonusAmountTab  END;          
    END IF;
  ELSEIF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_D()
  THEN
    IF inOperDate < '01.06.2021'
    THEN
      vbTotal := 0;     
    ELSE
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 70 THEN inBonusAmountTab - inAmountTheFineTab
                      ELSE inBonusAmountTab  END;          
    END IF;
  ELSE
    vbTotal := 0;
  END IF;  

  IF inOperDate >= '01.06.2021' AND vbTotal < 0
  THEN
    vbTotal := vbTotal / 2;   
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

-- òåñò SELECT * FROM zfCalc_MarketingPlan_Scale (zc_Enum_ScaleCalcMarketingPlan_D(), '01.06.2021', 10, 10, 20)
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
BEGIN

  IF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_AB()
  THEN
    RETURN CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                WHEN ROUND(inTotalExecutionLine, 2) < 60 THEN - inAmountTheFineTab / 3  
                WHEN ROUND(inTotalExecutionLine, 2) < 90 THEN inBonusAmountTab - inAmountTheFineTab
                ELSE inBonusAmountTab  END;  
  ELSEIF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_CC1()
  THEN
    IF inOperDate < '01.06.2021'
    THEN
      RETURN CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 THEN - inAmountTheFineTab / 2  
                  WHEN ROUND(inTotalExecutionLine, 2) < 50 THEN - inAmountTheFineTab / 3  
                  WHEN ROUND(inTotalExecutionLine, 2) < 80 THEN inBonusAmountTab - inAmountTheFineTab
                  ELSE inBonusAmountTab  END;      
    ELSE
      RETURN CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 2  
                  WHEN ROUND(inTotalExecutionLine, 2) < 50 THEN - inAmountTheFineTab / 3  
                  WHEN ROUND(inTotalExecutionLine, 2) < 80 THEN inBonusAmountTab - inAmountTheFineTab
                  ELSE inBonusAmountTab  END;          
    END IF;
  ELSEIF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_D()
  THEN
    IF inOperDate < '01.06.2021'
    THEN
      RETURN 0;     
    ELSE
      RETURN CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 THEN - inAmountTheFineTab / 2  
                  WHEN ROUND(inTotalExecutionLine, 2) < 40 THEN - inAmountTheFineTab / 3  
                  WHEN ROUND(inTotalExecutionLine, 2) < 70 THEN inBonusAmountTab - inAmountTheFineTab
                  ELSE inBonusAmountTab  END;          
    END IF;
  ELSE
    RETURN 0;
  END IF;  

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

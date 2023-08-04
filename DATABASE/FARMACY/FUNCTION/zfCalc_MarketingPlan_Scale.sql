-- Function: zfCalc_MarketingPlan_Scale

--DROP FUNCTION IF EXISTS zfCalc_MarketingPlan_Scale (Integer, TDateTime, TFloat, TFloat, TFloat);
--DROP FUNCTION IF EXISTS zfCalc_MarketingPlan_Scale (Integer, TDateTime, Integer, TFloat, TFloat, TFloat);
--DROP FUNCTION IF EXISTS zfCalc_MarketingPlan_Scale (Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat);
--DROP FUNCTION IF EXISTS zfCalc_MarketingPlan_Scale (Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, boolean, boolean);
DROP FUNCTION IF EXISTS zfCalc_MarketingPlan_Scale (Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, boolean, boolean, boolean);

CREATE OR REPLACE FUNCTION zfCalc_MarketingPlan_Scale (
       IN inScaleCalcMarketingPlanID Integer,
       IN inOperDate TDateTime,
       IN inUniitID Integer,
       IN inTotalExecutionLine TFloat,
       IN inTotalExecutionFixed TFloat,
       IN inAmountTheFineTab TFloat,
       IN inBonusAmountTab TFloat,
       IN inAddBonusPercentTab TFloat,
       IN inAddBonusPercentSum TFloat,
       IN inisNewUser Boolean,
       IN inisCashier Boolean,
       IN inisAdmin Boolean
       )
RETURNS TFloat
AS
$BODY$
  DECLARE vbTotal TFloat;
  DECLARE vbisAP Boolean;
  DECLARE vbUnitCategoryCode Integer;
  DECLARE vbPrizeThreshold TFloat;
  DECLARE vbMarkPlanThreshol TFloat;
BEGIN

  vbTotal := 0;
  
  SELECT COALESCE(History_CashSettings.PrizeThreshold, 0)
       , COALESCE(History_CashSettings.MarkPlanThreshol, 0)
  INTO vbPrizeThreshold, vbMarkPlanThreshol
  FROM gpSelect_ObjectHistory_CashSettings (0, zfCalc_UserAdmin()) AS History_CashSettings
  WHERE History_CashSettings.StartDate <= date_trunc('month', inOperDate)
    AND History_CashSettings.EndDate > date_trunc('month', inOperDate);
                                                                      
  vbPrizeThreshold := COALESCE (vbPrizeThreshold, 0);
  vbMarkPlanThreshol := COALESCE (vbMarkPlanThreshol, 0);

  IF  date_trunc('month', inOperDate) >= '01.11.2022'
  THEN
  
    /*IF  date_trunc('month', inOperDate) >= '01.04.2023' AND inBonusAmountTab > 0 AND Round(inTotalExecutionFixed, 2) < 45
    THEN
      inBonusAmountTab := ROUND(inBonusAmountTab * 0.7, 2);
    END IF;  */
  
    SELECT Object_Unit.ValueData ILIKE '���. ����� %'
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
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 55 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 85 + vbPrizeThreshold 
                      THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                      ELSE ROUND(inBonusAmountTab * CASE WHEN date_trunc('month', inOperDate) >= '01.04.2023' AND Round(inTotalExecutionFixed, 2) < 45 THEN 0.7 ELSE 1.0 END, 2) END;
    ELSEIF vbUnitCategoryCode = 3 -- B
    THEN
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 35 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 50 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 80 + vbPrizeThreshold  
                      THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                      ELSE ROUND(inBonusAmountTab * CASE WHEN date_trunc('month', inOperDate) >= '01.04.2023' AND Round(inTotalExecutionFixed, 2) < 45 THEN 0.7 ELSE 1.0 END, 2) END;
    ELSEIF vbUnitCategoryCode = 5 -- C
    THEN
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 42 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 75 + vbPrizeThreshold  
                      THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                      ELSE ROUND(inBonusAmountTab * CASE WHEN date_trunc('month', inOperDate) >= '01.04.2023' AND Round(inTotalExecutionFixed, 2) < 45 THEN 0.7 ELSE 1.0 END, 2) END;
    ELSEIF vbUnitCategoryCode = 8 -- D
    THEN
      vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 25 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                      WHEN ROUND(inTotalExecutionLine, 2) < 37 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                      WHEN ROUND(inTotalExecutionLine, 2) < 60 + vbPrizeThreshold  
                      THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                      ELSE ROUND(inBonusAmountTab * CASE WHEN date_trunc('month', inOperDate) >= '01.04.2023' AND Round(inTotalExecutionFixed, 2) < 45 THEN 0.7 ELSE 1.0 END, 2) END;              
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
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 60 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 90 + vbPrizeThreshold  
                        THEN inBonusAmountTab - inAmountTheFineTab
                        ELSE inBonusAmountTab  END;  
      ELSE
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 60 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 90 + vbPrizeThreshold  
                        THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                        ELSE inBonusAmountTab  END;  
      END IF;
    ELSEIF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_CC1()
    THEN
      IF inOperDate < '01.06.2021'
      THEN
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 50 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 80 + vbPrizeThreshold  
                        THEN inBonusAmountTab - inAmountTheFineTab
                        ELSE inBonusAmountTab  END;      
      ELSEIF inOperDate < '01.08.2021'
      THEN
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 50 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 80 + vbPrizeThreshold  
                        THEN inBonusAmountTab - inAmountTheFineTab
                        ELSE inBonusAmountTab  END;          
      ELSE
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 40 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 50 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 80 + vbPrizeThreshold  
                        THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
                        ELSE inBonusAmountTab  END;          
      END IF;
    ELSEIF inScaleCalcMarketingPlanID = zc_Enum_ScaleCalcMarketingPlan_D()
    THEN
      IF inOperDate < '01.06.2021'
      THEN
        vbTotal := 0;     
      ELSEIF inOperDate < '01.08.2021'
      THEN
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 40 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 70 + vbPrizeThreshold  
                        THEN inBonusAmountTab - inAmountTheFineTab
                        ELSE inBonusAmountTab  END;          
      ELSE
        vbTotal := CASE WHEN ROUND(inTotalExecutionLine, 2) < 30 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 2  
                        WHEN ROUND(inTotalExecutionLine, 2) < 40 + vbMarkPlanThreshol THEN - inAmountTheFineTab / 3  
                        WHEN ROUND(inTotalExecutionLine, 2) < 70 + vbPrizeThreshold  
                        THEN (inBonusAmountTab - inAmountTheFineTab) / CASE WHEN (inBonusAmountTab - inAmountTheFineTab) < 0 THEN 2 ELSE 1 END
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
  
  IF inOperDate >= '01.07.2023' AND inisCashier = TRUE AND (inisNewUser = TRUE OR vbUnitCategoryCode = 8) 
  THEN
    vbTotal := 0;
    IF ROUND(inTotalExecutionLine, 2) >= 75 + vbPrizeThreshold
    THEN
      vbTotal := inBonusAmountTab;
    ELSEIF inBonusAmountTab > 500 
    THEN
      vbTotal := inAddBonusPercentSum;
    ELSEIF inBonusAmountTab > 250 
    THEN
      vbTotal := inAddBonusPercentTab;
    END IF;
  ELSEIF inisNewUser = TRUE AND vbTotal < 0 
  THEN
    vbTotal := 0;
  END IF;
  
  IF NOT inisCashier AND vbTotal < 0 
  THEN
    vbTotal := 0;
  END IF;
  

  RETURN vbTotal;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MarketingPlan_Scale (Integer, TDateTime, Integer, TFloat, TFloat, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.06.21                                                       *
*/

-- ���� 

SELECT * FROM zfCalc_MarketingPlan_Scale (zc_enum_scalecalcmarketingplan_cc1(), '01.07.2023', 13711869, 77.25, 12.21, 4412.88, 1095.48, 111, 222, False, False)
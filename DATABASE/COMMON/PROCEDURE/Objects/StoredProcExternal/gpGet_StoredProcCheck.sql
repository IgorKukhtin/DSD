-- Function: gpGet_StoredProcCheck()

DROP FUNCTION IF EXISTS gpGet_StoredProcCheck (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_StoredProcCheck(
    IN inStoredProc   TVarChar , -- �������� ���������
    IN inParam1       TVarChar , -- �������� ���������
    IN inValue1       TVarChar , -- ��������
    IN inParam2       TVarChar , -- �������� ���������
    IN inValue2       TVarChar , -- ��������
    IN inParam3       TVarChar , -- �������� ���������
    IN inValue3       TVarChar , -- ��������
    IN inParam4       TVarChar , -- �������� ���������
    IN inValue4       TVarChar , -- ��������
    IN inParam5       TVarChar , -- �������� ���������
    IN inValue5       TVarChar , -- ��������
    IN inParam6       TVarChar , -- �������� ���������
    IN inValue6       TVarChar , -- ��������
    IN inParam7       TVarChar , -- �������� ���������
    IN inValue7       TVarChar , -- ��������
    IN inParam8       TVarChar , -- �������� ���������
    IN inValue8       TVarChar , -- ��������
    IN inParam9       TVarChar , -- �������� ���������
    IN inValue9       TVarChar , -- ��������
    IN inParam10      TVarChar , -- �������� ���������
    IN inValue10      TVarChar , -- ��������
    IN inSession      TVarChar   -- ������ ������������
)
RETURNS BOOLEAN
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbStartDate TDateTime;
  DECLARE vbEndDate   TDateTime;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpGetUserBySession (inSession);
      
      -- RAISE EXCEPTION '������.<%> %', inParam1, inParam2;
      -- RETURN FALSE;
      
      vbStartDate:= CASE -- ��� ������
                         WHEN -- ��� JuridicalDeferment...
                              (inParam1 ILIKE '%inOperDate%' AND inParam2 ILIKE '%inEmptyParam%')
                              -- ���������
                           OR TRIM (inStoredProc) ILIKE 'gpReport_ProductionOrder'
                           OR TRIM (inStoredProc) ILIKE 'Report_OrderExternal_MIChild_Detail'
                           --
                           OR TRIM (inStoredProc) ILIKE 'gpReport_GoodsBalance'
                           OR TRIM (inStoredProc) ILIKE 'gpReport_GoodsMI_Internal'
                           --
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractChoice'
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractChoice_byPromo'
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractJuridical'
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractPartnerChoice'
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractPartnerOrderChoice'
                           --
                           OR (TRIM (inStoredProc) ILIKE 'gpSelect_Scale_Goods' AND zfConvert_StringToNumber (inValue3) = 0)
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Scale_Partner'
                              --
                              THEN zc_DateStart()
                         --
                         WHEN inParam1  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue1)
                         WHEN inParam2  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue2)
                         WHEN inParam3  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue3)
                         WHEN inParam4  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue4)
                         WHEN inParam5  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue5)
                         WHEN inParam6  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue6)
                         WHEN inParam7  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue7)
                         WHEN inParam8  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue8)
                         WHEN inParam9  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue9)
                         WHEN inParam10 ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue10)

                    END;

      vbEndDate  := CASE -- ��� ������
                         WHEN -- ��� JuridicalDeferment...
                              (inParam1 ILIKE '%inOperDate%' AND inParam2 ILIKE '%inEmptyParam%')
                              -- ���������
                           OR TRIM (inStoredProc) ILIKE 'gpReport_ProductionOrder'
                           OR TRIM (inStoredProc) ILIKE 'Report_OrderExternal_MIChild_Detail'
                           --
                           OR TRIM (inStoredProc) ILIKE 'gpReport_GoodsBalance'
                           OR TRIM (inStoredProc) ILIKE 'gpReport_GoodsMI_Internal'
                           --
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractChoice'
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractChoice_byPromo'
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractJuridical'
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractPartnerChoice'
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractPartnerOrderChoice'
                           --
                           OR (TRIM (inStoredProc) ILIKE 'gpSelect_Scale_Goods' AND zfConvert_StringToNumber (inValue3) = 0)
                           OR TRIM (inStoredProc) ILIKE 'gpSelect_Scale_Partner'
                              --
                              THEN zc_DateStart()
                         --
                         WHEN inParam1  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue1)
                         WHEN inParam2  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue2)
                         WHEN inParam3  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue3)
                         WHEN inParam4  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue4)
                         WHEN inParam5  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue5)
                         WHEN inParam6  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue6)
                         WHEN inParam7  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue7)
                         WHEN inParam8  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue8)
                         WHEN inParam9  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue9)
                         WHEN inParam10 ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue10)
                    END;

      IF vbEndDate < CURRENT_DATE
         AND vbStartDate <= (CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                  -- ��������� ���� ����������� ������
                                  THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
 
                                  WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 7
                                  -- ������ ���� ����������� ������
                                  THEN DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY')
                                  
                                  -- ��������� ���� ��� ������ �����
                                  ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                             END)
         -- ���������
         AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_Movement_MemberHoliday'
         AND vbUserId <> 440561 -- ��������� �.�.
      THEN 
           RETURN TRUE;
           --RETURN FALSE;
      ELSE 
           RETURN FALSE;
      END IF;
                                 

      
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
  26.08.23                                       *
  18.08.23                                                      *
*/

-- ����
-- 
-- SELECT * FROM gpGet_StoredProcCheck (inStoredProc := 'gpSelect_Movement_Income', inParam1 := 'inStartDate', inValue1 := '25.07.2023', inParam2 := 'inEndDate', inValue2 := '25.07.2023', inParam3 := 'inIsErased', inValue3 := 'False', inParam4 := 'inJuridicalBasisId', inValue4 := '9399', inParam5 := '', inValue5 := '', inParam6 := '', inValue6 := '', inParam7 := '', inValue7 := '', inParam8 := '', inValue8 := '', inParam9 := '', inValue9 := '', inParam10 := '', inValue10 := '', inSession:= zfCalc_UserAdmin())

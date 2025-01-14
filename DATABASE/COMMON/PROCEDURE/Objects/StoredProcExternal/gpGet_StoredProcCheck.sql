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
  DECLARE vbUserId      Integer;
  DECLARE vbLastId_srv  Bigint;
  DECLARE vbStartDate   TDateTime;
  DECLARE vbEndDate     TDateTime;
  DECLARE vbIsReal_only Boolean;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);

      -- RAISE EXCEPTION '������. <%> <%>  %  %', vbStartDate, vbEndDate, inValue1, inValue2;
      -- RETURN FALSE;
      
      -- �������� - ���������� ���� ����� �� SRV-A
      vbIsReal_only:= FALSE;
      -- ������ ��������� ���������� �� SRV-A
      -- vbIsReal_only:= TRUE AND vbUserId <> 5;
      
      IF vbUserId = 5 AND 1=0
      THEN
           -- 0. !!!Admin!!!
          RETURN TRUE;

      ELSEIF vbUserId = 5 AND (TRIM (inStoredProc) ILIKE 'gpReport_ReceiptAnalyze'
                            OR TRIM (inStoredProc) ILIKE 'gpReport_ReceiptSaleAnalyzeReal'
                              )
             AND 1=0
      THEN
           -- 0. !!!Admin!!!
          RETURN TRUE;
      

      -- ���� �������� SRV-A
      ELSEIF vbIsReal_only = TRUE OR 1=1
          -- !!!����� ����������!!!
          OR (TRIM (inStoredProc) ILIKE 'gpReport_Balance'
              AND vbUserId <> 5
             )
      THEN
           -- 0.1.
          RETURN FALSE;
      ELSE
          -- ������ SRV-A 
          vbLastId_srv:= (WITH tmp_settings AS (SELECT gpSelect.Value :: Bigint AS LastId_srv
                                                FROM dblink('host=192.168.0.213 dbname=project_a port=5432 user=project password=sqoII5szOnrcZxJVF1BL' :: Text
                                                          , (' SELECT Value'
                                                          || ' FROM _replica.settings WHERE Id = 2') :: Text
                                                           ) AS gpSelect (Value     TVarChar
                                                                         )
                                               )
                          SELECT tmp_settings.LastId_srv FROM tmp_settings
                         );
                         
                         
          -- 1.0. �������� ���� ������� ���������
          IF EXISTS (SELECT 1 FROM _replica.table_update_data
                         WHERE Id = vbLastId_srv
                           AND last_modified < timezone('utc'::text, CURRENT_TIMESTAMP - INTERVAL '11 MIN')
                        )
             -- AND vbUserId <> 5
             AND (zfConvert_StringToDate (inValue2) > DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '2 MONTH'
               OR zfConvert_StringToDate (inValue2) IS NULL
                 )
          THEN
              -- 1.0.
              RETURN FALSE;

          -- 1.1. �� ������� ������ - ������ gpSelect_Report_Wage
          ELSEIF (zfConvert_StringToDate (inValue1) < zfConvert_StringToDate (inValue2) - INTERVAL '3 MONTH'
                   -- ������� �.�.
             --OR (vbUserId = 6561986 AND zfConvert_StringToDate (inValue2) < DATE_TRUNC ('MONTH', CURRENT_DATE))
                 )
             AND TRIM (inStoredProc) ILIKE 'gpSelect_Report_Wage%'
             -- "�������� - ������������"
             --AND EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 3745487)
          THEN
              -- 1.1.
              RETURN TRUE;
    
          -- 1.2. "�������� - ������������" - ������ ������� ������
          ELSEIF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 3745487)
          THEN
              -- 1.2.
              RETURN FALSE;
    
          -- 1.3. �� ������� ������ - ��������� �� SRV-A 
          ELSEIF zfConvert_StringToDate (inValue1) < zfConvert_StringToDate (inValue2) - INTERVAL '3 MONTH'
              AND TRIM (inStoredProc) NOT ILIKE '%gpSelect%'
          THEN
              -- 1.3.
              RETURN TRUE;
    
          ELSE
              -- ��� ���� �������
              vbStartDate:= CASE -- ��� ������
                                 WHEN -- ��� JuridicalDeferment...
                                      (inParam1 ILIKE '%inOperDate%' AND inParam2 ILIKE '%inEmptyParam%')
                                      -- ���������
                                   OR TRIM (inStoredProc) ILIKE 'gpReport_ProductionOrder'
                                   OR TRIM (inStoredProc) ILIKE 'Report_OrderExternal_MIChild_Detail'
                                   --
                                   OR TRIM (inStoredProc) ILIKE 'gpReport_GoodsMI_Internal'
                                   --OR TRIM (inStoredProc) ILIKE 'gpSelect_Report_Wage'
                                   --
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractChoice'
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractChoice_byPromo'
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractPartnerChoice'
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractPartnerOrderChoice'
                                   --
                                   OR (TRIM (inStoredProc) ILIKE 'gpSelect_Scale_Goods' AND zfConvert_StringToNumber (inValue3) = 0 AND zfConvert_StringToNumber (inValue4) = 0)
                                   OR TRIM (inStoredProc)  ILIKE 'gpSelect_Scale_Partner'
                                   --
                                   --OR (TRIM (inStoredProc) ILIKE 'gpReport_GoodsMI_SaleReturnIn' AND zfConvert_StringToDate (inValue2) < CURRENT_DATE)
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
        
              -- �������� ���� �������
              vbEndDate  := CASE -- ��� ������
                                 WHEN -- ��� JuridicalDeferment...
                                      (inParam1 ILIKE '%inOperDate%' AND inParam2 ILIKE '%inEmptyParam%')
                                      -- ���������
                                   OR TRIM (inStoredProc) ILIKE 'gpReport_ProductionOrder'
                                   OR TRIM (inStoredProc) ILIKE 'gpReport_OrderExternal_MIChild_Detail'
                                   --
                                   OR TRIM (inStoredProc) ILIKE 'gpReport_GoodsMI_Internal'
                                   --
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractChoice'
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractChoice_byPromo'
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractPartnerChoice'
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Object_ContractPartnerOrderChoice'
                                   --
                                   OR (TRIM (inStoredProc) ILIKE 'gpSelect_Scale_Goods' AND zfConvert_StringToNumber (inValue3) = 0 AND zfConvert_StringToNumber (inValue4) = 0)
                                   --
                                   OR TRIM (inStoredProc) ILIKE 'gpSelect_Scale_Partner'
                                   --
                                   --OR (TRIM (inStoredProc) ILIKE 'gpReport_GoodsMI_SaleReturnIn' AND zfConvert_StringToDate (inValue2) < CURRENT_DATE)
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
        

              -- 2. �������� ���� �������� ��� ����� ����� ��-���� ����, ������ ��� ���� ����
              IF vbStartDate <= (CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                      -- ��������� ���� ����������� ������
                                      THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
         
                                      -- ��������� ���� ��� ������ �����
                                      ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                                 END)
               AND vbEndDate <= (CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                      -- ��������� ���� ����������� ������
                                      THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
         
                                      -- ��������� ���� ��� ������ �����
                                      ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                                 END)
              --
              AND (TRIM (inStoredProc) ILIKE 'gpReport_GoodsBalance'
                OR TRIM (inStoredProc) ILIKE 'gpReport_MotionGoods%'
                  )
              -- ��� ���� �� ����� ����������
              AND TRIM (inStoredProc) NOT ILIKE 'gpReport_MotionGoods_Asset%'
              THEN
-- RAISE EXCEPTION '������. <%> <%>  %  %', vbStartDate, vbEndDate, inValue1, inValue2;
                   -- 2.
                   RETURN TRUE;
                -- RETURN FALSE;
        
              -- 3. 
              ELSEIF vbEndDate <= (CASE WHEN TRIM (inStoredProc) ILIKE 'gpSelect_Movement_Service'
                                          OR TRIM (inStoredProc) ILIKE 'gpSelect_Movement_ProfitLossService'
                                       -- ��������� ���� ����������� ������
                                       THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                       --
                                       ELSE DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
                                   END)
                 AND vbStartDate <= (CASE WHEN TRIM (inStoredProc) ILIKE '%Promo%'
                                          -- ������ ���� ��� ������ �����
                                          THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '3 MONTH'
        
                                          WHEN TRIM (inStoredProc) ILIKE 'gpSelect_Movement_Service'
                                            OR TRIM (inStoredProc) ILIKE 'gpSelect_Movement_ProfitLossService'
                                          -- ������ ���� ��� ������ �����
                                          THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '3 MONTH'
        
                                          WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                          -- ��������� ���� ����������� ������
                                          THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
        
                                          WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 7
                                          -- ������ ���� ����������� ������
                                          THEN DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY')
        
                                          -- ��������� ���� ��� ������ �����
                                          ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                                     END)
                                     --
                 -- ���������
                 AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_Movement_MemberHoliday'
                 AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_Movement_Promo%'
                 AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_Object_Contract'
                 AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_MovementProtocol'
                 AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_MovementItemProtocol'
                 AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_ObjectProtocol'
                 AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_Movement_SheetWorkTimeClose'
                 --
                 AND TRIM (inStoredProc) NOT ILIKE 'gpSelect_Report_Wage%'
                 AND TRIM (inStoredProc) NOT ILIKE 'gpReport_GoodsBalance'
                 AND TRIM (inStoredProc) NOT ILIKE 'gpReport_MotionGoods%'
                 --
                 AND (TRIM (inStoredProc) NOT ILIKE 'gpReport_Transport%'
                   --OR vbUserId IN (5)
                     )
                 -- AND vbUserId <> 440561 -- ��������� �.�.
                 -- AND vbUserId NOT IN (5)
              THEN
                   -- 3.
                   RETURN TRUE;
                   --RETURN FALSE;

              -- 4. 
              ELSE
                   -- 4.
                   RETURN FALSE;
              END IF;
    
          END IF;

      END IF; -- if vbIsReal_only = TRUE



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
-- SELECT * FROM gpGet_StoredProcCheck (inStoredProc := 'gpSelect_Report_Wage', inParam1 := 'inStartDate', inValue1 := '01.08.2023', inParam2 := 'inEndDate', inValue2 := '31.08.2023', inParam3 := 'inIsErased', inValue3 := 'False', inParam4 := 'inJuridicalBasisId', inValue4 := '9399', inParam5 := '', inValue5 := '', inParam6 := '', inValue6 := '', inParam7 := '', inValue7 := '', inParam8 := '', inValue8 := '', inParam9 := '', inValue9 := '', inParam10 := '', inValue10 := '', inSession:= zfCalc_UserAdmin())

-- Function: gpInsertUpdate_Object_CashSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashSettings(TVarChar, TVarChar, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Boolean, Boolean, 
                                                           TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TFloat, Integer, Boolean, 
                                                           Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TFloat, TFloat, Boolean, TFloat, Integer, 
                                                           Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer, Integer, TFloat, TFloat, Boolean, 
                                                           TFloat, TFloat, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, 
                                                           Boolean, TVarChar, Boolean, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TFloat, 
                                                           Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashSettings(
    IN inShareFromPriceName         TVarChar  ,     -- �������� ���� � ��������� ������� ������� ����� ������ � ����� �����
    IN inShareFromPriceCode         TVarChar  ,     -- �������� ����� ������� ������� ����� ������ � ����� �����
    IN inisGetHardwareData          Boolean   ,     -- �������� ������ ���������� �����
    IN inDateBanSUN                 TDateTime ,     -- ������ ������ �� ���
    IN inSummaFormSendVIP           TFloat    ,     -- ����� �� ������� ������� ����� ��� ������������ ����������� VIP
    IN inSummaUrgentlySendVIP       TFloat    ,     -- ����� ����������� �� ������� �������� ������� ������
    IN inDaySaleForSUN              Integer   ,     -- ���������� ���� ��� �������� <�������/������� �� ���� ���>
    IN inDayNonCommoditySUN         Integer   ,     -- ���������� ���� ��� �������� ����������� "���������� ���"
    IN inisBlockVIP                 Boolean   ,     -- ����������� ������������ ����������� VIP
    IN inisPairedOnlyPromo          Boolean   ,     -- ��� ��������� ������ �������������� ������ ���������
    IN inAttemptsSub                TFloat    ,     -- ���������� ������� �� �������� ����� ����� ��� ����������� ������
    IN inUpperLimitPromoBonus       TFloat    ,     -- ������� ������ ��������� (������ ������)
    IN inLowerLimitPromoBonus       TFloat    ,     -- ������ ������ ��������� (������ ������)
    IN inMinPercentPromoBonus       TFloat    ,     -- ����������� ������� (������ ������)
    IN inDayCompensDiscount         Integer   ,     -- ���� �� ����������� �� ���������� ��������
    IN inMethodsAssortmentGuidesId  Integer   ,     -- ������ ������ ����� ������������
    IN inAssortmentGeograph         Integer   ,     -- ����� ���������� �� ���������
    IN inAssortmentSales            Integer   ,     -- ����� ���������� �� ��������
    IN inCustomerThreshold          TFloat    ,     -- ����� ������������ ��� ������ ��� �������
    IN inPriceCorrectionDay         Integer   ,     -- ������ ���� ��� ������� ��������� ���� �� ������ �����/������� ������� ������
    IN inisRequireUkrName           Boolean   ,     -- ��������� ���������� ����������� ��������
    IN inisRemovingPrograms	        Boolean   ,     -- �������� ��������� ��������
    IN inPriceSamples               TFloat    ,     -- ����� ���� ������� ��
    IN inSamples21                  TFloat    ,     -- ������ ������� ��� 2.1 (�� 90-200 ����)
    IN inSamples22                  TFloat    ,     -- ������ ������� ��� 2.2 (�� 50-90 ����)
    IN inSamples3                   TFloat    ,     -- ������ ������� ��� 3 (�� 0 �� 50 ����)
    IN inTelegramBotToken           TVarChar  ,     -- ����� �������� ����
    IN inPercentIC                  TFloat    ,     -- ������� �� ������� ��������� ��������� ��� �/� �����������
    IN inPercentUntilNextSUN        TFloat    ,     -- ������� ��� ��������� ������� "�������/������� �� ���� ���"
    IN inisEliminateColdSUN         Boolean   ,     -- ��������� ����� �� ���
    IN inTurnoverMoreSUN2           TFloat    ,     -- ������ ������ �� ������� ����� ��� ������������� ��� 2
    IN inDeySupplOutSUN2            Integer   ,     -- ������� ���� ��� ����� ������ ���������� ��� 2
    IN inDeySupplInSUN2             Integer   ,     -- ������� ���� ��� ����� ���� ���������� ��� 2
    IN inExpressVIPConfirm          Integer   ,     -- ����� ��� �������� ������������� ���
    IN inPriceFormSendVIP           TFloat    ,     -- ���� �� ������� ������� ����� ��� ������������ ����������� VIP
    IN inMinPriceSale               TFloat    ,     -- ����������� ���� ������ ��� �������
    IN inDeviationsPrice1303        TFloat    ,     -- ������� ���������� �� ��������� ���� ��� ������� �� 1303
    IN inisWagesCheckTesting        Boolean   ,     -- �������� ����� ������� ��� ������ ��������
    IN inNormNewMobileOrders        Integer   ,     -- ����� �� ����� ������� ���������� ����������
    IN inUserUpdateMarketingId      Integer   ,     -- ��������� ��� �������������� � �� ����� ����������
    IN inLimitCash                  TFloat    ,     -- ����������� ��� ������� ���������
    IN inAddMarkupTabletki          TFloat    ,     -- ��� ������� �� �������� �� ��� �� ������������ ��������
    IN inisShoresSUN                Boolean   ,     -- ������ �������� �� ���
    IN inFixedPercent               TFloat    ,     -- ������������� ������� ���������� �����
    IN inMobMessSum                 TFloat    ,     -- ��������� �� �������� ������ �� ���������� �� ����� ����
    IN inMobMessCount               Integer   ,     -- 	��������� �� �������� ������ �� ���������� ����� ����

    IN inisEliminateColdSUN2        Boolean   ,     -- ��������� ����� �� ��� 2
    IN inisEliminateColdSUN3        Boolean   ,     -- ��������� ����� �� �-���
    IN inisEliminateColdSUN4        Boolean   ,     -- ��������� ����� �� ��� ��
    IN inisEliminateColdSUA         Boolean   ,     -- ��������� ����� �� ��A

    IN inisOnlyColdSUN              Boolean   ,     -- ������ �� ������ ��� 1
    IN inisOnlyColdSUN2             Boolean   ,     -- ������ �� ������ ��� 3
    IN inisOnlyColdSUN3             Boolean   ,     -- ������ �� ������ �-���
    IN inisOnlyColdSUN4             Boolean   ,     -- ������ �� ������ ��� ��
    IN inisOnlyColdSUA              Boolean   ,     -- ������ �� ������ ��A
    IN inSendCashErrorTelId         TVarChar  ,     -- ID � �������� ��� �������� ������ �� ������
    IN inisCancelBansSUN            Boolean   ,     -- ������ �������� �� ���� ���
    
    IN inAntiTOPMP_Count            Integer   ,     -- ���� ��� ���. ����. ���������� ����������� ��� �����������
    IN inAntiTOPMP_CountFine        Integer   ,     -- ���� ��� ���. ����. ���������� ����������� ��� ���������� ������
    IN inAntiTOPMP_CountAward       Integer   ,     -- ���� ��� ���. ����. ���������� ����������� ��� ���������� ������
    IN inAntiTOPMP_SumFine          TFloat    ,     -- ���� ��� ���. ����. ����� ������
    IN inAntiTOPMP_MinProcAward     TFloat    ,     -- ���� ��� ���. ����. ����������� ������� ���������� ����� ��� ������
    IN inCat_5                      TFloat    ,     -- ������ ��� 5 �� ����
    
    IN inUnitDeferredId             Integer   ,     -- ������ ������ ������� � ������������ �� ������
    IN inCourseReport               TFloat    ,     -- ���� ��� "����� ������� �� ������������� ��� ����������"
    
    IN inisLegalEntitiesSUN         Boolean   ,     -- ����������� �� ��. �����
    IN inSmashSumSend               TFloat    ,     -- �������� ����������� �� �����

    IN inSession                    TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbID Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Driver());
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;

   -- �������� ����� ���
   vbID := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CashSettings());

   -- ��������� <������>
   vbID := lpInsertUpdate_Object (vbID, zc_Object_CashSettings(), 1, '����� ��������� ����');
   
   -- ��������� �������� ���� � ��������� ������� ������� ����� ������ � ����� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_ShareFromPriceName(), vbID, inShareFromPriceName);
   
   -- ��������� �������� ����� ������� ������� ����� ������ � ����� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_ShareFromPriceCode(), vbID, inShareFromPriceCode);

   -- ��������� �������� ������ ���������� �����
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_GetHardwareData(), vbID, inisGetHardwareData);
   -- ��������� ������ ������ �� ���
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashSettings_DateBanSUN(), vbID, inDateBanSUN);

   -- ��������� ����� �� ������� ������� ����� ��� ������������ ����������� VIP
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_SummaFormSendVIP(), vbID, inSummaFormSendVIP);
      -- ��������� ����� ����������� �� ������� �������� ������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP(), vbID, inSummaUrgentlySendVIP);
      -- ��������� ���������� ���� ��� �������� <�������/������� �� ���� ���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DaySaleForSUN(), vbID, inDaySaleForSUN);
      -- ��������� ���������� ���� ��� �������� ����������� "���������� ���"
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DayNonCommoditySUN(), vbID, inDayNonCommoditySUN);
      -- ��������� ���������� ������� �� �������� ����� ����� ��� ����������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AttemptsSub(), vbID, inAttemptsSub);
      -- ��������� ������� ������ ��������� (������ ������)
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_UpperLimitPromoBonus(), vbID, inUpperLimitPromoBonus);
      -- ��������� ������ ������ ��������� (������ ������)
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_LowerLimitPromoBonus(), vbID, inLowerLimitPromoBonus);
      -- ��������� ����������� ������� (������ ������)
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_MinPercentPromoBonus(), vbID, inMinPercentPromoBonus);
      -- ��������� ���� �� ����������� �� ���������� ��������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DayCompensDiscount(), vbID, inDayCompensDiscount);
      -- ��������� ����� ������������ ��� ������ ��� �������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_CustomerThreshold(), vbID, inCustomerThreshold);
      -- ��������� ������ ���� ��� ������� ��������� ���� �� ������ �����/������� ������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_PriceCorrectionDay(), vbID, inPriceCorrectionDay);

      -- ��������� ����� ���������� �� ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AssortmentGeograph(), vbID, inAssortmentGeograph);
      -- ��������� ���� �� ����������� �� ���������� ��������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AssortmentSales(), vbID, inAssortmentSales);

   -- ��������� ����������� ������������ ����������� VIP
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_BlockVIP(), vbID, inisBlockVIP);
   -- ��������� ����� ���������� �� ��������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_PairedOnlyPromo(), vbID, inisPairedOnlyPromo);

   -- ��������� ��������� ���������� ����������� ��������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_RequireUkrName(), vbID, inisRequireUkrName);
   -- ��������� �������� ��������� ��������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_RemovingPrograms(), vbID, inisRemovingPrograms);

   -- ��������� ��������� ����� �� ��� 1
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUN(), vbID, inisEliminateColdSUN);
   -- ��������� ��������� ����� �� ��� 2
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUN2(), vbID, inisEliminateColdSUN2);
   -- ��������� ��������� ����� �� ��� 3
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUN3(), vbID, inisEliminateColdSUN3);
   -- ��������� ��������� ����� �� ��� 4
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUN4(), vbID, inisEliminateColdSUN4);
   -- ��������� ��������� ����� �� ��A
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUA(), vbID, inisEliminateColdSUA);
   -- ����������� �� ��. �����
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_LegalEntitiesSUN(), vbID, inisLegalEntitiesSUN);

   -- ��������� ����� ���� ������� ��
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CashSettings_PriceSamples(), vbID, inPriceSamples);
   -- ��������� ������ ������� ��� 2.1 (�� 90-200 ����)
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CashSettings_Samples21(), vbID, inSamples21);
   -- ��������� ������ ������� ��� 2.2 (�� 50-90 ����)
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CashSettings_Samples22(), vbID, inSamples22);
   -- ��������� ������ ������� ��� 3 (�� 0 �� 50 ����)
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CashSettings_Samples3(), vbID, inSamples3);

      -- ��������� ���� �� ����������� �� ���������� ��������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AssortmentSales(), vbID, inAssortmentSales);

   -- ��������� ����� �������� ����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_TelegramBotToken(), vbID, inTelegramBotToken);
   -- ID � �������� ��� �������� ������ �� ������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_SendCashErrorTelId(), vbID, inSendCashErrorTelId);

      -- ��������� ������� �� ������� ��������� ��������� ��� �/� �����������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_PercentIC(), vbID, inPercentIC);

      -- ��������� ������� ��� ��������� ������� "�������/������� �� ���� ���"
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_PercentUntilNextSUN(), vbID, inPercentUntilNextSUN);

      -- ��������� 	������ ������ �� ������� ����� ��� ������������� ��� 2
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_TurnoverMoreSUN2(), vbID, inTurnoverMoreSUN2);

      -- ��������� 	������� ���� ��� ����� ������ ���������� ��� 2
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DeySupplOutSUN2(), vbID, inDeySupplOutSUN2);
      -- ��������� 	������� ���� ��� ����� ���� ���������� ��� 2
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DeySupplInSUN2(), vbID, inDeySupplInSUN2);
   
      -- ��������� ����� ��� �������� ������������� ���
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_ExpressVIPConfirm(), vbID, inExpressVIPConfirm);

      -- ��������� ���� �� ������� ������� ����� ��� ������������ ����������� VIP
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_PriceFormSendVIP(), vbID, inPriceFormSendVIP);
   
     -- ����������� ���� ������ ��� �������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_MinPriceSale(), vbID, inMinPriceSale);
   
     -- ������� ���������� �� ��������� ���� ��� ������� �� 1303
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DeviationsPrice1303(), vbID, inDeviationsPrice1303);
   
     -- ����� �� ����� ������� ���������� ����������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_NormNewMobileOrders(), vbID, inNormNewMobileOrders);

     -- ����������� ��� ������� ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_LimitCash(), vbID, inLimitCash);
   
    -- ��� ������� �� �������� �� ��� �� ������������ ��������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AddMarkupTabletki(), vbID, inAddMarkupTabletki);
   
    -- ������������� ������� ���������� �����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_FixedPercent(), vbID, inFixedPercent);
   
    -- ��������� �� �������� ������ �� ���������� �� ����� ����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_MobMessSum(), vbID, inMobMessSum);
    -- 	��������� �� �������� ������ �� ���������� ����� ����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_MobMessCount(), vbID, inMobMessCount);
   

   -- �������� ����� ������� ��� ������ ��������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_WagesCheckTesting(), vbID, inisWagesCheckTesting);

   -- ������ ������ ����� ������������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CashSettings_MethodsAssortment(), vbID, inMethodsAssortmentGuidesId);

   -- ��������� ��� �������������� � �� ����� ����������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CashSettings_UserUpdateMarketing(), vbID, inUserUpdateMarketingId);
   
   -- ������ �������� �� ���
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_ShoresSUN(), vbID, inisShoresSUN);

   -- ������ �� ������ ���
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUN(), vbID, inisOnlyColdSUN);
   -- ������ �� ������ ���2
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUN2(), vbID, inisOnlyColdSUN2);
   -- ������ �� ������ ���3
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUN3(), vbID, inisOnlyColdSUN3);
   -- ������ �� ������ ���4
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUN4(), vbID, inisOnlyColdSUN4);
   -- ������ �� ������ ��A
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUA(), vbID, inisOnlyColdSUA);
   -- ������ �������� �� ���� ���
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_CancelBansSUN(), vbID, inisCancelBansSUN);

    -- ���� ��� ���. ����. ���������� ����������� ��� �����������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AntiTOPMP_Count(), vbID, inAntiTOPMP_Count);
    -- ���� ��� ���. ����. ���������� ����������� ��� ���������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine(), vbID, inAntiTOPMP_CountFine);
    -- ���� ��� ���. ����. ���������� ����������� ��� ���������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AntiTOPMP_CountAward(), vbID, inAntiTOPMP_CountAward);
    -- ���� ��� ���. ����. ����� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine(), vbID, inAntiTOPMP_SumFine);
    -- ���� ��� ���. ����. ����������� ������� ���������� ����� ��� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AntiTOPMP_MinProcAward(), vbID, inAntiTOPMP_MinProcAward);

    -- ������ ��� 5 �� ����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_Cat_5(), vbID, inCat_5);
   
   
   -- ������ ������ ������� � ������������ �� ������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CashSettings_UnitDeferred(), vbID, inUnitDeferredId);
   
    -- ���� ��� "����� ������� �� ������������� ��� ����������"
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_CourseReport(), vbID, inCourseReport);

    -- �������� ����������� �� �����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_SmashSumSend(), vbID, inSmashSumSend);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbID, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.11.19                                                       *
*/
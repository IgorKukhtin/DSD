-- Function: gpInsertUpdate_ObjectHistory_CashSettings ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_CashSettings (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_CashSettings(
 INOUT ioId                  Integer,    -- ���� ������� <������� ������� ����� ��������� ����>
    IN inCashSettingsId      Integer,    -- ����� ��������� ����
    IN inStartDate           TDateTime,  -- ���� �������� ������
    IN inFixedPercent        TFloat,     -- ������������� ������� ���������� �����	
    IN inFixedPercentB       TFloat,     -- ������������� ������� ���������� ����� ��������� B	
    IN inFixedPercentC       TFloat,     -- ������������� ������� ���������� ����� ��������� C	
    IN inFixedPercentD       TFloat,     -- ������������� ������� ���������� ����� ��������� D	
    IN inPenMobApp           TFloat,     -- ����� ������ �� 1% ������������ ����� �� ���������� ����������
    IN inPrizeThreshold      TFloat,     -- ������������� ������ �� ������ ��� ���������� ����� ����������
    IN inMarkPlanThreshol    TFloat,     -- ������ �� ������ ����� �� ������� ������
    IN inPercPlanMobileApp   TFloat,     -- ������� �� ����� ��� ����� �� ���������� ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- ��������
   IF COALESCE (inCashSettingsId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� ������� <����� ��������� ����>.';
   END IF;


   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_CashSettings(), inCashSettingsId, inStartDate, vbUserId);
   
   -- ������������� ������� ���������� �����	
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_FixedPercent(), ioId, inFixedPercent);
   -- ������������� ������� ���������� ����� ��������� B	
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_FixedPercentB(), ioId, inFixedPercentB);
   -- ������������� ������� ���������� ����� ��������� C	
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_FixedPercentC(), ioId, inFixedPercentC);
   -- ������������� ������� ���������� ����� ��������� D	
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_FixedPercentD(), ioId, inFixedPercentD);
   
   -- ����� ������ �� 1% ������������ ����� �� ���������� ����������
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_PenMobApp(), ioId, inPenMobApp);

   -- ������������� ������ �� ������ ��� ���������� ����� ����������
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_PrizeThreshold(), ioId, inPrizeThreshold);

   -- ������ �� ������ ����� �� ������� ������
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_MarkPlanThreshol(), ioId, inMarkPlanThreshol);

   -- ������ �� ������ ����� �� ������� ������
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_PercPlanMobileApp(), ioId, inPercPlanMobileApp);
        
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.23                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ObjectHistory_CashSettings()
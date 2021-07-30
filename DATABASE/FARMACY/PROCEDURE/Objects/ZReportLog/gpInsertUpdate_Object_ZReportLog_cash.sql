-- Function: gpInsertUpdate_Object_ZReportLog_cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ZReportLog_cash (Integer, TVarChar, TDateTime, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ZReportLog_cash(
    IN inZReport                   Integer,   -- ����� Z ������
    IN inFiscalNumber              TVarChar,  -- ���������� �����
    IN inDate                      TDateTime, -- ���� Z ������
    IN inSummaCash                 TFloat,    -- ������ ��������
    IN inSummaCard	               TFloat,    -- ������ �����
    IN inUserId                    Integer,   -- ���������
    IN inSession                   TVarChar   -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ZReportLog());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
    
   IF COALESCE (vbUnitId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� �������������.';
   END IF;
    
      
   -- �������� ����� ���
   IF EXISTS(SELECT ZReportLog.Id FROM Object AS ZReportLog
             WHERE ZReportLog.DescId = zc_Object_ZReportLog()
               AND ZReportLog.ObjectCode = inZReport
               AND ZReportLog.ValueData = TRIM(inFiscalNumber))
   THEN
     SELECT ZReportLog.Id 
     INTO vbId
     FROM Object AS ZReportLog
     WHERE ZReportLog.DescId = zc_Object_ZReportLog()
       AND ZReportLog.ObjectCode = inZReport
       AND ZReportLog.ValueData = TRIM(inFiscalNumber);    
   ELSE
     vbId := 0;
   END IF;

   -- ��������� <������>
   vbId := lpInsertUpdate_Object (vbId, zc_Object_ZReportLog(), inZReport, TRIM(inFiscalNumber));

   -- ���� Z ������
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ZReportLog_Date(), vbId, inDate);

   -- ������ ��������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ZReportLog_SummaCash(), vbId, inSummaCash);

   -- ������ �����
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ZReportLog_SummaCard(), vbId, inSummaCard);
 
   -- ������ �� �������������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ZReportLog_Unit(), vbId, vbUnitId);
   
   -- ������ �� ����������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ZReportLog_User(), vbId, inUserId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.07.21                                                       *
*/

-- ����
-- 

select * from gpInsertUpdate_Object_ZReportLog_cash(inZReport := 32390569 , inFiscalNumber := '3000007988' , inDate := ('30.07.2021 13:31:15')::TDateTime , 
              inSummaCash := 49343 , inSummaCard := 20567 , inUserId := 3 ,  inSession := '3');
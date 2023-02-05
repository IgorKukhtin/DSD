-- Function: gpInsertUpdate_ObjectHistory_CashSettings ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_CashSettings (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_CashSettings(
 INOUT ioId              Integer,    -- ���� ������� <������� ������� ����� ��������� ����>
    IN inCashSettingsId  Integer,    -- ����� ��������� ����
    IN inStartDate       TDateTime,  -- ���� �������� ������
    IN inFixedPercent    TFloat,     -- ������������� ������� ���������� �����	
    IN inSession         TVarChar    -- ������ ������������
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

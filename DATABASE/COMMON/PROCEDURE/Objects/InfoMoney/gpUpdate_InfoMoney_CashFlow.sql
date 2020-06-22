-- Function: gpUpdate_InfoMoney_CashFlow()

DROP FUNCTION IF EXISTS gpUpdate_InfoMoney_CashFlow(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_InfoMoney_CashFlow(
    IN inId                  Integer   ,    -- ���� �������
    IN inCashFlowId          Integer   ,    -- 
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_InfoMoney_CashFlow());
   
   -- ��������� ����� � <������ ������ ���>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow(), inId, inCashFlowId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.06.20         *
*/
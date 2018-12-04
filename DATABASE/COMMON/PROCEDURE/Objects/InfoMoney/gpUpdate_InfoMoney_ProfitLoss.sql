-- Function: gpUpdate_InfoMoney_ProfitLoss()

DROP FUNCTION IF EXISTS gpUpdate_InfoMoney_ProfitLoss(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_InfoMoney_ProfitLoss(
    IN inId                  Integer   ,    -- ���� �������
    IN inisProfitLoss        Boolean   ,    -- 
   OUT outisProfitLoss       Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_InfoMoney_ProfitLoss());
   
   -- ���������� �������
   outisProfitLoss:= NOT inisProfitLoss;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_ProfitLoss(), inId, outisProfitLoss);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.12.18         *
*/
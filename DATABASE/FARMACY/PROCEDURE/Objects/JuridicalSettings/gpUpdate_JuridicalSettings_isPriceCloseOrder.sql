-- Function: 
DROP FUNCTION IF EXISTS gpUpdate_JuridicalSettings_isPriceCloseOrder(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_JuridicalSettings_isPriceCloseOrder(
    IN inId                     Integer   ,    -- ���� ������� <�������������>
    IN inisPriceCloseOrder      Boolean   ,    -- ������ ������ ��� ��������������
   --OUT outisPriceCloseOrder     Boolean   ,
    IN inSession                TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   --outisPriceCloseOrder:= NOT inisPriceCloseOrder;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder(), inId, inisPriceCloseOrder);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.10.18         *
*/
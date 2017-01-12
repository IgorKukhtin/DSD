-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Contract_isReport(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_isReport(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisReport              Boolean   ,    -- ��������� � ���������������
   OUT outisReport             Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisReport:= NOT inisReport;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Report(), inId, outisReport);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 11.01.17         *

*/
--select * from gpUpdate_Contract_isReport(inId := 1393106 , inisReport := 'False' ,  inSession := '3');
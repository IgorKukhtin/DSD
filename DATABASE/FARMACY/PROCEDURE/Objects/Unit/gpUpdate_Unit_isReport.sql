-- Function: gpUpdate_Unit_isReport()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isReport(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isReport(
    IN inId                      Integer   ,    -- ���� ������� <�������������>
    IN inisReport        Boolean   ,    -- 
   OUT outisReport       Boolean   ,
    IN inSession                 TVarChar       -- ������� ������������
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

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_Report(), inId, outisReport);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 09.08.17         *

*/
--select * from gpUpdate_Unit_isReport(inId := 1393106 , inisReport := 'False' ,  inSession := '3');
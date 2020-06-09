-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_MonthSupplSun1 (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_MonthSupplSun1(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inMonthSupplSun1        Integer   ,    -- ��� ������ � ���������� ���1
    IN inSession             TVarChar       -- ������� ������������
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
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_MonthSupplSun1(), inId, inMonthSupplSun1);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.20                                                       *
*/
--gpUpdate_Unit_MonthSupplSun1()
-- Function: gpUpdate_Unit_isMarginCategory()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isMarginCategory(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isMarginCategory(
    IN inId                      Integer   ,    -- ���� ������� <�������������>
    IN inisMarginCategory        Boolean   ,    -- 
   OUT outisMarginCategory       Boolean   ,
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
   outisMarginCategory:= NOT inisMarginCategory;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_MarginCategory(), inId, outisMarginCategory);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 31.01.17         *

*/
--select * from gpUpdate_Unit_isMarginCategory(inId := 1393106 , inisMarginCategory := 'False' ,  inSession := '3');
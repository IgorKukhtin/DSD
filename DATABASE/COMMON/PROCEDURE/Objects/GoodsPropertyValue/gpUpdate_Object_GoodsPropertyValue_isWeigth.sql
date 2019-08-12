-- Function: gpUpdate_Object_GoodsPropertyValue_isWeigth()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_isWeigth(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsPropertyValue_isWeigth(
    IN inId             Integer,    -- ���� ������� <�������� ������� ������� ��� ��������������>
    IN inisWeigth       Boolean,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbisWeigth  Boolean;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());

   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ��������.';
   END IF;
  
   vbisWeigth := NOT inisWeigth;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsPropertyValue_Weigth(), inId, vbisWeigth);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.19         *
*/

-- ����
-- 
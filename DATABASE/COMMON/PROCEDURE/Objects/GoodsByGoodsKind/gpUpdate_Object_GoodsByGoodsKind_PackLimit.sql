-- Function: gpUpdate_Object_GoodsByGoodsKind_PackLimit (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_PackLimit (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_PackLimit(
    IN inId                      Integer  , -- ���� ������� <>
    IN inPackLimit               TFloat   , -- 
    IN inisPackLimit             Boolean  ,
    IN inSession                 TVarChar 
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_GoodsByGoodsKind_PackLimit());

   -- �������� - ��� � ����� ������ �� �����
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� ����������� �� ����������.';
   END IF;
  
   -- ��������� �������� <>
   IF inisPackLimit = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_PackLimit(), inId, inPackLimit);
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_PackLimit(), inId, inisPackLimit);

   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5 OR vbUserId = 9457
   THEN
       RAISE EXCEPTION '������.��� ���� - ��� � ����� ������ �� �����.';
   END IF;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.02.24         *
*/

-- ����
--
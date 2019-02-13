-- Function: gpInsertUpdate_Object_GoodsCategory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, TFloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsCategory(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������>
    IN inGoodsId                 Integer   ,    -- ������ �� ������� ��.����
    IN inUnitCategoryId          Integer   ,    -- ������ ��  ��.����
    IN inValue                   TFloat    ,    --  
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsCategory());
   vbUserId:= inSession;

     -- ��������
   IF EXISTS (SELECT 1
              FROM ObjectLink AS ObjectLink_GoodsCategory_UnitCategory
                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                        ON ObjectLink_GoodsCategory_Goods.ObjectId = ObjectLink_GoodsCategory_UnitCategory.ObjectId
                                       AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                       AND ObjectLink_GoodsCategory_Goods.ChildObjectId = inGoodsId
              WHERE ObjectLink_GoodsCategory_UnitCategory.DescId = zc_ObjectLink_GoodsCategory_Category()
                AND ObjectLink_GoodsCategory_UnitCategory.ChildObjectId = inUnitCategoryId
                AND ObjectLink_GoodsCategory_UnitCategory.ObjectId <> ioId
              )
   THEN
      RAISE EXCEPTION '������.����� ��������� <%> - ����� <%> ��� ����������', lfGet_Object_ValueData (inUnitCategoryId), lfGet_Object_ValueData (inGoodsId);
   END IF; 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsCategory(), 0, '');

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsCategory_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsCategory_Category(), ioId, inUnitCategoryId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsCategory_Value(), ioId, inValue);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.19         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsCategory ()                            

--select * from gpInsertUpdate_Object_GoodsCategory(ioId := 10091548 , inGoodsId := 342 , inGoodsCategoryId := 7779481 , inValue := 2 ,  inSession := '3');
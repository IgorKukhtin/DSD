-- Function: gpInsertUpdate_Object_GoodsCategory()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, Integer, TFloat, tvarchar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsCategory(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������>
    IN inGoodsId                 Integer   ,    -- ������ �� ������� ��.����
    IN inUnitCategoryId          Integer   ,    -- ������ �� ��������� �������.
    IN inUnitId                  Integer   ,    -- ������ �� �������������
    IN inValue                   TFloat    ,    --  
    IN inUserId                  Integer        -- ������ ������������
)
  RETURNS Integer AS
$BODY$
BEGIN

 /*  -- ��������
   IF EXISTS (SELECT 1
              FROM ObjectLink AS ObjectLink_GoodsCategory_Unit
                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                        ON ObjectLink_GoodsCategory_Goods.ObjectId = ObjectLink_GoodsCategory_Unit.ObjectId
                                       AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                       AND ObjectLink_GoodsCategory_Goods.ChildObjectId = inGoodsId

                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_UnitCategory
                                         ON ObjectLink_GoodsCategory_UnitCategory.ObjectId = ObjectLink_GoodsCategory_Unit.ObjectId
                                        AND ObjectLink_GoodsCategory_UnitCategory.DescId = zc_ObjectLink_GoodsCategory_Category()
                                        AND COALESCE (ObjectLink_GoodsCategory_UnitCategory.ChildObjectId, 0) = inUnitCategoryId

              WHERE ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                AND ObjectLink_GoodsCategory_Unit.ChildObjectId = inUnitId
                AND ObjectLink_GoodsCategory_Unit.ObjectId <> ioId
              )
   THEN
      RAISE EXCEPTION '������.����� <%> - <%> - <%>  ��� ����������', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (inUnitCategoryId);
   END IF; 
*/
   
   ioId := (SELECT ObjectLink_GoodsCategory_Goods.ObjectId AS Id
            FROM ObjectLink AS ObjectLink_GoodsCategory_Unit
                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                       ON ObjectLink_GoodsCategory_Goods.ObjectId = ObjectLink_GoodsCategory_Unit.ObjectId
                                      AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                      AND ObjectLink_GoodsCategory_Goods.ChildObjectId = inGoodsId

                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_UnitCategory
                                       ON ObjectLink_GoodsCategory_UnitCategory.ObjectId = ObjectLink_GoodsCategory_Unit.ObjectId
                                      AND ObjectLink_GoodsCategory_UnitCategory.DescId = zc_ObjectLink_GoodsCategory_Category()
                                      AND COALESCE (ObjectLink_GoodsCategory_UnitCategory.ChildObjectId, 0) = inUnitCategoryId

            WHERE ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
              AND ObjectLink_GoodsCategory_Unit.ChildObjectId = inUnitId
            Limit 1 -- �� ������ ������
              --AND ObjectLink_GoodsCategory_Unit.ObjectId <> ioId
              );
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsCategory(), 0, '');

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsCategory_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsCategory_Category(), ioId, inUnitCategoryId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsCategory_Unit(), ioId, inUnitId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsCategory_Value(), ioId, inValue);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.19         *

*/

-- ����
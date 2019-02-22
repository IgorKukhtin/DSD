-- Function: gpInsertUpdate_Object_GoodsCategory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, TFloat, tvarchar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, Integer, TFloat, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, Integer, TFloat, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsCategory(
    IN inId                      Integer   ,   	-- ���� ������� <�������>
    IN inGoodsId                 Integer   ,    -- ������ �� ������� ��.����
    IN inUnitCategoryId          Integer   ,    -- ������ �� ��������� �������.
    IN inUnitId                  Integer   ,    -- ������ �� �������������
    IN inValue                   TFloat    ,    --  
    In inisUnitList              Boolean   ,    -- �� ������
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS VOID
  AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsCategory());
   vbUserId:= inSession;

   -- ��������
   IF COALESCE (inUnitId, 0) = 0 OR COALESCE (inGoodsId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.��������� <�����> � <�������������> ����������� � ����������';
   END IF;

   PERFORM lpInsertUpdate_Object_GoodsCategory (ioId             := 0
                                              , inGoodsId        := inGoodsId
                                              , inUnitCategoryId := inUnitCategoryId
                                              , inUnitId         := tmpUnit.UnitId
                                              , inValue          := inValue
                                              , inUserId         := vbUserId
                                              )
   FROM (SELECT inUnitId AS UnitId
         WHERE COALESCE (inUnitId, 0) <> 0 
           AND inisUnitList = FALSE
        UNION
         SELECT ObjectBoolean_GoodsCategory.ObjectId AS UnitId
         FROM ObjectBoolean AS ObjectBoolean_GoodsCategory
         WHERE ObjectBoolean_GoodsCategory.DescId = zc_ObjectBoolean_Unit_GoodsCategory()
           AND ObjectBoolean_GoodsCategory.ValueData = TRUE
           AND inisUnitList = TRUE
      ) AS tmpUnit;
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.02.19         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsCategory ()                            

--select * from gpInsertUpdate_Object_GoodsCategory(ioId := 10091548 , inGoodsId := 342 , inGoodsCategoryId := 7779481 , inValue := 2 ,  inSession := '3');
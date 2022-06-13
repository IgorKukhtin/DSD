-- Function: gpSelect_Object_GoodsCategoryAddGoodsChosen()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsCategoryAddGoodsChosen (Boolean, Integer, Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsCategoryAddGoodsChosen(
    IN inisSelect                Boolean   ,    -- ���������
    IN inGoodsId                 Integer   ,    -- �����
    IN inUnitId                  Integer   ,    -- �������������
    IN inAmount                  Integer   ,    -- ����������
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
   
   IF COALESCE (inisSelect, FALSE) = False
   THEN
     RETURN;
   END IF;
   
   IF COALESCE (inGoodsId, 0) = 0 OR COALESCE (inGoodsId, 0) = 0
   THEN
     RAISE EXCEPTION '������. �� ������ ����� ��� �������������.';
   END IF;
   
   
   PERFORM gpInsertUpdate_Object_GoodsCategoryCopy(inId              := 0
                                                 , inGoodsId         := inGoodsId
                                                 , inUnitCategoryId  := 0
                                                 , inUnitId          := inUnitId
                                                 , inValue           := inAmount
                                                 , inisErased        := False 
                                                 , inSession         := '3');

/*    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%> <%>', inSession, inisSelect, lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inUnitId), inAmount;
    END IF;*/
       
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.06.22                                                       *

*/

-- ����
-- select * from gpSelect_Object_GoodsCategoryAddGoodsChosen(inisSelect := 'True' , inGoodsId := 375 , inUnitId := 377606 , inAmount := 1 ,  inSession := '3');


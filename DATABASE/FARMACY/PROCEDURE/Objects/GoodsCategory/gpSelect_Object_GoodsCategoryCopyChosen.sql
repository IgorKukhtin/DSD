-- Function: gpSelect_Object_GoodsCategoryCopyChosen()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsCategoryCopyChosen (Boolean, Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsCategoryCopyChosen(
    IN inisSelect                Boolean   ,    -- ���������
    IN inUnitFromId              Integer   ,    -- ������ �� �������������
    IN inUnitToId                Integer   ,    -- ������ �� �������������
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
   
   IF NOT EXISTS(SELECT * 
                 FROM gpSelect_Object_GoodsCategory(inUnitCategoryId := 0 , inUnitId := inUnitFromId , inisUnitList := 'False' , inShowAll := 'False' , inisErased := 'True' ,  inSession := inSession))
   THEN
     RAISE EXCEPTION '������. �� ������������� <%> �� ������� �������������� �������.', lfGet_Object_ValueData (inUnitFromId);
   END IF;
   
   PERFORM gpSelect_Object_GoodsCategoryCopy(inUnitFromId := inUnitFromId
                                           , inUnitToId   := inUnitToId
                                           , inSession    := inSession);

    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%>', inSession, inisSelect, lfGet_Object_ValueData (inUnitFromId), lfGet_Object_ValueData (inUnitToId);
    END IF;
       
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.06.22                                                       *

*/

-- ����
-- select * from gpSelect_Object_GoodsCategoryCopyChosen(inisSelect := 'True' , inUnitFromId := 0 , inUnitToId := 9951517 ,  inSession := '3');

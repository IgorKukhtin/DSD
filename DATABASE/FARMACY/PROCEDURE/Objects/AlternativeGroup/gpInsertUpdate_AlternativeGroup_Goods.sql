DROP FUNCTION IF EXISTS gpInsertUpdate_AlternativeGroup_Goods (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_AlternativeGroup_Goods(
    IN inAlternativeGroupId       Integer   ,    -- ������ �����������
    IN inGoodsId                  Integer   ,    -- �����
    IN inInGroup                  Boolean   ,    -- True - �������� � ������/ false - ������� �� ������
   OUT outAlternativeGroupId      Integer   ,    -- ������ �����������
    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
   --DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AlternativeGroup());
  -- vbUserId := inSession;
  IF inInGroup = True THEN
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_AlternativeGroup(), inGoodsId, inAlternativeGroupId);
  ELSE
    Delete from objectlink
    Where
      DescId = zc_ObjectLink_Goods_AlternativeGroup()
      AND 
      ObjectId = inGoodsId
      AND
      childobjectid = inAlternativeGroupId;
  END IF;  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_AlternativeGroup_Goods (Integer, Integer, BOOLEAN, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �. �.
 28.06.15                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_AlternativeGroup_Goods(0,0,False,'3')


DROP FUNCTION IF EXISTS gpInsertUpdate_AlternativeGroup_Goods (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_AlternativeGroup_Goods (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_AlternativeGroup_Goods(
    IN inAlternativeGroupId       Integer   ,    -- ������ �����������
    IN inGoodsId                  Integer   ,    -- �����
    IN inOldGoodsId                Integer   ,    -- �����, ������� ��������
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
  IF COALESCE(inOldGoodsId,0) <> 0 THEN
    Delete from objectlink
      Where
        DescId = zc_ObjectLink_Goods_AlternativeGroup()
        AND 
        ObjectId = inOldGoodsId
        AND
        childobjectid = inAlternativeGroupId;
  END IF;
  IF COALESCE(inGoodsId,0) <> 0 THEN  
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_AlternativeGroup(), inGoodsId, inAlternativeGroupId);
  END IF;
  outAlternativeGroupId := inAlternativeGroupId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_AlternativeGroup_Goods (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �. �.
 28.06.15                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_AlternativeGroup_Goods(0,0,False,'3')


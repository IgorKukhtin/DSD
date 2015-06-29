DROP FUNCTION IF EXISTS gpDelete_AlternativeGroup_Goods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_AlternativeGroup_Goods(
    IN inAlternativeGroupId       Integer   ,    -- ������ �����������
    IN inGoodsId                  Integer   ,    -- �����
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   --DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AlternativeGroup());
  -- vbUserId := inSession;
  IF COALESCE(inGoodsId,0) <> 0 THEN
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
ALTER FUNCTION gpDelete_AlternativeGroup_Goods (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �. �.
 29.06.15                                                          *
*/

-- ����
-- SELECT * FROM gpDelete_AlternativeGroup_Goods(0,0,'3')


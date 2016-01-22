-- Function: lfGet_Object_GoodsGroup_GoodsTagId (Integer)
-- ������� ��������� �� ������ ������ � ������

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_GoodsTagId (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_GoodsTagId (
 inObjectId               Integer    -- ��������� ��-�� ������
 
)
  RETURNS Integer
AS
$BODY$
DECLARE
  vbGoodsTagId TVarChar;
BEGIN
     vbGoodsTagId:= (SELECT CASE WHEN COALESCE (ObjectLink_GoodsGroup_GoodsTag.ChildObjectId,0) <> 0
                              THEN ObjectLink_GoodsGroup_GoodsTag.ChildObjectId
                            ELSE lfGet_Object_GoodsGroup_GoodsTagId (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
                   FROM Object
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsTag
                                ON ObjectLink_GoodsGroup_GoodsTag.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup_GoodsTag.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                   WHERE Object.Id = inObjectId);


     --
     RETURN (vbGoodsTagId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.16                                        *
*/

-- ����
-- SELECT * FROM lfGet_Object_GoodsGroup_GoodsTagId (137023)

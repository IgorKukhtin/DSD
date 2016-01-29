-- Function: lfGet_Object_GoodsGroup_GoodsGroupAnalystId (Integer)
-- ������� ��������� �� ������ ������ � ������

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_GoodsGroupAnalystId (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_GoodsGroupAnalystId (
 inObjectId               Integer    -- ��������� ��-�� ������
 
)
  RETURNS Integer
AS
$BODY$
DECLARE
  vbGoodsGroupAnalystId TVarChar;
BEGIN
     vbGoodsGroupAnalystId:= (SELECT CASE WHEN COALESCE (ObjectLink_GoodsGroup_GoodsGroupAnalyst.ChildObjectId,0) <> 0
                              THEN ObjectLink_GoodsGroup_GoodsGroupAnalyst.ChildObjectId
                            ELSE lfGet_Object_GoodsGroup_GoodsGroupAnalystId (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
                   FROM Object
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsGroupAnalyst
                                ON ObjectLink_GoodsGroup_GoodsGroupAnalyst.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup_GoodsGroupAnalyst.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                   WHERE Object.Id = inObjectId);


     --
     RETURN (vbGoodsGroupAnalystId);

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
-- SELECT * FROM lfGet_Object_GoodsGroup_GoodsGroupAnalystId (137023)

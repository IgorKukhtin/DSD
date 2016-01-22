-- Function: lfGet_Object_GoodsGroup_InfomoneyId (Integer)
-- ������� ��������� �� ������ ������ � ������

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_InfomoneyId (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_InfomoneyId (
 inObjectId               Integer    -- ��������� ��-�� ������
 
)
  RETURNS Integer
AS
$BODY$
DECLARE
  vbInfomoneyId TVarChar;
BEGIN
     vbInfomoneyId:= (SELECT CASE WHEN COALESCE (ObjectLink_GoodsGroup_InfoMoney.ChildObjectId,0) <> 0
                              THEN ObjectLink_GoodsGroup_InfoMoney.ChildObjectId
                            ELSE lfGet_Object_GoodsGroup_InfomoneyId (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
                   FROM Object
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                   WHERE Object.Id = inObjectId);


     --
     RETURN (vbInfomoneyId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.15         *                            
*/

-- ����
-- SELECT * FROM lfGet_Object_GoodsGroup_InfomoneyId (137023)

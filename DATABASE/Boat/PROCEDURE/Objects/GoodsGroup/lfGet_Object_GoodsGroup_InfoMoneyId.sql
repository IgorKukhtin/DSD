-- Function: lfGet_Object_GoodsGroup_InfoMoneyId (Integer)
-- ������� ��������� �� ������ ������ � ������

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_InfoMoneyId (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_InfoMoneyId (
 inObjectId       Integer    -- ��������� ��-�� ������
 
)
  RETURNS Integer
AS
$BODY$
DECLARE
  vbInfoMoneyId TVarChar;
BEGIN
     vbInfoMoneyId:= (SELECT CASE WHEN ObjectLink_GoodsGroup_InfoMoney.ChildObjectId <> 0
                                  -- ���� ���� �������� � ���� ������
                                  THEN ObjectLink_GoodsGroup_InfoMoney.ChildObjectId
                                  -- ���������� ���� � ������ ����
                                  ELSE lfGet_Object_GoodsGroup_InfoMoneyId (ObjectLink_GoodsGroup.ChildObjectId) 
                             END
                      FROM Object
                         LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
                         LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE Object.Id = inObjectId
                     );

     --
     RETURN (vbInfoMoneyId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.06.17         *
*/

-- ����
-- SELECT * FROM lfGet_Object_GoodsGroup_InfoMoneyId (0)

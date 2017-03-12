-- Function: lfGet_Object_GoodsGroup_DKPP (Integer)
-- ������� ��������� �� ������ ��� ��� ��� � ������

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_DKPP (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_DKPP (
 inObjectId               Integer    -- ��������� ��-�� ������
)
  RETURNS TVarChar
AS
$BODY$
DECLARE
  vbDKPP TVarChar;
BEGIN
     vbDKPP:= (SELECT CASE WHEN ObjectString_GoodsGroup_DKPP.ValueData <> ''
                              THEN ObjectString_GoodsGroup_DKPP.ValueData
                            ELSE lfGet_Object_GoodsGroup_DKPP (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
               FROM Object
                    LEFT JOIN ObjectString AS ObjectString_GoodsGroup_DKPP
                                           ON ObjectString_GoodsGroup_DKPP.ObjectId = Object.Id 
                                          AND ObjectString_GoodsGroup_DKPP.DescId = zc_ObjectString_GoodsGroup_DKPP()
                    LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
               WHERE Object.Id = inObjectId);


     --
     RETURN (vbDKPP);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.03.17         *                              *
*/

-- ����
-- SELECT * FROM lfGet_Object_GoodsGroup_DKPP (137023)

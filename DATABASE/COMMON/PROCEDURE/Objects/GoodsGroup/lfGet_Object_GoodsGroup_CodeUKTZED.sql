-- Function: lfGet_Object_GoodsGroup_CodeUKTZED (Integer)
-- ������� ��������� �� ������ ��� ��� ��� � ������

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_CodeUKTZED (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_CodeUKTZED (
 inObjectId               Integer    -- ��������� ��-�� ������
 
)
  RETURNS TVarChar
AS
$BODY$
DECLARE
  vbCodeUKTZED TVarChar;
BEGIN
     vbCodeUKTZED:= (SELECT CASE WHEN ObjectString_GoodsGroup_UKTZED.ValueData <> ''
                              THEN ObjectString_GoodsGroup_UKTZED.ValueData
                            ELSE lfGet_Object_GoodsGroup_CodeUKTZED (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
                   FROM Object
                      LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED
                                             ON ObjectString_GoodsGroup_UKTZED.ObjectId = Object.Id 
                                            AND ObjectString_GoodsGroup_UKTZED.DescId = zc_ObjectString_GoodsGroup_UKTZED()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                           ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                          AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                   WHERE Object.Id = inObjectId);


     --
     RETURN (vbCodeUKTZED);

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
-- SELECT * FROM lfGet_Object_GoodsGroup_CodeUKTZED (137023)

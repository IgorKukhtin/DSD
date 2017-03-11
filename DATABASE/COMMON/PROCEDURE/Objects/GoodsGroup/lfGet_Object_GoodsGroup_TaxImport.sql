-- Function: lfGet_Object_GoodsGroup_TaxImport (Integer)
-- ������� ��������� �� ������ ��� ��� ��� � ������

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_TaxImport (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_TaxImport (
 inObjectId               Integer    -- ��������� ��-�� ������
 
)
  RETURNS TVarChar
AS
$BODY$
DECLARE
  vbTaxImport TVarChar;
BEGIN
     vbTaxImport:= (SELECT CASE WHEN ObjectString_GoodsGroup_TaxImport.ValueData <> ''
                              THEN ObjectString_GoodsGroup_TaxImport.ValueData
                            ELSE lfGet_Object_GoodsGroup_TaxImport (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
                    FROM Object
                      LEFT JOIN ObjectString AS ObjectString_GoodsGroup_TaxImport
                                             ON ObjectString_GoodsGroup_TaxImport.ObjectId = Object.Id 
                                            AND ObjectString_GoodsGroup_TaxImport.DescId = zc_ObjectString_GoodsGroup_TaxImport()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                    WHERE Object.Id = inObjectId);


     --
     RETURN (vbTaxImport);

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
-- SELECT * FROM lfGet_Object_GoodsGroup_TaxImport (137023)

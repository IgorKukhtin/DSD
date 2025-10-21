-- View: _bi_Guide_Object_View

 DROP VIEW IF EXISTS _bi_Guide_Object_View;

-- ���������� ���
/*
-- ��������
Id
Code
Name
-- ��� �����������
ItemName
-- ������� "������ ��/���"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_Object_View
AS
      SELECT Object.Id                AS Id
           , Object.ObjectCode        AS Code
           , Object.ValueData         AS Name
           , ObjectDesc.ItemName      AS ItemName
             -- ������� "������ ��/���"
           , Object.isErased

       FROM Object
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
      ;

ALTER TABLE _bi_Guide_Object_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_Object_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_Object_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.10.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Object_View ORDER BY 1 LIMIT 100

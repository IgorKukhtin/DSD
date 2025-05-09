-- View: _bi_Guide_Branch_View

 DROP VIEW IF EXISTS _bi_Guide_Branch_View;

-- ���������� �������
CREATE OR REPLACE VIEW _bi_Guide_Branch_View
AS
       SELECT
             Object_Branch.Id         AS Id
           , Object_Branch.ObjectCode AS Code
           , Object_Branch.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Branch.isErased   AS isErased

       FROM Object AS Object_Branch
       WHERE Object_Branch.DescId = zc_Object_Branch()
      ;

ALTER TABLE _bi_Guide_Branch_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Branch_View

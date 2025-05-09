-- View: _bi_Guide_PaidKind_View

 DROP VIEW IF EXISTS _bi_Guide_PaidKind_View;

-- ���������� ����� ������
CREATE OR REPLACE VIEW _bi_Guide_PaidKind_View
AS
       SELECT
             Object_PaidKind.Id         AS Id
           , Object_PaidKind.ObjectCode AS Code
           , Object_PaidKind.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_PaidKind.isErased   AS isErased

       FROM Object AS Object_PaidKind
       WHERE Object_PaidKind.DescId = zc_Object_PaidKind()
      ;

ALTER TABLE _bi_Guide_PaidKind_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_PaidKind_View

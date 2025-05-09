-- View: _bi_Guide_Personal_View

 DROP VIEW IF EXISTS _bi_Guide_Personal_View;

-- ���������� ����������
CREATE OR REPLACE VIEW _bi_Guide_Personal_View
AS
       SELECT
             Object_Personal.Id         AS Id
           , Object_Personal.ObjectCode AS Code
           , Object_Personal.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Personal.isErased   AS isErased

       FROM Object AS Object_Personal
       WHERE Object_Personal.DescId = zc_Object_Personal()
      ;

ALTER TABLE _bi_Guide_Personal_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Personal_View

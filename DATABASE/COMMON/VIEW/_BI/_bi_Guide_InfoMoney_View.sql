-- View: _bi_Guide_InfoMoney_View

 DROP VIEW IF EXISTS _bi_Guide_InfoMoney_View;

-- ���������� �������� ����
CREATE OR REPLACE VIEW _bi_Guide_InfoMoney_View
AS
       SELECT
             Object_InfoMoney.Id         AS Id
           , Object_InfoMoney.ObjectCode AS Code
           , Object_InfoMoney.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_InfoMoney.isErased   AS isErased

       FROM Object AS Object_InfoMoney
       WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney()
      ;

ALTER TABLE _bi_Guide_InfoMoney_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_InfoMoney_View

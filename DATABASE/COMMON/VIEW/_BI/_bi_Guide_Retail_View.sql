-- View: _bi_Guide_Retail_View

 DROP VIEW IF EXISTS _bi_Guide_Retail_View;

-- ���������� �������� ����
CREATE OR REPLACE VIEW _bi_Guide_Retail_View
AS
       SELECT
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Retail.isErased   AS isErased

       FROM Object AS Object_Retail
       WHERE Object_Retail.DescId = zc_Object_Retail()
      ;

ALTER TABLE _bi_Guide_Retail_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Retail_View

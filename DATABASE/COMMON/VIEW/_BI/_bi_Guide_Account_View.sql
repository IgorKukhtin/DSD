-- View: _bi_Guide_Account_View

 DROP VIEW IF EXISTS _bi_Guide_Account_View;

-- ���������� �����
CREATE OR REPLACE VIEW _bi_Guide_Account_View
AS
       SELECT
             Object_Account.Id         AS Id
           , Object_Account.ObjectCode AS Code
           , Object_Account.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Account.isErased   AS isErased

       FROM Object AS Object_Account
       WHERE Object_Account.DescId = zc_Object_Account()
      ;

ALTER TABLE _bi_Guide_Account_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Account_View

-- View: _bi_Guide_GoodsKind_View

DROP VIEW IF EXISTS _bi_Guide_GoodsKind_View;

-- ���������� ���� �������
/*
--Id �������� ���� �������
Id
-- ������� "������ ��/���"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_GoodsKind_View
AS
       SELECT
             Object_GoodsKind.Id         AS Id
           , Object_GoodsKind.ObjectCode AS Code
           , Object_GoodsKind.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_GoodsKind.isErased   AS isErased

       FROM Object AS Object_GoodsKind
       WHERE Object_GoodsKind.DescId = zc_Object_GoodsKind()
      ;

ALTER TABLE _bi_Guide_GoodsKind_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.25         *
*/

-- ����
-- SELECT * FROM _bi_Guide_GoodsKind_View

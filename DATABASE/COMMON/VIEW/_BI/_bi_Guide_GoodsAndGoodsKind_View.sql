-- View: _bi_Guide_GoodsAndGoodsKind_View

DROP VIEW IF EXISTS _bi_Guide_GoodsAndGoodsKind_View;

-- ���������� ����� + ��� ������
/*
--Id �������� �����
GoodsId
GoodsCode
GoodsName

--Id �������� ��� ������
GoodsKindId
GoodsKindCode
GoodsKindName

-- ��-�� "���� �������� � ����"
NormInDays

-- ��-�� "��� ��/���"
isTop

-- ������� "������ ��/���"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_GoodsAndGoodsKind_View
AS
       SELECT
           --Object_GoodsByGoodsKind.Id         AS Id
             -- �����
             Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
            -- ��� ������
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ObjectCode        AS GoodsKindCode
           , Object_GoodsKind.ValueData         AS GoodsKindName

             -- ��-�� "���� �������� � ����"
           , COALESCE (ObjectFloat_NormInDays.ValueData, 0) :: TFloat AS NormInDays

             -- ��-�� "��� ��/���"
           , COALESCE (ObjectBoolean_Top.ValueData, FALSE) :: Boolean AS isTop

             -- ������� "������ ��/���"
           , Object_GoodsByGoodsKind.isErased   AS isErased

       FROM Object AS Object_GoodsByGoodsKind
            -- �����
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                 ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                AND ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
            -- ��� ������
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = Object_GoodsByGoodsKind.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId

            -- ��-�� "���� �������� � ����"
            LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                  ON ObjectFloat_NormInDays.ObjectId = Object_GoodsByGoodsKind.Id
                                 AND ObjectFloat_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
            -- ��-�� "��� ��/���"
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                    ON ObjectBoolean_Top.ObjectId = Object_GoodsByGoodsKind.Id
                                   AND ObjectBoolean_Top.DescId   = zc_ObjectBoolean_GoodsByGoodsKind_Top()

       WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
       AND (ObjectFloat_NormInDays.ValueData > 0
         OR ObjectBoolean_Top.ValueData      = TRUE
           )
      ;

ALTER TABLE _bi_Guide_GoodsAndGoodsKind_View  OWNER TO postgres;
ALTER TABLE _bi_Guide_GoodsAndGoodsKind_View  OWNER TO project;
ALTER TABLE _bi_Guide_GoodsAndGoodsKind_View  OWNER TO admin;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_GoodsAndGoodsKind_View

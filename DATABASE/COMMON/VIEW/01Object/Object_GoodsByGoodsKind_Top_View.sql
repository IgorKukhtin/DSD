-- View: Object_GoodsByGoodsKind_Top_View

DROP VIEW IF EXISTS Object_GoodsByGoodsKind_Top_View;

CREATE OR REPLACE VIEW Object_GoodsByGoodsKind_Top_View AS
       SELECT
             Object_GoodsByGoodsKind_View.Id
           , CASE WHEN COALESCE (ObjectBoolean_Top.ValueData, False) = False THEN '���' ELSE '��' END ::TVarChar AS ValueData
       FROM Object_GoodsByGoodsKind_View
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                    ON ObjectBoolean_Top.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Top();

ALTER TABLE Object_GoodsByGoodsKind_Top_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.06.21         *
*/

-- ����
-- SELECT * FROM Object_GoodsByGoodsKind_Top_View

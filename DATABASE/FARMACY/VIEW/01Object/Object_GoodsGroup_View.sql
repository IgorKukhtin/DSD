-- View: Object_GoodsGroup_View

-- DROP VIEW IF EXISTS Object_GoodsGroup_View;

CREATE OR REPLACE VIEW Object_GoodsGroup_View AS
         SELECT 
             Object_GoodsGroup.Id           AS GoodsGroupId
           , Object_GoodsGroup.ObjectCode   AS GoodsGroupCode
           , Object_GoodsGroup.ValueData    AS GoodsGroupName

       FROM Object AS Object_GoodsGroup
       WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup();


ALTER TABLE Object_GoodsGroup_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.04.16                                        *
*/

-- ����
-- SELECT * FROM Object_GoodsGroup_View

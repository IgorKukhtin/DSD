-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_PaidType_View;

CREATE OR REPLACE VIEW Object_PaidType_View AS
  SELECT
    Id               AS Id
    ,ObjectCode      AS PaidTypeCode
    ,ValueData       AS PaidTypeName
  FROM Object AS Object_PaidType
  WHERE Object_PaidType.DescId = zc_Object_PaidType();

ALTER TABLE Object_PaidType_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 06.07.15                                                          *
*/

-- ����
-- SELECT * FROM Object_PaidType_View

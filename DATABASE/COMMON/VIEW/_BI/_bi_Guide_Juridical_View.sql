-- View: _bi_Guide_Juridical_View

DROP VIEW IF EXISTS _bi_Guide_Juridical_View;

-- ���������� ����������� ����
CREATE OR REPLACE VIEW _bi_Guide_Juridical_View
AS
     SELECT
            Object_Juridical.Id                AS Id
          , Object_Juridical.ObjectCode        AS Code
          , Object_Juridical.ValueData         AS Name
            -- ������� "������ ��/���"
          , Object_Juridical.isErased          AS isErased

            -- ������
          , Object_JuridicalGroup.Id           AS JuridicalGroupId
          , Object_JuridicalGroup.ObjectCode   AS JuridicalGroupCode
          , Object_JuridicalGroup.ValueData    AS JuridicalGroupName

            -- �������������� ������� �������
          , Object_GoodsProperty.Id            AS GoodsPropertyId
          , Object_GoodsProperty.ObjectCode    AS GoodsPropertyCode
          , Object_GoodsProperty.ValueData     AS GoodsPropertyName

            -- �������� ����
          , Object_Retail.Id                   AS RetailId
          , Object_Retail.ObjectCode           AS RetailCode
          , Object_Retail.ValueData            AS RetailName

            -- �������� ����(�����)
          , Object_RetailReport.Id             AS RetailId_report
          , Object_RetailReport.ObjectCode     AS RetailCode_report
          , Object_RetailReport.ValueData      AS RetailName_report

            -- ��� c���� � ������� ����/���� ��������)
          , COALESCE (ObjectBoolean_isNotRealGoods.ValueData, FALSE) :: Boolean AS isNotRealGoods

            -- ������� ������� ����������� ���� (���� �� ������������� ��� ��.����)
          , COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)    :: Boolean AS isCorporate

     FROM Object AS Object_Juridical
          -- ������
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup
                               ON ObjectLink_JuridicalGroup.ObjectId = Object_Juridical.Id
                              AND ObjectLink_JuridicalGroup.DescId   = zc_ObjectLink_Juridical_JuridicalGroup()
          LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_JuridicalGroup.ChildObjectId

          -- �������������� ������� �������
          LEFT JOIN ObjectLink AS ObjectLink_GoodsProperty
                               ON ObjectLink_GoodsProperty.ObjectId = Object_Juridical.Id
                              AND ObjectLink_GoodsProperty.DescId   = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_GoodsProperty.ChildObjectId

          -- �������� ����
          LEFT JOIN ObjectLink AS ObjectLink_Retail
                               ON ObjectLink_Retail.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Retail.ChildObjectId

          -- �������� ���� (�����)
          LEFT JOIN ObjectLink AS ObjectLink_RetailReport
                               ON ObjectLink_RetailReport.ObjectId = Object_Juridical.Id
                              AND ObjectLink_RetailReport.DescId   = zc_ObjectLink_Juridical_RetailReport()
          LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = ObjectLink_RetailReport.ChildObjectId

          -- ��� c���� � ������� ����/���� ��������)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotRealGoods
                                  ON ObjectBoolean_isNotRealGoods.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isNotRealGoods.DescId   = zc_ObjectBoolean_Juridical_isNotRealGoods()
          -- ������� ������� ����������� ���� (���� �� ������������� ��� ��.����)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isCorporate.DescId   = zc_ObjectBoolean_Juridical_isCorporate()


     WHERE Object_Juridical.DescId = zc_Object_Juridical()
    ;

ALTER TABLE _bi_Guide_Juridical_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Juridical_View

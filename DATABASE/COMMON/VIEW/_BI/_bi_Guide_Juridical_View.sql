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

            -- �� ������ ����������
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyGroupCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationCode
          , Object_InfoMoney_View.InfoMoneyDestinationName

          --�����-����
          , Object_PriceList.Id         AS PriceListId
          , Object_PriceList.ValueData  AS PriceListName
          --����� ��� ��������� �� "������ �����" - ���� �� "1���"
          , Object_PriceList_Prior.Id         AS PriceListId_Prior
          , Object_PriceList_Prior.ValueData  AS PriceListName_Prior
          --����� ������ � ����������� ����
          , Object_PriceList_30103.Id         AS PriceListId_30103
          , Object_PriceList_30103.ValueData  AS PriceListName_30103
          --����� ������ � ����������� �����
          , Object_PriceList_30201.Id         AS PriceListId_30201
          , Object_PriceList_30201.ValueData  AS PriceListName_30201
          --�������
          , Object_Section.Id                 AS SectionId
          , Object_Section.ObjectCode         AS SectionCode
          , Object_Section.ValueData          AS SectionName

            -- ��� c���� � ������� ����/���� ��������)
          , COALESCE (ObjectBoolean_isNotRealGoods.ValueData, FALSE) :: Boolean AS isNotRealGoods
            -- ������� ������� ����������� ���� (���� �� ������������� ��� ��.����)
          , COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)    :: Boolean AS isCorporate
          --��� GLN - ���������� �/��� ����������
          , ObjectString_GLNCode.ValueData      AS GLNCode
          --���������� ���������� �������������
          , ObjectString_GUID.ValueData AS GUID
          --������� ������� ���������
          , COALESCE (ObjectBoolean_isTaxSummary.ValueData, False)   ::Boolean AS isTaxSummary
          --������ � ��������� ���� �� �������
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, False)::Boolean AS isDiscountPrice
          --������ � ��������� ���� � ��� (��/���)
          , COALESCE (ObjectBoolean_isPriceWithVAT.ValueData, False) ::Boolean AS isPriceWithVAT
          --����� ������� ���� � ��� (���������)
          , COALESCE (ObjectBoolean_isVatPrice.ValueData, FALSE)     ::Boolean AS isVatPrice
          -- � ����� ���� ����� ������� ���� � ��� (���������)
          , COALESCE (ObjectDate_VatPrice.ValueData, NULL)         ::TDateTime AS VatPriceDate
          --��� ������������ ������� ���� �� ����������)
          , COALESCE (ObjectBoolean_isNotTare.ValueData, FALSE)      ::Boolean AS isNotTare
          --10-�� ������� ��� ��� ���
          , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE::Boolean)      AS isLongUKTZED
          --�������� ����������� �����
          , COALESCE (ObjectBoolean_isOrderMin.ValueData, False::Boolean)       AS isOrderMin
          --����
          , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE) :: Boolean   AS isIrna
          --��������� �� ��������� ������ EDI
          , COALESCE (ObjectBoolean_VchasnoEdi.ValueData, FALSE) :: Boolean   AS isVchasnoEdi           
          --� - Comdoc, �������������� ��������
          , COALESCE (ObjectBoolean_isEdiComdoc.ValueData, FALSE) :: Boolean  AS isEdiComdoc
          --�� - Delnot, �������������� ��������
          , COALESCE (ObjectBoolean_isEdiDelnot.ValueData, FALSE) :: Boolean  AS isEdiDelnot

          --���-�� ���� ��� ������� ���������
          , ObjectFloat_DayTaxSummary.ValueData     ::TFloat     AS DayTaxSummary
          --����������� ����� � ������ >= 
          , ObjectFloat_SummOrderMin.ValueData      ::TFloat     AS SummOrderMin
          --��� ����
          , ObjectFloat_ObjectCode_Basis.ValueData  ::Integer    AS BasisCode

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
          --������ ����������
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

            ----����� ����
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                               ON ObjectLink_Juridical_PriceList.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
          LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Juridical_PriceList.ChildObjectId
          --����� ��� ��������� �� "������ �����" - ���� �� "1���"
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList_Prior
                               ON ObjectLink_Juridical_PriceList_Prior.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_PriceList_Prior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
          LEFT JOIN Object AS Object_PriceList_Prior ON Object_PriceList_Prior.Id = ObjectLink_Juridical_PriceList_Prior.ChildObjectId
          --����� ������ � ����������� ����
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList_30103
                               ON ObjectLink_Juridical_PriceList_30103.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_PriceList_30103.DescId = zc_ObjectLink_Juridical_PriceList30103()
          LEFT JOIN Object AS Object_PriceList_30103 ON Object_PriceList_30103.Id = ObjectLink_Juridical_PriceList_30103.ChildObjectId
          --����� ������ � ����������� �����
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList_30201
                               ON ObjectLink_Juridical_PriceList_30201.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_PriceList_30201.DescId = zc_ObjectLink_Juridical_PriceList30201()
          LEFT JOIN Object AS Object_PriceList_30201 ON Object_PriceList_30201.Id = ObjectLink_Juridical_PriceList_30201.ChildObjectId          
          --�������
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Section
                               ON ObjectLink_Juridical_Section.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_Section.DescId = zc_ObjectLink_Juridical_Section()
          LEFT JOIN Object AS Object_Section ON Object_Section.Id = ObjectLink_Juridical_Section.ChildObjectId
          
          -- ��� c���� � ������� ����/���� ��������)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotRealGoods
                                  ON ObjectBoolean_isNotRealGoods.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isNotRealGoods.DescId   = zc_ObjectBoolean_Juridical_isNotRealGoods()
          -- ������� ������� ����������� ���� (���� �� ������������� ��� ��.����)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isCorporate.DescId   = zc_ObjectBoolean_Juridical_isCorporate()

          --��� GLN - ���������� �/��� ����������
          LEFT JOIN ObjectString AS ObjectString_GLNCode
                                 ON ObjectString_GLNCode.ObjectId = Object_Juridical.Id
                                AND ObjectString_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
          --���������� ���������� �������������
          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = Object_Juridical.Id
                                AND ObjectString_GUID.DescId = zc_ObjectString_Juridical_GUID()
          --������� ������� ���������
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isTaxSummary
                                     ON ObjectBoolean_isTaxSummary.ObjectId = Object_Juridical.Id
                                    AND ObjectBoolean_isTaxSummary.DescId = zc_ObjectBoolean_Juridical_isTaxSummary()
          --������ � ��������� ���� �� �������
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()
          --������ � ��������� ���� � ��� (��/���)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceWithVAT
                                  ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT()
          --����� ������� ���� � ��� (���������)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isVatPrice
                                  ON ObjectBoolean_isVatPrice.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isVatPrice.DescId = zc_ObjectBoolean_Juridical_isVatPrice()
          --��� ������������ ������� ���� �� ����������)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotTare
                                  ON ObjectBoolean_isNotTare.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isNotTare.DescId   = zc_ObjectBoolean_Juridical_isNotTare()
          --� ����� ���� ����� ������� ���� � ��� (���������)
          LEFT JOIN ObjectDate AS ObjectDate_VatPrice
                               ON ObjectDate_VatPrice.ObjectId = Object_Juridical.Id
                              AND ObjectDate_VatPrice.DescId = zc_ObjectDate_Juridical_VatPrice()
          --10-�� ������� ��� ��� ���
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isLongUKTZED
                                  ON ObjectBoolean_isLongUKTZED.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()
          --�������� ����������� �����
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isOrderMin
                                  ON ObjectBoolean_isOrderMin.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isOrderMin.DescId = zc_ObjectBoolean_Juridical_isOrderMin()
          --������ � ���� ��������
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isBranchAll
                                  ON ObjectBoolean_isBranchAll.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isBranchAll.DescId   = zc_ObjectBoolean_Juridical_isBranchAll()
          --����
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                  ON ObjectBoolean_Guide_Irna.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
          --��������� �� ��������� ������ EDI
          LEFT JOIN ObjectBoolean AS ObjectBoolean_VchasnoEdi
                                  ON ObjectBoolean_VchasnoEdi.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_VchasnoEdi.DescId = zc_ObjectBoolean_Juridical_VchasnoEdi()
          --�� - Comdoc, �������������� ��������
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isEdiComdoc
                                  ON ObjectBoolean_isEdiComdoc.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isEdiComdoc.DescId = zc_ObjectBoolean_Juridical_isEdiComdoc()
          --�� - Delnot, �������������� ��������
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isEdiDelnot
                                  ON ObjectBoolean_isEdiDelnot.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isEdiDelnot.DescId = zc_ObjectBoolean_Juridical_isEdiDelnot()

          --��� ����
          LEFT JOIN ObjectFloat AS ObjectFloat_ObjectCode_Basis
                                ON ObjectFloat_ObjectCode_Basis.ObjectId = Object_Juridical.Id
                               AND ObjectFloat_ObjectCode_Basis.DescId   = zc_ObjectFloat_ObjectCode_Basis()
          --���-�� ���� ��� ������� ���������
          LEFT JOIN ObjectFloat AS ObjectFloat_DayTaxSummary
                                ON ObjectFloat_DayTaxSummary.ObjectId = Object_Juridical.Id
                               AND ObjectFloat_DayTaxSummary.DescId = zc_ObjectFloat_Juridical_DayTaxSummary()
          --����������� ����� � ������ >= 
          LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderMin
                                ON ObjectFloat_SummOrderMin.ObjectId = Object_Juridical.Id
                               AND ObjectFloat_SummOrderMin.DescId = zc_ObjectFloat_Juridical_SummOrderMin()


     WHERE Object_Juridical.DescId = zc_Object_Juridical()
    ;

ALTER TABLE _bi_Guide_Juridical_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25         *
 08.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Juridical_View

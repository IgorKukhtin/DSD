-- Function: lfGet_Object_Partner_PriceList (Integer, TDateTime)

DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lfGet_Object_Partner_PriceList (IN inPartnerId Integer, IN inOperDate TDateTime)

RETURNS TABLE (PriceListId Integer, PriceListName TVarChar, PriceWithVAT Boolean, VATPercent TFloat)
AS
$BODY$
BEGIN
      RETURN QUERY
      WITH tmpPartner AS (SELECT inPartnerId AS Id)
           -- ����� ������ � ��������� �������: 1) ��������� � ����������� 2) ������� � ����������� 3) ��������� � ��.���� 4) ������� � ��.���� 5) zc_PriceList_Basis
         , tmpPriceList AS (SELECT COALESCE (ObjectLink_Partner_PriceListPromo.ChildObjectId, COALESCE (ObjectLink_Partner_PriceList.ChildObjectId, COALESCE (ObjectLink_Juridical_PriceListPromo.ChildObjectId, COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId, zc_PriceList_Basis())))) AS PriceListId
                            FROM tmpPartner
                                 LEFT JOIN ObjectDate AS ObjectDate_PartnerStartPromo
                                                      ON ObjectDate_PartnerStartPromo.ObjectId = tmpPartner.Id
                                                     AND ObjectDate_PartnerStartPromo.DescId = zc_ObjectDate_Partner_StartPromo()
                                 LEFT JOIN ObjectDate AS ObjectDate_PartnerEndPromo
                                                      ON ObjectDate_PartnerEndPromo.ObjectId = tmpPartner.Id
                                                     AND ObjectDate_PartnerEndPromo.DescId = zc_ObjectDate_Partner_EndPromo()
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo
                                                      ON ObjectLink_Partner_PriceListPromo.ObjectId = tmpPartner.Id
                                                     AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
                                                     AND inOperDate BETWEEN ObjectDate_PartnerStartPromo.ValueData AND ObjectDate_PartnerEndPromo.ValueData
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                                      ON ObjectLink_Partner_PriceList.ObjectId = tmpPartner.Id
                                                     AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                                     AND ObjectLink_Partner_PriceListPromo.ObjectId IS NULL
                                 -- PriceList Juridical
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ObjectId = tmpPartner.Id
                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN ObjectDate AS ObjectDate_JuridicalStartPromo
                                                      ON ObjectDate_JuridicalStartPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                     AND ObjectDate_JuridicalStartPromo.DescId = zc_ObjectDate_Juridical_StartPromo()
                                 LEFT JOIN ObjectDate AS ObjectDate_JuridicalEndPromo
                                                      ON ObjectDate_JuridicalEndPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                     AND ObjectDate_JuridicalEndPromo.DescId = zc_ObjectDate_Juridical_EndPromo()
                                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                                                      ON ObjectLink_Juridical_PriceListPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
                                                     AND (ObjectLink_Partner_PriceListPromo.ChildObjectId IS NULL OR ObjectLink_Partner_PriceList.ChildObjectId IS NULL)-- ����� � �� ���������
                                                     AND inOperDate BETWEEN ObjectDate_JuridicalStartPromo.ValueData AND ObjectDate_JuridicalEndPromo.ValueData
                                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                      ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                                     AND ObjectLink_Juridical_PriceListPromo.ObjectId IS NULL
                           )
      SELECT tmpPriceList.PriceListId
           , Object_PriceList.ValueData           AS PriceListName
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , ObjectFloat_VATPercent.ValueData     AS VATPercent
      FROM tmpPriceList
           LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpPriceList.PriceListId
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                   ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                  AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
           LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                 ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.10.14                                        *
*/

-- ����
-- SELECT * FROM lfGet_Object_Partner_PriceList (inPartnerId:= 79134, inOperDate:= '20.11.2014')

-- View: _bi_Guide_Partner_View

 DROP VIEW IF EXISTS _bi_Guide_Partner_View;

-- ���������� �����������
CREATE OR REPLACE VIEW _bi_Guide_Partner_View
AS
       SELECT
             Object_Partner.Id         AS Id
           , Object_Partner.ObjectCode AS Code
           , Object_Partner.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Partner.isErased   AS isErased

             --�������� �����������
           , ObjectString_ShortName.ValueData   AS ShortName
           --��� GLN - ����� ��������
           , ObjectString_GLNCode.ValueData     AS GLNCode
           --��� GLN - ����������
           , ObjectString_GLNCodeJuridical.ValueData AS GLNCodeJuridical
           --��� GLN - ����������
           , ObjectString_GLNCodeRetail.ValueData    AS GLNCodeRetail
           --����� ����� ��������
           , ObjectString_Address.ValueData     AS Address
           --����� ����
           , ObjectString_HouseNumber.ValueData AS HouseNumber
           --����� �������
           , ObjectString_CaseNumber.ValueData  AS CaseNumber
           --����� ��������
           , ObjectString_RoomNumber.ValueData  AS RoomNumber
           --���������� ���������� �������������
           , ObjectString_GUID.ValueData        AS GUID
           --����������(��� ��������� �������)
           , ObjectString_Movement.ValueData   ::TVarChar AS MovementComment
           --��� ���������
           , ObjectString_Terminal.ValueData   ::TVarChar AS Terminal
           --����� �������
           , ObjectString_BranchCode.ValueData ::TVarChar AS BranchCode
           --�������� ��.���� ��� �������
           , ObjectString_BranchJur.ValueData  ::TVarChar AS BranchJur
           --������ ���������
           , ObjectString_Schedule.ValueData   ::TVarChar AS Schedule
           --������ Delivery
           , ObjectString_Delivery.ValueData   ::TVarChar AS Delivery
           --������� -������� EDIN
           , ObjectString_KATOTTG.ValueData    :: TVarChar AS KATOTTG
           --�� ������� ���� ����������� �����
           , ObjectFloat_PrepareDayCount.ValueData       ::TFloat  AS PrepareDayCount
           --����� ������� ���� ����������� �������������
           , ObjectFloat_DocumentDayCount.ValueData      ::TFloat  AS DocumentDayCount
           --��������� ��
           , ObjectFloat_Category.ValueData              ::TFloat  AS Category
           --��� ����
           , ObjectFloat_ObjectCode_Basis.ValueData      ::Integer AS BasisCode
           --����������� - % �� �������������
           , ObjectFloat_TaxSale_Personal.ValueData      ::TFloat  AS TaxSale_Personal
           --�� - % �� �������������
           , ObjectFloat_TaxSale_PersonalTrade.ValueData ::TFloat  AS TaxSale_PersonalTrade
           --��������-1 - % �� �������������
           , ObjectFloat_TaxSale_MemberSaler1.ValueData  ::TFloat  AS TaxSale_MemberSaler1
           --��������-2 - % �� �������������
           , ObjectFloat_TaxSale_MemberSaler2.ValueData  ::TFloat  AS TaxSale_MemberSaler2
           --GPS ���������� ����� �������� (������)
           , COALESCE (Partner_GPSN.ValueData,0)         ::Tfloat  AS GPSN
           --GPS ���������� ����� �������� (�������)
           , COALESCE (Partner_GPSE.ValueData,0)         ::Tfloat  AS GPSE

           --EDI - �������������
           , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, FALSE)        ::Boolean   AS EdiOrdspr
           --EDI - ����
           , COALESCE (ObjectBoolean_EdiInvoice.ValueData, FALSE)       ::Boolean   AS EdiInvoice
           --EDI - �����������
           , COALESCE (ObjectBoolean_EdiDesadv.ValueData, FALSE)        ::Boolean   AS EdiDesadv
           --����
           , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)       :: Boolean AS isIrna
           --�������� � �����
           , COALESCE (ObjectBoolean_Partner_GoodsBox.ValueData, FALSE) :: Boolean AS isGoodsBox

             -- ����������� ����
           , Object_Juridical.Id               AS JuridicalId
           , Object_Juridical.ObjectCode       AS JuridicalCode
           , Object_Juridical.ValueData        AS JuridicalName
             -- �������
           , Object_Route.Id                   AS RouteId
           , Object_Route.ObjectCode           AS RouteCode
           , Object_Route.ValueData            AS RouteName
             -- ������� ������ �����
           , Object_Route_30201.Id             AS RouteId_30201
           , Object_Route_30201.ObjectCode     AS RouteCode_30201
           , Object_Route_30201.ValueData      AS RouteName_30201

             -- ��� ���� (��������� ����������)  --��� ������ ��� ������ (������������ ���� �� ����������� �������� ��� �.�.)
           , Object_MemberTake.Id              AS MemberTakeId
           , Object_MemberTake.ObjectCode      AS MemberTakeCode
           , Object_MemberTake.ValueData       AS MemberTakeName
             -- ��� ���� (��������-1)
           , Object_MemberSaler1.Id            AS MemberSaler1Id
           , Object_MemberSaler1.ObjectCode    AS MemberSaler1Code
           , Object_MemberSaler1.ValueData     AS MemberSaler1Name
             -- ��� ���� (��������-2)
           , Object_MemberSaler2.Id            AS MemberSaler2Id
           , Object_MemberSaler2.ObjectCode    AS MemberSaler2Code
           , Object_MemberSaler2.ValueData     AS MemberSaler2Name
           -- ��� ��������� (�����������)
           , Object_Personal.PersonalId        AS PersonalId
           , Object_Personal.PersonalCode      AS PersonalCode
           , Object_Personal.PersonalName      AS PersonalName
           , Object_Personal.BranchName        AS BranchName_Personal
           , Object_Personal.UnitName          AS UnitName_Personal
           -- ��� ��������� (��������)
           , Object_PersonalTrade.PersonalId   AS PersonalTradeId
           , Object_PersonalTrade.PersonalCode AS PersonalTradeCode
           , Object_PersonalTrade.PersonalName AS PersonalTradeName
           , Object_PersonalTrade.BranchName   AS BranchName_PersonalTrade
           , Object_PersonalTrade.UnitName     AS UnitName_PersonalTrade
           --��� ��������� (������������)
           , Object_PersonalMerch.Id           AS PersonalMerchId
           , Object_PersonalMerch.ObjectCode   AS PersonalMerchCode
           , Object_PersonalMerch.ValueData    AS PersonalMerchName
           --��� ���������� (���������)
           , Object_PersonalSigning.Id         AS PersonalSigningId
           , Object_PersonalSigning.ObjectCode AS PersonalSigningCode
           , Object_PersonalSigning.ValueData  AS PersonalSigningName
           --������
           , Object_Area.Id                    AS AreaId
           , Object_Area.ObjectCode            AS AreaObjectCode
           , Object_Area.ValueData             AS AreaName
           --������� �������� �����
           , Object_PartnerTag.Id              AS PartnerTagId
           , Object_PartnerTag.ObjectCode      AS PartnerTagCode
           , Object_PartnerTag.ValueData       AS PartnerTagName
           --�����-����
           , Object_PriceList.Id               AS PriceListId
           , Object_PriceList.ObjectCode       AS PriceListCode
           , Object_PriceList.ValueData        AS PriceListName
           --�����-����(���������)
           , Object_PriceListPromo.Id          AS PriceListPromoId
           , Object_PriceListPromo.ObjectCode  AS PriceListPromoCode
           , Object_PriceListPromo.ValueData   AS PriceListPromoName
           --���� ������ �����
           , ObjectDate_StartPromo.ValueData   AS StartPromo
           --���� ��������� �����
           , ObjectDate_EndPromo.ValueData     AS EndPromo
           --����� ��� ��������� �� "������ �����" - ���� �� "1���"
           , Object_PriceList_Prior.Id         AS PriceListId_Prior
           , Object_PriceList_Prior.ObjectCode AS PriceListCode_Prior
           , Object_PriceList_Prior.ValueData  AS PriceListName_Prior
           --����� ������ � ����������� ����
           , Object_PriceList_30103.Id         AS PriceListId_30103
           , Object_PriceList_30103.ObjectCode AS PriceListCode_30103
           , Object_PriceList_30103.ValueData  AS PriceListName_30103
           --����� ������ � ����������� �����
           , Object_PriceList_30201.Id         AS PriceListId_30201
           , Object_PriceList_30201.ObjectCode AS PriceListCode_30201
           , Object_PriceList_30201.ValueData  AS PriceListName_30201
           --�����/��������
           , Object_Street.Id                  AS StreetId
           , Object_Street.ObjectCode          AS StreetCode
           , Object_Street.ValueData           AS StreetName
           --�������������
           , Object_Unit.Id                    AS UnitId
           , Object_Unit.ObjectCode            AS UnitCode
           , Object_Unit.ValueData             AS UnitName
           --�������������(������ ���������)
           , Object_UnitMobile.Id              AS UnitMobileId
           , Object_UnitMobile.ObjectCode      AS UnitMobileCode
           , Object_UnitMobile.ValueData       AS UnitMobileName

       FROM Object AS Object_Partner
         --�� ������� ���� ����������� �����
         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                               ON ObjectFloat_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         --����� ������� ���� ����������� �������������
         LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                               ON ObjectFloat_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
         --��������� ��
         LEFT JOIN ObjectFloat AS ObjectFloat_Category
                               ON ObjectFloat_Category.ObjectId = Object_Partner.Id
                              AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()
         --��� ����
         LEFT JOIN ObjectFloat AS ObjectFloat_ObjectCode_Basis
                               ON ObjectFloat_ObjectCode_Basis.ObjectId = Object_Partner.Id
                              AND ObjectFloat_ObjectCode_Basis.DescId   = zc_ObjectFloat_ObjectCode_Basis()
         --����������� - % �� �������������
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_Personal
                               ON ObjectFloat_TaxSale_Personal.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_Personal.DescId = zc_ObjectFloat_Partner_TaxSale_Personal()
         --�� - % �� �������������
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_PersonalTrade
                               ON ObjectFloat_TaxSale_PersonalTrade.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_PersonalTrade.DescId = zc_ObjectFloat_Partner_TaxSale_PersonalTrade()
         --��������-1 - % �� �������������
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_MemberSaler1
                               ON ObjectFloat_TaxSale_MemberSaler1.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_MemberSaler1.DescId = zc_ObjectFloat_Partner_TaxSale_MemberSaler1()
         --��������-2 - % �� �������������
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_MemberSaler2
                               ON ObjectFloat_TaxSale_MemberSaler2.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_MemberSaler2.DescId = zc_ObjectFloat_Partner_TaxSale_MemberSaler2()
         --GPS ���������� ����� �������� (������)
         LEFT JOIN ObjectFloat AS Partner_GPSN
                               ON Partner_GPSN.ObjectId = Object_Partner.Id
                              AND Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN()
         --GPS ���������� ����� �������� (�������)
         LEFT JOIN ObjectFloat AS Partner_GPSE
                               ON Partner_GPSE.ObjectId = Object_Partner.Id
                              AND Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE()
         --EDI - �������������
         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiOrdspr
                                 ON ObjectBoolean_EdiOrdspr.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
         --EDI - ����
         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiInvoice
                                 ON ObjectBoolean_EdiInvoice.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
         --EDI - �����������
         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiDesadv
                                 ON ObjectBoolean_EdiDesadv.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
         --����
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                 ON ObjectBoolean_Guide_Irna.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
         --�������� � �����
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_GoodsBox
                                 ON ObjectBoolean_Partner_GoodsBox.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_Partner_GoodsBox.DescId = zc_ObjectBoolean_Partner_GoodsBox()


         --�������� �����������
         LEFT JOIN ObjectString AS ObjectString_ShortName
                                ON ObjectString_ShortName.ObjectId = Object_Partner.Id
                               AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()
         --��� GLN - ����� ��������
         LEFT JOIN ObjectString AS ObjectString_GLNCode
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
         --��� GLN - ����������
         LEFT JOIN ObjectString AS ObjectString_GLNCodeJuridical
                                ON ObjectString_GLNCodeJuridical.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
         --��� GLN - ����������
         LEFT JOIN ObjectString AS ObjectString_GLNCodeRetail
                                ON ObjectString_GLNCodeRetail.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
         --����� ����� ��������
         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
         --����� ����
         LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                ON ObjectString_HouseNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()
         --����� �������
         LEFT JOIN ObjectString AS ObjectString_CaseNumber
                                ON ObjectString_CaseNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_CaseNumber.DescId = zc_ObjectString_Partner_CaseNumber()
         --����� ��������
         LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                ON ObjectString_RoomNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()
         --���������� ���������� �������������
         LEFT JOIN ObjectString AS ObjectString_GUID
                                ON ObjectString_GUID.ObjectId = Object_Partner.Id
                               AND ObjectString_GUID.DescId = zc_ObjectString_Juridical_GUID()

         --����������(��� ��������� �������)
         LEFT JOIN ObjectString AS ObjectString_Movement
                                ON ObjectString_Movement.ObjectId = Object_Partner.Id
                               AND ObjectString_Movement.DescId = zc_ObjectString_Partner_Movement()
         --����������� ����
         LEFT JOIN ObjectString AS ObjectString_Terminal
                                ON ObjectString_Terminal.ObjectId = Object_Partner.Id
                               AND ObjectString_Terminal.DescId = zc_ObjectString_Partner_Terminal()
         --����� �������
         LEFT JOIN ObjectString AS ObjectString_BranchCode
                                ON ObjectString_BranchCode.ObjectId = Object_Partner.Id
                               AND ObjectString_BranchCode.DescId = zc_ObjectString_Partner_BranchCode()
         --�������� ��.���� ��� �������
         LEFT JOIN ObjectString AS ObjectString_BranchJur
                                ON ObjectString_BranchJur.ObjectId = Object_Partner.Id
                               AND ObjectString_BranchJur.DescId = zc_ObjectString_Partner_BranchJur()
         ----������� -������� EDIN
         LEFT JOIN ObjectString AS ObjectString_KATOTTG
                                ON ObjectString_KATOTTG.ObjectId = Object_Partner.Id
                               AND ObjectString_KATOTTG.DescId = zc_ObjectString_Partner_KATOTTG()
         --������ ���������
         LEFT JOIN ObjectString AS ObjectString_Schedule
                                ON ObjectString_Schedule.ObjectId = Object_Partner.Id
                               AND ObjectString_Schedule.DescId = zc_ObjectString_Partner_Schedule()
         --������ Delivery
         LEFT JOIN ObjectString AS ObjectString_Delivery
                                ON ObjectString_Delivery.ObjectId = Object_Partner.Id
                               AND ObjectString_Delivery.DescId = zc_ObjectString_Partner_Delivery()

         --���� ������ �����
         LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                              ON ObjectDate_StartPromo.ObjectId = Object_Partner.Id
                             AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Partner_StartPromo()
         --���� ��������� �����
         LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                              ON ObjectDate_EndPromo.ObjectId = Object_Partner.Id
                             AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Partner_EndPromo()
         --����������� ����
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
         --��������
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId
         --�������� 30201
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route_30201
                              ON ObjectLink_Partner_Route_30201.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Route_30201.DescId = zc_ObjectLink_Partner_Route30201()
         LEFT JOIN Object AS Object_Route_30201 ON Object_Route_30201.Id = ObjectLink_Partner_Route_30201.ChildObjectId
         --��� ���� (��������� ����������)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId
         --��� ���� (��������-1)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberSaler1
                              ON ObjectLink_Partner_MemberSaler1.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_MemberSaler1.DescId = zc_ObjectLink_Partner_MemberSaler1()
         LEFT JOIN Object AS Object_MemberSaler1 ON Object_MemberSaler1.Id = ObjectLink_Partner_MemberSaler1.ChildObjectId
         --��� ���� (��������-2)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberSaler2
                              ON ObjectLink_Partner_MemberSaler2.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_MemberSaler2.DescId = zc_ObjectLink_Partner_MemberSaler2()
         LEFT JOIN Object AS Object_MemberSaler2 ON Object_MemberSaler2.Id = ObjectLink_Partner_MemberSaler2.ChildObjectId
         --��� ��������� (�����������)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                              ON ObjectLink_Partner_Personal.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
         LEFT JOIN Object_Personal_View AS Object_Personal ON Object_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId
         --��� ��������� (��������)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId
         --��� ��������� (������������)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalMerch
                              ON ObjectLink_Partner_PersonalMerch.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PersonalMerch.DescId = zc_ObjectLink_Partner_PersonalMerch()
         LEFT JOIN Object AS Object_PersonalMerch ON Object_PersonalMerch.Id = ObjectLink_Partner_PersonalMerch.ChildObjectId
         --��� ���������� (���������)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                              ON ObjectLink_Partner_PersonalSigning.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PersonalSigning.DescId = zc_ObjectLink_Partner_PersonalSigning()
         LEFT JOIN Object AS Object_PersonalSigning ON Object_PersonalSigning.Id = ObjectLink_Partner_PersonalSigning.ChildObjectId
         --������
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
         --������� �������� �����
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                              ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
         LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId
         --�����-����
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                              ON ObjectLink_Partner_PriceList.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
         LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Partner_PriceList.ChildObjectId
         --�����-����(���������)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo
                              ON ObjectLink_Partner_PriceListPromo.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
         LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Partner_PriceListPromo.ChildObjectId
         --����� ��� ��������� �� "������ �����" - ���� �� "1���"
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_Prior
                              ON ObjectLink_Partner_PriceList_Prior.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_Prior.DescId = zc_ObjectLink_Partner_PriceListPrior()
         LEFT JOIN Object AS Object_PriceList_Prior ON Object_PriceList_Prior.Id = ObjectLink_Partner_PriceList_Prior.ChildObjectId
         --����� ������ � ����������� ����
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_30103
                              ON ObjectLink_Partner_PriceList_30103.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_30103.DescId = zc_ObjectLink_Partner_PriceList30103()
         LEFT JOIN Object AS Object_PriceList_30103 ON Object_PriceList_30103.Id = ObjectLink_Partner_PriceList_30103.ChildObjectId
         --����� ������ � ����������� �����
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_30201
                              ON ObjectLink_Partner_PriceList_30201.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_30201.DescId = zc_ObjectLink_Partner_PriceList30201()
         LEFT JOIN Object AS Object_PriceList_30201 ON Object_PriceList_30201.Id = ObjectLink_Partner_PriceList_30201.ChildObjectId
         --�����/��������
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                              ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
         LEFT JOIN Object AS Object_Street ON Object_Street.Id = ObjectLink_Partner_Street.ChildObjectId
         --�������������
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit
                              ON ObjectLink_Partner_Unit.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Partner_Unit.ChildObjectId
         --�������������(������ ���������)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_UnitMobile
                              ON ObjectLink_Partner_UnitMobile.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_UnitMobile.DescId = zc_ObjectLink_Partner_UnitMobile()
         LEFT JOIN Object AS Object_UnitMobile ON Object_UnitMobile.Id = ObjectLink_Partner_UnitMobile.ChildObjectId

       WHERE Object_Partner.DescId = zc_Object_Partner()
      ;

ALTER TABLE _bi_Guide_Partner_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.25         *
*/

-- ����
-- SELECT * FROM _bi_Guide_Partner_View

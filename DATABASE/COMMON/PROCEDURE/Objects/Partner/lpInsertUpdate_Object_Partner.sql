-- Function: lpInsertUpdate_Object_Partner()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                       TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);   
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);  
/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);   */         
/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);*/ 
/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer); 
*/

/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);*/ 
/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat,TFloat, TFloat, TFloat, TFloat,
                                                       Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer,
                                                       TDateTime, TDateTime, Integer);*/
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat,TFloat, TFloat, TFloat, TFloat,
                                                       Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer,
                                                       TDateTime, TDateTime, Integer);
/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat,TFloat, TFloat, TFloat, TFloat,
                                                       Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer,
                                                       TDateTime, TDateTime, Integer); */
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat,TFloat, TFloat, TFloat, TFloat,
                                                       Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer,
                                                       TDateTime, TDateTime, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Partner(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
    IN inCode                Integer   ,    -- ��� ������� <����������> 
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    
    IN inGLNCodeJuridical    TVarChar  ,    -- ��� GLN - ����������
    IN inGLNCodeRetail       TVarChar  ,    -- ��� GLN - ����������
    IN inGLNCodeCorporate    TVarChar  ,    -- ��� GLN - ���������
    IN inSchedule            TVarChar  ,    -- ������ ���������

    IN inBranchCode          TVarChar  ,    -- ����� �������
    IN inBranchJur           TVarChar  ,    -- �������� ��.���� ��� �������
    IN inTerminal            TVarChar  ,    -- ��� ���������

    IN inPrepareDayCount     TFloat    ,    -- �� ������� ���� ����������� �����
    IN inDocumentDayCount    TFloat    ,    -- ����� ������� ���� ����������� �������������
    IN inCategory            TFloat    ,    -- ��������� ��
    IN inTaxSale_Personal       TFloat    ,   -- ����������� - % �� �������������
    IN inTaxSale_PersonalTrade  TFloat    ,   -- �� - % �� �������������
    IN inTaxSale_MemberSaler1   TFloat    ,   -- ��������-1 - % �� �������������
    IN inTaxSale_MemberSaler2   TFloat    ,   -- ��������-2 - % �� �������������

    IN inEdiOrdspr           Boolean   ,    -- EDI - �������������
    IN inEdiInvoice          Boolean   ,    -- EDI - ����
    IN inEdiDesadv           Boolean   ,    -- EDI - �����������

    IN inJuridicalId         Integer   ,    -- ����������� ����
    IN inRouteId             Integer   ,    -- �������
    IN inRouteId_30201       Integer   ,    -- ������� ������ ����� 
    IN inRouteSortingId      Integer   ,    -- ���������� ���������
    
    IN inMemberTakeId        Integer   ,    -- ��� ���� (��������� ����������)
    IN inMemberSaler1Id      Integer   ,    -- ��� ����(��������-1)
    IN inMemberSaler2Id      Integer   ,    -- ��� ����(��������-2)

    IN inPersonalId          Integer   ,    -- ��������� (�����������)
    IN inPersonalTradeId     Integer   ,    -- ��������� (��������)
    IN inPersonalMerchId     Integer   ,    -- ��������� (������������)
    IN inPersonalSigningId   Integer   ,    -- ��������� (���������)
    IN inAreaId              Integer   ,    -- ������
    IN inPartnerTagId        Integer   ,    -- ������� �������� �����

    IN inGoodsPropertyId     Integer   ,    -- �������������� ������� �������
    
    IN inUnitMobileId        Integer   ,    -- �������������(������ ���������)

    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListId_30201   Integer   ,    -- �����-���� ������ �����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����     
    
    IN inUserId              Integer        -- ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

   -- �������� ��� TPartner1CLinkPlaceForm
   IF ioId <> 0 AND NOT EXISTS (SELECT Id FROM Object where Id = ioId AND DescId = zc_Object_Partner()) THEN
      RAISE EXCEPTION '������.������������� �������� ����������.';
   END IF;

   -- �������� ��������� ��������
   IF COALESCE (inJuridicalId, 0) = 0  THEN
      RAISE EXCEPTION '������.�� ����������� <����������� ����>.';
   END IF;
   

   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   IF COALESCE (ioId, 0) = 0
   THEN
       -- ��������� <������>
       ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, '');
   END IF;

   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);

   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeJuridical(), ioId, inGLNCodeJuridical);
   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeRetail(), ioId, inGLNCodeRetail);   
   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeCorporate(), ioId, inGLNCodeCorporate);   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Schedule(), ioId, inSchedule);   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_BranchCode(), ioId, inBranchCode); 
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_BranchJur(), ioId, inBranchJur);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Terminal(), ioId, inTerminal); 
         
   -- ��������� �������� <�� ������� ���� ����������� �����>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_PrepareDayCount(), ioId, inPrepareDayCount /*CASE WHEN vbIsInsert = TRUE AND COALESCE (inPrepareDayCount, 0) = 0 THEN 1 ELSE inPrepareDayCount END*/);
   -- ��������� �������� <����� ������� ���� ����������� �������������>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);

   -- ��������� �������� <inCategory>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_Category(), ioId, inCategory);

   -- ��������� �������� <inTaxSale_Personal>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_TaxSale_Personal(), ioId, inTaxSale_Personal);
   -- ��������� �������� <inTaxSale_PersonalTrade>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_TaxSale_PersonalTrade(), ioId, inTaxSale_PersonalTrade);
   -- ��������� �������� <inTaxSale_MemberSaler1>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_TaxSale_MemberSaler1(), ioId, inTaxSale_MemberSaler1);
   -- ��������� �������� <inTaxSale_MemberSaler2>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_TaxSale_MemberSaler2(), ioId, inTaxSale_MemberSaler2);
   
   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <��������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route30201(), ioId, inRouteId_30201);
   
   -- ��������� ����� � <���������� ���������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- ��������� ����� � <��� ���� (��������� ����������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inMemberTakeId);

   -- ��������� ����� � <��� ���� (��������-1)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberSaler1(), ioId, inMemberSaler1Id);
   -- ��������� ����� � <��� ���� (��������-2)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberSaler2(), ioId, inMemberSaler2Id);
   
   -- ��������� ����� � <��������� (�����������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), ioId, inPersonalId);
   -- ��������� ����� � <��������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), ioId, inPersonalTradeId);
   -- ��������� ����� � <��������� (������������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalMerch(), ioId, inPersonalMerchId);
   -- ��������� ����� � <��������� (���������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalSigning(), ioId, inPersonalSigningId);

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), ioId, inAreaId);
   -- ��������� ����� � <������� �������� �����>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), ioId, inPartnerTagId);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_GoodsProperty(), ioId, inGoodsPropertyId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PriceList(), ioId, inPriceListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PriceList30201(), ioId, inPriceListId_30201);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceListPromo(), ioId, inPriceListPromoId);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_UnitMobile(), ioId, inUnitMobileId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_StartPromo(), ioId, DATE (inStartPromo));
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_EndPromo(), ioId, DATE (inEndPromo));

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiOrdspr(), ioId, inEdiOrdspr);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiInvoice(), ioId, inEdiInvoice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiDesadv(), ioId, inEdiDesadv);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 07.11.24         * inPersonalSigningId
 04.07.24         *
 24.10.23         *
 27.09.21         *
 25.05.21         *
 29.04.21         * Category
 19.06.17         * add inPersonalMerchId
 07.03.17         * add Schedule
 25.12.15         * add inGoodsPropertyId
 06.02.15         * add inEdiOrdspr, inEdiInvoice, inEdiDesadv
 22.11.14                                        * all
 10.11.14         * add redmine
 25.08.14                                        * set lp
 24.08.14                                        * add �������� ��� TPartner1CLinkPlaceForm
 16.08.14                                        * add inAddress
 01.06.14         * add ShortName,
                        HouseNumber, CaseNumber, RoomNumber, Street
 24.04.14                                        * add inPartnerName
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 06.01.14                                        * add inAddress
 06.01.14                                        * add �������� ������������ <���>
 06.01.14                                        * add �������� ������������ <������������>
 20.10.13                                        * vbCode_calc:=0
 29.07.13          *  + PersonalTakeId, PrepareDayCount, DocumentDayCount                
 03.07.13          *  + Route, RouteSorting              
 16.06.13                                        * rem lpCheckUnique_Object_ObjectCode
 13.06.13          *
 14.05.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Partner()

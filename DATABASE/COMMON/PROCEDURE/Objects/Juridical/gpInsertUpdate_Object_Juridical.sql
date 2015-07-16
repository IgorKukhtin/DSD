-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inCode                Integer   ,    -- �������� <��� ������������ ����>
    IN inName                TVarChar  ,    -- �������� ������� <����������� ����>
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    IN inisCorporate         Boolean   ,    -- ������� ���� �� ������������� ��� ����������� ����
    IN inisTaxSummary        Boolean   ,    -- ������� ������� ���������
    IN inDayTaxSummary       TFloat    ,    -- ���-�� ���� ��� ������� ���������
    IN inJuridicalGroupId    Integer   ,    -- ������ ����������� ���
    IN inGoodsPropertyId     Integer   ,    -- �������������� ������� �������
    IN inRetailId            Integer   ,    -- �������� ����
    IN inRetailReportId      Integer   ,    -- �������� ����(�����) 
    IN inInfoMoneyId         Integer   ,    -- ������ ����������
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����
    IN inSession             TVarChar       -- ������� ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());


   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Juridical());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Juridical(), inName);
   -- �������� ������������ <���>
   IF vbCode <> 0
   THEN
       PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), vbCode);
   END IF;

   -- ��������
   IF COALESCE (inInfoMoneyId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<�� ������ ����������> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inJuridicalGroupId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<������ ����������� ���> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inName, '') = ''
   THEN
      RAISE EXCEPTION '������.���������� ���������� <�������� ������������ ����>.';
   END IF;
   -- ��������
   IF inIsCorporate = TRUE AND COALESCE (ioId, 0) <> zc_Juridical_Basis()
   THEN
      RAISE EXCEPTION '������.����������� ���������� ������� <������� ����������� ����>.';
   END IF;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Juridical(), vbCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_DayTaxSummary(), ioId, inDayTaxSummary);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isTaxSummary(), ioId, inisTaxSummary);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_GoodsProperty(), ioId, inGoodsPropertyId);
    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);
    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_RetailReport(), ioId, inRetailReportId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_InfoMoney(), ioId, inInfoMoneyId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceList(), ioId, inPriceListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceListPromo(), ioId, inPriceListPromoId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_StartPromo(), ioId, DATE (inStartPromo));
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_EndPromo(), ioId, DATE (inEndPromo));
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Juridical  (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.11.14         *
 07.11.14         * �������� RetailReport
 23.05.14         * add Retail
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo               
 06.01.14                                        * add �������� ������������ <���>
 06.01.14                                        * add �������� ������������ <������������>
 20.10.13                                        * vbCode_calc:=0
 03.07.13          * + InfoMoney              
 12.05.13                                        * rem lpCheckUnique_Object_ValueData
 12.06.13          *    
 16.06.13                                        * rem lpCheckUnique_Object_ObjectCode
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Juridical()

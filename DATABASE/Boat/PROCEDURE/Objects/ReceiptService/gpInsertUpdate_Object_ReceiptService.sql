--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TVarChar,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar,TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptService(
 INOUT ioId                           Integer,       -- ���� ������� < >
 INOUT ioCode                         Integer,       -- ��� ������� < >
    IN inName                         TVarChar,      -- �������� ������� <>
    IN inArticle                      TVarChar,      --
    IN inNumReplace                   TVarChar,
    IN inComment                      TVarChar,      -- ������� ��������
    IN inTaxKindId                    Integer ,      -- ���
    IN inPartnerId                    Integer ,      -- ��������� �����
    IN inReceiptServiceGroupId        Integer , --
    IN inEKPrice                      TFloat  ,      -- ��. ���� ��� ���
    IN inSalePrice                    TFloat  ,      -- ���� ������� ��� ���
    IN inNPP                          TFloat  ,
    IN inReceiptServiceModelName      TVarChar,
    IN inReceiptServiceMaterialName   TVarChar,
    IN inSession                      TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbReceiptServiceModelId Integer;
   DECLARE vbReceiptServiceMaterialId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptService());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_ReceiptService());

   -- �������� ������������ ��� �������� <������������ ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReceiptService(), inName ::TVarChar, vbUserId);
   -- �������� ������������ ��� �������� <��� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReceiptService(), ioCode, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptService(), ioCode, inName);

   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptService_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);
   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptService_NumReplace(), ioId, inNumReplace);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptService_EKPrice(), ioId, inEKPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptService_SalePrice(), ioId, inSalePrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptService_NPP(), ioId, inNPP);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_TaxKind(), ioId, inTaxKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_Partner(), ioId, inPartnerId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_ReceiptServiceGroup(), ioId, inReceiptServiceGroupId);

   --������� ����� ReceiptServiceModel ���� ��� �������
   IF TRIM (COALESCE (inReceiptServiceModelName, '')) <> ''
   THEN
       -- ������� �����
       vbReceiptServiceModelId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptServiceModel() AND UPPER ( TRIM (Object.ValueData)) = UPPER ( TRIM (inReceiptServiceModelName)) );
       --���� �� ����� �������
       IF COALESCE (vbReceiptServiceModelId,0) = 0
       THEN
            --RAISE EXCEPTION '������.';
            vbReceiptServiceModelId := (SELECT tmp.ioId
                                        FROM gpInsertUpdate_Object_ReceiptServiceModel (ioId       := 0         :: Integer
                                                                                      , ioCode     := 0         :: Integer
                                                                                      , inName     := CAST (TRIM (inReceiptServiceModelName) AS TVarChar) ::TVarChar
                                                                                      , inComment  := ''        :: TVarChar
                                                                                      , inSession  := inSession :: TVarChar
                                                                                       ) AS tmp);

       END IF;
   END IF;

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_ReceiptServiceModel(), ioId, vbReceiptServiceModelId);


   -- ������� ����� ReceiptServiceMaterial ���� ��� �������
   IF TRIM (COALESCE (inReceiptServiceMaterialName, '')) <> ''
   THEN
       -- ������� �����
       vbReceiptServiceMaterialId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptServiceMaterial() AND UPPER ( TRIM (Object.ValueData)) = UPPER ( TRIM (inReceiptServiceMaterialName)) );
       --���� �� ����� �������
       IF COALESCE (vbReceiptServiceMaterialId,0) = 0
       THEN
            --RAISE EXCEPTION '������.';
            vbReceiptServiceMaterialId := (SELECT tmp.ioId
                                        FROM gpInsertUpdate_Object_ReceiptServiceMaterial (ioId       := 0         :: Integer
                                                                                         , ioCode     := 0         :: Integer
                                                                                         , inName     := CAST (TRIM (inReceiptServiceMaterialName) AS TVarChar) ::TVarChar
                                                                                         , inComment  := ''        :: TVarChar
                                                                                         , inSession  := inSession :: TVarChar
                                                                                          ) AS tmp);

       END IF;
   END IF;

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_ReceiptServiceMaterial(), ioId, vbReceiptServiceMaterialId);


   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
20.03.24          *
24.07.23          * Partner
22.12.20          *
11.12.20          *
*/

-- ����
--
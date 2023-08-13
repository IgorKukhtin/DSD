-- Function: gpInsertUpdate_Object_Asset()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Asset(
 INOUT ioId                  Integer   ,    -- ���� ������� < �������� ��������>
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� 
    
    IN inRelease             TDateTime ,    -- ���� �������
    
    IN inInvNumber           TVarChar  ,    -- ����������� �����
    IN inFullName            TVarChar  ,    -- ������ �������� ��
    IN inSerialNumber        TVarChar  ,    -- ��������� �����
    IN inPassportNumber      TVarChar  ,    -- ����� ��������
    IN inComment             TVarChar  ,    -- ����������
    
    IN inAssetGroupId        Integer   ,    -- ������ �� ������ �������� �������
    IN inJuridicalId         Integer   ,    -- ������ �� ����������� ����
    IN inMakerId             Integer   ,    -- ������ �� ������������� (��)
    IN inCarId               Integer   ,    -- ������ �� ����
    IN inAssetTypeId         Integer   ,    -- ��� ��  
    IN inPartionModelId      Integer   ,    -- ������
    
    IN inPeriodUse           TFloat   ,     -- ������ ������������
    IN inProduction          TFloat   ,     -- ������������������, ��
    IN inKW                  TFloat   ,     -- ������������ �������� KW 
    IN inisDocGoods          Boolean  ,     -- 
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Asset());
   vbUserId:= lpGetUserBySession (inSession);

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Asset()); 

   
   -- �������� ������������ ��� �������� <������������>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Asset(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Asset(), vbCode_calc);
   -- �������� ������������ ��� �������� <����������� �����> 
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Asset_InvNumber(), inInvNumber);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Asset(), vbCode_calc, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_InvNumber(), ioId, inInvNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_FullName(), ioId, inFullName);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_SerialNumber(), ioId, inSerialNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_PassportNumber(), ioId, inPassportNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_Comment(), ioId, inComment);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_AssetGroup(), ioId, inAssetGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_Maker(), ioId, inMakerId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_AssetType(), ioId, inAssetTypeId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_PartionModel(), ioId, inPartionModelId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_Car(), ioId, inCarId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_PeriodUse(), ioId, inPeriodUse);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_Production(), ioId, inProduction);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_KW(), ioId, inKW);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Asset_Release(), ioId, inRelease);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Asset_DocGoods(), ioId, inisDocGoods);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.08.23         *
 03.10.22         *
 17.11.20         *
 29.04.20         * add Production
 10.09.18         * add Car
 11.02.14         * add wiki  
 02.07.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Asset()

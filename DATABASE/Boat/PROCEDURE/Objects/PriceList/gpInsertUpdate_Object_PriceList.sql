-- Function: gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
 INOUT ioId            Integer   ,     -- ���� ������� <����� �����> 
    IN inCode          Integer   ,     -- ��� ������� <����� �����> 
    IN inName          TVarChar  ,     -- �������� ������� <����� �����> 
    IN inPriceWithVAT  Boolean   ,     -- ���� � ��� (��/���)
    IN inVATPercent    TFloat    ,     -- % ���
    IN inSession       TVarChar        -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:= lfGet_ObjectCode (inCode, zc_Object_PriceList());
   
   -- �������� ���� ������������ ��� �������� <������������ ����� �����>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PriceList(), inName);
   -- �������� ���� ������������ ��� �������� <��� ����� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PriceList(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceList(), inCode, inName);
   -- ��������� �������� <���� � ��� (��/���)>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PriceList_PriceWithVAT(), ioId, inPriceWithVAT);
   -- ��������� �������� <% ���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PriceList_VATPercent(), ioId, inVATPercent);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PriceList ()
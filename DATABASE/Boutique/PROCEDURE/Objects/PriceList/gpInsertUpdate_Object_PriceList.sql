-- Function: gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
 INOUT ioId              Integer,       -- ���� ������� <����� ����>
    IN inCode            Integer,       -- �������� <���>
    IN inName            TVarChar,      -- ������� ��������
    IN inCurrencyId      Integer,       -- ���� ������� <������> 
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_PriceList_seq'); END IF; 


   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PriceList(), inName); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PriceList(), inCode, inName);

   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceList_Currency(), ioId, inCurrencyId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
28.04.17          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PriceList()

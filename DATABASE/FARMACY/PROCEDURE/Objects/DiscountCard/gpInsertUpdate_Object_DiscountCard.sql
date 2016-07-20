-- Function: gpInsertUpdate_Object_DiscountCard()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountCard (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountCard(
 INOUT ioId                  Integer   , -- ���� �������
    IN inCode                Integer   , -- ��� ������� 
    IN inName                TVarChar  , -- ��������
    IN inObjectId            Integer   , -- ��� ��������� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountCard());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiscountCard());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountCard(), vbCode_calc, inName);

   -- ��������� ����� � <
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountCard_Object(), ioId, inObjectId);
   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiscountCard (ioId:=0, inCode:=0, inValue:='����', inObjectId:=0, inSession:='2')

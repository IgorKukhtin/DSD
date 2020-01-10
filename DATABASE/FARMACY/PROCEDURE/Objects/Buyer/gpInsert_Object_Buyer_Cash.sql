-- Function: gpInsert_Object_Buyer_Cash()

DROP FUNCTION IF EXISTS gpInsert_Object_Buyer_Cash(Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_Buyer_Cash(
 INOUT ioId             Integer   ,     -- ���� ������� <����������> 
    IN inPhone          TVarChar  ,     -- ������� 
    IN inName           TVarChar  ,     -- ������� ��� ��������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Buyer());

   -- �������� ����� ���
   IF ioId <> 0 
   THEN
     RAISE EXCEPTION '������. ��������� ������������� ��� ����� ������ ����������!';
   END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (0, zc_Object_Buyer());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Buyer(), inPhone);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Buyer(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Buyer(), vbCode_calc, inPhone);
      
   -- ��������� ������� ��� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Name(), ioId, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.01.20                                                       *
*/

-- ����

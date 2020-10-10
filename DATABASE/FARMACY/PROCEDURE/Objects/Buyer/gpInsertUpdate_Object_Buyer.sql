-- Function: gpInsertUpdate_Object_Buyer()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Buyer(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Buyer(
 INOUT ioId             Integer   ,     -- ���� ������� <����������> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inPhone          TVarChar  ,     -- ������� 
    IN inName           TVarChar  ,     -- ������� ��� ��������
    IN inEmail          TVarChar  ,     -- E-Mail
    IN inAddress        TVarChar  ,     -- ����� ����������
    IN inComment        TVarChar  ,     -- ����������
    IN inDateBirth      TDateTime ,     -- ���� ��������
    IN inSex            TVarChar  ,     -- ���
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Buyer());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Buyer());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Buyer(), inPhone);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Buyer(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Buyer(), vbCode_calc, inPhone);
   
   -- ��������� ������� ��� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Name(), ioId, inName);
   -- ��������� E-Mail
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_EMail(), ioId, inEMail);
   -- ��������� ����� ����������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Address(), ioId, inAddress);
   -- ��������� ����������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Comment(), ioId, inComment);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Buyer_DateBirth(), ioId, inDateBirth);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Sex(), ioId, inSex);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
*/

-- ����

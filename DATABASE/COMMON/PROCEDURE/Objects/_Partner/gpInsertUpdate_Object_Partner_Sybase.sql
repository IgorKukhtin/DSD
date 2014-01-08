-- Function: gpInsertUpdate_Object_Partner_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner_Sybase (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner_Sybase(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
    IN inCode                Integer   ,    -- ��� ������� <����������> 
    IN inName                TVarChar  ,    -- <����������> 
    IN inAddress             TVarChar  ,    -- ����� ����� ��������
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    IN inPrepareDayCount     TFloat    ,    -- �� ������� ���� ����������� �����
    IN inDocumentDayCount    TFloat    ,    -- ����� ������� ���� ����������� �������������
    IN inJuridicalId         Integer   ,    -- ����������� ����
    IN inRouteId             Integer   ,    -- �������
    IN inRouteSortingId      Integer   ,    -- ���������� ���������
    IN inPersonalTakeId      Integer   ,    -- ��������� (����������)  
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId := inSession;

   -- �������� ��������� ��������
   IF COALESCE (inJuridicalId, 0) = 0  THEN
      RAISE EXCEPTION '�� ����������� ����������� ����!';
   END IF;
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName);
   -- �������� ������������ <���>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), inCode); END IF;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, inName);
   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);
   -- ��������� �������� <����� ����� ��������>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Address(), ioId, inAddress);
   -- ��������� �������� <�� ������� ���� ����������� �����>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_PrepareDayCount(), ioId, inPrepareDayCount);
   -- ��������� �������� <����� ������� ���� ����������� �������������>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);
   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <��������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
   -- ��������� ����� � <���������� ���������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- ��������� ����� � <��������� (����������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTake(), ioId, inPersonalTakeId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.01.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Partner_Sybase()

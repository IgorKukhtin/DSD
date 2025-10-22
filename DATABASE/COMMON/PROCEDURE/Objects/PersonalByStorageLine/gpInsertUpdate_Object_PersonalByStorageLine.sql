-- Function: gpInsertUpdate_Object_PersonalByStorageLine(Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalByStorageLine (Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalByStorageLine(
 INOUT ioId                  Integer   , -- ���� ������� <>
    IN inPersonalId          Integer   , -- ���������
    IN inStorageLineId       Integer   , -- ����� ������������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PersonalByStorageLine());
   vbUserId:= lpGetUserBySession (inSession);

    -- ��������
   IF COALESCE (inPersonalId, 0) = 0
   THEN
       RAISE EXCEPTION '������. ��������� �� ������.';
   END IF;

    -- ��������
   IF COALESCE (inStorageLineId, 0) = 0
   THEN
       RAISE EXCEPTION '������. ����� ������������ �� �������.';
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PersonalByStorageLine(), 0, '');
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PersonalByStorageLine_Personal(), ioId, inPersonalId);   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PersonalByStorageLine_StorageLine(), ioId, inStorageLineId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.10.25         * 
*/
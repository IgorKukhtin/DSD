-- Function: gpInsertUpdate_Object_InternetRepair()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InternetRepair (Integer , Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InternetRepair(
 INOUT ioId	                 Integer   ,    -- ���� �������
    IN inCode                Integer   ,    -- ��� �������
    IN inName                TVarChar  ,    -- �������� ������� <

    IN inUnitId              Integer   ,    -- �������������
    IN inProvider            TVarChar  ,    -- ���������
    IN inContractNumber      TVarChar  ,    -- ����� ��������
    IN inPhone               TVarChar  ,    -- �������
    IN inWhoSignedContract   TVarChar  ,    -- ��� ������� �������
    IN inNotes               TBlob     ,    -- �������

    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE (inUnitId, 0) = 0 OR  COALESCE (inProvider, '') = ''
   THEN
     RAISE EXCEPTION '������. ������������� � ��������� ������ ���� ���������.'; 
   END IF;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_InternetRepair());

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InternetRepair(), vbCode_calc, COALESCE(inName, ''));

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InternetRepair_Unit(), ioId, inUnitId);

   -- ��������� <���������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InternetRepair_Provider(), ioId, inProvider);
   -- ��������� <����� ��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InternetRepair_ContractNumber(), ioId, inContractNumber);
   -- ��������� <�������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InternetRepair_Phone(), ioId, inPhone);
   -- ��������� <��� ������� �������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InternetRepair_WhoSignedContract(), ioId, inWhoSignedContract);

   -- ��������� <�������>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_InternetRepair_Notes(), ioId, inNotes);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InternetRepair(Integer , Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.09.22                                                       *              
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_InternetRepair()
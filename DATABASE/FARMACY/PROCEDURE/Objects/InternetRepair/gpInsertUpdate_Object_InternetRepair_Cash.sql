-- Function: gpInsertUpdate_Object_InternetRepair_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InternetRepair_Cash (Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InternetRepair_Cash(
    IN inId	                 Integer   ,    -- ���� �������
    IN inNotes               TBlob     ,    -- �������

    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION '������. ������ ��������� �� ��������.'; 
   END IF;
   
   -- ��������� <�������>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_InternetRepair_Notes(), inId, inNotes);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InternetRepair_Cash(Integer, TBlob, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.09.22                                                       *              
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_InternetRepair_Cash()
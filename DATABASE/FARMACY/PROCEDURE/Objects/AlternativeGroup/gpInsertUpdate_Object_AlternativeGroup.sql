-- Function: gpInsertUpdate_Object_AlternativeGroup (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AlternativeGroup (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AlternativeGroup(
 INOUT ioId                       Integer   ,    -- ���� ������� < ������ ����������� >
    IN inName                     TVarChar  ,    -- ��������
    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AlternativeGroup());
   vbUserId := inSession;

   -- ��������� ������������ ��������
   IF COALESCE(inName) = ''
   THEN
     RAISE EXCEPTION '������.�������� ������ �� ����� ���� ������';
   END IF;
   
   ioId := lpInsertUpdate_Object (ioId, zc_Object_AlternativeGroup(), 0, inName);
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AlternativeGroup (Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �. �.
 28.06.15                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_AlternativeGroup(0,'����','3')


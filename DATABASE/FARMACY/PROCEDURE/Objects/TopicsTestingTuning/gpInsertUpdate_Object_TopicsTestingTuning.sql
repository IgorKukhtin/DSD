-- Function: gpInsertUpdate_Object_TopicsTestingTuning()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TopicsTestingTuning (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TopicsTestingTuning(
 INOUT ioId                        Integer,   -- ���� ������� <>
    IN inCode                      Integer,   -- ��� �������
    IN inName                      TVarChar,  -- �������� �������
    IN inSession                   TVarChar   -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TopicsTestingTuning());
   vbUserId := inSession;
  
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_TopicsTestingTuning());

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_TopicsTestingTuning(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TopicsTestingTuning(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TopicsTestingTuning(), vbCode_calc, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.07.21                                                       *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_TopicsTestingTuning(ioId:=null, inCode:=null, inName:='������ 1', inSession:='3')
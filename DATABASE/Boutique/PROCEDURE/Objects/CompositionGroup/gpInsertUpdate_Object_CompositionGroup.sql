-- Function: gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CompositionGroup(
 INOUT ioId	      Integer,       -- ���� ������� <������ ��� ������� ������>
    IN inCode         Integer,       -- ��� ������� <������ ��� ������� ������>
    IN inName         TVarChar,      -- �������� ������� <������ ��� ������� ������>
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Composition());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!��������!!! - �������� ����� Id  ��� �������� �� Sybase - !!!�� ���� � Sybase ��� ������������ - ���� ������!!!
   IF COALESCE (ioId, 0) = 0
   THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_CompositionGroup());
        -- �������� ����� ���
        inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId);
   END IF;
   -- !!!��������!!! - ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (inCode, 0) = 0 THEN  inCode := NEXTVAL ('Object_CompositionGroup_seq'); END IF; 


   -- �������� ������������ ��� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CompositionGroup(), inCode);
   -- �������� ������������ ��� <��������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CompositionGroup(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CompositionGroup(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
16.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CompositionGroup()

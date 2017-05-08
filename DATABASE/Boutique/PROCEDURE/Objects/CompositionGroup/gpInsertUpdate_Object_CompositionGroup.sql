-- Function: gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CompositionGroup(
 INOUT ioId	      Integer,       -- ���� ������� <������ ��� ������� ������>
 INOUT ioCode         Integer,       -- ��� ������� <������ ��� ������� ������>
    IN inName         TVarChar,      -- �������� ������� <������ ��� ������� ������>
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS record 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Composition());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!��������!!! - �������� ����� Id  ��� �������� �� Sybase - !!!�� ���� � Sybase ��� ������������ - ���� ������!!!
   IF COALESCE (ioId, 0) = 0    AND COALESCE(ioCode,0) = 0 
   THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_CompositionGroup());
        -- �������� ����� ���
        ioCode := (SELECT ObjectCode FROM Object WHERE Id = ioId);
   END IF;
   -- !!!��������!!! - ��� �������� �� Sybase �.�. ��� ��� = 0 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_CompositionGroup_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_CompositionGroup_seq'); 
   END IF; 


   -- �������� ������������ ��� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CompositionGroup(), ioCode);
   -- �������� ������������ ��� <��������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CompositionGroup(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CompositionGroup(), ioCode, inName);

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

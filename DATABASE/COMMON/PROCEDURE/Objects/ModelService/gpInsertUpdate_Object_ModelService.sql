-- Function: gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelService(
 INOUT ioId                   Integer   ,    -- ���� ������� <������ ����������> 
    IN inCode                 Integer   ,    -- ��� �������
    IN inName                 TVarChar  ,    -- �������� �������
    IN inComment              TVarChar  ,    -- ����������
    IN inUnitId               Integer   ,    -- �������������
    IN inModelServiceKindId   Integer   ,    -- ���� ������ ����������
    IN inSession              TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   

BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ModelService());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ModelService()); 
   
   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ModelService(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ModelService(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ModelService(), vbCode_calc, inName);
  
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ModelService_Comment(), ioId, inComment);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ModelService_Unit(), ioId, inUnitId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ModelService_ModelServiceKind(), ioId, inModelServiceKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_ModelService (Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.10.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ModelService(0,0,'EREWG', 'ghygjf', 2,6,'2')

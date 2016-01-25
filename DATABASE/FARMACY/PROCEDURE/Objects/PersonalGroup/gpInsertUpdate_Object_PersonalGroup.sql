-- Function: gpInsertUpdate_Object_PersonalGroup(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalGroup(Integer,Integer,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalGroup(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������� �����������> 
    IN inCode                     Integer   ,    -- ��� �������
    IN inName                     TVarChar  ,    -- �������� �������
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   

BEGIN
      
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PersonalGroup());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PersonalGroup()); 
   
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PersonalGroup(), vbCode_calc);
 
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PersonalGroup(), vbCode_calc, inName);
 
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_PersonalGroup (Integer,Integer,TVarChar,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PersonalGroup()

-- Function: gpInsertUpdate_Object_PersonalGroup(Integer,Integer,TVarChar,TFloat,Integer,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_PersonalGroup(Integer,Integer,TVarChar,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalGroup(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������� �����������> 
    IN inCode                     Integer   ,    -- ��� �������
    IN inName                     TVarChar  ,    -- �������� �������
    IN inWorkHours                TFloat    ,    -- ���������� �����
    IN inUnitId                   Integer   ,    -- �������������
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   

BEGIN
   -- !!! ��� �������� !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT PersonalGroupId FROM Object_PersonalGroup_View WHERE PersonalGroupName = inName AND UnitId = inUnitId);
   -- END IF;
   
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PersonalGroup());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PersonalGroup()); 
   
   -- ��������  ������������ ��� �������: <������������> + <�������������>
   IF EXISTS (SELECT PersonalGroupName FROM Object_PersonalGroup_View WHERE PersonalGroupName = inName AND UnitId = inUnitId AND PersonalGroupId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION '�������� <%> ��� �������������: <%> �� ��������� � ����������� <%>.', inName, (SELECT ValueData FROM Object WHERE Id = inUnitId), (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PersonalGroup());
   END IF; 

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PersonalGroup(), vbCode_calc);
 
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PersonalGroup(), vbCode_calc, inName);
  
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PersonalGroup_WorkHours(), ioId, inWorkHours);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalGroup_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_PersonalGroup (Integer,Integer,TVarChar,TFloat,Integer,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.11.13                                        * add �������� ������������ ��� �������
 09.10.13                                        * �������� ����� ���
 30.09.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PersonalGroup()

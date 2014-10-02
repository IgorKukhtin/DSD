-- Function: gpInsertUpdate_Object_PersonalServiceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalServiceList(
 INOUT ioId             Integer   ,     -- ���� ������� <> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inName           TVarChar  ,     -- �������� ������� 
    IN inJuridicalId    Integer   ,     -- ��. ����
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PersonalServiceList());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PersonalServiceList());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PersonalServiceList(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PersonalServiceList(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PersonalServiceList(), vbCode_calc, inName);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Juridical(), ioId, inJuridicalId);
        
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PersonalServiceList (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PersonalServiceList(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')
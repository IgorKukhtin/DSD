-- Function: gpInsertUpdate_Object_InfoMoneyGroup()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(
 INOUT ioId	             Integer   ,   	-- ���� <������ �������������� ��������>
    IN inCode            Integer   ,    -- ���
    IN inName            TVarChar  ,    -- ������������  
    IN inSession         TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_calc Integer;   

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoneyGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_InfoMoneyGroup());


   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoneyGroup(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoneyGroup(), Code_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoneyGroup(), Code_calc, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InfoMoneyGroup (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.06.13          *                             
*/

-- ����  
-- SELECT * FROM gpInsertUpdate_Object_InfoMoneyGroup()                         
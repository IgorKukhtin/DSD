-- Function: gpInsertUpdate_Object_InfoMoneyGroup()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(
 INOUT ioId              Integer   ,   	-- ���� <������ �������������� ��������>
    IN inCode            Integer   ,    -- ���
    IN inName            TVarChar  ,    -- ������������  
    IN inSession         TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoneyGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_InfoMoneyGroup());


   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoneyGroup(), inName,vbUserId);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoneyGroup(), vbCode_max, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoneyGroup(), vbCode_max, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.06.13          *                             
*/

-- ����  
-- SELECT * FROM gpInsertUpdate_Object_InfoMoneyGroup()                         
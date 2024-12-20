-- Function: gpInsertUpdate_Object_AccountDirection(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_AccountDirection (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AccountDirection(
 INOUT ioId             Integer,       -- ���� ������� <��������� �������������� ������>
    IN inCode           Integer,       -- �������� <��� ��������� �������������� ������>
    IN inName           TVarChar,      -- �������� <������������ ��������� �������������� ������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   
 
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_AccountDirection());
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AccountDirection());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_AccountDirection()); 
   
   -- !!! �������� ������������ ��� �������� <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_AccountDirection(), inName);

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_AccountDirection(), vbCode_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_AccountDirection(), vbCode_max, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 18.04.14                                        * rem !!! ��� �������� !!!
 25.08.13                                        * !!! ��� �������� !!!
 21.06.13          * vbCode_max:=lpGet_ObjectCode (inCode, zc_Object_AccountDirection()); 
 19.06.13                                        * rem lpCheckUnique_Object_ValueData
 17.06.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_AccountDirection()

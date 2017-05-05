-- Function: gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId           Integer,       -- ���� ������� <���������� ����>    
    IN inCode         Integer,       -- ��� ������� <���������� ����>     
    IN inName         TVarChar,      -- �������� ������� ��� <���������� ����>
    IN inINN          TVarChar,      -- ���
    IN inComment      TVarChar,      -- ����������
    IN inEMail        TVarChar,      -- E-Mail
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Member());
   vbUserId:= lpGetUserBySession (inSession);

  -- !!!��������!!! - �������� ����� Id  ��� �������� �� Sybase - !!!�� ���� � Sybase ��� ������������ - ���� ������!!!
   IF COALESCE (ioId, 0) = 0
   THEN ioId := (SELECT Id FROM Object WHERE Valuedata = inName AND DescId = zc_Object_Member());
        -- �������� ����� ���
        inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId);
   END IF;
   -- !!!��������!!! - ��� �������� �� Sybase �.�. ��� ��� = 0 


   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Member_seq'); END IF; 
   
   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName); 
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Member(), inCode, inName);

   -- ��������� ���
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_INN(), ioId, inINN);
   -- ��������� ����������  
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_Comment(), ioId, inComment);
   -- ��������� E-Mail
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_EMail(), ioId, inEMail);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
06.03.17                                                          *
20.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Member()

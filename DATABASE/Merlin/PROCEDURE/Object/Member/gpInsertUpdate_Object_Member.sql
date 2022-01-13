-- Function: gpInsertUpdate_Object_Member()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId	          Integer   ,    -- ���� ������� <> 
    IN inCode             Integer   ,    -- ��� ������� <> 
    IN inName             TVarChar  ,    -- �������� ������� <> 
    IN inEMail            TVarChar  ,    -- 
    IN inComment          TVarChar  ,    -- 
    IN inSession          TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_Member());
    
   -- �������� ���� ������������ ��� �������� <������������ >  
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName);
   -- �������� ���� ������������ ��� �������� <��� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), inCode, inName);

   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_Comment(), ioId, inComment);
   -- ���������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_EMail(), ioId, inEMail);


   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- ��������� �������� <���� ����>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ ����>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);   
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
 /*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.01.22         *
*/

-- ����
--
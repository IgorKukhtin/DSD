-- Function: gpInsertUpdate_Object_InfoMoney()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId	          Integer   ,    -- ���� ������� <> 
    IN inCode             Integer   ,    -- ��� ������� <> 
    IN inName             TVarChar  ,    -- �������� ������� <>
    IN inisService        Boolean   , 
    IN inisUserAll        Boolean   , 
    IN inInfoMoneyKindId  Integer   ,    --
    IN inParentId         Integer   ,    -- ���� ������� <�����>
    IN inSession          TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbGroupNameFull TVarChar;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_InfoMoney());
    
   -- �������� ���� ������������ ��� �������� <������������ �����>  
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inInfoMoneyName);
   -- �������� ���� ������������ ��� �������� <��� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoney(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_InfoMoney(), inCode, inInfoMoneyName);

   -- �������� �������� <������ �������� ������>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inParentId, zc_ObjectLink_InfoMoney_Parent());

   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InfoMoney_GroupNameFull(), ioId, vbGroupNameFull);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_Service(), ioId, inisService);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_UserAll(), ioId, inisUserAll);
   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoney_InfoMoneyKind(), ioId, inInfoMoneyKindId);
   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoney_Parent(), ioId, inParentId);

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
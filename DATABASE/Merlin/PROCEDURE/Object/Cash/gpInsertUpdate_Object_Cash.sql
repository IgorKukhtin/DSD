-- Function: gpInsertUpdate_Object_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash(
 INOUT ioId	          Integer   ,    -- ���� ������� <�����> 
    IN inCode             Integer   ,    -- ��� ������� <�����> 
    IN inCashName         TVarChar  ,    -- �������� ������� <�����> 
    IN inShortName        TVarChar  ,    -- ����������� ��������
    IN inNPP              TFloat    ,    -- � ��
    IN inCurrencyId       Integer   ,    -- ������ ������ ����� 
    IN inPaidKindId       Integer   ,    -- ����� ������
    IN inParentId         Integer   ,    -- ���� ������� <�����> 
    IN inSession          TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGroupNameFull TVarChar;    
   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Cash());
   --vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_Cash());
    
   -- �������� ���� ������������ ��� �������� <������������ �����>  
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Cash(), inCashName);
   -- �������� ���� ������������ ��� �������� <��� �����>
   --PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Cash(), inCode);

   -- ���������
   vbOldId:= ioId;
   -- ���������
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Cash_Parent() AND ObjectId = ioId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Cash(), inCode, inCashName);

   -- �������� �������� <������ �������� ������>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inParentId, zc_ObjectLink_Cash_Parent());

   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Cash_GroupNameFull(), ioId, vbGroupNameFull);
   -- ���������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Cash_ShortName(), ioId, inShortName);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Cash_NPP(), ioId, inNPP);
   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Currency(), ioId, inCurrencyId);
   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Parent(), ioId, inParentId);
   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_PaidKind(), ioId, inPaidKindId);

   -- ���� ��������� ������
   IF vbOldId <> ioId THEN
      -- ���������� �������� ����\����� � ����
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- ����� ������ inParentId ���� ������
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_Cash_Parent());
   END IF;

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
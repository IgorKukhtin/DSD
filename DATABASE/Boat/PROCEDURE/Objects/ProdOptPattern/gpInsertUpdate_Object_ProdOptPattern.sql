-- Function: gpInsertUpdate_Object_ProdOptPattern()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptPattern(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptPattern(
 INOUT ioId               Integer   ,    -- ���� ������� <>
    IN inCode             Integer   ,    -- ��� ������� 
    IN inName             TVarChar  ,    -- �������� �������
    IN inComment          TVarChar  ,
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdOptPattern());
   vbUserId:= lpGetUserBySession (inSession);

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1, ��� ������ ����� ������� � 1
    vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ProdOptPattern()); 
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdOptPattern(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdOptPattern_Comment(), ioId, inComment);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdOptPattern()


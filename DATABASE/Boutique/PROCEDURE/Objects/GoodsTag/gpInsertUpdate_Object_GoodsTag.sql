-- Function: gpInsertUpdate_Object_GoodsTag()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsTag(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsTag(
 INOUT ioId                  Integer   ,     -- ���� ������� <������� ������> 
    IN inCode                Integer   ,     -- ��� �������  
    IN inName                TVarChar  ,     -- �������� ������� 
    IN inSession             TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_GoodsTag());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsTag(), vbCode_calc, inName);
   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.05.20         * 
*/

-- ����
--
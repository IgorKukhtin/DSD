-- Function: gpInsertUpdate_Object_GoodsWhoCan()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsWhoCan(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsWhoCan(
 INOUT ioId	             Integer   ,    -- ���� ������� <����� ������� (���. ������)> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� <>
    IN inNameUkr             TVarChar  ,    -- �������� ������� <>
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsWhoCan());
   vbUserId := inSession;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_GoodsWhoCan());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsWhoCan(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsWhoCan(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsWhoCan(), vbCode_calc, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsWhoCan_NameUkr(), ioId, inNameUkr);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.07.22                                                       *              
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsWhoCan()
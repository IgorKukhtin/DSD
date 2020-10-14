-- Function: gpInsertUpdate_Object_ConditionsKeep()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ConditionsKeep(Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ConditionsKeep(
 INOUT ioId	                 Integer   ,    -- ���� ������� <̳�������� ������������� ����� (���. ������)> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� <>
    IN inRelatedProductId    Integer   ,    -- ������������� ������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ConditionsKeep());
   vbUserId := inSession;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ConditionsKeep());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ConditionsKeep(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ConditionsKeep(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ConditionsKeep(), vbCode_calc, inName);

   -- ��������� �������� <������������� ������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ConditionsKeep_RelatedProduct(), ioId, inRelatedProductId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 14.10.18                                                      *
 07.01.17         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ConditionsKeep()

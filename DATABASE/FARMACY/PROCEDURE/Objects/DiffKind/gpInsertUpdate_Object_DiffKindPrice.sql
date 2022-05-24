-- Function: gpInsertUpdate_Object_DiffKindPrice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKindPrice (Integer, Integer, TVarChar, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiffKindPrice(
 INOUT ioId	                  Integer   ,    -- ���� ������� <> 
    IN inCode                 Integer   ,    -- ��� ������� 
    IN inName                 TVarChar  ,    -- �������� ������� <>
    IN inDiffKindId           Integer   ,    -- ��� ������
    IN inPrice                TFloat    ,    -- ����������� ����
    IN inAmount               TFloat    ,    -- ���������� ��������
    IN inSumma                TFloat    ,    -- ������������ ����� ������
    IN inSession              TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiffKindPrice());
   
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiffKindPrice(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_DiffKindPrice(), vbCode_calc, COALESCE(inName, ''));

   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiffKindPrice_DiffKind(), ioId, inDiffKindId);

   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiffKindPrice_MinPrice(), ioId, inPrice);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiffKindPrice_Amount(), ioId, inAmount);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiffKindPrice_Summa(), ioId, inSumma);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.05.22                                                       * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiffKindPrice()
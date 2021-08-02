-- Function: gpInsertUpdate_Object_DiffKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiffKind(
 INOUT ioId	                  Integer   ,    -- ���� ������� <> 
    IN inCode                 Integer   ,    -- ��� ������� 
    IN inName                 TVarChar  ,    -- �������� ������� <>
    IN inIsClose              Boolean   ,    -- ������ ��� ������
    IN inMaxOrderAmount       TFloat    ,    -- ������������ ����� ������ 
    IN inMaxOrderAmountSecond TFloat    ,    -- ������������ ����� ������ ������ �����
    IN inDaysForSale          Integer   ,    -- ���� ��� �������
    IN inIsLessYear           Boolean   ,    -- �������� ����� ������ � ������ ����� ����
    IN inIsFormOrder          Boolean   ,    -- ����� ����������� �����
    IN inisFindLeftovers      Boolean   ,    -- ����� �������� �� �������
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
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiffKind());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_DiffKind(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiffKind(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_DiffKind(), vbCode_calc, inName);

   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_Close(), ioId, inIsClose);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_LessYear(), ioId, inIsLessYear);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_FormOrder(), ioId, inIsFormOrder);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_FindLeftovers(), ioId, inisFindLeftovers);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MaxOrderAmount(), ioId, inMaxOrderAmount);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MaxOrderAmountSecond(), ioId, inMaxOrderAmountSecond);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiffKind_DaysForSale(), ioId, inDaysForSale);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.12.19                                                       * 
 05.06.19                                                       * 
 11.12.18         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiffKind()
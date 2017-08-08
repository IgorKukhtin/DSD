-- Function: gpUpdate_Contract_OrderParam()

DROP FUNCTION IF EXISTS gpUpdate_Contract_OrderParam (Integer, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_OrderParam(
    IN inId                      Integer   ,   	-- ���� ������� <�������>
    IN inOrderSumm               TFloat    ,    -- ����������� ����� ��� ������
    IN inOrderSummComment        TVarChar  ,    -- ���������� � ����������� ����� ��� ������
    IN inOrderTime               TVarChar  ,    -- ������������ - ������������ ����� ��������
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   vbUserId:= inSession;

   -- ��������
   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- ��������� �������� <����������� ����� ��� ������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_OrderSumm(), inId, inOrderSumm);

   -- ��������� �������� <������������ - ������������ ����� ��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_OrderTime(), inId, inOrderTime);
      -- ��������� �������� <���������� � ����������� ����� ��� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_OrderSumm(), inId, inOrderSummComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.08.17         *
*/

-- ����
-- 

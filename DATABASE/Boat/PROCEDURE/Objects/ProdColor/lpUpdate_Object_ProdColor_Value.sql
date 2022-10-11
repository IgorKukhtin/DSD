-- zc_Object_ProdColor

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColor_Value (TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_ProdColor_Value (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_Object_ProdColor_Value (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_ProdColor_Value(
    IN inId              Integer,       -- ���� �������
    IN inValue           TVarChar,      -- �������� �����
    IN inUserId          Integer        -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbColor_calc Integer;
BEGIN
   
   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������. inId = <%>', inId;
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ProdColor_Value(), inId, inValue);
   
   IF inValue <> ''
   THEN
      BEGIN
         EXECUTE('SELECT CAST(x'''||SUBSTRING(inValue, 6, 2)||SUBSTRING(inValue, 4, 2)||SUBSTRING(inValue, 2, 2)||''' AS INT8)') INTO vbColor_calc;
      EXCEPTION
         WHEN others THEN vbColor_calc := zc_Color_White();
      END;     
   ELSE
     vbColor_calc := zc_Color_White();
   END IF;

   -- ��������� �������� <>
   IF vbColor_calc <> zc_Color_White() OR
      EXISTS(SELECT 1 FROM ObjectFloat
             WHERE ObjectId = inId AND DescId = zc_ObjectFloat_ProdColor_Value())
   THEN
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdColor_Value(), inId, vbColor_calc);
   END IF;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.09.22                                                       *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_ProdColor_Value()
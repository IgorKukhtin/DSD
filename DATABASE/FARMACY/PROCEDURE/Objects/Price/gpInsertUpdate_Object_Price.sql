-- Function: gpInsertUpdate_Object_Price (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� > 
    IN inPrice                    TFloat    ,    -- 
    IN inGoodsId                  Integer   ,    --          
    IN inUnitId                   Integer   ,    --
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Price());
   vbUserId := inSession;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Price(), 0, '');

   -- ��������� ��-�� < ���� >
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Price_Value(), ioId, inPrice);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Price()

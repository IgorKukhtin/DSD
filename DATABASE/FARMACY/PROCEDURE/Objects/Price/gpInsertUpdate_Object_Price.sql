-- Function: gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� >
    IN inPrice                    TFloat    ,    -- ����
    IN inGoodsId                  Integer   ,    -- �����
    IN inUnitId                   Integer   ,    -- �������������
   OUT outDateChange              TDateTime ,    -- ���� ��������� ����
    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Price());
   vbUserId := inSession;

   -- ��������� ������������ ����
   IF (COALESCE(inPrice,0)<=0)
   THEN
     RAISE EXCEPTION '������.���� <%> ������ ���� ������ 0.', inPrice;
   END IF;
   -- ���� ����� ������ ���� - ������� � ����� ����.-�����
   SELECT Id INTO ioId
   from Object_Price_View
   Where
     GoodsId = inGoodsId
     AND
     UnitId = inUnitID;
   IF COALESCE(ioId,0)=0
   THEN
     -- ���������/�������� <������> �� ��
     ioId := lpInsertUpdate_Object (ioId, zc_Object_Price(), 0, '');

     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), ioId, inGoodsId);

     -- ��������� ����� � <�������������>
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), ioId, inUnitId);
   END IF;
   -- ��������� ��-�� < ���� >
   PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_Value(), ioId, inPrice);
   -- ��������� ��-�� < ���� ��������� >
   outDateChange := CURRENT_DATE;
   PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_DateChange(), ioId, outDateChange);

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

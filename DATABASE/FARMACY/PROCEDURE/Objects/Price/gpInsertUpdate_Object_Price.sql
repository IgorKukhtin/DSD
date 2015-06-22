-- Function: gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� >
    IN inPrice                    TFloat    ,    -- ����
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
    IN inGoodsId                  Integer   ,    -- �����
    IN inUnitId                   Integer   ,    -- �������������
   OUT outDateChange              TDateTime ,    -- ���� ��������� ����
   OUT outMCSDateChange           TDateTime ,    -- ���� ��������� ������������ ��������� ������
    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
   DECLARE
     vbUserId Integer;
     vbPrice TFloat;
     vbMCSValue TFloat;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Price());
   vbUserId := inSession;

   -- ��������� ������������ ����
   IF inPrice = 0
   THEN
     inPrice := null;
   END IF;
   IF inPrice is not null AND (inPrice<0)
   THEN
     RAISE EXCEPTION '������.���� <%> ������ ���� ������ 0.', inPrice;
   END IF;
   -- ��������� ������������ ����

   IF inMCSValue is not null AND (inMCSValue<0)
   THEN
     RAISE EXCEPTION '������.����������� �������� ����� <%> �� ����� ���� ������ 0.', inMCSValue;
   END IF;
   -- ���� ����� ������ ���� - ������� � ����� ����.-�����
   SELECT Id, Price, MCSValue, DateChange, MCSDateChange
     INTO ioId, vbPrice, vbMCSValue, outDateChange, outMCSDateChange
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
   IF (inPrice is not null) AND (inPrice <> COALESCE(vbPrice,0))
   THEN
     PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_Value(), ioId, inPrice);
     -- ��������� ��-�� < ���� ��������� >
     outDateChange := CURRENT_DATE;
     PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_DateChange(), ioId, outDateChange);
   END IF;
   -- ��������� ��-�� < ����������� �������� ����� >
   IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
   THEN
     PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, inMCSValue);
     -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
     outMCSDateChange := CURRENT_DATE;
     PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), ioId, outMCSDateChange);
   END IF;
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Price()

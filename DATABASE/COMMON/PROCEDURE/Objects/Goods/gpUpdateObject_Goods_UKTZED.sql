-- Function: gpUpdateObject_Goods_UKTZED()

DROP FUNCTION IF EXISTS gpUpdateObject_Goods_UKTZED (Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdateObject_Goods_UKTZED (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdateObject_Goods_UKTZED (Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdateObject_Goods_UKTZED (Integer, TVarChar, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateObject_Goods_UKTZED (Integer, TVarChar, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Goods_UKTZED(
    IN inId                  Integer   , -- ���� ������� <�����>
    IN inUKTZED              TVarChar  , -- ��� ������ �� ��� ���  
    IN inCodeUKTZED_new      TVarChar  , --
    IN inDateUKTZED_new      TDateTime , -- 
    IN inGoodsGroupPropertyId Integer, 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Goods_UKTZED());


     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_UKTZED(), inId, inUKTZED); 
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_UKTZED_new(), inId, inCodeUKTZED_new);
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_UKTZED_new(), inId, inDateUKTZED_new);

     -- ��������� ����� � < ������������� �������������>              
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupProperty(), inId, inGoodsGroupPropertyId);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.24         *
 09.11.23         *
 13.07.17         *
 10.03.17         *
 06.01.17         *
*/


-- ����
-- SELECT * FROM gpUpdateObject_Goods_UKTZED (ioId:= 275079, inUKTZED:= '456/45', inSession:= '2')

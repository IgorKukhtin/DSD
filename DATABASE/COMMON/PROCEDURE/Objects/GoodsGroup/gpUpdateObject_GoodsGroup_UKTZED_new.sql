-- Function: gpUpdateObject_GoodsGroup_UKTZED()

DROP FUNCTION IF EXISTS gpUpdateObject_GoodsGroup_UKTZED_new (Integer, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_GoodsGroup_UKTZED_new(
    IN inId                  Integer   , -- ���� ������� <�����>
    IN inUKTZED              TVarChar  , -- ��� ������ �� ��� ���
    IN inUKTZED_new          TVarChar  , -- ��� ������ �� ��� ���   �����
    IN inDateUKTZED_new      TDateTime , -- ���� �������� ��� ��� ������ �� ������   ����� 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_GoodsGroup_UKTZED());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED(), inId, inUKTZED);
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED_new(), inId, inUKTZED_new);
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsGroup_UKTZED_new(), inId, inDateUKTZED_new);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.03.23         *
*/


-- ����
--
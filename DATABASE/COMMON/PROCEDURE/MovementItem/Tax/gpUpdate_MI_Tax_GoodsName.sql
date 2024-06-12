-- Function: gpUpdate_MI_Tax_GoodsName()

DROP FUNCTION IF EXISTS gpUpdate_MI_Tax_GoodsName (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Tax_GoodsName(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inGoodsName           TVarChar  , -- ������ ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Tax());


     -- ��������� �������� <������ ��������>  --�������������� � �����
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), inId, inGoodsName);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.06.24         *
*/

-- ����
--
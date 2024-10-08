-- Function: gpUpdate_MI_Income_PricePartner()

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_PricePartner (Integer, Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_PricePartner(
    IN inMovementId      Integer      , -- ���� ���������
    IN inId              Integer      , -- ���� ������
    IN inPricePartner    TFloat       ,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_PricePartner());

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), inId, inPricePartner);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.24         *
*/

-- ����
--
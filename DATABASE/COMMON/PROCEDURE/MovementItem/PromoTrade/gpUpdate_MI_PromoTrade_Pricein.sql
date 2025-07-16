-- Function: gpUpdate_MI_PromoTrade_PriceIn()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoTrade_PriceIn (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoTrade_PriceIn(
    IN inId          Integer   , -- ���� ������� <������� ���������>
    IN inPriceIn     TFloat    , --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
    IF COALESCE (inId,0) = 0
    THEN
        RETURN;
    END IF;
    
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTrade());

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), inId, inPriceIn);  

    --��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.25         *
*/
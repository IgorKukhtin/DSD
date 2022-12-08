-- Function: gpUpdate_MovementItem_Sale_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_ChangePercent (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_ChangePercent(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inChangePercent       TFloat    , -- % ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId := inSession;

    IF 3 <> inSession::Integer AND 4183126 <> inSession::Integer AND 235009  <> inSession::Integer AND 183242  <> inSession::Integer 
    THEN
      RAISE EXCEPTION '��������� <�������� ������> ��� ���������.';
    END IF;
            
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

     -- ���������
    PERFORM lpInsertUpdate_MovementItem_Sale (ioId                 := T.Id
                                            , inMovementId         := inId
                                            , inGoodsId            := T.GoodsId
                                            , inAmount             := T.Amount
                                            , inPrice              := ROUND( COALESCE(T.PriceSale,0) - (COALESCE(T.PriceSale,0)/100 * inChangePercent) ,2)
                                            , inPriceSale          := T.PriceSale
                                            , inChangePercent      := inChangePercent
                                            , inSumm               := ROUND(COALESCE(T.Amount,0) * COALESCE(ROUND( COALESCE(T.PriceSale,0) - (COALESCE(T.PriceSale,0)/100 * inChangePercent) ,2),0), 2)
                                            , inisSp               := COALESCE(T.IsSp,False) ::Boolean
                                            , inNDSKindId          := T.NDSKindId 
                                            , inUserId             := vbUserId
                                             )
    FROM gpSelect_MovementItem_Sale(inMovementId := inId  , inShowAll := False, inIsErased := False,  inSession := inSession) AS T;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_MovementItem_Sale_ChangePercent (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.12.22                                                       *               
*/

-- 
select * from gpUpdate_MovementItem_Sale_ChangePercent(inId := 540915992 , inChangePercent := 50.0 ,  inSession := '3');
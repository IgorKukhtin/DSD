DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_Site(Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_Site(
 INOUT ioId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    -- ������� ������� �� ��������� � ������
    IF (COALESCE(ioId,0) = 0)
       or
       (NOT EXISTS(SELECT 1 FROM MovementItem Where Id = ioId))       
    THEN
        SELECT 
            Id
        INTO 
            ioId
        FROM MovementItem
        WHERE MovementId = inMovementId 
          AND ObjectId = inGoodsId 
          AND DescId = zc_MI_Master();
    END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- ��������� �������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     
    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_Site(Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 17.12.2015                                                                      *
*/
-- Select * from gpInsertUpdate_MovementItem_Check_Site(ioId := 0, inMovementId := 506887, inGoodsId := 364, inAmount :=1::TFloat, inPrice := 1.0::TFloat, inSession := '3'::TVarChar)

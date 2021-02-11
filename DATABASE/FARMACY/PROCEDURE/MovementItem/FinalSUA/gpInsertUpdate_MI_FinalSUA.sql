-- Function: gpInsertUpdate_MI_FinalSUA()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_FinalSUA (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_FinalSUA(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;


     -- ���������
    ioId := lpInsertUpdate_MI_FinalSUA (ioId                 := ioId
                                     , inMovementId         := inMovementId
                                     , inGoodsId            := inGoodsId
                                     , inUnitId             := inUnitId
                                     , inAmount             := inAmount
                                     , inUserId             := vbUserId
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_FinalSUA (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 11.02.21                                                                      *
*/

-- ����
-- select * from gpInsertUpdate_MI_FinalSUA(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');
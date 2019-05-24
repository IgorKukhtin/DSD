-- Function: lpInsertUpdate_Movement_WeighingProduction _wms()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_WeighingProduction _wms (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_WeighingProduction _wms(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inStartWeighing       TDateTime , -- �������� ������ �����������
    IN inEndWeighing         TDateTime , -- �������� ���������  �����������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� �������� (�����������)
    IN inPlaceNumber         Integer   , -- ����� �������� �����
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN GoodsId               Integer   , -- 
    IN GoodsKindId           Integer   , -- 
    IN inUserId              Integer    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
BEGIN

     THEN
         -- ��������
         UPDATE Movement_WeighingProduction
                SET InvNumber            = inInvNumber
                  , OperDate             = inOperDate
                  , FromId               = inFromId
                  , ToId                 = inToId
                  , GoodsId              = inGoodsId
                  , GoodsKindId          = inGoodsKindId
                  , MovementDescId       = inMovementDescId
                  , MovementDescNumber   = inMovementDescNumber
                  , PlaceNumber          = inPlaceNumber
                  , UserId               = inUserId
                  , StartWeighing        = inStartWeighing
                  , EndWeighing          = inEndWeighing
         WHERE Movement_WeighingProduction.Id = ioId;

     -- ��������� ��������
     --PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.05.19         *
*/

-- ����
--
-- Function: gpInsertUpdate_Movement_WeighingProduction_wms()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction_wms (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction_wms (BigInt, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingProduction_wms(
 INOUT ioId                  BigInt    , -- ���� ������� <��������>
--  IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
--  IN inStartWeighing       TDateTime , -- �������� ������ �����������
--  IN inEndWeighing         TDateTime , -- �������� ���������  �����������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� �������� (�����������)
    IN inPlaceNumber         Integer   , -- ����� �������� �����
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inGoodsId             Integer   , -- 
    IN inGoodsKindId         Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS BigInt
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingProduction_wms());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.����� �� ���������.';
     END IF;
     -- ��������
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ �� ���������.';
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        -- ������� <��������>
        INSERT INTO Movement_WeighingProduction (InvNumber, OperDate, StatusId, FromId, ToId, GoodsId, GoodsKindId, MovementDescId, MovementDescNumber, PlaceNumber, UserId, StartWeighing, EndWeighing)
               VALUES (CAST (NEXTVAL ('Movement_WeighingProduction_wms_seq') AS TVarChar)
                     , inOperDate
                     , zc_Enum_Status_UnComplete()
                     , inFromId
                     , inToId
                     , inGoodsId
                     , inGoodsKindId
                     , inMovementDescId
                     , inMovementDescNumber
                     , inPlaceNumber
                     , vbUserId
                     , CURRENT_TIMESTAMP
                     , NULL
                      )
                 RETURNING Id INTO ioId;
     ELSE
        -- �������� <��������>
        UPDATE Movement_WeighingProduction
               SET OperDate             = inOperDate
              -- , InvNumber            = inInvNumber
                 , FromId               = inFromId
                 , ToId                 = inToId
                 , GoodsId              = inGoodsId
                 , GoodsKindId          = inGoodsKindId
                 , MovementDescId       = inMovementDescId
                 , MovementDescNumber   = inMovementDescNumber
                 , PlaceNumber          = inPlaceNumber
                 , UserId               = inUserId
              -- , StartWeighing        = inStartWeighing
              -- , EndWeighing          = inEndWeighing
         WHERE Id = ioId
           RETURNING StatusId INTO vbStatusId;
   
        --
        IF NOT FOUND
        THEN
            RAISE EXCEPTION '������.�� ������ ioId = <%>.', ioId;
        END IF;

        --
        IF vbStatusId <> zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
        END IF;
   
   
     END IF;

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.05.19                                        *
*/

-- ����
--
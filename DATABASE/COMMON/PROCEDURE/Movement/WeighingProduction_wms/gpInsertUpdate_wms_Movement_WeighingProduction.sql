-- Function: gpInsertUpdate_wms_Movement_WeighingProduction()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_wms_Movement_WeighingProduction (BigInt, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_wms_Movement_WeighingProduction (BigInt, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_wms_Movement_WeighingProduction(
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
    IN inGoodsTypeKindId_1   Integer   , -- ������� - 1-�� �����
    IN inGoodsTypeKindId_2   Integer   , -- ������� - 2-�� �����
    IN inGoodsTypeKindId_3   Integer   , -- ������� - 3-�� �����
    IN inBarCodeBoxId_1      Integer   , -- Id ��� �/� �����
    IN inBarCodeBoxId_2      Integer   , -- Id ��� �/� �����
    IN inBarCodeBoxId_3      Integer   , -- Id ��� �/� �����
    IN inGoodsId             Integer   , -- 
    IN inGoodsKindId         Integer   , -- 
    IN inGoodsId_sh          Integer   , -- 
    IN inGoodsKindId_sh      Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS BigInt
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_wms_Movement_WeighingProduction());
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
     -- ��������
     IF COALESCE (inGoodsTypeKindId_1, 0) = 0 OR COALESCE (inGoodsTypeKindId_2, 0) = 0 OR COALESCE (inGoodsTypeKindId_3, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� ������� �����: 1, 2 ��� 3.';
     END IF;
     -- ��������
     IF  (inGoodsTypeKindId_1 > 0 AND COALESCE (inBarCodeBoxId_1, 0) = 0)
      OR (inGoodsTypeKindId_2 > 0 AND COALESCE (inBarCodeBoxId_2, 0) = 0)
      OR (inGoodsTypeKindId_3 > 0 AND COALESCE (inBarCodeBoxId_3, 0) = 0)
     THEN
         RAISE EXCEPTION '������.�� ��������� ���� �/� �����. <>';
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        -- ������� <��������>
        INSERT INTO wms_Movement_WeighingProduction (InvNumber, OperDate, StatusId, FromId, ToId
                                                   , GoodsTypeKindId_1, GoodsTypeKindId_2, GoodsTypeKindId_3, BarCodeBoxId_1, BarCodeBoxId_2, BarCodeBoxId_3
                                                   , GoodsId, GoodsKindId, GoodsId_link_sh, GoodsKindId_link_sh, MovementDescId, MovementDescNumber, PlaceNumber, UserId, StartWeighing, EndWeighing
                                                    )
               VALUES (CAST (NEXTVAL ('wms_Movement_WeighingProduction_seq') AS TVarChar)
                     , inOperDate
                     , zc_Enum_Status_UnComplete()
                     , inFromId
                     , inToId
                     , inGoodsTypeKindId_1
                     , inGoodsTypeKindId_2
                     , inGoodsTypeKindId_3
                     , inBarCodeBoxId_1
                     , inBarCodeBoxId_2
                     , inBarCodeBoxId_3
                     , inGoodsId
                     , inGoodsKindId
                     , inGoodsId_sh
                     , inGoodsKindId_sh
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
        UPDATE wms_Movement_WeighingProduction
               SET OperDate             = inOperDate
              -- , InvNumber            = inInvNumber
                 , FromId               = inFromId
                 , ToId                 = inToId
                 , GoodsTypeKindId_1    = inGoodsTypeKindId_1
                 , GoodsTypeKindId_2    = inGoodsTypeKindId_2
                 , GoodsTypeKindId_3    = inGoodsTypeKindId_3
                 , BarCodeBoxId_1       = inBarCodeBoxId_1
                 , BarCodeBoxId_2       = inBarCodeBoxId_2
                 , BarCodeBoxId_3       = inBarCodeBoxId_3
                 , GoodsId              = inGoodsId
                 , GoodsKindId          = inGoodsKindId
                 , GoodsId_link_sh      = inGoodsId_sh
                 , GoodsKindId_link_sh  = inGoodsKindId_sh
                 , MovementDescId       = inMovementDescId
                 , MovementDescNumber   = inMovementDescNumber
                 , PlaceNumber          = inPlaceNumber
                 , UserId               = vbUserId
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
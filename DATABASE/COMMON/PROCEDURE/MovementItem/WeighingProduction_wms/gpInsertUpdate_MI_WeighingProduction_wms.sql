-- Function: gpInsertUpdate_MI_WeighingProduction_wms()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_WeighingProduction_wms (BigInt, BigInt, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_WeighingProduction_wms(
 INOUT ioId                  BigInt    , -- ���� ������� <������� ���������>
    IN inMovementId          BigInt    , -- ���� ������� <��������>
 -- IN inParentId            Integer   , -- 
    IN inGoodsTypeKindId     Integer   , -- 
    IN inBarCodeBoxId        Integer   , -- 
    IN inLineCode            Integer   , --
    IN inAmount              TFloat    , --
    IN inRealWeight          TFloat    , --
 -- IN inInsertDate          TDateTime , --
 -- IN inUpdateDate          TDateTime , --
    IN inWmsCode             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS BigInt
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingProduction_wms());
     vbUserId:= lpGetUserBySession (inSession);


     -- �����
     vbStatusId:= (SELECT Movement_WeighingProduction.StatusId FROM Movement_WeighingProduction WHERE Movement_WeighingProduction.Id = inMovementId);
     -- ��������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.'
                       , (SELECT Movement_WeighingProduction.InvNumber FROM Movement_WeighingProduction WHERE Movement_WeighingProduction.Id = inMovementId)
                       , lfGet_Object_ValueData (vbStatusId);
     END IF;
     
     -- ��������
     IF COALESCE (inGoodsTypeKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��������� ������ �� ����������.<%>', inGoodsTypeKindId;
     END IF;

     -- ��������
     IF COALESCE (inBarCodeBoxId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �/� ����� �� ���������.<%>', inBarCodeBoxId;
     END IF;

     -- ��������
     IF COALESCE (inLineCode, 0) NOT IN (1, 2, 3)
     THEN
         RAISE EXCEPTION '������.��� ����� (1,2 ��� 3) �� ���������.<%>', inLineCode;
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        -- �������
        INSERT INTO MI_WeighingProduction (MovementId, ParentId, GoodsTypeKindId, BarCodeBoxId, LineCode
                                         , Amount, RealWeight, InsertDate, UpdateDate, WmsCode, IsErased
                                          )
               VALUES (inMovementId
                     , NULL
                     , inGoodsTypeKindId
                     , inBarCodeBoxId
                     , inLineCode
                     , inAmount
                     , inRealWeight
                     , CURRENT_TIMESTAMP
                     , NULL
                     , inWmsCode
                     , FALSE
                      )
                 RETURNING Id INTO ioId;
     ELSE
        -- ��������
        UPDATE MI_WeighingProduction
                SET MovementId        = inMovementId
               -- , ParentId          = inParentId
                  , GoodsTypeKindId   = inGoodsTypeKindId
                  , BarCodeBoxId      = inBarCodeBoxId
                  , LineCode          = inLineCode
                  , Amount            = inAmount
                  , RealWeight        = inRealWeight
               -- , InsertDate        = inInsertDate
                  , UpdateDate        = CURRENT_TIMESTAMP
                  , WmsCode           = inWmsCode
        WHERE MI_WeighingProduction.Id = ioId;    
    
        --
        IF NOT FOUND
        THEN
            RAISE EXCEPTION '������.�� ������ ioId = <%>.', ioId;
        END IF;

     END IF;

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.05.19         *
*/

-- ����
--

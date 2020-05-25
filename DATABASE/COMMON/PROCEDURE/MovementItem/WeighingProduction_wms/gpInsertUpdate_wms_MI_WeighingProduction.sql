-- Function: gpInsertUpdate_wms_MI_WeighingProduction()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_wms_MI_WeighingProduction (BigInt, BigInt, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_wms_MI_WeighingProduction (BigInt, BigInt, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_wms_MI_WeighingProduction(
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
    IN inWmsBarCode          TVarChar  , --
    IN in_sku_id             TVarChar  , --
    IN in_sku_code           TVarChar  , --
    IN inPartionDate         TDateTime , --
    IN inIsErrSave           Boolean   , -- �����, ����� �������� �� ������ ��� � ���� ��������� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS BigInt
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbParentId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_wms_MI_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);


     -- �����
     vbStatusId:= (SELECT wms_Movement_WeighingProduction.StatusId FROM wms_Movement_WeighingProduction WHERE wms_Movement_WeighingProduction.Id = inMovementId);
     -- ��������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.'
                       , (SELECT wms_Movement_WeighingProduction.InvNumber FROM wms_Movement_WeighingProduction WHERE wms_Movement_WeighingProduction.Id = inMovementId)
                       , lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- ��������
     IF COALESCE (inGoodsTypeKindId, 0) = 0 AND inIsErrSave = FALSE
     THEN
         RAISE EXCEPTION '������.��������� ������ �� ����������.<%>', inGoodsTypeKindId;
     END IF;

     -- ��������
     IF COALESCE (inBarCodeBoxId, 0) = 0 AND inIsErrSave = FALSE
     THEN
         RAISE EXCEPTION '������. �/� ����� �� ���������.<%>', inBarCodeBoxId;
     END IF;

     -- ��������
     IF COALESCE (inLineCode, 0) NOT IN (1, 2, 3) AND inIsErrSave = FALSE
     THEN
         RAISE EXCEPTION '������.��� ����� (1,2 ��� 3) �� ���������.<%>', inLineCode;
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        -- �������
        INSERT INTO wms_MI_WeighingProduction (MovementId, ParentId, GoodsTypeKindId, BarCodeBoxId, LineCode
                                             , Amount, RealWeight, InsertDate, UpdateDate
                                             , WmsCode, sku_id, sku_code
                                             , PartionDate
                                             , StatusId_wms
                                             , IsErased
                                              )
               VALUES (inMovementId
                     , NULL
                     , COALESCE (inGoodsTypeKindId, 0)
                     , COALESCE (inBarCodeBoxId, 0)
                     , COALESCE (inLineCode, 0)
                     , inAmount
                     , inRealWeight
                     , CURRENT_TIMESTAMP
                     , NULL
                     , COALESCE (inWmsBarCode, '')
                     , COALESCE (in_sku_id, '')
                     , COALESCE (in_sku_code, '')
                     , inPartionDate
                     , NULL
                     , CASE WHEN inIsErrSave = TRUE THEN TRUE ELSE FALSE END
                      )
                 RETURNING Id INTO ioId;
     ELSE
        -- ��������
        UPDATE wms_MI_WeighingProduction
                SET MovementId        = inMovementId
               -- , ParentId          = inParentId
                  , GoodsTypeKindId   = inGoodsTypeKindId
                  , BarCodeBoxId      = inBarCodeBoxId
                  , LineCode          = inLineCode
                  , Amount            = inAmount
                  , RealWeight        = inRealWeight
               -- , InsertDate        = inInsertDate
                  , UpdateDate        = CURRENT_TIMESTAMP
                  , WmsCode           = inWmsBarCode
                  , sku_id            = in_sku_id
                  , sku_code          = in_sku_code
                  , PartionDate       = inPartionDate
                  , StatusId_wms      = NULL
        WHERE wms_MI_WeighingProduction.Id = ioId RETURNING ParentId INTO vbParentId;

        --
        IF NOT FOUND
        THEN
            RAISE EXCEPTION '������.�� ������ ioId = <%>.', ioId;
        END IF;

        -- ��������
        IF COALESCE (vbParentId, 0) > 0
        THEN
            RAISE EXCEPTION '������.���� ��� ������.��������� ����������.';
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

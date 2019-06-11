-- Function: lpInsertUpdate_MI_WeighingProduction_wms()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_WeighingProduction_wms (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_WeighingProduction_wms (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_WeighingProduction_wms(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- 
    IN inGoodsTypeKindId     Integer   , -- 
    IN inBarCodeBoxId        Integer   , -- 
    IN inLineCode            Integer   , --
    IN inDateInsert          TDateTime , --
    IN inDateUpdate          TDateTime , --
    IN inAmount              TFloat    , --
    IN inRealWeight          TFloat    , --
    IN inWmsCode             TVarChar  , --
    IN inUserId              Integer    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

         -- ��������
         UPDATE MI_WeighingProduction
                SET MovementId        = inMovementId
                  , ParentId          = inParentId
                  , GoodsTypeKindId   = inGoodsTypeKindId
                  , BarCodeBoxId      = inBarCodeBoxId
                  , LineCode          = inLineCode
                  , DateInsert        = inDateInsert
                  , DateUpdate        = inDateUpdate
                  , Amount            = inAmount
                  , RealWeight        = inRealWeight
                  , WmsCode           = inWmsCode
         WHERE MI_WeighingProduction.Id = ioId;    
    
     -- ��������� ��������
     --PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

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
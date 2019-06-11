-- Function: gpInsert_ScaleLight_MI()

DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleLight_MI(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- 
    IN inGoodsKindId         Integer   , -- 
    IN inMeasureId           Integer   , -- 

    IN inWmsCode_Sh          TVarChar  , -- ��� ��� - ��.
    IN inWmsCode_Nom         TVarChar  , -- ��� ��� - ���.
    IN inWmsCode_Ves         TVarChar  , -- ��� ��� - ���

    IN inGoodsTypeKindId_Sh  Integer   , -- Id - ���� �� ��.
    IN inGoodsTypeKindId_Nom Integer   , -- Id - ���� �� ���.
    IN inGoodsTypeKindId_Ves Integer   , -- Id - ���� �� ���
    -- 1-�� ����� - ������ ���� ����
    IN inGoodsTypeKindId_1   Integer   , -- ��������� ��� ��� ����� �����
    IN inBarCodeBoxId_1      Integer   , -- Id ��� �/� �����
    IN inLineCode_1          Integer   , -- ��� ����� = 1,2 ��� 3
    IN inWeightOnBox_1       Integer   , -- ����������� - ���
    IN inCountOnBox_1        Integer   , -- ����������� - �� (������������?)
    -- 1-�� ����� - ������ ���� ����
    IN inGoodsTypeKindId_2   Integer   , -- ��������� ��� ��� ����� �����
    IN inBarCodeBoxId_2      Integer   , -- Id ��� �/� �����
    IN inLineCode_2          Integer   , -- ��� ����� = 1,2 ��� 3
    -- 1-�� ����� - ������ ���� ����
    IN inGoodsTypeKindId_3   Integer   , -- ��������� ��� ��� ����� �����
    IN inBarCodeBoxId_3      Integer   , -- Id ��� �/� �����
    IN inLineCode_3          Integer   , -- ��� ����� = 1,2 ��� 3

    IN inWeightMin           TFloat    , -- ����������� ��� 1��.
    IN inWeightMax           TFloat    , -- ������������ ��� 1��.

    IN inAmount              TFloat    , -- ���-��, ��� ������� = 1
    IN inRealWeight          TFloat    , -- ���

    IN inBranchCode          Integer   , -- 

    IN inSession             TVarChar    -- ������ ������������
)                              

RETURNS TABLE (Id              Integer   -- Id ������������ ��������
             , GoodsTypeKindId Integer   -- ��� = ��. ��� ���. ��� ���
             , BarCodeBoxId    Integer   -- Id ��� �/� �����
             , LineCode        Integer   -- ��� ����� = 1,2 ��� 3
             , WmsCode         TVarChar  -- �/� ��� ���: 3(1)+���(3)+WmsCode(4)+���(4)+�����������(1)
             , isFull          Boolean   -- ���� ��������
              )
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE vbGoodsTypeKindId  Integer;
   DECLARE vbBarCodeBoxId     Integer;
   DECLARE vbLineCode         Integer;
   DECLARE vbWmsCode          TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);



     IF inMeasureId = zc_Measure_Sh() OR inGoodsTypeKindId_Sh > 0
     THEN
         -- ���� ��� ��.
         IF inRealWeight BETWEEN (inWeightMin + inWeightMax) / 2 - 0.002  AND (inWeightMin + inWeightMax) / 2 + 0.002
         THEN
             -- ��� ��.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Sh;
             -- 13-�����. �/�.
                 vbWmsCode     := '3' || 

             -- ����� �� ����� ��� �����
             IF inGoodsTypeKindId_1 = inGoodsTypeKindId_Sh
             THEN
                 vbBarCodeBoxId:= inBarCodeBoxId_1;
                 vbLineCode    := inLineCode_1;

             ELSEIF inGoodsTypeKindId_2 = inGoodsTypeKindId_Sh
             THEN
             ELSE
                 RAISE EXCEPTION '������. �� ���������� <��.> ��� <���.> ��� <���>', ;
             END IF;
             
         END IF;

     ELSE
     END IF;
     
     
     -- ���������
     vbId:= gpInsertUpdate_MI_WeighingProduction_wms (ioId                  := 0
                                                    , inMovementId          := inMovementId
                                                    , inGoodsTypeKindId     := vbGoodsTypeKindId
                                                    , inBarCodeBoxId        := vbBarCodeBoxId
                                                    , inLineCode            := vbLineCode
                                                    , inAmount              := inAmount
                                                    , inRealWeight          := inRealWeight
                                                    , inWmsCode             := vbWmsCode
                                                    , inSession             := inSession
                                                     );




     -- ���������
     RETURN QUERY
       SELECT vbId
            , vbGoodsTypeKindId
            , vbBarCodeBoxId
            , vbLineCode
            , vbWmsCode
            , FALSE AS isFull
              ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsert_ScaleLight_MI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')

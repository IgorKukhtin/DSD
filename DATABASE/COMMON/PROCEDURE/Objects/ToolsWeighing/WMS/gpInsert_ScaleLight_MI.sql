-- Function: gpInsert_ScaleLight_MI()

DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (BigInt, BigInt, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleLight_MI(
 -- IN inId                  BigInt    , -- ���� ������� <������� ���������>
 -- IN inMovementId          BigInt    , -- ���� ������� <��������>
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
    IN inWeightOnBox_1       TFloat    , -- ����������� - ���
    IN inCountOnBox_1        TFloat    , -- ����������� - �� (������������?)
    -- 2-�� ����� - ������ ���� ����
    IN inGoodsTypeKindId_2   Integer   , -- ��������� ��� ��� ����� �����
    IN inBarCodeBoxId_2      Integer   , -- Id ��� �/� �����
    IN inLineCode_2          Integer   , -- ��� ����� = 1,2 ��� 3
    IN inWeightOnBox_2       TFloat    , -- ����������� - ���
    IN inCountOnBox_2        TFloat    , -- ����������� - �� (������������?)
    -- 1-�� ����� - ������ ���� ����
    IN inGoodsTypeKindId_3   Integer   , -- ��������� ��� ��� ����� �����
    IN inBarCodeBoxId_3      Integer   , -- Id ��� �/� �����
    IN inLineCode_3          Integer   , -- ��� ����� = 1,2 ��� 3
    IN inWeightOnBox_3       TFloat    , -- ����������� - ���
    IN inCountOnBox_3        TFloat    , -- ����������� - �� (������������?)

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
   DECLARE vbId               Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbDay              TVarChar;
   DECLARE vbW_1              TVarChar;
   DECLARE vbW_3              TVarChar;
   DECLARE vbGoodsTypeKindId  Integer;
   DECLARE vbBarCodeBoxId     Integer;
   DECLARE vbLineCode         Integer;
   DECLARE vbWmsCode          TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);


     -- �������� - ��� �� 10 ��.
     IF FLOOR (inRealWeight) >= 10
     THEN
         RAISE EXCEPTION '������.��� = <%> �� ������ ���� ������ 9.999 ��.', inRealWeight;
     END IF;
     -- �������� - ��� ������ 0.010 ��.
     IF FLOOR (inRealWeight) <= 0.010
     THEN
         RAISE EXCEPTION '������.��� = <%> ������ ���� ������ 0.010 ��.', inRealWeight;
     END IF;

     -- ����� ���� ������
     vbOperDate:= (SELECT Movement.OperDate FROM Movement_WeighingProduction AS Movement WHERE Movement.Id = inMovementId);
     
     -- ������� ����
     vbDay:= (1 + EXTRACT (DAY FROM (vbOperDate - DATE_TRUNC ('YEAR', vbOperDate)) :: INTERVAL)) :: TVarChar;
     vbDay:= REPEAT ('0', 3 - LENGTH (vbDay)) || vbDay;
     -- ��� - ��
     vbW_1:= (FLOOR (inRealWeight) :: Integer) :: TVarChar;
     -- ��� - ��.
     vbW_3:= (FLOOR (MOD (inRealWeight, 1) * 1000) :: Integer) :: TVarChar;
     
     -- ������� � 4-� ��������
     inWmsCode_Sh := REPEAT ('0', 4 - LENGTH (inWmsCode_Sh))  || inWmsCode_Sh;
     inWmsCode_Nom:= REPEAT ('0', 4 - LENGTH (inWmsCode_Nom)) || inWmsCode_Nom;
     inWmsCode_Ves:= REPEAT ('0', 4 - LENGTH (inWmsCode_Ves)) || inWmsCode_Ves;


         -- 1.1. ���� ������ � ��� ��� ��.
         IF ((inRealWeight BETWEEN (inWeightMin + inWeightMax) / 2 - 0.002 AND (inWeightMin + inWeightMax) / 2 + 0.002)
         -- ��� �������� ������ ��.
         OR (COALESCE (inGoodsTypeKindId_Nom, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
            )
         -- � �������� ��.
         AND inGoodsTypeKindId_Sh > 0
         THEN
             -- ��� ��.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Sh;
             -- 12-�����. �/� ��� ���: 3(1)+���(3)+WmsCode(4)+���(4)+�����������(1)
             vbWmsCode := '3' || vbDay || inWmsCode_Sh || vbW_1 || vbW_3;
             -- 13-�����. �/� ��� ���: +�����������(1)
             vbWmsCode := vbWmsCode || zfCalc_SummBarCode(vbWmsCode) :: TVarChar;

             -- ����� �� ����� ��� �����
             IF inGoodsTypeKindId_1 = inGoodsTypeKindId_Sh
             THEN
                 -- 1
                 vbBarCodeBoxId:= inBarCodeBoxId_1;
                 vbLineCode    := inLineCode_1;

             ELSEIF inGoodsTypeKindId_2 = inGoodsTypeKindId_Sh
             THEN
                 -- 2
                 vbBarCodeBoxId:= inBarCodeBoxId_2;
                 vbLineCode    := inLineCode_2;

             ELSEIF inGoodsTypeKindId_3 = inGoodsTypeKindId_Sh
             THEN
                 -- 3
                 vbBarCodeBoxId:= inBarCodeBoxId_3;
                 vbLineCode    := inLineCode_3;

             ELSE
                 RAISE EXCEPTION '������. �� ���������� <��.> ��� <���.> ��� <���>';
             END IF;
             

         -- 1.2. ���� ������ � ��� ��� ���.
         ELSEIF((inRealWeight BETWEEN inWeightMin AND inWeightMax)
             -- ��� �������� ������ ���.
             OR (COALESCE (inGoodsTypeKindId_Sh, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
               )
             -- � �������� ���.
             AND inGoodsTypeKindId_Nom > 0
         THEN
             -- ��� ���.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Nom;
             -- 12-�����. �/� ��� ���: 3(1)+���(3)+WmsCode(4)+���(4)+�����������(1)
             vbWmsCode := '3' || vbDay || inWmsCode_Nom || vbW_1 || vbW_3;
             -- 13-�����. �/� ��� ���: +�����������(1)
             vbWmsCode := vbWmsCode || zfCalc_SummBarCode(vbWmsCode) :: TVarChar;

             -- ����� �� ����� ��� �����
             IF inGoodsTypeKindId_1 = inGoodsTypeKindId_Nom
             THEN
                 -- 1
                 vbBarCodeBoxId:= inBarCodeBoxId_1;
                 vbLineCode    := inLineCode_1;

             ELSEIF inGoodsTypeKindId_2 = inGoodsTypeKindId_Nom
             THEN
                 -- 2
                 vbBarCodeBoxId:= inBarCodeBoxId_2;
                 vbLineCode    := inLineCode_2;

             ELSEIF inGoodsTypeKindId_3 = inGoodsTypeKindId_Nom
             THEN
                 -- 3
                 vbBarCodeBoxId:= inBarCodeBoxId_3;
                 vbLineCode    := inLineCode_3;

             ELSE
                 RAISE EXCEPTION '������. �� ���������� <��.> ��� <���.> ��� <���>';
             END IF;


         -- 1.3. ���� �������� ���
         ELSEIF inGoodsTypeKindId_Ves > 0
         THEN
             -- ��� Ves.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Ves;
             -- 12-�����. �/� ��� ���: 3(1)+���(3)+WmsCode(4)+���(4)+�����������(1)
             vbWmsCode := '3' || vbDay || inWmsCode_Ves || vbW_1 || vbW_3;
             -- 13-�����. �/� ��� ���: +�����������(1)
             vbWmsCode := vbWmsCode || zfCalc_SummBarCode(vbWmsCode) :: TVarChar;

             -- ����� �� ����� ��� �����
             IF inGoodsTypeKindId_1 = inGoodsTypeKindId_Ves
             THEN
                 -- 1
                 vbBarCodeBoxId:= inBarCodeBoxId_1;
                 vbLineCode    := inLineCode_1;

             ELSEIF inGoodsTypeKindId_2 = inGoodsTypeKindId_Ves
             THEN
                 -- 2
                 vbBarCodeBoxId:= inBarCodeBoxId_2;
                 vbLineCode    := inLineCode_2;

             ELSEIF inGoodsTypeKindId_3 = inGoodsTypeKindId_Ves
             THEN
                 -- 3
                 vbBarCodeBoxId:= inBarCodeBoxId_3;
                 vbLineCode    := inLineCode_3;

             ELSE
                 RAISE EXCEPTION '������. �� ���������� <��.> ��� <���.> ��� <���>';
             END IF;
             

         -- 1.4. 
         ELSE
             RAISE EXCEPTION '������.��� ���� <% ��.> �� ���������� <��.> ��� <���.> ��� <���>', inRealWeight;
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

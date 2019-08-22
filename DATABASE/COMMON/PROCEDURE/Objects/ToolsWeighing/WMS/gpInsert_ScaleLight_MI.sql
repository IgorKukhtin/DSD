-- Function: gpInsert_ScaleLight_MI()

DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (BigInt, BigInt, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

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
             , isFull_1        Boolean   -- ����_1 ��������
             , isFull_2        Boolean   -- ����_2 ��������
             , isFull_3        Boolean   -- ����_3 ��������
             , WeightOnBox     TFloat
             , CountOnBox      TFloat
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
   DECLARE vbWmsBarCode       TVarChar;
   DECLARE vb_sku_id          TVarChar;
   DECLARE vb_sku_code        TVarChar;
   DECLARE vbIsFull           Boolean;
   DECLARE vbWeightOnBox      TFloat;   -- ���� - ���
   DECLARE vbCountOnBox       TFloat;   -- ���� - �� (������������?)
   DECLARE vbMovementId       Integer;  -- �������� zc_Movement_WeighingProduction
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
     -- ������� � 3-� ��������
     vbDay:= REPEAT ('0', 3 - LENGTH (vbDay)) || vbDay;
     -- ��� - ��
     vbW_1:= (FLOOR (inRealWeight) :: Integer) :: TVarChar;
     -- ������� � 1-�� �������
     IF LENGTH (vbW_1) <> 1 THEN vbW_1:= SUBSTRING(vbW_1, LENGTH (vbW_1), 1); vbW_1 := REPEAT ('0', 1 - LENGTH (vbW_1)); END IF;
     -- ��� - ��.
     vbW_3:= (FLOOR (MOD (inRealWeight, 1) * 1000) :: Integer) :: TVarChar;
     -- ������� � 3-� ��������
     vbW_3 := REPEAT ('0', 3 - LENGTH (vbW_3)) || vbW_3;
     
     -- ������� � 4-� ��������
     inWmsCode_Sh := REPEAT ('0', 4 - LENGTH (inWmsCode_Sh))  || inWmsCode_Sh;
     inWmsCode_Nom:= REPEAT ('0', 4 - LENGTH (inWmsCode_Nom)) || inWmsCode_Nom;
     inWmsCode_Ves:= REPEAT ('0', 4 - LENGTH (inWmsCode_Ves)) || inWmsCode_Ves;


         -- 1.1. ���� ������ � ��� ��� ��.
         IF ((inRealWeight BETWEEN (inWeightMin + inWeightMax) / 2 - 0.002 AND (inWeightMin + inWeightMax) / 2 + 0.002)
         -- ��� �������� ������ ��.
         OR (COALESCE (inGoodsTypeKindId_Nom, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
      -- OR 1=1
            )
         -- � �������� ��.
         AND inGoodsTypeKindId_Sh > 0
         THEN
             -- ��� ��.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Sh;
             -- Id ��� + ��� ���
             SELECT tmp.sku_id_Sh, tmp.sku_code_Sh
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_Object_GoodsByGoodsKind_wms (inGoodsId, inGoodsKindId, inSession) AS tmp;
             -- 12-�����. �/� ��� ���: 3(1)+���(3)+WmsCode(4)+���(4)+�����������(1)
             vbWmsBarCode:= '3' || vbDay || inWmsCode_Sh || vbW_1 || vbW_3;
             -- 13-�����. �/� ��� ���: +�����������(1)
             vbWmsBarCode:= vbWmsBarCode || zfCalc_SummBarCode (vbWmsBarCode) :: TVarChar;

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
          -- OR 1=1
               )
             -- � �������� ���.
             AND inGoodsTypeKindId_Nom > 0
         THEN
             -- ��� ���.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Nom;
             -- Id ��� + ��� ���
             SELECT tmp.sku_id_Nom, tmp.sku_code_Nom
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_Object_GoodsByGoodsKind_wms (inGoodsId, inGoodsKindId, inSession) AS tmp;
             -- 12-�����. �/� ��� ���: 3(1)+���(3)+WmsCode(4)+���(4)+�����������(1)
             vbWmsBarCode := '3' || vbDay || inWmsCode_Nom || vbW_1 || vbW_3;
             -- 13-�����. �/� ��� ���: +�����������(1)
             vbWmsBarCode := vbWmsBarCode || zfCalc_SummBarCode (vbWmsBarCode) :: TVarChar;

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
             -- Id ��� + ��� ���
             SELECT tmp.sku_id_Ves, tmp.sku_code_Ves
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_Object_GoodsByGoodsKind_wms (inGoodsId, inGoodsKindId, inSession) AS tmp;
             -- 12-�����. �/� ��� ���: 3(1)+���(3)+WmsCode(4)+���(4)+�����������(1)
             vbWmsBarCode := '3' || vbDay || inWmsCode_Ves || vbW_1 || vbW_3;
             -- 13-�����. �/� ��� ���: +�����������(1)
             vbWmsBarCode := vbWmsBarCode || zfCalc_SummBarCode (vbWmsBarCode) :: TVarChar;

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
                                                    , inWmsBarCode          := vbWmsBarCode
                                                    , in_sku_id             := vb_sku_id
                                                    , in_sku_code           := vb_sku_code
                                                    , inPartionDate         := vbOperDate
                                                    , inSession             := inSession
                                                     );

     -- ���� - ��� + �� (������������?)
     SELECT SUM (MovementItem.RealWeight)
          , SUM (MovementItem.Amount)
            INTO vbWeightOnBox, vbCountOnBox
     FROM MI_WeighingProduction AS MovementItem
     WHERE MovementItem.MovementId      = inMovementId
       AND MovementItem.isErased        = FALSE
       AND MovementItem.ParentId        IS NULL
       AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
       AND MovementItem.BarCodeBoxId    = vbBarCodeBoxId
            ;


     -- ���� ��� �������� >= ����������� - ���
     vbIsFull:= CASE WHEN vbWeightOnBox >= CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                                THEN inWeightOnBox_1 -- ����������� - 1
                                                WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                                THEN inWeightOnBox_2 -- ����������� - 2
                                                WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                                THEN inWeightOnBox_3 -- ����������� - 3
                                           END
                     THEN TRUE
                     ELSE FALSE
                END;
     
     -- !!!���� ���� ������� ���� ����!!!
     IF vbIsFull = TRUE
     THEN
         -- ������� �������� zc_Movement_WeighingProduction
         vbMovementId:= gpInsertUpdate_Movement_WeighingProduction (ioId                  := 0
                                                                  , inOperDate            := Movement.OperDate
                                                                  , inMovementDescId      := Movement.MovementDescId
                                                                  , inMovementDescNumber  := Movement.MovementDescNumber
                                                                  , inWeighingNumber      := 1 + COALESCE ((SELECT COUNT(*)
                                                                                                            FROM MI_WeighingProduction AS MovementItem
                                                                                                            WHERE MovementItem.MovementId      = inMovementId
                                                                                                              AND MovementItem.isErased        = FALSE
                                                                                                              AND MovementItem.ParentId        > 0
                                                                                                              AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
                                                                                                           )
                                                                                                         , 0) :: Integer
                                                                  , inFromId              := Movement.FromId
                                                                  , inToId                := Movement.ToId
                                                                  , inDocumentKindId      := 0
                                                                  , inPartionGoods        := ''
                                                                  , inIsProductionIn      := FALSE
                                                                  , inSession             := inSession
                                                                   )
         FROM Movement_WeighingProduction AS Movement WHERE Movement.Id = inMovementId;

         -- � �������� ��� ��������� <��������� ������ (�����)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsTypeKind(), vbMovementId, vbGoodsTypeKindId);
         -- � �������� ��� ��������� <�/� ����� (�����)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BarCodeBox(), vbMovementId, vbBarCodeBoxId);
    

         -- �������� ������� - zc_MI_Master
         PERFORM gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                               , inMovementId          := vbMovementId
                                                               , inGoodsId             := Movement.GoodsId
                                                               , inAmount              := CASE WHEN inMeasureId = zc_Measure_Sh() THEN Movement.Amount ELSE Movement.RealWeight END
                                                               , inIsStartWeighing     := FALSE
                                                               , inRealWeight          := Movement.RealWeight
                                                               , inWeightTare          := 0
                                                               , inLiveWeight          := 0
                                                               , inHeadCount           := 0
                                                               , inCount               := 0
                                                               , inCountPack           := Movement.Amount
                                                               , inCountSkewer1        := 0
                                                               , inWeightSkewer1       := 0
                                                               , inCountSkewer2        := 0
                                                               , inWeightSkewer2       := 0
                                                               , inWeightOther         := 0
                                                               , inPartionGoodsDate    := NULL
                                                               , inPartionGoods        := ''
                                                               , inMovementItemId      := 0
                                                               , inGoodsKindId         := Movement.GoodsKindId
                                                               , inStorageLineId       := NULL
                                                               , inSession             := inSession
                                                                )
         FROM (SELECT Movement.GoodsId, Movement.GoodsKindId
                    , SUM (MovementItem.RealWeight) AS RealWeight
                    , SUM (MovementItem.Amount)     AS Amount
               FROM Movement_WeighingProduction AS Movement
                    INNER JOIN MI_WeighingProduction AS MovementItem
                                                     ON MovementItem.MovementId      = Movement.Id
                                                    AND MovementItem.isErased        = FALSE
                                                    AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
                                                    AND MovementItem.BarCodeBoxId    = vbBarCodeBoxId
                                                    AND MovementItem.ParentId        IS NULL
               WHERE Movement.Id = inMovementId
               GROUP BY Movement.GoodsId, Movement.GoodsKindId
              ) AS Movement;



         -- �������� ���� �� ����� - �/� ��� �����
         UPDATE Movement_WeighingProduction SET BarCodeBoxId_1 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                                                           THEN 0
                                                                      ELSE Movement_WeighingProduction.BarCodeBoxId_1
                                                                 END
                                              , BarCodeBoxId_2 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                                                           THEN 0
                                                                      ELSE Movement_WeighingProduction.BarCodeBoxId_2
                                                                 END
                                              , BarCodeBoxId_3 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                                                           THEN 0
                                                                      ELSE Movement_WeighingProduction.BarCodeBoxId_3
                                                                 END
         WHERE Movement_WeighingProduction.Id = inMovementId
        ;

         -- ��������� ��� 1 ���� ������
         UPDATE MI_WeighingProduction SET ParentId = vbMovementId
         WHERE MI_WeighingProduction.MovementId      = inMovementId
        -- AND MI_WeighingProduction.isErased        = FALSE
           AND MI_WeighingProduction.ParentId        IS NULL
           AND MI_WeighingProduction.GoodsTypeKindId = vbGoodsTypeKindId
           AND MI_WeighingProduction.BarCodeBoxId    = vbBarCodeBoxId
        ;

     END IF;

     -- ���������
     RETURN QUERY
       SELECT vbId
            , vbGoodsTypeKindId
            , vbBarCodeBoxId
            , vbLineCode
            , vbWmsBarCode
            , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1 THEN vbIsFull ELSE FALSE END :: Boolean AS isFull_1
            , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2 THEN vbIsFull ELSE FALSE END :: Boolean AS isFull_2
            , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3 THEN vbIsFull ELSE FALSE END :: Boolean AS isFull_3
            , vbWeightOnBox AS WeightOnBox
            , vbCountOnBox  AS CountOnBox
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

-- Function: gpInsert_ScaleLight_MI()

-- DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (BigInt, BigInt, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleLight_MI(
 -- IN inId                  BigInt    , -- ���� ������� <������� ���������>
 -- IN inMovementId          BigInt    , -- ���� ������� <��������>
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , --
    IN inGoodsKindId         Integer   , --
    IN inGoodsId_sh          Integer   , --
    IN inGoodsKindId_sh      Integer   , --
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
    IN inWeightOnBox_1       TFloat    , -- ����������� �� ���� - !�������!
    IN inCountOnBox_1        TFloat    , -- ����������� - �� (�� ������������!)
    -- 2-�� ����� - ������ ���� ����
    IN inGoodsTypeKindId_2   Integer   , -- ��������� ��� ��� ����� �����
    IN inBarCodeBoxId_2      Integer   , -- Id ��� �/� �����
    IN inLineCode_2          Integer   , -- ��� ����� = 1,2 ��� 3
    IN inWeightOnBox_2       TFloat    , -- ����������� �� ���� - !�������!
    IN inCountOnBox_2        TFloat    , -- ����������� - �� (�� ������������!)
    -- 3-�� ����� - ������ ���� ����
    IN inGoodsTypeKindId_3   Integer   , -- ��������� ��� ��� ����� �����
    IN inBarCodeBoxId_3      Integer   , -- Id ��� �/� �����
    IN inLineCode_3          Integer   , -- ��� ����� = 1,2 ��� 3
    IN inWeightOnBox_3       TFloat    , -- ����������� �� ���� - !�������!
    IN inCountOnBox_3        TFloat    , -- ����������� - �� (�� ������������!)

    IN inWeightMin           TFloat    , -- ����������� ��� 1��. - !!!��������
    IN inWeightMax           TFloat    , -- ������������ ��� 1��.- !!!��������

    IN inWeightMin_Sh        TFloat    , -- ����������� ��� 1��.
    IN inWeightMin_Nom       TFloat    , --
    IN inWeightMin_Ves       TFloat    , --
    IN inWeightMax_Sh        TFloat    , -- ������������ ��� 1��.
    IN inWeightMax_Nom       TFloat    , --
    IN inWeightMax_Ves       TFloat    , --

    IN inAmount              TFloat    , -- ���-��, ��� ������� = 1
    IN inRealWeight          TFloat    , -- ���

    IN inBranchCode          Integer   , --

    IN inIsErrSave           Boolean   , -- �����, ����� �������� �� ������ ��� � ���� ��������� ������

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
             , ResultText      Text      -- ������
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
   DECLARE vbCountOnBox       TFloat;   -- ���� - �� (�� ������������!)
   DECLARE vbMovementId       Integer;  -- �������� zc_Movement_WeighingProduction
   DECLARE vbResultText       Text;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);


/* if vbUserId = 5
 then
 RAISE EXCEPTION '������.ok  %  %' ,
      inWeightMin_Sh       ,
     , CHR (13), vbResultText
;
 end if;*/

     -- ���� ��� ������
     vbResultText:= '';


     -- �������� - ��� �� 10 ��.
     IF FLOOR (inRealWeight) >= 10
     THEN
       --RAISE EXCEPTION '������.��� = <%> �� ������ ���� ������ 9.999 ��.', inRealWeight;
         vbResultText:= '������.��� = <' || zfConvert_FloatToString (inRealWeight) || '> �� ������ ���� ������ 9.999 ��.';
         -- IF inIsErrSave = FALSE THEN RETURN; END IF;
     END IF;
     -- �������� - ��� ������ 0.010 ��.
     IF inRealWeight <= 0.050
     THEN
       --RAISE EXCEPTION '������.��� = <%> ������ ���� ������ 0.050 ��.', inRealWeight;
         vbResultText:= '������.��� = <' || zfConvert_FloatToString (inRealWeight) || '> �� ������ ���� ������ 0.050 ��.';
         -- IF inIsErrSave = FALSE THEN RETURN; END IF;
     END IF;


     -- ����� ���� ������
     vbOperDate:= (SELECT Movement.OperDate FROM wms_Movement_WeighingProduction AS Movement WHERE Movement.Id = inMovementId);

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


         -- 1.1. ���� �������� ��.
         IF inGoodsTypeKindId_Sh > 0
            -- � ���� ������ � ��� ��� ��.
        AND inRealWeight BETWEEN inWeightMin_Sh AND inWeightMax_Sh
      /*AND ((inRealWeight BETWEEN (inWeightMin + inWeightMax) / 2 - 0.002 AND (inWeightMin + inWeightMax) / 2 + 0.002)
         -- ��� �������� ������ ��.
         OR (COALESCE (inGoodsTypeKindId_Nom, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
      -- OR 1=1
            )*/
         THEN
             -- ��� ��.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Sh;
             -- Id ��� + ��� ���
             SELECT tmp.sku_id_Sh, tmp.sku_code_Sh
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_wms_Object_GoodsByGoodsKind (CASE WHEN inGoodsId_sh > 0 THEN inGoodsId_sh ELSE inGoodsId END, CASE WHEN inGoodsKindId_sh > 0 THEN inGoodsKindId_sh ELSE inGoodsKindId END, inSession) AS tmp;
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
               --RAISE EXCEPTION '������. �� ���������� <��.> ��� <���.> ��� <���>';
                 vbResultText:= '������.�� ���������� ����� ��� <��.> ��� <���.> ��� <���>';
                 -- IF inIsErrSave = FALSE THEN RETURN; END IF;
             END IF;


         -- 1.2. ���� �������� ���.
         ELSEIF inGoodsTypeKindId_Nom > 0
                -- � ���� ������ � ��� ��� ���.
            AND inRealWeight BETWEEN inWeightMin_Nom AND inWeightMax_Nom
          /*AND ((inRealWeight BETWEEN inWeightMin AND inWeightMax)
              -- ��� �������� ������ ���.
              OR (COALESCE (inGoodsTypeKindId_Sh, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
           -- OR 1=1
                )*/
         THEN
             -- ��� ���.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Nom;
             -- Id ��� + ��� ���
             SELECT tmp.sku_id_Nom, tmp.sku_code_Nom
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_wms_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inSession) AS tmp;
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
               --RAISE EXCEPTION '������. �� ���������� <��.> ��� <���.> ��� <���>';
                 vbResultText:= '������.�� ���������� ����� ��� <��.> ��� <���.> ��� <���>';
                 -- IF inIsErrSave = FALSE THEN RETURN; END IF;
             END IF;


         -- 1.3. ���� �������� ���
         ELSEIF inGoodsTypeKindId_Ves > 0
                -- � ���� ������ � ��� ��� ���.
            AND inRealWeight BETWEEN inWeightMin_Ves AND inWeightMax_Ves
         THEN
             -- ��� Ves.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Ves;
             -- Id ��� + ��� ���
             SELECT tmp.sku_id_Ves, tmp.sku_code_Ves
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_wms_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inSession) AS tmp;
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
               --RAISE EXCEPTION '������. �� ���������� <��.> ��� <���.> ��� <���>';
                 vbResultText:= '������.�� ���������� ����� ��� <��.> ��� <���.> ��� <���>';
                 -- IF inIsErrSave = FALSE THEN RETURN; END IF;
             END IF;


         -- 1.4.
         ELSE
           --RAISE EXCEPTION '��������.��� ���� = <% ��.> �� ���������� <��.> ��� <���.> ��� <���>.���������� �������� �� <% ��.> �� <% ��.>', inRealWeight;
             vbResultText:= '��������.'
             || CHR (13) || '��� ���� = <' || zfConvert_FloatToString (inRealWeight) || ' ��.>'
                         || '�� ���������� <��.> ��� <���.> ��� <���>.'
             || CHR (13) || '���������� �������� �� <' || zfConvert_FloatToString (CASE WHEN inGoodsTypeKindId_Ves > 0 THEN inWeightMin_Ves
                                                                                        WHEN inGoodsTypeKindId_Nom > 0 THEN inWeightMin_Nom
                                                                                        WHEN inGoodsTypeKindId_Sh  > 0 THEN inWeightMin_Sh
                                                                                        ELSE 0
                                                                                   END
                                                                                  ) || ' ��.>'

                         ||                    ' �� <' || zfConvert_FloatToString (CASE WHEN inGoodsTypeKindId_Ves > 0 THEN inWeightMax_Ves
                                                                                        WHEN inGoodsTypeKindId_Nom > 0 THEN inWeightMax_Nom
                                                                                        WHEN inGoodsTypeKindId_Sh  > 0 THEN inWeightMax_Sh
                                                                                        ELSE 0
                                                                                   END
                                                                                  ) || ' ��.>'
                         ;
         END IF;


     -- ���������
     IF vbResultText = '' OR inIsErrSave = TRUE
     THEN
         vbId:= gpInsertUpdate_wms_MI_WeighingProduction (ioId                  := 0
                                                        , inMovementId          := inMovementId
                                                        , inGoodsTypeKindId     := vbGoodsTypeKindId
                                                        , inBarCodeBoxId        := vbBarCodeBoxId
                                                        , inLineCode            := vbLineCode
                                                        , inAmount              := inAmount
                                                        , inRealWeight          := inRealWeight
                                                        , inWmsBarCode          := CASE WHEN inIsErrSave = TRUE THEN '' ELSE vbWmsBarCode END
                                                        , in_sku_id             := vb_sku_id
                                                        , in_sku_code           := vb_sku_code
                                                        , inPartionDate         := vbOperDate
                                                        , inIsErrSave           := inIsErrSave
                                                        , inSession             := inSession
                                                         );

         -- !!! ����� ���������� ���������� �����������!!!
         IF inIsErrSave = FALSE
         THEN
             -- ���� - ��� + �� (�� ������������!)
             SELECT SUM (MovementItem.RealWeight)
                  , SUM (MovementItem.Amount)
                    INTO vbWeightOnBox, vbCountOnBox
             FROM wms_MI_WeighingProduction AS MovementItem
             WHERE MovementItem.MovementId      = inMovementId
               AND MovementItem.isErased        = FALSE
               AND MovementItem.ParentId        IS NULL
               AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
               AND MovementItem.BarCodeBoxId    = vbBarCodeBoxId
                    ;
    
        -- RAISE EXCEPTION '<%> %', vbWeightOnBox, inWeightOnBox_2;
    
             -- ���� ��� ���� �������
             vbIsFull:= CASE -- �������� �� >= ����������� �� ��
                             WHEN vbGoodsTypeKindId <> inGoodsTypeKindId_Ves
                              -- ����������� ����������� �� ��
                              AND CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                       THEN inCountOnBox_1 -- ����������� - 1
                                       WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                       THEN inCountOnBox_2 -- ����������� - 2
                                       WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                       THEN inCountOnBox_3 -- ����������� - 3
                                  END > 0
                              AND vbCountOnBox >= CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                                        THEN inCountOnBox_1 -- ����������� - 1
                                                        WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                                        THEN inCountOnBox_2 -- ����������� - 2
                                                        WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                                        THEN inCountOnBox_3 -- ����������� - 3
                                                   END
                             -- �������
                             THEN TRUE
    
                             -- �������� >= ����������� �� ���� - !�������!
                             WHEN vbWeightOnBox >= CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1 AND inCountOnBox_1 = 0
                                                        THEN inWeightOnBox_1 -- ����������� - 1
                                                        WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2 AND inCountOnBox_2 = 0
                                                        THEN inWeightOnBox_2 -- ����������� - 2
                                                        WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3 AND inCountOnBox_3 = 0
                                                        THEN inWeightOnBox_3 -- ����������� - 3
                                                   END
                             -- �������
                             THEN TRUE
    
                             -- ��� ���� ���������
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
                                                                                                                    FROM (SELECT DISTINCT MovementItem.BarCodeBoxId
                                                                                                                          FROM wms_MI_WeighingProduction AS MovementItem
                                                                                                                          WHERE MovementItem.MovementId = inMovementId
                                                                                                                            AND MovementItem.isErased   = FALSE
                                                                                                                            AND MovementItem.ParentId   > 0
                                                                                                                         ) AS tmp
                                                                                                                   )
                                                                                                                 , 0) :: Integer
                                                                          , inFromId              := Movement.FromId
                                                                          , inToId                := Movement.ToId
                                                                          , inDocumentKindId      := 0
                                                                          , inPartionGoods        := ''
                                                                          , inIsProductionIn      := FALSE
                                                                          , inSession             := inSession
                                                                           )
                 FROM wms_Movement_WeighingProduction AS Movement WHERE Movement.Id = inMovementId;
    
                 -- � �������� ��� ��������� <��������� ������ (�����)>
                 PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsTypeKind(), vbMovementId, vbGoodsTypeKindId);
                 -- � �������� ��� ��������� <�/� ����� (�����)>
                 PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BarCodeBox(), vbMovementId, vbBarCodeBoxId);
    
    
                 -- �������� ������� - zc_MI_Master
                 PERFORM gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                                       , inMovementId          := vbMovementId
                                                                       , inGoodsId             := Movement.GoodsId
                                                                       , inAmount              := CASE WHEN Movement.GoodsId = inGoodsId_sh OR inMeasureId = zc_Measure_Sh() THEN Movement.Amount ELSE Movement.RealWeight END
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
                 FROM (SELECT CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_sh AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh     ELSE Movement.GoodsId     END AS GoodsId
                            , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_sh AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsKindId_link_sh ELSE Movement.GoodsKindId END GoodsKindId
                            , SUM (MovementItem.RealWeight) AS RealWeight
                            , SUM (MovementItem.Amount)     AS Amount
                       FROM wms_Movement_WeighingProduction AS Movement
                            INNER JOIN wms_MI_WeighingProduction AS MovementItem
                                                                 ON MovementItem.MovementId      = Movement.Id
                                                                AND MovementItem.isErased        = FALSE
                                                                AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
                                                                AND MovementItem.BarCodeBoxId    = vbBarCodeBoxId
                                                                AND MovementItem.ParentId        IS NULL
                       WHERE Movement.Id = inMovementId
                       GROUP BY CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_sh AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh     ELSE Movement.GoodsId     END
                              , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_sh AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsKindId_link_sh ELSE Movement.GoodsKindId END
                      ) AS Movement;
    
    
    
                 -- �������� ���� �� ����� - �/� ��� �����
                 UPDATE wms_Movement_WeighingProduction SET BarCodeBoxId_1 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                                                                        THEN 0
                                                                                   ELSE wms_Movement_WeighingProduction.BarCodeBoxId_1
                                                                              END
                                                           , BarCodeBoxId_2 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                                                                        THEN 0
                                                                                   ELSE wms_Movement_WeighingProduction.BarCodeBoxId_2
                                                                              END
                                                           , BarCodeBoxId_3 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                                                                        THEN 0
                                                                                   ELSE wms_Movement_WeighingProduction.BarCodeBoxId_3
                                                                              END
                 WHERE wms_Movement_WeighingProduction.Id = inMovementId
                ;
    
                 -- ��������� ��� 1 ���� ������
                 UPDATE wms_MI_WeighingProduction SET ParentId = vbMovementId
                 WHERE wms_MI_WeighingProduction.MovementId      = inMovementId
                -- AND wms_MI_WeighingProduction.isErased        = FALSE
                   AND wms_MI_WeighingProduction.ParentId        IS NULL
                   AND wms_MI_WeighingProduction.GoodsTypeKindId = vbGoodsTypeKindId
                   AND wms_MI_WeighingProduction.BarCodeBoxId    = vbBarCodeBoxId
                ;
             END IF; -- if vbIsFull = TRUE

         END IF; -- if inIsErrSave = FALSE

     END IF; -- if vbResultText = '' OR inIsErrSave = TRUE

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
            , vbResultText  AS ResultText
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

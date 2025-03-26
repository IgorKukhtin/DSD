-- Function: gpInsertUpdate_MovementItem_WeighingPartner()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);*/

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingPartner(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inRealWeight          TFloat    , -- �������� ��� (��� �����: ����� ���� � % ������ ��� ���-��)
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inCountTare           TFloat    , -- ���������� ����
    IN inWeightTare          TFloat    , -- ��� ����

    IN inCountTare1          TFloat    , -- ���������� ��. ����1
    IN inWeightTare1         TFloat    , -- ��� ��. ����1
    IN inCountTare2          TFloat    , -- ���������� ��. ����2
    IN inWeightTare2         TFloat    , -- ��� ��. ����2
    IN inCountTare3          TFloat    , -- ���������� ��. ����3
    IN inWeightTare3         TFloat    , -- ��� ��. ����3
    IN inCountTare4          TFloat    , -- ���������� ��. ����4
    IN inWeightTare4         TFloat    , -- ��� ��. ����4
    IN inCountTare5          TFloat    , -- ���������� ��. ����5
    IN inWeightTare5         TFloat    , -- ��� ��. ����5
    IN inCountTare6          TFloat    , -- ���������� ��. ����6
    IN inWeightTare6         TFloat    , -- ��� ��. ����6
    IN inCountTare7          TFloat    , -- ���������� ��. ����7
    IN inWeightTare7         TFloat    , -- ��� ��. ����7
    IN inCountTare8          TFloat    , -- ���������� ��. ����8
    IN inWeightTare8         TFloat    , -- ��� ��. ����8
    IN inCountTare9          TFloat    , -- ���������� ��. ����9
    IN inWeightTare9         TFloat    , -- ��� ��. ����9
    IN inCountTare10         TFloat    , -- ���������� ��. ����10
    IN inWeightTare10        TFloat    , -- ��� ��. ����10

    IN inTareId_1              Integer   , --
    IN inTareId_2              Integer   , --
    IN inTareId_3              Integer   , --
    IN inTareId_4              Integer   , --
    IN inTareId_5              Integer   , --
    IN inTareId_6              Integer   , --
    IN inTareId_7              Integer   , --
    IN inTareId_8              Integer   , --
    IN inTareId_9              Integer   , --
    IN inTareId_10             Integer   , --

    IN inPartionCellId         Integer   , -- 

    IN inCountPack           TFloat    , -- ���������� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inBoxCount            TFloat    , -- ���������� ����(�����)
    IN inBoxNumber           TFloat    , -- ����� �����
    IN inLevelNumber         TFloat    , -- ����� ����
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inPartionGoods        TVarChar  , -- ������
    IN inPartionGoodsDate    TDateTime , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inPriceListId         Integer   , -- �����
    IN inBoxId               Integer   , -- ����(�����)
    IN inMovementId_Promo    Integer   ,
    IN inIsBarCode           Boolean   , --
    IN inBranchCode          Integer   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <MovementId-�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, inMovementId_Promo);

     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� �������� <����/����� ��������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);

     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- ��������� �������� <�������� ��� (��� �����: ����� ���� � % ������ ��� ���-��)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- ��������� �������� <% ������ ��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);
     -- ��������� �������� <���������� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- ��������� �������� <���������� ����(�����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);
     -- ��������� �������� <����� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxNumber(), ioId, inBoxNumber);
     -- ��������� �������� <����� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LevelNumber(), ioId, inLevelNumber);
     -- ��������� �������� <�� �������>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), ioId, inIsBarCode);


     IF inBranchCode = 115
     THEN
         -- ��� ��������� � ��������
         IF vbIsInsert = TRUE
         THEN
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionNum(), ioId, CAST (NEXTVAL ('MI_PartionPassport_seq') AS TFloat));
         END IF;
         

         -- ������ �������� 
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, inPartionCellId);

         -- ������������ (��������)
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         

         -- ����� ��������� 5 ����������
         IF (CASE WHEN inCountTare1  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare2  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare3  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare4  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare5  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare6  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare7  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare8  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare9  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare10 > 0 THEN 1 ELSE 0 END) > 5
         THEN
             RAISE EXCEPTION '������.��������� ����� 5 ��������';
         END IF;
         
         -- ����� ���������
         IF inCountTare1 > 0 AND inCountTare2 > 0
         THEN
             RAISE EXCEPTION '������.����� ���� ������ ������ ���� ��� �������.';
         END IF;

         -- ����� ���������
         IF inCountTare1 NOT IN (0, 1)
         THEN
             RAISE EXCEPTION '������.���-�� �������� ����� ���� ������ = 1.';
         END IF;
         -- ����� ���������
         IF inCountTare2 NOT IN (0, 1)
         THEN
             RAISE EXCEPTION '������.���-�� �������� ����� ���� ������ = 1.';
         END IF;


         -- ��������� �������� <���������� ��������>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountTare);
         -- ��������� �������� <��� 1-�� ��������>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightPack(), ioId, inWeightTare);

         PERFORM CASE WHEN tmp.Ord = 1 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), ioId, tmp.BoxId)
                      WHEN tmp.Ord = 2 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box2(), ioId, tmp.BoxId)
                      WHEN tmp.Ord = 3 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box3(), ioId, tmp.BoxId)
                      WHEN tmp.Ord = 4 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box4(), ioId, tmp.BoxId)
                      WHEN tmp.Ord = 5 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box5(), ioId, tmp.BoxId)
                 END
               , CASE WHEN tmp.Ord = 1 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 2 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(), ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 3 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare3(), ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 4 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare4(), ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 5 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare5(), ioId, tmp.CountTare ::TFloat)
                 END

               , CASE WHEN tmp.Ord = 1 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare1(), ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 2 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare2(), ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 3 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare3(), ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 4 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare4(), ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 5 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare5(), ioId, tmp.WeightTare ::TFloat)
                 END

         FROM (WITH tmpParamAll AS (SELECT inTareId_1 AS BoxId, COALESCE (inCountTare1,0) AS CountTare, COALESCE (inWeightTare1, 0) AS WeightTare, 1 AS npp
                          UNION ALL SELECT inTareId_2 AS BoxId, COALESCE (inCountTare2,0) AS CountTare, COALESCE (inWeightTare2, 0) AS WeightTare, 2 AS npp
                          UNION ALL SELECT inTareId_3 AS BoxId, COALESCE (inCountTare3,0) AS CountTare, COALESCE (inWeightTare3, 0) AS WeightTare, 3 AS npp
                          UNION ALL SELECT inTareId_4 AS BoxId, COALESCE (inCountTare4,0) AS CountTare, COALESCE (inWeightTare4, 0) AS WeightTare, 4 AS npp
                          UNION ALL SELECT inTareId_5 AS BoxId, COALESCE (inCountTare5,0) AS CountTare, COALESCE (inWeightTare5, 0) AS WeightTare, 5 AS npp
                          UNION ALL SELECT inTareId_6 AS BoxId, COALESCE (inCountTare6,0) AS CountTare, COALESCE (inWeightTare6, 0) AS WeightTare, 6 AS npp
                          UNION ALL SELECT inTareId_7 AS BoxId, COALESCE (inCountTare7,0) AS CountTare, COALESCE (inWeightTare7, 0) AS WeightTare, 7 AS npp
                          UNION ALL SELECT inTareId_8 AS BoxId, COALESCE (inCountTare8,0) AS CountTare, COALESCE (inWeightTare8, 0) AS WeightTare, 8 AS npp
                          UNION ALL SELECT inTareId_9 AS BoxId, COALESCE (inCountTare9,0) AS CountTare, COALESCE (inWeightTare9, 0) AS WeightTare, 9 AS npp
                          UNION ALL SELECT inTareId_10 AS BoxId, COALESCE (inCountTare10,0) AS CountTare, COALESCE (inWeightTare10, 0) AS WeightTare, 10 AS npp
                                   )
                     , tmpParam AS (SELECT tmpParamAll.*
                                         , ROW_NUMBER() OVER (ORDER BY tmpParamAll.npp) AS Ord
                                    FROM tmpParamAll
                                    WHERE tmpParamAll.CountTare <> 0 AND tmpParamAll.BoxId <> 0
                                      -- ������ �������
                                      AND tmpParamAll.npp <= 2

                                  UNION ALL
                                    SELECT tmpParamAll.*
                                         , 1 + ROW_NUMBER() OVER (ORDER BY tmpParamAll.npp) AS Ord
                                    FROM tmpParamAll
                                    WHERE tmpParamAll.CountTare <> 0 AND tmpParamAll.BoxId <> 0
                                      -- ��� ��������
                                      AND tmpParamAll.npp > 2
                                   )
                            -- ������ 5 ���������� ���� ����� ����� ���-�� ��������
                          , tmp AS (SELECT 1 AS Ord
                          UNION ALL SELECT 2 AS Ord
                          UNION ALL SELECT 3 AS Ord
                          UNION ALL SELECT 4 AS Ord
                          UNION ALL SELECT 5 AS Ord
                                    )
               SELECT COALESCE (tmpParam.BoxId, 0)      AS BoxId
                    , COALESCE (tmpParam.CountTare, 0)  AS CountTare
                    , COALESCE (tmpParam.WeightTare, 0) AS WeightTare
                    , tmp.Ord
               FROM tmp
                    LEFT JOIN tmpParam ON tmpParam.Ord = tmp.Ord
              ) AS tmp;

     ELSE

         -- ��������� �������� <���������� ����>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare(), ioId, inCountTare);
         -- ��������� �������� <��� ����>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);

         -- ��������� �������� <���������� ��. ����1>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), ioId, inCountTare1);
         -- ��������� �������� <��� ��. ����1>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare1(), ioId, inWeightTare1);
         -- ��������� �������� <���������� ��. ����2>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(), ioId, inCountTare2);
         -- ��������� �������� <��� ��. ����2>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare2(), ioId, inWeightTare2);
         -- ��������� �������� <���������� ��. ����3>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare3(), ioId, inCountTare3);
         -- ��������� �������� <��� ��. ����3>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare3(), ioId, inWeightTare3);
         -- ��������� �������� <���������� ��. ����4>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare4(), ioId, inCountTare4);
         -- ��������� �������� <��� ��. ����4>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare4(), ioId, inWeightTare4);
         -- ��������� �������� <���������� ��. ����5>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare5(), ioId, inCountTare5);
         -- ��������� �������� <��� ��. ����5>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare5(), ioId, inWeightTare5);
         -- ��������� �������� <���������� ��. ����6>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare6(), ioId, inCountTare6);
         -- ��������� �������� <��� ��. ����6>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare6(), ioId, inWeightTare6);

     END IF;

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     -- ��������� �������� <(-)% ������ (+)% �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PriceList(), ioId, inPriceListId);
     -- ��������� ����� � <��� �����. ��.>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.02.20         *
 13.11.15                                        *
 13.10.14                                        * all
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')

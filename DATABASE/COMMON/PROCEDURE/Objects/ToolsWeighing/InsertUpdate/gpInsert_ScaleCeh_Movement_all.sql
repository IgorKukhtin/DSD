-- Function: gpInsert_ScaleCeh_Movement_all()

DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_Movement_all (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleCeh_Movement_all(
    IN inBranchCode          Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (MovementId_begin    Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId_find Integer;
   DECLARE vbMovementId_begin Integer;
   DECLARE vbMovementDescId Integer;

   DECLARE vbId_tmp Integer;
   DECLARE vbPartionGoods   TVarChar;
   DECLARE vbIsProductionIn Boolean;
   DECLARE vbWeighingNumber TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ScaleCeh_Movement_all());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ ��� ���������.';
     END IF;

     -- ���������� <��� ���������>
     vbMovementDescId:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_MovementDesc()) :: Integer;

     -- !!!�������� ��������!!! : ����������� -> ������������ �����������
     IF vbMovementDescId = zc_Movement_Send() AND (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To())
                                                  IN (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) WHERE UnitId <> 8450 -- ��� �������+���-�� <> ��� ��������
                                                     UNION
                                                      SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8439) -- ������� ������� �����
                                                     )
                                              AND (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                  IN (SELECT 8451 -- ��� ��������
                                                     UNION
                                                      SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8453) -- ������
                                                     )
     THEN
         vbMovementDescId:= zc_Movement_ProductionUnion();
         vbIsProductionIn:= FALSE;
     ELSE
         vbIsProductionIn:= NULL;
     END IF;


     -- ���������� <������ ������>
     vbPartionGoods:= (SELECT MIString_PartionGoods.ValueData
                       FROM MovementItem
                            INNER JOIN MovementItemString AS MIString_PartionGoods
                                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                         AND MIString_PartionGoods.ValueData <> ''
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.isErased = FALSE
                         AND vbMovementDescId = zc_Movement_ProductionSeparate()
                       GROUP BY MIString_PartionGoods.ValueData
                      );

     IF vbMovementDescId = zc_Movement_ProductionSeparate()
     THEN
           -- ���������� <������ ��� ������>, ����� ������ ��� zc_Movement_ProductionSeparate
           vbIsProductionIn:= (SELECT MB_isIncome.ValueData FROM MovementBoolean AS MB_isIncome WHERE MB_isIncome.MovementId = inMovementId AND MB_isIncome.DescId = zc_MovementBoolean_isIncome());

           -- ����� ������������� ��������� <������������> �� ���� ���������� + ������
           vbMovementId_find:= (SELECT Movement.Id
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                     INNER JOIN MovementString AS MovementString_PartionGoods
                                                               ON MovementString_PartionGoods.MovementId = Movement.Id
                                                              AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                              AND MovementString_PartionGoods.ValueData = vbPartionGoods
                                WHERE Movement.DescId = zc_Movement_ProductionSeparate()
                                  AND Movement.OperDate = inOperDate
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()));
            vbWeighingNumber:= 1 + COALESCE ((SELECT COUNT(*) FROM Movement WHERE ParentId = vbMovementId_find AND DescId = zc_Movement_WeighingProduction() AND StatusId <> zc_Enum_Status_Erased()), 0);
     END IF;
     IF vbMovementDescId = zc_Movement_Inventory()
     THEN
           -- ����� ������������� ��������� <��������������> �� ���� ����������
           vbMovementId_find:= (SELECT Movement.Id
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                   ON MovementLinkObject_From_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                                   ON MovementLinkObject_To_find.MovementId = inMovementId
                                                                  AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = MovementLinkObject_To_find.ObjectId
                                WHERE Movement.DescId = zc_Movement_Inventory()
                                  AND Movement.OperDate = inOperDate - INTERVAL '1 DAY'
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()));
     END IF;


     -- ���������
     vbMovementId_begin:= vbMovementId_find;


    -- ��������� <��������>
    IF COALESCE (vbMovementId_begin, 0) = 0
    THEN
        -- ���������
        vbMovementId_begin:= (SELECT CASE WHEN vbMovementDescId = zc_Movement_Loss()
                                                    -- <��������>
                                               THEN lpInsertUpdate_Movement_Loss_scale
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Loss_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inPriceWithVAT          := FALSE
                                                  , inVATPercent            := 20
                                                  , inFromId                := FromId
                                                  , inToId                  := NULL
                                                  , inArticleLossId         := ToId -- !!!�� ������!!!
                                                  , inPaidKindId            := zc_Enum_PaidKind_SecondForm()
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Send()
                                                    -- <�����������>
                                               THEN lpInsertUpdate_Movement_Send
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Send_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ProductionUnion()
                                                    -- <������ � ������������>
                                               THEN lpInsertUpdate_Movement_ProductionUnion
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inIsPeresort            := FALSE
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ProductionSeparate()
                                                    -- <������������>
                                               THEN lpInsertUpdate_Movement_ProductionSeparate
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ProductionSeparate_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPartionGoods          := vbPartionGoods
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Inventory()
                                                    -- <��������������>
                                               THEN lpInsertUpdate_Movement_Inventory
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Inventory_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate - INTERVAL '1 DAY'
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inUserId                := vbUserId
                                                   )

                                          END AS MovementId_begin

                                    FROM gpGet_Movement_WeighingProduction (inMovementId:= inMovementId, inSession:= inSession) AS tmp
                                 );
         -- ��������
         IF COALESCE (vbMovementId_begin, 0) = 0
         THEN
             RAISE EXCEPTION '������.������ ��������� ������ ��� ���������.';
         END IF;

        -- �������� ��-�� <����/����� ��������>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId_begin, CURRENT_TIMESTAMP);

    ELSE
        -- ����������� �������� !!!������������!!!
        PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_begin
                                     , inUserId     := vbUserId);
    END IF;


     -- ��������� <�������� �����>
     SELECT MAX (tmpId) INTO vbId_tmp
     FROM (SELECT CASE WHEN vbMovementDescId = zc_Movement_Loss()
                                 -- <��������>
                            THEN lpInsertUpdate_MovementItem_Loss_scale
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPrice               := 0
                                                        , inCountForPrice       := 0
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Send()
                                 -- <�����������>
                            THEN lpInsertUpdate_MovementItem_Send_Value
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inCount               := tmp.CountPack
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUnitId              := NULL -- !!!�� ������, ����� �� �����������!!!
                                                        , inStorageId           := NULL
                                                        , inPartionGoodsId      := NULL
                                                        , inUserId              := vbUserId
                                                         )

                       WHEN vbMovementDescId = zc_Movement_ProductionUnion()
                                 -- <������ � ������������>
                            THEN lpInsertUpdate_MI_ProductionUnion_Master
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inCount               := tmp.Count
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = FALSE
                                 -- <������ � ������������ - Separate>
                            THEN lpInsertUpdate_MI_ProductionSeparate_Master
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inLiveWeight          := tmp.LiveWeight
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = TRUE
                                 -- <������ �� ������������ - Separate>
                            THEN lpInsertUpdate_MI_ProductionSeparate_Child
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inParentId            := NULL
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inLiveWeight          := tmp.LiveWeight
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Inventory()
                                 -- <��������������>
                            THEN lpInsertUpdate_MovementItem_Inventory
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inPrice               := 0 -- !!!�� ������, ����� �� �����������!!!
                                                        , inSumm                := 0 -- !!!�� ������, ����� �� �����������!!!
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inCount               := tmp.Count
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUnitId              := NULL
                                                        , inStorageId           := NULL
                                                        , inUserId              := vbUserId
                                                         )

                  END AS tmpId
          FROM (SELECT MAX (tmp.MovementItemId)      AS MovementItemId_find
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , tmp.PartionGoodsDate
                     , tmp.PartionGoods
                     , SUM (tmp.Amount)       AS Amount
                     , SUM (tmp.Count)        AS Count
                     , SUM (tmp.CountPack)    AS CountPack
                     , SUM (tmp.HeadCount)    AS HeadCount
                     , SUM (tmp.LiveWeight)   AS LiveWeight
                FROM (SELECT 0                                                   AS MovementItemId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN zc_Goods_ReWork() ELSE MovementItem.ObjectId             END AS GoodsId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  END AS GoodsKindId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE MIDate_PartionGoods.ValueData                  END AS PartionGoodsDate
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIString_PartionGoods.ValueData, '') END AS PartionGoods

                           , MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount -- !!!* ��� ������ ��� ����������� � �����������!!
                           , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                           , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight

                           , MovementItem.Amount                                 AS Amount_mi
                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       THEN 0 -- ���� �����������
                                  WHEN inBranchCode <> 201 -- ���� �� �������
                                       THEN 0 -- ����� �����������
                                  ELSE MovementItem.Id -- ���� �� ���� �����������
                             END AS myId
                      FROM MovementItem
                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                       AND vbMovementDescId <> zc_Movement_ProductionSeparate() -- !!!���� ������ ������, �.�. � UNION �� ���!!!

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                               AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn= FALSE -- !!!�����!!!
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                                AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn= FALSE -- !!!�����!!!

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     UNION ALL
                      SELECT MovementItem.Id                                     AS MovementItemId
                           , MovementItem.ObjectId                               AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                           , MIDate_PartionGoods.ValueData                       AS PartionGoodsDate
                           , COALESCE (MIString_PartionGoods.ValueData, '')      AS PartionGoods

                           , MovementItem.Amount                                 AS Amount
                           , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                           , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight

                           , 0                                                   AS Amount_mi
                           , 0                                                   AS myId
                      FROM (SELECT zc_MI_Master() AS DescId WHERE vbMovementDescId = zc_Movement_Inventory()
                           UNION
                            SELECT zc_MI_Master() AS DescId WHERE vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = FALSE AND 1 = 0 -- ���� �� ���� �����������
                           UNION
                            SELECT zc_MI_Child() AS DescId WHERE vbMovementDescId = zc_Movement_ProductionSeparate() AND vbIsProductionIn = TRUE AND 1 = 0 -- ���� �� ���� �����������
                           ) AS tmp
                           INNER JOIN MovementItem ON MovementItem.MovementId = vbMovementId_find
                                                  AND MovementItem.DescId     = tmp.DescId
                                                  AND MovementItem.isErased   = FALSE
                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     ) AS tmp
                GROUP BY tmp.GoodsId
                       , tmp.GoodsKindId
                       , tmp.PartionGoodsDate
                       , tmp.PartionGoods
                       , tmp.myId -- ���� ��� ������������ - ������ ����������� � ��������� �������
                HAVING SUM (tmp.Amount_mi) <> 0
               ) AS tmp
          ) AS tmp;


     -- �������� ������ �� �����������
     IF vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
     THEN 
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                  := 0
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inParentId            := vbId_tmp
                                                        , inPartionGoodsDate    := NULL
                                                        , inPartionGoods        := NULL
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUserId              := vbUserId
                                                         )
          FROM (SELECT tmp.GoodsId
                     , tmp.GoodsKindId
                     , SUM (tmp.Amount) AS Amount
                FROM (SELECT MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     ) AS tmp
                GROUP BY tmp.GoodsId
                       , tmp.GoodsKindId
               ) AS tmp
          ;
     END IF;


     -- !!!!!!!!!!!!!!
     -- !!!��������!!!
     -- !!!!!!!!!!!!!!

     -- <��������>
     IF vbMovementDescId = zc_Movement_Loss()
     THEN
         -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <����������� �� ����>
         PERFORM lpComplete_Movement_Loss_CreateTemp();
         -- �������� ��������
         PERFORM lpComplete_Movement_Loss (inMovementId     := vbMovementId_begin
                                         , inUserId         := vbUserId);
     ELSE
          -- <�����������>
          IF vbMovementDescId = zc_Movement_Send()
          THEN
              -- �������� ��������
              PERFORM gpComplete_Movement_Send (inMovementId     := vbMovementId_begin
                                              , inIsLastComplete := NULL
                                              , inSession        := inSession);
          ELSE
               -- <������ � ������������>
               IF vbMovementDescId = zc_Movement_ProductionUnion()
               THEN
                   -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <����������� �� ����>
                   PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
                   -- �������� ��������
                   PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := vbMovementId_begin
                                                              , inIsHistoryCost  := FALSE
                                                              , inUserId         := vbUserId);
               ELSE
               -- <��������������>
               IF vbMovementDescId = zc_Movement_Inventory()
               THEN
                   -- �������� ��������
                   PERFORM gpComplete_Movement_Inventory (inMovementId     := vbMovementId_begin
                                                        , inIsLastComplete := NULL
                                                        , inSession        := inSession);
               END IF;
               END IF;
               END IF;
     END IF;


     -- ����� - ��������� <��������> - <����������� (������������)> - ������ ���� + ParentId + AccessKeyId
     PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, inOperDate, vbMovementId_begin, Movement_begin.AccessKeyId)
     FROM Movement
          LEFT JOIN Movement AS Movement_begin ON Movement_begin.Id = vbMovementId_begin
     WHERE Movement.Id = inMovementId ;

     -- ��������� �������� <�������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inMovementId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), inMovementId, vbPartionGoods);
     --
     IF vbMovementDescId = zc_Movement_ProductionSeparate()
     THEN
          -- ��������� �������� <����� �����������>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inMovementId, vbWeighingNumber);
     END IF;


     -- ����� - ����������� ������ ������ ��������� + ��������� �������� - <����������� (������������)>
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingProduction()
                                , inUserId     := vbUserId
                                 );


     -- !!!�������� ��� �������� ����!!!
     IF vbMovementDescId = zc_Movement_Inventory()
     THEN IF EXISTS (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                        ON MovementLinkObject_From_find.MovementId = inMovementId
                                                       AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                      WHERE Movement.Id <> vbMovementId_begin
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.OperDate = inOperDate - INTERVAL '1 DAY'
                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                    )
          THEN
              RAISE EXCEPTION '������ <%>.�������� <��������������> �� <%> ��� ����������.��������� �������� ����� 15 ���.'
                  , (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                        ON MovementLinkObject_From_find.MovementId = inMovementId
                                                       AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND MovementLinkObject_From.ObjectId = MovementLinkObject_From_find.ObjectId
                      WHERE Movement.Id <> vbMovementId_begin
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.OperDate = inOperDate - INTERVAL '1 DAY'
                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                    )
                  , DATE (inOperDate - INTERVAL '1 DAY');
          END IF;
     END IF;

     -- ���������
     RETURN QUERY
       SELECT vbMovementId_begin AS MovementId_begin;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.07.15                                        * !!!�������� ��� �������� ����!!!
 11.06.15                                        *
*/

-- ����
-- SELECT * FROM gpInsert_ScaleCeh_Movement_all (inBranchCode:= 0, inMovementId:= 10, inOperDate:= '01.01.2015', inSession:= zfCalc_UserAdmin())

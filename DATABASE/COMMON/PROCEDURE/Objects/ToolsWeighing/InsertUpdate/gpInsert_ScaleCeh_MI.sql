-- Function: gpInsert_ScaleCeh_MI()

-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleCeh_MI(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inStorageLineId       Integer   , -- ����� ��-��
    IN inPersonalId_KVK      Integer   , --
    IN inAssetId             Integer   , --
    IN inAssetId_two         Integer   , --
    IN inIsStartWeighing     Boolean   , -- ����� ������ �����������
    IN inIsPartionGoodsDate  Boolean   , --
    IN inIsAsset             Boolean   , --
    IN inOperCount           TFloat    , -- ����������
    IN inRealWeight          TFloat    , -- �������� ��� (��� ����� % ������ ��� ���-��)
    IN inWeightTare          TFloat    , -- ��� ����
    IN inLiveWeight          TFloat    , -- ����� ���
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inCount               TFloat    , -- ���������� �������
    IN inCountPack           TFloat    , -- ���������� ��������
    IN inCountSkewer1        TFloat    , -- ���������� ������/������� ����1
    IN inWeightSkewer1       TFloat    , -- ��� ����� ������/������ ����1
    IN inCountSkewer2        TFloat    , -- ���������� ������ ����2
    IN inWeightSkewer2       TFloat    , -- ��� ����� ������ ����2
    IN inWeightOther         TFloat    , -- ���, ������
    IN inPartionGoodsDate    TDateTime , -- ������ ������ (����)
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inNumberKVK           TVarChar  , -- � ���
    IN inBranchCode          Integer   , --
    IN inSession             TVarChar    -- ������ ������������
)

RETURNS TABLE (Id        Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId Integer;
   DECLARE vbDocumentKindId Integer;
   DECLARE vbToId      Integer;
   DECLARE vbUnitId    Integer;

   DECLARE vbWeight_goods              TFloat;
   DECLARE vbWeightTare_goods          TFloat;
   DECLARE vbCountForWeight_goods      TFloat;

   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);


-- !!!!!!!!!!
-- !!!!!!!!!!
-- IF inGoodsKindId IN (196608, 1869768455) THEN inGoodsKindId:= 0; END IF;
-- !!!!!!!!!!
-- !!!!!!!!!!


     -- ����� ��������� ����� ������ ���������� ����.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- ����������
     SELECT MovementLinkObject_From.ObjectId          AS UnitId
          , MovementLinkObject_To.ObjectId            AS ToId
            INTO vbUnitId, vbToId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId      = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;


     -- ��������
     IF vbUnitId = 8451 -- ��� ��������
        AND vbToId = 8459 -- ����������� ��������
        AND inGoodsKindId = zc_GoodsKind_Basis()
     THEN
         RAISE EXCEPTION '������.��� ���� ��� ����������� ���� <%>.', lfGet_Object_ValueData_sh (inGoodsKindId);
     END IF;


     -- !!!������, �������� ��� - �� ���� �������� �. ��� ��.
     IF 1=1 AND EXISTS (SELECT FROM ObjectLink AS OL_Measure WHERE OL_Measure.ChildObjectId NOT IN (zc_Measure_Kg(), zc_Measure_Sh()) AND OL_Measure.ObjectId = inGoodsId AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure())
        AND NOT EXISTS (SELECT 1
                        FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                             INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                              ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                             AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                                                                                         , zc_Enum_InfoMoneyDestination_20600() -- ������ ���������
                                                                                                          )
                        WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                          AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                       )

     THEN
         -- ��� ��� �������� �� ���� � ����� ��� ���-�� ���
         vbWeight_goods:= (SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_Weight());
         --
         IF vbWeight_goods > 0
         THEN
             -- ���. ��� ����
             vbCountForWeight_goods:= (SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_CountForWeight());
             IF COALESCE (vbCountForWeight_goods, 0) = 0 THEN vbCountForWeight_goods:= 1; END IF;
             -- ��� ������
             vbWeightTare_goods:= COALESCE ((SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_WeightTare()), 0);

             -- ��������
             IF 1=0 AND vbWeightTare_goods > 0 AND COALESCE (inCount, 0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ���-�� ������ � ����� <%>', zfConvert_FloatToString (vbWeightTare_goods);
             END IF;
             -- ���� ���-���� ������ ���
             IF inCount < 0 THEN inCount:= 0; END IF;

             IF (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure())
                IN (zc_Measure_Sht() -- ��.
                   )
             THEN
                 -- ������ �������� - ������� �� ���� � ����� ��� ���-�� ��� ... � �������� ������
                 inOperCount:= ROUND (vbCountForWeight_goods * (inRealWeight - inWeightTare - vbWeightTare_goods * inCount) / vbWeight_goods);
             ELSE
                 -- ������ �������� - ������� �� ���� � ����� ��� ���-�� ��� ... � �������� ������
                 inOperCount:= vbCountForWeight_goods * (inRealWeight - inWeightTare - vbWeightTare_goods * inCount) / vbWeight_goods;
             END IF;

             -- ��������
             IF inOperCount <= 0
             THEN
                 RAISE EXCEPTION '������.��������� ���-�� �� ������� ���� ������ = <%> �� ����� ���� <= 0.', zfConvert_FloatToString (inOperCount);
             END IF;

         ELSE
             -- �������� ���-�� ������
             inCount:= 0;
         END IF;

     END IF;


     -- ���������� <��� ���������>
     vbDocumentKindId:= (SELECT CASE WHEN TRIM (tmp.RetV) = '' THEN '0' ELSE TRIM (tmp.RetV) END :: Integer
                         FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                               , inLevel2      := 'Movement'
                                                               , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                               , inItemName    := 'DocumentKindId'
                                                               , inDefaultValue:= '0'
                                                               , inSession     := inSession
                                                                ) AS RetV
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId = inMovementId
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                 AND MovementFloat.ValueData > 0
                              ) AS tmp
                        );
     -- ��������
     IF vbDocumentKindId IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg())
     THEN IF zfConvert_StringToNumber (inPartionGoods) = 0
          THEN
              RAISE EXCEPTION '������.������ ����������� ��-�� �� ����������. <%>', inPartionGoods;
          END IF;
     END IF;

     -- ���������
     vbId:= gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                          , inMovementId          := inMovementId
                                                          , inGoodsId             := inGoodsId
                                                          , inAmount              := inOperCount
                                                          , inIsStartWeighing     := inIsStartWeighing
                                                          , inRealWeight          := inRealWeight
                                                          , inWeightTare          := inWeightTare
                                                          , inLiveWeight          := inLiveWeight
                                                          , inHeadCount           := inHeadCount
                                                          , inCount               := inCount
                                                          , inCountPack           := inCountPack
                                                          , inCountSkewer1        := inCountSkewer1
                                                          , inWeightSkewer1       := inWeightSkewer1
                                                          , inCountSkewer2        := inCountSkewer2
                                                          , inWeightSkewer2       := inWeightSkewer2
                                                          , inWeightOther         := inWeightOther
                                                          , inPartionGoodsDate    := CASE WHEN inIsPartionGoodsDate = TRUE AND COALESCE (vbDocumentKindId, 0) = 0
                                                                                               THEN inPartionGoodsDate
                                                                                          ELSE NULL
                                                                                     END :: TDateTime
                                                          , inPartionGoods        := CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg()) AND zfConvert_StringToNumber (inPartionGoods) > 0 THEN '' ELSE inPartionGoods END
                                                          , inNumberKVK           := inNumberKVK
                                                          , inMovementItemId      := CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg()) AND zfConvert_StringToNumber (inPartionGoods) > 0 THEN zfConvert_StringToNumber (inPartionGoods) ELSE 0 END
                                                          , inGoodsKindId         := CASE WHEN (SELECT View_InfoMoney.InfoMoneyDestinationId
                                                                                                FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                                                     LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                                WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                                                                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                                                               ) IN (zc_Enum_InfoMoneyDestination_20500() -- ������������� + ��������� ����
                                                                                                   , zc_Enum_InfoMoneyDestination_20600() -- ������������� + ������ ���������
                                                                                                    )
                                                                                               THEN 0
                                                                                          ELSE inGoodsKindId
                                                                                     END
                                                          , inStorageLineId       := inStorageLineId
                                                          , inPersonalId_KVK      := inPersonalId_KVK
                                                          , inSession             := inSession
                                                           );


     -- �������� ��-�� <Asset >
     IF inIsAsset = TRUE
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), vbId, inAssetId);
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset_two(), vbId, inAssetId_two);
     END IF;

     -- �������� ��-�� <�������� ����/����� ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), vbId, vbOperDate_StartBegin);
     -- �������� ��-�� <�������� ����/����� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), vbId, CLOCK_TIMESTAMP());


     -- ���������
     RETURN QUERY
       SELECT vbId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsert_ScaleCeh_MI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')

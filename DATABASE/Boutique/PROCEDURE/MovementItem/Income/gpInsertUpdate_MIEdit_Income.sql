-- Function: gpInsertUpdate_MIEdit_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_IncomeLoad (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MIEdit_Income(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsGroupId          Integer   , --
    IN inMeasureId             Integer   , --
    IN inJuridicalId           Integer   , -- ��.����(����)
 INOUT ioGoodsCode             Integer   , -- ��� ������
    IN inGoodsName             TVarChar  , -- ������
    IN inGoodsInfoName         TVarChar  , --
    IN inGoodsSizeName         TVarChar  , --
    IN inCompositionName       TVarChar  , --
    IN inLineFabricaName       TVarChar  , --
    IN inLabelName             TVarChar  , --
    IN inAmount                TFloat    , -- ����������
    IN inPriceJur              TFloat    , -- ���� ��.��� ������
    IN inCountForPrice         TFloat    , -- ���� �� ����������
    IN inOperPriceList         TFloat    , -- ���� �� ������
    IN inIsCode                Boolean   , -- �� �������� ��� ������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbLineFabricaId Integer;
   DECLARE vbCompositionId Integer;
   DECLARE vbGoodsSizeId   Integer;
   DECLARE vbGoodsId       Integer;
   DECLARE vbGoodsId_old   Integer;
   DECLARE vbGoodsInfoId   Integer;
   DECLARE vbGoodsItemId   Integer;
   DECLARE vbLabelId       Integer;

   DECLARE vbOperDate  TDateTime;
   DECLARE vbPartnerId Integer;

   DECLARE vbId_min Integer;
   DECLARE vbId_max Integer;

   DECLARE vbOperPriceList_old TFloat;
   DECLARE vbOperPrice TFloat;
   DECLARE vbChangePercent TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF (inSession :: Integer) < 0
     THEN
         vbUserId := lpCheckRight ((-1 * (inSession :: Integer)) :: TVarChar, zc_Enum_Process_InsertUpdate_MI_Income());
     ELSE
         vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());
     END IF;


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;

     -- ��������� �� ���������
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbPartnerId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbPartnerId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <��c������>.';
     END IF;


     -- ����� ���������
     inLineFabricaName:= TRIM (inLineFabricaName);
     IF inLineFabricaName <> ''
     THEN
         -- �����
         vbLineFabricaId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_LineFabrica() AND LOWER (Object.ValueData) = LOWER (inLineFabricaName));
         --
         IF COALESCE (vbLineFabricaId, 0) = 0
         THEN
             -- ��������
             vbLineFabricaId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_LineFabrica (ioId     := 0
                                                                                       , ioCode   := 0
                                                                                       , inName   := inLineFabricaName
                                                                                       , inSession:= vbUserId :: TVarChar
                                                                                         ) AS tmp);
         END IF;
     END IF;

     -- ������ ������
     inCompositionName:= TRIM (inCompositionName);
     IF inCompositionName <> ''
     THEN
         -- ����� !!!��� ������!!!
         vbCompositionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Composition() AND LOWER (Object.ValueData) = LOWER (inCompositionName) ORDER BY Object.Id LIMIT 1);   -- limit 1 ��� ��� ������  ��� inCompositionName = '100%������'  ���������� 2 ������
         --
         IF COALESCE (vbCompositionId, 0) = 0
         THEN
             -- ��������
             vbCompositionId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Composition (ioId                 := 0
                                                                                       , ioCode               := 0
                                                                                       , inName               := inCompositionName
                                                                                       , inCompositionGroupId := 0 -- ��������� � ������ �������
                                                                                       , inSession            := vbUserId :: TVarChar
                                                                                         ) AS tmp);
         END IF;
     END IF;

     -- �������� ������
     inGoodsInfoName:= TRIM (inGoodsInfoName);
     IF COALESCE (TRIM (inGoodsInfoName), '') <> ''
     THEN
         -- ����� !!!��� ������!!!
         vbGoodsInfoId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsInfo() AND LOWER (Object.ValueData) = LOWER (inGoodsInfoName));   --  '\%'  ��� ��� ������ ���  inGoodsInfoName = '\�����  '   ��� ��� �������� ����� �� ����������� � ��������� ���������
         --
         IF COALESCE (vbGoodsInfoId, 0) = 0
         THEN
             -- ��������
             vbGoodsInfoId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsInfo (ioId     := 0
                                                                                   , ioCode   := 0
                                                                                   , inName   := inGoodsInfoName
                                                                                   , inSession:= vbUserId :: TVarChar
                                                                                     ) AS tmp);
         END IF;
     END IF;

     -- �������� ��� �������
     inLabelName:= TRIM (inLabelName);
     IF inLabelName <> ''
     THEN
         -- �����
         vbLabelId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND LOWER (Object.ValueData) = LOWER (inLabelName));
         --
         IF COALESCE (vbLabelId, 0) = 0
         THEN
             -- ��������
             vbLabelId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Label (ioId     := 0
                                                                           , ioCode   := 0
                                                                           , inName   := inLabelName
                                                                           , inSession:= vbUserId :: TVarChar
                                                                             ) AS tmp);
         END IF;
     END IF;

     -- ������ ������
     inGoodsSizeName:= COALESCE (TRIM (inGoodsSizeName), '');
     -- �������� - �������� ������ ���� �����������
     -- IF inGoodsSizeName = '' THEN
     --    RAISE EXCEPTION '������.�� ����������� �������� <������ ������>.';
     -- END IF;
     --
     -- ����� - ������
     vbGoodsSizeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND LOWER (Object.ValueData) = LOWER (inGoodsSizeName));
     --
     IF COALESCE (vbGoodsSizeId, 0) = 0
     THEN
         -- ��������
         vbGoodsSizeId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsSize (ioId     := 0
                                                                               , ioCode   := 0
                                                                               , inName   := inGoodsSizeName
                                                                               , inSession:= vbUserId :: TVarChar
                                                                                 ) AS tmp);
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inGoodsGroupId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������ �������>.';
     END IF;

     -- !!!������!!!
     IF zc_Enum_GlobalConst_isTerry() = FALSE
     THEN
         inGoodsName:= ioGoodsCode :: TVarChar;
     END IF;

     -- �������� - �������� ������ ���� �����������
     inGoodsName:= COALESCE (TRIM (inGoodsName), '');
     IF inGoodsName = '' THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inOperPriceList, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���� �������>. <%> <%> <%>', inGoodsName, inPriceJur, inOperPriceList;
     END IF;


     -- ��� �������� �� Sybase �.�. ��� ��� �� = 0
     IF vbUserId = zc_User_Sybase()
     THEN
         -- ����� - !!!��� ������!!! + inGoodsName + ioGoodsCode
         vbGoodsId:= (SELECT DISTINCT Object.Id
                      FROM Object
                           -- ����������� ������� �� ������
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId   = Object.Id
                                                         AND Object_PartionGoods.PartnerId = vbPartnerId -- ����� + ��� + �����
                      WHERE Object.DescId     = zc_Object_Goods()
                        AND Object.ValueData  = inGoodsName
                        AND Object.ObjectCode = -1 * ioGoodsCode
                     );
         -- ����� ����� - � �������� ��������
         vbGoodsId_old = (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId);


--         IF COALESCE (vbGoodsId, -1) <> COALESCE (vbGoodsId_old, -2) THEN
--            RAISE EXCEPTION '������.COALESCE (%, -1) <> COALESCE (%, -2)', vbGoodsId, vbGoodsId_old;
--         END IF;
--         -- ��������� ����� � <������ �������>
--         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, inGoodsGroupId);
--         -- RETURN;
--         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), vbGoodsId, lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent()));
--         -- �������� �� ���� ������� ������
--         UPDATE Object_PartionGoods SET GoodsGroupId         = inGoodsGroupId
--         WHERE Object_PartionGoods.GoodsId = vbGoodsId;
--         RETURN;


     ELSE
         -- ��������� !!!�� ���������!!!
         IF ioId > 0
         THEN -- ����� - � �������� ��������
              vbGoodsId_old = (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId);
         END IF;

         -- �����
         SELECT MIN (Object.Id), MAX (Object.Id)
                INTO vbId_min, vbId_max
         FROM Object
              -- ����������� ������� �� ������
              INNER JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId   = Object.Id
                                            AND Object_PartionGoods.PartnerId = vbPartnerId -- ����� + ��� + �����
              INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                    ON ObjectLink_Goods_GoodsGroup.ObjectId      = Object.Id
                                   AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                   AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId
         WHERE Object.DescId    = zc_Object_Goods()
           AND Object.ValueData = inGoodsName
         ;

         -- ��������
         IF vbId_min <> vbId_max
         THEN
             RAISE EXCEPTION '������.������� <%> ��� ���������� � ������ ������.', inGoodsName;
         END IF;

         -- �����
         IF inIsCode = TRUE
         THEN
              vbGoodsId:= (SELECT Object.Id
                           FROM Object
                                -- ������ ������
                                INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                      ON ObjectLink_Goods_GoodsGroup.ObjectId      = Object.Id
                                                     AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                                     AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId
                           WHERE Object.DescId     = zc_Object_Goods()
                             AND Object.ObjectCode = ioGoodsCode
                          );
              -- ��������
              IF COALESCE (vbGoodsId, 0) = 0
              THEN
                  RAISE EXCEPTION '������.��� ������ <%> � ������ <%> �� ������.', ioGoodsCode, lfGet_Object_ValueData_sh (inGoodsGroupId);
              END IF;
              -- !!!������!!!
              IF zc_Enum_GlobalConst_isTerry() = FALSE
              THEN
                  RAISE EXCEPTION '������.��� ����.';
              END IF;
         ELSE
             vbGoodsId:= vbId_max;
         END IF;

         -- ���� �� ����� - ���������� ����� "���������"
         IF COALESCE (vbGoodsId, 0) = 0
         THEN
             vbGoodsId:= (SELECT Object.Id
                          FROM Object
                               INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                     ON ObjectLink_Goods_GoodsGroup.ObjectId      = Object.Id
                                                    AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                                    AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId
                               -- ������
                               LEFT JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId   = Object.Id
                          WHERE Object.DescId    = zc_Object_Goods()
                            AND Object.ValueData = inGoodsName
                            AND Object_PartionGoods.GoodsId IS NULL
                         );
         END IF;

         -- ���� �� ����� � ������������� + �� ���� - ��������� ��� �� �����
         IF COALESCE (vbGoodsId, 0) = 0 AND ioId <> 0
         THEN
             -- ������� ������ � ���� �������
             IF (SELECT COUNT (*) FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_old AND Object_PartionGoods.MovementId = inMovementId)
              = (SELECT COUNT (*) FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = vbGoodsId_old)
             THEN
                 -- ��������� ��� �� �����
                 vbGoodsId:= vbGoodsId_old;
                 -- ������ ��� ��������, ���� ����
                 UPDATE Object SET ValueData = inGoodsName WHERE Object.Id = vbGoodsId AND Object.DescId = zc_Object_Goods() AND Object.ValueData <> inGoodsName;
                 -- ���� ��������� - ����
                 IF FOUND THEN
                   -- ��������� ��������
                   PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);
                 END IF;
             END IF;

         END IF;

     END IF;


     IF COALESCE (vbGoodsId, 0) = 0
     THEN
         -- ��������
         SELECT tmp.ioId, tmp.ioCode
                INTO vbGoodsId, ioGoodsCode
         FROM gpInsertUpdate_Object_Goods (ioId            := vbGoodsId
                                         , ioCode          := ioGoodsCode
                                         , inName          := inGoodsName
                                         , inGoodsGroupId  := inGoodsGroupId
                                         , inMeasureId     := inMeasureId
                                         , inCompositionId := vbCompositionId
                                         , inGoodsInfoId   := vbGoodsInfoId
                                         , inLineFabricaId := vbLineFabricaId
                                         , inLabelId       := vbLabelId
                                         , inSession       := inSession
                                         ) AS tmp;

     ELSE
         -- ���� ��������� - ������ �������
         IF inGoodsGroupId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_GoodsGroup()), 0)
         THEN
             -- ��������
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION '������.��� ���� ������ <%> ������ ������ ������.', ioGoodsCode;
             END IF;
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, inGoodsGroupId);
             -- ������������� - ������ �������� ������
             PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), vbGoodsId, lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent()));
         END IF;

         -- ���� ��������� - ������� ���������
         IF inMeasureId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure()), 0)
         THEN
             -- ��������
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION '������.��� ���� ������ <%> ������ ������ ������� ���������.', ioGoodsCode;
             END IF;
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), vbGoodsId, inMeasureId);
         END IF;

         -- ���� ��������� - ������ ������
         IF inIsCode = FALSE AND vbCompositionId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Composition()), 0)
         THEN
             -- ��������
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION '������.��� ���� ������ <%> ������ ������ ������ � <%> �� <%>.', ioGoodsCode
                               , lfGet_Object_ValueData_sh ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_Composition()))
                               , inCompositionName
                               ;
             END IF;
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Composition(), vbGoodsId, vbCompositionId);
         END IF;

         -- ���� ��������� - �������� ������
         IF vbGoodsInfoId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_GoodsInfo()), 0)
         THEN
             -- ��������
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION '������.��� ���� ������ <%> ������ ������ ��������.', ioGoodsCode;
             END IF;
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsInfo(), vbGoodsId, vbGoodsInfoId);
         END IF;

         -- ���� ��������� - ����� ���������
         IF vbLineFabricaId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId =  zc_ObjectLink_Goods_LineFabrica()), 0)
         THEN
             -- ��������
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION '������.��� ���� ������ <%> ������ ������ �����.', ioGoodsCode;
             END IF;
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink ( zc_ObjectLink_Goods_LineFabrica(), vbGoodsId, vbLineFabricaId);
         END IF;

         -- ���� ��������� - �������� ��� �������
         IF vbLabelId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId =  zc_ObjectLink_Goods_Label()), 0)
         THEN
             -- ��������
             IF inIsCode = TRUE
             THEN
                 RAISE EXCEPTION '������.��� ���� ������ <%> ������ ������ ��������.', ioGoodsCode;
             END IF;
             -- �������������
             PERFORM lpInsertUpdate_ObjectLink ( zc_ObjectLink_Goods_Label(), vbGoodsId, vbLabelId);
         END IF;

     END IF;


     -- ������ � ��������� - ������ ��� �������
     vbGoodsItemId:= lpInsertFind_Object_GoodsItem (inGoodsId      := vbGoodsId
                                                  , inGoodsSizeId  := vbGoodsSizeId
                                                  , inPartionId    := ioId
                                                  , inUserId       := vbUserId
                                                   );

     -- �������� - ���������� vbGoodsItemId
     IF vbUserId <> zc_User_Sybase()
        AND EXISTS (SELECT 1 FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND Object_PartionGoods.GoodsItemId = vbGoodsItemId AND Object_PartionGoods.MovementItemId <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION '������.� ��������� ��� ���� ����� <% %> �.<%>.������������ ���������.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND Object_PartionGoods.GoodsItemId = vbGoodsItemId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND Object_PartionGoods.GoodsItemId = vbGoodsItemId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND Object_PartionGoods.GoodsItemId = vbGoodsItemId))
                       ;
     END IF;


     -- ��������� !!!�� ���������!!!
     IF ioId > 0
     THEN -- ���� - � �������� ��������
          vbOperPriceList_old:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_OperPriceList());

     ELSE
         -- ��������
         IF 1 < (SELECT COUNT(*) FROM (SELECT DISTINCT MIF.ValueData
                                        FROM MovementItem
                                             LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.ObjectId   = vbGoodsId
                                          AND MovementItem.isErased   = FALSE
                                       ) AS tmp)
          THEN
             RAISE EXCEPTION '������.������� ��� �������: <%> � <%> ��� <%> � ��������� � <%> �� <%>.'
                           , (SELECT MIN (tmp.OperPriceList)
                              FROM (SELECT DISTINCT COALESCE (MIF.ValueData, 0) AS OperPriceList
                                    FROM MovementItem
                                         LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND MovementItem.ObjectId   = vbGoodsId
                                      AND MovementItem.isErased   = FALSE
                                   ) AS tmp)
                           , (SELECT MAX (tmp.OperPriceList)
                              FROM (SELECT DISTINCT COALESCE (MIF.ValueData, 0) AS OperPriceList
                                    FROM MovementItem
                                         LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND MovementItem.ObjectId   = vbGoodsId
                                      AND MovementItem.isErased   = FALSE
                                   ) AS tmp)
                           , lfGet_Object_ValueData (vbGoodsId)
                           , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                           , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                            ;
          END IF;

          -- ���� - � ������ ��������
          vbOperPriceList_old:= (SELECT DISTINCT MIF.ValueData
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.ObjectId   = vbGoodsId
                                   AND MovementItem.isErased   = FALSE
                                );
     END IF;

     -- �������� �������� <���� �� ����������>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;

     -- ���������� % ������� / ������� �� ����� ���������
     vbChangePercent := COALESCE ((SELECT MovementFloat.ValueData
                                   FROM MovementFloat
                                   WHERE MovementFloat.MovementId = inMovementId
                                     AND MovementFloat.DescId = zc_MovementFloat_ChangePercent()
                                   )
                                  , 0);
     -- ������ ��. ���� �� �������
     vbOperPrice := (inPriceJur + inPriceJur / 100 * vbChangePercent) :: TFloat;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := vbGoodsId
                                              , inAmount             := inAmount
                                              , inOperPrice          := vbOperPrice
                                              , inCountForPrice      := inCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );


     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceJur(), ioId, inPriceJur);

     -- c�������� Object_PartionGoods + Update ��-�� � ��������� ������ ����� vbGoodsId + Update ���� � �������
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId     := ioId
                                               , inMovementId         := inMovementId
                                               , inPartnerId          := vbPartnerId
                                               , inUnitId             := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inOperDate           := vbOperDate
                                               , inGoodsId            := COALESCE (vbGoodsId, 0)
                                               , inGoodsId_old        := COALESCE (vbGoodsId_old, 0)
                                               , inGoodsItemId        := vbGoodsItemId
                                               , inCurrencyId         := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument())
                                               , inAmount             := inAmount
                                               , inOperPrice          := vbOperPrice
                                               , inCountForPrice      := inCountForPrice
                                               , inOperPriceList      := COALESCE (inOperPriceList, 0)
                                               , inOperPriceList_old  := COALESCE (vbOperPriceList_old, 0)
                                               , inBrandId            := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Brand())
                                               , inPeriodId           := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Period())
                                               , inPeriodYear         := (SELECT ObF.ValueData FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbPartnerId AND ObF.DescId = zc_ObjectFloat_Partner_PeriodYear()) :: Integer
                                               , inFabrikaId          := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Fabrika())
                                               , inGoodsGroupId       := inGoodsGroupId
                                               , inMeasureId          := inMeasureId
                                               , inCompositionId      := vbCompositionId
                                               , inGoodsInfoId        := vbGoodsInfoId
                                               , inLineFabricaId      := vbLineFabricaId
                                               , inLabelId            := vbLabelId
                                               , inCompositionGroupId := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbCompositionId AND OL.DescId = zc_ObjectLink_Composition_CompositionGroup())
                                               , inGoodsSizeId        := vbGoodsSizeId
                                               , inJuridicalId        := inJuridicalId
                                               , inUserId             := vbUserId
                                                );


     -- �� ���� ������� ��������� OperPriceList - �� ��� �������� �� Sybase �.�. ��� ???
     IF 1=1 -- vbUserId <> zc_User_Sybase()
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), MovementItem.Id, inOperPriceList)
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.ObjectId   = vbGoodsId
           AND MovementItem.Id         <> ioId
           AND COALESCE (MIF.ValueData, 0) <> inOperPriceList
        ;
     END IF;


     -- �������� - ������ = Id
     UPDATE MovementItem SET PartionId = ioId WHERE MovementItem.Id = ioId AND MovementItem.PartionId IS NULL;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 05.02.19         *
 11.05.17                                                        *
 10.05.17                                                        *
 24.04.17                                                        *
 10.04.17         *
*/

/*
-- SELECT  lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), tmp.Id, tmp.PriceOk)
-- from (
SELECT Object_Goods.*, Object_GoodsSize.ValueData, Movement.OperDate, Movement.InvNumber
, ObjectHistoryFloat_PriceListItem_Value.ValueData, Object_PartionGoods .OperPriceList , MIFloat_OperPriceList.ValueData as PriceOk
, Object_PartionGoods .OperPrice , MIFloat_OperPrice.ValueData as PriceInOk
, ObjectHistory_PriceListItem.*
, Object_PartionGoods.*
FROM Object_PartionGoods
     join Object AS Object_Goods on Object_Goods.Id = Object_PartionGoods.GoodsId
     join Object AS Object_GoodsSize on Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId

     join Movement ON Movement.Id = MovementId

     join MovementItemFloat AS MIFloat_OperPriceList
          ON MIFloat_OperPriceList.MovementItemId = Object_PartionGoods .MovementItemId
          AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

     join MovementItemFloat AS MIFloat_OperPrice
          ON MIFloat_OperPrice.MovementItemId = Object_PartionGoods .MovementItemId
          AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()

                   inner join ObjectLink AS ObjectLink_PriceListItem_PriceList
                      on ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                     -- AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate = zc_DateStart())
                        inner JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                             ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                            AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                            AND ObjectLink_PriceListItem_Goods.ChildObjectId = Object_PartionGoods.GoodsId

                        LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                               AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                               AND CURRENT_DATE >= ObjectHistory_PriceListItem.StartDate AND CURRENT_DATE < ObjectHistory_PriceListItem.EndDate
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                     ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                    AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()




WHERE Object_PartionGoods.PeriodYear = 2019
-- and Object_PartionGoods .MovementItemId = 1707494
-- and Object_PartionGoods.OperPriceList <> MIFloat_OperPriceList.ValueData and ObjectHistory_PriceListItem.StartDate = zc_DateStart()
-- and Object_PartionGoods .OperPriceList  <> ObjectHistoryFloat_PriceListItem_Value.ValueData
 and Object_PartionGoods .OperPrice  <> MIFloat_OperPrice.ValueData
order by 3, Object_GoodsSize.ValueData
-- ) as tmp
*/
/*
-- !!!ERROR!!!
select distinct Object_PartionGoods.GoodsSizeId, CLO.ObjectId, *
from Container
join Object_PartionGoods on Object_PartionGoods.MovementItemId = Container.PartionId
left join ContainerLinkObject as CLO on CLO.ContainerId = Container.Id and CLO.DescId = 14 -- zc_ContainerLinkObject_GoodsSize
-- inner join MovementItemContainer on MovementItemContainer.ContainerId = Container.Id
 where Container.Id = 2431697
 and coalesce (Object_PartionGoods.GoodsSizeId, 0) <> coalesce (CLO.ObjectId, 0)
-- where coalesce (Object_PartionGoods.GoodsSizeId, 0) <> coalesce (CLO.ObjectId, 0)
*/
-- ����
-- SELECT * FROMgpInsertUpdate_MIEdit_Income()

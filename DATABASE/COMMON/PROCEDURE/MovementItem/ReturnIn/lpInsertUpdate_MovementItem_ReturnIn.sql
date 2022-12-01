-- Function: lpInsertUpdate_MovementItem_ReturnIn()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, TFloat, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
 INOUT ioPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inMovementId_Partion  Integer   , -- Id ��������� �������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
 INOUT ioMovementId_Promo    Integer   ,
 INOUT ioChangePercent       TFloat    , -- (-)% ������ (+)% �������
   OUT outPricePromo         TFloat    ,
    IN inIsCheckPrice        Boolean   , --
   OUT outGoodsRealCode      Integer  , -- ����� (���� ��������)
   OUT outGoodsRealName      TVarChar  , -- ����� (���� ��������)
   OUT outGoodsKindRealName  TVarChar  , -- ��� ������ (���� ��������) 
    IN inUserId              Integer     -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsKindRealId Integer;
   DECLARE vbGoodsRealId Integer;
BEGIN
     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.����� �� ���������.';
     END IF;

     -- �������� zc_ObjectBoolean_GoodsByGoodsKind_Order
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId = zc_MovementLinkObject_To()
                  AND MLO.ObjectId IN (SELECT tt.UnitId FROM Object_Unit_check_isOrder_View_two AS tt)
               )
AND NOT EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                     INNER JOIN ObjectString AS ObjectString_GLNCode
                                             ON ObjectString_GLNCode.ObjectId  = MLO.ObjectId
                                            AND ObjectString_GLNCode.DescId    IN (zc_ObjectString_Partner_GLNCode(), zc_ObjectString_Partner_GLNCodeJuridical())
                                            AND ObjectString_GLNCode.ValueData <> ''
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId = zc_MovementLinkObject_From()
               )
-- AND inUserId IN (5, 6604558, 8056474)
     THEN
         -- ���� ������ � ��� ������ ��� � zc_ObjectBoolean_GoodsByGoodsKind_Order - ����� �������
          IF NOT EXISTS (SELECT 1
                         FROM ObjectBoolean AS ObjectBoolean_Order
                              INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                         WHERE ObjectBoolean_Order.ValueData = TRUE
                           AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                           AND Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
                           AND COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) = COALESCE (inGoodsKindId,0)
                        )  
               AND EXISTS (SELECT 1 FROM ObjectLink AS OL
                                    WHERE OL.ObjectId = inGoodsId
                                      AND OL.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                      AND OL.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                           --, zc_Enum_InfoMoney_30102() -- �������
                                                             , zc_Enum_InfoMoney_20901() -- ����
                                                              )
                          )
         THEN
              RAISE EXCEPTION '������.��� ������ <%>% ������ �������� ��� = <%>.'
                             , lfGet_Object_ValueData (inGoodsId)
                             , CHR (13)
                             , lfGet_Object_ValueData_sh (inGoodsKindId)
                             /*, CHR (13)
                             , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_ReturnIn())
                             , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                             , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                             , CHR (13)
                             , (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())*/
                              ;
         END IF;
     END IF;

     -- �������� zc_ObjectBoolean_GoodsByGoodsKind_Order ��� ������������� �� Object_Unit_check_isOrder_View
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO 
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId = zc_MovementLinkObject_To()
                  AND MLO.ObjectId IN (SELECT tt.UnitId FROM Object_Unit_check_isOrder_View AS tt)
                )
     THEN   
         --���� ������ � ���� ������  ��� � zc_ObjectBoolean_GoodsByGoodsKind_Order  - ����� �������
         IF NOT EXISTS (SELECT 1
                        FROM ObjectBoolean AS ObjectBoolean_Order
                             INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                        WHERE ObjectBoolean_Order.ValueData = TRUE
                          AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                          AND Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
                          AND COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) = COALESCE (inGoodsKindId,0)
                        )
         THEN
             RAISE EXCEPTION '������.� ������ <%> <%> �� ����������� �������� ������������ � �������.% % � % �� % % %'
                            , lfGet_Object_ValueData (inGoodsId)
                            , lfGet_Object_ValueData_sh (inGoodsKindId)
                            , CHR (13)
                            , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_ReturnIn()) 
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                            , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                            , CHR (13)
                            , (SELECT Object.ValueData 
                               FROM MovementLinkObject AS MLO
                                  LEFT JOIN Object ON Object.Id = MLO.ObjectId
                               WHERE MLO.MovementId = inMovementId
                                 AND MLO.DescId = zc_MovementLinkObject_To())
                            ;
         END IF;
     END IF;


     -- ��������� ����� - �� "���� ��������� � �����������"
     SELECT tmp.MovementId
          , CASE WHEN tmp.isChangePercent = TRUE
                      THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0)
                 ELSE 0
            END
          , ioPrice
            INTO ioMovementId_Promo, ioChangePercent, outPricePromo
     FROM lpGet_Movement_Promo_Data_all (inOperDate     := (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner())
                                       , inPartnerId    := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                       , inContractId   := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                       , inUnitId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                       , inGoodsId      := inGoodsId
                                       , inGoodsKindId  := inGoodsKindId
                                       , inIsReturn     := TRUE
                                        ) AS tmp
     -- !!!������ ���� ������������� ����!!!
     WHERE ioPrice = CASE WHEN TRUE = (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT())
                               THEN tmp.PriceWithVAT
                          WHEN 1=1
                               THEN tmp.PriceWithOutVAT
                          ELSE 0 -- ???����� ���� ����� ����� �� ������ ����� ���� ����� ��� ����� ������� ��� ��� �����???
                     END
    ;
     -- !!!� ���� ������ - ������ �� ���������!!!
     IF zc_isReturnInNAL_bySale() > (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
        OR COALESCE (ioMovementId_Promo, 0) = 0
     THEN ioChangePercent:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0); END IF;
     

     -- 
   /*IF COALESCE (ioMovementId_Promo, 0) = 0 AND inIsCheckPrice = TRUE
     THEN
          -- !!!������!!!
          ioPrice:= lpGet_ObjectHistory_Price_check (inMovementId            := inMovementId
                                                   , inMovementItemId        := ioId
                                                   , inContractId            := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                   , inPartnerId             := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                   , inMovementDescId        := zc_Movement_ReturnIn()
                                                   , inOperDate_order        := NULL
                                                   , inOperDatePartner       := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner()) 
                                                   , inDayPrior_PriceReturn  := 14
                                                   , inIsPrior               := FALSE -- !!!���������� �� ������ ���!!!
                                                   , inOperDatePartner_order := NULL
                                                   , inGoodsId               := inGoodsId
                                                   , inGoodsKindId           := inGoodsKindId
                                                   , inPrice                 := ioPrice
                                                   , inCountForPrice         := 1
                                                   , inUserId                := inUserId
                                                    );
     END IF;*/

     -- ��� ��������� ObjectId �/��� � zc_MILinkObject_GoodsKind
     -- ������� � ��������� ����������� �� zc_ObjectLink_GoodsByGoodsKind_GoodsReal + zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal ���� ��� ���� + ��� ���������� � Juridical_isNotRealGoods
     IF '01.12.2022' <= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
    AND NOT EXISTS (SELECT 1
                    FROM MovementLinkObject AS MLO
                        INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                              ON ObjectLink_Partner_Juridical.ObjectId = MLO.ObjectId
                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                        INNER JOIN ObjectBoolean AS ObjectBoolean_isNotRealGoods
                                                 ON ObjectBoolean_isNotRealGoods.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId 
                                                AND ObjectBoolean_isNotRealGoods.DescId = zc_ObjectBoolean_Juridical_isNotRealGoods()
                                                AND ObjectBoolean_isNotRealGoods.ValueData = TRUE
                    WHERE MLO.MovementId = inMovementId
                      AND MLO.DescId = zc_MovementLinkObject_From()
                    ) 
        /*AND ( (inGoodsId <> (SELECT MI.ObjectId FROM MovementItem AS MI WHERE MI.Id = ioId))
              (COALESCE (inGoodsKindId,0) <> COALESCE ((SELECT MILO
                                                        FROM MovementItemLinkObject AS MILO
                                                        WHERE MILO.MovementItemId = ioId
                                                          AND MILO.DescId = zc_MILinkObject_GoodsKind()) , 0 ) )
            ) */
     THEN   
         SELECT ObjectLink_GoodsByGoodsKind_GoodsReal.ChildObjectId     AS GoodsRealId
              , ObjectLink_GoodsByGoodsKind_GoodsKindReal.ChildObjectId AS GoodsKindRealId
                INTO vbGoodsRealId, vbGoodsKindRealId
         FROM Object_GoodsByGoodsKind_View
              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsReal
                                   ON ObjectLink_GoodsByGoodsKind_GoodsReal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                  AND ObjectLink_GoodsByGoodsKind_GoodsReal.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsReal()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindReal
                                   ON ObjectLink_GoodsByGoodsKind_GoodsKindReal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKindReal.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal()
         WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
           AND COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) = COALESCE (inGoodsKindId,0);
           
         SELECT tmp.ObjectCode, tmp.ValueData
       INTO outGoodsRealCode, outGoodsRealName
         FROM Object AS tmp
         WHERE tmp.Id = vbGoodsRealId;
         outGoodsKindRealName := (SELECT tmp.ValueData FROM Object AS tmp WHERE tmp.Id = vbGoodsKindRealId)::TVarChar;
     END IF;
        
     ---

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, ioPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- ��������� �������� <���������� ������� ��� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
     -- ��������� �������� <���������� �����>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     -- ��������� �������� <id ��������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_Partion);



     -- !!!������ ����� ����� - ��� � ��������� � ��������!!!
     -- ��������� �������� <(-)% ������ (+)% �������> 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, ioChangePercent);
     -- ��������� �������� <MovementId-�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, COALESCE (ioMovementId_Promo, 0));



     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);


     -- ��������� ����� � <����� ((���� ��������))>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsReal(), ioId, vbGoodsRealId);
     -- ��������� ����� � <���� ������� (���� ��������)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindReal(), ioId, vbGoodsKindRealId);

     
     -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)>
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     /*IF inGoodsId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;*/

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmountPartner * ioPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmountPartner * ioPrice AS NUMERIC (16, 2))
                      END;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 02.10.22         * outGoodsRealName, outGoodsKindRealName
 26.07.22         * inCount
 27.04.15         * add inMovementId
 11.05.14                                        * change ioCountForPrice
 07.05.14                                        * add lpInsert_MovementItemProtocol
 08.04.14                                        * rem ������� ������ <����� ������ � ���� �������>
 14.02.14                                                         * add ioCountForPrice
 13.02.14                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, ioPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')

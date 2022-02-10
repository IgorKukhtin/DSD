-- Function: gpInsert_Scale_Movement_all()

-- DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_test (Integer, Integer, Boolean);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax_From_Kind_test (Integer, Integer, Integer, TDateTime, Integer);

DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_Movement_all(
    IN inBranchCode          Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId_begin    Integer
             , isExportEmail       Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbBranchId         Integer;
   DECLARE vbIsUnitCheck      Boolean;
   DECLARE vbIsSendOnPriceIn  Boolean;
   DECLARE vbIsProductionIn   Boolean;

   DECLARE vbMovementId_find    Integer;
   DECLARE vbMovementId_begin   Integer;
   DECLARE vbMovementDescId     Integer;
   DECLARE vbIsTax              Boolean;

   DECLARE vbGoodsId_err     Integer;
   DECLARE vbGoodsKindId_err Integer;
   DECLARE vbAmount_err      TFloat;
   DECLARE vbTaxDoc_err      TFloat;
   DECLARE vbTaxMI_err      TFloat;

   DECLARE vbOperDate_scale TDateTime;
   DECLARE vbOperDatePartner_order TDateTime;
   DECLARE vbOperDate_order TDateTime;
   DECLARE vbId_tmp Integer;
   DECLARE vbGoodsId_ReWork Integer;

   DECLARE vbOperDate_StartBegin TDateTime;
   
   DECLARE vbKeyData TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� ��������� ����� ������ ���������� ����.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();



     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ ��� ���������.';
     END IF;

     -- ��������
     IF inBranchCode <> COALESCE((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_BranchCode()), inBranchCode)
     THEN
         /*IF inBranchCode = 7
         THEN
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BranchCode(), inMovementId, inBranchCode);
         ELSE*/
             RAISE EXCEPTION '������.� ��� � ���������� ��� ������� = <%>.�������� ����� ������� �� ���������� ��� ��� ������� = <%>.'
                           , inBranchCode
                           , zfConvert_FloatToString ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_BranchCode()))
                            ;
       --END IF;
     END IF;


     -- �������� - ������� �� ���������
     IF EXISTS(SELECT 1
               FROM MovementLinkMovement AS MovementLinkMovement_Order
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = MovementLinkMovement_Order.MovementChildId
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                         ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                        AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                    LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
               WHERE MovementLinkMovement_Order.MovementId = inMovementId
                 AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                 AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- ������������� + ���������
              )
     THEN
         RAISE EXCEPTION '������.� ������ ������ ������������ � �������� = <%> <%>.', lfGet_Object_ValueData ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_Contract())), lfGet_Object_ValueData (zc_Enum_InfoMoneyDestination_21500());
     END IF;


     -- ����������
     vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                       ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                  END;
     -- ���������� <��� ���������>
     vbMovementDescId:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_MovementDesc()) :: Integer;
     -- ���������� <�����������>
     vbGoodsId_ReWork:= (SELECT CASE WHEN TRIM (tmp.RetV) = '' THEN '0' ELSE TRIM (tmp.RetV) END :: Integer
                         FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'Scale_' || inBranchCode
                                                               , inLevel2      := 'Movement'
                                                               , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                               , inItemName    := 'GoodsId_ReWork'
                                                               , inDefaultValue:= '0'
                                                               , inSession     := inSession
                                                                ) AS RetV
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId = inMovementId
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                 AND MovementFloat.ValueData > 0
                              ) AS tmp
                        );
     -- !!!�������� ��������!!! : ������� -> ����������� �� ����
     IF vbMovementDescId = zc_Movement_Sale() AND EXISTS (SELECT MLM_Order.MovementChildId
                                                          FROM MovementLinkMovement AS MLM_Order
                                                               INNER JOIN MovementLinkObject AS MLO ON MLO.MovementId = MLM_Order.MovementChildId AND MLO.DescId = zc_MovementLinkObject_From()
                                                               INNER JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Unit()
                                                          WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                                         )
     THEN
         vbMovementDescId:= zc_Movement_SendOnPrice();
     END IF;

     -- !!!�������� ��������!!! : ����������� -> ������������ �����������
     IF vbMovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion()) AND vbGoodsId_ReWork > 0
     THEN
         -- ��������
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                               ON ObjectLink_Goods_InfoMoney.ObjectId      = MovementItem.ObjectId
                                              AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                              AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() -- ��������� ����
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSe
                   )
         THEN
             RAISE EXCEPTION '������.� �������� �� ����� ����������� ������ � �� = <%>', lfGet_Object_ValueData_sh (zc_Enum_InfoMoney_20501());
         END IF;
         --
         vbMovementDescId:= zc_Movement_ProductionUnion();
         vbIsProductionIn:= FALSE;
     ELSE
         vbIsProductionIn:= NULL;
     END IF;

     -- �������� - ���������� ��������
     IF vbMovementDescId = zc_Movement_Sale() -- AND vbUserId = 5
     THEN
         WITH -- GoodsProperty
              tmpGoodsProperty AS (SELECT zfCalc_GoodsPropertyId ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                                , (SELECT OL_Juridical.ChildObjectId FROM MovementLinkObject AS MLO LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical() WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                                , (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                                 ) AS GoodsPropertyId
                                  )
              -- MovementItem
            , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                             , MovementItem.ObjectId                         AS GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             -- , MovementItem.Amount                        AS Amount
                             , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS Amount
                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                             INNER JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                            ON MIBoolean_BarCode.MovementItemId = MovementItem.Id
                                                           AND MIBoolean_BarCode.DescId         = zc_MIBoolean_BarCode()
                                                           AND MIBoolean_BarCode.ValueData      = TRUE
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSe
                       )
              -- ���������� ��������
            , tmpAmountDoc AS (SELECT DISTINCT
                                      ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                     AS GoodsId
                                    , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)   AS GoodsKindId
                                    , ObjectFloat_AmountDoc.ValueData * (1 - tmpGoodsProperty.TaxDoc / 100) AS AmountStart
                                    , ObjectFloat_AmountDoc.ValueData * (1 + tmpGoodsProperty.TaxDoc / 100) AS AmountEnd
                                    , ObjectFloat_AmountDoc.ValueData                                       AS AmountDoc
                                    , tmpGoodsProperty.TaxDoc                                               AS TaxDoc
                                    , tmpMI.Amount                                                          AS Amount
                                    -- , tmpMI.AmountPartner                                                AS AmountPartner
                               FROM (SELECT OFl.ObjectId AS GoodsPropertyId, OFl.ValueData AS TaxDoc
                                     FROM tmpGoodsProperty
                                          INNER JOIN ObjectFloat AS OFl
                                                                 ON OFl.ObjectId  = tmpGoodsProperty.GoodsPropertyId
                                                                AND OFl.DescId    = zc_ObjectFloat_GoodsProperty_TaxDoc()
                                                                AND OFl.ValueData > 0
                                    ) AS tmpGoodsProperty
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                          ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                         AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                                                          ON ObjectFloat_AmountDoc.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                         AND ObjectFloat_AmountDoc.DescId   = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                         ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                        AND ObjectLink_GoodsPropertyValue_Goods.DescId   = zc_ObjectLink_GoodsPropertyValue_Goods()
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                         ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                        AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                    INNER JOIN tmpMI ON tmpMI.GoodsId     = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
                                                    AND tmpMI.GoodsKindId = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId
                               WHERE ObjectFloat_AmountDoc.ValueData > 0
                              )

         SELECT tmpAmountDoc.GoodsId, tmpAmountDoc.GoodsKindId, tmpAmountDoc.Amount, tmpAmountDoc.TaxDoc, tmpAmountDoc.Amount / tmpAmountDoc.AmountDoc * 100 - 100
                INTO vbGoodsId_err, vbGoodsKindId_err, vbAmount_err, vbTaxDoc_err, vbTaxMI_err
         FROM tmpAmountDoc
              LEFT JOIN MovementLinkObject AS MLO ON MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract()
              LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MLO.ObjectId
         WHERE tmpAmountDoc.AmountStart > 0 AND NOT (tmpAmountDoc.Amount BETWEEN tmpAmountDoc.AmountStart AND tmpAmountDoc.AmountEnd)
           AND COALESCE (Object_Contract.ValueData, '') NOT ILIKE '%�����%'
         LIMIT 1
         ;
         --
         IF vbGoodsId_err > 0
         THEN
             RAISE EXCEPTION '������.������������ ���%<%> <%> ���-�� = <%>%���������� ����.���������� = <%>%���� ����.���������� = <%>.'
                           , CHR (13)
                           , lfGet_Object_ValueData (vbGoodsId_err)
                           , lfGet_Object_ValueData (vbGoodsKindId_err)
                           , zfConvert_FloatToString (vbAmount_err)
                           , CHR (13)
                           , zfConvert_FloatToString (vbTaxDoc_err)
                           , CHR (13)
                           , zfConvert_FloatToString (vbTaxMI_err)
                           ;
         END IF;

     END IF;


     -- �������� + ����������� <�������>
     IF EXISTS (SELECT 1
                FROM MovementLinkMovement AS MovementLinkMovement_Order
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_find
                                                  ON MovementLinkObject_Contract_find.MovementId = MovementLinkMovement_Order.MovementChildId
                                                 AND MovementLinkObject_Contract_find.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = inMovementId
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_Contract.ObjectId <> MovementLinkObject_Contract_find.ObjectId)
     THEN
         -- ��������� ����� � <�������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, MovementLinkObject_Contract_find.ObjectId)
         FROM MovementLinkMovement AS MovementLinkMovement_Order
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_find
                                                  ON MovementLinkObject_Contract_find.MovementId = MovementLinkMovement_Order.MovementChildId
                                                 AND MovementLinkObject_Contract_find.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = inMovementId
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_Contract.ObjectId <> MovementLinkObject_Contract_find.ObjectId;
     END IF;

     -- �������� + ����������� <�� ���� (�����)>
     /*IF vbMovementDescId = zc_Movement_Sale()
    AND EXISTS (SELECT 1
                FROM MovementLinkMovement AS MovementLinkMovement_Order
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                  ON MovementLinkObject_To_find.MovementId = MovementLinkMovement_Order.MovementChildId
                                                 AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = inMovementId
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_From.ObjectId <> MovementLinkObject_To_find.ObjectId)
     THEN
          -- ��������� ����� � <�� ���� (�����)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inMovementId, MovementLinkObject_To_find.ObjectId)
         FROM MovementLinkMovement AS MovementLinkMovement_Order
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To_find
                                                  ON MovementLinkObject_To_find.MovementId = MovementLinkMovement_Order.MovementChildId
                                                 AND MovementLinkObject_To_find.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = inMovementId
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_From.ObjectId <> MovementLinkObject_To_find.ObjectId;
     END IF;*/

     -- �������� + ����������� <���� (����������)>
     IF vbMovementDescId = zc_Movement_Sale()
    AND EXISTS (SELECT 1
                FROM MovementLinkMovement AS MovementLinkMovement_Order
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                  ON MovementLinkObject_From_find.MovementId = MovementLinkMovement_Order.MovementChildId
                                                 AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = inMovementId
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_To.ObjectId <> MovementLinkObject_From_find.ObjectId)
     THEN
         -- ��������� ����� � <���� (����������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inMovementId, MovementLinkObject_From_find.ObjectId)
         FROM MovementLinkMovement AS MovementLinkMovement_Order
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                  ON MovementLinkObject_From_find.MovementId = MovementLinkMovement_Order.MovementChildId
                                                 AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = inMovementId
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_To.ObjectId <> MovementLinkObject_From_find.ObjectId;
     END IF;



     -- !!!���������!!
     vbOperDate_scale:= inOperDate;
     -- !!!������������ OperDate ������, !!!����� inOperDate!!!
     vbOperDate_order:= COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.DescId = zc_Movement_OrderExternal() AND Movement.Id = (SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()))
                                , inOperDate);
     -- !!!������������ OperDatePartner ������, !!!����� inOperDate!!!
     vbOperDatePartner_order:= COALESCE ((SELECT MovementDate.ValueData FROM MovementDate JOIN Movement ON Movement.Id = MovementDate.MovementId AND Movement.DescId = zc_Movement_OrderExternal() WHERE MovementDate.DescId = zc_MovementDate_OperDatePartner() AND MovementDate.MovementId = (SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()))
                                       , inOperDate);
     -- !!!���� �� ������, ����� ������� �� �� OperDatePartner, ������ - ���� ������ ��� ��������!!!
     inOperDate:= CASE WHEN vbBranchId   = zc_Branch_Basis()
                         -- AND inSession <> '5'
                         AND EXISTS (SELECT 1
                                     FROM MovementLinkMovement
                                          INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                          ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                         AND MovementLinkMovement_Order.DescId          = zc_MovementLinkMovement_Order()
                                          INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Order.MovementId
                                                             AND Movement.DescId   = zc_Movement_Sale()
                                                             AND Movement.OperDate = inOperDate - INTERVAL '1 DAY'
                                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                                     WHERE MovementLinkMovement.MovementId = inMovementId
                                       AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Order()
                                    )
                            THEN inOperDate - INTERVAL '1 DAY' -- !!!�������� �� 1 ����, �.�. �� ������ ������� �� 8:00!!!

                       WHEN vbBranchId   = zc_Branch_Basis()
                         OR inBranchCode = 2 -- ������ ����
                            THEN inOperDate

                       ELSE vbOperDatePartner_order
                  END;

     -- ������� - "��������� �������"
     /*CREATE TEMP TABLE _tmpUnit_check (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_check (UnitId)
        SELECT 301309 -- 22121	����� �� �.���������
       UNION
        SELECT 309599 -- 22122	����� ��������� �.���������

       UNION
        SELECT 346093 -- 22081	����� �� �.������
       UNION
        SELECT 346094 -- 22082	����� ��������� �.������

       UNION
        SELECT 8413   -- ����� �� �.������ ���
       UNION
        SELECT 428366 -- ����� ��������� �.������ ���

       UNION
        SELECT 8417   -- ����� �� �.�������� (������)
       UNION
        SELECT 428364 -- ����� ��������� �.�������� (������)

       UNION
        SELECT 8425   -- ����� �� �.�������
       UNION
        SELECT 409007 -- ����� ��������� �.�������

       UNION
        SELECT 8415   -- ����� �� �.�������� (����������)
       UNION
        SELECT 428363 -- ����� ��������� �.�������� (����������)

       UNION
        SELECT 8411   -- ����� �� �.����
       UNION
        SELECT 428365 -- ����� ��������� �.����
    ;*/


     -- ������������ ������� "��������� ��������� - ��/���"
     IF vbMovementDescId = zc_Movement_Sale()
     THEN           -- ���� � ��������
          vbIsTax:= LOWER ((SELECT gpGet_ToolsWeighing_Value ('Scale_'||inBranchCode, 'Default', '', 'isTax', 'FALSE', inSession))) = LOWER ('TRUE')
                    -- ���� � ����������� ��� �������� "�������"
                AND NOT EXISTS (SELECT ObjectBoolean_isTaxSummary.ValueData
                                FROM MovementLinkObject AS MovementLinkObject_To
                                     INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_isTaxSummary
                                                              ON ObjectBoolean_isTaxSummary.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                             AND ObjectBoolean_isTaxSummary.DescId = zc_ObjectBoolean_Juridical_isTaxSummary()
                                                             AND ObjectBoolean_isTaxSummary.ValueData = TRUE
                                WHERE MovementLinkObject_To.MovementId = inMovementId
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               )
                    -- ���� ��
                AND EXISTS (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PaidKind() AND ObjectId = zc_Enum_PaidKind_FirstForm())
                    -- ���� �� ��������� � �.�.
                AND EXISTS (SELECT MovementItem.ObjectId FROM MovementItem INNER JOIN MovementItemFloat AS MIFloat_Price ON MIFloat_Price.MovementItemId = MovementItem.Id AND MIFloat_Price.DescId = zc_MIFloat_Price() AND MIFloat_Price.ValueData <> 0 WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE)
               ;
     ELSE vbIsTax:= FALSE;
     END IF;


     IF vbMovementDescId = zc_Movement_Sale()
     THEN
          IF 1 <(SELECT COUNT(*) FROM MovementLinkMovement
                                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                     ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                     INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                        AND Movement.DescId = zc_Movement_Sale()
                                                        AND Movement.OperDate = inOperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                WHERE MovementLinkMovement.MovementId = inMovementId
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order())
          THEN
              RAISE EXCEPTION '������. ������� ��������� ���������� ������� ��� ������ � <%>'
                             , (SELECT Movement.InvNumber
                                FROM MovementLinkMovement
                                     INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                WHERE MovementLinkMovement.MovementId = inMovementId
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                LIMIT 1
                               );
          END IF;
          -- ����� ������������� ��������� <������� ����������> �� ������
          vbMovementId_find:= (SELECT Movement.Id
                                FROM MovementLinkMovement
                                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                     ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                     INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                        AND Movement.DescId = zc_Movement_Sale()
                                                        AND Movement.OperDate = inOperDate -- BETWEEN inOperDate - INTERVAL '1 DAY' AND inOperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                WHERE MovementLinkMovement.MovementId = inMovementId
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                  -- AND inSession <> '5'
                              );
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
     IF vbMovementDescId = zc_Movement_ReturnIn()
     THEN
          -- ����� ������������� ��������� <ReturnIn> �� ReturnIn
          vbMovementId_find:= (SELECT Movement.Id
                                FROM MovementLinkMovement
                                     INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                        AND Movement.DescId = zc_Movement_ReturnIn()
                                                      --AND Movement.OperDate = inOperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_Erased(), zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                WHERE MovementLinkMovement.MovementId = inMovementId
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                  -- AND inSession <> '5'
                              );
          -- ������� ���� ������
          IF vbMovementId_find > 0
          THEN
              UPDATE Movement SET OperDate = inOperDate WHERE Movement.Id = vbMovementId_find;
          END IF;

     END IF;

     -- ��� <����������� �� ����>
     IF vbMovementDescId = zc_Movement_SendOnPrice()
     THEN
          IF EXISTS (SELECT MLM_Order.MovementChildId
                     FROM MovementLinkMovement AS MLM_Order
                          JOIN Movement ON Movement.Id = MLM_Order.MovementChildId
                                       AND Movement.DescId = zc_Movement_SendOnPrice()
                                       AND Movement.OperDate BETWEEN inOperDate - INTERVAL '20 DAY' AND inOperDate
                     WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                    )
          THEN
              -- �� ��������� <����������� �� ����> - ����� ������������� ��������� <����������� �� ����> !!!����� �������� ����!!!
              vbMovementId_find:= (SELECT MLM_Order.MovementChildId
                                   FROM MovementLinkMovement AS MLM_Order
                                   WHERE MLM_Order.MovementId = inMovementId
                                     AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()
                                  );
          ELSE
              -- ��������
              IF 1 < (SELECT COUNT(*)
                      FROM MovementLinkMovement
                            INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                            ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                           AND MovementLinkMovement_Order.DescId          = zc_MovementLinkMovement_Order()
                            INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Order.MovementId
                                               AND Movement.DescId   = zc_Movement_SendOnPrice()
                                               AND Movement.OperDate = inOperDate
                                               AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                      WHERE MovementLinkMovement.MovementId = inMovementId
                        AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Order()
                     )
               --OR vbUserId = 5
              THEN
                  RAISE EXCEPTION '������.��� ������ � <%> �� <%> ������������ 2 ���������: <� % �� %> + <� % �� %>'
                                , (SELECT Movement.InvNumber FROM MovementLinkMovement AS MLM_Order JOIN Movement ON Movement.Id = MLM_Order.MovementChildId WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order())
                                , (SELECT zfConvert_DateToString (Movement.OperDate) FROM MovementLinkMovement AS MLM_Order JOIN Movement ON Movement.Id = MLM_Order.MovementChildId WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order())
                                  -- 1.1.
                                , (SELECT Movement.InvNumber
                                   FROM MovementLinkMovement
                                        INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                        ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                       AND MovementLinkMovement_Order.DescId          = zc_MovementLinkMovement_Order()
                                        INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Order.MovementId
                                                           AND Movement.DescId   = zc_Movement_SendOnPrice()
                                                           AND Movement.OperDate = inOperDate
                                                           AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                   WHERE MovementLinkMovement.MovementId = inMovementId
                                     AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Order()
                                   ORDER BY Movement.Id DESC
                                   LIMIT 1
                                  )
                                  -- 1.2.
                                , (SELECT zfConvert_DateToString (Movement.OperDate)
                                   FROM MovementLinkMovement
                                        INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                        ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                       AND MovementLinkMovement_Order.DescId          = zc_MovementLinkMovement_Order()
                                        INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Order.MovementId
                                                           AND Movement.DescId   = zc_Movement_SendOnPrice()
                                                           AND Movement.OperDate = inOperDate
                                                           AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                   WHERE MovementLinkMovement.MovementId = inMovementId
                                     AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Order()
                                   ORDER BY Movement.Id DESC
                                   LIMIT 1
                                  )
                                  -- 2.1.
                                , (SELECT Movement.InvNumber
                                   FROM MovementLinkMovement
                                        INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                        ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                       AND MovementLinkMovement_Order.DescId          = zc_MovementLinkMovement_Order()
                                        INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Order.MovementId
                                                           AND Movement.DescId   = zc_Movement_SendOnPrice()
                                                           AND Movement.OperDate = inOperDate
                                                           AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                   WHERE MovementLinkMovement.MovementId = inMovementId
                                     AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Order()
                                   ORDER BY Movement.Id ASC
                                   LIMIT 1
                                  )
                                  -- 2.2.
                                , (SELECT zfConvert_DateToString (Movement.OperDate)
                                   FROM MovementLinkMovement
                                        INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                        ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                       AND MovementLinkMovement_Order.DescId          = zc_MovementLinkMovement_Order()
                                        INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Order.MovementId
                                                           AND Movement.DescId   = zc_Movement_SendOnPrice()
                                                           AND Movement.OperDate = inOperDate
                                                           AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                   WHERE MovementLinkMovement.MovementId = inMovementId
                                     AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Order()
                                   ORDER BY Movement.Id ASC
                                   LIMIT 1
                                  )
                                ;
              END IF;
              -- �� ��������� <������> ��� ������ "��������" - ����� ������������� ��������� <����������� �� ����> !!!����� �������� ����!!!
              vbMovementId_find:= (SELECT Movement.Id
                                   FROM MovementLinkMovement
                                         INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                         ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                        AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                         INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                            AND Movement.DescId = zc_Movement_SendOnPrice()
                                                            AND Movement.OperDate = inOperDate
                                                            AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                   WHERE MovementLinkMovement.MovementId = inMovementId
                                     AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                  );
          END IF;


          -- ��� "��������� �������", ����� ������ = ������ !!!��������, �.�. ������ ���� ���!!!
          vbIsUnitCheck:= TRUE; -- EXISTS (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To()));
          -- ��� "������" �� "��������� �������"
          vbIsSendOnPriceIn:= (WITH tmpUnit_Branch AS (SELECT OL.ObjectId AS UnitId
                                                       FROM ObjectLink AS OL
                                                       WHERE OL.ChildObjectId = vbBranchId
                                                         AND OL.DescId        = zc_ObjectLink_Unit_Branch()
                                                      UNION
                                                       -- ������
                                                       SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8453) AS lfSelect
                                                       WHERE vbBranchId = zc_Branch_Basis()
                                                      )
                                     , tmpMLO_From AS (SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From WHERE MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From()
                                                      )
                                       , tmpMLO_To AS (SELECT MLO_To.ObjectId   FROM MovementLinkObject AS MLO_To   WHERE MLO_To.MovementId   = inMovementId AND MLO_To.DescId   = zc_MovementLinkObject_To()
                                                      )
                               SELECT CASE -- ����� ������ � ����
                                           WHEN (SELECT tmpMLO_From.ObjectId FROM tmpMLO_From) IN (SELECT tmpUnit_Branch.UnitId FROM tmpUnit_Branch)
                                                THEN FALSE
                                           -- ����� ������ �� ����
                                           WHEN (SELECT tmpMLO_To.ObjectId   FROM tmpMLO_To)   IN (SELECT tmpUnit_Branch.UnitId FROM tmpUnit_Branch)
                                                THEN TRUE
                                      END
                              );
                              /*CASE WHEN vbBranchId = zc_Branch_Basis() AND EXISTS (SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From INNER JOIN ObjectLink ON ObjectLink.ObjectId = MLO_From.ObjectId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch() AND COALESCE (ObjectLink.ChildObjectId, zc_Branch_Basis()) <> zc_Branch_Basis() WHERE MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From())
                                        THEN TRUE -- ��� �������� - ������ �� ����
                                   WHEN vbBranchId = zc_Branch_Basis() AND EXISTS (SELECT MLO_To.ObjectId   FROM MovementLinkObject AS MLO_To   INNER JOIN ObjectLink ON ObjectLink.ObjectId = MLO_To.ObjectId   AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch() AND COALESCE (ObjectLink.ChildObjectId, zc_Branch_Basis()) <> zc_Branch_Basis() WHERE MLO_To.MovementId = inMovementId   AND MLO_To.DescId   = zc_MovementLinkObject_To())
                                        THEN FALSE -- ��� �������� - ������ � ����
                                   WHEN EXISTS (SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To     INNER JOIN ObjectLink ON ObjectLink.ObjectId = MLO_To.ObjectId   AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch() AND COALESCE (ObjectLink.ChildObjectId, zc_Branch_Basis()) <> zc_Branch_Basis() WHERE MLO_To.MovementId   = inMovementId AND MLO_To.DescId   = zc_MovementLinkObject_To())
                                        THEN TRUE -- ��� ������� - ������ �� ����
                                   WHEN EXISTS (SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From INNER JOIN ObjectLink ON ObjectLink.ObjectId = MLO_From.ObjectId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch() AND COALESCE (ObjectLink.ChildObjectId, zc_Branch_Basis()) <> zc_Branch_Basis() WHERE MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From())
                                        THEN FALSE -- ��� ������� - ������ � ����
                              END;*/

          IF vbBranchId <> zc_Branch_Basis() -- OR vbIsSendOnPriceIn = TRUE
          THEN
              -- �������� vbMovementId_find
              IF  (COALESCE (vbMovementId_find, 0) = 0  AND vbIsSendOnPriceIn = TRUE)  -- �.�. ������ ������, � vbMovementId_find ���
               OR (COALESCE (vbMovementId_find, 0) <> 0 AND vbIsSendOnPriceIn = FALSE) -- �.�. ������ ������, � vbMovementId_find ����
              THEN
                   RAISE EXCEPTION 'vbMovementId_find <%> <%> <%>', vbMovementId_find, vbIsSendOnPriceIn, inBranchCode;
              END IF;
          END IF;

     END IF;


     -- !!!���������!!!
     vbMovementId_begin:= vbMovementId_find;


    -- ��������� <��������>
    IF COALESCE (vbMovementId_begin, 0) = 0
    THEN
        -- ���������
        vbMovementId_begin:= (SELECT CASE WHEN vbMovementDescId = zc_Movement_Income()
                                                    -- <������ �� ����������>
                                               THEN lpInsertUpdate_Movement_Income_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Income_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := inOperDate
                                                  , inInvNumberPartner      := ''
                                                  , inPriceWithVAT          := PriceWithVAT -- ������������ �� ���������
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inPersonalPackerId      := NULL
                                                  , inCurrencyDocumentId    := 0
                                                  , inCurrencyPartnerId     := 0
                                                  , inCurrencyValue         := 0
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ReturnOut()
                                                    -- <������� ����������>
                                               THEN lpInsertUpdate_Movement_ReturnOut_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ReturnOut_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := inOperDate
                                                  , inPriceWithVAT          := PriceWithVAT
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Sale()
                                                    -- <������� ����������>
                                               THEN lpInsertUpdate_Movement_Sale_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Sale_seq') AS TVarChar)
                                                  , inInvNumberPartner      := ''
                                                  , inInvNumberOrder        := InvNumberOrder
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := -- !!!���� �� ������, ����� ������ OperDatePartner �� OperDate ������ - ���� ������ ��� inBranchCode = 201 + 2
                                                                              (CASE WHEN inBranchCode = 2 OR inBranchCode BETWEEN 201 AND 210 THEN vbOperDate_order ELSE inOperDate END
                                                                             + (CASE WHEN inBranchCode = 2 OR inBranchCode BETWEEN 201 AND 210 THEN COALESCE (ObjectFloat_PrepareDayCount.ValueData, 0) ELSE 0 END :: TVarChar || ' DAY') :: INTERVAL
                                                                             + (COALESCE (ObjectFloat_Partner_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime
                                                  , inChecked               := NULL
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inRouteSortingId        := NULL
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inMovementId_Order      := MovementId_Order
                                                  , ioPriceListId           := NULL
                                                  , ioCurrencyPartnerValue  := NULL
                                                  , ioParPartnerValue       := NULL
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                                    -- <������� �� ����������>
                                               THEN lpInsertUpdate_Movement_ReturnIn
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_ReturnIn_seq') AS TVarChar)
                                                  , inInvNumberPartner      := ''
                                                  , inInvNumberMark         := ''
                                                  , inParentId              := NULL
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := inOperDate
                                                  , inChecked               := NULL
                                                  , inIsPartner             := NULL
                                                  , inPriceWithVAT          := PriceWithVAT
                                                  , inisList                := FALSE
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inCurrencyValue         := NULL
                                                  , inComment               := ''
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_SendOnPrice()
                                                    -- <����������� �� ����>
                                               THEN lpInsertUpdate_Movement_SendOnPrice_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_SendOnPrice_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate -- ���� ������ = ���� �������� ������ ��� ��������
                                                  , inOperDatePartner       := inOperDate -- ���� ������ = ���� ������
                                                  , inPriceWithVAT          := PriceWithVAT
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inRouteSortingId        := NULL
                                                  , inMovementId_Order      := MovementId_Order
                                                  , ioPriceListId           := NULL
                                                  , inProcessId             := zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Loss()
                                                    -- <��������>
                                               THEN lpInsertUpdate_Movement_Loss_scale
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Loss_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inPriceWithVAT          := FALSE
                                                  , inVATPercent            := 20
                                                  , inFromId                := FromId
                                                  , inToId                  := CASE WHEN tmp.DescId_to IN (zc_Object_Member(), zc_Object_Car()) THEN tmp.ToId ELSE ContractId END -- !!!�� ������!!!
                                                  , inArticleLossId         := CASE WHEN tmp.DescId_to IN (zc_Object_Member(), zc_Object_Car()) THEN 0        ELSE ToId       END -- !!!�� ������!!!
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
                                                  , inDocumentKindId        := 0
                                                  , inSubjectDocId          := SubjectDocId
                                                  , inComment               := tmp.Comment
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
                                                  , inDocumentKindId        := 0
                                                  , inIsPeresort            := FALSE
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Inventory()
                                                    -- <��������������>
                                               THEN lpInsertUpdate_Movement_Inventory
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Inventory_seq') AS TVarChar)
                                                  , inOperDate              := CASE WHEN inBranchCode = 102 THEN inOperDate ELSE inOperDate - INTERVAL '1 DAY' END :: TDateTime
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inGoodsGroupId          := 0
                                                  , inisGoodsGroupIn        := FALSE
                                                  , inisGoodsGroupExc       := FALSE
                                                  , inisList                := FALSE
                                                  , inUserId                := vbUserId
                                                   )

                                          END AS MovementId_begin

                                    FROM gpGet_Movement_WeighingPartner (inMovementId:= inMovementId, inSession:= inSession) AS tmp
                                         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                                                               ON ObjectFloat_PrepareDayCount.ObjectId = tmp.ToId
                                                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Partner_DocumentDayCount
                                                               ON ObjectFloat_Partner_DocumentDayCount.ObjectId = tmp.ToId
                                                              AND ObjectFloat_Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

                                 );
         -- ��������
         IF COALESCE (vbMovementId_begin, 0) = 0
         THEN
             RAISE EXCEPTION '������.������ ��������� ������ ��� ���������.';
         END IF;

        -- ��������� ����� � ���������� <������ ���������>
        IF vbMovementDescId = zc_Movement_Send() AND EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order() AND MLM.MovementChildId > 0)
        THEN
            PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), vbMovementId_begin
                                                       , (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order() AND MLM.MovementChildId > 0)
                                                        );
        END IF;

        -- �������� ��-�� - SubjectDoc
        IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_SubjectDoc() AND MLO.ObjectId > 0)
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), vbMovementId_begin
                                                     , (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_SubjectDoc() AND MLO.ObjectId > 0)
                                                      );
        END IF;

        -- �������� ��-�� - ������ - �.�. � ������� �����
        IF vbMovementDescId = zc_Movement_Income()
        THEN
            PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), vbMovementId_begin
                                                       , (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order())
                                                        );
        END IF;

        -- �������� ��-�� - ����� ���� �������� �������
        IF vbMovementDescId = zc_Movement_ReturnIn()
        THEN
            -- ��������� ����� � <���������� ����(��������/����������)>
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), vbMovementId_begin, MovementLinkObject_Member.ObjectId)
            FROM MovementLinkObject AS MovementLinkObject_Member
            WHERE MovementLinkObject_Member.MovementId = inMovementId
              AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member();
        END IF;

        -- �������� ��-�� - �������������� ������ ��� ��������� �������
        IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_List() AND MB.ValueData = TRUE)
        THEN
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), vbMovementId_begin, TRUE);
        END IF;

        -- �������� ��-�� <����/����� ��������>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId_begin, CURRENT_TIMESTAMP);
        -- �������� ��-�� <������� ����>
        PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), vbMovementId_begin, MovementLinkMovement.MovementChildId)
        FROM MovementLinkMovement
        WHERE MovementLinkMovement.MovementChildId > 0
          AND MovementLinkMovement.MovementId = inMovementId
          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport()
       ;


        -- !!!���������!!!
        IF vbIsTax = TRUE -- AND inSession <> '5'
        THEN
             -- ���������
             PERFORM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := vbMovementId_begin
                                                          , inDocumentTaxKindId     := zc_Enum_DocumentTaxKind_Tax()
                                                          , inDocumentTaxKindId_inf := NULL
                                                          , inStartDateTax          := NULL
                                                          , inUserId                := vbUserId
                                                           );
        END IF;

    ELSE
        -- ����������� �������� !!!������������!!!
        PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_begin
                                     , inUserId     := vbUserId);

        -- ��� !!!������������!!! zc_Movement_SendOnPrice �������� <���� �������> + <���� (� ���������)> (���� ��� ������ ���)
        IF vbMovementDescId = zc_Movement_SendOnPrice() -- AND vbIsSendOnPriceIn = TRUE
        THEN
            IF vbIsSendOnPriceIn = TRUE
            THEN
                -- ��������� �������� <���� �������>
                PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), vbMovementId_begin, inOperDate);

                -- !!!������ � ������ ���!!! ��� �����������
                IF NOT EXISTS (SELECT Movement.ParentId FROM Movement WHERE Movement.ParentId = vbMovementId_begin AND Movement.DescId = zc_Movement_WeighingPartner() AND Movement.StatusId = zc_Enum_Status_Complete())
                THEN
                    -- ��������� ����� � <���� (� ���������)>
                    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), vbMovementId_begin, (SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To WHERE MLO_To.MovementId = inMovementId AND MLO_To.DescId = zc_MovementLinkObject_To()));
                END IF;

            ELSE
                -- �� ���� ������ ���� �� �����
                -- RAISE EXCEPTION '������.<���� �������> �� ����� ����������.';
                -- ��������� �������� <���� �������>
                PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, inOperDate, Movement.ParentId, Movement.AccessKeyId)
                FROM Movement
                WHERE Movement.Id = vbMovementId_begin;
            END IF;
        END IF;

    END IF;


    -- ������������ ����� � ��������� ����. � EDI (����� �� ��� � � ������)
    IF vbMovementDescId = zc_Movement_Sale()
    THEN PERFORM lpUpdate_Movement_Sale_Edi_byOrder (vbMovementId_begin, (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = vbMovementId_begin AND DescId = zc_MovementLinkMovement_Order() AND MovementChildId <> 0), vbUserId);
    END IF;


    -- ��������� <�������� �����>
     SELECT MAX (tmpId) INTO vbId_tmp
     FROM (-- �������� ��������� (���� ��������� ������)
           WITH tmpMI AS (SELECT MovementItem.Id                                     AS MovementItemId
                               , MovementItem.ObjectId                               AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                               , COALESCE (MILinkObject_Box.ObjectId, 0)             AS BoxId
                               , MIDate_PartionGoods.ValueData                       AS PartionGoodsDate
                               , COALESCE (MIString_PartionGoods.ValueData, '')      AS PartionGoods
                               , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                               , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                               , COALESCE (MIFloat_CountForPrice.ValueData, 0)       AS CountForPrice
                               , COALESCE (MILinkObject_To.ObjectId, COALESCE (MLO_To.ObjectId, 0)) AS UnitId_to

                               , COALESCE (MIFloat_ChangePercent.ValueData, 0)       AS ChangePercent    -- ������������ ������ ��� ��������
                               , COALESCE (MIFloat_PromoMovement.ValueData, 0)       AS MovementId_Promo -- ������������ ������ ��� ��������

                               , MovementItem.Amount                                 AS Amount
                               , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS AmountChangePercent
                               , COALESCE (MIFloat_AmountPartner.ValueData, 0)       AS AmountPartner
                               , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                               , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                               , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                               , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                               , COALESCE (MIFloat_AmountPacker.ValueData, 0)        AS AmountPacker
                               , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight

                               , CASE WHEN MIBoolean_BarCode.ValueData = TRUE THEN 1 ELSE 0 END AS isBarCode_value

                                 --  � �/�
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId, MIFloat_Price.ValueData ORDER BY MovementItem.Amount DESC) AS Ord

                          FROM MovementItem
                                LEFT JOIN MovementLinkObject AS MLO_To
                                                             ON MLO_To.MovementId = MovementItem.MovementId
                                                            AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                            AND vbMovementDescId = zc_Movement_SendOnPrice()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_To
                                                                 ON MILinkObject_To.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_To.DescId = zc_MILinkObject_Unit()
                                                                AND vbMovementDescId = zc_Movement_SendOnPrice()
                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                                            ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                           AND vbMovementDescId NOT IN (zc_Movement_Inventory())
                                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                                           AND vbMovementDescId NOT IN (zc_Movement_Inventory())
                                LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                           ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                          AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                             ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                            AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                                           AND vbMovementDescId = zc_Movement_ReturnIn()
                                LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                            ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                           AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                                           AND vbMovementDescId = zc_Movement_ReturnIn()

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                                 ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                                LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                            ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                            ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                           AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                                                           AND (vbIsSendOnPriceIn = FALSE OR vbMovementDescId <> zc_Movement_SendOnPrice())
                                LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                            ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Count.DescId = zc_MIFloat_Count()
                                                           AND (vbIsSendOnPriceIn = FALSE OR vbMovementDescId <> zc_Movement_SendOnPrice())
                                LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                            ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                                                           AND (vbIsSendOnPriceIn = FALSE OR vbMovementDescId <> zc_Movement_SendOnPrice())
                                LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                            ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                           AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                           AND (vbIsSendOnPriceIn = FALSE OR vbMovementDescId <> zc_Movement_SendOnPrice())
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                            ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                                                           AND (vbIsSendOnPriceIn = FALSE OR vbMovementDescId <> zc_Movement_SendOnPrice())
                                LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                            ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                           AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                                                           AND (vbIsSendOnPriceIn = FALSE OR vbMovementDescId <> zc_Movement_SendOnPrice())

                                LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                              ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                                             AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

                          WHERE MovementItem.MovementId = vbMovementId_find
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                            AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_Inventory(), zc_Movement_SendOnPrice(), zc_Movement_ReturnIn())
                          )

           -- InsertUpdate
           SELECT CASE WHEN vbMovementDescId = zc_Movement_Income()
                                 -- <������ �� ����������>
                            THEN lpInsertUpdate_MovementItem_Income
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inAmountPacker        := tmp.AmountPacker
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inLiveWeight          := tmp.LiveWeight
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ReturnOut()
                                 -- <������� ����������>
                            THEN lpInsertUpdate_MovementItem_ReturnOut
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Sale()
                                 -- <������� ����������>
                            THEN lpInsertUpdate_MovementItem_Sale_Value
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inAmountChangePercent := tmp.AmountChangePercent
                                                        , inChangePercentAmount := tmp.ChangePercentAmount
                                                        , inPrice               := tmp.Price
                                                        , ioCountForPrice       := tmp.CountForPrice
                                                        , inHeadCount           := tmp.HeadCount
                                                        , inBoxCount            := tmp.BoxCount
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inBoxId               := tmp.BoxId
                                                        , inIsBarCode           := CASE WHEN tmp.isBarCode_value = 1 THEN TRUE ELSE FALSE END
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                 -- <������� �� ����������>
                            THEN lpInsertUpdate_MovementItem_ReturnIn_Value
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inChangePercent       := tmp.ChangePercent
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inHeadCount           := 0
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
                                                        , inMovementId_Promo    := tmp.MovementId_Promo :: Integer
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_SendOnPrice()
                                 -- <����������� �� ����>
                            THEN lpInsertUpdate_MovementItem_SendOnPrice_scale
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inAmountChangePercent := tmp.AmountChangePercent
                                                        , inAmountPartner       := tmp.AmountPartner
                                                        , inChangePercentAmount := tmp.ChangePercentAmount
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inPartionGoods        := '' -- !!!�� ������, ����� �� �����������!!!
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inUnitId              := CASE WHEN vbIsUnitCheck = FALSE OR vbIsSendOnPriceIn = FALSE THEN 0 ELSE tmp.UnitId_to END -- !!!����������� ������ ����� ������ + �� "��������� �������"!!!
                                                        , inIsBarCode           := CASE WHEN tmp.isBarCode_value = 1 THEN TRUE ELSE FALSE END
                                                        , inUserId              := vbUserId
                                                         )
                       WHEN vbMovementDescId = zc_Movement_Loss()
                                 -- <��������>
                            THEN lpInsertUpdate_MovementItem_Loss_scale
                                                         (ioId                  := tmp.MovementItemId_find
                                                        , inMovementId          := vbMovementId_begin
                                                        , inGoodsId             := tmp.GoodsId
                                                        , inAmount              := tmp.Amount
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
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
                                                        , inCuterWeight         := 0
                                                        , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
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
                                                        , inPartionGoodsId      := NULL
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inGoodsKindCompleteId := NULL
                                                        , inAssetId             := NULL
                                                        , inUnitId              := NULL
                                                        , inStorageId           := NULL
                                                        , inUserId              := vbUserId
                                                         )

                  END AS tmpId
          FROM (SELECT MAX (tmp.MovementItemId)      AS MovementItemId_find
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , tmp.BoxId
                     , tmp.PartionGoodsDate
                     , tmp.PartionGoods
                     , SUM (tmp.Amount)              AS Amount
                     , SUM (tmp.AmountChangePercent) AS AmountChangePercent
                     , SUM (tmp.AmountPartner)       AS AmountPartner
                     , tmp.ChangePercentAmount
                     , tmp.Price
                     , tmp.CountForPrice
                     , MAX (tmp.ChangePercent)       AS ChangePercent    -- ������������ ������ ��� ��������
                     , MAX (tmp.MovementId_Promo)    AS MovementId_Promo -- ������������ ������ ��� ��������
                     , SUM (tmp.BoxCount)     AS BoxCount
                     , SUM (tmp.Count)        AS Count
                     , SUM (tmp.CountPack)    AS CountPack
                     , SUM (tmp.HeadCount)    AS HeadCount
                     , SUM (tmp.LiveWeight)   AS LiveWeight
                     , SUM (tmp.AmountPacker) AS AmountPacker
                     , MAX (tmp.isBarCode_value) AS isBarCode_value
                     , tmp.UnitId_to
                FROM (-- �������� �����������
                      SELECT 0 AS MovementItemId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN CASE WHEN vbGoodsId_ReWork > 0 THEN vbGoodsId_ReWork ELSE zc_Goods_ReWork() END ELSE MovementItem.ObjectId END AS GoodsId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  END AS GoodsKindId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MILinkObject_Box.ObjectId, 0)        END AS BoxId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE MIDate_PartionGoods.ValueData                  END AS PartionGoodsDate
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIString_PartionGoods.ValueData, '') END AS PartionGoods

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN MovementItem.Amount -- ����������� ������ ������ = ��� ��� ������

                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN 0 -- �� �����������, �.�. ������ ������

                                  ELSE MovementItem.Amount -- ������� ��������

                             END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount -- !!!* ��� ������ ��� ����������� � �����������!!

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ����������� ������ ������ = ��� �� �������

                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN 0 -- �� �����������, �.�. ������ ������

                                  ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ������� �������� = ��� �� �������

                             END AS AmountChangePercent

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN 0 -- �� �����������, �.�. ������ ������

                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ����������� ������ ������ = ��� �� �������

                                  WHEN vbMovementDescId = zc_Movement_ReturnIn() AND vbMovementId_find > 0
                                       THEN 0 -- �� ����������� - ����� �� ���������� ����������

                                  ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ������� �������� = ��� �� �������

                             END AS AmountPartner

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
                                       THEN NULL
                                  -- ���� ���� - ����� �� ���������� ����������
                                  ELSE COALESCE (tmpMI.ChangePercentAmount, COALESCE (MIFloat_ChangePercentAmount.ValueData, 0))
                             END AS ChangePercentAmount

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
                                       THEN NULL
                                  -- ���� ���� - ����� �� ���������� ����������
                                  ELSE COALESCE (tmpMI.Price, COALESCE (MIFloat_Price.ValueData, 0))
                             END AS Price
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
                                       THEN NULL
                                  -- ���� ���� - ����� �� ���������� ����������
                                  ELSE COALESCE (tmpMI.CountForPrice, COALESCE (MIFloat_CountForPrice.ValueData, 0))
                             END AS CountForPrice

                             -- ������������ ������ ��� ��������
                           , COALESCE (tmpMI.ChangePercent, COALESCE (MIFloat_ChangePercent.ValueData, 0)) AS ChangePercent
                             -- ������������ ������ ��� ��������
                           , COALESCE (tmpMI.MovementId_Promo, COALESCE (MIFloat_PromoMovement.ValueData, 0)) AS MovementId_Promo

                           , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                           , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                           , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , 0                                                   AS AmountPacker
                           , 0                                                   AS LiveWeight

                           , CASE WHEN MIBoolean_BarCode.ValueData = TRUE THEN 1 ELSE 0 END AS isBarCode_value

                           , MovementItem.Amount                                 AS Amount_mi
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MLO_To.ObjectId, 0) END AS UnitId_to
                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       THEN 0 -- ���� �����������
                                  WHEN vbMovementDescId IN (zc_Movement_Send()) AND inBranchCode BETWEEN 201 AND 210 -- ���� �������
                                       THEN MovementItem.Id -- ���� �� ���� �����������
                                  ELSE 0 -- ����� �����������, ���� ��� �������
                             END AS myId
                      FROM MovementItem
                           LEFT JOIN MovementLinkObject AS MLO_To
                                                        ON MLO_To.MovementId = MovementItem.MovementId
                                                       AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                       AND vbMovementDescId = zc_Movement_SendOnPrice()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                                       ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
                           LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                       ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                      AND vbMovementDescId NOT IN (zc_Movement_Inventory())
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                                      AND vbMovementDescId NOT IN (zc_Movement_Inventory())

                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                                      AND vbMovementDescId = zc_Movement_ReturnIn()
                           LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                                      AND vbMovementDescId = zc_Movement_ReturnIn()

                           LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                         ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                                        AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                            ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                                                           AND vbMovementDescId = zc_Movement_Sale()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                               AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn= FALSE -- !!!�����!!!
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                                AND vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn= FALSE -- !!!�����!!!

                           -- ������������ ��� �������� + ������ ��� ���� + ChangePercentAmount + ChangePercent
                           LEFT JOIN tmpMI ON tmpMI.GoodsId     = MovementItem.ObjectId
                                          AND tmpMI.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                          AND tmpMI.Ord         = 1
                                          AND vbMovementDescId  = zc_Movement_ReturnIn()
                                          AND vbMovementId_find > 0

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     UNION ALL
                      -- �������� ��������� (���� ��������� ������)
                      SELECT tmpMI.MovementItemId
                           , tmpMI.GoodsId
                           , tmpMI.GoodsKindId
                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       -- ����� ���������� + ����� ���� ��
                                   AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (8459, 8458))
                                       THEN 0
                                  ELSE tmpMI.BoxId
                             END AS BoxId
                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       -- ����� ���������� + ����� ���� ��
                                   AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (8459, 8458))
                                       THEN NULL
                                  ELSE tmpMI.PartionGoodsDate
                             END AS PartionGoodsDate
                           , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                       -- ����� ���������� + ����� ���� ��
                                   AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (8459, 8458))
                                       THEN ''
                                  ELSE tmpMI.PartionGoods
                             END AS PartionGoods

                           , CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() AND vbMovementId_find > 0
                                       THEN 0 -- �� ����������� - ����� �� ��������� �����������
                                  ELSE tmpMI.Amount
                             END AS Amount

                           , CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() AND vbMovementId_find > 0
                                       THEN 0 -- �� ����������� - ����� �� ��������� �����������
                                  ELSE tmpMI.AmountChangePercent
                             END AS AmountChangePercent

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN 0 -- �� �����������, �.�. ������ ������
                                  ELSE tmpMI.AmountPartner
                             END AS AmountPartner
                           , tmpMI.ChangePercentAmount

                           , tmpMI.Price
                           , tmpMI.CountForPrice

                           , tmpMI.ChangePercent    -- ������������ ������ ��� ��������
                           , tmpMI.MovementId_Promo -- ������������ ������ ��� ��������

                           , tmpMI.BoxCount
                           , tmpMI.Count
                           , tmpMI.CountPack
                           , tmpMI.HeadCount
                           , tmpMI.AmountPacker
                           , tmpMI.LiveWeight

                           , tmpMI.isBarCode_value

                           , CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() AND vbMovementId_find > 0
                                       THEN tmpMI.Amount
                                  ELSE 0
                             END AS Amount_mi
                           , tmpMI.UnitId_to
                           , 0                                                   AS myId

                      FROM tmpMI
                      WHERE tmpMI.Ord = 1
                     ) AS tmp
                GROUP BY tmp.GoodsId
                       , tmp.GoodsKindId
                       , tmp.BoxId
                       , tmp.PartionGoodsDate
                       , tmp.PartionGoods
                       , tmp.ChangePercentAmount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.UnitId_to
                       , tmp.myId -- ���� ��� ������������ - ������ ����������� � ��������� �������
                HAVING SUM (tmp.Amount_mi) <> 0
               ) AS tmp
          ) AS tmp;


--��� �����
/* if inMovementId in (8351040) then
    RAISE EXCEPTION 'inSession  - Errr _end <%>', vbMovementId_begin;
 end if;*/

/*
     -- �������� ReturnIn_Detail
     IF EXISTS (SELECT 1 FROM MovementItem WHERE )
     PERFORM gpInsertUpdate_MovementItem_ReturnIn_Detail (MI_Detail.Id, zc_MI_Detail(), MovementItem.ObjectId, inMovementId, MovementItem.Amount, MovementItem.Id)
     FROM MovementItem
          LEFT JOIN MovementItem AS MI_Detail ON MI_Detail.MovementId = inMovementId
                                             AND MI_Detail.DescId     = zc_MI_Detail()
                                             AND MI_Detail.ParentId   = MovementItem.Id
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND MI_Detail.ParentId IS NULL
    ;
*/
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
                                                        , inGoodsKindCompleteId := NULL
                                                        , inCount_onCount       := 0
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

     -- <������� ����������>
     IF vbMovementDescId = zc_Movement_Sale()
     THEN
         -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <������� ����������>
         PERFORM lpComplete_Movement_Sale_CreateTemp();
         -- �������� ��������
         PERFORM lpComplete_Movement_Sale (inMovementId     := vbMovementId_begin
                                         , inUserId         := vbUserId
                                         , inIsLastComplete := NULL);

     ELSE -- <������� �� ����������>
          IF vbMovementDescId = zc_Movement_ReturnIn()
          THEN
              -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <������� �� ����������>
              PERFORM lpComplete_Movement_ReturnIn_CreateTemp();
              -- �������� ��������
              PERFORM lpComplete_Movement_ReturnIn (inMovementId     := vbMovementId_begin
                                                  , inStartDateSale  := NULL
                                                  , inUserId         := vbUserId
                                                  , inIsLastComplete := NULL);

          ELSE -- <����������� �� ����>
               IF vbMovementDescId = zc_Movement_SendOnPrice()
               THEN

                   -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <����������� �� ����>
                   PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
                   -- �������� ��������
                   PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := vbMovementId_begin
                                                          , inUserId         := vbUserId);

               ELSE
               -- <������ �� ����������>
               IF vbMovementDescId = zc_Movement_Income()
               THEN
                   -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <����������� �� ����>
                   PERFORM lpComplete_Movement_Income_CreateTemp();
                   -- �������� ��������
                   PERFORM lpComplete_Movement_Income (inMovementId     := vbMovementId_begin
                                                     , inUserId         := vbUserId
                                                     , inIsLastComplete := NULL);
               ELSE
               -- <������� ����������>
               IF vbMovementDescId = zc_Movement_ReturnOut()
               THEN
                   -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� - <����������� �� ����>
                   PERFORM lpComplete_Movement_ReturnOut_CreateTemp();
                   -- �������� ��������
                   PERFORM lpComplete_Movement_ReturnOut (inMovementId     := vbMovementId_begin
                                                        , inUserId         := vbUserId
                                                        , inIsLastComplete := NULL);

               ELSE
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
               END IF;
               END IF;
               END IF;
               END IF;
     END IF;

-- if vbUserId <> 5 then
     -- ����� - ��������� <��������> - <����������� (����������)> - ������ ���� + ParentId + AccessKeyId
     PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, vbOperDate_scale, vbMovementId_begin, Movement_begin.AccessKeyId)
     FROM Movement
          LEFT JOIN Movement AS Movement_begin ON Movement_begin.Id = vbMovementId_begin
     WHERE Movement.Id = inMovementId;

     -- ��������� �������� <�������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inMovementId, CURRENT_TIMESTAMP);

     -- ����� - ����������� ������ ������ ��������� + ��������� �������� - <����������� (����������)>
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingPartner()
                                , inUserId     := vbUserId
                                 );
-- end if;

     -- !!!�������� ��� �������� ����!!!
     IF vbMovementDescId = zc_Movement_Inventory()
     THEN
          -- !!!�������� ������������!!!
          /*PERFORM lpInsert_LockUnique (inKeyData:= 'Movement'
                                         || ';' || Movement.DescId :: TVarChar
                                         || ';' || COALESCE (MovementLinkObject_From.ObjectId, 0) :: TVarChar
                                         || ';' || (DATE (Movement.OperDate)) :: TVarChar
                                     , inUserId:= vbUserId
                                      )
          FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          WHERE Movement.Id = vbMovementId_begin*/

          IF EXISTS (SELECT Movement.Id
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

     -- �������� ����� ������������
     -- IF vbMovementDescId NOT IN (zc_Movement_Send()) OR inBranchCode NOT BETWEEN 201 AND 210 -- ���� �������
     IF vbMovementDescId = zc_Movement_Inventory() AND 1=0
     THEN
          -- !!!�������� ��� ������� ���� - �������� ������������!!!
          /*PERFORM lpInsert_LockUnique (inKeyData:= 'MI'
                                         || ';' || MovementItem.MovementId :: TVarChar
                                         || ';' || MovementItem.ObjectId   :: TVarChar
                                         || ';' || COALESCE (MILinkObject_GoodsKind.ObjectId, 0) :: TVarChar
                                         || ';' || (DATE (COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()))) :: TVarChar
                                         || ';' || COALESCE (MIString_PartionGoods.ValueData, '')
                                     , inUserId:= vbUserId
                                      )
          FROM MovementItem
               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                          ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                         AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
               LEFT JOIN MovementItemString AS MIString_PartionGoods
                                            ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                           AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
           WHERE MovementItem.MovementId = vbMovementId_begin
             AND MovementItem.isErased = FALSE
             AND (MovementItem.Amount <> 0 OR vbMovementDescId <> zc_Movement_Inventory())
          ;*/
          -- !!!�������� ��� ������� ����!!!
          IF EXISTS (SELECT 1
                     FROM MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                     ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                          LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                       ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                      WHERE MovementItem.MovementId = vbMovementId_begin
                        AND MovementItem.isErased = FALSE
                        AND (MovementItem.Amount <> 0 OR vbMovementDescId <> zc_Movement_Inventory())
                      GROUP BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId, COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()), COALESCE (MIString_PartionGoods.ValueData, '')
                      HAVING COUNT (*) > 1
                    )
          THEN
              RAISE EXCEPTION '������.�������� �� <%> ������������ ������ �������������.��������� �������� ����� 25 ���.', DATE (inOperDate - INTERVAL '1 DAY');
          END IF;

     END IF;


     -- !!!�������� ��� �������� ����!!!
     IF vbMovementDescId = zc_Movement_SendOnPrice() AND EXISTS (SELECT MLM_Order.MovementChildId
                                                                 FROM MovementLinkMovement AS MLM_Order
                                                                      JOIN Movement ON Movement.Id     = MLM_Order.MovementChildId
                                                                                   AND Movement.DescId = zc_Movement_OrderExternal()
                                                                 WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                                                )
     THEN
         --
         vbKeyData:= (SELECT 'Movement'
                   || ';' || Movement.DescId :: TVarChar
                   || ';' || MLM_Order.MovementChildId :: TVarChar
                   || ';' || (DATE (Movement.OperDate)) :: TVarChar
                      FROM Movement
                           JOIN MovementLinkMovement AS MLM_Order
                                                     ON MLM_Order.MovementId      = Movement.Id
                                                    AND MLM_Order.DescId          = zc_MovementLinkMovement_Order()
                                                    AND MLM_Order.MovementChildId > 0
                      WHERE Movement.Id = vbMovementId_begin
                     );

         -- ��������
         IF NOT EXISTS (SELECT 1 FROM LockUnique WHERE LockUnique.KeyData = vbKeyData)
         THEN
             -- !!!�������� ������������!!!
             PERFORM lpInsert_LockUnique (inKeyData:= vbKeyData, inUserId:= vbUserId);
         END IF;

     END IF;


--��� �����
/*if inMovementId in (8351040) then
    RAISE EXCEPTION ' !!! --- END ALL --- !!! Errr <%>', vbMovementId_begin;
end if;*/

-- !!! �������� !!!
 IF vbUserId = 5 AND 1=1 THEN
-- IF inSession = '1162887' AND 1=1 THEN
    RAISE EXCEPTION 'Admin - Test = OK : %  %  %  % % % % %'
  , inBranchCode -- '��������� �������� ����� 3 ���.'
  , vbMovementId_begin
  , (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_begin)
  , (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_begin AND MD.DescId = zc_MovementDate_OperDatePartner())
  , (SELECT  MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = vbMovementId_begin AND MLM.DescId = zc_MovementLinkMovement_Master())
  , (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = vbMovementId_begin AND MF.DescId = zc_MovementFloat_TotalCount())
  , (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = vbMovementId_begin AND MF.DescId = zc_MovementFloat_TotalCountPartner())
  , (SELECT MIF.ValueData FROM MovementItem AS MI JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_Price() WHERE MI.MovementId = vbMovementId_begin AND MI.DescId = zc_MI_Master() LIMIT 1)
   ;
END IF;


     -- �������� zc_MovementFloat_GPSN + zc_MovementFloat_GPSE
     IF vbMovementDescId = zc_Movement_Sale()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_GPSN(), inMovementId, COALESCE ((SELECT EXTRACT (DAY FROM Movement.OperDate) :: TFloat FROM Movement WHERE Movement.Id = vbMovementId_begin), 0));
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_GPSE(), inMovementId, COALESCE ((SELECT EXTRACT (DAY FROM MovementDate.ValueData) :: TFloat FROM MovementDate WHERE MovementDate.MovementId = vbMovementId_begin AND MovementDate.DescId = zc_MovementDate_OperDatePartner()), 0));
         -- ��������� ��������
          PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     END IF;


     -- �������� ��-�� <�������� ����/����� ������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartBegin(), inMovementId, vbOperDate_StartBegin);
     -- �������� ��-�� <�������� ����/����� ����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), inMovementId, CLOCK_TIMESTAMP());


     -- ���������
     RETURN QUERY
       SELECT vbMovementId_begin AS MovementId_begin
             , CASE WHEN vbMovementDescId = zc_Movement_Sale()
                          -- ���
                     AND (EXISTS (SELECT
                                  FROM MovementLinkObject AS MovementLinkObject_To
                                       INNER JOIN ObjectLink AS OL_Juridical
                                                             ON OL_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                            AND OL_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                       INNER JOIN ObjectLink AS OL_Retail
                                                             ON OL_Retail.ObjectId      = OL_Juridical.ChildObjectId
                                                            AND OL_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                                                            AND OL_Retail.ChildObjectId = 341162 -- ���
                                  WHERE MovementLinkObject_To.MovementId = vbMovementId_begin
                                    AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                 )
                          -- ����+ ���
                       OR EXISTS (SELECT
                                  FROM MovementLinkObject AS MovementLinkObject_To
                                       INNER JOIN ObjectLink AS OL_Juridical
                                                             ON OL_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                            AND OL_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                                            AND OL_Juridical.ChildObjectId = 4978325 -- "����+ ���"
                                  WHERE MovementLinkObject_To.MovementId = vbMovementId_begin
                                    AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                 )
                         )
                         THEN TRUE
                    ELSE FALSE
               END :: Boolean AS isExportEmail
       ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.03.21         *
 13.11.15                                        *
 04.07.15                                        * !!!�������� ��� �������� ����!!!
 27.05.15                                        * add vbIsTax
 03.02.15                                        *
*/
-- ����
-- SELECT * FROM gpInsert_Scale_Movement_all (inBranchCode:= 2, inMovementId:= 8351040, inOperDate:= CURRENT_DATE, inSession:= '992376') -- ������� �.�.
-- SELECT * FROM gpInsert_Scale_Movement_all (inBranchCode:= 2, inMovementId:= 8351040, inOperDate:= CURRENT_DATE, inSession:= '539736') -- ׸���� �.�.

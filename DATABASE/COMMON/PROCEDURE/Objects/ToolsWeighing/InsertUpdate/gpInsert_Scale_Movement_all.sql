-- Function: gpInsert_Scale_Movement_all()

-- DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_test (Integer, Integer, Boolean);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax_From_Kind_test (Integer, Integer, Integer, TDateTime, Integer);

-- DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, TDateTime, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, TDateTime, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, TDateTime, Boolean, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_Movement_all(
    IN inBranchCode          Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementDescId_next Integer   , -- ����
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ���������
    IN inIsDocInsert         Boolean   , --
    IN inIsOldPeriod         Boolean   , --
    IN inIsDocPartner        Boolean   , -- ������ �� ���������� - �������� ����������
    IN inIP                  TVarChar,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId_begin         Integer
             , MovementId_begin_next    Integer
             , isExportEmail            Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbFromId_next      Integer;
   DECLARE vbToId_next        Integer;

   DECLARE vbRetailId         Integer;
   DECLARE vbBranchId         Integer;
   DECLARE vbGoodsPropertyId  Integer;
   DECLARE vbIsUnitCheck      Boolean;
   DECLARE vbIsSendOnPriceIn  Boolean;
   DECLARE vbIsProductionIn   Boolean;

   DECLARE vbMovementId_find       Integer;
   DECLARE vbMovementId_begin      Integer;
   DECLARE vbMovementId_begin_next Integer;
   DECLARE vbMovementId_cost       Integer;
   DECLARE vbMovementDescId        Integer;
   DECLARE vbIsTax                 Boolean;

   DECLARE vbVATPercent_begin     TFloat;
   DECLARE vbIsPriceWithVAT_begin Boolean;

   DECLARE vbGoodsId_err     Integer;
   DECLARE vbGoodsKindId_err Integer;
   DECLARE vbAmount_err      TFloat;
   DECLARE vbTaxDoc_err      TFloat;
   DECLARE vbTaxMI_err       TFloat;
   DECLARE vbAmountDoc_err   TFloat;

   DECLARE vbOperDate_scale TDateTime;
   DECLARE vbId_tmp Integer;
   DECLARE vbGoodsId_ReWork Integer;

   DECLARE vbOperDate_StartBegin TDateTime;

   DECLARE vbKeyData TVarChar;

   DECLARE vbIsUpak_UnComplete Boolean;

   DECLARE vbIsDocMany        Boolean;
   DECLARE vbIsCloseInventory Boolean;

   DECLARE vbInvNumberPartner_find TVarChar;
   DECLARE vbContractId_find Integer;
   DECLARE vbMovementId_income_find Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� ��������� ����� ������ ���������� ����.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- ���� ��� <�������� ����������>
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner())
        AND zc_Movement_Income() = (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementDesc()) :: Integer
     THEN
         vbInvNumberPartner_find:= (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner());
         vbContractId_find      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
         --
         IF vbInvNumberPartner_find <> ''
         THEN
             vbMovementId_income_find:= (SELECT Movement.Id
                                         FROM Movement
                                              -- ���� ����� ��-��
                                              INNER JOIN MovementBoolean AS MovementBoolean_DocPartner
                                                                         ON MovementBoolean_DocPartner.MovementId = Movement.Id
                                                                        AND MovementBoolean_DocPartner.DescId     = zc_MovementBoolean_DocPartner()
                                              INNER JOIN MovementString AS MovementString_InvNumberPartner
                                                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                                       AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                                                       --  � ����� ������� ����������
                                                                       AND MovementString_InvNumberPartner.ValueData = vbInvNumberPartner_find
                                              INNER JOIN MovementLinkObject AS MLO_Contract
                                                                            ON MLO_Contract.MovementId = Movement.Id
                                                                           AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                           --  � ����� ���������
                                                                           AND MLO_Contract.ObjectId   = vbContractId_find
                                         WHERE Movement.OperDate BETWEEN inOperDate - INTERVAL '1 DAY' AND inOperDate + INTERVAL '1 DAY'
                                           AND Movement.DescId   = zc_Movement_WeighingPartner()
                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                         LIMIT 1
                                        );
         END IF;

         -- ����� �������� ����������
         IF vbMovementId_income_find > 0
         THEN
             RAISE EXCEPTION '������.�������� ���������� % � = <%> (%) �� <%> ��� ����������.%������������ ���������.'
                            , CHR (13)
                            , vbInvNumberPartner_find
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_income_find)
                            , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = vbMovementId_income_find)
                            , CHR (13)
                             ;
         END IF;

     END IF;

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


     -- ��������
     IF inBranchCode = 115
     THEN
          RAISE EXCEPTION '������.��� ���� ��������� ��������.';
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


     -- ����� � ���������� - �������� ����� �� ��������
     vbIsUpak_UnComplete:= EXISTS (SELECT 1
                                   FROM Object_Unit_Scale_upak_View
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = inMovementId
                                                                         AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                                         AND MovementLinkObject_From.ObjectId   = Object_Unit_Scale_upak_View.FromId
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = inMovementId
                                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId   = Object_Unit_Scale_upak_View.ToId
                                  );

     -- ����������
     vbRetailId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM MovementLinkObject AS MovementLinkObject_To
                        LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                             ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                            AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                   WHERE MovementLinkObject_To.MovementId = inMovementId
                     AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                  );

     -- ����������
     vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                       ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                  END;


     -- ���������� <��� ���������>
     IF inMovementDescId_next < 0
     THEN vbMovementDescId:= ABS (inMovementDescId_next);
          vbFromId_next:= (SELECT CASE WHEN TRIM (tmp.RetV) = '' THEN '0' ELSE TRIM (tmp.RetV) END :: Integer
                           FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'Scale_' || inBranchCode
                                                                 , inLevel2      := 'Movement'
                                                                 , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                                 , inItemName    := 'FromId_next'
                                                                 , inDefaultValue:= '0'
                                                                 , inSession     := inSession
                                                                  ) AS RetV
                                 FROM MovementFloat
                                 WHERE MovementFloat.MovementId = inMovementId
                                   AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                   AND MovementFloat.ValueData > 0
                                ) AS tmp
                          );
          vbToId_next  := (SELECT CASE WHEN TRIM (tmp.RetV) = '' THEN '0' ELSE TRIM (tmp.RetV) END :: Integer
                           FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'Scale_' || inBranchCode
                                                                 , inLevel2      := 'Movement'
                                                                 , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                                 , inItemName    := 'ToId_next'
                                                                 , inDefaultValue:= '0'
                                                                 , inSession     := inSession
                                                                  ) AS RetV
                                 FROM MovementFloat
                                 WHERE MovementFloat.MovementId = inMovementId
                                   AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                   AND MovementFloat.ValueData > 0
                                ) AS tmp
                          );

     ELSE
         vbMovementDescId:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_MovementDesc()) :: Integer;
     END IF;


     -- !!!���������� ��������!!!
     IF vbMovementDescId = zc_Movement_Inventory()
     THEN
         vbIsCloseInventory:= (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
                               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'Scale_' || inBranchCode
                                                                     , inLevel2      := 'Movement'
                                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                                     , inItemName    := 'isCloseInventory'
                                                                     , inDefaultValue:= 'TRUE'
                                                                     , inSession     := inSession
                                                                      ) AS RetV
                                     FROM MovementFloat
                                     WHERE MovementFloat.MovementId = inMovementId
                                       AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                       AND MovementFloat.ValueData > 0
                                    ) AS tmp
                              );

         IF vbMovementDescId = zc_Movement_Inventory()
         THEN
             -- ����������� ��������
             vbIsCloseInventory:= zc_Unit_RK() <> COALESCE ((SELECT MLO.ObjectId AS MLO FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From()), 0);
         END IF;

      END IF;

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
     and 1=1
     THEN
         -- �����
         --vbGoodsPropertyId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = inMovementId AND MLO.DescId = zc_MovementLinkObject_GoodsProperty());
         vbGoodsPropertyId:= (SELECT zfCalc_GoodsPropertyId ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                           , (SELECT OL_Juridical.ChildObjectId FROM MovementLinkObject AS MLO LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical() WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                           , (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                            )
                             );
         --
         WITH -- MovementItem
              tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
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
                                     FROM ObjectFloat AS OFl
                                     WHERE OFl.ObjectId  = vbGoodsPropertyId
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

         SELECT tmpAmountDoc.GoodsId, tmpAmountDoc.GoodsKindId, tmpAmountDoc.Amount, tmpAmountDoc.TaxDoc, tmpAmountDoc.Amount / tmpAmountDoc.AmountDoc * 100 - 100, tmpAmountDoc.AmountDoc
                INTO vbGoodsId_err, vbGoodsKindId_err, vbAmount_err, vbTaxDoc_err, vbTaxMI_err, vbAmountDoc_err
         FROM tmpAmountDoc
              LEFT JOIN MovementLinkObject AS MLO ON MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract()
              LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MLO.ObjectId
         WHERE tmpAmountDoc.AmountStart > 0 AND NOT (tmpAmountDoc.Amount BETWEEN tmpAmountDoc.AmountStart AND tmpAmountDoc.AmountEnd)
           AND COALESCE (Object_Contract.ValueData, '') NOT ILIKE '%�����%'
           AND COALESCE (Object_Contract.ValueData, '') NOT ILIKE '%����%'
           AND COALESCE (Object_Contract.ValueData, '') NOT ILIKE '%���i�%'
         LIMIT 1
         ;
         --
         IF vbGoodsId_err > 0
         THEN
             RAISE EXCEPTION '������.������������ ���%<%> <%> ���-�� = <%>%���������� ����.���������� = <%>%���� ����.���������� = <%>.%�������� � �������������� <%>%���������� ��.�������� (�������� ���� �����) = <%>'
                           , CHR (13)
                           , lfGet_Object_ValueData (vbGoodsId_err)
                           , lfGet_Object_ValueData (vbGoodsKindId_err)
                           , zfConvert_FloatToString (vbAmount_err)
                           , CHR (13)
                           , zfConvert_FloatToString (vbTaxDoc_err)
                           , CHR (13)
                           , zfConvert_FloatToString (vbTaxMI_err)
                           , CHR (13)
                           , lfGet_Object_ValueData_sh (vbGoodsPropertyId)
                           , CHR (13)
                           , zfConvert_FloatToString (vbAmountDoc_err)
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
                  AND MovementLinkObject_Contract.ObjectId <> MovementLinkObject_Contract_find.ObjectId
               )
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
                     --INNER JOIN Movement AS Movement_order ON Movement_order.Id     = MovementLinkMovement_Order.MovementChildId
                     --                                    AND Movement_order.DescId = zc_Movement_OrderExternal()
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
                     --INNER JOIN Movement AS Movement_order ON Movement_order.Id     = MovementLinkMovement_Order.MovementChildId
                     --                                    AND Movement_order.DescId = zc_Movement_OrderExternal()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = inMovementId
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_To.ObjectId <> MovementLinkObject_From_find.ObjectId;
     END IF;



     -- !!!���������!!
     vbOperDate_scale:= inOperDate;

     -- !!!���� �� ������, ����� ������� �� �� OperDatePartner, ������ - ���� ������ ��� ��������!!!
     inOperDate:= CASE WHEN vbBranchId   = zc_Branch_Basis()
                         AND vbUserId <> 5
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

                       -- ��� ��� ���� � ����� - �.�. ������ �� ��������, ���� �� �����
                       WHEN vbBranchId   = zc_Branch_Basis()
                         OR inBranchCode = 2 -- ������ ����
                            THEN inOperDate

                     -- WHEN inIsOldPeriod = FALSE
                     --      THEN inOperDate

                       ELSE -- !!!������������ ��������� ���� ����� �� ������, !!!����� inOperDate!!!
                            COALESCE ((SELECT MovementDate.ValueData
                                       FROM MovementDate JOIN Movement ON Movement.Id = MovementDate.MovementId AND Movement.DescId = zc_Movement_OrderExternal()
                                       WHERE MovementDate.DescId = zc_MovementDate_OperDatePartner()
                                         AND MovementDate.MovementId = -- ����� ������
                                                                       (SELECT MLM_Order.MovementChildId
                                                                        FROM MovementLinkMovement AS MLM_Order
                                                                        WHERE MLM_Order.MovementId = inMovementId
                                                                          AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()
                                                                       )
                                      )
                                    , inOperDate)
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


     -- ������������ - ����� �� ���� ��������� ���������� ��� ���� ������
     vbIsDocMany:= inBranchCode = 1 AND (vbRetailId IN (310839 -- ����
                                                      , 310854 -- ����
                                                      , 310846 -- ��
                                                      , vbRetailId
                                                       )
                                      OR vbMovementDescId = zc_Movement_SendOnPrice()
                                        );
     -- ������������ �������
     inIsDocInsert:= inIsDocInsert = TRUE AND vbIsDocMany = TRUE;

     -- �����
     IF vbMovementDescId = zc_Movement_Sale() AND inIsDocInsert = FALSE
     THEN
          -- �������� ���
          IF vbIsDocMany = FALSE
             AND 1 < (SELECT COUNT(*) FROM MovementLinkMovement
                                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                     ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                     INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                        AND Movement.DescId = zc_Movement_Sale()
                                                      --AND Movement.OperDate = inOperDate
                                                        AND Movement.OperDate BETWEEN inOperDate - CASE WHEN inIsOldPeriod = TRUE THEN '2 DAY' ELSE '0 DAY' END :: INTERVAL AND inOperDate
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
                                                      --AND Movement.OperDate = inOperDate
                                                        AND Movement.OperDate BETWEEN inOperDate - CASE WHEN inIsOldPeriod = TRUE THEN '2 DAY' ELSE '0 DAY' END :: INTERVAL AND inOperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                WHERE MovementLinkMovement.MovementId = inMovementId
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                  -- AND inSession <> '5'
                                ORDER BY Movement.Id DESC
                                LIMIT CASE WHEN vbIsDocMany = TRUE THEN 1 ELSE 100 END
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
     IF vbMovementDescId = zc_Movement_SendOnPrice() AND inIsDocInsert = FALSE
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
                                                      UNION
                                                       -- ������
                                                       SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8439) AS lfSelect
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


     IF vbUserId = 5 AND 1=0
     THEN
         vbMovementId_begin:= 0;
         vbMovementId_find := 0;
         inOperDate:= '07.05.2024';
         inOperDatePartner:= '08.05.2024';
     END IF;


    -- ��������� <��������>
    IF COALESCE (vbMovementId_begin, 0) = 0 AND inIsDocPartner = FALSE
    THEN
        -- ���������
        vbMovementId_begin:= (SELECT CASE WHEN vbMovementDescId = zc_Movement_Income()
                                                    -- <������ �� ����������>
                                               THEN lpInsertUpdate_Movement_Income_Value
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Income_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := CASE WHEN inBranchCode BETWEEN 301 AND 310
                                                                                    THEN inOperDatePartner
                                                                                    ELSE inOperDate
                                                                               END
                                                  , inInvNumberPartner      := tmp.InvNumberPartner
                                                  , inPriceWithVAT          := CASE WHEN inBranchCode BETWEEN 1 AND 310
                                                                                         THEN COALESCE ((SELECT tmp.isPriceWithVAT
                                                                                                         FROM lpGet_MovementItem_ContractGoods (inOperDate   := CASE WHEN inBranchCode BETWEEN 1 AND 310 AND vbMovementDescId = zc_Movement_Income()
                                                                                                                                                                     THEN COALESCE ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                                                                                                                                                  , (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                                                                                                                                   )
                                                                                                                                                                     ELSE NULL
                                                                                                                                                                END
                                                                                                                                              , inJuridicalId:= 0
                                                                                                                                              , inPartnerId  := 0
                                                                                                                                              , inContractId := CASE WHEN inBranchCode BETWEEN 1 AND 310 AND vbMovementDescId = zc_Movement_Income()
                                                                                                                                                                     THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                                                                                                                                     ELSE -1
                                                                                                                                                                END
                                                                                                                                              , inGoodsId    := (SELECT MI.ObjectId FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE LIMIT 1)
                                                                                                                                              , inUserId     := vbUserId
                                                                                                                                               ) AS tmp
                                                                                                         LIMIT 1)
                                                                                                      , PriceWithVAT)

                                                                                         ELSE PriceWithVAT -- ������������ �� ���������
                                                                               END
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
                                                  , inComment               := tmp.Comment
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
                                                  , inOperDatePartner       := inOperDatePartner
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
                                                  , inMovementId_ReturnIn   := MLM_ReturnIn.MovementChildId
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                                    -- <������� �� ����������>
                                               THEN lpInsertUpdate_Movement_ReturnIn_scale
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
                                                  , inSubjectDocId          := SubjectDocId
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inCurrencyValue         := NULL
                                                  , inParValue              := NULL
                                                  , inCurrencyPartnerValue  := NULL
                                                  , inParPartnerValue       := NULL
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
                                                  , inProcessId             := CASE WHEN vbUserId = 5 THEN zc_Enum_Process_InsertUpdate_Movement_SendOnPrice() ELSE zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch() END
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
                                                  , inToId                  := CASE WHEN tmp.DescId_to IN (zc_Object_Member(), zc_Object_Car(), zc_Object_Unit()) THEN tmp.ToId ELSE ContractId END -- !!!�� ������!!!
                                                  , inArticleLossId         := CASE WHEN tmp.DescId_to IN (zc_Object_Member(), zc_Object_Car(), zc_Object_Unit()) THEN 0        ELSE ToId       END -- !!!�� ������!!!
                                                  , inPaidKindId            := zc_Enum_PaidKind_SecondForm()
                                                  , inComment               := tmp.Comment
                                                  , inUserId                := vbUserId
                                                   )
                                          WHEN vbMovementDescId = zc_Movement_Send()
                                                    -- <�����������>
                                               THEN lpInsertUpdate_Movement_Send
                                                   (ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_Send_seq') AS TVarChar)
                                                  , inOperDate              := inOperDate
                                                  , inFromId                := CASE WHEN vbFromId_next > 0 THEN vbFromId_next ELSE FromId END
                                                  , inToId                  := CASE WHEN vbFromId_next > 0 THEN vbToId_next   ELSE ToId END
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
                                                  , inPriceListId           := Null ::Integer
                                                  , inisGoodsGroupIn        := FALSE
                                                  , inisGoodsGroupExc       := FALSE
                                                  , inisList                := FALSE
                                                  , inUserId                := vbUserId
                                                   )

                                          END AS MovementId_begin

                                    FROM gpGet_Movement_WeighingPartner (inMovementId:= inMovementId, inSession:= inSession) AS tmp
                                         LEFT JOIN MovementLinkMovement AS MLM_ReturnIn
                                                                        ON MLM_ReturnIn.MovementId = inMovementId
                                                                       AND MLM_ReturnIn.DescId     = zc_MovementLinkMovement_ReturnIn()

                                 );
         -- ��������
         IF COALESCE (vbMovementId_begin, 0) = 0
         THEN
             RAISE EXCEPTION '������.������ ��������� ������ ��� ���������.';
         END IF;

         -- ����������
         vbVATPercent_begin     := (SELECT MF.ValueData FROM MovementFloat   AS MF WHERE MF.MovementId = vbMovementId_begin AND MF.DescId = zc_MovementFloat_VATPercent());
         vbIsPriceWithVAT_begin := (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = vbMovementId_begin AND MB.DescId = zc_MovementBoolean_PriceWithVAT());


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

        -- �������� ������� - � ������
        IF vbMovementDescId = zc_Movement_Income()
        THEN
            -- �������� �������� �������
            vbMovementId_cost:= (SELECT lpInsertUpdate_Movement_IncomeCost (ioId         := 0
                                                                          , inParentId   := vbMovementId_begin                   -- ��� ������
                                                                          , inMovementId := MovementLinkMovement.MovementChildId -- ��� �����
                                                                          , inComment    := ''
                                                                          , inUserId     := vbUserId
                                                                           ) AS MovementId_cost
                                 FROM MovementLinkMovement
                                      LEFT JOIN Movement ON Movement.ParentId = vbMovementId_begin AND Movement.DescId = zc_Movement_IncomeCost()
                                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 WHERE MovementLinkMovement.MovementChildId > 0
                                   AND MovementLinkMovement.MovementId = inMovementId
                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport()
                                   AND Movement.ParentId IS NULL
                                );

        END IF;

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

    ELSEIF inIsDocPartner = FALSE
    THEN
        -- ����������� �������� !!!������������!!!
        PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_begin
                                     , inUserId     := vbUserId);


        -- ��������� ����
        IF vbMovementDescId = zc_Movement_Sale() AND inOperDatePartner <> (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_begin AND MD.DescId = zc_MovementDate_OperDatePartner())
        THEN
            -- ���������
            PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), vbMovementId_begin, inOperDatePartner);
            -- ��������� ��������
            PERFORM lpInsert_MovementProtocol (vbMovementId_begin, vbUserId, FALSE);

            -- ��������� ��� ���������
            UPDATE Movement SET OperDate = inOperDatePartner
            WHERE Movement.Id = (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = vbMovementId_begin AND MLM.DescId = zc_MovementLinkMovement_Master())
              AND Movement.DescId = zc_Movement_Tax();

            -- ��������� �������� ��� ���������
            PERFORM lpInsert_MovementProtocol ((SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = vbMovementId_begin AND MLM.DescId = zc_MovementLinkMovement_Master())
                                             , vbUserId
                                             , FALSE
                                              );

        END IF;


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


    IF inIsDocPartner = FALSE
    THEN
        -- ��������� <�������� �����>
        SELECT MAX (tmpId) INTO vbId_tmp
        FROM (WITH -- ������ � ���������(������������)
                   tmpContractGoods
                        AS (SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.CountForAmount
                            FROM lpGet_MovementItem_ContractGoods (inOperDate   := CASE WHEN inBranchCode BETWEEN 1 AND 310 AND vbMovementDescId = zc_Movement_Income()
                                                                                        THEN COALESCE ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                                                                     , (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                                                      )
                                                                                        ELSE NULL
                                                                                   END
                                                                 , inJuridicalId:= 0
                                                                 , inPartnerId  := 0
                                                                 , inContractId := CASE WHEN inBranchCode BETWEEN 1 AND 310 AND vbMovementDescId = zc_Movement_Income()
                                                                                        THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                                                        ELSE -1
                                                                                   END
                                                                 , inGoodsId    := 0
                                                                 , inUserId     := vbUserId
                                                                  ) AS tmp
                            WHERE inBranchCode BETWEEN 1 AND 310
                              AND vbMovementDescId = zc_Movement_Income()
                           )
                   -- �������� ��������� (���� ��������� ������)
                 , tmpMI AS (SELECT MovementItem.Id                                     AS MovementItemId
                                  , MovementItem.ObjectId                               AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                  , COALESCE (MILinkObject_Box.ObjectId, 0)             AS BoxId
                                  , COALESCE (MILinkObject_Asset.ObjectId, 0)           AS AssetId

                                  , MIDate_PartionGoods.ValueData                       AS PartionGoodsDate
                                  , COALESCE (MIString_PartionGoods.ValueData, '')      AS PartionGoods
                                  , COALESCE (MIString_PartNumber.ValueData,'')         AS PartNumber
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
                                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                               AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
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
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

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
      , tmpGoodsPropertyValue AS (SELECT DISTINCT
                                         ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                     AS GoodsId
                                       , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)   AS GoodsKindId
                                       , ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId                  AS BoxId
                                  FROM ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                       LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                            ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND ObjectLink_GoodsPropertyValue_Goods.DescId   = zc_ObjectLink_GoodsPropertyValue_Goods()
                                       LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                            ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                             ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsBox()

                                  WHERE ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = vbGoodsPropertyId
                                    AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                 )

              -- InsertUpdate
              SELECT CASE WHEN vbMovementDescId = zc_Movement_Income()
                                    -- <������ �� ����������>
                               THEN lpInsertUpdate_MovementItem_Income_Value
                                                            (ioId                  := tmp.MovementItemId_find
                                                           , inMovementId          := vbMovementId_begin
                                                           , inGoodsId             := tmp.GoodsId
                                                           , inAmount              := tmp.Amount
                                                           , inAmountPartner       := tmp.AmountPartner
                                                           , inAmountPartnerSecond := tmp.AmountPartnerSecond
                                                           , inAmountPacker        := tmp.AmountPacker
                                                           , inPrice               := tmp.Price
                                                           , inCountForPrice       := tmp.CountForPrice
                                                           , inPricePartner        := tmp.PricePartner
                                                           , inLiveWeight          := tmp.LiveWeight
                                                           , inHeadCount           := tmp.HeadCount
                                                           , inPartionGoods        := tmp.PartionGoods
                                                           , inPartNumber          := tmp.PartNumber
                                                           , inGoodsKindId         := tmp.GoodsKindId
                                                           , inAssetId             := NULL
                                                           , inStorageId           := NULL
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
                                                           , inAmountPartner       := CASE COALESCE ((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = vbRetailId AND OFl.DescId = zc_ObjectFloat_Retail_RoundWeight()), 0)
                                                                                           WHEN 2 THEN CAST (tmp.AmountPartner AS NUMERIC (16, 2))
                                                                                           WHEN 3 THEN CAST (tmp.AmountPartner AS NUMERIC (16, 3))
                                                                                           ELSE tmp.AmountPartner
                                                                                      END
                                                           , inAmountChangePercent := tmp.AmountChangePercent
                                                           , inChangePercentAmount := tmp.ChangePercentAmount
                                                           , inPrice               := tmp.Price
                                                           , ioCountForPrice       := tmp.CountForPrice
                                                           , inCount               := tmp.Count
                                                           , inHeadCount           := tmp.HeadCount
                                                           , inBoxCount            := CASE WHEN tmpGoodsPropertyValue.BoxId > 0 THEN tmp.BoxCount ELSE 0 END
                                                           , inPartionGoods        := tmp.PartionGoods
                                                           , inGoodsKindId         := tmp.GoodsKindId
                                                           , inAssetId             := NULL
                                                           , inBoxId               := tmpGoodsPropertyValue.BoxId -- tmp.BoxId
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
                                                           , inCount               := tmp.Count
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
                                                           , inPartionGoodsDate    := tmp.PartionGoodsDate
                                                           , inPartionGoods        := tmp.PartionGoods
                                                           , inGoodsKindId         := tmp.GoodsKindId
                                                           , inAssetId             := tmp.AssetId
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
                                                           , inPartNumber          := tmp.PartNumber
                                                           , inGoodsKindId         := tmp.GoodsKindId
                                                           , inAssetId             := tmp.AssetId
                                                           , inAssetId_two         := NULL
                                                           , inUnitId              := NULL -- !!!�� ������, ����� �� �����������!!!
                                                           , inStorageId           := NULL
                                                           , inPartionModelId      := NULL
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
                                                           , inPartNumber          := NULL
                                                           , inPartionGoodsId      := NULL
                                                           , inGoodsKindId         := tmp.GoodsKindId
                                                           , inGoodsKindCompleteId := NULL
                                                           , inAssetId             := NULL
                                                           , inUnitId              := NULL
                                                           , inStorageId           := NULL
                                                           , inPartionModelId      := NULL
                                                           , inUserId              := vbUserId
                                                            )

                     END AS tmpId
             FROM (SELECT MAX (tmp.MovementItemId)      AS MovementItemId_find
                        , tmp.GoodsId
                        , tmp.GoodsKindId
                          -- �.�. ��������
                        , MAX (tmp.BoxId) AS BoxId
                          --
                        , tmp.AssetId
                        , tmp.PartionGoodsDate
                        , tmp.PartionGoods
                        , tmp.PartNumber
                        , SUM (tmp.Amount)              AS Amount
                        , SUM (tmp.AmountChangePercent) AS AmountChangePercent
                        , SUM (tmp.AmountPartner)       AS AmountPartner
                          -- ���������� � ���������� ��� �����
                        , SUM (tmp.AmountPartnerSecond) AS AmountPartnerSecond
                          -- ���� ���������� ��� �����
                        , MAX (tmp.PricePartner)        AS PricePartner

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
                              , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIString_PartNumber.ValueData, '')   END AS PartNumber

                              , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId

                              , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                          THEN MovementItem.Amount -- ����������� ������ ������ = ��� ��� ������

                                     WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                          THEN 0 -- �� �����������, �.�. ������ ������

                                     ELSE MovementItem.Amount -- ������� ��������

                                END
                                -- !!!* ��� ������ ��� ����������� � �����������!!
                              * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                -- ����� �������� �� ���-�� ����������
                              * CASE WHEN tmpContractGoods.CountForAmount > 0 THEN tmpContractGoods.CountForAmount ELSE 1 END
                                AS Amount

                              , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                          THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ����������� ������ ������ = ��� �� �������

                                     WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                          THEN 0 -- �� �����������, �.�. ������ ������

                                     ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ������� �������� = ��� �� �������

                                END
                                -- ����� �������� �� ���-�� ����������
                              * CASE WHEN tmpContractGoods.CountForAmount > 0 THEN tmpContractGoods.CountForAmount ELSE 1 END
                                AS AmountChangePercent

                              , CASE WHEN vbMovementDescId = zc_Movement_Income() AND COALESCE (MIB_AmountPartnerSecond.ValueData, FALSE) = TRUE
                                          -- ���� ������� "��� ������"
                                          THEN COALESCE (MIF_AmountPartnerSecond.ValueData, 0)

                                     WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                          THEN 0 -- �� �����������, �.�. ������ ������

                                     WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                          THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ����������� ������ ������ = ��� �� �������

                                     WHEN vbMovementDescId = zc_Movement_ReturnIn() AND vbMovementId_find > 0
                                          THEN 0 -- �� ����������� - ����� �� ���������� ����������

                                     ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ������� �������� = ��� �� �������

                                END
                                -- ����� �������� �� ���-�� ����������
                              * CASE WHEN tmpContractGoods.CountForAmount > 0 THEN tmpContractGoods.CountForAmount ELSE 1 END
                                AS AmountPartner

                                -- ���������� � ���������� - �� ���������
                              , COALESCE (MIF_AmountPartnerSecond.ValueData, 0) AS AmountPartnerSecond

                                -- ���� ���������� ��� ����� - �� ���������
                              , CASE WHEN vbIsPriceWithVAT_begin = COALESCE (MIB_PriceWithVAT.ValueData, FALSE)
                                          -- ������ �� ������
                                          THEN COALESCE (MIF_PricePartner.ValueData, 0)
                                     -- ������ � ���
                                     WHEN vbIsPriceWithVAT_begin = TRUE  AND COALESCE (MIB_PriceWithVAT.ValueData, FALSE) = FALSE
                                          THEN ROUND (COALESCE (MIF_PricePartner.ValueData, 0) * (1 + vbVATPercent_begin / 100), 2)
                                     -- ������ ��� ���
                                     WHEN vbIsPriceWithVAT_begin = FALSE AND COALESCE (MIB_PriceWithVAT.ValueData, FALSE) = TRUE
                                          THEN ROUND (COALESCE (MIF_PricePartner.ValueData, 0) / (1 + vbVATPercent_begin / 100), 2)

                                END AS PricePartner


                              , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
                                          THEN NULL
                                     -- ���� ���� - ����� �� ���������� ����������
                                     ELSE COALESCE (tmpMI.ChangePercentAmount, COALESCE (MIFloat_ChangePercentAmount.ValueData, 0))
                                END AS ChangePercentAmount

                              , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
                                          THEN NULL
                                     -- ���� ���� - ����� �� ���������� ����������
                                     ELSE COALESCE (tmpMI.Price, COALESCE (MIFloat_Price.ValueData, 0))
                                END
                                AS Price

                              , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE
                                          THEN NULL
                                     -- ����� �������� �� ���-�� ����������
                                     WHEN tmpContractGoods.CountForAmount > 0
                                          THEN tmpContractGoods.CountForAmount
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

                              , MovementItem.Amount
                                -- ����� �������� �� ���-�� ����������
                              * CASE WHEN tmpContractGoods.CountForAmount > 0 THEN tmpContractGoods.CountForAmount ELSE 1 END
                                AS Amount_mi

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

                              -- ���� ���������� ��� ����� - �� ���������
                              LEFT JOIN MovementItemFloat AS MIF_PricePartner
                                                          ON MIF_PricePartner.MovementItemId = MovementItem.Id
                                                         AND MIF_PricePartner.DescId         = zc_MIFloat_PricePartner()
                              -- ���������� � ���������� - �� ���������
                              LEFT JOIN MovementItemFloat AS MIF_AmountPartnerSecond
                                                          ON MIF_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                         AND MIF_AmountPartnerSecond.DescId         = zc_MIFloat_AmountPartnerSecond()

                              -- ���� � ��� ��/��� - ��� ���� ����������
                              LEFT JOIN MovementItemBoolean AS MIB_PriceWithVAT
                                                            ON MIB_PriceWithVAT.MovementItemId = MovementItem.Id
                                                           AND MIB_PriceWithVAT.DescId         = zc_MIBoolean_PriceWithVAT()

                              -- ������� "��� ������"
                              LEFT JOIN MovementItemBoolean AS MIB_AmountPartnerSecond
                                                            ON MIB_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                           AND MIB_AmountPartnerSecond.DescId         = zc_MIBoolean_AmountPartnerSecond()

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
                              LEFT JOIN MovementItemString AS MIString_PartNumber
                                                           ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                          AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                               ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                                                              AND vbMovementDescId = zc_Movement_Sale()
                                                              -- !!!��������
                                                              AND 1=0
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                               ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

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

                              -- ������ � ���������(������������)
                              LEFT JOIN tmpContractGoods ON tmpContractGoods.GoodsId     = MovementItem.ObjectId
                                                        AND tmpContractGoods.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

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
                                      AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK(), 8458))
                                          THEN 0
                                     ELSE tmpMI.BoxId
                                END AS BoxId
                              , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                          -- ����� ���������� + ����� ���� ��
                                      -- AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK(), 8458))
                                      AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (8458))
                                          THEN NULL
                                     ELSE tmpMI.PartionGoodsDate
                                END AS PartionGoodsDate
                              , CASE WHEN vbMovementDescId = zc_Movement_Inventory()
                                          -- ����� ���������� + ����� ���� ��
                                      AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK(), 8458))
                                          THEN ''
                                     ELSE tmpMI.PartionGoods
                                END AS PartionGoods

                              , tmpMI.PartNumber

                              , tmpMI.AssetId

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

                                -- ���������� � ���������� ��� �����
                              , 0 AS AmountPartnerSecond
                                -- ���� ���������� ��� �����
                              , 0 AS PricePartner

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
                        --, tmp.BoxId
                          , tmp.AssetId
                          , tmp.PartionGoodsDate
                          , tmp.PartionGoods
                          , tmp.PartNumber
                          , tmp.ChangePercentAmount
                          , tmp.Price
                          , tmp.CountForPrice
                          , tmp.UnitId_to
                          , tmp.myId -- ���� ��� ������������ - ������ ����������� � ��������� �������
                   HAVING SUM (tmp.Amount_mi) <> 0
                  ) AS tmp
                  LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = tmp.GoodsId
                                                 AND tmpGoodsPropertyValue.GoodsKindId = tmp.GoodsKindId

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
                                                           , inPartNumber          := NULL
                                                           , inModel               := Null
                                                           , inGoodsKindId         := tmp.GoodsKindId
                                                           , inGoodsKindCompleteId := NULL
                                                           , inStorageId           := NULL
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

                      -- �������� ������� - � ������
                      IF vbMovementId_cost > 0 
                      THEN
                          IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem')
                          THEN
                              DROP TABLE _tmpItem;
                          END IF;
              
                          IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem_To')
                          THEN
                              DROP TABLE _tmpItem_To;
                          END IF;
                          IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem_SummPersonal')
                          THEN
                              DROP TABLE _tmpItem_SummPersonal;
                          END IF;
                          
                          -- �������
                          PERFORM lpComplete_Movement_IncomeCost (vbMovementId_cost, vbUserId);
                      END IF;

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
                  IF vbMovementDescId = zc_Movement_Send() AND vbIsUpak_UnComplete = FALSE
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
                  IF vbMovementDescId = zc_Movement_Inventory() AND COALESCE (vbIsCloseInventory, TRUE) = TRUE
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

        IF COALESCE (inMovementDescId_next, 0) >=0
        THEN
   -- if vbUserId <> 5 then
            -- ����� - ��������� <��������> - <����������� (����������)> - ������ ���� + ParentId + AccessKeyId
            PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, vbOperDate_scale, vbMovementId_begin, Movement_begin.AccessKeyId)
            FROM Movement
                 LEFT JOIN Movement AS Movement_begin ON Movement_begin.Id = vbMovementId_begin
            WHERE Movement.Id = inMovementId;

            -- ��������� �������� <�������� �����������>
            PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inMovementId, CURRENT_TIMESTAMP);

            -- ��������� �������� <IP>
            PERFORM lpInsertUpdate_MovementString (zc_MovementString_IP(), inMovementId, inIP);

        END IF;


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

    ELSE 
            -- ����� - ��������� <��������> - <����������� (����������)> - ������ ���� + ParentId + AccessKeyId
            PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, vbOperDate_scale, Movement.ParentId, Movement.AccessKeyId)
            FROM Movement
            WHERE Movement.Id = inMovementId;

            -- ��������� �������� <�������� �����������>
            PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inMovementId, CURRENT_TIMESTAMP);

            -- ��������� �������� <IP>
            PERFORM lpInsertUpdate_MovementString (zc_MovementString_IP(), inMovementId, inIP);

    END IF; -- if inIsDocPartner = FALSE - ��������� <�������� �����>


--��� �����
/*if inMovementId in (8351040) then
    RAISE EXCEPTION ' !!! --- END ALL --- !!! Errr <%>', vbMovementId_begin;
end if;*/

-- !!! �������� !!!
 IF vbUserId = 5 AND 1=0 THEN
-- IF inSession = '1162887' AND 1=1 THEN
    RAISE EXCEPTION 'Admin - Test = OK  %vbIsDocMany = % %MovementId_begin = %  %OperDate = % %OperDatePartner = % %InvNumber = % %TotalCount = % %TotalCountPartner = % %Amount = % %AmountPartner = % %OperDate_scale = % %ContractGoods = %'
  , CHR (13)
  , vbIsDocMany -- vbIsSendOnPriceIn -- inBranchCode -- '��������� �������� ����� 3 ���.'
  , CHR (13)
  , vbMovementId_begin
  , CHR (13)
  , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_begin))
  , CHR (13)
  , zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_begin AND MD.DescId = zc_MovementDate_OperDatePartner()))
  , CHR (13)
  , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_begin)
  , CHR (13)
  , (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = vbMovementId_begin AND MF.DescId = zc_MovementFloat_TotalCount())
  , CHR (13)
  , (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = vbMovementId_begin AND MF.DescId = zc_MovementFloat_TotalCountPartner())
  , CHR (13)
  , (SELECT MI.Amount FROM MovementItem AS MI LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPartner() WHERE MI.MovementId = vbMovementId_begin AND MI.DescId = zc_MI_Master() LIMIT 1)
  , CHR (13)
  , (SELECT MIF.ValueData FROM MovementItem AS MI LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_AmountPartner() WHERE MI.MovementId = vbMovementId_begin AND MI.DescId = zc_MI_Master() LIMIT 1)
  , CHR (13)
  , zfConvert_DateToString (vbOperDate_scale)
  , CHR (13)
--  , zfConvert_DateToString (inOperDate)
  , (select CASE WHEN inBranchCode BETWEEN 1 AND 310
                                                                                         THEN COALESCE ((SELECT tmp.isPriceWithVAT
                                                                                                         FROM lpGet_MovementItem_ContractGoods (inOperDate   := CASE WHEN inBranchCode BETWEEN 1 AND 310 AND vbMovementDescId = zc_Movement_Income()
                                                                                                                                                                     THEN COALESCE ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                                                                                                                                                  , (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                                                                                                                                   )
                                                                                                                                                                     ELSE NULL
                                                                                                                                                                END
                                                                                                                                              , inJuridicalId:= 0
                                                                                                                                              , inPartnerId  := 0
                                                                                                                                              , inContractId := CASE WHEN inBranchCode BETWEEN 1 AND 310 AND vbMovementDescId = zc_Movement_Income()
                                                                                                                                                                     THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                                                                                                                                     ELSE -1
                                                                                                                                                                END
                                                                                                                                              , inGoodsId    := 0
                                                                                                                                              , inUserId     := vbUserId
                                                                                                                                               ) AS tmp
                                                                                                         LIMIT 1)
                                                                                                      , null)

                                                                                         ELSE null
                                                                               END)
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


     -- ���� ������� ��������
     IF inMovementDescId_next > 0
     THEN
          -- ��������� ������ ��������
          vbMovementId_begin_next:= (SELECT gpInsert.MovementId_begin
                                     FROM gpInsert_Scale_Movement_all (inBranchCode          := inBranchCode
                                                                     , inMovementId          := inMovementId
                                                                     , inMovementDescId_next := -1 * inMovementDescId_next
                                                                     , inOperDate            := inOperDate
                                                                     , inOperDatePartner     := inOperDatePartner
                                                                     , inIsDocInsert         := inIsDocInsert
                                                                     , inIsOldPeriod         := inIsOldPeriod
                                                                     , inIP                  := inIP
                                                                     , inSession             := inSession
                                                                      ) AS gpInsert
                                    );

          -- !!!���������!!!
          UPDATE Movement SET ParentId = inMovementId WHERE Id = vbMovementId_begin_next;

      END IF;

     -- ���� �� ������ ��������
     IF COALESCE (inMovementDescId_next, 0) >= 0
     THEN
         -- ����� - ����������� ������ ������ ��������� + ��������� �������� - <����������� (����������)>
         PERFORM lpComplete_Movement (inMovementId := inMovementId
                                    , inDescId     := zc_Movement_WeighingPartner()
                                    , inUserId     := vbUserId
                                     );
     END IF;

     -- ���������
     RETURN QUERY
       SELECT vbMovementId_begin      AS MovementId_begin
            , vbMovementId_begin_next AS MovementId_begin_next
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

/*

-- update Box
--
with tmp1 as
(SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
     , Movement.Id, InvNumber, OperDate

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
WHERE Movement.OperDate between '01.08.2022' and '01.09.2022'
  and Movement.DescID = zc_Movement_Sale()
)

, t1 as (

SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
     , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
     , Movement.Id As MovementId, Movement.OperDate, Movement.InvNumber
, MovementItem.Id
--, MovementItem.ObjectId as goodsId
-- , MILinkObject_GoodsKind.ObjectId as GoodsKindId
, MovementItem.Amount
, MIFloat_BoxCount.ValueData AS BoxCount
, MovementItem.isErased
, coalesce (MILinkObject_Box.ObjectId , 0) as OldId , ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId as NewId

-- , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), MovementItem.Id, ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId)

                          FROM tmp1 AS Movement

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE

                                inner JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()


                                             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = Movement.GoodsPropertyId
                                                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
and ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId > 0


                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
AND MovementItem.ObjectId           = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
AND MILinkObject_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId


                                left  JOIN MovementItemLinkObject AS MILinkObject_Box
                                                                 ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                                 LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                             ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

 -- where coalesce (MILinkObject_Box.ObjectId , 0) <> ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
-- and MovementItem.isErased = false
where MovementItem.isErased = false
order by  MovementItem.Id
)
, t2 as (select * from Movement where ParentId in (select distinct MovementId  from  t1))

, t33 as ( select MovementId, MovementItem.ObjectId as goodsId, MovementItem.Id as MovementItemId
FROM t2
join MovementItem
 on MovementItem.MovementId = t2.Id
and MovementItem.isErased = false
and MovementItem.Descid = zc_MI_Master()
-- where MovementItem.MovementId in (select distinct t2.Id  from  t2)
-- and MovementItem.isErased = false
-- and MovementItem.Descid = zc_MI_Master()
)
, MIFloat_BoxCount as (select * from MovementItemFloat where MovementItemId IN (select distinct MovementItemId from t33) )
, MILinkObject_GoodsKind as (select * from MovementItemLinkObject where MovementItemId IN (select distinct MovementItemId from t33) )

, t3 as (
select MovementId, coalesce(MIFloat_BoxCount.ValueData, 0) as BoxCount
, MovementItem.goodsId, MovementItem.MovementItemId
, MILinkObject_GoodsKind.ObjectId as  GoodsKindId
FROM t33 as MovementItem
       left join MIFloat_BoxCount
              ON MIFloat_BoxCount.MovementItemId = MovementItem.MovementItemId
             AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

                           LEFT JOIN MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
-- where MovementItem.MovementId in (select distinct t2.Id  from  t2)
-- and MovementItem.isErased = false
-- and MovementItem.Descid = zc_MI_Master()
)

, t4 as (select t2.ParentId, goodsId, GoodsKindId, sum(BoxCount) as BoxCount FROM t3 join t2 on t2.Id = t3.MovementId where BoxCount <> 0 group by t2.ParentId, goodsId, GoodsKindId)

, t5 as (select t1 .*, t4.BoxCount as BoxCount_new, MIFloat_BoxCount.ValueData as BoxCount_old
         FROM t1
               join t4 on t4.ParentId = t1.MovementId
                      and t4.goodsId  = t1.goodsId
                      and t4.GoodsKindId = t1.GoodsKindId
left JOIN MovementItemFloat AS MIFloat_BoxCount
                                                       ON MIFloat_BoxCount.MovementItemId = t1 .Id
                                                      AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
-- where OldId <> NewId
)

select *
-- , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), t5.Id, NewId)
  -- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), t5.Id, BoxCount_new)
from t5
left join Object on Object.Id = NewId
 where (BoxCount_new <> coalesce (BoxCount_old, 0)
or NewId <> OldId)
-- and MovementId = 23166802
 -- and MovementId = 23091922
order by OperDate
*/

-- ����
-- SELECT * FROM gpInsert_Scale_Movement_all (inBranchCode:= 2, inMovementId:= 8351040, inOperDate:= CURRENT_DATE, inSession:= '992376') -- ������� �.�.
-- SELECT * FROM gpInsert_Scale_Movement_all (inBranchCode:= 2, inMovementId:= 8351040, inOperDate:= CURRENT_DATE, inSession:= '539736') -- ׸���� �.�.

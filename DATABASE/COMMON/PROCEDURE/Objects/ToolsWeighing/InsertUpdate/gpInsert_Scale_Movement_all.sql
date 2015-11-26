-- Function: gpInsert_Scale_Movement_all()

DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_Movement_all(
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

   DECLARE vbBranchId         Integer;
   DECLARE vbIsUnitCheck      Boolean;
   DECLARE vbIsSendOnPriceIn  Boolean;
   DECLARE vbIsProductionIn   Boolean;

   DECLARE vbMovementId_find  Integer;
   DECLARE vbMovementId_begin Integer;
   DECLARE vbMovementDescId   Integer;
   DECLARE vbIsTax            Boolean;

   DECLARE vbOperDate_scale TDateTime;
   DECLARE vbOperDatePartner_order TDateTime;
   DECLARE vbOperDate_order TDateTime;
   DECLARE vbId_tmp Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ ��� ���������.';
     END IF;


     IF EXISTS (SELECT 1
                FROM MovementLinkMovement AS MovementLinkMovement_Order
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = inMovementId
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_find
                                                  ON MovementLinkObject_Contract_find.MovementId = MovementLinkMovement_Order.MovementChildId
                                                 AND MovementLinkObject_Contract_find.DescId = zc_MovementLinkObject_Contract()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_Contract.ObjectId <> MovementLinkObject_Contract_find.ObjectId)
     THEN 
         -- ��������� ����� � <��������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, MovementLinkObject_Contract.ObjectId)
         FROM MovementLinkMovement AS MovementLinkMovement_Order
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = inMovementId
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_find
                                                  ON MovementLinkObject_Contract_find.MovementId = MovementLinkMovement_Order.MovementChildId
                                                 AND MovementLinkObject_Contract_find.DescId = zc_MovementLinkObject_Contract()
                WHERE MovementLinkMovement_Order.MovementId = inMovementId
                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                  AND MovementLinkObject_Contract.ObjectId <> MovementLinkObject_Contract_find.ObjectId;
     END IF;



     -- ���������� 
     vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                       ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                  END;
     -- ���������� <��� ���������>
     vbMovementDescId:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_MovementDesc()) :: Integer;

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
     IF vbMovementDescId = zc_Movement_Send() AND -- ���� ����� "�� ����"
                                                  (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                  IN (SELECT 8451 -- ��� ��������
                                                     UNION
                                                      SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8453) AS lfSelect -- ������
                                                     )
                                              AND -- ���� ����� "����"
                                                  (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                  IN (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId <> 8450 -- ��� �������+���-�� <> ��� ��������
                                                     UNION
                                                      SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8439) AS lfSelect -- ������� ������� �����
                                                     )
                                              AND -- ���� ��� �� ����������� �����������
                                                  NOT EXISTS
                                                  (SELECT MovementItem.MovementId
                                                   FROM MovementItem
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30301() -- ������ + ����������� + �����������
                                                  )
     THEN
         vbMovementDescId:= zc_Movement_ProductionUnion();
         vbIsProductionIn:= FALSE;
     ELSE
         vbIsProductionIn:= NULL;
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
     inOperDate:= CASE WHEN vbBranchId = zc_Branch_Basis()
                            THEN inOperDate
                       ELSE vbOperDatePartner_order
                 END;

     -- ������� - "��������� �������"
     CREATE TEMP TABLE _tmpUnit_check (UnitId Integer) ON COMMIT DROP;
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
    ;


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
          -- ����� ������������� ��������� <������� ����������> �� ������
          vbMovementId_find:= (SELECT Movement.Id
                                FROM MovementLinkMovement
                                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                     ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                     INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                        AND Movement.DescId = zc_Movement_Sale()
                                                        AND Movement.OperDate = inOperDate
                                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                WHERE MovementLinkMovement.MovementId = inMovementId
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order());
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

     IF vbMovementDescId = zc_Movement_SendOnPrice() AND EXISTS (SELECT MLM_Order.MovementChildId
                                                                 FROM MovementLinkMovement AS MLM_Order
                                                                      JOIN Movement ON Movement.Id = MLM_Order.MovementChildId
                                                                                   AND Movement.DescId = zc_Movement_SendOnPrice()
                                                                                   AND Movement.OperDate BETWEEN inOperDate - INTERVAL '4 DAY' AND inOperDate
                                                                 WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order())
     THEN
         -- ����� ������������� ��������� <����������� �� ����> !!!����� �������� ����!!!
          vbMovementId_find:= (SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order());
          -- ��� "��������� �������", ����� ������ = ������ !!!��������, �.�. ������ ���� ���!!!
          vbIsUnitCheck:= EXISTS (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To()));
          -- ��� "������" �� "��������� �������"
          vbIsSendOnPriceIn:= CASE WHEN vbIsUnitCheck = FALSE
                                        THEN FALSE -- �.�. �� �����
                                   WHEN vbBranchId = zc_Branch_Basis() AND EXISTS (SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO_From.ObjectId WHERE MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From())
                                        THEN TRUE -- ��� �������� - ������ �� ����
                                   WHEN vbBranchId = zc_Branch_Basis() AND EXISTS (SELECT MLO_To.ObjectId   FROM MovementLinkObject AS MLO_To   JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO_To.ObjectId   WHERE MLO_To.MovementId = inMovementId   AND MLO_To.DescId   = zc_MovementLinkObject_To())
                                        THEN FALSE -- ��� �������� - ������ � ����
                                   WHEN EXISTS (SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To     JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO_To.ObjectId   WHERE MLO_To.MovementId   = inMovementId AND MLO_To.DescId   = zc_MovementLinkObject_To())
                                        THEN TRUE -- ��� ������� - ������ �� ����
                                   WHEN EXISTS (SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From JOIN _tmpUnit_check ON _tmpUnit_check.UnitId = MLO_From.ObjectId WHERE MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From())
                                        THEN FALSE -- ��� ������� - ������ � ����
                              END;

          -- �������� vbMovementId_find
          IF  (COALESCE (vbMovementId_find, 0) <> 0 AND vbIsUnitCheck     = FALSE) -- �.�. vbMovementId_find �� ������ ����
           OR (COALESCE (vbMovementId_find, 0) = 0  AND vbIsSendOnPriceIn = TRUE)  -- �.�. ������ ������, � vbMovementId_find ���
           OR (COALESCE (vbMovementId_find, 0) <> 0 AND vbIsSendOnPriceIn = FALSE) -- �.�. ������ ������, � vbMovementId_find ����
          THEN
               RAISE EXCEPTION 'vbMovementId_find <%>', vbMovementId_find;
          END IF;
     ELSE
     IF vbMovementDescId = zc_Movement_SendOnPrice()
     THEN
          -- ����� ������������� ��������� <����������� �� ����> �� ������
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
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order());
     END IF;
     END IF;


     -- ���������
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
                                                  , inPriceWithVAT          := PriceWithVAT
                                                  , inVATPercent            := VATPercent
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inPersonalPackerId      := NULL
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
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
                                                  , inOperDatePartner       := -- !!!���� �� ������, ����� ������ OperDatePartner �� OperDate ������ - ���� ������ ��� inBranchCode = 201, 
                                                                              (CASE WHEN inBranchCode = 201 THEN vbOperDate_order ELSE inOperDate END
                                                                             + (CASE WHEN inBranchCode = 201 THEN COALESCE (ObjectFloat_PrepareDayCount.ValueData, 0) ELSE 0 END :: TVarChar || ' DAY') :: INTERVAL
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
        IF vbIsTax = TRUE
        THEN
             -- ���������
             PERFORM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := vbMovementId_begin
                                                          , inDocumentTaxKindId     := zc_Enum_DocumentTaxKind_Tax()
                                                          , inDocumentTaxKindId_inf := NULL
                                                          , inUserId                := vbUserId
                                                           );
        END IF;

    ELSE
        -- ����������� �������� !!!������������!!!
        PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_begin
                                     , inUserId     := vbUserId);

        -- ��� !!!������������!!! zc_Movement_SendOnPrice �������� <���� �������> + <���� (� ���������)> (���� ��� ������ ���)
        IF vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsUnitCheck = TRUE
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
                RAISE EXCEPTION '������.<���� �������> �� ����� ����������.';
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
     FROM (SELECT CASE WHEN vbMovementDescId = zc_Movement_Income()
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
                                                        , inPartionGoods        := ''
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
                                                        , inAmountPartner       := tmp.Amount
                                                        , inPrice               := tmp.Price
                                                        , inCountForPrice       := tmp.CountForPrice
                                                        , inHeadCount           := 0
                                                        , inPartionGoods        := tmp.PartionGoods
                                                        , inGoodsKindId         := tmp.GoodsKindId
                                                        , inAssetId             := NULL
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
                     , SUM (tmp.BoxCount)     AS BoxCount
                     , SUM (tmp.Count)        AS Count
                     , SUM (tmp.CountPack)    AS CountPack
                     , SUM (tmp.HeadCount)    AS HeadCount
                     , SUM (tmp.LiveWeight)   AS LiveWeight
                     , SUM (tmp.AmountPacker) AS AmountPacker
                     , MAX (tmp.isBarCode_value) AS isBarCode_value
                     , tmp.UnitId_to
                FROM (SELECT 0                                                   AS MovementItemId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN zc_Goods_ReWork() ELSE MovementItem.ObjectId             END AS GoodsId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  END AS GoodsKindId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MILinkObject_Box.ObjectId, 0)        END AS BoxId
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE MIDate_PartionGoods.ValueData                  END AS PartionGoodsDate
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIString_PartionGoods.ValueData, '') END AS PartionGoods

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsUnitCheck = FALSE
                                       THEN MovementItem.Amount -- ������ = ������ = ��� ��� ������
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN MovementItem.Amount -- ����������� ������ ������ = ��� ��� ������
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN 0 -- �� �����������, �.�. ������ ������
                                  ELSE MovementItem.Amount -- ������� ��������
                             END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount -- !!!* ��� ������ ��� ����������� � �����������!!

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsUnitCheck = FALSE
                                       THEN MovementItem.Amount -- ������ = ������ = ��� ��� ������
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN MovementItem.Amount -- ����������� ������ ������ = ��� ��� ������
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN 0 -- �� �����������, �.�. ������ ������
                                  ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ������� �������� = ��� �� �������
                             END AS AmountChangePercent

                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsUnitCheck = FALSE
                                       THEN MovementItem.Amount -- ������ = ������ = ��� ��� ������
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = FALSE
                                       THEN 0 -- �� �����������, �.�. ������ ������
                                  WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN MovementItem.Amount -- ����������� ������ ������ = ��� ��� ������
                                  ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) -- ������� �������� = ��� �� �������
                             END AS AmountPartner

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) END AS ChangePercentAmount

                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIFloat_Price.ValueData, 0)               END AS Price
                           , CASE WHEN vbMovementDescId = zc_Movement_ProductionUnion() AND vbIsProductionIn = FALSE THEN NULL ELSE COALESCE (MIFloat_CountForPrice.ValueData, 0)       END AS CountForPrice

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
                                  WHEN vbMovementDescId IN (zc_Movement_Send()) AND inBranchCode = 201 -- ���� �������
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

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     UNION ALL
                      SELECT MovementItem.Id                                     AS MovementItemId
                           , MovementItem.ObjectId                               AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                           , COALESCE (MILinkObject_Box.ObjectId, 0)             AS BoxId
                           , MIDate_PartionGoods.ValueData                       AS PartionGoodsDate
                           , COALESCE (MIString_PartionGoods.ValueData, '')      AS PartionGoods

                           , MovementItem.Amount                                 AS Amount
                           , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS AmountChangePercent
                           , CASE WHEN vbMovementDescId = zc_Movement_SendOnPrice() AND vbIsSendOnPriceIn = TRUE
                                       THEN 0 -- �� �����������, �.�. ������ ������ (!!!�.�. ����� ������� 1 ���!!!)
                                  ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0)
                             END AS AmountPartner
                           , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount

                           , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                           , COALESCE (MIFloat_CountForPrice.ValueData, 0)       AS CountForPrice

                           , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                           , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                           , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , COALESCE (MIFloat_AmountPacker.ValueData, 0)        AS AmountPacker
                           , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight

                           , CASE WHEN MIBoolean_BarCode.ValueData = TRUE THEN 1 ELSE 0 END AS isBarCode_value

                           , 0                                                   AS Amount_mi
                           , COALESCE (MILinkObject_To.ObjectId, COALESCE (MLO_To.ObjectId, 0)) AS UnitId_to
                           , 0                                                   AS myId
                      FROM MovementItem
                           LEFT JOIN MovementLinkObject AS MLO_To
                                                        ON MLO_To.MovementId = MovementItem.MovementId
                                                       AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                       AND vbMovementDescId = zc_Movement_SendOnPrice()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_To
                                                            ON MILinkObject_To.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_To.DescId = zc_MILinkObject_Unit()
                                                           AND vbMovementDescId = zc_Movement_SendOnPrice()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                       ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
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
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                       ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                           LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                      AND vbMovementDescId NOT IN (zc_Movement_Inventory())
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                                      AND vbMovementDescId NOT IN (zc_Movement_Inventory())

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

                      WHERE MovementItem.MovementId = vbMovementId_find
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_Inventory(), zc_Movement_SendOnPrice())
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


     -- ����� - ��������� <��������> - <����������� (����������)> - ������ ���� + ParentId + AccessKeyId
     PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, vbOperDate_scale, vbMovementId_begin, Movement_begin.AccessKeyId)
     FROM Movement
          LEFT JOIN Movement AS Movement_begin ON Movement_begin.Id = vbMovementId_begin
     WHERE Movement.Id = inMovementId ;

     -- ��������� �������� <�������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inMovementId, CURRENT_TIMESTAMP);

     -- ����� - ����������� ������ ������ ��������� + ��������� �������� - <����������� (����������)>
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingPartner()
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.11.15                                        *
 04.07.15                                        * !!!�������� ��� �������� ����!!!
 27.05.15                                        * add vbIsTax
 03.02.15                                        *
*/
-- ����
-- SELECT * FROM gpInsert_Scale_Movement_all (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')

-- Function: gpComplete_Movement_WeighingPartner_diff (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_WeighingPartner_diff (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_WeighingPartner_diff(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbInvNumberPartner TVarChar;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION '������.�������� ��� ��������.';
     END IF;
     -- ��������
     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner())
     THEN
         RAISE EXCEPTION '������.�������� ���������� �� ������.';
     END IF;


     -- ��������� �� ���������
     vbOperDate        := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     vbInvNumberPartner:= (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner());
     vbContractId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     vbPaidKindId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind());


     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_income_diff (MovementId Integer, MovementItemId Integer, AmountPartner TFloat, AmountPartnerSecond TFloat, PricePartner TFloat, Ord Integer) ON COMMIT DROP;

     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem_income_diff (MovementId, MovementItemId, AmountPartner, AmountPartnerSecond, PricePartner, Ord)
        WITH -- ���. ����������� - ������ ����������
             tmpMI_partner AS (SELECT gpSelect.MovementId_income
                                    , gpSelect.GoodsId
                                    , COALESCE (gpSelect.GoodsKindId, 0) AS GoodsKindId
                                      -- ���-�� ��������� � ������ % ������ ���-��
                                    , gpSelect.Amount_income_calc
                                      -- ���������� ����������
                                    , gpSelect.AmountPartnerSecond
                                      --
                                    , gpSelect.PricePartnerNoVAT
                                    , gpSelect.PricePartnerWVAT
 
                               FROM gpSelect_MI_WeighingPartner_diff (inMovementId, FALSE, inSession) AS gpSelect
                              )
        -- ��� �������, � ���������� InvNumberPartner + ContractId + PaidKindId +  ��� ���� �����������
      , tmpMovement AS (SELECT Movement.Id                                  AS MovementId
                             , COALESCE (MF_VATPercent.ValueData, 0)        AS VATPercent
                             , COALESCE (MB_PriceWithVAT.ValueData, FALSE)  AS isPriceWithVAT
                        FROM Movement
                             LEFT JOIN MovementFloat AS MF_VATPercent
                                                     ON MF_VATPercent.MovementId = Movement.Id
                                                    AND MF_VATPercent.DescId     = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementBoolean AS MB_PriceWithVAT
                                                       ON MB_PriceWithVAT.MovementId = Movement.Id
                                                      AND MB_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()
                             INNER JOIN MovementString AS MovementString_InvNumberPartner
                                                       ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                      AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                                      AND MovementString_InvNumberPartner.ValueData  = vbInvNumberPartner
                                                      AND vbInvNumberPartner <> ''
                             INNER JOIN MovementLinkObject AS MLO_Contract
                                                           ON MLO_Contract.MovementId = Movement.Id
                                                          AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                          AND MLO_Contract.ObjectId   = vbContractId
                             INNER JOIN MovementLinkObject AS MLO_PaidKind
                                                           ON MLO_PaidKind.MovementId = Movement.Id
                                                          AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                                          AND MLO_PaidKind.ObjectId   = vbPaidKindId
                        WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate + INTERVAL '1 DAY'
                          AND Movement.DescId   = zc_Movement_Income()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       )

   , tmpMI_income AS (SELECT MovementItem.Id AS MovementItemId
                           , MovementItem.MovementId
                           , MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount
                           , tmpMovement.VATPercent
                           , tmpMovement.isPriceWithVAT
                      FROM tmpMovement
                           JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     )
       -- ���������
       SELECT tmpMI_income.MovementId
            , tmpMI_income.MovementItemId
              -- ���-�� ��������� � ������ % ������ ���-��
            , tmpMI_partner.Amount_income_calc
              -- ���������� ����������
            , tmpMI_partner.AmountPartnerSecond
              --
            , CASE WHEN tmpMI_income.isPriceWithVAT = TRUE THEN tmpMI_partner.PricePartnerWVAT ELSE tmpMI_partner.PricePartnerNoVAT END AS PricePartner
              -- � �/�
            , ROW_NUMBER() OVER (PARTITION BY tmpMI_income.MovementId, tmpMI_income.GoodsId, tmpMI_income.GoodsKindId ORDER BY tmpMI_income.Amount DESC) AS Ord

       FROM tmpMI_partner
            INNER JOIN tmpMI_income ON tmpMI_income.MovementId  = tmpMI_partner.MovementId_income
                                   AND tmpMI_income.GoodsId     = tmpMI_partner.GoodsId
                                   AND tmpMI_income.GoodsKindId = tmpMI_partner.GoodsKindId
       WHERE tmpMI_partner.MovementId_income > 0

      UNION ALL
       SELECT tmpMI_income.MovementId
            , tmpMI_income.MovementItemId
              -- ���-�� ��������� � ������ % ������ ���-��
            , tmpMI_partner.Amount_income_calc
              -- ���������� ����������
            , tmpMI_partner.AmountPartnerSecond
              --
            , CASE WHEN tmpMI_income.isPriceWithVAT = TRUE THEN tmpMI_partner.PricePartnerWVAT ELSE tmpMI_partner.PricePartnerNoVAT END AS PricePartner
              -- � �/�
            , ROW_NUMBER() OVER (PARTITION BY tmpMI_income.GoodsId, tmpMI_income.GoodsKindId ORDER BY tmpMI_income.Amount DESC) AS Ord

       FROM tmpMI_income
            INNER JOIN tmpMI_partner ON tmpMI_partner.MovementId_income = 0
                                    AND tmpMI_partner.GoodsId           = tmpMI_income.GoodsId
                                    AND tmpMI_partner.GoodsKindId       = tmpMI_income.GoodsKindId
            LEFT JOIN tmpMI_partner AS tmpMI_partner_check
                                    ON tmpMI_partner_check.MovementId_income = tmpMI_income.MovementId
                                   AND tmpMI_partner_check.GoodsId           = tmpMI_income.GoodsId
                                   AND tmpMI_partner_check.GoodsKindId       = tmpMI_income.GoodsKindId
       WHERE tmpMI_partner_check.MovementId_income IS NULL
      ;


         -- ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (_tmpMI.MovementItemId, vbUserId, FALSE)
         -- ���������
         FROM (SELECT CASE WHEN _tmpItem_income_diff.Ord = 1
                           THEN 
                               -- ���������� ����������
                               lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), _tmpItem_income_diff.MovementItemId, _tmpItem_income_diff.AmountPartner)
                      END

                   ,  CASE WHEN _tmpItem_income_diff.Ord = 1
                           THEN 
                               -- ���������� ���������� -  �� ��������� ����������
                               lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), _tmpItem_income_diff.MovementItemId, _tmpItem_income_diff.AmountPartnerSecond)
                      END

                      -- ���� ����������
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), _tmpItem_income_diff.MovementItemId, _tmpItem_income_diff.PricePartner)

                    , _tmpItem_income_diff.MovementItemId

               FROM _tmpItem_income_diff
              ) AS _tmpMI;



     -- ��������� �������� <�������� ���������� (��/���)>
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DocPartner(), inMovementId, TRUE);

     -- �������� �������� + ��������� ��������
     /*PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingPartner()
                                , inUserId     := vbUserId
                                 );*/
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.11.24                                        *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_WeighingPartner_diff (inMovementId:= -1, inSession:= zfCalc_UserAdmin())

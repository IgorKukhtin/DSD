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
   DECLARE vbOperDatePartner TDateTime;
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
     vbOperDatePartner := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner());
     vbInvNumberPartner:= (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner());
     vbContractId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     vbPaidKindId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind());


     -- ������� - �������� ������������
     CREATE TEMP TABLE _tmpContractGoods_diff ON COMMIT DROP
        AS (SELECT lpGet.GoodsId, CASE WHEN lpGet.GoodsKindId > 0 THEN lpGet.GoodsKindId ELSE zc_GoodsKind_Basis() END AS GoodsKindId
                 , lpGet.ValuePrice, lpGet.ValuePrice_from, lpGet.ValuePrice_to
                   -- ����
                 , CASE WHEN vbUserId = 5 THEN 0 ELSE 0 END + lpGet.ValuePrice_notVat AS ValuePrice_notVat
                 , lpGet.ValuePrice_from_notVat, lpGet.ValuePrice_to_notVat
                   -- ����
                 , CASE WHEN vbUserId = 5 THEN 0 ELSE 0 END + lpGet.ValuePrice_addVat AS ValuePrice_addVat
                 , lpGet.ValuePrice_from_addVat, lpGet.ValuePrice_to_addVat

            FROM lpGet_MovementItem_ContractGoods (inOperDate    := vbOperDatePartner
                                                 , inJuridicalId := 0
                                                 , inPartnerId   := 0
                                                 , inContractId  := vbContractId
                                                 , inGoodsId     := 0
                                                 , inUserId      := vbUserId
                                                  ) AS lpGet
           );


     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_income_diff (MovementId Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, AmountPartnerSecond TFloat, PricePartner TFloat, OperPrice TFloat, Ord Integer) ON COMMIT DROP;

     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem_income_diff (MovementId, MovementItemId, GoodsId, GoodsKindId, AmountPartner, AmountPartnerSecond, PricePartner, OperPrice, Ord)
        WITH -- ���. ����������� - ������ ����������
             tmpMI_partner AS (SELECT -- ��� 2.����������� - ��� �����
                                      gpSelect.MovementId_income
                                      --
                                    , gpSelect.GoodsId
                                    , COALESCE (gpSelect.GoodsKindId, 0) AS GoodsKindId
                                      -- ���-�� ��������� � ������ % ������ ���-��
                                    , gpSelect.Amount_income_calc
                                      -- ���������� ���������� - ������������
                                    , gpSelect.AmountPartnerSecond
                                      --
                                    , gpSelect.PricePartnerNoVAT
                                    , gpSelect.PricePartnerWVAT

                               FROM gpSelect_MI_WeighingPartner_diff (inMovementId, FALSE, inSession) AS gpSelect
                              )
        -- ��� ������� ����, � ���������� InvNumberPartner + ContractId + PaidKindId
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
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                       )

     -- ���. ������ - ����
   , tmpMI_income AS (SELECT MovementItem.Id AS MovementItemId
                           , MovementItem.MovementId
                           , COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId)                  AS GoodsId
                           , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             -- ���-�� �����
                           , MovementItem.Amount
                             --
                           , tmpMovement.VATPercent
                           , tmpMovement.isPriceWithVAT
                      FROM tmpMovement
                           JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                                            ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                                            ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()
                     )
     -- ���. ������ - ���� - ����� � ����� ��������� ����� ������������
   , tmpMI_income_find AS (SELECT tmpMI_income.MovementItemId
                                , tmpMI_income.MovementId
                                , tmpMI_income.GoodsId
                                , tmpMI_income.GoodsKindId
                                  -- ���-�� �����
                                , tmpMI_income.Amount
                                  --
                                , tmpMI_income.VATPercent
                                , tmpMI_income.isPriceWithVAT
 
                           FROM tmpMI_income
                                -- ��������� �� �������
                                LEFT JOIN tmpMI_partner AS tmpMI_partner_check
                                                        ON tmpMI_partner_check.MovementId_income = tmpMI_income.MovementId
                                                       AND tmpMI_partner_check.GoodsId           = tmpMI_income.GoodsId
                                                       AND tmpMI_partner_check.GoodsKindId       = tmpMI_income.GoodsKindId
                           -- ��� ���������� �� �������
                           WHERE tmpMI_partner_check.MovementId_income IS NULL
                          )

     -- ���. ����������� - ������ ���������� - ����� ����� ��������� ����� ������������
   , tmpMI_partner_find AS (SELECT tmpMI_partner.GoodsId
                                 , tmpMI_partner.GoodsKindId
 
                                 , MAX (tmpMI_partner.PricePartnerWVAT)  AS PricePartnerWVAT
                                 , MAX (tmpMI_partner.PricePartnerNoVAT) AS PricePartnerNoVAT
 
                                   -- ���-�� ��������� � ������ % ������ ���-��
                                 , SUM (tmpMI_partner.Amount_income_calc)   AS Amount_income_calc
                                   -- ���������� ���������� - ������������
                                 , SUM (tmpMI_partner.AmountPartnerSecond)  AS AmountPartnerSecond
                            FROM tmpMI_partner
                            --  ��� ���������� �� �������
                            WHERE tmpMI_partner.MovementId_income = 0
                            GROUP BY tmpMI_partner.GoodsId
                                   , tmpMI_partner.GoodsKindId
                           )

     -- ���. ������ - ����
   , tmpMI_income_res AS (SELECT tmpMI_income.MovementItemId
                               , tmpMI_income.MovementId
                               , tmpMI_income.GoodsId
                               , tmpMI_income.GoodsKindId

                                 -- ������������ ���-�� ��������� � ������ % ������ ���-��
                               , CAST (tmpMI_partner_find.Amount_income_calc  * tmpMI_income.Amount / tmpMI_income_sum.Amount_sum AS NUMERIC (16, 2)) AS Amount_income_calc
                                 -- ������������ ���������� ���������� - ������������
                               , CAST (tmpMI_partner_find.AmountPartnerSecond * tmpMI_income.Amount / tmpMI_income_sum.Amount_sum AS NUMERIC (16, 2)) AS AmountPartnerSecond
                                 --
                               , tmpMI_income.VATPercent
                               , tmpMI_income.isPriceWithVAT
                                 --
                               , tmpMI_partner_find.PricePartnerWVAT
                               , tmpMI_partner_find.PricePartnerNoVAT

                                 -- � �/�
                               , ROW_NUMBER() OVER (PARTITION BY tmpMI_income.GoodsId, tmpMI_income.GoodsKindId ORDER BY tmpMI_income.Amount DESC) AS Ord

                          FROM tmpMI_income_find AS tmpMI_income
                               -- ���. ������ - ���� - ����� ��� ���������
                               INNER JOIN (SELECT tmpMI_income_find.GoodsId
                                                , tmpMI_income_find.GoodsKindId
                                                  -- ���-�� ����� ���� - ��������������� ��� ����������� ���-�� ���������
                                                , SUM (tmpMI_income_find.Amount)   AS Amount_sum
                                           FROM tmpMI_income_find
                                           GROUP BY tmpMI_income_find.GoodsId
                                                  , tmpMI_income_find.GoodsKindId
                                          ) AS tmpMI_income_sum
                                            ON tmpMI_income_sum.GoodsId     = tmpMI_income.GoodsId
                                           AND tmpMI_income_sum.GoodsKindId = tmpMI_income.GoodsKindId

                               -- ���. ����������� - ����� ������ ����������
                               INNER JOIN tmpMI_partner_find ON tmpMI_partner_find.GoodsId     = tmpMI_income.GoodsId
                                                            AND tmpMI_partner_find.GoodsKindId = tmpMI_income.GoodsKindId
                         )
       -- ���������
       SELECT tmpMI_income.MovementId
            , tmpMI_income.MovementItemId
            , tmpMI_income.GoodsId
            , tmpMI_income.GoodsKindId

              -- ���-�� ��������� � ������ % ������ ���-��
            , tmpMI_partner.Amount_income_calc
              -- ���������� ���������� - ������������
            , tmpMI_partner.AmountPartnerSecond
              --
            , CASE WHEN tmpMI_income.isPriceWithVAT = TRUE THEN tmpMI_partner.PricePartnerWVAT ELSE tmpMI_partner.PricePartnerNoVAT END AS PricePartner
              --
            , CASE WHEN tmpMI_income.isPriceWithVAT = TRUE THEN _tmpContractGoods_diff.ValuePrice_addVat ELSE _tmpContractGoods_diff.ValuePrice_notVat END AS OperPrice
              -- � �/�
            , ROW_NUMBER() OVER (PARTITION BY tmpMI_income.MovementId, tmpMI_income.GoodsId, tmpMI_income.GoodsKindId ORDER BY tmpMI_income.Amount DESC) AS Ord

       -- ���. ����������� - ������ ����������
       FROM tmpMI_partner
            -- ���. ������ - ���� - � ���� ������� ����������� ���-�� ����������
            INNER JOIN tmpMI_income ON tmpMI_income.MovementId  = tmpMI_partner.MovementId_income
                                   AND tmpMI_income.GoodsId     = tmpMI_partner.GoodsId
                                   AND tmpMI_income.GoodsKindId = tmpMI_partner.GoodsKindId
            -- ������������
            LEFT JOIN _tmpContractGoods_diff ON _tmpContractGoods_diff.GoodsId     = tmpMI_partner.GoodsId
                                            AND _tmpContractGoods_diff.GoodsKindId = tmpMI_partner.GoodsKindId

       -- ���� ��������� �� �������
       WHERE tmpMI_partner.MovementId_income > 0

      UNION ALL
       SELECT tmpMI_income.MovementId
            , tmpMI_income.MovementItemId
            , tmpMI_income.GoodsId
            , tmpMI_income.GoodsKindId

              -- ���-�� ��������� � ������ % ������ ���-�� ���� "������������� ����������"
            , tmpMI_income.Amount_income_calc + CASE WHEN tmpMI_income.ord = 1 THEN COALESCE (tmpMI_partner_find.Amount_income_calc, 0) - COALESCE (tmpMI_income_sum.Amount_income_calc, 0) ELSE 0 END
              -- ���������� ���������� - ������������
            , tmpMI_income.AmountPartnerSecond + CASE WHEN tmpMI_income.ord = 1 THEN COALESCE (tmpMI_partner_find.AmountPartnerSecond, 0) - COALESCE (tmpMI_income_sum.AmountPartnerSecond, 0) ELSE 0 END
              --
            , CASE WHEN tmpMI_income.isPriceWithVAT = TRUE THEN tmpMI_income.PricePartnerWVAT ELSE tmpMI_income.PricePartnerNoVAT END AS PricePartner
              --
            , CASE WHEN tmpMI_income.isPriceWithVAT = TRUE THEN _tmpContractGoods_diff.ValuePrice_addVat ELSE _tmpContractGoods_diff.ValuePrice_notVat END AS OperPrice
              -- � �/�
            , 1 AS Ord

       -- ���. ������ - ����
       FROM tmpMI_income_res AS tmpMI_income
            -- ����� ����� �������������
            LEFT JOIN (SELECT tmpMI_income_res.GoodsId
                            , tmpMI_income_res.GoodsKindId
                              -- ������������ ���-�� ��������� � ������ % ������ ���-��
                            , SUM (tmpMI_income_res.Amount_income_calc)  AS Amount_income_calc
                              -- ������������ ���������� ���������� - ������������
                            , SUM (tmpMI_income_res.AmountPartnerSecond) AS AmountPartnerSecond
                       FROM tmpMI_income_res
                       GROUP BY tmpMI_income_res.GoodsId
                              , tmpMI_income_res.GoodsKindId
                      ) AS tmpMI_income_sum
                        ON tmpMI_income_sum.GoodsId     = tmpMI_income.GoodsId
                       AND tmpMI_income_sum.GoodsKindId = tmpMI_income.GoodsKindId

            -- ���. ����������� - ����� ������ ����������
            LEFT JOIN tmpMI_partner_find ON tmpMI_partner_find.GoodsId     = tmpMI_income.GoodsId
                                        AND tmpMI_partner_find.GoodsKindId = tmpMI_income.GoodsKindId

            -- ������������
            LEFT JOIN _tmpContractGoods_diff ON _tmpContractGoods_diff.GoodsId     = tmpMI_income.GoodsId
                                            AND _tmpContractGoods_diff.GoodsKindId = tmpMI_income.GoodsKindId
      ;


IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.<%>   <%>', (select _tmpItem_income_diff.AmountPartner from _tmpItem_income_diff WHERE _tmpItem_income_diff.MovementItemId = 308783810 )
                                      , (select MovementItemFloat.ValueData from MovementItemFloat WHERE MovementItemFloat.MovementItemId = 308783810 and MovementItemFloat.descId = zc_MIFloat_AmountPartner())
                                       ;
END IF;


         -- 1. ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (_tmpMI.MovementItemId, vbUserId, FALSE)
         -- ���������
         FROM (SELECT 
                      -- ���������� ����������
                      lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), _tmpItem_income_diff.MovementItemId
                                                      , CASE WHEN _tmpItem_income_diff.Ord = 1 THEN COALESCE (_tmpItem_income_diff.AmountPartner, 0) ELSE 0 END
                                                       )

                   ,  -- ���������� ���������� -  �� ��������� ����������
                      lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), _tmpItem_income_diff.MovementItemId
                                                      , CASE WHEN _tmpItem_income_diff.Ord = 1 THEN COALESCE (_tmpItem_income_diff.AmountPartnerSecond, 0) ELSE 0 END
                                                       )
                      -- ���� ����������
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), _tmpItem_income_diff.MovementItemId, COALESCE (_tmpItem_income_diff.PricePartner, 0))

                      -- ����
                    , CASE WHEN _tmpItem_income_diff.OperPrice <> 0
                           THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), _tmpItem_income_diff.MovementItemId, COALESCE (_tmpItem_income_diff.OperPrice, 0))
                      END AS x4

                    , _tmpItem_income_diff.MovementItemId

               FROM _tmpItem_income_diff
              ) AS _tmpMI;


         -- 2.��������� ��������
         PERFORM lpInsert_MovementItemProtocol (_tmpMI.MovementItemId, vbUserId, FALSE)
         -- ���������
         FROM (SELECT -- ����
                      CASE WHEN _tmpItem_income_diff.OperPrice <> 0
                           THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), MovementItem.Id, _tmpItem_income_diff.OperPrice)
                      END AS x1

                    , MovementItem.Id AS MovementItemId

               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN (SELECT DISTINCT
                                      _tmpItem_income_diff.GoodsId
                                    , _tmpItem_income_diff.GoodsKindId
                                    , _tmpItem_income_diff.OperPrice
                               FROM _tmpItem_income_diff
                              ) AS _tmpItem_income_diff
                                ON _tmpItem_income_diff.GoodsId     = MovementItem.ObjectId
                               AND _tmpItem_income_diff.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())

               WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
              ) AS _tmpMI;



     -- ��������� �������� <���� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), _tmpItem_income_diff.MovementId, vbOperDatePartner)
     FROM (SELECT DISTINCT _tmpItem_income_diff.MovementId FROM _tmpItem_income_diff) AS _tmpItem_income_diff
    ;

     -- ��������� �������� <�������� ���������� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DocPartner(), inMovementId, TRUE);

     -- ����������� ���������
     PERFORM lpUnComplete_Movement (inMovementId     := _tmpItem_income_diff.MovementId
                                  , inUserId         := vbUserId
                                   )
     FROM (SELECT DISTINCT _tmpItem_income_diff.MovementId FROM _tmpItem_income_diff) AS _tmpItem_income_diff
    ;

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Income_CreateTemp();
     -- �������� ���������
     PERFORM lpComplete_Movement_Income (inMovementId     := _tmpItem_income_diff.MovementId
                                       , inUserId         := vbUserId
                                       , inIsLastComplete := TRUE
                                        )
     FROM (SELECT DISTINCT _tmpItem_income_diff.MovementId FROM _tmpItem_income_diff) AS _tmpItem_income_diff
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.11.24                                        *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_WeighingPartner_diff (inMovementId:= 30105796, inSession:= zfCalc_UserAdmin())

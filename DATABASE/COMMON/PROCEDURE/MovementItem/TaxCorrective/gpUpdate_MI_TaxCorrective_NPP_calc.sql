-- Function: gpUpdate_MI_TaxCorrective_NPP_calc (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP_calc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_NPP_calc(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementItemId   Integer
             , GoodsId          Integer
             , GoodsKindId      Integer
             , NPPTax_calc      Integer
             , NPP_calc         Integer
             , AmountTax_calc   TFloat
             , SummTaxDiff_calc TFloat
             , Amount           TFloat
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbMovementId_tax Integer;
   DECLARE vbOperDate       TDateTime;
   DECLARE vbMovementId_Corrective Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());


     -- !!!�������� - ����� �� ������!!!
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                  ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                 AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                                 AND MIFloat_NPP_calc.ValueData < 0
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Amount     <> 0
               )
     THEN
         RAISE EXCEPTION '������.� ������������� ��� ������������ ������ <� �/� � ������� 1/2������ - ��� ������� 7 � "������" - ����������� � ������������� �� �������: � �/� + 1>';
     END IF;
     -- !!!�������� - ����� �� ������!!!
     IF NOT EXISTS (SELECT 1
                    FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                    WHERE MovementLinkObject_DocumentTaxKind.MovementId = inMovementId
                      AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                      AND MovementLinkObject_DocumentTaxKind.ObjectId   IN (zc_Enum_DocumentTaxKind_Corrective()
                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                                                           )
                   )
     THEN
         RAISE EXCEPTION '������.��� ��������� <%> ��������� ������� �� �������������.'
                       , lfGet_Object_ValueData_sh ((SELECT MovementLinkObject_DocumentTaxKind.ObjectId
                                                     FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                     WHERE MovementLinkObject_DocumentTaxKind.MovementId = inMovementId
                                                       AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                                   ));
     END IF;


     -- ������������ <��������� ��������> � ��� ���������
     SELECT Movement.OperDate
          , MovementLinkMovement_Child.MovementChildId AS MovementId_tax
            INTO vbOperDate, vbMovementId_tax
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                         ON MovementLinkMovement_Child.MovementId = Movement.Id
                                        AND MovementLinkMovement_Child.DescId     = zc_MovementLinkMovement_Child()
     WHERE Movement.Id = inMovementId
     ;



     -- ������� - ������
     CREATE TEMP TABLE _tmpRes (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, NPPTax_calc Integer, NPP_calc Integer, AmountTax_calc TFloat, SummTaxDiff_calc TFloat, Amount TFloat, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;


     -- !!!�������� - ���� ��� ��� ������ - ����� ������ ��������� �������!!!
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.ValueData = TRUE AND MB.DescId = zc_MovementBoolean_NPP_calc())
        -- � ���� ������� � ����������� = "���" ��� "��������������"
        AND EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                     ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND MovementItem.Amount     = MIFloat_AmountTax_calc.ValueData
                   )
        -- � ���� ������� � ����������� <> "���" ��� "��������������"
        AND EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                     ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND MovementItem.Amount     <> MIFloat_AmountTax_calc.ValueData
                      AND MIFloat_AmountTax_calc.ValueData <> 0
                   )
        -- � ���� ������� � NPP_calc
        AND EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                     ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                    AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND MIFloat_NPP_calc.ValueData > 0
                   )
     THEN
         -- ��������� - !!!��� ������� ��/�!!!
         INSERT INTO _tmpRes (MovementItemId, GoodsId, GoodsKindId, NPPTax_calc, NPP_calc, AmountTax_calc, SummTaxDiff_calc, Amount, OperPrice, CountForPrice)
           SELECT MovementItem.Id                                     AS MovementItemId
                , MovementItem.ObjectId                               AS GoodsId
                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                , COALESCE (MIFloat_NPPTax_calc.ValueData, 0)         AS NPPTax_calc
                , COALESCE (MIFloat_NPP_calc.ValueData, 0)            AS NPP_calc
                , COALESCE (MIFloat_AmountTax_calc.ValueData, 0)      AS AmountTax_calc
                , COALESCE (zc_MIFloat_SummTaxDiff_calc.ValueData, 0) AS SummTaxDiff_calc
                , MovementItem.Amount                                 AS Amount
                , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                , COALESCE (MIFloat_CountForPrice.ValueData, 1)       AS CountForPrice
           FROM MovementItem
                LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                            ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                           AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                            ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                           AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                            ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                LEFT JOIN MovementItemFloat AS zc_MIFloat_SummTaxDiff_calc
                                            ON zc_MIFloat_SummTaxDiff_calc.MovementItemId = MovementItem.Id
                                           AND zc_MIFloat_SummTaxDiff_calc.DescId         = zc_MIFloat_SummTaxDiff_calc()

                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                           -- AND MIFloat_Price.ValueData <> 0
                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId     = zc_MI_Master()
             AND MovementItem.isErased   = FALSE
             AND MovementItem.Amount     <> 0
          ;

     ELSE
         -- ��������� - !!!� �������� ��/�!!!
         WITH -- ��� �������������
              tmpMovement AS
                 (SELECT MovementLinkMovement_Child.MovementId
                  FROM MovementLinkMovement AS MovementLinkMovement_Child
                       INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Child.MovementId
                                          AND Movement.StatusId = zc_Enum_Status_Complete()
                                          AND Movement.OperDate <= vbOperDate
                       INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                     ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                                    AND MovementLinkObject_DocumentTaxKind.ObjectId   IN (zc_Enum_DocumentTaxKind_Corrective()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                                                                                         )
                  WHERE MovementLinkMovement_Child.MovementChildId = vbMovementId_tax
                    AND MovementLinkMovement_Child.DescId          = zc_MovementLinkMovement_Child()
                    AND MovementLinkMovement_Child.MovementId      <> inMovementId
                 )
              -- ��� ������������� (����� �������)
            , tmpMI_All AS
                 (SELECT MovementItem.Id                             AS Id
                       , MovementItem.MovementId                     AS MovementId
                       , MovementItem.ObjectId                       AS GoodsId
                       , MovementItem.Amount                         AS Amount
                  FROM tmpMovement
                       INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = FALSE
                                              AND MovementItem.Amount     <> 0
                 )
              -- ��-�� - �����������
            , tmpMIFloat AS
                 (SELECT MovementItemFloat.*
                  FROM MovementItemFloat
                  WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                 )
              -- ��-�� - �����������
            , tmpGoodsKind AS
                 (SELECT MovementItemLinkObject.*
                  FROM MovementItemLinkObject
                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                    AND MovementItemLinkObject.DescId        = zc_MILinkObject_GoodsKind()
                 )
              -- ��� ������������� (����� �������) + ��-��
            , tmpMI_Corr_all AS
                 (SELECT tmpMI_All.Id                                   AS Id
                       , tmpMI_All.MovementId                           AS MovementId
                       , tmpMI_All.GoodsId                              AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                       , tmpMI_All.Amount                               AS Amount
                       , COALESCE (MIFloat_Price.ValueData, 0)          AS Price
                       , COALESCE (MIFloat_AmountTax_calc.ValueData, 0) AS AmountTax_calc
                       , COALESCE (MIFloat_NPP_calc.ValueData, 0)       AS NPP_calc
                         --  ����� - ��� �����
                       , CAST (tmpMI_All.Amount * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) + COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0) AS AmountSumm
                         --  � �/� - ��� � ������� !!!���������!!!
                       , ROW_NUMBER() OVER (PARTITION BY tmpMI_All.GoodsId, MILinkObject_GoodsKind.ObjectId, MIFloat_Price.ValueData ORDER BY COALESCE (MIFloat_NPP_calc.ValueData, 1) DESC, tmpMI_All.Id DESC) AS Ord1
                         --  � �/� - ��� � ������� !!!���������!!!
                       , ROW_NUMBER() OVER (PARTITION BY tmpMI_All.GoodsId, MILinkObject_GoodsKind.ObjectId, MIFloat_Price.ValueData ORDER BY COALESCE (MIFloat_NPP_calc.ValueData, 1) DESC, tmpMI_All.Id DESC) AS Ord2
                  FROM tmpMI_All
                       LEFT JOIN tmpMIFloat AS MIFloat_NPP_calc
                                            ON MIFloat_NPP_calc.MovementItemId = tmpMI_All.Id
                                           AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                           AND MIFloat_NPP_calc.ValueData      > 0
                       LEFT JOIN tmpMIFloat AS MIFloat_AmountTax_calc
                                            ON MIFloat_AmountTax_calc.MovementItemId = tmpMI_All.Id
                                           AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                       LEFT JOIN tmpMIFloat AS MIFloat_SummTaxDiff_calc
                                            ON MIFloat_SummTaxDiff_calc.MovementItemId = tmpMI_All.Id
                                           AND MIFloat_SummTaxDiff_calc.DescId         = zc_MIFloat_SummTaxDiff_calc()
                       LEFT JOIN tmpMIFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = tmpMI_All.Id
                                           AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                           -- AND MIFloat_Price.ValueData <> 0
                       LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = tmpMI_All.Id
                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                 )
              -- SUMMA
            , tmpMI_Corr_sum_1 AS
                 (SELECT tmpMI_Corr_all.GoodsId
                       , tmpMI_Corr_all.GoodsKindId
                       , tmpMI_Corr_all.Price
                       , SUM (CASE WHEN tmpMI_Corr_all.NPP_calc = 0 THEN tmpMI_Corr_all.Amount ELSE 0 END) AS Amount
                       , SUM (tmpMI_Corr_all.Amount)     AS Amount_all
                       , SUM (tmpMI_Corr_all.AmountSumm) AS AmountSumm
                  FROM tmpMI_Corr_all
                  GROUP BY tmpMI_Corr_all.GoodsId
                         , tmpMI_Corr_all.GoodsKindId
                         , tmpMI_Corr_all.Price
                 )
            , tmpMI_Corr_sum_2 AS
                 (SELECT tmpMI_Corr_all.GoodsId
                       , tmpMI_Corr_all.Price
                       , SUM (CASE WHEN tmpMI_Corr_all.NPP_calc = 0 THEN tmpMI_Corr_all.Amount ELSE 0 END) AS Amount
                       , SUM (tmpMI_Corr_all.Amount)     AS Amount_all
                       , SUM (tmpMI_Corr_all.AmountSumm) AS AmountSumm
                  FROM tmpMI_Corr_all
                  GROUP BY tmpMI_Corr_all.GoodsId
                         , tmpMI_Corr_all.Price
                 )
              -- ������� ���� - �������������
            , tmpMI_Corr_curr_all AS
                 (SELECT MovementItem.Id                                AS Id
                       , MovementItem.MovementId                        AS MovementId
                       , MovementItem.ObjectId                          AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                       , MovementItem.Amount                            AS Amount
                       , COALESCE (MIFloat_Price.ValueData, 0)          AS Price
                       , COALESCE (MIFloat_CountForPrice.ValueData, 1)  AS CountForPrice
                       , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, TRUE) = TRUE THEN 0 ELSE COALESCE (MIFloat_NPP.ValueData, 0) END AS NPP
                  FROM MovementItem
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                                  -- AND MIFloat_Price.ValueData <> 0
                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                       LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                                   ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                                  AND MIFloat_NPP.DescId         = zc_MIFloat_NPP()
                       LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                     ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                    AND MIBoolean_isAuto.DescId         = zc_MIBoolean_isAuto()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                    AND MovementItem.Amount     <> 0
                 )

             -- �������� ����� ��������� � � �/�
           , tmpMI_tax AS (SELECT * FROM lpSelect_TaxFromTaxCorrective (vbMovementId_tax))
              -- ������� ���� - ������������� + � �/� �� ���������
            , tmpMI_Corr_curr AS
                 (SELECT tmpMI_Corr_curr_all.Id
                       , tmpMI_Corr_curr_all.MovementId
                       , tmpMI_Corr_curr_all.GoodsId
                       , tmpMI_Corr_curr_all.GoodsKindId
                       , tmpMI_Corr_curr_all.Amount
                       , tmpMI_Corr_curr_all.Price
                       , tmpMI_Corr_curr_all.CountForPrice
                         -- ���-�� �� �����. �� ������� "����������" ����. (�.�. ��� "�����")
                       , COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find) - COALESCE (tmpMI_Corr_sum_1.Amount, tmpMI_Corr_sum_2.Amount, 0) AS AmountTax_calc
                         -- ����� DIFF - �� �����. �� ������� ...
                       , CAST (COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find) * COALESCE (tmpMI_tax1.Price, tmpMI_tax2.Price) AS NUMERIC (16, 2))
                               -- ����� "����������" ����. (���)
                             - COALESCE (tmpMI_Corr_sum_1.AmountSumm, tmpMI_Corr_sum_2.AmountSumm, 0)
                         AS SummTaxDiff_calc
                         -- � �/� �� �����. ��� �������
                       , CASE WHEN tmpMI_Corr_curr_all.NPP = 0 THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum) ELSE tmpMI_Corr_curr_all.NPP END :: Integer AS NPP
                         -- � �/� ���������� ��� ������� � 1... � ��... - ��� � ��������� ������� �� + 1
                       , ROW_NUMBER() OVER (ORDER BY CASE WHEN COALESCE (tmpMI_Corr_sum_1.Amount_all, tmpMI_Corr_sum_1.Amount_all, 0) + tmpMI_Corr_curr_all.Amount
                                                             = COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find, 0)
                                                               THEN 12345678
                                                          WHEN tmpMI_Corr_curr_all.NPP = 0 THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum, 0)
                                                          ELSE tmpMI_Corr_curr_all.NPP END ASC
                                           ) AS Ord
                  FROM tmpMI_Corr_curr_all
                       -- ������ ����� � ��
                       LEFT JOIN tmpMI_tax AS tmpMI_tax1 ON tmpMI_tax1.Kind        = 1
                                                        AND tmpMI_tax1.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                        AND tmpMI_tax1.GoodsKindId = tmpMI_Corr_curr_all.GoodsKindId
                                                        AND tmpMI_tax1.Price       = tmpMI_Corr_curr_all.Price

                       LEFT JOIN tmpMI_tax AS tmpMI_tax2 ON tmpMI_tax2.Kind        = 2
                                                        AND tmpMI_tax2.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                        AND tmpMI_tax2.Price       = tmpMI_Corr_curr_all.Price
                                                        AND tmpMI_tax1.GoodsId     IS NULL
                       -- ����� � ����
                       LEFT JOIN tmpMI_Corr_sum_1 ON tmpMI_Corr_sum_1.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                 AND tmpMI_Corr_sum_1.GoodsKindId = tmpMI_Corr_curr_all.GoodsKindId
                                                 AND tmpMI_Corr_sum_1.Price       = tmpMI_Corr_curr_all.Price
                       LEFT JOIN tmpMI_Corr_sum_2 ON tmpMI_Corr_sum_2.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                 AND tmpMI_Corr_sum_2.Price       = tmpMI_Corr_curr_all.Price
                                                 -- !!!�����������!!! - ���� � � ��������� ��� GoodsKindId
                                                 AND tmpMI_tax1.GoodsId           IS NULL
                 )
              -- ���������
            , tmpMI_Data AS
                 (SELECT tmpMI_Corr_curr.Id AS MovementItemId
                       , tmpMI_Corr_curr.GoodsId
                       , tmpMI_Corr_curr.GoodsKindId
                         -- � �/� � ������� 1/1������ - ��� ������� 7 � "�������"
                       , COALESCE (tmpMI_Corr_all1.NPP_calc  -- � �/� � ��������� ����
                                 , tmpMI_Corr_all2.NPP_calc  -- � �/� � ��������� ���� - ��� GoodsKindId
                                 , tmpMI_Corr_curr.NPP       -- � �/� � ���������
                                  ) :: Integer AS NPPTax_calc
                         -- ���-�� ��� �� � ������� 7/1������
                       , COALESCE (tmpMI_Corr_all1.AmountTax_calc - tmpMI_Corr_all1.Amount  -- ���-�� � ��������� ���� ����� ����� ��� ����.
                                 , tmpMI_Corr_all2.AmountTax_calc - tmpMI_Corr_all2.Amount  -- ���-�� � ��������� ���� ����� ����� ��� ����. - ��� GoodsKindId
                                 , tmpMI_Corr_curr.AmountTax_calc                           -- ���-�� � ���������
                                  ) :: TFloat AS AmountTax_calc
                         -- ����� DIFF ��� �� � ������� 13/1������ - �� �����. �� ������� ...
                       , tmpMI_Corr_curr.SummTaxDiff_calc
                       - CAST (COALESCE (tmpMI_Corr_all1.AmountTax_calc - tmpMI_Corr_all1.Amount  -- ���-�� � ��������� ���� ����� ����� ��� ����.
                                       , tmpMI_Corr_all2.AmountTax_calc - tmpMI_Corr_all2.Amount  -- ���-�� � ��������� ���� ����� ����� ��� ����. - ��� GoodsKindId
                                       , tmpMI_Corr_curr.AmountTax_calc                           -- ���-�� � ���������
                                        )
                             * tmpMI_Corr_curr.Price AS NUMERIC (16, 2))
                         AS SummTaxDiff_calc

                         -- � �/� � ������� ������������� - ��� � ��������� ������� �� + 1
                       , tmpMI_Corr_curr.Ord
                         -- ���-�� � ������� �������������
                       , tmpMI_Corr_curr.Amount
                         -- ���� � ������� �������������
                       , tmpMI_Corr_curr.Price
                       , tmpMI_Corr_curr.CountForPrice

                  FROM tmpMI_Corr_curr
                       LEFT JOIN tmpMI_Corr_all AS tmpMI_Corr_all1 ON tmpMI_Corr_all1.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                                  AND tmpMI_Corr_all1.GoodsKindId = tmpMI_Corr_curr.GoodsKindId
                                                                  AND tmpMI_Corr_all1.Price       = tmpMI_Corr_curr.Price
                                                                  AND tmpMI_Corr_all1.Ord1        = 1 -- �.�. �� ���� ��-���
                                                                  AND tmpMI_Corr_all1.NPP_calc    > 0
                       LEFT JOIN tmpMI_Corr_all AS tmpMI_Corr_all2 ON tmpMI_Corr_all2.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                                  AND tmpMI_Corr_all2.Price       = tmpMI_Corr_curr.Price
                                                                  AND tmpMI_Corr_all2.Ord2        = 2 -- �.�. �� ��-��� ��� GoodsKindId
                                                                  AND tmpMI_Corr_all2.NPP_calc    > 0
                 )
         -- ���������
         INSERT INTO _tmpRes (MovementItemId, GoodsId, GoodsKindId, NPPTax_calc, NPP_calc, AmountTax_calc, SummTaxDiff_calc, Amount, OperPrice, CountForPrice)
           SELECT tmpMI_Data.MovementItemId
                , tmpMI_Data.GoodsId
                , tmpMI_Data.GoodsKindId
                  -- � �/� � ������� 1/1������ - ��� ������� 7 � "�������"
                , tmpMI_Data.NPPTax_calc
                  -- � �/� � ������� 1/2������ - ��� ������� 7 � "������" - ����������� � ������������� �� �������: � �/� + 1
                , (COALESCE ((SELECT MAX (tmp.NPP)
                              FROM (SELECT MAX (tmpMI_Data.NPPTax_calc)  AS NPP FROM tmpMI_Data
                                   UNION ALL
                                    SELECT MAX (tmpMI_tax.LineNum)       AS NPP FROM tmpMI_tax
                                   UNION ALL
                                    SELECT MAX (tmpMI_Corr_all.NPP_calc) AS NPP FROM tmpMI_Corr_all
                                   ) AS tmp
                             ), 0)
                 + tmpMI_Data.Ord -- � �/� - ��� � ��������� ������� �� + 1
                  ) :: Integer AS NPP_calc
                  -- ���-�� ��� �� � ������� 7/1������
                , tmpMI_Data.AmountTax_calc
                  -- ����� DIFF ��� �� � ������� 13/1������ - !!!������!!!
                  -- , CASE WHEN tmpMI_Data.AmountTax_calc = tmpMI_Data.Amount THEN tmpMI_Data.SummTaxDiff_calc ELSE 0 END AS SummTaxDiff_calc
                , tmpMI_Data.SummTaxDiff_calc
                  -- ���-�� � ������� �������������
                , tmpMI_Data.Amount
                  -- ���� � ������� �������������
                , tmpMI_Data.Price AS OperPrice
                , tmpMI_Data.CountForPrice

           FROM tmpMI_Data;

     END IF; -- ��������� - !!!� �������� ��/�!!!


     -- ��������� ��� ��� ��������� ��� � �/�
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(),      _tmpRes.MovementItemId, _tmpRes.NPPTax_calc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(),   _tmpRes.MovementItemId, _tmpRes.AmountTax_calc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), _tmpRes.MovementItemId, _tmpRes.SummTaxDiff_calc)
             -- !!!����� - ��������� ������ ���� ���� ��� ��� ����������!!!
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc()
                                             , _tmpRes.MovementItemId
                                             , CASE -- WHEN inSession = '5' THEN 0
                                                    WHEN _tmpRes.AmountTax_calc > _tmpRes.Amount THEN _tmpRes.NPP_calc
                                                    ELSE 0
                                               END
                                              )
     FROM _tmpRes;


     -- ����� - ��������� ����� �������������
     IF   EXISTS (SELECT 1 FROM _tmpRes WHERE _tmpRes.AmountTax_calc =  _tmpRes.Amount AND _tmpRes.Amount <> 0)
      AND EXISTS (SELECT 1 FROM _tmpRes WHERE _tmpRes.AmountTax_calc <> _tmpRes.Amount AND _tmpRes.Amount <> 0)
     THEN
         -- ������� ����� <�������������>
         vbMovementId_Corrective:= lpInsertUpdate_Movement_TaxCorrective (ioId               :=0
                                                       , inInvNumber        := NEXTVAL ('movement_taxcorrective_seq') :: TVarChar
                                                       , inInvNumberPartner := lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective(), vbOperDate, '') :: TVarChar
                                                       , inInvNumberBranch  := ''
                                                       , inOperDate         := vbOperDate
                                                       , inChecked          := FALSE
                                                       , inDocument         := FALSE
                                                       , inPriceWithVAT     := (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT())
                                                       , inVATPercent       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_VATPercent())
                                                       , inFromId           := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                       , inToId             := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                       , inPartnerId        := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner())
                                                       , inContractId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                       , inDocumentTaxKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_DocumentTaxKind())
                                                       , inUserId           := vbUserId
                                                      );
         -- ��������� ����� � <������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), vbMovementId_Corrective, (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Branch()));

         -- ������������ ����� <�������������> � <������� �� ����������> ��� <������� ����� (������)>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), vbMovementId_Corrective
                                                    , (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Master())
                                                     );
         -- ������������ ����� <�������������> � ���������
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), vbMovementId_Corrective, vbMovementId_tax);

         -- ������� �������� ����� ������ � <�������������>
         PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                          , inMovementId         := vbMovementId_Corrective
                                                          , inGoodsId            := _tmpRes.GoodsId
                                                          , inAmount             := _tmpRes.Amount
                                                          , inPrice              := _tmpRes.OperPrice
                                                          , ioCountForPrice      := _tmpRes.CountForPrice
                                                          , inGoodsKindId        := _tmpRes.GoodsKindId
                                                          , inUserId             := vbUserId
                                                           )
         FROM _tmpRes
         WHERE _tmpRes.AmountTax_calc = _tmpRes.Amount
           AND _tmpRes.Amount <> 0
          ;

         -- ��������� !!!��� vbMovementId_Corrective!!! - ��� ��� ��������� ��� � �/�
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(),      tmpMI.MovementItemId, _tmpRes.NPPTax_calc)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(),   tmpMI.MovementItemId, _tmpRes.AmountTax_calc)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), tmpMI.MovementItemId, _tmpRes.SummTaxDiff_calc)
         FROM _tmpRes
              LEFT JOIN (SELECT MovementItem.Id                                AS MovementItemId
                              , MovementItem.ObjectId                          AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                              , MovementItem.Amount                            AS Amount
                              , COALESCE (MIFloat_Price.ValueData, 0)          AS OperPrice
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                         WHERE MovementItem.MovementId = vbMovementId_Corrective
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased   = FALSE
                           AND MovementItem.Amount     <> 0
                        ) AS tmpMI
                          ON tmpMI.GoodsId     = _tmpRes.GoodsId
                         AND tmpMI.GoodsKindId = _tmpRes.GoodsKindId
                         AND tmpMI.OperPrice   = _tmpRes.OperPrice
                         AND tmpMI.Amount      = _tmpRes.Amount
         WHERE _tmpRes.AmountTax_calc = _tmpRes.Amount
           AND _tmpRes.Amount <> 0
          ;

         -- ����������� �������� ����� �� ���������
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId_Corrective);

         -- ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
         FROM MovementItem
         WHERE MovementItem.MovementId = vbMovementId_Corrective
           AND MovementItem.DescId     = zc_MI_Master()
           ;

         -- ��������� ��������
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), vbMovementId_Corrective, TRUE)
               , lpInsertUpdate_MovementDate    (zc_MovementDate_NPP_calc(),    vbMovementId_Corrective, CURRENT_TIMESTAMP)
                ;

         -- ������� - vbMovementId_Corrective
         PERFORM lpComplete_Movement_TaxCorrective (vbMovementId_Corrective, vbUserId);


         -- ������� !!!��� inMovementId!!! - �������� ��� �������� ��� - �����������
         UPDATE MovementItem SET isErased = TRUE
         FROM _tmpRes
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.Id         = _tmpRes.MovementItemId
           AND _tmpRes.AmountTax_calc  = _tmpRes.Amount
           AND _tmpRes.Amount          <> 0
          ;

     END IF;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (_tmpRes.MovementItemId, vbUserId, FALSE)
     FROM _tmpRes;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), inMovementId, TRUE)
           , lpInsertUpdate_MovementDate    (zc_MovementDate_NPP_calc(),    inMovementId, CURRENT_TIMESTAMP)
            ;


     IF inSession <> '5' OR 1=1
     THEN
         -- ���������
         RETURN;
     ELSE
         -- ���������
         RETURN QUERY
           SELECT _tmpRes.MovementItemId, _tmpRes.GoodsId, _tmpRes.GoodsKindId, _tmpRes.NPPTax_calc
                , CASE WHEN _tmpRes.AmountTax_calc > _tmpRes.Amount THEN _tmpRes.NPP_calc ELSE 0 END AS NPP_calc
                , _tmpRes.AmountTax_calc, _tmpRes.SummTaxDiff_calc, _tmpRes.Amount
           FROM _tmpRes;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.03.18                                        *
*/
/*
 SELECT DISTINCT Movement.*
 FROM Movement
      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                             AND MovementItem.Amount     <> 0
      LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                  ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                 AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
      LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                  ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                 AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
      LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                  ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                 AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
 WHERE Movement.OperDate >= '01.03.2018'
   AND Movement.DescId   = zc_Movement_TaxCorrective()
   AND Movement.StatusId = zc_Enum_Status_Complete()
   AND (MIFloat_NPPTax_calc.ValueData    <> 0
     OR MIFloat_NPP_calc.ValueData       <> 0
     OR MIFloat_AmountTax_calc.ValueData <> 0
       )
*/
-- ����
-- SELECT * FROM gpUpdate_MI_TaxCorrective_NPP_calc (inMovementId:= 8842841, inSession:= zfCalc_UserAdmin())

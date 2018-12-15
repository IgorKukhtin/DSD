-- Function: lpComplete_Movement_TaxCorrective (Integer, Integer);

DROP FUNCTION IF EXISTS lpComplete_Movement_TaxCorrective (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TaxCorrective(
    IN inMovementId        Integer   , -- ���� ���������
   OUT outMessageText      Text      ,
    IN inUserId            Integer     -- ������������
)
RETURNS Text
AS
$BODY$
  DECLARE vbDocumentTaxKindId Integer;
  DECLARE vbPrice TFloat;
BEGIN

     -- ������������ <��� ������������ ���������� ���������>
     vbDocumentTaxKindId:= (SELECT ObjectId  FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_DocumentTaxKind());

     -- �������� ������
     IF '01.01.2017' < (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
     THEN
         outMessageText:= (SELECT tmp.MessageText FROM lpSelect_TaxCorrectiveFromTax (inMovementId) AS tmp);
         -- !!!����� ���� ������!!!
         IF outMessageText <> '' THEN RETURN; END IF;
     END IF;

     -- �������� ���� �� ������� DocumentTaxKind
     vbPrice := (SELECT ObjectFloat_Price.ValueData
                 FROM ObjectFloat AS ObjectFloat_Price
                 WHERE ObjectFloat_Price.ObjectId = vbDocumentTaxKindId
                   AND ObjectFloat_Price.DescId = zc_objectFloat_DocumentTaxKind_Price()
                 );
     IF COALESCE (vbPrice, 0) <> 0
     THEN
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND COALESCE (MIFloat_Price.ValueData, 0) <> vbPrice
                    ) 
         THEN 
             RAISE EXCEPTION '������.���� �� ������������� ���������������� ��� ���� �����. ���������';
         END IF;
     END IF; 

     -- !!!��������� - ����� ����� � 30.03.18!!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), inMovementId
                                           , EXISTS (SELECT 1
                                                     FROM MovementItem
                                                          LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                                                                      ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                                                                     AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
                                                          LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                                                      ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                                                     AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                                          LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                                                      ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                                                     AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                                                     WHERE MovementItem.MovementId = inMovementId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                                       AND MovementItem.Amount     <> 0
                                                       AND (MIFloat_NPPTax_calc.ValueData    <> 0
                                                         OR MIFloat_NPP_calc.ValueData       <> 0
                                                         OR MIFloat_AmountTax_calc.ValueData <> 0
                                                           )
                                                    )
                                            );


     IF vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Corrective()
     THEN
          -- � ���� ��������� "���������������" <��� ������������ ���������� ���������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), MovementLinkMovement.MovementChildId, vbDocumentTaxKindId)
          FROM MovementLinkMovement
          WHERE MovementLinkMovement.MovementId = inMovementId
            AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Master()
            AND MovementLinkMovement.MovementChildId > 0
            ;
     END IF;

     -- ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_TaxCorrective()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 06.05.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_TaxCorrective (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())

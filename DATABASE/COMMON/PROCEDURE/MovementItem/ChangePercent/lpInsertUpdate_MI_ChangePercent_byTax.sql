-- Function: lpInsertUpdate_MI_ChangePercent_byTax()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ChangePercent_byTax (integer, integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ChangePercent_byTax(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbToId       Integer;
   DECLARE vbContractId Integer;
   DECLARE vbPartnerId  Integer;
   DECLARE vbOperDate   TDateTime;
   DECLARE vbStartDate  TDateTime;
   DECLARE vbEndDate    TDateTime;
BEGIN

     --��������
     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;

     --������ �� ���������
     SELECT MovementLinkObject_To.ObjectId       AS ToId
          , MovementLinkObject_Contract.ObjectId AS ContractId
          , Movement.OperDate
          --, MovementLinkObject_Partner.ObjectId  AS PartnerId
    INTO vbToId, vbContractId, vbOperDate--, vbPartnerId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            */

     WHERE Movement.Id = inMovementId
     ;
     --��������
     IF COALESCE (vbToId,0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� ��.����.';
     END IF;
      IF COALESCE (vbContractId,0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������ �������.';
     END IF;

     vbStartDate := DATE_TRUNC ('MONTH', vbOperDate);
     vbEndDate   := DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     --����� ������� ������� ���. ������
      UPDATE MovementItem
      SET isErased = TRUE
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = FALSE;
     
     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_ChangePercent (ioId            := 0
                                                      , inMovementId    := inMovementId
                                                      , inGoodsId       := tmp.GoodsId
                                                      , inAmount        := tmp.Amount
                                                      , inPrice         := tmp.Price
                                                      , ioCountForPrice := tmp.CountForPrice
                                                      , inGoodsKindId   := tmp.GoodsKindId
                                                      , inUserId        := inUserId
                                                      ) 
     FROM (WITH
           tmpTax AS (SELECT Movement.Id 
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       AND MovementLinkObject_To.ObjectId = vbToId

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                       AND MovementLinkObject_Contract.ObjectId = vbContractId

                           /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                        ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                       AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()*/
                      WHERE Movement.DescId = zc_Movement_Tax()
                        AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                        --AND (MovementLinkObject_Partner.ObjectId = vbPartnerId OR vbPartnerId = 0) 
                      )
         , tmpMI AS (SELECT MovementItem.ObjectId           AS GoodsId
                          , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                          , MIFloat_Price.ValueData         AS Price
                          , MIFloat_CountForPrice.ValueData AS CountForPrice
                          , SUM (MovementItem.Amount)       AS Amount
                     FROM tmpTax
                          INNER JOIN MovementItem ON MovementItem.MovementId = tmpTax.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.isErased = FALSE

                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     GROUP BY MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                            , MIFloat_Price.ValueData
                            , MIFloat_CountForPrice.ValueData 
                     )
         SELECT *
         FROM tmpMI
          ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.03.23         *
*/

-- ����
--
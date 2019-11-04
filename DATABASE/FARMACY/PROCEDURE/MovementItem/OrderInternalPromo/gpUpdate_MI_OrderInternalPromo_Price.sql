-- Function: gpUpdate_MI_OrderInternalPromo_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_Price(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbRetailId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    -- ������ �� ����� ���������
    SELECT MovementLinkObject_Retail.ObjectId AS RetailId
   INTO vbRetailId 
    FROM Movement 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                      ON MovementLinkObject_Retail.MovementId = Movement.Id
                                     AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
    WHERE Movement.Id = inMovementId;
    
    --��������� ������ � �������
    PERFORM lpInsertUpdate_MovementItemFloat      (zc_MIFloat_Price(),          tmpAll.MI_Id, tmpAll.Price ::TFloat)
          , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), tmpAll.MI_Id, tmpAll.JuridicalId)
          , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(),  tmpAll.MI_Id, tmpAll.ContractId)

    FROM (WITH 
             -- ������ �� ����� �������
               SelectMinPrice_AllGoods AS (SELECT * FROM lpSelect_GoodsMinPrice_onDate (inOperdate := CURRENT_DATE, inUnitId := 0, inObjectId := vbRetailId, inUserId := vbUserId) AS SelectMinPrice_AllGoods)
             -- ������ ���������
             , tmpGoodsPromo AS (SELECT MovementItem.Id        AS MI_Id
                                      , MovementItem.ObjectId  AS GoodsId_retail
                                 FROM MovementItem
                                 WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.isErased = FALSE
                                 )

         SELECT tmp.MI_Id
              , SelectMinPrice_AllGoods.Price
              , SelectMinPrice_AllGoods.JuridicalId
              , SelectMinPrice_AllGoods.ContractId
         FROM tmpGoodsPromo AS tmp
              INNER JOIN SelectMinPrice_AllGoods ON SelectMinPrice_AllGoods.GoodsId = tmp.GoodsId_retail
         WHERE COALESCE (SelectMinPrice_AllGoods.Price,0) > 0
         ) AS tmpAll;


    -- �� ������� ��������� zc_Movement_OrderInternalPromoPartner 
    PERFORM lpInsertUpdate_Movement_OrderInternalPromoPartner (ioId         := 0
                                                             , inParentId   := inMovementId
                                                             , inJuridicalId:= tmp.JuridicalId
                                                             , inUserId     := vbUserId)
    FROM (WITH
          -- �������� ��� ����������� ��.����
          tmpMIPartner AS (SELECT MovementLinkObject_Juridical.ObjectId AS JuridicalId
                           FROM Movement 
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                           ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                          AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                           WHERE Movement.DescId = zc_Movement_OrderInternalPromoPartner()
                             AND Movement.ParentId = inMovementId
                           )

          SELECT DISTINCT MILinkObject_Juridical.ObjectId AS JuridicalId
          FROM MovementItem
               INNER JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                 ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
               LEFT JOIN tmpMIPartner ON tmpMIPartner.JuridicalId = MILinkObject_Juridical.ObjectId
          WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
             AND tmpMIPartner.JuridicalId IS NULL
          ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.10.19         *
*/
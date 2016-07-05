DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_GoodsId 
          (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_GoodsId(
    IN inMovementId          Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbStatusId INTEGER;
   DECLARE vbInvNumber INTEGER;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

     -- ������������ <�������� ����>
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     -- ������������
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;
     
     --
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������. ��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


   -- ������������
   SELECT ObjectId INTO vbJuridicalId
          FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From();
 
    -- ���������
    CREATE TEMP TABLE _tmpMI (Id Integer, GoodsId Integer) ON COMMIT DROP;
    -- ���� ����� ��� ���������.
    INSERT INTO _tmpMI (Id, GoodsId)
     SELECT MovementItem_Income_View.Id, Goods_Retail.GoodsId
     FROM MovementItem_Income_View 
          LEFT JOIN Object_LinkGoods_View AS Goods_Juridical ON Goods_Juridical.GoodsId = MovementItem_Income_View.PartnerGoodsId
                                                             AND Goods_Juridical.ObjectId = vbJuridicalId
          LEFT JOIN Object_LinkGoods_View AS Goods_Retail ON Goods_Retail.GoodsMainId = Goods_Juridical.GoodsMainId
                                                         AND Goods_Retail.ObjectId = vbObjectId
       WHERE MovementItem_Income_View.MovementId = inMovementId
         AND COALESCE (MovementItem_Income_View.GoodsId, 0) = 0
         AND Goods_Retail.GoodsId > 0
      ;

     -- �������� ����� ��� ���������
     UPDATE MovementItem SET ObjectId = _tmpMI.GoodsId
     FROM _tmpMI
     WHERE MovementItem.Id = _tmpMI.Id;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (_tmpMI.Id, vbUserId, FALSE)
     FROM _tmpMI;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.01.15                        *   
*/

-- select * from gpUpdate_MovementItem_Income_GoodsId(inMovementId := 12474 ,  inSession := '3');  
-- vbJuridicalId = 183312

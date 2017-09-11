-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Income (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Income (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
    IN inMovementId          Integer              , -- ���� ���������
    IN inIsCurrentData       Boolean              , -- ���� ������ - ������� �� /���
   --OUT outisDeferred         Boolean              , -- ��� ���������� ������ ������� ������� � ������
   OUT outOperDate_Branch    TDateTime            ,
    IN inSession             TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS TDateTime --RECORD -- VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbObjectId        Integer;
  DECLARE vbJuridicalId     Integer;
  DECLARE vbToId            Integer;
  DECLARE vbOperDate        TDateTime;
  DECLARE vbUnit            Integer;
  DECLARE vbOrderId         Integer;
  DECLARE vbGoodsName       TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
     vbUserId:= inSession;
     
     -- ����� <�������� ����>
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     -- !!!�������� ��� � ������ ��� �� ������� ��������� � �������� �� ����������!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION '������.�������� ��� ��������.';
     END IF;
     
     -- ���� ������
     outOperDate_Branch := (SELECT MD_Branch.ValueData
                         FROM MovementDate AS MD_Branch
                         WHERE MD_Branch.MovementId = inMovementId
                           AND MD_Branch.DescId = zc_MovementDate_Branch()
                         );
     -- ���� �������� �������� ���-� ������ ������ ������ ��������������
     IF (outOperDate_Branch <> CURRENT_DATE) AND (inIsCurrentData = TRUE)
     THEN
         --RAISE EXCEPTION '������. ��������� ���� ������ ��������� �� �������.';
         outOperDate_Branch:= CURRENT_DATE;
         -- ������ ���� ������ �� �������
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, outOperDate_Branch);
     ELSE 
         IF (outOperDate_Branch <> CURRENT_DATE) AND (inIsCurrentData = FALSE)
         THEN
            -- �������� ���� �� ���������� ������ ������
            vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompleteDate_Income());
         END IF;
     END IF;
     

     -- !!!�������� ���� ���� ��������� ������� ���� ���-��!!!
     vbGoodsName := (SELECT Object_Goods.ValueData 
                     FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                             ON MIFloat_AmountManual.MovementItemId = MovementItem.ID
                            AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.isErased = FALSE
                       AND COALESCE(MovementItem.Amount,0) <> COALESCE(MIFloat_AmountManual.ValueData,0)
                     LIMIT 1);
     IF COALESCE (vbGoodsName, '') <> ''
       AND vbUserId NOT IN (375661, 2301972) -- ����� ���� �����������
     THEN
         RAISE EXCEPTION '������. ��������� ���-�� ���� �� ������ <%> ��� ����� �������.', vbGoodsName;
     END IF;


     IF vbUserId NOT IN (375661, 2301972) -- ����� ���� �����������
     THEN
         -- ��������� ��� ����������� ��� �����
         PERFORM lpCheckComplete_Movement_Income (inMovementId);
     END IF;

    -- ���������, ��� �� �� ���� ��������� ����� ���� ���������
    SELECT
        Movement.OperDate,
        Movement_Unit.ObjectId AS Unit
    INTO
        vbOperDate,
        vbUnit
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()

    WHERE Movement.Id = inMovementId;
    
    /*IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnit
                  Inner Join MovementItem AS MI_Send
                                          ON MI_Inventory.ObjectId = MI_Send.ObjectId
                                         AND MI_Send.DescId = zc_MI_Master()
                                         AND MI_Send.IsErased = FALSE
                                         AND MI_Send.Amount > 0
                                         AND MI_Send.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION '������. �� ������ ��� ����� ������� ���� �������� ��������� ����� ���� �������� �������. ���������� ��������� ���������!';
    END IF;*/


    -- ���������� �� ����, ����
    --vbJuridicalId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From());
    SELECT MLO_From.ObjectId  AS JuridicalId
         , MLO_To.ObjectId    AS ToId
           INTO vbJuridicalId, vbToId
    FROM MovementLinkObject AS MLO_From 
         LEFT JOIN MovementLinkObject AS MLO_To
                                      ON MLO_To.MovementId = inMovementId
                                     AND MLO_To.DescId = zc_MovementLinkObject_To()
    WHERE MLO_From.MovementId = inMovementId 
      AND MLO_From.DescId = zc_MovementLinkObject_From();

    -- ��� ������������� ����� ����� �������� ����������� � ������� �������
    PERFORM gpInsertUpdate_Object_LinkGoods(0                                 -- ���� ������� <������� ��������>
                                          , DD.GoodsMainId
                                          , DD.PartnerGoodsId
                                          , inSession
                                            )
    FROM (WITH tmpMI AS (SELECT DISTINCT
                                MovementItem.ObjectId       AS GoodsId
                              , MILinkObject_Goods.ObjectId AS PartnerGoodsId
                         FROM MovementItem
                              INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                                               AND MILinkObject_Goods.ObjectId       > 0
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.IsErased   = FALSE
                        )
      , tmpGoodsMain AS (SELECT DISTINCT
                                tmpMI.GoodsId
                              , tmpMI.PartnerGoodsId
                              , ObjectLink_LinkGoods_GoodsMain.ChildObjectId  AS GoodsMainId
                         FROM tmpMI
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                    ON ObjectLink_LinkGoods_Goods.ChildObjectId = tmpMI.GoodsId
                                                   AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                    ON ObjectLink_LinkGoods_GoodsMain.ObjectId  = ObjectLink_LinkGoods_Goods.ObjectId
                                                   AND ObjectLink_LinkGoods_GoodsMain.DescId    = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                    ON ObjectLink_Goods_Object.ObjectId      = tmpMI.GoodsId
                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                        )
 , tmpGoodsJuridical AS (SELECT DISTINCT
                                tmpGoodsMain.GoodsId
                              , ObjectLink_LinkGoods_GoodsMain.ObjectId  AS Id
                         FROM tmpGoodsMain
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                    ON ObjectLink_LinkGoods_GoodsMain.ChildObjectId  = tmpGoodsMain.GoodsMainId
                                                   AND ObjectLink_LinkGoods_GoodsMain.DescId         = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                    ON ObjectLink_LinkGoods_Goods.ObjectId      = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                   AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                                   AND ObjectLink_LinkGoods_Goods.ChildObjectId = tmpGoodsMain.PartnerGoodsId
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                    ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbJuridicalId
                        )
         -- ��������
         SELECT DISTINCT tmpGoodsMain.GoodsMainId -- ������� �����
                       , tmpMI.PartnerGoodsId     -- ����� �� ������
         FROM tmpMI
              LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = tmpMI.GoodsId
              LEFT JOIN tmpGoodsJuridical ON tmpGoodsJuridical.GoodsId = tmpMI.GoodsId
           WHERE tmpGoodsJuridical.Id IS NULL
          ) AS DD;


      -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
     PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);


     -- ���������� ��������
     PERFORM lpComplete_Movement_Income(inMovementId, -- ���� ���������
                                        vbUserId);    -- ������������                          

     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


 -- ���� �������, ����� � ������� ��� ������� ������ ����������� ��������� ���� � ���������
/*
     -- ��� ���������� ������� - ����� ����� �� ����������
        SELECT MLM.MovementChildId 
             , COALESCE (MB_Deferred.ValueData, False) AS isDeferred
      INTO vbOrderId, outisDeferred
        FROM MovementLinkMovement AS MLM 
             LEFT JOIN MovementBoolean AS MB_Deferred
                    ON MB_Deferred.MovementId = MLM.MovementChildId
                   AND MB_Deferred.DescId = zc_MovementBoolean_Deferred()
        WHERE MLM.descid = zc_MovementLinkMovement_Order()
          AND MLM.MovementId = inMovementId; 
    
     -- � ��������� ������ ������ ������ �������� �� �� �������
     IF COALESCE (vbOrderId, 0) <> 0 AND outisDeferred = TRUE 
     THEN
         outisDeferred = FALSE;
         -- C�������� �������� <�������> ���
         PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), vbOrderId, outisDeferred);
         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (vbOrderId, vbUserId, FALSE);
     END IF;
     
     --����� ���������� ������� �� ����� - ��������� ������� � ���� ������ � ���� ����� �� ���� �������
     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), Movement.Id, FALSE)            -- ��������� �������� �������  ���
           , lpInsert_MovementProtocol (Movement.Id, vbUserId, FALSE)                                     -- ��������� ��������
     FROM Movement
          INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                     ON MovementBoolean_Deferred.MovementId = Movement.Id
                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                    AND MovementBoolean_Deferred.ValueData = TRUE

          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      AND MovementLinkObject_From.ObjectId = vbJuridicalId

          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                      AND MovementLinkObject_To.ObjectId = vbToId
     WHERE Movement.DescId   = zc_Movement_OrderExternal()
       AND Movement.OperDate < outOperDate_Branch
       AND Movement.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete());
     */

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.07.17         * 
 25.07.17         * �������� ���� ������
 01.02.17         * ��� ���������� ������� - ����� ����� �� ����������
 05.02.15                         * 

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsCurrentData:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')

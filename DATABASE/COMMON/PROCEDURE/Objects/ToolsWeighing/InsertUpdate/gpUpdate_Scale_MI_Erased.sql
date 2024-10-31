-- Function: gpUpdate_Scale_MI_Erased()

-- DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_Erased (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_Erased (Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_Erased(
    IN inMovementItemId        Integer   , -- ���� ������� <������� ���������>
    IN inIsModeSorting         Boolean   , -- 
    IN inIsErased              Boolean   , -- 
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS TABLE (TotalSumm        TFloat
             , TotalSummPartner TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbTotalSummPartner TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);


    IF inIsModeSorting = TRUE
    THEN
        -- ������������� ����� ��������
        UPDATE wms_MI_WeighingProduction SET isErased = inIsErased, UpdateDate = CURRENT_TIMESTAMP WHERE Id = inMovementItemId AND WmsCode <> '' AND GoodsTypeKindId > 0;
         -- ���������
         RETURN QUERY
           SELECT 0 :: TFloat AS TotalSumm, 0 :: TFloat AS TotalSummPartner;

    ELSE
        -- ������������� ����� ��������
        IF inIsErased = TRUE
        THEN PERFORM lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);
        ELSE PERFORM lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);
        END IF;
    
        -- ��������� �������� <����/�����>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMovementItemId, CURRENT_TIMESTAMP);
        
        
        --
        vbMovementId:= (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId);
        
        -- ��� ������� �� ����������
        IF zc_Movement_Income() = (SELECT MF.ValueData :: Integer FROM MovementFloat AS MF WHERE MF.MovementId = vbMovementId AND MF.DescId = zc_MovementFloat_MovementDesc())
        THEN
             vbTotalSummPartner:= (WITH tmpMI AS (SELECT SUM (COALESCE (MIF_AmountPartnerSecond.ValueData, 0))AS AmountPartner
                                                       , COALESCE (MIF_PricePartner.ValueData, 0)             AS PricePartner
                                                       , COALESCE (MIB_PriceWithVAT.ValueData, FALSE)         AS isPriceWithVAT
                                                       , MovementItem.ObjectId                                AS GoodsId
                                                       , COALESCE (MILO_GoodsKind.ObjectId, 0)                AS GoodsKindId
                                                  FROM MovementItem
                                                       LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                                        ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                                       AND MILO_GoodsKind.DescId         = zc_MovementLinkObject_To()
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

                                                  WHERE MovementItem.MovementId = vbMovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                                  GROUP BY COALESCE (MIF_PricePartner.ValueData, 0)
                                                         , COALESCE (MIB_PriceWithVAT.ValueData, FALSE)
                                                         , MovementItem.ObjectId
                                                         , COALESCE (MILO_GoodsKind.ObjectId, 0)
                                                 )
                                 , tmpMI_summ AS (SELECT CAST (tmpMI.AmountPartner * tmpMI.PricePartner AS NUMERIC (16, 2)) AS Summ_notVat
                                                       , 0 AS Summ_addVat
                                                  FROM tmpMI
                                                  WHERE NOT EXISTS (SELECT 1 FROM tmpMI WHERE tmpMI.isPriceWithVAT = TRUE)

                                                 UNION
                                                  SELECT 0 AS Summ_notVat
                                                       , CAST (CAST (tmpMI.AmountPartner * tmpMI.PricePartner AS NUMERIC (16, 2))
                                                             * CASE WHEN tmpMI.isPriceWithVAT = FALSE THEN 1.2 ELSE 1 END
                                                               AS NUMERIC (16, 2)
                                                              ) AS Summ_addVat
                                                  FROM tmpMI
                                                  WHERE EXISTS (SELECT 1 FROM tmpMI WHERE tmpMI.isPriceWithVAT = TRUE)
                                                 )
                                   --
                                   SELECT -- ���� ��� ��� ���, ����� �������
                                          CAST (SUM (tmpMI_summ.Summ_notVat) * 1.2 AS NUMERIC (16, 2))
                                          -- ���� ��� � ���
                                        + SUM (tmpMI_summ.Summ_addVat)
                                   FROM tmpMI_summ
                                  );
        END IF;

    
         -- ���������
         RETURN QUERY
           SELECT MovementFloat.ValueData AS TotalSumm
                , COALESCE (vbTotalSummPartner, 0) :: TFloat AS TotalSummPartner
           FROM MovementFloat
           WHERE MovementFloat.MovementId = (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
             AND MovementFloat.DescId = zc_MovementFloat_TotalSumm();
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 31.01.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MI_Erased (ioId:= 0, inIsErased:= TRUE, inSession:= '5')

-- Function: gpUpdateMobile_Movement_ReturnIn_Auto

DROP FUNCTION IF EXISTS gpUpdateMobile_Movement_ReturnIn_Auto (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_Movement_ReturnIn_Auto (
    IN inMovementGUID TVarChar , -- ���������� ������������� ���������
    IN inSession      TVarChar   -- ������ ������������
)
RETURNS TBlob
AS $BODY$
  DECLARE vbUserId Integer;

  DECLARE vbId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate  TDateTime;
  
  DECLARE vbMessageText Text:= '';
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
      
      -- ����������� �������������� ��������� �� ����������� ����������� ��������������
      SELECT MovementString_GUID.MovementId 
           , Movement.StatusId
           , Movement.OperDate
            INTO vbId 
               , vbStatusId
               , vbOperDate
      FROM MovementString AS MovementString_GUID
           JOIN Movement ON Movement.Id     = MovementString_GUID.MovementId
                        AND Movement.DescId = zc_Movement_ReturnIn() 
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      -- �������� �� ����������� ��������
      IF vbStatusId = zc_Enum_Status_Complete() 
      THEN
           RAISE EXCEPTION '������� ��� ��������, �������� ��� ������������.';
      END IF;

      IF COALESCE (vbId, 0) <> 0
      THEN
           IF vbStatusId <> zc_Enum_Status_UnComplete() 
           THEN 
                -- ������� ����������� ��������
                PERFORM lpUnComplete_Movement (inMovementId:= vbId, inUserId:= vbUserId);
           END IF;


           -- ���� ��� �� ���� ��������
           IF NOT EXISTS (SELECT 1 FROM MovementItem
                          WHERE MovementItem.MovementId = vbId
                            AND MovementItem.DescId     = zc_MI_Child()
                            AND MovementItem.isErased   = FALSE
                            AND MovementItem.Amount     <> 0
                         )
              -- OR 1=1
           THEN
               -- ������� �������������
               CREATE TEMP TABLE _tmpMI_noPromo (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, Price TFloat) ON COMMIT DROP;
               -- ��������� ���� �� ���������
               INSERT INTO _tmpMI_noPromo (MovementItemId, GoodsId, GoodsKindId, Amount, Price)
                  SELECT MovementItem.Id                       AS MovementItemId
                       , MovementItem.ObjectId                 AS GoodsId
                       , MILinkObject_GoodsKind.ObjectId       AS GoodsKindId
                       , MovementItem.Amount                   AS Amount
                       , COALESCE (MIFloat_Price.ValueData, 0) AS Price
                  FROM MovementItem
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                  WHERE MovementItem.MovementId = vbId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                   ;

               -- ������� ��������� ��������� ��������� ���� - ��� � Scale
               PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.MovementItemId, tmp.PricePromo)
               FROM (WITH tmpResult AS (SELECT tmpMI.MovementItemId
                                             , CASE WHEN (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = vbId AND MB.DescId = zc_MovementBoolean_PriceWithVAT()) = TRUE
                                                         THEN tmp.PriceWithVAT
                                                    WHEN 1=1
                                                         THEN tmp.PriceWithOutVAT
                                                    ELSE 0 -- ???����� ���� ����� ����� �� ������ ����� ���� ����� ��� ����� ������� ��� ��� �����???
                                               END AS PricePromo
                                             , tmp.isChangePercent
                                        FROM _tmpMI_noPromo AS tmpMI
                                             INNER JOIN lpGet_Movement_Promo_Data_all (inOperDate     := vbOperDate
                                                                                     , inPartnerId    := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbId AND MLO.DescId = zc_MovementLinkObject_From())
                                                                                     , inContractId   := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                                                     , inUnitId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbId AND MLO.DescId = zc_MovementLinkObject_To())
                                                                                     , inGoodsId      := tmpMI.GoodsId
                                                                                     , inGoodsKindId  := tmpMI.GoodsKindId
                                                                                     , inIsReturn     := TRUE
                                                                                      ) AS tmp ON tmp.MovementId > 0
                                       )
                    -- ���������
                    SELECT tmpResult.MovementItemId, tmpResult.PricePromo, tmpResult.isChangePercent
                    FROM tmpResult
                   ) AS tmp;

               -- ������ ��� - ��������� �������������� �������� ����� - zc_MI_Child
               vbMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '6 MONTH'
                                                              , inEndDateSale   := NULL
                                                              , inMovementId    := vbId
                                                              , inUserId        := -1 * vbUserId
                                                               );

               -- ���� �� �����������
               IF EXISTS (SELECT 1
                          FROM (WITH tmpResult AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                                   FROM MovementItem
                                                   WHERE MovementItem.MovementId = vbId
                                                    AND MovementItem.DescId     = zc_MI_Child()
                                                     AND MovementItem.isErased   = FALSE
                                                   GROUP BY MovementItem.ParentId
                                                  )
                               -- ���������
                               SELECT _tmpMI_noPromo.MovementItemId, _tmpMI_noPromo.Price
                               FROM _tmpMI_noPromo
                                    LEFT JOIN tmpResult ON tmpResult.ParentId = _tmpMI_noPromo.MovementItemId
                               WHERE _tmpMI_noPromo.Amount <> COALESCE (tmpResult.Amount, 0)
                              ) AS tmp
                         )
                  -- AND 1=0
               THEN
                   -- ����������� ���� ��� ����
                   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.MovementItemId, tmp.Price)
                   FROM (WITH tmpResult AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                            FROM MovementItem
                                            WHERE MovementItem.MovementId = vbId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                              AND MovementItem.isErased   = FALSE
                                            GROUP BY MovementItem.ParentId
                                           )
                        -- ���������
                        SELECT _tmpMI_noPromo.MovementItemId, _tmpMI_noPromo.Price
                        FROM _tmpMI_noPromo
                             LEFT JOIN tmpResult ON tmpResult.ParentId = _tmpMI_noPromo.MovementItemId
                        WHERE _tmpMI_noPromo.Amount <> COALESCE (tmpResult.Amount, 0)
                       ) AS tmp;
    
                   -- ��� ��� - ��������� ������������ �������� ����� - zc_MI_Child
                   vbMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := DATE_TRUNC ('MONTH', vbOperDate) - INTERVAL '6 MONTH'
                                                                  , inEndDateSale   := NULL
                                                                  , inMovementId    := vbId
                                                                  , inUserId        := -1 * vbUserId
                                                                   );
               END IF;
                                                               
               -- ������ ������
               IF vbMessageText <> '' THEN
                 RAISE EXCEPTION '%', vbMessageText;
               END IF;
               
           END IF;

/*if inSession = '5'
then
    RAISE EXCEPTION '<%>  %', (SELECT _tmpMI_noPromo.Price FROM _tmpMI_noPromo)
                            , (SELECT MIF_Price.ValueData
                               FROM MovementItem AS MI
                                    LEFT JOIN MovementItemFloat AS MIF_Price ON MIF_Price.MovementItemId = MI.Id AND MIF_Price.DescId = zc_MIFloat_Price()
                               WHERE MI.MovementId = vbId
                                 AND MI.DescId     = zc_MI_Master()
                              );
end if;*/

           -- �������
           PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);

      END IF;

      RETURN vbMessageText::TBlob;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 21.08.17                                                        *
*/

-- ����
-- SELECT lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), 127263612, 119)
-- SELECT lpInsertUpdate_MovementString (zc_MovementString_GUID(), 11832911 , 'test_mobile_01')
-- SELECT gpUpdateMobile_Movement_ReturnIn_Auto (inMovementGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}', inSession:= zfCalc_UserAdmin());
-- SELECT gpUpdateMobile_Movement_ReturnIn_Auto (inMovementGUID:= 'test_mobile_01', inSession:= zfCalc_UserAdmin());

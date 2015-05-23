-- Function: gpInsertUpdate_Movement_QualityDoc (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityDoc (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_QualityDoc(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inMovementId_Sale     Integer   , -- 
    IN inOperDateIn          TDateTime , -- ���� 
    IN inOperDateOut         TDateTime , -- ���� 
    IN inCarId               Integer   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_QualityDoc());


     -- �������� �� ��������� - !!!��������!!!
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Sale);

     -- ������� - �� 
     CREATE TEMP TABLE _tmpMovement_QualityDoc (MovementId Integer, MovementId_master Integer, MovementId_child Integer) ON COMMIT DROP;

       WITH -- �������� ��������� inMovementId_Sale
            tmpMI AS (SELECT MovementItem.*
                      FROM MovementItem
                           INNER JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                       AND MIFloat_Price.ValueData <> 0
                           INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                       AND MIFloat_AmountPartner.ValueData <> 0
                      WHERE MovementItem.MovementId =  inMovementId_Sale
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )
            -- �������� ������ Goods
          , tmpMIGoods AS (SELECT DISTINCT tmpMI.ObjectId AS GoodsId FROM tmpMI)
            -- �������� ������ Quality
          , tmpQuality AS (SELECT ObjectLink_GoodsQuality_Quality.ChildObjectId AS QualityId
                           FROM tmpMIGoods
                                INNER JOIN ObjectLink AS ObjectLink_GoodsQuality_Goods
                                                      ON ObjectLink_GoodsQuality_Goods.ChildObjectId = tmpMIGoods.GoodsId
                                                     AND ObjectLink_GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_GoodsQuality_Quality
                                                     ON ObjectLink_GoodsQuality_Quality.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                    AND ObjectLink_GoodsQuality_Quality.DescId = zc_ObjectLink_GoodsQuality_Quality()
                                INNER JOIN ObjectFloat AS ObjectFloat_Quality_NumberPrint
                                                       ON ObjectFloat_Quality_NumberPrint.ObjectId = ObjectLink_GoodsQuality_Quality.ChildObjectId
                                                      AND ObjectFloat_Quality_NumberPrint.DescId = zc_ObjectFloat_Quality_NumberPrint()
                                                      AND ObjectFloat_Quality_NumberPrint.ValueData = 1 -- !!!��� �����������!!!, ������ �� ���� 2: ������ ��� ���������, ������ ��� ���������
                           GROUP BY ObjectLink_GoodsQuality_Quality.ChildObjectId
                          )

            -- �������� ������ ���� zc_Movement_QualityParams ��� ������� Quality !!!� ����� <= vbOperDate!!!
          , tmpMovementQualityParams_list AS (SELECT tmpQuality.QualityId, Movement.Id AS MovementId, Movement.OperDate
                                              FROM tmpQuality
                                                   INNER JOIN MovementLinkObject AS MLO_Quality
                                                                                 ON MLO_Quality.ObjectId = tmpQuality.QualityId
                                                                                AND MLO_Quality.DescId = zc_MovementLinkObject_Quality()
                                                   INNER JOIN Movement ON Movement.Id = MLO_Quality.MovementId
                                                                      AND Movement.DescId = zc_Movement_QualityParams()
                                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                      AND Movement.OperDate <= vbOperDate
                                             )
            -- ��� ������� Quality ������� � MAX (OperDate) !!!��� � ����� ���������!!!, ������ � ���� ���-��� � ������ ���� �������� inMovementId_Sale
          , tmpMovementQualityParams_max AS (SELECT tmp.QualityId, MAX (tmpMovementQualityParams_list.MovementId) AS MovementId
                                             FROM (SELECT tmpMovementQualityParams_list.QualityId, MAX (tmpMovementQualityParams_list.OperDate) AS OperDate FROM tmpMovementQualityParams_list GROUP BY tmpMovementQualityParams_list.QualityId) AS tmp
                                                  INNER JOIN tmpMovementQualityParams_list ON tmpMovementQualityParams_list.QualityId = tmp.QualityId
                                                                                          AND tmpMovementQualityParams_list.OperDate = tmp.OperDate
                                             GROUP BY tmp.QualityId
                                            )
            -- �������� inMovementId_Sale ����������� �� !!!���!!! ������������ MovementId + MovementId_master
          , tmpMovementQualityDoc AS (SELECT MovementLinkMovement_Child.MovementId       AS MovementId
                                           , MovementLinkMovement_Master.MovementChildId AS MovementId_master
                                      FROM Movement
                                           LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                                          ON MovementLinkMovement_Child.MovementChildId = Movement.Id 
                                                                         AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                                           LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                                          ON MovementLinkMovement_Master.MovementId = MovementLinkMovement_Child.MovementId
                                                                         AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                                           LEFT JOIN Movement AS Movement_QualityDoc ON Movement_QualityDoc.Id = MovementLinkMovement_Child.MovementId
                                      WHERE Movement.Id = inMovementId_Sale
                                     )
     -- �������� "��������" ������ 
     INSERT INTO _tmpMovement_QualityDoc (MovementId)
        SELECT CASE WHEN tmpResult.MovementId_master <> 0
                         THEN lpInsertUpdate_Movement_QualityDoc (ioId               := tmpResult.MovementId
                                                                , inMovementId_master:= tmpResult.MovementId_master
                                                                , inMovementId_child := inMovementId_Sale
                                                                , inOperDateIn       := inOperDateIn
                                                                , inOperDateOut      := inOperDateOut
                                                                , inCarId            := inCarId
                                                                , inUserId           := vbUserId
                                                                 )
                    WHEN tmpResult.MovementId <> 0
                         THEN lpSetErased_Movement_QualityDoc (inMovementId := tmpResult.MovementId
                                                             , inUserId     := vbUserId
                                                              )
                    ELSE 0
               END
        FROM (SELECT COALESCE (tmpMovementQualityDoc.MovementId, 0)        AS MovementId         -- ���� �� ��� ������� MovementId �� ����� ���������, ����� ��� Update or Delete
                   , COALESCE (tmpMovementQualityParams_max.MovementId, 0) AS MovementId_master  -- ���� 0 �� ��������� ��� �� ���� ��� ���� �������
               FROM tmpMovementQualityDoc
                    FULL JOIN tmpMovementQualityParams_max ON tmpMovementQualityParams_max.MovementId = tmpMovementQualityDoc.MovementId_master
             ) AS tmpResult
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_QualityDoc (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')

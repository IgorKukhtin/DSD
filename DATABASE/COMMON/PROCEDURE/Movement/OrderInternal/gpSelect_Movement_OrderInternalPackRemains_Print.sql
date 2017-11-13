-- Function: gpSelect_Movement_OrderInternalPackRemains_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id             Integer
             , GoodsId        Integer
             , GoodsCode      Integer
             , GoodsName      TVarChar
  
             , GoodsId_basis   Integer
             , GoodsCode_basis Integer
             , GoodsName_basis TVarChar
  
             , GoodsKindId       Integer
             , GoodsKindName     TVarChar
             , MeasureName       TVarChar
             , MeasureName_basis TVarChar
  
             , GoodsGroupNameFull TVarChar
  
             , Amount            TFloat
             , AmountSecond      TFloat
             , AmountTotal       TFloat
             , Num               Integer
             , Income_CEH        TFloat
             , Income_PACK_to    TFloat
             , Income_PACK_from  TFloat
             
             , GoodsCode_Child         Integer
             , GoodsName_Child         TVarChar
             , GoodsKindName_Child     TVarChar
             , MeasureName_Child       TVarChar
             , AmountPack_Child        TFloat
             , AmountPackSecond_Child  TFloat
             , AmountPackTotal_Child   TFloat
             , Income_PACK_to_Child    TFloat
             , Income_PACK_from_Child  TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �� ���������
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
      INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- ����� ������ ��������
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5 -- !!!����� ������!!!
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- ��� ��� �������� ������
         RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;
     
      -- ���������  _Result_Master, _Result_Child, _Result_ChildTotal
      PERFORM lpSelect_MI_OrderInternalPackRemains (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inUserId:= vbUserId) ;

          RETURN QUERY
           SELECT _Result_Master.Id, _Result_Master.GoodsId, _Result_Master.GoodsCode, _Result_Master.GoodsName   
                , _Result_Master.GoodsId_basis, _Result_Master.GoodsCode_basis, _Result_Master.GoodsName_basis
                , _Result_Master.GoodsKindId, _Result_Master.GoodsKindName
                , _Result_Master.MeasureName, _Result_Master.MeasureName_basis
                , _Result_Master.GoodsGroupNameFull
                , _Result_Master.Amount
                , _Result_Master.AmountSecond
                , _Result_Master.AmountTotal
                , _Result_Master.Num
                , _Result_Master.Income_CEH
                , _Result_Master.Income_PACK_to
                , _Result_Master.Income_PACK_from
                
                , _Result_Child.GoodsCode         AS GoodsCode_Child
                , _Result_Child.GoodsName         AS GoodsName_Child
                , _Result_Child.GoodsKindName     AS GoodsKindName_Child
                , _Result_Child.MeasureName       AS MeasureName_Child
                , _Result_Child.AmountPack        AS AmountPack_Child
                , _Result_Child.AmountPackSecond  AS AmountPackSecond_Child
                , _Result_Child.AmountPackTotal   AS AmountPackTotal_Child
                , _Result_Child.Income_PACK_to    AS Income_PACK_to_Child
                , _Result_Child.Income_PACK_from  AS Income_PACK_from_Child
                
           FROM _Result_Master
              LEFT JOIN _Result_Child ON _Result_Child.KeyId = _Result_Master.KeyId
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_OrderInternalPackRemains_Print (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.06.15                                        *
*/

-- ����
--
-- SELECT * FROM gpSelect_Movement_OrderInternalPackRemains_Print (inMovementId := 7463854, inSession:= zfCalc_UserAdmin())

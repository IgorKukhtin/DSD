-- Function: gpSelect_Movement_OrderReturnTare_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderReturnTare_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderReturnTare_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderReturnTare());
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


     --
     OPEN Cursor1 FOR
      SELECT Movement.Id                      AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber               AS InvNumber
           , Movement.OperDate                AS OperDate
           , Movement_Transport.Id            AS MovementId_Transport
           , Movement_Transport.InvNumber     AS InvNumber_Transport
           , Movement_Transport.OperDate      AS OperDate_Transport
           --, ('� ' || Movement_Transport.InvNumber || ' �� ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full
           , zfCalc_PartionMovementName (Movement_Transport.DescId, MovementDesc.ItemName, Movement_Transport.InvNumber, Movement_Transport.OperDate) AS InvNumber_Transport_Full
           
           , Object_Car.ValueData             AS CarName
           , Object_CarModel.ValueData        AS CarModelName
           , View_PersonalDriver.PersonalName AS PersonalDriverName
       FROM Movement
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Transport.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderReturnTare()
      ;
    RETURN NEXT Cursor1;
    
    OPEN Cursor2 FOR
        SELECT
             Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData           AS MeasureName

           , MovementItem.Amount     :: TFloat  AS Amount

           , Object_Partner.Id        	        AS PartnerId
           , Object_Partner.ObjectCode          AS PartnerCode
           , Object_Partner.ValueData 	        AS PartnerName


        FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased = FALSE
       ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.01.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_OrderReturnTare_Print (inMovementId := 388160, inSession:= zfCalc_UserAdmin())
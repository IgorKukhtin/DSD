-- ������

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Product (Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Product(
    IN inObjectId Integer,
    IN inIsErased Boolean, 
    IN inSession  TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_Product());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inIsErased:=inIsErased, inUserId:= vbUserId);
   
   --
   IF inIsErased = TRUE
   THEN
       -- ������� ��������
       PERFORM lpSetErased_Movement (inMovementId := MLO.MovementId
                                   , inUserId     := vbUserId
                                    )
       FROM MovementLinkObject AS MLO
       WHERE MLO.ObjectId = inObjectId
         AND MLO.DescId = zc_MovementLinkObject_Product()
        ;

   ELSEIF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO JOIN Movement ON Movement.Id = MLO.MovementId AND Movement.StatusId = zc_Enum_Status_Erased() WHERE MLO.ObjectId = inObjectId AND MLO.DescId = zc_MovementLinkObject_Product())
   THEN
       -- ������������ ��������
       PERFORM lpUnComplete_Movement (inMovementId := MLO.MovementId
                                    , inUserId     := vbUserId
                                     )
       FROM MovementLinkObject AS MLO
       WHERE MLO.ObjectId = inObjectId
         AND MLO.DescId = zc_MovementLinkObject_Product()
        ;
   END IF;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         *
*/

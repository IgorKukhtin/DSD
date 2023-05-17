-- Function: gpGet_Movement_SalePromoGoods()

DROP FUNCTION IF EXISTS gpGet_Movement_SalePromoGoods (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SalePromoGoods(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber     TVarChar
             , OperDate      TDateTime
             , StatusCode    Integer
             , StatusName    TVarChar
             , RetailId      Integer
             , RetailName    TVarChar
             , StartPromo    TDateTime
             , EndPromo      TDateTime
             , InsertId      Integer
             , InsertName    TVarChar
             , InsertDate    TDateTime
             , UpdateId      Integer
             , UpdateName    TVarChar
             , UpdateDate    TDateTime
             , Comment       TVarChar
             , isAmountCheck Boolean
             , AmountCheck   TFloat
             , isDiscountInformation Boolean 
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());
    vbUserId := inSession;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                           AS Id
          , CAST (NEXTVAL ('movement_SalePromoGoods_seq') AS TVarChar) AS InvNumber
          , inOperDate		            AS OperDate
          , Object_Status.Code          AS StatusCode
          , Object_Status.Name          AS StatusName
          , NULL  ::Integer             AS RetailId
          , NULL  ::TVarChar            AS RetailName
          , Null  :: TDateTime          AS StartPromo
          , Null  :: TDateTime          AS EndPromo
          , NULL  ::Integer             AS InsertId
          , Object_Insert.ValueData     AS InsertName
          , CURRENT_TIMESTAMP :: TDateTime AS InsertDate
          , NULL  ::Integer             AS UpdateId
          , NULL  ::TVarChar            AS UpdateName
          , Null  :: TDateTime          AS UpdateDate
          , NULL  ::TVarChar            AS Comment
          , False :: Boolean            AS isAmountCheck
          , 0 :: TFloat                 AS AmountCheck
          , False :: Boolean            AS isDiscountInformation
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
  
   ELSE
 
  RETURN QUERY
     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , Object_Retail.Id                                               AS RetailId
          , Object_Retail.ValueData                                        AS RetailName
          , MovementDate_StartPromo.ValueData                              AS StartPromo
          , MovementDate_EndPromo.ValueData                                AS EndPromo
          , Object_Insert.Id                                               AS InsertId
          , Object_Insert.ValueData                                        AS InsertName
          , MovementDate_Insert.ValueData                                  AS InsertDate
          , Object_Update.Id                                               AS UpdateId
          , Object_Update.ValueData                                        AS UpdateName
          , MovementDate_Update.ValueData                                  AS UpdateDate
          , MovementString_Comment.ValueData                               AS Comment
          , COALESCE (MovementBoolean_AmountCheck.ValueData, False)        AS isAmountCheck
          , MovementFloat_AmountCheck.ValueData                            AS AmountCheck
          , COALESCE(MovementBoolean_DiscountInformation.ValueData, False) AS isDiscountInformation
     FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementBoolean AS MovementBoolean_AmountCheck
                                  ON MovementBoolean_AmountCheck.MovementId = Movement.Id
                                 AND MovementBoolean_AmountCheck.DescId = zc_MovementBoolean_AmountCheck()
        LEFT JOIN MovementBoolean AS MovementBoolean_DiscountInformation
                                  ON MovementBoolean_DiscountInformation.MovementId = Movement.Id
                                 AND MovementBoolean_DiscountInformation.DescId = zc_MovementBoolean_DiscountInformation()

        LEFT JOIN MovementFloat AS MovementFloat_AmountCheck
                                ON MovementFloat_AmountCheck.MovementId = Movement.Id
                               AND MovementFloat_AmountCheck.DescId = zc_MovementFloat_AmountCheck()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
                              
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId 

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                     ON MovementLinkObject_Update.MovementId = Movement.Id
                                    AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId  

     WHERE Movement.Id =  inMovementId;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.09.22                                                       *
*/

--���� 
--select * from gpGet_Movement_SalePromoGoods(inMovementId := 0 , inOperDate := ('13.03.2016')::TDateTime ,  inSession := '3');
--select * from gpGet_Movement_SalePromoGoods(inMovementId := 16406918 , inOperDate := ('24.04.2016')::TDateTime ,  inSession := '3');

select * from gpGet_Movement_SalePromoGoods(inMovementId := 0 , inOperDate := ('25.11.2022')::TDateTime ,  inSession := '3');
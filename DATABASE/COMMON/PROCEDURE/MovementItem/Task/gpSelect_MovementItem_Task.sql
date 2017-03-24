-- Function: gpSelect_MovementItem_Task()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Task (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Task(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , Description TVarChar
             , Comment TVarChar
             , UpdateMobileDate TDateTime
             , isClose Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Task());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
       SELECT
             MovementItem.Id                      AS Id
           , Object_Partner.Id                    AS PartnerId
           , Object_Partner.ObjectCode            AS PartnerCode
           , Object_Partner.ValueData             AS PartnerName
           , MIString_Description.ValueData       AS Description
           , MIString_Comment.ValueData           AS Comment
           , MIDate_UpdateMobile.ValueData        AS UpdateMobileDate

           , MIBoolean_Close.ValueData            AS isClose
           , MovementItem.isErased                AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementItem.ObjectId
           
            LEFT JOIN MovementItemDate AS MIDate_UpdateMobile
                                       ON MIDate_UpdateMobile.MovementItemId = MovementItem.Id
                                      AND MIDate_UpdateMobile.DescId = zc_MIDate_UpdateMobile()

            LEFT JOIN MovementItemString AS MIString_Description
                                         ON MIString_Description.MovementItemId = MovementItem.Id
                                        AND MIString_Description.DescId = zc_MIString_Description()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                          ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Close.DescId = zc_MIBoolean_Close()
         ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.03.17         *
*/

-- ����
-- 